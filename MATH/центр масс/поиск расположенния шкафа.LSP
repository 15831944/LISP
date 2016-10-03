
(load (strcat #lisppath "DataBase\\dblib.lsp"))


(setq koeffs (excel>lst))

(setq res (ziplist koeffs))


(setq ans
(mapcar
  '(lambda (x)

     (list
       (car x)
       (apply '+ (mapcar 'atoi (cdr x)))
       )
     
     )
  (cdr res)
  ))






(mapcar
  '(lambda (b)
     (vla-put-TextString (getbatt b "KKS")
       ((kd-get-textstring (getbatt b "KKS"))
       )
     )
     )
  (ss->lsto* (ssget "_I"))
  )




(mapcar
  '(lambda (b / kks a)
     (setq kks (kd-get-textstring (getbatt b "KKS")))
     (if (setq a (assoc kks ans))
       (vla-put-TextString (getbatt b "WEIGHT") (cadr a))
       (vla-put-TextString (getbatt b "WEIGHT") "ERROR")
       )
     )
  (ss->lsto* (ssget "_I"))
  )







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq blks (ss->lsto* (ssget "_I")))

(setq cmpt '(0 (0 0 0)))

(setq data
       (mapcar
	 '(lambda (b)
	    (list
	      (atoi (kd-get-textstring (getbatt b "WEIGHT")))
	      (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))
	      )
	    )
	 blks
	 )
       )



(mapcar
  '(lambda (line / w ang l)	;(setq line (nth 13 data))
     (setq l (/
	       (* (car line) (distance (cadr cmpt) (cadr line)))
	       (+ (car cmpt) (car line))
	       ))
     (setq ang (angle (cadr cmpt) (cadr line)))
     (setq
       cmpt
	(list
	  (+ (car cmpt) (car line))
	  (polar (cadr cmpt) ang l)
	  )
	)
     )
  data
  )

cmpt


(vla-addcircle #modspace (vlax-3d-point (cadr cmpt)) (car cmpt))