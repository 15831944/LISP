


(defun calcdepth (lst / tmp)
  (defun asd (x)
    (if
      (atom x)
      0
      (+ 1 (apply 'max (mapcar 'asd x)))
      )
    )
  (setq tmp )
)


(defun calcdepth (x)
  (if
    (listp x)
    (+ 1 (apply 'max (mapcar 'asd x)))
    0
    )
  );defun
  


(calcdepth '(d
	     (a (b) (c (d))
	      )
	     )
  )




(asd '(1 2 '(3)  '(3) '(3 '( 2 '(5 nil) 2)  2) 2   '(2 '(3) 1)))

(asd lst)

(asd 1)
(asd '(1))
(asd '('(1)))
(asd '(nil 2 '(33) 1 ))


(setq lst '(1 2 3 4))
lst


(defun push (lst / tsl)
  (setq tsl (reverse lst))
  (cons (car tsl) (reverse (cdr tsl)))
  )

(defun pull (lst)
  (append (cdr lst) (list (car lst)))
  )

(append (cdr lst) (list (car lst)))

(setq lst (push lst))