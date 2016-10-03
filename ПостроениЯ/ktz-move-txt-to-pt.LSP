(defun c:mf (/ et p)
  (setq et 	(car (entsel "\n pick  a txt")))
  (setq p	(getpoint "\n pick a point"))
  
  
  (ktz-move-txt-to-pt et p)
  );


(defun ktz-move-txt-to-pt (
			     e	;	блок
			     pt		;	точка в которую его перенести
			     /
			     eng
			     bpt
			     )
  (setq eng (entget e))
	      
  (if (= "MTEXT"
	  (cdr (assoc 0 eng))
	  )
    ;then
    (progn
      (setq eng (subst (cons 10 pt)
		       (assoc 10 eng)
		       eng
		       )
	    );setq
      (entmod eng)
      (entupd e)
      );progn
    ;else
    (alert "не *текст")
    );if
  );defun



















