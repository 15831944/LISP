(defun c:ktz-line-length (
		      /
		      lent	;лини€
		      lentg	;entget линии
		      l		;длина линии
		      ln	;нужна€ длина линии
		      p10	; т.п. 10
		      p11	; т.п. 11
		      p11n	; т.п. 11 нова€
		      x
		      y
		      )
  (setq lent	(car (entsel "\nукажите отрезок"))
	lentg	(entget lent)
	p10	(cdr (assoc 10 lentg))
	p11	(cdr (assoc 11 lentg))
	l	(distance p10 p11)
	x	(- (car p10) (car p11))
	y	(- (cadr p10) (cadr p11))
	);setq

  
  (setq ln (getreal "\nукажите нужную длину линии"))

  (setq
    x (/ (* x ln) l)
    y (/ (* y ln) l)
   ; z (/ (* z ln) l)
    );setq

  (setq p11n (cons 11 (list
			(- (car p10) x)
			(- (cadr p10) y)
			;(+ (caddr p10) z)
			)))

  (setq lentg (subst p11n (cons 11 p11) lentg))
  (entmod lentg)
  (entupd lent)
  );defun