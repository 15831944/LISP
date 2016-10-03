(vl-load-com)
(defun c:rotview (
		  /
		  doc
		  vp
		  deg
		  )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init
  (setq vp (car (entsel "\nУкажи видивой экран...")))
  (if (equal '(0 . "VIEWPORT") (assoc 0 (entget vp)))
    (progn
      (setq deg (getint "\nНа сколько градусов повернуть?..."))
      (vla-put-TwistAngle (vlax-ename->vla-object vp) (* (/ pi 180) deg))
      );progn
    (alert "Это не видовой экран!")
    );if
  (acet-error-restore)
  (vla-endundomark doc)
  );defun



;(vla-put-TwistAngle (vlax-ename->vla-object (car (entsel))) (* (/ pi 180) 30))