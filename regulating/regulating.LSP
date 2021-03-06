;(entget (car (entsel)) '("*"))

;;;(defun vla-container->list (obj / lst col i)
;;;  (setq lst '() i -1)
;;;  (if (setq col (vla-get-Count obj))
;;;    (repeat col (setq lst (append lst (list (vla-item obj (setq i (1+ i)))))))
;;;    )
;;;  lst
;;;  )

(defun getitem (str)
  (set (read str) (vlax-ename->vla-object (car (entsel (strcat "\n������� " str)))))
  )


;(getitem "actuator")
;(getitem "psens")
;(getitem "pzadat")
;(getitem "mA")
;(getitem "mApt")
;(getitem "psens1000")
(mapcar 'getitem '("actuator" "psens" "pzadat" "mA" "mApt"))
;;;; � ����� ���������� ���������� � ������ ��� ��� � �������� � �� ���������� - ������

(setq pin 10)	;;;;  �������� ��������




(defun c:apply () (recount))

(defun recount (
		/
		psv pzv actv%
		actmax
		actmin
		dpcahnged
		)
;;;  (setq actclosed 0			;;; ���� � �������� ��������� ��������� ����������
;;;	actopened 4.71239)		;;; ���� � �������� ��������� ��������� ����������


  (setq actclosed (cdr (assoc 141 (entget (getbrpprops "actuator")))))
  (setq actopened (cdr (assoc 142 (entget (getbrpprops "actuator")))))

  
  (setq actstep 0.1)			;;; ��� ����������� ���-�� (����� ��������)

  (setq actvallist '())			;;; ��� ������� �������������
  
  
  (defun getactval (actobj) (vlax-variant-value (vla-get-Value (getbdyn actobj "����"))))
  (defun putactval (actobj val) (vla-put-Value (getbdyn actobj "����")(vlax-make-variant val)))
  
  (defun getsensval (sensobj) (atof (vla-get-TextString (getbatt sensobj "VAL"))))
  (defun putsensval (sensobj val) (vla-put-TextString (getbatt sensobj "VAL") (rtos val)))
  (defun getval (obj att) (atof (vla-get-TextString (getbatt obj att))))
  (setq pzv (getsensval (eval (read "pzadat"))))
  ;(PUTSENSVAL (eval (read "psens")) 6)
  ;(getsensval (eval (read "psens")))
    
  ;(putactval (eval (read "actuator")) (* actopened (/ (atof (vla-get-TextString (getbatt (eval (read "psens")) "VAL"))) pin)))
  (putsensval (eval (read "psens")) (* pin (/ (getactval (eval (read "actuator"))) actopened)))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;; ������� ����������  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun iseq (a b) (< (abs (- a b )) 0.0001))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;; ������� ������� � ������ ������� (����������) ;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun getsmax (str) (getval (eval (read str)) "LIM_MAX"))
  (defun getsmin (str) (getval (eval (read str)) "LIM_MIN"))
  (defun getsval (str) (getval (eval (read str)) "VAL"))
  
  (defun get%s (str) (/ (- (getsval str) (getsmin str)) (- (getsmax str) (getsmin str))))
  (defun put%s (str percent) (putsensval (eval (read str)) (+ (getsmin str) (* percent (- (getsmax str) (getsmin str))))))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;; ������� ������� � ������ ���������� (��� ��-��) ;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun get%act (str) (/ (- (getactval (eval (read str))) actclosed) (- actopened actclosed)))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;; ��� ������� ������������� �� ��������� ���������� ;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (while (not (iseq pzv (setq psv (getsensval (eval (read "psens"))))))
    (setq dpchanged (> pzv psv))
    
    (putactval (eval (read "actuator")) ( (if (> pzv psv)
					    (progn (eval +))
					    (progn (eval -))
					    )
					  (getactval (eval (read "actuator")))
					  actstep))
    
    ;;;; ���������� �������� � ������ ��� ���������� �������
    (setq actvallist (append actvallist (list (getactval (eval (read "actuator"))))))


    ;;;; �������� ����������

     
    
    (put%s "mA" (get%act "actuator"))
    (put%s "psens" (get%act "actuator"))
    (put%s "psens1000" (get%act "actuator"))
    (put%s "mApt" (get%s "psens"))
    
    ;(putsensval (eval (read "psens")) (* pin (/ (getactval (eval (read "actuator"))) actopened)))
    ;(putsensval (eval (read "mA")) (+ 4(* 16 (/ (getactval (eval (read "actuator"))) actopened))))
    
    (repeat 20000 (princ))
    (vla-Update (eval (read "actuator")))
    (setq psv (getsensval (eval (read "psens"))))
    (if (/= dpchanged (> pzv psv))
      (setq actstep (* actstep 0.9))
      )
    );while
  )





















(defun c:graph () (draw-graph (mapcar '(lambda (x) (* x 10)) actvallist)))


(defun draw-graph (lst 
		   /
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



(defun make-coords (Xrange
		    mc-bpt
		    /
		    pt1 pt2
		    )

  ;;; ============  ��� �  =========================
  
  (setq pt1 (list (- (car mc-bpt) (/ Xrange 2)) (cadr mc-bpt)))
  (setq pt2 (list (+ (car mc-bpt) (/ Xrange 2)) (cadr mc-bpt)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (setq pt1 (list (- (car pt2) 5)  (+ (cadr pt2) 1)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (setq pt1 (list (- (car pt2) 5)  (- (cadr pt2) 1)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (entmake (list (cons 0 "TEXT")(cons 10 pt2)(cons 40 2.5)(cons 1 "X")))

  ;;; ============  ��� Y  =========================
  
  (setq pt1 (list (car mc-bpt) (- (cadr mc-bpt) (/ Xrange 2))))
  (setq pt2 (list (car mc-bpt) (+ (cadr mc-bpt) (/ Xrange 2))))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (setq pt1 (list (- (car pt2) 1)  (- (cadr pt2) 5)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (setq pt1 (list (+ (car pt2) 1)  (- (cadr pt2) 5)))
  (entmake (list (cons 0 "LINE")(cons 10 pt1)(cons 11 pt2)))
  (entmake (list (cons 0 "TEXT")(cons 10 pt2)(cons 40 2.5)(cons 1 "Y")))
  );defun





(defun getbrpprops (str)
  (car
    (vl-remove-if-not
      '(lambda (x) (= "BLOCKROTATIONPARAMETER" (cdr (assoc 0 (entget x)))))
      (mapcar 'cdr
	      (vl-remove-if-not '(lambda (x) (= 360 (car x)))
		(entget (vlax-vla-object->ename
			  (car
			    (vl-remove-if-not
			      '(lambda (x) (= "AcDbEvalGraph" (vla-get-ObjectName x)))
			      (cont>list
				(vla-GetExtensionDictionary
				  (vla-item
				    (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object)))
				    (vla-get-effectivename
				      (eval (read str))
				      )))))))))))));defun