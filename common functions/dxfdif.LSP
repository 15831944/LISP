(defun dxfdif (
	       /
	       eg1
	       eg2
	       lst
	       )
  (setq eg1 (entget (car (entsel)))
	eg2 (entget (car (entsel)))
	lst '())
  (foreach item eg1
    (if
      (equal item
	  (assoc (car item) eg2))
      (princ)
      (setq lst (append lst (list item)))
      )
    )
  lst
  );defun
