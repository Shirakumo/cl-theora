(asdf:defsystem cl-theora
  :version "1.0.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "A decoder library for the OGG/Theora video format via the theorafile C library"
  :homepage "https://shirakumo.org/docs/cl-theora/"
  :bug-tracker "https://shirakumo.org/project/cl-theora/issues"
  :source-control (:git "https://shirakumo.org/project/cl-theora.git")
  :serial T
  :components ((:file "package")
               (:file "low-level")
               (:file "wrapper")
               (:file "documentation"))
  :depends-on (:documentation-utils
               :pathname-utils
               :memory-regions/region
               :cffi))
