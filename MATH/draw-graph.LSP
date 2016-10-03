

(defun make-coords (Xrange
		    mc-bpt
		    /
		    pt1 pt2
		    )

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



;;;(defun func (x)
;;;  (* 5 (sin x))
;;;  );

(defun func (x)
  (abs (* 2 (sin x)))
  );

;;;(defun func (x)
;;;  (- (* 2 (cos x)) (* 2 (sin x)))
;;;  );




;;;(defun func (x)
;;;  (* x 2)
;;;  );

;;;(defun func (x)
;;;  (sqrt (abs x))
;;;  );


(defun draw-graph ( step range
		   /
		   bpt step range
		   x1 x2
		   y1 y2
		   )
  (setq bpt (getpoint "\npick a point\n"))
;;;  (setq step (getreal "\ninput step\n"))
;;;  (setq range (getreal "\ninput a range\n"))
  (make-coords range bpt)
;;;  (setq bpt (list
;;;	      (- (car bpt) (/ range 2))
;;;	      (- (cadr bpt) (func (/ range 2)))
;;;	      ))
  (setq x1	(- (/ range 2))
	y1	(func x1))
  (while (< x1 (/ range 2))
    (setq x2 (+ x1 step))
    (setq y2 (func x2))
    (entmake (list
	       '(0 . "line")
	       (cons 10 (list (+ (car bpt) x1)	(+ (cadr bpt) y1)))
	       (cons 11 (list (+ (car bpt) x2)	(+ (cadr bpt) y2)))
	       '(62 . 4)
	       ))
    (princ)
    (setq x1 x2
	  y1 y2)
    );while
  );

(draw-graph 0.1 100)