(defun concat (lst1 lst2)
  (
   (lambda (frec) (frec (reverse lst1) lst2))
    (lambda (lst1 lst2)
      (if lst1
	(frec (cdr lst1) (cons (car lst1) lst2))
	lst2)
      )
    )
  );defun