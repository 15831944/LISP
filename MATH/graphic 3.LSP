


(defun func|encount (func Xrange / x arglst)
  (setq x (cadr Xrange))
  (setq arglst '())
  (while (<= x (caddr Xrange)) (setq arglst (cons x arglst) x (+ x (car Xrange))))
  (mapcar '(lambda (x) (list x (apply func (list x)))) (reverse arglst))
  );defun


(defun drawbase (bpt datarange / obj)
  (setq Xmax (* 1.4 (apply 'max (cons 1 (mapcar 'car datarange)))))
  (setq Xmin (* 1.4 (apply 'min (cons -1 (mapcar 'car datarange)))))
  (setq Ymax (* 1.4 (apply 'max (cons 1 (mapcar 'cadr datarange)))))
  (setq ymin (* 1.4 (apply 'min (cons -1 (mapcar 'cadr datarange)))))
  
  (setq obj (vla-addline #modspace
    (vlax-3d-point (mapcar '+ bpt (list Xmin 0 0)))
    (vlax-3d-point (mapcar '+ bpt (list Xmax 0 0)))
    )) (vlax-put-property obj "color" 250)
  (setq obj (vla-InsertBlock #modspace
    (vlax-3d-point (mapcar '+ bpt (list Xmax 0 0)))
    (strcat #lisppath "!blocking\\arrow.dwg")
    1 1 1 0)) (vlax-put-property obj "color" 250)
  (setq obj (vla-addline #modspace
    (vlax-3d-point (mapcar '+ bpt (list 0 Ymin 0)))
    (vlax-3d-point (mapcar '+ bpt (list 0 Ymax 0)))
    )) (vlax-put-property obj "color" 250)
  (setq obj (vla-InsertBlock #modspace
    (vlax-3d-point (mapcar '+ bpt (list 0 Ymax 0)))
    (strcat #lisppath "!blocking\\arrow.dwg")
    1 1 1 (* pi 0.5))) (vlax-put-property obj "color" 250)
  (mapcar
    '(lambda (p) (entmake (list (cons 0 "TEXT") (cons 10 (mapcar '+ bpt p))(cons 40 2.5)(cons 1 (VL-PRIN1-TO-STRING p)))))
    (vl-remove-if-not '(lambda (pt) (= (apply '* pt) 0)) datarange)
    )
  );defun



(defun drawgraph-spline (bpt 2Ddatarange / obj ptdata fitPoints startTan endTan)
  (setq startTan (vlax-3d-point 0 0 0) endTan (vlax-3d-point 0 0 0))
  (setq ptdata (apply 'append (mapcar '(lambda (p) (mapcar '+ bpt (append p '(0.0)))) 2Ddatarange)))
  (setq fitPoints (vlax-make-safearray vlax-vbDouble (cons 0  (1- (length ptdata)))))
  (vlax-safearray-fill fitPoints ptdata)
  (setq obj (vla-AddSpline #modspace fitPoints startTan endTan))
  (vlax-put-property obj "color" 4)
  );defun

(defun drawgraph-pline (bpt 2Ddatarange / obj ptdata fitPoints startTan endTan)
  ;(setq startTan (vlax-3d-point 0 0 0) endTan (vlax-3d-point 0 0 0))
  (setq ptdata (apply 'append (mapcar '(lambda (p) (mapcar '+ bpt (append p '(0.0)))) 2Ddatarange)))
  (setq fitPoints (vlax-make-safearray vlax-vbDouble (cons 0  (1- (length ptdata)))))
  (vlax-safearray-fill fitPoints ptdata)
  (setq obj (vla-AddPolyline #modspace fitPoints))
  (vlax-put-property obj "color" 4)
  );defun







;;; y = f(x) = Vx-1
;		dx x0 xend
(setq Xrange	'(1.0 -100 100))
(setq func '(lambda (w)
	      ;(- (expt x (/ 1.0 2.0)) 1.0)
	      ;(/ (* 10 (sin (* 10 x))) x )
	      ;(- (abs (- (abs (+ (abs (- x 1)) 2)) 3)) 4)
	      ;(- (+ (abs (- x 1)) (abs (- 5 x))) 18)
	      ;(* 340 (/ 1.0 w))
	      ;(- (abs (- 10 (abs (- x 1)))) 8)
	      ;(+ (- (abs (+ x 3)) (* 2 x)) 3)

;;	      (- (abs (- (abs (+ 2 (* 3 x))) 4)) x)

	      ;(- (abs (+ (* 2 x) 8)) 2)

	      ;(- (- (abs (- (* x 2) 10)) (abs (+ x 85))) 4)



	      (-
		(abs
		  (+
		    x
		    4
		    )
		  )
		(+
		  (* 3 x)
		  12
		  )
	       )

	      
	      ;(+ (* (abs x) (abs (- 5 x))) -84)
	      
 ))
(setq datarange (func|encount func Xrange))




;(setq #ptbase '(0 0 0))
(setq #ptbase (getpoint))
(drawbase #ptbase datarange) 
;(drawgraph-spline datarange)
(drawgraph-pline #ptbase datarange)








