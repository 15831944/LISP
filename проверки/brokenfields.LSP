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

  (princ "\n���������� ������������� ��������� ��������� ����� : ")
  (princ (sslength ss))
  (princ "\n")
  (repeat (sslength ss)
    (setq ent (ssname ss i))


    (if	(= "INSERT" (cdr (assoc 0 (entget ent))))
      (progn
	(setq ent (entnext ent)
	      isattnotadded T
	      ) ;_ ����� setq
	(while isattnotadded
	  (setq str (cdr (assoc 1 (entget ent))))
	  (setq str (vl-string->list str))
	  (if (member 35 str)
	    (setq ss1		(ssadd (cdr (assoc 330 (entget ent))) ss1)
		  isattnotadded	nil
		  ) ;_ ����� setq
	    ) ;if member
	  (setq ent (entnext ent))
	  (if isattnotadded
	    (setq isattnotadded
		   (/= "SEQEND" (cdr (assoc 0 (entget ent))))
		  ) ;_ ����� setq
	    ) ;_ ����� if
	  ) ;while
	) ;progn
 ;else
      (progn
	(setq str (cdr (assoc 1 (entget ent))))
	(setq str (vl-string->list str))
	(if (member 35 str)
	  (setq ss1 (ssadd ent ss1))
	  ) ;if member
	) ;_ ����� progn
      ) ;if insert
    (setq i (1+ i))
    ) ;_ ����� repeat
  (princ "\n���������� ����������� ��������� ����� : ")
  (princ (sslength ss1))
  (princ "\n")

  (sssetfirst nil ss1)

  ) ;defun

