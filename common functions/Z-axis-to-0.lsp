
(progn
  (setq lst (ss->lsto* (ssget "_X")))
  (princ)
  )


(origlist
(mapcar
  '(lambda (obj)
     (vla-get-objectname obj)
     )
  lst))


(mapcar
  '(lambda (obj / p1 p2)	;(setq obj (vlax-ename->vla-object (car (entsel))))
     (cond

       ((member (vla-get-objectname obj) '("AcDbLine"))
	;(vlax-property-available-p obj "StartPoint")
	(setq p1 (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint obj))))
	(setq p2 (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint obj))))
	(vla-put-StartPoint obj (vlax-3d-point (list (car p1) (cadr p1) 0)))
	(vla-put-EndPoint obj (vlax-3d-point (list (car p2) (cadr p2) 0)))
	)
       ((member (vla-get-objectname obj) '("AcDbBlockReference" "AcDbText" "AcDbMText" "AcDbAttributeDefinition"))
	;(vlax-property-available-p obj "InsertionPoint")
	(setq p1 (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
	(vla-put-InsertionPoint obj (vlax-3d-point (list (car p1) (cadr p1) 0)))
	)
       (T (princ))
       )
     )
  lst)