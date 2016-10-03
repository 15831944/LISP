(defun ss-odd (step
	       /
	       lst
	       ss
	       i
	       )
  (setq lst (ss->list (ssget))	
	i 0
	ss (ssadd))
  (if (= 0 (rem (length lst) step))
    (progn
      (repeat (/ (length lst) step)
	(setq ss (ssadd (nth i lst) ss))
	(setq i (+ i step))
	)
      (sssetfirst nil ss)
      )
    (alert "\nНе кратное количество выбранных элементов")
    )
  );defun



;(setq step 2)
(defun list-odd (lst step / i ans)
  (setq i 0 ans '())
  (if (= 0 (rem (length lst) step))
    (repeat (/ (length lst) step)
      (setq ans (cons (nth i lst) ans))
      (setq i (+ i step))
      )
    (exit)
    )
  (reverse ans)
  );defun
