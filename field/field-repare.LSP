
; так как в основном у меня поля на содержимое текста (Content)
; то эти функции особого смысла не имеют 12_05_23


(defun c:fldr ( / ss ID)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list
			   "cmdecho" 0
			   "highlight" (getvar "highlight")
			   "limcheck" 0
			   "osmode" 0);list
			 T));acet-error-init
  (if (and
	(setq ss (ssget '((0 . "*TEXT"))))
	(setq ID (nentsel "\n=Select a new source obj..."))
	(setq ID (vlax-ename->vla-object (car ID)))
	(setq ID (vla-get-objectID ID))
	)
    (mapcar '(lambda (x)
	       (field-repare x ID)
	       ) (ss->lsto* ss))
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun



(defun c:flar ( / obj ID)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list
			   "cmdecho" 0
			   "highlight" (getvar "highlight")
			   "limcheck" 0
			   "osmode" 0);list
			 T));acet-error-init
  (if (and
	(setq obj (nentsel))
	(setq obj (vlax-ename->vla-object (car obj)))
	(setq ID (nentsel "\n=Select a new source obj..."))
	(setq ID (vlax-ename->vla-object (car ID)))
	(setq ID (vla-get-objectID ID))
	)
    (field-repare obj ID)
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun



(defun field-repare (obj srcID / str)
  (setq str (vl-string-subst
	      (strcat "_ObjId " (itoa srcID))
	      "_ObjId 0"
	      (vla-FieldCode obj)))
  (vla-put-textstring obj str)
  );defun