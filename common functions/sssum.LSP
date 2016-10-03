;;; функция консолидации наборов

;(setq ss1 (ssget))
;(setq ss2 (ssget))

(defun sssum (ss1 ss2
	      /
	      lst
	      ss
	      )
  (setq lst (ss->list* ss1)
	lst (append lst (ss->list* ss2))
	ss (ssadd))
  (mapcar '(lambda (x) (ssadd x ss)) lst)
  ss
  );defun

;(setq ss (sssum ss1 ss2))