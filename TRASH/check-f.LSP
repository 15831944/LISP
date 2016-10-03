;;; проверяет совпадение координат двух параллельных отрезков
;;; и выдает 2 точки рамки формата, если совпадают
(defun check-f (pare / en1 en2 pt1 pt2)

  (setq	en1 (car pare)
	en2 (cadr pare)
  )
  (if (and (= (car (tp 10 en1))
	      (car (tp 10 en2))
	   );=
	   (= (car (tp 11 en1))
	      (car (tp 11 en2))
	   );=
      );and
    (setq pt1 (tp 10 en1)
	  pt2 (tp 11 en2)
    )

    (if	(and (=	(car (tp 10 en1))
		(car (tp 11 en2))
	     );=
	     (=	(car (tp 11 en1))
		(car (tp 10 en2))
	     );=
	);and
      (setq pt1	(tp 10 en1)
	    pt2	(tp 10 en2)
      )

      (prompt "\nнесовпадают линии рамки")
    );if
  );if
  (list pt1 pt2)
);defun

