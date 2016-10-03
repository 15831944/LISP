
;13_07_18
(defun kd-container->list (objc / lst)
  (vlax-for o objc (setq lst (append lst (list o))))
  lst
  )

(defun cont>list (objc / lst)
  (vlax-for o objc (setq lst (append lst (list o))))
  lst
  )

;;;;12_09_05
;;;(defun kd-container->list (objc / lst col i)
;;;  (if (setq col (vla-get-Count objc))
;;;    (progn
;;;      (setq lst '()
;;;	    i 0)
;;;      (repeat col
;;;	(setq lst (append lst (list (vla-item objc i)))
;;;	      i (1+ i))
;;;	)
;;;      );progn
;;;    );if
;;;  lst
;;;  )
