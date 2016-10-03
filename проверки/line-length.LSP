(defun as (
	   /
	   ss
	   i
	   l
	   e
	   )
  
  (setq ss (ssget)
	i 0
	l 0)
  
  (repeat (sslength ss)
    (setq e (entget (ssname ss i)))
    (setq l (+ l (distance (cdr (assoc 10 e))
			   (cdr (assoc 11 e)))))
    (setq i (1+ i))
    );repeat
  (princ l)
  (princ)
  );defun