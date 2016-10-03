


(defun mergetxt (ss)
  (setq ss (ssget '((0 . "TEXT"))))
  (antisep
  (mapcar
    'kd-get-textstring
    
  (vl-sort
    (ss->lsto* ss) ;(setq x (car (ss->lsto* ss)))
    '(lambda (a b)
       (>
	 (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
	 (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))
	 )
       )
    )
  )
  (cond
    ((= p "KKS") "")
    ((= p "meas_name") " ")
    ((= p "order") " ")
    ((= p "order_code") "")
    )
  )
  );defun





(mergetxt (ssget '((0 . "TEXT"))))
  (ss->lsto* (ssget '((0 . "TEXT"))))
  )




(setq tbl '(("KKS" "meas_name" "order" "order_code")))



(defun c:asd ()
  (setq tbl (cons
	      (mapcar '(lambda (p) (princ p) (mergetxt (ssget '((0 . "TEXT"))))) (last tbl))
	      tbl)
	)
  )



(lst>excel (reverse tbl))
