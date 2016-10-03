(vl-load-com)
(vlax-dump-object (vlax-ename->vla-object (car (entsel))) T)
(vlax-dump-object (vlax-ename->vla-object (car (entsel))) T)
(vlax-dump-object (vla-get-activedocument (vlax-get-acad-object)))
(vla-get-color (vlax-ename->vla-object (car (entsel))))
(vla-put-color (vlax-ename->vla-object (car (entsel))) 3)

(vla-get-hyperlinks (vlax-ename->vla-object (car (entsel))))

(vla-put-textstring (vlax-ename->vla-object (car (entsel))) "asdf")

(setq vlo1 (vlax-ename->vla-object (car (entsel))))


(vla-ResetBlock (vlax-ename->vla-object (car (entsel))))
(vla-GetAttributes (vlax-ename->vla-object (car (entsel))))
(vla-GetXData (vlax-ename->vla-object (car (entsel))))
(setq va1 (vlax-make-variant (vlax-3d-point '(1.1 1.1 1.1))))
(vla-put-startpoint (vlax-ename->vla-object (car (entsel))) va1)
(vla-TransformBy (vlax-ename->vla-object (car (entsel))) "Âèäèìîñòü")

(setq pt (vlax-3d-point '(1.1 1.1 1.1)))
(setq ax_cirlce (vla-addcircle model_space pt 100.0))




;;; rotate
(vla-Rotate (vlax-ename->vla-object (car (entsel)))
  (vlax-3d-point (getpoint))
  90)


(vla-Highlight (vlax-ename->vla-object (car (entsel)))T)


(vla-GetDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))
(vlax-variant-value (vla-GetDynamicBlockProperties (vlax-ename->vla-object (car (entsel)))))
(vlax-safearray->list (vlax-variant-value (vla-GetDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))))
(vlax-safearray->list (vlax-variant-value v))
(vla-Update (vlax-ename->vla-object (car (entsel))))


(vlax-invoke (vlax-ename->vla-object (car (entsel))) 'FieldCode)






(setq actdoc (vla-get-activedocument (vlax-get-acad-object)))
(vlax-dump-object (vla-item (vla-get-blocks actdoc) "êëåììêà"))
(vlax-dump-object (vla-item (vla-item (vla-get-blocks actdoc) "êëåììêà") 2))
(vla-get-ObjectID (vla-item (vla-item (vla-get-blocks actdoc) "êëåììêà") 2))
(vla-SetBlockAttributeValue obj 1 3 (vla-get-ObjectID (vla-item (vla-item (vla-get-blocks actdoc) "êëåììêà") 2)) "206-A62")




(vla-update (vlax-ename->vla-object (car (entsel))))






(setq temp  (vla-get-ActiveSelectionSet actdoc))
;;;   fKVLA-OBJECT IAcadSelectionSet 0c4c0f64>
(vla-Clear temp)
(vla-SelectOnScreen temp)
(vla-Wblock actdoc "D:/Temp/export.dwg" temp)




(setq ac (vlax-get-acad-object))
(vlax-dump-object ac T)
(setq v (vla-listarx ac))
(vlax-safearray->list (vlax-variant-value v))
(setq obj   (vlax-ename->vla-object   (car  (entsel))))
;;;   IKVLA-OBJECT lAcadLine 0b858eb4>
(vla-GetXData obj  "mcsloader"   'XDataType  'XDataValue)
(vlax-safearray->list XDataType)
;;;    (1001   1000   1040)
(setq temp  (vlax-safearray->list XDataValue))
;;;   {IKvariant 8 TestApp> («variant 8 Description fi<variant 5 12.34>)
(mapcar 'vlax-variant-value temp)
;;;   i"TestApp"  "Description"  12.34)


mcsloader