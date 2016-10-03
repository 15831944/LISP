(defun fndre (
	      /
	      doc
	      ss
	      ss1
	      i

	      entxt
	      strl
	      wrd
	      words
	      )
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

  (setq ss (ssget '((0 . "TEXT")))
	ss1 (ssadd)
	i -1)

  (repeat (sslength ss)
    (setq i (1+ i)
	  entxt (ssname ss i)
	  strl (vl-string->list (cdr (assoc 1 (entget entxt))))
	  words '()
	  wrd '()
	  );setq
    (foreach item strl
      (cond
	((= item 32)(setq words (append words (list wrd))
			  wrd '()))
	(T (setq wrd (append wrd (list item))))
	)
      );foreach strl
    
   
    );repeat ss
  (acet-error-restore)
  (vla-endundomark doc)
  );defun









;;;(getlang (car (entsel)))
(defun getlang (e
		/
		eg
		strl
		english
		rus
		other
		num
		)
  (setq english 0
	rus 0
	other 0
	num 0
	)
  (if (= "TEXT" (cdr (assoc 0 (setq eg (entget e)))))
    (progn
      (setq strl (vl-string->list (cdr (assoc 1 eg))))
      (foreach item strl
	(cond
	  ;english
	  ((or
	     (ifin item '(65 90))
	     (ifin item '(97 122))
	     )
	   (setq english (1+ english)))
	  
	  ;russian
	  ((or (ifin item '(192 255)))
	   (setq rus (1+ rus)))
	  ;num
	  ((or (ifin item '(48 57)))
	   (setq num (1+ num)))
	  ;other
	  (T (setq other (1+ other)))
	  );cond
	);foreach strl
      );progn then
    );if text
  (princ "english rus num other\n")
  (list english rus num other)
  );defun getlang



;;;(setq i 0)
;;;(repeat 256
;;;  (princ (strcat (itoa i) "\t" (chr i) "\n"))
;;;  (setq i (1+ i))
;;;  )

;;;(vl-catch-all-error-message
;;;  (vl-catch-all-apply   'sqrt   '(-72))
;;;  )

(defun ifin (number		; 6
	   range		; '(2 9)
	   /
	   )
  (and
    (<= number (cadr range))
    (>= number (car range))
    )
  )