;;; навигатор по зависимостям объектов 360-330


;(setq ent nil)
(setq ent (NAMEDOBJDICT))

(defun nav ( ent
	   /
	   ;ent
	   str-init
	   famlist
	   pp
	   key
	   i
	   flag
	   )

  (if (null ent)
    (setq ent (entget (car (entsel))))
    (setq ent (entget ent))
    )
    ;(setq ent (entget (cadr flee)))
  ;(setq ent (entget (tblobjname "block" "монтаж_STS-2.5")))
;;;  (setq ent (entget (tblobjname "block" "провод")))
  (setq flag T)




  (while flag
  (setq i 1
	famlist '())

    (princ "\n********************************************************************")
    (princ "\n")
    (princ ent)
    (princ "\n********************************************************************")
    (princ "\n")
    ;;;================================================================================
  (while (and
	   (setq pp (assoc 330 ent))
	   (entget (cdr pp))
	   )
    (setq famlist (append famlist (list (cons i
					      (list (car pp)
						    (cdr pp)
						    (strcat
						      (cdr (assoc 0 ent))
						      "<-"
						      (cdr (assoc 0 (entget (cdr pp))))
						      );strcat
						    )))));setq
    (setq ent (vl-remove pp ent))
    (setq i (1+ i))
    );while
    
    ;;;================================================================================
  (while (and
	   (setq pp (assoc 340 ent))
	   (entget (cdr pp))
	   )
    (setq famlist (append famlist (list (cons i
					      (list (car pp)
						    (cdr pp)
						    (strcat
						      (cdr (assoc 0 ent))
						      "<-"
						      (cdr (assoc 0 (entget (cdr pp))))
						      );strcat
						    )))));setq
    (setq ent (vl-remove pp ent))
    (setq i (1+ i))
    );while
    ;;;================================================================================



  (while (and
	   (setq pp (assoc 350 ent))
	   (entget (cdr pp))
	   )
    (setq famlist (append famlist (list (cons i
					      (list (car pp)
						    (cdr pp)
						    (strcat
						      (cdr (assoc 0 ent))
						      "<-"
						      (cdr (assoc 0 (entget (cdr pp))))
						      );strcat
						    )))));setq
    (setq ent (vl-remove pp ent))
    (setq i (1+ i))
    );while
    ;;;================================================================================    

    (while (and
	   (setq pp (assoc -2 ent))
	   (entget (cdr pp))
	   )
    (setq famlist (append famlist (list (cons i
					      (list (car pp)
						    (cdr pp)
						    (strcat
						      (cdr (assoc 0 ent))
						      "<-"
						      (cdr (assoc 0 (entget (cdr pp))))
						      );strcat
						    )))));setq
    (setq ent (vl-remove pp ent))
    (setq i (1+ i))
    );while

    ;;;================================================================================

  (while (and
	   (setq pp (assoc 360 ent))
	   (entget (cdr pp))
	   )
    (setq famlist (append famlist (list (cons i
					      (list (car pp)
						    (cdr pp)
						    (strcat
						      (cdr (assoc 0 ent))
						      "->"
						      (cdr (assoc 0 (entget (cdr pp))))
						      );strcat
						    )))));setq
    (setq ent (vl-remove pp ent))
    (setq i (1+ i))
    );while

    ;;;================================================================================

  (while (and
	   (setq pp (assoc 331 ent))
	   (entget (cdr pp))
	   )
    (setq famlist (append famlist (list (cons i
					      (list (car pp)
						    (cdr pp)
						    (strcat
						      (cdr (assoc 0 ent))
						      "->"
						      (cdr (assoc 0 (entget (cdr pp))))
						      );strcat
						    )))));setq
    (setq ent (vl-remove pp ent))
    (setq i (1+ i))
    );while

    ;;;================================================================================

    

    
  (princ "\n-----------------------------------------------------------------")
  (princ "\n")
  (mapcar '(lambda (x)
	     (princ x)
	     (princ "\n")
	     )
	  famlist)
    
  (princ "\n-----------------------------------------------------------------")
  (princ "\n")
    ;(sssetfirst nil (ssadd (cdr (assoc -1 ent))))

  (initget 1)
  (setq key (getint))
  (if (= key 0)
    (setq flag nil)
    (setq ent (entget (caddr (assoc key famlist))))
    );if
    
  );while T
  

  
  );defun
(nav ent)