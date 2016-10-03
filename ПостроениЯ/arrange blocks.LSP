
;;; 12_11_05
;;; att - таг аттрибута для сортировки



(defun c:arrange ( / lsto attssa atts tag)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 ) T))
  (princ "\nвыберите элементы для построения...")
  (setq lsto (ss->lsto* (ssget '((0 . "INSERT,*TEXT")))))
  (cond
    ((= (vla-get-objectname (car lsto)) "AcDbText")
     (setq tag "AcDbText")
     )
    ((= (vla-get-objectname (car lsto)) "AcDbMText")
     (setq tag "AcDbMText")
     )
    ((= (vla-get-objectname (car lsto)) "AcDbBlockReference")
     (setq attssa (vlax-variant-value (vla-GetAttributes (car lsto))))
     (if (>= (vlax-safearray-get-u-bound attssa 1) 0)
       (setq atts (vlax-safearray->list attssa) tag (kd:dcl:pick-from-list (mapcar 'vla-get-TagString atts)))
       (setq tag "")
       )
     )
    )
  (align lsto tag)
  (acet-error-restore)
  (vla-endundomark #actdoc)  
  )







(defun align (lsto tag / iftxt rule nlsto nlst)
  (setq rule (kd:dcl:pick-from-list '("alphabetical" "preset-ssget" "XY")))
    
  (cond
    ((= rule "alphabetical")
     (if (member tag '("AcDbText" "AcDbMText"))
       (setq nlsto (vl-sort lsto '(lambda (a b) (< (vla-get-textstring a) (vla-get-textstring b)))))
       (setq nlsto (vl-sort lsto '(lambda (a b) (<
						  ;(atof* (vla-get-textstring (getbatt a tag)))
						  ;(atof* (vla-get-textstring (getbatt b tag)))
						  (vla-get-textstring (getbatt a tag))
						  (vla-get-textstring (getbatt b tag))
						  ))))
       )
     
     )
    ((= rule "preset-ssget")
     (if (and (setq rule (mapcar 'vla-get-TextString (ss->lsto (ssget)))) (= (length rule) (length lsto)))
       (progn
	 (setq nlst lsto)
	 (setq nlsto '())
	 (foreach x rule
	   (setq a (car (vl-remove-if-not '(lambda (o) (= x (vla-get-TextString (getbatt o tag)))) nlst)))
	   (setq nlsto (append nlsto (list a)))
	   (setq nlst (vl-remove a nlst))
	   )
	 )
       (exit)
       )
     )
    ((= rule "XY")
     (initget 1 "x -x y -y content")
     (setq rule (getkword "\n Правило сортировки : [x/-x/y/-y] <x> \n"))
     (cond
       ((= rule "x") (setq nlsto (vl-sort lsto '(lambda (a b) (< (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))))))))
       ((= rule "y") (setq nlsto (vl-sort lsto '(lambda (a b) (< (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))))))))
       ((= rule "-x") (setq nlsto (vl-sort lsto '(lambda (a b) (> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))))))))
       ((= rule "-y") (setq nlsto (vl-sort lsto '(lambda (a b) (> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))))))))
       )
     )
    )
  (placeBlocks nlsto)
  ;(placeBlocksForCableList nlsto)
  );defun




(defun placeBlocks (lst / i bpt dv obj)
  (setq	i -1
	bpt (getpoint "\nукажите точку начала постоения...")
	dv (getpoint bpt "\nукажите расстояние между элементами в линии...")
	dv (mapcar '- dv bpt))
  (repeat (length lst)
    (setq obj (nth (setq i (1+ i)) lst))
    (if (and (= tag "AcDbText") (/= 0 (vla-get-alignment obj)))
      (vla-put-TextAlignmentPoint obj (vlax-3d-point (mapcar '+ bpt (mapcar '(lambda (x) (* i x)) dv))))
      (vla-put-InsertionPoint obj (vlax-3d-point (mapcar '+ bpt (mapcar '(lambda (x) (* i x)) dv))))
      )
    ;(vla-put-rotation obj 0)
    );repeat
  );defun


(defun placeBlocksForCableList (lst / Vdy VdyList itemsQuantity  i bpt cpt)
  (setq Vdy 	'(0 -12 0))
  (setq VdyList '(0 -62 0))
  (setq itemsQuantity 20)
  

  (setq bpt (getpoint))
  (setq cpt bpt)
  (setq i -1)
  
  (repeat (length lst)
    (setq obj (nth (setq i (1+ i)) lst))
    (if (= 0 (rem i itemsQuantity))
      (setq cpt (mapcar '+ cpt Vdy VdyList))
      (setq cpt (mapcar '+ cpt Vdy))
      )
    (vla-put-InsertionPoint obj (vlax-3d-point cpt))
    )
  );defun
















(defun arrangeXY ( / lsto bpt
		  dx dy ddx ddy qx qy
		  cx cy cq
		  )
  (setq lsto (ss->lsto (ssget '((0 . "INSERT")))))
  
  (setq	cq 0
	bpt (getpoint "\nукажите точку начала постоения...")
	;dy -24 dx 425
	;dy -24 dx -62
	;qy 10

	dx 0
	dy -10
	ddx 0
	;ddy -86
	ddy -62
	qx nil
	;qy 27
	qy 25
	)
  (setq cx (car bpt) cy (cadr bpt))


  (mapcar
    '(lambda (x)
       (if (= cq qy) (setq cq 0 cy (+ cy ddy)))
       (vla-put-InsertionPoint x (vlax-3d-point (list cx cy)))
       (setq cq (1+ cq) cx (+ cx dx) cy (+ cy dy))
       )
    lsto)
  );defun