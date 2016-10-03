

;;; выбор ближайшего значения из ряда
(defun get-closer-from-row (val row / condidatelist tmp)
  (if (and
	val row
	(setq condidatelist (mapcar '(lambda (x) (abs (- val x))) row))
	(setq tmp (eval (append '(min) condidatelist)))
	(setq tmp (nth (vl-position tmp condidatelist) row))
	)
    tmp
    )
  );defun


;;; выбор по таблице вида:
;;; 	(	(x1	x2	x3 ...)
;;; 	(y1	(#	#	#  ...))
;;; 	(y2	(#	#	#  ...))
;;; 	(y3	(#	#	#  ...))
;;; 	...
;;;	)


(defun get-closer-from-table (x y lst)
  (nth
    (vl-position (get-closer-from-row x (car lst)) (car lst))
    (cadr
      (assoc
	(get-closer-from-row y (mapcar 'car (cdr lst)))
	(cdr lst)))
    )
  );defun

