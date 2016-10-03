(defun fnd (/ objlist i ss lst ss1 str ent cmd isAttNotAdded)

  (setq	objlist	'(
		  (-4 . "<OR")
		  (0 . "TEXT")
		  (0 . "MTEXT")
		  (0 . "ATTRIB")
		  (0 . "ATTDEF")
		  (-4 . "<AND")
		  (0 . "INSERT")
		  (66 . 1)
		  (-4 . "AND>")
		  (-4 . "OR>")
		  )
	i	0
	ss1	(ssadd)
	) ;setq
  (setq ss (ssget "_X" objlist))

  (princ "\nКоличество подозреваемых носителей сломанных полей : ")
  (princ (sslength ss))
  (princ "\n")
  (repeat (sslength ss)
    (setq ent (ssname ss i))


    (if	(= "INSERT" (cdr (assoc 0 (entget ent))))
      (progn
	(setq ent (entnext ent)
	      isattnotadded T
	      ) ;_ конец setq
	(while isattnotadded
	  (setq str (cdr (assoc 1 (entget ent))))
	  (setq str (vl-string->list str))
	  (if (member 35 str)
	    (setq ss1		(ssadd (cdr (assoc 330 (entget ent))) ss1)
		  isattnotadded	nil
		  ) ;_ конец setq
	    ) ;if member
	  (setq ent (entnext ent))
	  (if isattnotadded
	    (setq isattnotadded
		   (/= "SEQEND" (cdr (assoc 0 (entget ent))))
		  ) ;_ конец setq
	    ) ;_ конец if
	  ) ;while
	) ;progn
 ;else
      (progn
	(setq str (cdr (assoc 1 (entget ent))))
	(setq str (vl-string->list str))
	(if (member 35 str)
	  (setq ss1 (ssadd ent ss1))
	  ) ;if member
	) ;_ конец progn
      ) ;if insert
    (setq i (1+ i))
    ) ;_ конец repeat
  (princ "\nКоличество обладателей сломанных полей : ")
  (princ (sslength ss1))
  (princ "\n")

  (sssetfirst nil ss1)

  ) ;defun

