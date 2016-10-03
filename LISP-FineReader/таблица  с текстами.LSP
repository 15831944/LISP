(setq startpt (getpoint) cpt startpt)
(setq dy -8 dx 89)

(setq slist '())
(while
  (progn
    (vl-cmdf "_zoom" "_W" cpt (mapcar '+ cpt (list dx dy 0)))
    (setq ss (ssget "_C"
		    cpt
		    (mapcar '+ cpt (list dx dy 0))
		    '((0 . "*TEXT"))
		    )
	  )


		
    
    )
  (setq slist (cons (mergetxt ss) slist))
  (setq cpt (mapcar '+ cpt (list 0 dy)))
  )

(length slist)



(lst>excel (mapcar 'list slist))



(defun mergetxt (ss)
  (antisep
    (mapcar
      'kd-get-textstring
      (vl-sort
	(ss->lsto* ss)
	'(lambda (a b)
	   (>
	     (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
	     (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))
	     )
	   )
	)
      )
    " "
    )
  );defun



