(defun asd (pt1 pt2
	      /
	      ss
	      str
	      i
	      )
(setq ss (ssget "_C" pt1 pt2)
      i	0
      str	"")
  (repeat (sslength ss)
    (setq str (strcat "\n" (cdr (assoc 0 (entget (ssname ss i))))))
    (princ str)
    (setq i (1+ i))
    )
  (princ "\n")
  (princ i)
  );defun
grread