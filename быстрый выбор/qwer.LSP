(defun qwer (
	     /
	     ss
	     i
	     ent
	     entg
	     txt
	     l1
	     l2

	     )

  (setq ss (ssget)
	i 0)
  (repeat (sslength ss)
    (setq entg (entget (setq ent (ssname ss i))))
    (setq txt (cdr (assoc 1 entg)))
;;;      (setq l1 1
;;;            l2 (- (strlen txt) 6))
      (setq l1 9
            l2 nil)
    
    (setq txt (substr txt l1 l2))
    (setq entg (subst (cons 1 txt)
		      (assoc 1 entg)
		      entg
		      ))
    (entmod entg)
    (entupd ent)
    
    (setq i (1+ i))
    )
  );defun