
;(getbatt (vlax-ename->vla-object (car (entsel))) "ADDRESS1")
;(setq bobj (vlax-ename->vla-object (car (entsel))))
;(setq tag "ADDRESS1")
(defun getbatt (bobj tag / al sc *tag i)
  (if
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (<= 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al))
      )
    (progn
      (setq al (vl-remove-if-not '(lambda (x) (member (vla-get-tagstring x) (list tag (strcase tag)))) al))
      (cond
	((= 1 (length al)) (car al))
	;((null al) (exit))
	;(T (exit))
	;((> (length al) 1) al)
	(T nil)
	)
      )
    )
  );defun



(defun getbatts (bobj tags / bal return)
  (if
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq bal (vlax-variant-value (vla-getattributes bobj)))
      (< 0 (vlax-safearray-get-u-bound bal 1))
      (setq bal (vlax-safearray->list bal))
      )
    (foreach item tags
      (setq return (append return (vl-remove-if-not '(lambda (x) (= (vla-get-tagstring x) item)) bal)))
      )
    )
  return
  );defun



(defun getbattswcmatch ( bobj str / al)
  (if
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (<= 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al))
      )
    (vl-remove-if-not
      '(lambda (x)
	 (wcmatch (vla-get-tagstring x) (strcat str "," (strcase str)))
	 )
      al)
    )
  );defun