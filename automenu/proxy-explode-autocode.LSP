(defun c:testal () (princ "\n loaded"))
(while (setq ss (ssget "_X" '((0 . "*PROXY*"))))
  (command "_explode" ss)
  )
  (princ "\nproxy-explode подгружено")
  