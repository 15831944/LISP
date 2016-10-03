(defun asd (
	    /
	    e
	    ss
	    )
  (setq e (car (entsel)))
  (vl-cmdf "_zoom" "_o" e "")
  (setq
    ss (ssget "_f" e "")
    )
;;;  (setq
;;;    ss (ssget "_f" (list p1 p2))
;;;    ss (ssdel e ss )
;;;    i 0)

  )