;expt

(defun math-power (x p)
  (if (= p 0)
    1
    (* (math-power x (1- p)) x)
    )
  )
  
  (princ "\nexpt")