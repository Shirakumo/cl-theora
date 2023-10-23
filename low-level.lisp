(in-package #:org.shirakumo.fraf.theora.cffi)

(defvar *here* #.(or *compile-file-pathname* *load-pathname* *default-pathname-defaults*))
(defvar *static* (make-pathname :name NIL :type NIL :defaults (merge-pathnames "static/" *here*)))
(pushnew *static* cffi:*foreign-library-directories*)

(cffi:define-foreign-library libtheorafile
    (:darwin (:or #+X86 "libtheorafile-mac-i686.dylib"
                  #+X86-64 "libtheorafile-mac-amd64.dylib"
                  #+ARM64 "libtheorafile-mac-arm64.dylib"))
  (:unix (:or #+X86 "libtheorafile-lin-i686.so"
              #+X86-64 "libtheorafile-lin-amd64.so"))
  (:windows (:or #+X86 "libtheorafile-win-i686.dll"
                 #+X86-64 "libtheorafile-win-amd64.dll"))
  (T (:or (:default "libtheorafile") (:default "theorafile"))))

(cffi:defcenum error
  (:ok 0)
  (:unknown -1)
  (:unsupported -2)
  (:no-data-source -3))

(cffi:defcenum pixel-format
  :420
  :reserved
  :422
  :444)

(cffi:defcenum seek
  (:set 0)
  (:current 1)
  (:from-end 2))

(cffi:defcstruct (callbacks :conc-name callbacks-)
  (read-func :pointer)
  (seek-func :pointer)
  (close-func :pointer))

(cffi:defcstruct (page :conc-name page-)
  (header :pointer)
  (header-length :long)
  (body :pointer)
  (body-length :long))

(cffi:defcstruct (sync-state :conc-name sync-state-)
  (data :pointer)
  (storage :int)
  (fill :int)
  (returned :int)
  (unsynced :int)
  (header-bytes :int)
  (body-bytes :int))

(cffi:defcstruct (dsp-state :conc-name dsp-state-)
  (analysis-p :int)
  (info :pointer)
  (pcm :pointer)
  (pcm-ret :pointer)
  (pcm-storage :int)
  (pcm-current :int)
  (pcm-returned :int)
  (pre-extrapolate :int)
  (eof-flag :int)
  (lw :long)
  (w :long)
  (nw :long)
  (center-w :long)
  (granule-pos :int64)
  (sequence :int64)
  (glue-bits :int64)
  (time-bits :int64)
  (floor-bits :int64)
  (res-bits :int64)
  (backend-state :pointer))

(cffi:defcstruct (pack-buffer :conc-name pack-buffer-)
  (end-byte :long)
  (end-bit :int)
  (buffer :pointer)
  (ptr :pointer)
  (storage :long))

(cffi:defcstruct (vorbis-block :conc-name vorbis-block-)
  (pcm :pointer)
  (buffer (:struct pack-buffer))
  (lw :long)
  (w :long)
  (nw :long)
  (pcm-end :int)
  (mode :int)
  (eof-flag :int)
  (granule-pos :int64)
  (sequence :int64)
  (dsp-state :pointer)
  (local-store :pointer)
  (local-top :long)
  (local-alloc :long)
  (total-use :long)
  (reap :pointer)
  (glue-bits :long)
  (time-bits :long)
  (floor-bits :long)
  (res-bits :long)
  (internal :pointer))

(cffi:defcstruct (file :conc-name file-)
  (sync-state (:struct sync-state))
  (page (:struct page))
  (eos :int)
  (t-packets :int)
  (v-packets :int)
  (t-stream :pointer)
  (v-stream :pointer)
  (t-info :pointer)
  (v-info :pointer)
  (t-comment :pointer)
  (v-comment :pointer)
  (v-tracks :int)
  (v-track :int)
  (t-tracks :int)
  (t-track :int)
  (t-dec :pointer)
  (v-dsp-init :int)
  (v-dsp (:struct dsp-state))
  (v-block-init :int)
  (v-block (:struct vorbis-block))
  (callbacks (:struct callbacks))
  (data-source :pointer))

(cffi:defcfun ("tf_open_callbacks2" open-callbacks) error
  (data-source :pointer)
  (file :pointer)
  (callbacks :pointer))

(cffi:defcfun ("tf_fopen" open) error
  (path :string)
  (file :pointer))

(cffi:defcfun ("tf_close" close) :void
  (file :pointer))

(cffi:defcfun ("tf_hasvideo" has-video) :boolean
  (file :pointer))

(cffi:defcfun ("tf_hasaudio" has-audio) :boolean
  (file :pointer))

(cffi:defcfun ("tf_videoinfo" video-info) :void
  (file :pointer)
  (width :pointer)
  (height :pointer)
  (fps :pointer)
  (pixel-format :pointer))

(cffi:defcfun ("tf_audioinfo" audio-info) :void
  (file :pointer)
  (channels :pointer)
  (samplerate :pointer))

(cffi:defcfun ("tf_eos" eos) :boolean
  (file :pointer))

(cffi:defcfun ("tf_reset" reset) :void
  (file :pointer))

(cffi:defcfun ("tf_readvideo" read-video) :int
  (file :pointer)
  (buffer :pointer)
  (frames :int))

(cffi:defcfun ("tf_readaudio" read-audio) :int
  (file :pointer)
  (buffer :pointer)
  (samples :int))

(cffi:defcfun ("tf_setaudiotrack" set-audio-track) :boolean
  (file :pointer)
  (track :int))

(cffi:defcfun ("tf_setvideotrack" set-video-track) :boolean
  (file :pointer)
  (track :int))
