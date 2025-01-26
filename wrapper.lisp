(in-package #:org.shirakumo.fraf.theora)

;;;; callback support structures
;;; For pointers/memory regions we keep a bespoke struct to track all data.
;;; For vectors we keep a single index variable in C, which also serves to
;;; resolve the Lisp vector object through a global table

(cffi:defcstruct (memory-stream :conc-name memory-stream-)
  (index :ssize)
  (size :size)
  (data :pointer))

(cffi:defcallback read-memory-stream :size ((buffer :pointer) (size :size) (nmemb :size) (data-source :pointer))
  (let* ((off (memory-stream-index data-source))
         (bytes (max 0 (min (* nmemb size) (- (memory-stream-size data-source) off)))))
    (cffi:foreign-funcall "memcpy" :pointer buffer :pointer (cffi:inc-pointer (memory-stream-data data-source) off) :size bytes)
    (setf (memory-stream-index data-source) (+ off bytes))
    bytes))

(cffi:defcallback seek-memory-stream :int ((data-source :pointer) (offset :int64) (seek theora:seek))
  (let ((position (ecase seek
                    (:set offset)
                    (:current (+ (memory-stream-index data-source) offset))
                    (:from-end (- (memory-stream-size data-source) offset)))))
    (cond ((<= 0 position (memory-stream-size data-source))
           (setf (memory-stream-index data-source) position)
           0)
          (T
           -1))))

(cffi:defcallback close-memory-stream :int ((data-source :pointer))
  (cffi:foreign-free data-source)
  0)

(defvar *object-table* (make-hash-table :test 'eql))

(defun pointer-object (ptr &optional (errorp T))
  (or (gethash (cffi:pointer-address ptr) *object-table*)
      (when errorp (error "No object associated with ~a" ptr))))

(defun (setf pointer-object) (value ptr)
  (if value
      (setf (gethash (cffi:pointer-address ptr) *object-table*) value)
      (remhash (cffi:pointer-address ptr) *object-table*))
  value)

(cffi:defcallback read-vector-stream :size ((buffer :pointer) (size :size) (nmemb :size) (data-source :pointer))
  (let* ((off (cffi:mem-ref data-source :ssize))
         (vec (pointer-object data-source))
         (bytes (max 0 (min (* nmemb size) (- (length vec) off)))))
    (cffi:with-pointer-to-vector-data (ptr vec)
      (cffi:foreign-funcall "memcpy" :pointer buffer :pointer (cffi:inc-pointer ptr off) :size bytes))
    (setf (cffi:mem-ref data-source :ssize) (+ off bytes))
    bytes))

(cffi:defcallback seek-vector-stream :int ((data-source :pointer) (offset :int64) (seek theora:seek))
  (let ((position (ecase seek
                    (:set offset)
                    (:current (+ (cffi:mem-ref data-source :ssize) offset))
                    (:from-end (- (length (pointer-object data-source)) offset)))))
    (cond ((<= 0 position (memory-stream-size data-source))
           (setf (cffi:mem-ref data-source :ssize) position)
           0)
          (T
           -1))))

(cffi:defcallback close-vector-stream :int ((data-source :pointer))
  (cond ((pointer-object data-source NIL)
         (cffi:foreign-free data-source)
         (setf (pointer-object data-source) NIL)
         0)
        (T
         -1)))

;;;; Actual library definitions

(define-condition theora-error (error)
  ((file :initarg :file :reader file)
   (code :initarg :code :reader code))
  (:report (lambda (c s) (format s "Failure in file ~a: ~a"
                                 (file c) (code c)))))

(defun init ()
  (unless (cffi:foreign-library-loaded-p 'theora:libtheorafile)
    (cffi:load-foreign-library 'theora:libtheorafile)))

(defclass file ()
  ((handle :initform NIL :reader handle)
   (width :initform NIL :reader width)
   (height :initform NIL :reader height)
   (framerate :initform NIL :reader framerate)
   (pixel-format :initform NIL :reader pixel-format)
   (channels :initform NIL :reader channels)
   (samplerate :initform NIL :reader samplerate)
   (audio-track :initform NIL :accessor audio-track)
   (video-track :initform NIL :accessor video-track)))

(defmethod initialize-instance :after ((file file) &key source)
  (init)
  (let ((handle (cffi:foreign-alloc '(:struct theora:file))))
    (unwind-protect
         (progn
           (%open source handle)
           (when (theora:has-video handle)
             (cffi:with-foreign-objects ((width :int)
                                         (height :int)
                                         (framerate :double)
                                         (pixel-format 'theora:pixel-format))
               (theora:video-info handle width height framerate pixel-format)
               (setf (slot-value file 'width) (cffi:mem-ref width :int))
               (setf (slot-value file 'height) (cffi:mem-ref height :int))
               (setf (slot-value file 'framerate) (cffi:mem-ref framerate :double))
               (setf (slot-value file 'pixel-format) (cffi:mem-ref pixel-format 'theora:pixel-format))
               (setf (slot-value file 'video-track) 0)))
           (when (theora:has-audio handle)
             (cffi:with-foreign-objects ((channels :int)
                                         (samplerate :int))
               (theora:audio-info handle channels samplerate)
               (setf (slot-value file 'channels) (cffi:mem-ref channels :int))
               (setf (slot-value file 'samplerate) (cffi:mem-ref samplerate :int))
               (setf (slot-value file 'audio-track) 0)))
           (setf (slot-value file 'handle) handle))
      (unless (handle file)
        (cffi:foreign-free handle)))))

(defmethod free ((file file))
  (when (handle file)
    (theora:close (handle file))
    (setf (slot-value file 'handle) NIL)))

(defmacro check-open (file code &body cleanup)
  `(let ((code ,code))
     (unless (eq :ok code)
       ,@cleanup
       (error 'theora-error :file ,file :code code))))

(defun open (source)
  (make-instance 'file :source source))

(defmethod %open ((source pathname) handle)
  (check-open source (theora:open (pathname-utils:native-namestring source) handle)))

(defmethod %open ((source string) handle)
  (check-open source (theora:open source handle)))

(defmethod %open ((source mem:memory-region) handle)
  (let ((stream (cffi:foreign-alloc '(:struct memory-stream))))
    (setf (memory-stream-index stream) 0)
    (setf (memory-stream-size stream) (mem:memory-region-size source))
    (setf (memory-stream-data stream) (mem:memory-region-pointer source))
    (cffi:with-foreign-objects ((cb '(:struct theora:callbacks)))
      (setf (theora:callbacks-read-func cb) (cffi:callback read-memory-stream))
      (setf (theora:callbacks-seek-func cb) (cffi:callback seek-memory-stream))
      (setf (theora:callbacks-close-func cb) (cffi:callback close-memory-stream))
      (check-open source (theora:open-callbacks stream handle cb)
        (cffi:foreign-free stream)))))

(defmethod %open ((source vector) handle)
  (let ((index (cffi:foreign-alloc :ssize)))
    (setf (cffi:mem-ref index :ssize) 0)
    (cffi:with-foreign-objects ((cb '(:struct theora:callbacks)))
      (setf (theora:callbacks-read-func cb) (cffi:callback read-vector-stream))
      (setf (theora:callbacks-seek-func cb) (cffi:callback seek-vector-stream))
      (setf (theora:callbacks-close-func cb) (cffi:callback close-vector-stream))
      (check-open source (theora:open-callbacks index handle cb)
        (cffi:foreign-free index)))))

(defmethod (setf video-track) :before (track (file file))
  (unless (theora:set-video-track (handle file) track)
    (error 'theora-error :file file :code :no-such-track)))

(defmethod (setf audio-track) :before (track (file file))
  (unless (theora:set-audio-track (handle file) track)
    (error 'theora-error :file file :code :no-such-track)))

(defmethod reset ((file file))
  (theora:reset (handle file)))

(defmethod done-p ((file file))
  (theora:eos (handle file)))

(defmethod read-video ((buffer mem:memory-region) (file file))
  (theora:read-video (handle file)
                     (mem:memory-region-pointer buffer)
                     1))

(defmethod read-video (buffer (file file))3
  (mem:with-memory-region (mem buffer)
    (read-video mem file)))

(defmethod read-audio ((buffer mem:memory-region) (file file) &optional samples)
  (theora:read-audio (handle file)
                     (mem:memory-region-pointer buffer)
                     (min (or samples most-positive-fixnum)
                          (truncate (mem:memory-region-size buffer) 4))))

(defmethod read-audio (buffer (file file) &optional samples)
  (mem:with-memory-region (mem buffer)
    (read-audio mem file samples)))
