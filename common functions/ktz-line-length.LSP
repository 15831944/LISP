(defun c:ktz-line-length (
		      /
		      lent	;�����
		      lentg	;entget �����
		      l		;����� �����
		      ln	;������ ����� �����
		      p10	; �.�. 10
		      p11	; �.�. 11
		      p11n	; �.�. 11 �����
		      x
		      y
		      )
  (setq lent	(car (entsel "\n������� �������"))
	lentg	(entget lent)
	p10	(cdr (assoc 10 lentg))
	p11	(cdr (assoc 11 lentg))
	l	(distance p10 p11)
	x	(- (car p10) (car p11))
	y	(- (cadr p10) (cadr p11))
	);setq

  
  (setq ln (getreal "\n������� ������ ����� �����"))

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