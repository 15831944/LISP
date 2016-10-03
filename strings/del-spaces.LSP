;;; прога удаляет из текста пробелы


(defun del-spaces (e
		   /
		   eg
		   str
		   strn
		   )
  (setq ;e (car (entsel))
	eg (entget e)
	str (cdr (assoc 1 eg))
	str (vl-string->list str)
	strn '())
  ;(princ str)
  (foreach char str
    (if (/= 32 char)
      (setq strn (append strn (list char)))
      )
    )
  ;(princ strn)

  (setq eg
  (subst
    (cons 1 (vl-list->string strn))
    (assoc 1 eg)
    eg
    )
	)
  (entmod eg)
  (entupd e)
  );defun


(defun ss-del-spaces (
		      /
		      ss
		      i
		      )
  (setq ss (ssget)
	i 0)
  (repeat (sslength ss)
    (del-spaces (ssname ss i))
    (setq i (1+ i))
    )
  
  );defun



;(kd|del-spaces* (vlax-ename->vla-object (car (entsel))))

;(mapcar 'kd|del-spaces* (ss->lsto* (ssget '((0 . "*TEXT")))))



(defun kd|del-spaces* (obj)
  (vla-put-TextString obj (str|del-spaces* (kd-get-TextString obj)))
  )
(defun str|del-spaces* (str / lst)
  (setq lst (vl-string->list str))
  (defun dsp (lst) (if (= 32 (car lst)) (dsp (cdr lst)) lst))
  (setq lst (dsp (vl-string->list str)))
  (setq lst (reverse (dsp (reverse lst))))
  (vl-list->string lst)
  )