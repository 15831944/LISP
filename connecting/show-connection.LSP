;;; изменена 10_10_08
;;; соединяет линиями на непечатуемом слое "невидимые_аттрибуты"
;;; блоки "провод" и блоки клемм
;;; -kakt00z-™  ©
;;; круть :)
;:::			VLA-GET-ATTRIBUTES

(defun show-connection (/
			doc	;текущий чертеж
			ss	;набор проводов
			i
			fld	;ename аттрибута с полем
			owner	;блок клемма - владелец поля в аттрибуте "К_КЛЕММЕ" блока "провод"

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
(setq ss (ssget '((0 . "INSERT")))
      i 0)
  (repeat (sslength ss)
    ;(setq fld (entget (getbatt (ssname ss i) "К_КЛЕММЕ")))
    (setq fld (entget (getbatt (ssname ss i) "ADDRESS")))
      (while (and (/= "FIELD" (cdr (assoc 0 fld)))
	      (assoc 360 fld)
	      ) ;and
    (setq fld (entget (cdr (assoc 360 fld))))
    ) ;while
    (setq owner (cdr (assoc 331 (entget (cdr (assoc 360 fld))))))
    
    (entmake  (list '(0 . "LINE")
		    (cons 10 (cdr (assoc 10 (entget (ssname ss i)))))
		    (cons 11 (cdr (assoc 10 (entget owner))))
		    '(100 . "AcDbEntity")
		    ;'(370 . 60)
		    '(8 . "невидимые_аттрибуты")
		    )
	      );entmake
    (setq i (1+ i))
    );repet
  (acet-error-restore)
  (vla-endundomark doc)
  );defun

;;;
;;;
;;;(defun getbatt (bname attname
;;;	       /
;;;	       tmp
;;;	       )
;;;  (if (and (= 1 (cdr (assoc 66 (entget bname))))
;;;	   (= "INSERT" (cdr (assoc 0 (entget bname))))
;;;	   )
;;;    (progn
;;;      (setq tmp (entnext bname))
;;;      (while (and
;;;	       tmp
;;;	       (/= attname (cdr (assoc 2 (entget tmp))))
;;;	       (/= "SEQEND" (cdr (assoc 0 (entget tmp))))
;;;	       )
;;;	(setq tmp (entnext tmp))
;;;	);while
;;;      (if (and
;;;	    tmp
;;;	    (= attname (cdr (assoc 2 (entget tmp)))))
;;;	tmp
;;;	nil
;;;	);if
;;;      );progn
;;;    nil
;;;    )
;;;  );defun
;;;

;(vla-select)

(defun getbatt (
		 bobj
		 tag
		 /
		 al
		 )
  (if
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (< 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al))
      )
    (car (vl-remove-if-not '(lambda (x) (= tag (vla-get-tagstring x))) al))
    )
  );defun


;;;vla-item что не работает?
(defun getbatt* (
		 bobj
		 attname
		 /
		 al
		 i
		 )
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (> 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al))
      (setq i (vl-position attname (mapcar 'vla-get-tagstring al)))
      (nth i al)
      )
  );defun





(defun fldline (
                /
                doc
                tfobj			;text field object
                ID
                parobj
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

    (setq tfobj (vlax-ename->vla-object (car (entsel "\nchoose text object with a field..."))))
    (and
        (vlax-method-applicable-p tfobj "Fieldcode")
        (setq ID (vlax-invoke-method tfobj "Fieldcode"))
        )
    (if ID
        (progn
            (setq ID (atoi (vl-string-right-trim ">%).TextString>%" (vl-string-left-trim "%<\\AcObjProp Object(%<\\_ObjId " ID))))
            (setq parobj (vla-objectidtoobject doc ID))
            )
        )
    
    (entmake  (list '(0 . "LINE")
		    (cons 10 (vlax-safearray->list (vlax-variant-value(vla-get-InsertionPoint tfobj))))
		    (cons 11 (vlax-safearray->list (vlax-variant-value(vla-get-InsertionPoint parobj))))
		    '(100 . "AcDbEntity")
		    ;'(370 . 60)
		    '(8 . "невидимые_аттрибуты")
		    )
	      );entmake


  (acet-error-restore)
  (vla-endundomark doc)
  );defun





(vlax-dump-object
 (vla-get-Dictionaries doc)
 T)


(vlax-for any (vla-get-Dictionaries doc)
    (vlax-dump-object any)
    )

(vla-item (vla-get-Dictionaries doc) 'AcDbFieldList)


(vla-item (vla-get-Dictionaries doc) 5)
