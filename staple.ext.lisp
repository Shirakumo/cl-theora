(defmethod staple:packages ((system (eql (asdf:find-system :cl-theora))))
  (list (find-package 'org.shirakumo.fraf.theora)
        (find-package 'org.shirakumo.fraf.theora.cffi)))
