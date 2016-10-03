(defun c:fd ( / ss fltr)
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		) T));acet-error-init
  
  (setq fltr '((-4 . "<OR")
	       (0 . "*TEXT")
	       (0 . "ATTDEF")
	       (0 . "INSERT")
	       (0 . "MULTILEADER")
	       (-4 . "OR>")))
  
  (setq ss (ssget "_I" fltr))
  (if (null ss) (setq ss (ssget fltr)))
  
  (setq ss (mapcar 'vlax-ename->vla-object (ss->list* ss)))
  (setq ss (vl-remove-if '(lambda (x)
			    (and
			      (= "AcDbBlockReference" (vla-get-ObjectName x))
			      (= :vlax-false (vla-get-HasAttributes x)))
			    ) ss))
  (mapcar 'delete-field ss)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun

;;;;; см clean.lsp
;(defun delete-field (obj / str)
;  (if (and (= "AcDbBlockReference" (vla-get-ObjectName obj)) (= :vlax-true (vla-get-HasAttributes obj)))
;    (mapcar 'delete-field (vlax-safearray->list (vlax-variant-value (vla-GetAttributes obj))))
;    (progn
;      ;(setq str (vla-get-TextString obj))
;      (setq str (cdr (assoc 1 (entget (vlax-vla-object->ename obj)))))
;      (vla-put-textstring obj "dsf")
;      (vlax-put-property obj "TextString" str)
;      )
;    )
;  );defun


(defun delete-field (obj / str)
  (if (and (= "AcDbBlockReference" (vla-get-ObjectName obj)) (= :vlax-true (vla-get-HasAttributes obj)))
    (mapcar 'delete-field (vlax-safearray->list (vlax-variant-value (vla-GetAttributes obj))))
    (progn
      (setq str (entget (vlax-vla-object->ename obj)))
      (setq str (eval (cons 'strcat (mapcar 'cdr (vl-remove-if-not '(lambda (x) (member (car x) '(3 1))) str)))))
      (vla-put-textstring obj "dsf")
      (vlax-put-property obj "TextString" str)
      )
    )
  );defun



(defun dfia (tag / ss)
  (setq ss (ssget "_I" '((0 . "INSERT"))))
  (if (null ss) (setq ss (ssget '((0 . "INSERT")))))
  (mapcar
    '(lambda (x)
       (delete-field-in-att x tag)
       )
    (ss->lsto* ss)
    )
  )

(defun delete-field-in-att (obj tag / att str)
  (setq att (getbatt obj tag))
  (delete-field att)
  );defun


