(defpackage #:org.shirakumo.fraf.theora.cffi
  (:use #:cl)
  (:export))

(defpackage #:org.shirakumo.fraf.theora
  (:use #:cl)
  (:local-nicknames
   (#:theora #:org.shirakumo.fraf.theora.cffi))
  (:export))
