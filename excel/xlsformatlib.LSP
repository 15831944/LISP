;;; 13_10_08
;;; db|library
;(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))

(load (strcat #lisppath "common functions\\diap.lsp"))
(defun isnumericstring (str / lst)
  (setq lst (subst 46 44 (VL-STRING->LIST str)))
  (eval (append '(and) (mapcar '(lambda (x) (or (diap x 48 57)(= x 46))) lst)))
  );defun





;;;  дает количество значимых цифр после запятой
(defun getqanums (num / step)
  ;;;;  (getqanums 150.1023)   - глюк
  (if (member (type num) '(INT REAL))
    (progn
      (setq step 0)
      (while (null (= (fix (* num (expt 10 step))) (* num (expt 10 step))))
	(setq step (1+ step))
	) step
      )
    0
    )
  );defun
;(getqanums 15.1590)





;(db|formatdata lst)
(defun db|formatdata (lines / ans)
  (setq ans (mapcar
    '(lambda (line)
       (mapcar
	 '(lambda (x)
	    (cond
	      ((or (= (type x) 'INT) (= (type x) 'REAL)) (rtos* x))
	      ((= "м?/ч" x) "м\U+00B3/ч")
	      ;;   kappa \U+00E6	63
	      ((= "#" x) "")
	      ((null x) "")
	      (T x)
	      )
	    )
	 line
	 )
       )
    lines
    ))
  (setq ans (vl-remove-if '(lambda (x) (apply '= (cons nil x))) ans))
  (setq ans (vl-remove-if '(lambda (x) (apply '= (cons "" x))) ans))
  );defun

(defun db|formatdata0 (lines / ans)
  (setq ans (mapcar
    '(lambda (line)
       (mapcar
	 '(lambda (x)
	    (cond
	      ((or (= (type x) 'INT) (= (type x) 'REAL)) (rtos* x))
	      ((= "м?/ч" x) "м\U+00B3/ч")
	      ;;   kappa \U+00E6	63
	      ((= "#" x) "")
	      ((null x) "")
	      (T x)
	      )
	    )
	 line
	 )
       )
    lines
    ))
  );defun




;;;
;;;
;;;;;;    generate string from xlsline
;;;(defun spc|gsfxl (paramname razdelitel xlslines)
;;;  (vl-string-right-trim razdelitel
;;;    (apply 'strcat
;;;	   (mapcar
;;;	     '(lambda (xlsline)
;;;		(strcat (db|gpar paramname xlsline) razdelitel)
;;;		)
;;;	     xlslines)))
;;;  );defun


;;;
;;;;(setq paramname "place_cpu")
;;;;(setq xlslines tail)
;;;(defun spc|gsfxl2 (paramname xlslines / lst place1)
;;;  (setq lst (mapcar
;;;    '(lambda (xlsline)
;;;       (db|gpar paramname xlsline))
;;;    xlslines))
;;;  (setq place1 (car lst))
;;;  (if (vl-every '(lambda (x) (= place1 x)) lst)
;;;    place1
;;;    (vl-string-right-trim ", "
;;;      (apply 'strcat
;;;	     (mapcar
;;;	     '(lambda (x)
;;;		(strcat x ", ")
;;;		)
;;;	     lst)))
;;;    )
;;;  
;;;  );defun


;;;;(setq lparamnames '("KKS" "Diam_tr"))
;;;;(setq lrazds '(", " ",\n"))
;;;;(spc|gsfxl3 lparamnames lrazds xlslines)
;;;(defun spc|gsfxl3 (lparamnames lrazds xlslines / lst place1)
;;;  (setq lst (mapcar
;;;       '(lambda (xlsline)
;;;	  ;(vl-string-right-trim (car (reverse lrazds))
;;;	  (apply 'strcat (mapcar
;;;	    '(lambda (p r)
;;;	       (strcat (db|gpar p xlsline) r))
;;;	    lparamnames lrazds))
;;;	  ;)
;;;	  )xlslines))
;;;  (setq place1 (car lst))
;;;  (if (vl-every '(lambda (x) (= place1 x)) lst)
;;;    (vl-string-right-trim (car (reverse lrazds)) place1)
;;;    (vl-string-right-trim (car (reverse lrazds))
;;;      (apply 'strcat lst))
;;;    )
;;;  );defun








;;;(defun spc|mm->m ( data )
;;;  (mapcar
;;;    ;(setq x (car xls-data))
;;;    '(lambda (x)
;;;       (if (= "мм" (db|gpar "units" x))
;;;	 (mapcar
;;;	   '(lambda (pr h)
;;;	      (cond
;;;		((= h "units") "м")
;;;		((= h "nom_val") (rtos* (/ (atof* pr) 1000)))
;;;		((= h "max_val") (rtos* (/ (atof* pr) 1000)))
;;;		((= h "min_val") (rtos* (/ (atof* pr) 1000)))
;;;		(T pr)
;;;		)
;;;	      )
;;;	   x xls-head
;;;	   )
;;;	 x
;;;	 )
;;;       )
;;;    data
;;;    )
;;;  );defun
