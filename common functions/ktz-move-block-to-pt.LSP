

;;;			VLA-PUT-INSERTIONPOINT


(defun c:mf (/ et p)
  (setq et 	(car (entsel "\n pick  a block")))
  (setq p	(getpoint "\n pick a point"))
  
  
  (ktz-move-block-to-pt et p)
  );


(defun ktz-move-block-to-pt (
			     e	;	блок
			     pt		;	точка в которую его перенести
			     /
			     ent
			     pti
			     eng
			     bpt
			     dbpt
			     pf

			     )
  (setq ent e)
  (if (/= "INSERT"
	  (cdr (assoc 0 (entget ent)))
	  );then
    (progn
      (alert "не блок")
      (exit)
    )
    );if

;;;      (setq bpt (cdr (assoc 10 (entget ent))))

      (setq bpt (cdr (assoc 10 (entget e))))
;;;*************************************************************
      (while (/= "SEQEND" (cdr (assoc 0 (setq eng (entget ent)))))

;;;	(if (or	(eq (cdr (assoc 0 eng)) "INSERT")
;;;		(and (eq (cdr (assoc 72 eng)) 0)
;;;		     (eq (cdr (assoc 73 eng)) 0)
;;;		)
;;;	    );or
;;;	  ;then
;;;	  (setq pf 10)
;;;	  ;else
;;;	  (setq pf 11)
;;;
;;;	);if

  (princ "\n")
	(setq pf (if (princ (or
		       (equal '(11 0.0 0.0 0.0)
			   (assoc 11 eng))
		       (null (assoc 11 eng))
		       ))
		   10
		   11
		   ))
	

	
	(princ pf)
      (setq dbpt (vec-dif bpt (cdr (assoc pf eng))))

;;;	(setq pti (list	(+ (car pt)
;;;			   (- (car (cdr (assoc 10 eng))) (car bpt)
;;;			   )
;;;			);X
;;;			(+ (cadr pt)
;;;			   (- (cadr (cdr (assoc 10 eng))) (cadr bpt)
;;;			   )
;;;			);Y
;;;		  )
;;;	)
	(setq pti (vec-dif pt dbpt))

	(setq eng (subst (cons pf pti)
			 (assoc pf eng)
			 eng
		  )
	);setq
	(entmod eng)
	(entupd ent)
	(setq ent (entnext ent))

      );while
;;;*************************************************************

  (entupd e)
);defun



















