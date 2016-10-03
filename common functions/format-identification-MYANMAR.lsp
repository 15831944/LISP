;;;****************************************************************************
;;; даёт ename линии справа от слова Format на 20 мм
;;; ent - слово Кол. уч.
(defun m-get-rightformatline<-koluch (ent
			     /
			     pt1
			     pt2
			     ss
			     en
			     )
  (setq	pt1	(list
			  (+ (car (cdr (assoc 10 (entget ent)))) (* 15 scale)) ;;;; расстояние до линии справа
			    (cadr (cdr (assoc 10 (entget ent)))) 
			)
		pt2	(list
			  (+ (car pt1) (* 5 scale))
			  (cadr pt1)
			  )
		)
  (vl-cmdf "_zoom" "_W" pt1 pt2)
  
      (setq ss (ssget "_C" pt1 pt2))
  
      (if (= 1 (sslength ss))
	(setq en (ssname ss 0))
	(progn
	  (ktz-show-error
	    (cons 10 pt1)
	    "\nлинии рамки формата дублируются или отсутствуют\nнужно сделать чтобы рамка была нарисована 4-мя отрезками"
	    ) ;_ конец ktz-show-error
	  (exit)
	  );progn
	);if
     en
  ;(command "_Line" pt1 pt2 "")
);defun

