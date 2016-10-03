(defun c:123 (/ l entg tp)
  (setq entg (entget (car (entsel))))
  (setq l '())
  (foreach tp entg
    (if (= (car tp) 10)
      (setq l (append l (cdr tp)))
      )
    )

  (princ l)
  );def