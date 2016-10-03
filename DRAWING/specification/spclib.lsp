;;; 13_05_17
;;; spc|library


;; c:frmtstr		в наборе заменяет в дробных числах, "," на "." - для lispa
;;			и удаляет лишние нули
;; isnumericstring	проверяет является ли текстовая строка - числом

(load (strcat #lisppath "common functions\\diap.lsp"))
(load (strcat #lisppath "strings\\stringlib.lsp"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;   параметры вывода графы спецификации   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
  #spc|addgraha:insertparamslist
   '(
     ;(("object" "TEXT") ("dpt" '( 10 -4 0)))
     (("object" "MTEXT")("dpt" '( 0.8 -3 0))("attch" 1)("width" 18.4)
      ;("widthfactor" "{\\W0.8;\\T0.9;")
      ("widthfactor" "{\\W0.9;")
      )	;позиция
     (("object" "MTEXT")("dpt" '( 22 -3 0))("attch" 1)("width" 126))
     (("object" "MTEXT")("dpt" '( 152 -3 0))("attch" 1)("width" 56))
     (("object" "TEXT")("dpt" '( 227.5 -4 0)))
     (("object" "MTEXT")("dpt" '( 247 -3 0))("attch" 2)("width" 41))
     (("object" "TEXT")("dpt" '( 300 -4 0)))
     (("object" "TEXT")("dpt" '( 320 -4 0)))
     (("object" "TEXT")("dpt" '( 342.5 -4 0)))
     (("object" "MTEXT")("dpt" '( 357 -3 0))("attch" 1)("width" 36))
     )
  );spctblparamlist
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun spc|addgrapha (pt list9strings / txtobj maxheight cpt wf)
  (setq cpt pt)
  (setq maxheight '())
  (mapcar '(lambda (x p)
     (cond
       ((= "MTEXT" (cadr (assoc "object" p)))
	(progn
	  (setq txtobj (vla-AddMtext #modspace
			 (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))) (cadr (assoc "width" p))
			 ;;;;  тестил тока с давлением
			 (if (setq wf (assoc "widthfactor" p))
			   (strcat (cadr wf) x "}")
			   x
			   )
			 ))
	  (vla-put-AttachmentPoint txtobj (cadr (assoc "attch" p)))
	  (vla-put-LineSpacingStyle txtobj acLineSpacingStyleExactly)
	  (vla-put-Height txtobj 2.5)
	  (vla-put-LineSpacingDistance txtobj 8)
	  (setq maxheight (append maxheight (list (mtxt:getnumberoflines txtobj))))
	  );progn
	)
       ((= "TEXT" (cadr (assoc "object" p)))
	(progn
	  (setq txtobj (vla-Addtext #modspace x (vlax-3d-point '(0 0 0)) 2.5))
	  (vla-put-Alignment txtobj 10)
	  (vla-put-TextAlignmentPoint txtobj (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))))
	  );progn
	);1
       )
	     )
	  list9strings			 ;x
	  #spc|addgraha:insertparamslist ;p
	  )
  ; и выдает точку вставки следующей графы
  (mapcar '- cpt (list 0 (* 8 (apply 'max maxheight)) 0))
  ;(mapcar '- cpt (list 0 (* 8 (1+ (apply 'max maxheight))) 0))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun xls|formatdata (xlslines)
  (mapcar
    '(lambda (xlsline)
       (mapcar
	 '(lambda (x)
	    (if (or (= (type x) 'INT) (= (type x) 'REAL))
	      (rtos* x)
	      x
	      )
	    )
	 xlsline
	 )
       )
    xlslines)
  );defun










(defun xlsgpar (str line / n)	; # - xls-head
  (if (setq n (vl-position str xls-head))
    (nth n line)
    )
  );defun



;;;    generate string from xlsline
;;;    перечисляет значения параметров через razdelitel
(defun spc|gsfxl (paramname razdelitel xlslines)
  (vl-string-right-trim razdelitel
    (apply 'strcat
	   (mapcar
	     '(lambda (xlsline)
		(strcat (xlsgpar paramname xlsline) razdelitel)
		)
	     xlslines)))
  );defun


;(setq paramname "place_cpu")
;(setq xlslines tail)
;;  предпочитаю первый вариант
(defun spc|gsfxl2 (paramname xlslines / lst place1)
  (setq lst (mapcar
    '(lambda (xlsline)
       (xlsgpar paramname xlsline))
    xlslines))
  (setq place1 (car lst))
  (if (vl-every '(lambda (x) (= place1 x)) lst)
    place1
    (vl-string-right-trim ", "
      (apply 'strcat
	     (mapcar
	     '(lambda (x)
		(strcat x ", ")
		)
	     lst)))
    )
  
  );defun


; соединяет названия параграфов, если одинаковое, то пишет одно
;(setq lparamnames '("KKS" "Diam_tr"))
;(setq lrazds '(", " ",\n"))
;(spc|gsfxl3 lparamnames lrazds xlslines)
(defun spc|gsfxl3 (lparamnames lrazds xlslines / lst place1)
  (setq lst (mapcar
       '(lambda (xlsline)
	  ;(vl-string-right-trim (car (reverse lrazds))
	  (apply 'strcat (mapcar
	    '(lambda (p r)
	       (strcat (xlsgpar p xlsline) r))
	    lparamnames lrazds))
	  ;)
	  )xlslines))
  (setq place1 (car lst))
  (if (vl-every '(lambda (x) (= place1 x)) lst)
    (vl-string-right-trim (car (reverse lrazds)) place1)
    (vl-string-right-trim (car (reverse lrazds))
      (apply 'strcat lst))
    )
  );defun




(defun spc|mm->m ( data )
  (mapcar
    ;(setq x (car xls-data))
    '(lambda (x)
       (if (= "мм" (xlsgpar "units" x))
	 (mapcar
	   '(lambda (pr h)
	      (cond
		((= h "units") "м")
		((= h "nom_val") (rtos* (/ (atof* pr) 1000)))
		((= h "max_val") (rtos* (/ (atof* pr) 1000)))
		((= h "min_val") (rtos* (/ (atof* pr) 1000)))
		(T pr)
		)
	      )
	   x xls-head
	   )
	 x
	 )
       )
    data
    )
  );defun









;;;(defun formatstrings-for-encount ()
;;;  (mapcar
;;;    '(lambda (x / str)
;;;       (setq str (vla-get-TextString x))
;;;       (if (isnumericstring str)
;;;	 (vla-put-textstring x
;;;	   (if (= (atof* str) (atoi str))
;;;	     (itoa (atoi (rtos (atof* str))))
;;;	     (rtos (atof* str))
;;;	     ))
;;;	 ))
;;;    (ss->lsto* (ssget '((0 . "*TEXT"))))
;;;    )
;;;  );defun