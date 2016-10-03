

(setq #color (vla-GetInterfaceObject cad "AutoCAD.AcCmColor.18"))
(vla-SetRGB #color 250 100 100)

(setq obj (vlax-ename->vla-object (car (entsel))))
(vlax-put-property obj "Truecolor" #color)



(setq lines (ss->lsto* (ssget '((0 . "LINE")))))

(setq pts (mapcar '(lambda (x)
		       (vlax-safearray->list (vlax-variant-value (vla-get-startpoint x)))
		       (vlax-safearray->list (vlax-variant-value (vla-get-endpoint x)))
		     ) lines))

(setq pts (mapcar '(lambda (x)
	   (list (car x) (cadr x))
	   ) pts))



(setq lst (mapcar '(lambda (x) (getpoint)) '(1 2 3 4)))
(setq lst (mapcar '(lambda (x)
	   (list (car x) (cadr x))
	   ) lst))

(defun diagonali (lst)
  (if (<= (length lst) 2)
    (list (distance (car lst) (cadr lst)))
    (append
      (mapcar '(lambda (x) (distance x (car lst))) (cdr lst))
      (diagonali (cdr lst))
      )
    )
  );defun

(diagonali lst)
(setq diags (diagonali pts))
(eval (cons 'min diags))
(eval (cons '* diags))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq lines (ss->lsto* (ssget '((0 . "LINE")))))

(setq a (car lines))
(setq b (cadr lines))

(or
  (equal
    (vlax-safearray->list (vlax-variant-value (vla-get-startpoint a)))
    (vlax-safearray->list (vlax-variant-value (vla-get-startpoint b)))
    )
  (equal
    (vlax-safearray->list (vlax-variant-value (vla-get-startpoint a)))
    (vlax-safearray->list (vlax-variant-value (vla-get-endpoint b)))
    )
  (equal
    (vlax-safearray->list (vlax-variant-value (vla-get-endpoint a)))
    (vlax-safearray->list (vlax-variant-value (vla-get-startpoint b)))
    )
  (equal
    (vlax-safearray->list (vlax-variant-value (vla-get-endpoint a)))
    (vlax-safearray->list (vlax-variant-value (vla-get-endpoint b)))
    )
  )

(vla-IntersectWith a b acExtendNone)
(setq pt (vla-IntersectWith a b acExtendNone))
(vlax-safearray->list (vlax-variant-value pt))
(vlax-safearray-get-element (vlax-variant-value pt) 0)



(or
  (and
    (equal pt (vla-get-startpoint a))
    (equal pt (vla-get-startpoint b))
    )
  (and
    (equal pt (vla-get-startpoint a))
    (equal pt (vla-get-startpoint b))
    )
)





(setq pts (mapcar '(lambda (x)
		     (list
		       (vlax-safearray->list (vlax-variant-value (vla-get-startpoint x)))
		       (vlax-safearray->list (vlax-variant-value (vla-get-endpoint x)))
		       )
		     ) lines))



(do (vla-get-truecolor (vlax-ename->vla-object (car (entsel)))))

(defun c:trm ( /
	      es
	      blobj	; base line object
	      inlobj	; inline object
	      intpt	; intersection point
	      ptobj
	      pthatch
	      )
  (load "D:/LISP WORKING/common functions/startorend.LSP")
  (setq blobj (entsel "1....pick a base line\n"))
  (if blobj
    (progn
      (setq blobj (vlax-ename->vla-object (car blobj)))
      (while (setq es (entsel "2...pick a line to trim\n"))
	(setq inlobj (vlax-ename->vla-object (car es)))
	(setq intpt (vla-IntersectWith blobj inlobj acextendotherentity))
	(if (and
	      (> (vlax-safearray-get-u-bound (vlax-variant-value intpt) 1) 0)
	      (= 3 (length (setq intpt (vlax-safearray->list (vlax-variant-value intpt)))))
	      )
	  (vlax-put-property inlobj (startorend inlobj intpt) (vlax-3d-point intpt))
	  )
	(setq ptobj (vla-InsertBlock ms (vlax-3D-point intpt) (strcat blocks-template-path "ФС_point.dwg") 1 1 1 0))
	(setq pthatch (car (vlax-safearray->list (vlax-variant-value (vla-explode ptobj)))))
	(vla-delete ptobj)
	(vla-put-layer pthatch "ФС_связи")
	;(vla-put-plotstylename pthatch"ByLayer")
	);while
      )
    );if
  );defun




; подсветка неортогоальных линий
(defun c:hl ( /
	     lines
	     xxx
	     )
  (setq xxx 0.02)
  (setq lines (ss->lsto* (ssget '((0 . "LINE")))))
  (mapcar '(lambda (x)
	     (if (if-line-is-bad x)
	       (vlax-put-property x "Truecolor" #color)
	       )
	     ) lines)
  );defun

(defun if-line-is-bad (obj /
		       sp ep
		       dx dy
		       )
  (setq sp (vlax-safearray->list (vlax-variant-value(vla-get-startpoint obj))))
  (setq ep (vlax-safearray->list (vlax-variant-value(vla-get-endpoint obj))))
  (setq dx (abs (- (car sp) (car ep))))
  (setq dy (abs (- (cadr sp) (cadr ep))))
  (and
      (/= "0" (rtos dx 2))
      (/= "0" (rtos dy 2))
      (< (/ (min dx dy) (max dx dy)) xxx)
      )
  );defun

(setq obj (vlax-ename->vla-object (car (entsel))))
