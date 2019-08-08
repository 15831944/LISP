(defun c:ktz-txtcopy (
		      /
		      ent-from
		      ent-to
		      ename-get
		      fl		; флаг правильно выбранного объекта
		      tmp
		      str
		      doc
		      es
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



    
  (while (not fl)
    (setq ent-from (car (nentsel "\n Укажите источник данных ... :"))
	  tmp (cdr (assoc 0 (entget ent-from)))
	  );setq
    (if	(or
	  (eq tmp "TEXT")
	  (eq tmp "ATTRIB")
	  (eq tmp "MTEXT")
	  (eq tmp "DIMENSION")
	  );or
      ;then	
      (setq fl T)
      ;else
      (princ "\n *** Не найден источник данных ***")
      );if
    );while
  (setq fl nil)


  (setq	str (cdr (assoc 1 (entget ent-from))))

  (while (setq es (nentsel "\n Укажите объект-приемник данных ... :"))
    (if (and
	  es
	  (setq ent-to (car es))
	  (member (cdr (assoc 0 (entget ent-to)))
	    '("ATTRIB" "MTEXT" "DIMENSION" "TEXT")
	    ) ;_ member
	  ) ;_ and
	  
    (progn
      (setq ename-get (entget ent-to))
      (setq ename-get (subst (cons 1 str)
			     (assoc 1 ename-get)
			     ename-get
			     ) ;_ subst
	    ) ;_ setq
      (entmod ename-get)
      (entupd (cdr (assoc -1 ename-get)))
      (vl-cmdf "_updatefield" (cdr (assoc -1 ename-get)) "")
      ) ;progn
    (princ "\n *** Не верный выбор объекта-приемника ***")
    ) ;if ent
  (acet-error-restore)
  (vla-endundomark doc)

    ) ;while entsel
 
  (princ)
);defun
