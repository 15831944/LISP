
(defun bound (
	      /
	      e
	      pt1
	      pt2
	      minp
	      maxp
	      )
  (setq e (car (entsel)))
(vla-GetBoundingBox (vlax-ename->vla-object e) 'minp 'maxp)
(setq pt1 (vlax-safearray->list minp))
  (setq pt2 (vlax-safearray->list maxp))
;;;  (setq snap (getvar "osnap"))


  (acet-error-init
 (list (list "cmdecho" 0
             "highlight" (getvar "highlight")
             "limcheck" 0
	     "osmode" 0
       );list
       T
 );list
);acet-error-init
 

  
  (command "_rectang" pt1 pt2)

  (acet-error-restore)
  );defun
