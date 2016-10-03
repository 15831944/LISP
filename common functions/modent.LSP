;;;  14_02_28


; 41 - MTextBoundaryWidth - difined width factor - ширина мультитекстового аттрибута
;	Reference rectangle width
; 46 - высота Рамки мультитекстового аттрибута
;	Defined annotation height

;;  --------   Embded Object ----------------

; 40 - Height - высота букв
; 41 - MTextBoundaryWidth - difined width factor - ширина мультитекстового аттрибута
;	Reference rectangle width
; 71	Attachment point: 1 = Top left; 2 = Top center; 3 = Top right 4 = Middle left; 5 = Middle center; 6 = Middle right 7 = Bottom left; 8 = Bottom center; 9 = Bottom right
; 72	Drawing direction: 1 = Left to right 3 = Top to bottom 5 = By style (the flow direction is inherited from the associated text style)

; 1 - string

; 42 - Horizontal width of the characters that make up the mtext entity.
;	This value will always be equal to or less than the value
;	of group code 41 (read-only, ignored if supplied).
; 43 - Vertical height of the mtext entity (read-only, ignored if supplied)
; 50 - Rotation angle in radians
; 73 - Line spaceing style (1 at least; 2 exacly)
; 44 - Line sapcing factor межстроковое [0.8 = 3.5, exacly]


;	(modent (car (entsel)) (cons 44 0.75))


