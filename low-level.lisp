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
