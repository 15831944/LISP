;;;
;;;(setq n 1.536 q 0.01)
;;;(setq n 2.35 q 1)
;;;
;;;
;;;
;;;(defun math-round (n q
;;;		   /
;;;		   )
;;;  
;;;  )
;;;(setq n 45.4)

(defun math-fix (n)
  (if (< (- n (fix n)) 0.5)
    (fix n)
    (1+ (fix n))
    )
  )

;(math-fix 534.45)