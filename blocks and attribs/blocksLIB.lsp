
;; 16_02_18


;(ss:getBRefs '("RU_format"))
;(setq bnames '("RU_format"))
;(setq bnames '("*"))

(defun ss:getBRefs (bnames / lst)
  (if (or (null bnames) (equal bnames '("*")))
    (progn
      (if (null (setq lst (ssget "_I" (list '(0 . "INSERT")))))
	(setq lst (ssget (list '(0 . "INSERT"))))
	)
      (setq lst (ss->lsto* lst))
      )
    (progn
      (if (null (setq lst (ssget "_I" (list '(0 . "INSERT") (cons 2 (antisep (cons "`*U*" bnames) ","))))))
	(setq lst (ssget (list '(0 . "INSERT") (cons 2 (antisep (cons "`*U*" bnames) ","))))))
      (setq lst (ss->lsto* lst))
      (setq lst (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) bnames)) lst))
      )
    )
  lst
  );defun