;;; Копирует текст исходного в конечный (2 тыка)
;;; Тыкать в Текст/Мтекст/Блок
;;; использует ktz-get-blk-attrib-ename-by-pt (ближайший к указанию аттрибут) ktz-get-blk-attrib-ename или (из списка)
;;; 		уже блин не использует
;;; обязательно в настройках динамического ввода наличие галочки возле
;;; "включить ввод размеров где возможно"


;;;(defun c:ktz-txtcopy-old ( /
;;;			  ents			;список entsel
;;;			  ent			;ename
;;;			  ename-get		
;;;			  t-str			;текст генерируемого поля
;;;			  flag			;способ выбора аттрибута в блоке
;;;			  )
;;;  (while (= (setq ents (entsel "\nоткуда брать содержимое")) nil))
;;;  
;;;  (cond
;;;    ;1
;;;    ((or
;;;       (eq "TEXT" (cdr (assoc 0 (entget (car ents)))))
;;;       (eq "MTEXT" (cdr (assoc 0 (entget (car ents)))))
;;;     );or
;;;     (setq ent (car ents))
;;;    );1
;;;    ;2
;;;    ((eq "INSERT" (cdr (assoc 0 (entget (car ents)))))
;;;     (progn
;;;       (initget "Точка Выбрать _Точка Выбрать")
;;;       (setq flag (getkword "\n Выбирать аттрибут по точке или выбрать из списка?  : [Точка/Выбрать] <Точка>"))
;;;       (cond
;;;	 ;1
;;;	 ((= flag "Выбрать")
;;;	  (setq ent (ktz-get-blk-attrib-ename ents))			;выбор из списка
;;;	  )
;;;	 ;2
;;;	 ((= flag "Точка")
;;;	  (setq ent (ktz-get-blk-attrib-ename-by-pt ents))		;выбор по точке
;;;	 )
;;;       );cond
;;;     );progn
;;;    );2
;;;  );cond
;;;
;;;  (setq	t-str (cdr (assoc 1 (entget ent))))
;;;  (while (= (setq ents (entsel "\n\nкуда писать")) nil))
;;;  (cond
;;;    ;1
;;;    ((or
;;;       (eq "TEXT" (cdr (assoc 0 (entget (car ents)))))
;;;       (eq "MTEXT" (cdr (assoc 0 (entget (car ents)))))
;;;     );or
;;;     (setq ent (car ents))
;;;    );1
;;;    ;2
;;;    ((eq "INSERT" (cdr (assoc 0 (entget (car ents)))))
;;;     (progn
;;;       (initget "Точка Выбрать -Точка Выбрать")
;;;       (setq flag (getkword "\n Выбирать аттрибут по точке или выбрать из списка?  : [Точка/Выбрать] <Точка>"))
;;;       (cond
;;;	 ;1
;;;	 ((= flag "Выбрать")
;;;	  (setq ent (ktz-get-blk-attrib-ename ents))			;выбор из списка
;;;	  )
;;;	 ;2
;;;	 ((= flag "Точка")
;;;	  (setq ent (ktz-get-blk-attrib-ename-by-pt ents))		;выбор по точке
;;;	 )
;;;       );cond
;;;     );progn
;;;    );2
;;;  );cond
;;;  (princ ent)
;;;  (setq ename-get (entget ent))
;;;  (setq	ename-get (subst (cons 1 t-str)
;;;			 (assoc 1 ename-get)
;;;			 ename-get
;;;		  )
;;;  )
;;;  (entmod ename-get)
;;;  (entupd (cdr (assoc -1 ename-get)))
;;;  (princ)
;;;)					;defun
;;;
;;;

;;;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*




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
