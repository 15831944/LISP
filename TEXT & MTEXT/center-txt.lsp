



;;	на кубике WCS поставить
;(setq targ (getvar "TARGET"))
;(setq circ (vla-addcircle #modspace (vlax-3d-point targ) 10))
;(command "_zoom" "_O" circ)








(defun c:ct (/ err)
  (vla-startundomark #actdoc)
  (if (and (setq obj (entsel)) (setq obj (vlax-ename->vla-object (car obj))))
    (setq res (vl-catch-all-apply 'center-txt (list obj)))
    )
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type res)) (VL-CATCH-ALL-ERROR-MESSAGE res))
    ((null res) (princ))
    );cond
  (vla-endundomark #actdoc)
  );defun

(defun center-txt (obj /
		   pt1 pt2
		   cxy
		   rot
		   eng
	           pe
		   )
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (if (member (vla-get-ObjectName obj) '("AcDbText" "AcDbMText" "AcDbAttributeDefinition"))
    (progn
      (setq rot (vla-get-rotation obj))
      (vl-cmdf "_.-boundary" (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))) "")
      (setq pe (vlax-ename->vla-object (entlast)))
      (vla-getboundingbox pe 'pt1 'pt2)
      (vla-delete pe)
      (if (and
	    obj
	    (= "AcDbMText" (vla-get-objectname obj))
	    (= 5 (vla-get-AttachmentPoint obj))
	    (setq pe (vlax-ename->vla-object (entlast)))
	    (= "AcDbPolyline" (vla-get-objectname pe))
	    )
	(vla-delete pe)
	)
      (setq pt1 (vlax-safearray->list pt1))
      (setq pt2 (vlax-safearray->list pt2))
      (setq cxy (mapcar '(lambda (a b) (/ (+ a b) 2)) pt1 pt2))

     
      (cond
	(
	 (= "AcDbMText" (vla-get-ObjectName obj))
	 (setq obj (vlax-vla-object->ename obj))
	 (setq eng (entget obj))
	 (if (member rot (list (/ pi 2) (/ (* 3 pi) 2))) 		;rotated
	   (progn
	     (setq eng (subst (cons 41 (- (cadr pt2) (cadr pt1)))	(assoc 41 eng) eng))
	     (setq eng (subst (cons 46 (- (car pt2) (car pt1)))	(assoc 46 eng) eng))
	     )
	   (progn
	     (setq eng (subst (cons 41 (- (car pt2) (car pt1)))	(assoc 41 eng) eng))
	     (setq eng (subst (cons 46 (- (cadr pt2) (cadr pt1)))	(assoc 46 eng) eng))
	     )
	   );if rotated
	 (setq eng (subst (cons 71 5) (assoc 71 eng) eng))
	 (setq eng (subst (cons 10 cxy) (assoc 10 eng) eng))
	 (entmod eng)
	 (entupd obj)
	 ;(vla-put-attachmentpoint obj 5)
	 ;(vla-put-InsertionPoint obj (vlax-3d-point cxy))
	 )
	(
	 (= "AcDbAttributeDefinition" (vla-get-ObjectName obj))
	 
	 (vla-put-alignment obj 10)
	 (vla-put-TextAlignmentPoint obj (vlax-3d-point cxy))
	 )
	(T
	 (vla-put-alignment obj 10)
	 (vla-put-TextAlignmentPoint obj (vlax-3d-point cxy))
	 )
	)
      
      );progn
    );if
  );defun




;;;;;;;;;;;;;;;;;;;;;;; OLD
;;;(defun center-txt (
;;;		/
;;;		ent
;;;		eng
;;;		rx
;;;		lx
;;;		ty
;;;		by
;;;		cxy
;;;		np
;;;		)
;;;  (setq ent (car (entsel)))
;;;  (if (and
;;;	ent
;;;	(member (cdr (assoc 0 (setq eng (entget ent)))) '("TEXT" "MTEXT"))
;;;	)
;;;    (progn
;;;      (setq rx (cadr (assoc 10 (entget (mtxtfit-getline ent "right"))))
;;;	    lx (cadr (assoc 10 (entget (mtxtfit-getline ent "left"))))
;;;	    ty (caddr (assoc 10 (entget (mtxtfit-getline ent "up"))))
;;;	    by (caddr (assoc 10 (entget (mtxtfit-getline ent "down"))))
;;;	    cxy (list (/ (+ rx lx) 2) (/ (+ ty by) 2))
;;;	    )
;;;      (if (= "MTEXT" (cdr (assoc 0 eng)))
;;;	(progn
;;;	  (setq eng (subst (cons 41 (abs (- rx lx))) (assoc 41 eng) eng)
;;;		eng (subst (cons 46 (abs (- ty by))) (assoc 46 eng) eng)
;;;		eng (subst (cons 71 5) (assoc 71 eng) eng)
;;;		np 10)
;;;	  )
;;;	(progn
;;;	  (setq eng (subst (cons 72 1) (assoc 72 eng) eng)
;;;		eng (subst (cons 73 2) (assoc 73 eng) eng)
;;;		np 11)
;;;	  )
;;;	);if
;;;      (setq eng (subst (cons np cxy) (assoc np eng) eng))
;;;      (entmod eng)
;;;      (entupd ent)
;;;      (princ)
;;;      );progn
;;;    );if
;;;  );defun
;;;
;;;
;;;;(sssetfirst nil (ssadd (mtxtfit-getline "left" (car (entsel)))))
;;;(defun mtxtfit-getline ( obj
;;;			dir
;;;			/
;;;			e
;;;			center
;;;			eng
;;;			dd
;;;			line-not-found
;;;			cmd
;;;			ss
;;;			step
;;;			l
;;;			)
;;;  ;(setq e (vlax-vla-object->ename obj))
;;;  (setq e  obj)
;;;  (setq step (cdr (assoc 40 (entget e))))
;;;  (cond
;;;    ((= dir "right")(setq cmd '(mapcar '+ center (list dd 0))))
;;;    ((= dir "left")(setq cmd '(mapcar '- center (list dd 0))))
;;;    ((= dir "up")(setq cmd '(mapcar '+ center (list 0 dd))))
;;;    ((= dir "down")(setq cmd '(mapcar '- center (list 0 dd))))
;;;    (T (exit))
;;;    )
;;;  (setq center (cdr (assoc 10 (setq eng (entget e))))
;;;	dd 0
;;;	line-not-found T
;;;	)
;;;  
;;;  (while line-not-found
;;;    (setq dd (+ dd step)
;;;	  ss (ssget "_F" (list center (eval cmd)) '(
;;;						    (-4 . "<NOT")
;;;						    (0 . "*TEXT")
;;;						    (-4 . "NOT>")
;;;						    )))
;;;    (if (and ss
;;;	     (= 1 (sslength ss)))
;;;      (progn
;;;	(setq line-not-found nil)
;;;	);progn
;;;      );if
;;;    
;;;    (if (and ss
;;;	     (= 2 (sslength ss)))
;;;      (progn
;;;	(alert (strcat "нашол много граничных линий\n" dir "\n ок - указать"))
;;;	(while (not l)
;;;	  (setq l (car (nentsel)))
;;;	  )
;;;	(setq line-not-found nil)	
;;;	)
;;;      );if
;;;    
;;;    (if (> dd (* step 100))
;;;      (progn
;;;	(alert (strcat "не могу найти граничную линиию, \n ок - указать" dir))
;;;	(while (not l)
;;;	  (setq l (car (nentsel)))
;;;	  )
;;;	(setq line-not-found nil)
;;;	)
;;;      )
;;;    );while
;;;  
;;;  (if (= (sslength ss) 1)
;;;    (setq l (ssname ss 0))
;;;    );if
;;;  l
;;;  );defun
;;;
;;;;(command "_line" (getpoint) (cdr (assoc 10 (entget (car (entsel))))))



