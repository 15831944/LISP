
(defun do (obj)(vlax-dump-object obj T))



(defun cdo (dicts / i)
  (setq i -1)
  (mapcar
    '(lambda (x)
       (princ "\n")
       (princ (strcat (itoa (setq i (1+ i))) "\t"))
       (if (vlax-property-available-p x "name")
	 (princ (vla-get-name x))
	 (princ (strcat (vla-get-ObjectName x) " = "   (cdr (nth (+ 6 (1+ (* 2 i))) (entget (namedobjdict))))))
	 )
       (princ "\t")
       (if (vlax-property-available-p x "Count")
	 (princ (vla-get-Count x))
	 (princ "nil")
	 )
       )
    (kd-container->list dicts)
    )
  (princ)
  );defun



;;;(defun cdo (obj)
;;;  (vlax-for i obj
;;;    (princ (strcat "\n"(vla-get-name i)))
;;;    )
;;;  )