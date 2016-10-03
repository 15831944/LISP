











(defun getang (e1
	       e2
	       /
	       	)
  (* (/
       (-
	 (angle	(cdr (assoc 10 (entget e2)))
		(cdr (assoc 11 (entget e2)))
		) ;_ конец angle

	 (angle	(cdr (assoc 10 (entget e1)))
		(cdr (assoc 11 (entget e1)))
		) ;_ конец angle
	 ) ;_ конец -
       pi
       ) ;_ конец /
     180
     ) ;_ конец *
  ) ;_ конец defun

;;;(* (/ (angle (getpoint) (getpoint))pi) 180)







(defun c:ktz-rotate (/ doc ss pt curang e os ang)


  (vl-load-com)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)

  (acet-error-init
    (list (list	"cmdecho" 0
		"expert"  nil
		)			;list
	  T
	  )				;list
    )					;acet-error-init



  
  (if (not (setq ss (ssget "_I")))
    (setq ss (ssget))
    ) ;if
  (command "_rotate" ss pause)
  (princ)
  (setq	pt     (getpoint "\nБазовая точка для поворота... :")
	curang 90
	) ;_ конец setq

  (setq os (car (nentsel "\nУкажите ось")))

  (setq	ang
	 (-
	   (* (/ (angle	(cdr (assoc 10 (entget os)))
			(cdr (assoc 11 (entget os)))
			) ;_ конец angle
		 pi
		 ) ;_ конец /
	      180
	      ) ;_ конец *
	   curang
	   ) ;_ конец -

	) ;_ конец setq
  (princ)

  (command pt ang "")
  
  (vla-endundomark doc)
  (princ)

  ) ;defun



