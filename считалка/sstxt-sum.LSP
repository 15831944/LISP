(defun c:sts (
                  /
                  ss
                  i
                  sum
                  )
    (setq ss (ssget '((0 . "TEXT")))
          i 0
          sum 0)
    (repeat (sslength ss)
        (setq sum (+ sum (atoi (cdr (assoc 1 (entget (ssname ss i)))))))
        (setq i (1+ i))
        )
    sum
    );defun