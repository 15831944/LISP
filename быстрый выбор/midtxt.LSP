(defun c:midtxt	(/ ss x1 x2 et eng pt)
  (if (and
	(setq ss (ssget "_I"))
	(= (sslength ss) 2)
	) ;_ and
    (setq x1 (cadr (assoc 10 (entget (ssname ss 0))))
	  x2 (cadr (assoc 10 (entget (ssname ss 1))))
	  ) ;_ setq
    (setq x1 (cadr
	       (assoc 10 (entget (car (entsel "\nукажите 1-й отрезок"))))
	       ) ;_ cadr
	  x2 (cadr
	       (assoc 10 (entget (car (entsel "\nукажите 2-ой отрезок"))))
	       ) ;_ cadr
	  ) ;_ setq
    ) ;if

  (setq eng (entget (setq et (car (entsel "\nукажите текст")))))

  (cond
 ;text
    ((= "TEXT" (cdr (assoc 0 eng)))
     (progn
       (setq ss	(assoc 11 eng)
	     pt	(cons 11
		      (list
			(/ (+ x1 x2) 2)
			(caddr ss)
			(cadddr ss)
			) ;_ list
		      ) ;_ cons
	     ) ;_ setq
       (setq eng (subst pt ss eng))
       ) ;_ progn
     )
 ;mtext
    ((= "MTEXT" (cdr (assoc 0 eng)))
     (progn
       (setq ss	(assoc 10 eng)
	     pt	(cons 10
		      (list
			(/ (+ x1 x2) 2)
			(caddr ss)
			(cadddr ss)
			) ;_ list
		      ) ;_ cons
	     ) ;_ setq
       (setq eng (subst pt ss eng))
       
       (setq ss	(assoc 41 eng)
	     pt	(cons 41 (abs (- x2 x1)))
	     ) ;_ setq
       (setq eng (subst pt ss eng))
       (setq eng (subst '(71 . 5) (assoc 71 eng) eng))
       ) ;_ progn
     )
    ) ;cond
    (entmod eng)
  (entupd et)
  ) ;defun