






(vl-load-com)

(setq #cad (vlax-get-acad-object))

(setq uzfolder "d:\\12341241324\\100ÏÝÎ\\")

;(setq files (VL-DIRECTORY-FILES uzfolder "*.dwg" 1))
(setq files (VL-DIRECTORY-FILES uzfolder "*.dxf" 1))

(foreach file files
  (setq fullname (strcat uzfolder file))
  (setq docs (vla-get-Documents #cad))
  (setq $doc (vla-open docs fullname))
  (vla-put-LineweightDisplay (vla-get-Preferences $doc) :vlax-true)
  (vla-saveas $doc fullname ac2004_dwg)
  (vla-close $doc)
  )



