(defun www (
	    /
	    e
	    lst
	    i
	    )
  (setq lst '()
	e (entnext)
	i 0
	)
  (while e
    ;(if (= "коро" (cdr (assoc 8 (entget e))))
    (if (= "невидимые_аттриуты" (cdr (assoc 8 (entget e))))
      (setq lst (append lst (list e)))
      );if
    (setq e (entnext e)
	  i (1+ i))
    );while
  lst
  );defun


;(command "_zoom" "_o" (nth 1 (www)) "")