
(setq lst (vl-remove-if-not
	    '(lambda (x)
	       (and
		 (= "ФС_задвижка" (vla-get-effectivename x))
		 ;(= (vla-get-XScaleFactor x) -1)
		 )
	       )
	    (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
	    )
      )
(length lst)


(mapcar 'rep lst)

(defun rep (bobj
	    /
	    ;ip
	    rot
	    ;scf
	    )
;(setq bobj (vlax-ename->vla-object (car (entsel))))
;(setq ip (vlax-safearray->list(vlax-variant-value (vla-get-InsertionPoint bobj))))
(setq rot (vla-get-rotation bobj))
;(setq scf (vla-get-XScaleFactor bobj))

(vla-put-XScaleFactor bobj 1)
(vla-put-rotation bobj (+ rot (dtr 180)))
;(vla-put-insertionpoint bobj (vlax-3d-point (polar ip (+ rot (dtr 180)) 4)))
  );defun



(defun c:tmp ( / lst actview cent he wi)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq lst (vl-remove-if-not
	    '(lambda (x)
	       (and
		 (= "ФС_задвижка" (vla-get-effectivename x))
		 ;(= (vla-get-XScaleFactor x) -1)
		 )
	       )
	    (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
	    )
      )
;(length lst)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;(setq cent (vla-get-Center (vla-get-ActiveViewport actdoc)))
  ;(setq he (vla-get-Height (vla-get-ActiveViewport actdoc)))
  ;(setq wi (vla-get-Width (vla-get-ActiveViewport actdoc)))
  (mapcar 'modline lst)
  ;(vla-put-center (vla-get-ActiveViewport actdoc) cent)
  ;(vla-put-Height (vla-get-ActiveViewport actdoc) he)
  ;(vla-put-Width (vla-get-ActiveViewport actdoc) wi)
);defun



(defun modline (bobj
		/
		line
		pt
		)
  (setq line (getline bobj))
  (setq pt (polar
	     (vlax-safearray->list(vlax-variant-value (vla-get-InsertionPoint bobj)))
	     (vla-get-rotation bobj) 4))
  (eval (list (read (strcat "vla-put-" (startorend line pt))) line (vlax-3d-point pt)))
  (setq n (1+ n))
  );defun





  (setq c_red (vla-GetInterfaceObject cad "AutoCAD.AcCmColor.18"))
  (vlax-put-property bobj "Truecolor" c_red)
;(setq bobj (vlax-ename->vla-object (car (entsel))))
;(getline bobj)

(defun getline (bobj
		/
		pt
		sset)
  ;(vl-cmdf "zoom" "o" (vlax-vla-object->ename bobj) "")
  (setq pt (polar
	     (vlax-safearray->list(vlax-variant-value (vla-get-InsertionPoint bobj)))
	     (vla-get-rotation bobj)
	     9))
  (vla-zoomwindow cad
    (vlax-3d-point (polar pt 0 10))
    (vlax-3d-point (polar pt pi 10))
    )
  (setq sset (vla-get-ActiveSelectionSet actdoc))
  (vla-Clear sset)
  (vla-SelectAtPoint sset
    (vlax-3D-point   pt)
    (vlax-safearray-fill (vlax-make-safearray vlax-vbinteger '(0 . 0)) '(0))
    (vlax-safearray-fill (vlax-make-safearray vlax-vbvariant '(0 . 0)) '("LINE"))
    )
  (if (= 1 (vla-get-Count sset))
    (vla-item sset 0)
    (vlax-ename->vla-object (car (entsel)))
    ;(exit)
    )
  )





(defun startorend (lobj pt)
  (if (>
	(distance pt (vlax-safearray->list(vlax-variant-value (vla-get-startpoint lobj))))
	(distance pt (vlax-safearray->list(vlax-variant-value (vla-get-endpoint lobj)))))
    "EndPoint"
    "StartPoint"
    )
  );defun

;(startorend (vlax-ename->vla-object (car (entsel))) (getpoint))