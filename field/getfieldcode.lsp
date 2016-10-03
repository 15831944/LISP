;;;; 14_03_28
;	(if (null kd:getfieldcode) (load (strcat #lisppath "field\\getfieldcode.lsp")))

;(kd:getfieldcode obj)
;(kd:getfieldcode (vlax-ename->vla-object (car (nentsel))))
;;;   возвращает список - структуру записи текстовой строки с полями
;;   вида (текст1 поле1 текст2 поле2. ...), где
;;;  поле - ename элемента "FIELD"

;(setq obj (getbatt (vlax-ename->vla-object (car (entsel))) "$MARKSHKAF"))
;(kd:getfieldcode (getbatt (vlax-ename->vla-object (car (entsel))) "OWNER"))
(defun kd:getfieldcode (obj /
			exd
			fldsdict
			field
			fieldeng
			fieldmask
			fields
			fieldcodes
			)
  ;(setq obj (vlax-ename->vla-object (car (nentsel))))
  ;(setq obj (getbatt (pickobj) "LOCFLD"))
  ;DICTIONARY
  (if
    (and
      (= :vlax-true (vla-get-HasExtensionDictionary obj))
      (setq exd (vla-GetExtensionDictionary obj))
      (member "ACAD_FIELD" (mapcar 'vla-get-name (cont>list exd)))
      (setq fldsdict (vla-item exd "ACAD_FIELD"))
      )
    (progn
      (setq field (vla-item fldsdict 0))
      (setq fieldeng (entget (vlax-vla-object->ename field)))
      (setq fieldmask (cdr (assoc 2 fieldeng)))
      ;(sepstr fieldmask "%")
      (setq fields (mapcar 'cdr (vl-remove-if-not '(lambda (pp) (= 360 (car pp))) fieldeng)))
      (setq fieldcodes
      (mapcar
	'(lambda (x / engx ten)
	   ;(setq x (nth 0 fields))
	   (setq engx (entget x))
	   (cond
	     ((= "AcVar" (cdr (assoc 1 engx)))
	      (strcat "%<" (cdr (assoc 2 engx)) ">%")
	      )
	     ((= "AcObjProp" (cdr (assoc 1 engx)))
	      (setq ten (cdr (assoc 331 engx)))
	      (if (entget ten)
		(vl-string-subst
		  (strcat "\\_ObjId " (itoa (vla-get-ObjectID (vlax-ename->vla-object ten))))
		  "\\_ObjIdx 0"
		  (strcat "%<" (cdr (assoc 2 engx)) ">%")
		  )
		(vl-string-subst (strcat "\\_ObjId 0") "\\_ObjIdx 0" (strcat "%<" (cdr (assoc 2 engx)) ">%"))
		)
	      )
	     )
	   )
	fields))
      (apply
	'strcat
	(mapcar
	  '(lambda (x)
	     ;(setq x (nth 1 (sepstr fieldmask "%")))
	     (if (wcmatch x "<\\_FldIdx*")
	       (nth (atoi (vl-string-left-trim "<\\_FldIdx " (vl-string-trim "<>" x))) fieldcodes)
	       x
	       )
	     )
	  (sepstr fieldmask "%")
	  )
	)
      )
    (kd-get-textstring obj)
    )
  );defun