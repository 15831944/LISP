(setq e (car (entsel)))


(defun gl (e / el v)
  (setq el (entget e))
  (setq v (mapcar '- (cdr (assoc 10 el)) (cdr (assoc 11 el))))
  (sqrt (+ (* (car v) (car v))  (* (cadr v) (cadr v))))
  )

(setq ss (ss->list* (ssget '((0 . "LINE")))))


(setq l (vl-remove-if-not '(lambda (x) (= 26 (gl x))) ss))



(mapcar '(lambda (x)(setq ss1 (ssadd x ss1))) l)

