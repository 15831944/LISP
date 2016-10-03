(defun c:ktz-deltadist (/ pt1 pp ppl entg1 ptl pt2 entg2 instextpt dv doc)


  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init

  
  (setq	pt1
	 (assoc	10
		(entget (car (entsel "\n укажите ѕ–»ћ≈–ный блок (базу)")))
	 )
  )

  (setq ppl (list 0 10 71 72 62 6 40 7 8 41 51))
  (setq entg1 (entget (car (entsel "\n укажите ѕ–»ћ≈–ный текст"))))
  (setq ptl '())
  (foreach pp ppl
    (if	(assoc pp entg1)
      (setq ptl (append ptl (list (assoc pp entg1))))
    )
  )

  (if (not (assoc 11 entg1))
    (setq instextpt 10)
    (setq instextpt 11)
  )
  (setq dv (ktz-vect-dif (cdr pt1) (cdr (assoc instextpt entg1))))

  (setq	pt2
	 (assoc	10
		(entget
		  (car (entsel "\n укажите модифицируемый блок (базу)"))
		)
	 )
  )

  (setq entg2 (entget (car (entsel "\n укажите модифицируемы текст"))))

  (setq	ptl (append ptl
		    (list
		      (assoc 1 entg2)
		      (cons instextpt (ktz-vect-dif (cdr pt2) dv))
		    )
	    )
  )
  (entdel (cdr (assoc -1 entg2)))
  (entmake ptl)
  (princ)


  (acet-error-restore)
  (vla-endundomark doc)  
)					;defun