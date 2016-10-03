(setq od (namedobjdict))
(entget od)


(setq liod (mapcar 'cdr (vl-remove-if-not '(lambda (x) (or (= (car x) 3) (= (car x) 350))) (entget od))))







;vla-getxdata
(setq spt (car (entsel)))
(setq to (vlax-ename->vla-object spt))
(vlax-dump-object to T)

;;;regapp

(vla-GetXData to  nil   'XDataType  'XDataValue)
(vla-GetXData to  "mcsDbObjectTable"   'XDataType  'XDataValue)

(vlax-safearray->list XDataType)
;;;    (1001   1000  1040)
(setq temp   (vlax-safearray->list XDataValue))
;;;   (#<vanant  8 TestApp>  fl<variant  8 Description  (Kvariant  5  12.34>)
(mapcar  'vlax-variant-value  temp)
;;;    rTestApp"   "Description"   12.34}