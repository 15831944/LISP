
;;;;
;; вставляем разделитель строки после последней цифры в MTEXTе


(setq txtlst (ss->lsto* (ssget '((0 . "*TEXT")))))


(mapcar '(lambda (x)
	   (vla-put-textstring x (transl (vla-get-textstring x)))
	   )
	txtlst)




(defun transl (str / stl i nstr bylo)
  (setq stl (vl-string->list str) nstr '() bylo nil)
  (setq i (1- (length stl)))
  (while (>= i 0)
    (if (and
	  (null bylo)
	  (and
	    (<= (nth i stl) 57)
	    (>= (nth i stl) 48)
	    )
	  )
      (progn (setq bylo T)
	(setq nstr (append nstr (list 80 92)))
	)
      )
    (setq nstr (append nstr (list (nth i stl))))
    (setq i (1- i))
    )
  (vl-list->string (reverse nstr))
  );defun


