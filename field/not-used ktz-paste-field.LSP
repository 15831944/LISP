;;; Создает поле с содержимым исходного текста/аттрибута в конечном (2 тыка)
;;; Тыкать в Текст/Мтекст/Блок
;;; использует ktz-get-blk-attrib-ename-by-pt (ближайший к указанию аттрибут)


;;;(defun c:ktz-paste-field-old ( /
;;;			  ents			;список entsel
;;;			  ent			;ename
;;;			  ename-get		
;;;			  t-str			;текст генерируемого поля
;;;			  ID			;ID исходного примитива
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
;;;  (princ ent)
;;;
;;;
;;;
;;;  (vl-load-com)
;;;  (setq ID (vla-get-objectid (vlax-ename->vla-object ent)))
;;;  (setq	t-str (strcat "%<\\AcObjProp Object(%<\\_ObjId "
;;;		      (itoa ID)
;;;		      ">%).TextString>%"
;;;		);strcat
;;;   );setq
;;;  (princ ID)
;;;
;;;
;;;  (while (= (setq ents (entsel "\n\nкуда писать")) nil))
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
;;;  (princ ent)
;;;
;;;  
;;;  (setq ename-get (entget ent))
;;;  (setq	ename-get (subst (cons 1 t-str)
;;;			 (assoc 1 ename-get)
;;;			 ename-get
;;;		  )
;;;  )
;;;
;;;
;;;  (entmod ename-get)
;;;  (entupd (cdr (assoc -1 ename-get)))
;;;  (vl-cmdf "_updatefield" (cdr (assoc -1 ename-get)) "")
;;;  (princ)
;;;)					;defun
;;;








(defun c:ktz-paste-field (
		      /
                          ns
		      ent-from
		      ent-to
		      ename-get
		      fl		; флаг правильно выбранного объекта
		      tmp
		      str
		      ID
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
    (setq ns (nentsel "\n Укажите источник данных ... :"))
      (if ns
          (progn
              (setq ent-from (car ns)
                    tmp (cdr (assoc 0 (entget ent-from)))
                    );setq
              (if (or
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
              )
          (progn
              (acet-error-restore)
              (vla-endundomark doc)
              (exit)
              )
          )
    );while
  
  (vl-load-com)
  (setq ID (vla-get-objectid (vlax-ename->vla-object ent-from)))
  (setq	str (strcat "%<\\AcObjProp Object(%<\\_ObjId "
		      (itoa ID)
		      ">%).TextString>%"
		);strcat
   );setq
  
(setq fl nil)
  (while (setq es (nentsel "\n Укажите объект-приемник данных ... :"))
    (if (and
	  es
	  (setq ent-to (car es))
	  (member	(cdr (assoc 0 (entget ent-to)))
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
;;;
;;;
;;;(setq obj (vlax-ename->vla-object (car (entsel))))
;;;
;;;(do obj)
;;;(do
;;;  (setq txto-extdict-container
;;;	 (vla-GetExtensionDictionary obj)
;;;	)
;;;  )
;;;
;;;(vla-addobject txto-extdict-container "tst" "AcDbTableStyle")
;;;(do (vla-item txto-extdict-container 0))
;;;
;;;
;;;(setq ktzfld-dictobj-name "ktzfieldlinks")
;;;(setq ktzfld-dictobj (vla-add (vla-get-dictionaries actdoc) ktzfld-dictobj-name))
;;;(vla-addObject ktzfld-dictobj "mtxt" )
;;;
;;;(do ktzfld-dictobj)
;;;
;;;(do (vla-get-dictionaries actdoc))