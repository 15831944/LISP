;;  14_11_13




(defun c:fd ( / lst fltr)
  (setq non-removal-field-tags '("FORMATNAME" "FORMAT_NAME"))
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0 ) T))
  (setq fltr '((-4 . "<OR") (0 . "*TEXT") (0 . "ATTDEF") (0 . "INSERT") (0 . "MULTILEADER") (-4 . "OR>")))

  (if (not (setq lst (ssget "_I" fltr)))
    (setq lst (vl-catch-all-apply 'ssget (list fltr)))
    )
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type lst))
     (princ (strcat "\n" (VL-CATCH-ALL-ERROR-MESSAGE lst)))
    )
    ((null lst) nil)
    ((= 'PICKSET (type lst))
     (setq lst (ss->lsto* lst))
     (mapcar 'delete-field lst)
     )
    (T nil)
    );comd error
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun


(defun c:fd1 ( / ss fltr)
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0 ) T))
  (delete-field (vlax-ename->vla-object (car (nentsel))))
  (acet-error-restore)	
  (vla-endundomark #actdoc)
  );defun

;(setq obj (vlax-ename->vla-object (car (entsel))))
(defun delete-field (obj / str string-replace)
  (defun string-replace (obj / str)
    (setq str (kd-get-textstring obj))
    ;(setq str (entget (vlax-vla-object->ename obj)))
    ;(setq str (eval (cons 'strcat (mapcar 'cdr (vl-remove-if-not '(lambda (x) (member (car x) '(3 1))) str)))))
    (vla-put-textstring obj "#delete-field#tempstring#")
    (vlax-put-property obj "TextString" str)
    );defun
  (cond
    ((and (= "AcDbBlockReference" (vla-get-ObjectName obj)) (= :vlax-true (vla-get-HasAttributes obj)))
     (mapcar 'delete-field (vlax-safearray->list (vlax-variant-value (vla-GetAttributes obj))))
     )
    ((and (= "AcDbAttribute" (vla-get-objectname obj)) (null (member (vla-get-TagString obj) non-removal-field-tags)))
     (string-replace obj)
     )
    ((member (vla-get-ObjectName obj) '("AcDbMLeader" "AcDbText" "AcDbMText"))
     (string-replace obj)
     )
    );cond
  );defun





