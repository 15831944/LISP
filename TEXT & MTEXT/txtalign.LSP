
;;; недоделано

(vl-load-all)
(defun txtalign (
		 /
		 osmode
		 doc
		 ss
		 i
		 to
		 pt
		 choice
		 
		 )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init (list (list "cmdecho" 0
			       "highlight" (getvar "highlight")
			       "limcheck" 0
			       )T));acet-error-init
  (setq osmode (getvar "osmode")
	(setvar "osmode" 0)
	)
  
  ;*******************************************************************************
  (princ "\n выберите тексты...:")
  (setq ss (ssget '((0 . "*TEXT")))
	i 0)
  (setvar "osmode" osmode)
  (setq pt (getpoint "\n pick a point...:"))
  (setvar "osmode" 0)
  (initget "X Y _X Y")
  (setq choice (getkword "\n ровняем текст по ...: [x/y] <y>"))
  
  (repeat (sslength ss)
    (setq to (vlax-ename->vla-object (ssname ss i)))
    
    (vlax-safearray->list (vlax-variant-value  (vla-get-TextAlignmentPoint (vlax-ename->vla-object (car (entsel))))))
    
    (setq i (1+ i))
    )



  ;*******************************************************************************
  (setvar "osmode" osmode)
  (acet-error-restore)
  (vla-endundomark doc)
  );defun