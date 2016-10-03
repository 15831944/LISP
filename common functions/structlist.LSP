;;; 13_02_28
;;; pts - 1d-list
;;; stl - 2d-list
;;; k - кратность

(defun structlist (pts k / i stl line)
  (= 'INT (type (/ (length pts) k)))
  (setq i 1)
  
  (foreach item pts
    (if (= i (1+ k))
      (progn
	(setq stl (append stl (list line)))
	(setq line (list item))
	(setq i 1)
	)
      (setq line (append line (list item)))
      )
    (setq i (1+ i))
    )
  (append stl (list line))
  )
