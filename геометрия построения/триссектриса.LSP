











(defun getang (e1
	       e2
	       /
	       	)
  (* (/
       (-
	 (angle	(cdr (assoc 10 (entget e2)))
		(cdr (assoc 11 (entget e2)))
		) ;_ ����� angle

	 (angle	(cdr (assoc 10 (entget e1)))
		(cdr (assoc 11 (entget e1)))
		) ;_ ����� angle
	 ) ;_ ����� -
       pi
       ) ;_ ����� /
     180
     ) ;_ ����� *
  ) ;_ ����� defun

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
  (setq	pt     (getpoint "\n������� ����� ��� ��������... :")
	curang 90
	) ;_ ����� setq

  (setq os (car (nentsel "\n������� ���")))

  (setq	ang
	 (-
	   (* (/ (angle	(cdr (assoc 10 (entget os)))
			(cdr (assoc 11 (entget os)))
			) ;_ ����� angle
		 pi
		 ) ;_ ����� /
	      180
	      ) ;_ ����� *
	   curang
	   ) ;_ ����� -

	) ;_ ����� setq
  (princ)

  (command pt ang "")
  
  (vla-endundomark doc)
  (princ)

  ) ;defun



