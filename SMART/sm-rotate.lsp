;; начало 13_03_21
;; smart rotate

(defun c:smR ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (sm:rotate)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  )


(defun sm:rotate ( / ss)
  (if (not (setq ss (ssget "_I")))
    (setq ss (ssget))
    );if
  (cond
    (()())
    (T (command "_rotate" ss ""))
    )
  );defun