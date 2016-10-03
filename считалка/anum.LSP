(defun anum (
	     /
	     doc
	     ss
	     str
	     mask

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


  (setq ss (mapcar 'vlax-ename->vla-object (ss->list (ssget))))
  (setq mask '())

  (foreach item ss
    (setq str (VL-STRING->LIST (vla-get-TextString
				 ;;item
				 (car ss)
				 )))
    (foreach ch str
      (cond
	((and (> 47 ch)(< 58 ch))(setq mask (append)))
	)
      )
    )
  



  (acet-error-restore)
  (vla-endundomark doc)
  
  );defun

