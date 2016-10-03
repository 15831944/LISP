

;;; y = f(x) = Vx-1

(setq x0 0
      xend 20
      step 1)

(defun func (x)
  (- (expt x 0.5) 1)
  )




(defun make-data ( / x xrange)
  (setq x X0)
  (setq xrange '())
  (while (<= x xend) (setq xrange (cons x xrange) x (+ x step)))
  (reverse xrange)
  );defun

(setq datalist (mapcar 'func (make-data)))
       
(draw-graph datalist)








(defun draw-graph (lst /
		   bpt step range
		   x1 x2
		   y1 y2
		   )
  (setq bpt (getpoint "\npick a point\n"))
  (setq range (length lst))
  (make-coords range bpt)
  (setq x1	0
	y1	(nth x1 lst))
  (repeat (1- (length lst))
    (setq x2 (1+ x1))
    (setq y2 (nth x2 lst))
    (entmake (list
	       '(0 . "line")
	       (cons 10 (list (+ (car bpt) x1)	(+ (cadr bpt) y1)))
	       (cons 11 (list (+ (car bpt) x2)	(+ (cadr bpt) y2)))
	       '(62 . 4)
	       ))
    (princ)
    (setq x1 (1+ x1)
	  y1 y2)
    );while
  );



(defun make-coords (Xrange mc-bpt / pt1 pt2)
  ;;; ============  Îñü Õ  =========================
  (setq pt1 (list (- (car mc-bpt) (/ Xrange 2)) (cadr mc-bpt)))
  (setq pt2 (list (+ (car mc-bpt) (/ Xrange 2)) (cadr mc-bpt)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (setq pt1 (list (- (car pt2) 5)  (+ (cadr pt2) 1)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (setq pt1 (list (- (car pt2) 5)  (- (cadr pt2) 1)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (entmake (list (cons 0 "TEXT")(cons 10 pt2)(cons 40 2.5)(cons 1 "X")))
  ;;; ============  Îñü Y  =========================
  (setq pt1 (list (car mc-bpt) (- (cadr mc-bpt) (/ Xrange 2))))
  (setq pt2 (list (car mc-bpt) (+ (cadr mc-bpt) (/ Xrange 2))))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (setq pt1 (list (- (car pt2) 1)  (- (cadr pt2) 5)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (setq pt1 (list (+ (car pt2) 1)  (- (cadr pt2) 5)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (entmake (list (cons 0 "TEXT")(cons 10 pt2)(cons 40 2.5)(cons 1 "Y")))
  );defun





