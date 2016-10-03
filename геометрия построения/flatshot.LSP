


(setq lst (ss->list* (ssget "_X")))
(length lst)
(setq
  res
   (vl-remove-if
     '(lambda (e)	;(setq e (nth 113 lst))
	(or
	  (> (abs (last (assoc 10 (entget e)))) 0)
	  (> (abs (last (assoc 11 (entget e)))) 0)
	  )
	
	)
     lst)
  )
(length res)
(sssetfirst nil (lst-to-ss res))




(setq ss (ss->lsto* (ssget "_I")))


(setq lst (ss->lsto* (ssget "_X")))


(setq names (mapcar
  'vla-get-objectname
  lst))
(setq namesUnq (origlist names))
(length namesUnq)


(setq
  res
   (vl-remove-if
     '(lambda (obj)
	(cond
	  ()
	  )
	)
     lst)
  )

("AcDbBlockReference"
  "AcDbLine"
  "AcDbText"
  "AcDbMText"
  "AcDbPolyline"
  "AcDbEllipse"
  "AcDbHatch"
  "AcDbCircle"
  "AcDbArc"
  "AcDbPoint"
  "AcDbMLeader"
  "AcDbRotatedDimension"
  "AcDbSpline"
  "AcDbSolid"
  "AcDbViewport"
  ) 




(setq ss (ss->lsto* (ssget "_X" '((0 . "LINE")))))

(mapcar
  '(lambda (x / p)
     (setq p (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint x))))
     (setq p (reverse (cons 0 (cdr (reverse p)))))
     (vla-put-startpoint x (vlax-3d-point p))

     (setq p (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint x))))
     (setq p (reverse (cons 0 (cdr (reverse p)))))
     (vla-put-Endpoint x (vlax-3d-point p))
     
     )
  ss)



(setq ss (ss->lsto* (ssget "_X" '((0 . "TEXT")))))

(mapcar
  '(lambda (x / p)
     (setq p (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint x))))
     (setq p (reverse (cons 0 (cdr (reverse p)))))
     (vla-put-InsertionPoint x (vlax-3d-point p))

     (setq p (vlax-safearray->list (vlax-variant-value (vla-get-TextAlignmentPoint x))))
     (setq p (reverse (cons 0 (cdr (reverse p)))))
     (vla-put-TextAlignmentPoint x (vlax-3d-point p))
     
     )
  ss)


(setq ss (ss->lsto* (ssget "_X" '((0 . "CIRCLE,ARC")))))
(mapcar
  '(lambda (x / p)
     (setq p (vlax-safearray->list (vlax-variant-value (vla-get-Center x))))
     (setq p (reverse (cons 0 (cdr (reverse p)))))
     (vla-put-Center x (vlax-3d-point p))
     )
  ss)