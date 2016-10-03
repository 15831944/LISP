(setq od (namedobjdict))

(defun nav-od (od
	       /
	       
	       liod
	       lod

	       i
	       )
   (setq 
	 lod '()
	 i 0
	 liod (vl-remove-if-not '(lambda (x) (or (= (car x) 3) (= (car x) 350)))
		 (entget od)))
   (repeat (/ (length liod) 2)
      (setq lod (append lod (list (cons (cdr (nth i liod)) (cdr (nth (1+ i)liod)))))
	    i (+ i 2))
      );repeaat

   
   (princ "\n")
   (princ "==========================================================")
   (princ "\n")
   (mapcar 'princ lod)
   (princ "\n")
   (princ "\n")




   

   (setq od (cdr (nth (sellist lod) lod)))
   (nav-od od)
      
   );defun



(defun sellist (lst
		/
		init
		init2
		kword
		txt
		i
		)
   (setq i 0
	 init ""
	 init2 ""
	 kword "")
   (repeat (length lst)
      (setq txt (strcase (car (nth i lst)) T))
      (while (wcmatch txt "*_*") (setq txt (vl-string-subst "-" "_" txt)))
      (setq init (strcat init txt " ")
	    init2 (strcat init2 (itoa i) " ")
	    kword (strcat kword txt "/")
	    )
      (setq i (1+ i))
      );repeat
   (setq kword (vl-string-right-trim "/" kword))
   (initget (strcat init "_" init2))
   (atoi (getkword (strcat "\n select dictionary  : [" kword "]\n")))
   );defun
      
   
   





