;;; 14_02_26
;;; XDlib.lsp
;(load (strcat #lisppath "XDictionaries\\XDictlib.LSP"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; функция
;(setq dict #dict)
;(setq dict nil)		CDO
(defun XD|getnames (dict / i lst)
  (cond
    (
     (member (vla-get-objectname dict) '("AcDbDictionary" "AcDbDictionaryWithDefault"))
     (setq i -1)
     (setq lst (mapcar 'cdr (vl-remove-if-not '(lambda (x) (= 3 (car x))) (entget (vlax-vla-object->ename dict)))))
     (mapcar
       '(lambda (x)
	  (setq i (1+ i))
	  (if (vlax-property-available-p x "Name")
	    (vla-get-name x)
	    (nth i lst)
	    )
	  )
       (cont>list dict)
       )
     )
    (T nil)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq mask "KFL_REC_")
;(setq )
(defun XD|nextname (dict / mask names lastnumber)
  (setq names (XD|getnames dict))
  (cond
    ((and names (member "IDMASK" names))
     (setq mask (car (XD|XR|getdata (vla-item dict "IDMASK"))))
     (setq names (vl-remove-if-not '(lambda (x) (wcmatch x (strcat mask "*"))) names))
     (setq lastnumber (apply 'max (mapcar '(lambda (x) (atoi (vl-string-left-trim mask x))) names)))
     (strcat mask (itoa (1+ lastnumber)))
     )
    (T nil)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; в таких словарях как ACAD_FIELDLIST, ACAD_GROUP нет свойства vla-get-name, хотя item работает
(defun XD|dictgetbyname (dict name) (vla-item dict name))

;(setq path "PE_DATABASE\\PEDB_LOOPS")
;(setq path "PE_DATABASE\\PEDB_LOOPS\\MASK")
(defun XD|get (path / lst cdict)
  (setq cdict (vla-get-Dictionaries (vla-get-activedocument (vlax-get-acad-object))))
  (setq lst (sepstr path "\\"))
  (foreach dname lst	;(setq dname (cadr lst))
    (if (member dname (XD|getnames cdict))
      (setq cdict (vla-item cdict dname))
      )
    )
  cdict
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(XD|dictdivide oexd)
; разбивает на разные списки типы объектов в словаре - словари, записи, - и остальную хрень
(defun XD|dictdivide (dict / lst)
  (setq lst '())
  (vlax-map-Collection dict
    '(lambda (x / tmp)
       (if (setq tmp (assoc (vla-get-ObjectName x) lst))
	 (setq lst (subst (append tmp (list x)) tmp lst))
	 (setq lst (append lst (list (list (vla-get-ObjectName x) x))))
	 )))
  lst
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;   interface : xrHANDLE XR xrNAME xrVAL
(defun XD|XR|add (dict val / name xr)
  (setq name (XD|nextname dict))
  (setq xr (vla-AddXRecord dict name))
  (XD|XR|setdata xr val)
  (list (vla-get-handle xr) xr name val)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun XD|XR|setdata (xrec val / sa1 sa2)
  (cond
    ((and (= "AcDbXrecord" (vla-get-ObjectName xrec)) (listp val))
     (setq sa1 (vlax-safearray-fill
		 (vlax-make-safearray vlax-vbInteger (cons 0  (1- (length val))))
		 (mapcar
		   '(lambda (x)
		      (cond
			((= (type x) 'STR) 301)
			((= (type x) 'INT) 451)
			((= (type x) 'REAL) 140)
			))
		   val)
		 ))
     (setq sa2 (vlax-safearray-fill
		 (vlax-make-safearray vlax-vbvariant (cons 0 (1- (length val))))
		 val))
     (vla-SetXRecordData xrec sa1 sa2)
     )
    (T (princ "\nkd:setxrecdata : value must be a list"))
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(kd:getxrecdata xr)
;(XD|XR|getdata (vla-item (vla-item (vla-get-Dictionaries #actdoc) "KD_FIELD_LINKS") "MASK"))
;(XD|XR|getdata (vla-item (vla-item (vla-get-Dictionaries #actdoc) "KD_FIELD_LINKS") "INTERFACE"))
;(XD|XR|getdata (vla-item (vla-item (vla-get-Dictionaries #actdoc) "KD_FIELD_LINKS") "KFL_REC_50"))
(defun XD|XR|getdata (xrec / sa1 sa2)
  (cond
    ((= "AcDbXrecord" (vla-get-ObjectName xrec))
     (vla-getXrecordData xrec 'sa1 'sa2)
     (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
     )
    (T
     (princ (strcat "\n" (vla-get-ObjectName xrec) " is not a " "AcDbXrecord" "\n"))
     (exit)
     )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(princ)