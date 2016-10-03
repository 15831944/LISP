
(defun dcl-gen (

		/
		e
		ss
		dcl-file-path
		hand
		)
  ;(setq ss (ssget '((0 . "INSERT")))
  (setq e (car (entsel)))
  (setq
	dcl-file-path (strcat "D:\\!! ACAD work folder" "\\dcl-dialog.dcl")
	hand (open dcl-file-path "w"))
  (write-line (btostr e) hand)
  (close hand)

   
  );defun


(defun btostr (bname
	       /
	       str
	       enatt
	       engatt
	       endstr
	       val
	       )
  (setq str "")
  (if (= 1 (cdr (assoc 66 (entget bname))))
    (progn
      (setq str (strcat ": "
			(cdr (assoc 2 (entget bname)))
			"{"
			)
	    enatt (entnext bname))
      (while (/= "SEQEND" (cdr (assoc 0 (setq engatt(entget enatt)))))



;;; 			VLA-GET-ATTRIBUTES




	(setq val (cdr (assoc 1 engatt))
	      str (strcat
		    str
		    (strcase (cdr (assoc 2 engatt)) T)
		    "="
		    (if (= (type val) 'STR) (chr 34))
		    val
		    (if (= (type val) 'STR) (chr 34))
		    ";"
		    ))
	  (setq enatt (entnext enatt))
	  );while
      (setq str (strcat str "}"))
      (princ)
      );progn then
    (setq str (strcat ": " (cdr (assoc 2 (entget bname))) ";"))
    );if
  str
  );defun