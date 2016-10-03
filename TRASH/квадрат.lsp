
(defun c:kva ()
  (Setq pt (getpoint "\n Введите точку вставки")
        l2 (/ (getdist "Ширина = " ) 2)
        h2 (/ (getdist "Высота = " ) 2)
  )

  (setq p1 (list  (- (car pt) l2)  (+ (cadr pt) h2)  0)
        p2 (list  (+ (car pt) l2)  (- (cadr pt) h2)  0)
  )

  (setq p12 (list (car p2) (cadr p1) 0)  
        p21 (list (car p1) (cadr p2) 0)
  )



  (command "_pline" p1 p12 p2 p21 "_c")  


  ;  (command "_pline" p1 (list (car p2) (cadr p1)) p2 (list (car p1) (cadr p2))"_c")

 ); end kva