;;;рисунко надо располагать справа снизу от нулевой точки чертежа - как от
;;; верхнего левого края окнаm
;;;  то есть в четверти где угол 270...0

(defun vector_im (/)
  (vl-sort
    (mapcar
      (function
	(lambda	(x)
	  (list
	    (abs (atoi (rtos (car (cdr (assoc 10 x))) 2 0)))
	    (abs (atoi (rtos (cadr (cdr (assoc 10 x))) 2 0)))
	    (abs (atoi (rtos (car (cdr (assoc 11 x))) 2 0)))
	    (abs (atoi (rtos (cadr (cdr (assoc 11 x))) 2 0)))
	    (if	(assoc 62 x)
	      (cdr (assoc 62 x))
	      250
	    )
	  )
	)
      )
      (mapcar 'entget
	      (vl-remove-if-not
		'(lambda (x) (= (type x) 'ENAME))
		(mapcar 'cadr (ssnamex (ssget '((0 . "LINE")))))
	      )
      )
    )
    (function (lambda (x y) (/= (cadddr (cdr x)) 250)))
  )
)


;(vector_im)

;(list (GETPOINT)(GETPOINT)(GETPOINT))

;(atoi (rtos (cadr (cdr (assoc 10 (entget (car (entsel)))))) 2 0))