(defun c:kva ()
  (Setq pt (getpoint "\n Введите точку вставки"))
  (setq l2 (/ (getdist "Ширина = " ) 2))
  (setq h2 (/ (getdist "Высота = " ) 2))

  (setq p1 (list  (- (car pt) l2)  (- (cadr pt) h2)  ))
  (setq p2 (list  (+ (car pt) l2)  (+ (cadr pt) h2)  ))

 
  (command "_pline" p1 (list (car p2) (cadr p1)) p2 (list (car p1) (cadr p2))"_c")

 ); end kva