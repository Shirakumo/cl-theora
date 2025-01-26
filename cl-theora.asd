(asdf:defsystem cl-theora
  :version "1.0.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "A decoder library for the OGG/Theora video format via the theorafile C library"
  :homepage "https://shirakumo.github.io/cl-theora/"
  :bug-tracker "https://github.com/shirakumo/cl-theora/issues"
  :source-control (:git "https://github.com/shirakumo/cl-theora.git")
  :serial T
  :components ((:file "package")
               (:file "low-level")
               (:file "wrapper")
               (:file "documentation"))
  :depends-on (:documentation-utils
               :pathname-utils
               :memory-regions/region
               :cffi))
