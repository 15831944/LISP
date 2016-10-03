(defun nav-od (
	       /
	       od
	      ; liod
	      ; di
	       flag
	       ent

	       init
	       kword
	       i
	       )
  (setq od (namedobjdict)
	flag T
	init ""
	kword "")
  

;  (entget od)
  
  (setq liod (mapcar 'cdr (vl-remove-if-not
			    (function (lambda (x) (or
						    (= (car x) 3)
						    ;(= (car x) 350)
						    )))
			    (entget od))));setq

 ; (setq init (strcase (strcat init (vl-string-subst "-" "_" acn) " ") t))
  (foreach item liod
    (setq init (strcat init (vl-string-subst "-" "_" item) " ")
	  kword (strcat kword (vl-string-subst "-" "_" item) "/"))
    )

  (initget (strcat init " _" init))
  (setq di (getkword (strcat "\n ”кажите словарь \n[" kword "] :")))


  (princ di)

 
  );defun

(nav-od)