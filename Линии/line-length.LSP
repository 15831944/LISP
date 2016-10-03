

(defun llch (
	     /
	     ss
	     i
	     )
  (setq ss (ssget "_I")
	i 0)
  (repeat (sslength ss)
    (line-length (ssname ss i) 400)
    (setq i (1+ i))
    )
  )




(defun line-length (ent
		    l
		    /
		    eng
		    p10
		    p10n
		    p11
		    p11n
		    mp
		    OldLength
		    
		    )
  
  (setq eng (entget ent)
	p10 (cdr (assoc 10 eng))
	p11 (cdr (assoc 11 eng))
	mp (vec-div (vec-sum p10 p11) 2)
	OldLength (distance mp p11)
	p10n (vec-sum mp (vec-comp (vec-dif p10 mp) (/ (/ l 2) OldLength)))
	p11n (vec-sum mp (vec-comp (vec-dif p11 mp) (/ (/ l 2) OldLength)))
	)
  (setq eng (subst (cons 10 p10n) (cons 10 p10) eng))
  (setq eng (subst (cons 11 p11n) (cons 11 p11) eng))
  (entmod eng)
  (entupd ent)
  
  );defun




(defun c:make-axe (
		   /
		   eng1
		   eng2
		   cp1
		   cp2
		   )
  (setq eng1 (entget (car (entsel)))
	eng2 (entget (car (entsel)))
	cp (vec-div (vec-sum
		      (cdr (assoc 10 eng1))
		      (cdr (assoc 11 eng2)))
		    2)
	)
  
  )