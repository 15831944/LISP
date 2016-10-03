;;; есть 2 набора текстов
;;; прога ищет и подсвечивает красным те текстовые элементы,
;;; которые взаимно не повтор€ютс€ в наборах


(defun consp (
	      /
	      ls1
	      ls2
	      eng
	      flag
	      doc
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
  
  (setq ls1 (ss->lst "/nукажите 1")
	ls2 (ss->lst "/nукажите 2")
	ls1 (mapcar '(lambda (x) (cons (cdr (assoc 1 (entget x))) x)) ls1)
	ls2 (mapcar '(lambda (x) (cons (cdr (assoc 1 (entget x))) x)) ls2)
	)

  (foreach item ls1
    (if (null (assoc (car item) ls2))
      (progn
	(setq eng (entget (cdr item)))
	(if (assoc 62 eng)
	  (setq eng (subst '(62 . 1) (assoc 62 eng) eng))
	  (setq eng (append eng '((62 . 1))))
	  );if
	(entmod eng)
	(entupd (cdr item))
	(setq flag T)
	)
      )
    );foreach

  (foreach item ls2
    (if (null (assoc (car item) ls1))
      (progn
	(setq eng (entget (cdr item)))
	(if (assoc 62 eng)
	  (setq eng (subst '(62 . 1) (assoc 62 eng) eng))
	  (setq eng (append eng '((62 . 1))))
	  );if
	(entmod eng)
	(entupd (cdr item))
	(setq flag T)
	)
      )
    );foreach
  (acet-error-restore)
  (vla-endundomark doc)

  
  flag
  );defun