(defun c:modmtatt ( / ent eng ptags curntData lastInputFilename pvals obj wf)
  (setq ent (car (nentsel)))
  (setq eng (entget ent))
  (setq ptags '("Boundary Height" "Boundary Width" "Line Spacing" "WidthFactor"))
  (setq curntData (append (mapcar '(lambda (tag asp)
				     (list tag (any-to-string (cdr (assoc asp (member '(101 . "Embedded Object") eng)))))
				     )
				  ptags (list 46 41 44))
			  (list (list "WidthFactor" "1"))))

  (setq lastInputFilename (strcat "\\dclget-lif-" (apply 'strcat (mapcar 'str|FilenameFormat ptags)) ".tmp"))
  (wfile curntData (strcat (getenv "temp") lastInputFilename))
  
  (if (setq pvals (kd:dclget ptags))
    (progn
      (setq pvals (mapcar 'atof* pvals))
      (modent ent (cons 46 (nth 0 pvals)))		; высота
      (modenteo ent (cons 41 (nth 1 pvals)))		; ширина
      (modent ent (cons 44 (nth 2 pvals)))		; межстроковое
      (modent ent (cons 73 2))				; межстроковое
      
      (if (and
	    (/= 1 (setq wf (nth 3 pvals)))
	    (/= 0 wf)
	    )
	(progn
	  (setq obj (vlax-ename->vla-object ent))
	  (vla-put-textstring obj
	    (strcat
	      "{\\W" (rtos wf) ";"
	      (kd:mtextstring-unformat (vla-get-textstring obj))
	      "}")
	    )
	  )
	)
      )
    )
  );defun



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun modent (ent pp / head eng)
  (setq head (car pp))
  (setq eng (entget ent))
  (setq eng (subst pp (assoc head eng) eng))
  (entmod eng)
  (entupd ent)
  )


;(setq ent (car (entsel)))
;(setq pp '(41 . 11))
(defun modenteo (ent pp / engeo enghead eng)
  (setq eng (entget ent))
  (setq engeo (member '(101 . "Embedded Object") eng))
  (setq enghead (reverse (cdr (member '(101 . "Embedded Object") (reverse eng)))))
  (setq engeo (subst pp (assoc (car pp) engeo) engeo))
  (setq eng (append enghead engeo))
  (entmod eng)
  (entupd ent)
  );defun



(defun kd-get-MTAttRealHeight (att) (cdr (assoc 43 (member '(101 . "Embedded Object") (entget (vlax-vla-object->ename att))))))
(defun kd-get-MTAttRealWidth (att) (cdr (assoc 42 (member '(101 . "Embedded Object") (entget (vlax-vla-object->ename att))))))

(defun kd-get-MTAttBoundaryHeight (att) (cdr (assoc 46 (member '(101 . "Embedded Object") (entget (vlax-vla-object->ename att))))))
(defun kd-put-MTAttBoundaryHeight (att val / ent eng eo head)
  (setq ent (vlax-vla-object->ename att))
  (setq eng (entget ent))
  (setq eo (member '(101 . "Embedded Object") eng))
  (setq head (reverse (cdr (member '(101 . "Embedded Object") (reverse eng)))))
  (if (assoc 46 eo)
    (setq eo (subst (cons 46 val) (assoc 46 eo) eo))
    (setq eo (cons (cons 46 val) eo))
    )
  (setq eng (concat head eo))
  (entmod eng)
  (entupd ent)
  );defun





(defun kd-get-MTAttLineSpacingStyle (att) (cdr (assoc 73 (member '(101 . "Embedded Object") (entget (vlax-vla-object->ename att))))))
(defun kd-put-MTAttLineSpacingStyle (att val / ent eng eo head)
  (setq ent (vlax-vla-object->ename att))
  (setq eng (entget ent))
  (setq eo (member '(101 . "Embedded Object") eng))
  (setq head (reverse (cdr (member '(101 . "Embedded Object") (reverse eng)))))
  (if (assoc 73 eo)
    (setq eo (subst (cons 73 val) (assoc 73 eo) eo))
    (setq eo (cons (cons 73 val) eo))
    )
  (setq eng (concat head eo))
  (entmod eng)
  (entupd ent)
  );defun




(defun kd-get-MTAttLineSpacingFactor (att) (cdr (assoc 44 (member '(101 . "Embedded Object") (entget (vlax-vla-object->ename att))))))
(defun kd-put-MTAttLineSpacingFactor (att val / ent eng eo head)
  (setq ent (vlax-vla-object->ename att))
  (setq eng (entget ent))
  (setq eo (member '(101 . "Embedded Object") eng))
  (setq head (reverse (cdr (member '(101 . "Embedded Object") (reverse eng)))))
  (if (assoc 44 eo)
    (setq eo (subst (cons 44 val) (assoc 44 eo) eo))
    (setq eo (cons (cons 44 val) eo))
    )
  (setq eng (concat head eo))
  (entmod eng)
  (entupd ent)
  );defun


(defun kd-change-MTAttTextHeight (att val / w)
  (setq w (vla-get-MTextBoundaryWidth att))
  (vla-put-Height att val)
  (vla-put-MTextBoundaryWidth att w)
  );defun
;(kd-change-MTAttTextHeight (vlax-ename->vla-object (car (nentsel))) )


(defun mta|fitstring-by-height (att)
  (while (> (kd-get-MTAttRealHeight att) (kd-get-MTAttBoundaryHeight att))
    (kd-change-MTAttTextHeight att (- (vla-get-height att) 0.1))
    )
  (vla-get-height att)
  )


(defun c:decr-scalefactor ( / att)
  (setq att (vlax-ename->vla-object (car (nentsel))))
  (vla-put-ScaleFactor att (- (vla-get-ScaleFactor att) 0.1))
  )
(defun c:incr-scalefactor ( / att)
  (setq att (vlax-ename->vla-object (car (nentsel))))
  (vla-put-ScaleFactor att (+ (vla-get-ScaleFactor att) 0.1))
  )
(defun c:decr-linespacing-factor ( / att)
  (setq att (vlax-ename->vla-object (car (nentsel))))
  (kd-put-MTAttLineSpacingFactor att (- (kd-get-MTAttLineSpacingFactor att) 0.1))
  )
(defun c:incr-linespacing-factor ( / att)
  (setq att (vlax-ename->vla-object (car (nentsel))))
  (kd-put-MTAttLineSpacingFactor att (+ (kd-get-MTAttLineSpacingFactor att) 0.1))
  )


;(vla-put-ScaleFactor (vlax-ename->vla-object (car (nentsel))) 1)
;(kd-put-MTAttLineSpacingFactor (vlax-ename->vla-object (car (nentsel))) 1)
