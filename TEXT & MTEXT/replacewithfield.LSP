; 13_12_10

(if (null sepstr) (load (strcat #lisppath "strings\\stringlib.lsp")))



(defun c:rwf ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0
			       "highlight" (getvar "highlight")
			       "limcheck" 0
			       "osmode" 0) T))
  (replacewithfield)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun



(defun replacewithfield	( / obj lst separ)
  ;(setq separ ".")
  (setq separ "-")
  (setq obj (vlax-ename->vla-object (car (nentsel "\n”кажите источник пол€: ... "))))
  (princ "\n”кажите тексты дл€ вставки пол€: ... ")
  (setq lst (ss->lsto* (ssget '((0 . "*TEXT")))))
  (mapcar
    '(lambda (x / adr)			;(setq x (vlax-ename->vla-object (car (entsel))))
       (setq adr (sepstr (vla-get-TextString x) separ))
       (if (= (vla-get-TextString obj) (car adr))
	 (progn
	   (vla-put-TextString x "")
	   (vla-put-TextString
	     x
	     (strcat
	       "%<\\AcObjProp Object(%<\\_ObjId "
	       (itoa (vla-get-ObjectID obj))
	       ">%).TextString>%"
	       (if (cadr adr)
		 (strcat separ (cadr adr))
		 ""
	       )
	     )
	   )
	 )
       )
     )
    lst
  )
)