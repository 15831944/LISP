;;;(defun cable-trim (
;;;		   /
;;;		   doc
;;;		   ss
;;;		   len
;;;		   i
;;;		   bpt
;;;		   nproperty
;;;		   )
;;;  
;;;  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
;;;  (vla-startundomark doc)
;;;  
;;;  (acet-error-init
;;;    (list (list "cmdecho" 0
;;;		"highlight" (getvar "highlight")
;;;		"limcheck" 0
;;;	;	"osmode" 0
;;;		);list
;;;	  T
;;;	  );list
;;;    );acet-error-init
;;;;;;*************************************************************************************  
;;;
;;;  (if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
;;;    (setq ss (ssget '((0 . "INSERT"))))
;;;    );if
;;;  (setq bpt (getpoint "\nукажите расстояние от клеммника")
;;;	len (- (car (getpoint bpt)) (car bpt))
;;;	i 0)
;;;  
;;;  (setq nproperty 3);;; порядковый номер дин свойства (=n-1)
;;;
;;;
;;;
;;;  
;;;  
;;;
;;;  (repeat (sslength ss)
;;;    (if
;;;      (vla-put-value 
;;;      (nth nproperty					
;;;	   (vlax-safearray->list
;;;	     (vlax-variant-value
;;;	       (vla-getDynamicBlockProperties
;;;		 (vlax-ename->vla-object
;;;		   (ssname ss i)))))
;;;	   )
;;;      (vlax-make-variant (- (abs (- (+ len (car bpt)) (cadr (assoc 10 (entget (ssname ss i)))))) 0))
;;;      )
;;;      (princ)
;;;      );if
;;;    (setq i (1+ i))
;;;    );repeat
;;;;;;*************************************************************************************
;;;  (acet-error-restore)
;;;  (vla-endundomark doc)
;;;  );defun

;dump
;;;(vlax-dump-Object
;;;(car
;;;(vlax-safearray->list
;;;  (vlax-variant-value
;;;    (vla-getDynamicBlockProperties
;;;      (vlax-ename->vla-object
;;;	(car (entsel))
;;;	)
;;;      )
;;;    )
;;;  )
;;;)
;;;)
;;;
;;;(mapcar 'vla-get-PropertyName
;;;(vlax-safearray->list
;;;  (vlax-variant-value
;;;    (vla-getDynamicBlockProperties
;;;      (vlax-ename->vla-object
;;;	(car (entsel))
;;;	)
;;;      )
;;;    )
;;;  )
;;;)





(defun cable-trim (
		   /
		   doc
		   ss
		   len
		   i
		   bpt
		   prop
		   )
  
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
	;	"osmode" 0
		);list
	  T
	  );list
    );acet-error-init
;;;*************************************************************************************  

  (if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
    (setq ss (ssget '((0 . "INSERT")))))
  
  (setq bpt (getpoint "\nукажите расстояние от клеммника")
	len (getdist bpt)
	i 0)

  
  (setq prop "Расстояние");;; дин свойство блока

  (setq ss (mapcar 'vlax-ename->vla-object (ss->list* ss)))
  

  (foreach bl ss
    (vla-put-value
      (getbdyn  bl prop)
      (vlax-make-variant (abs
			     (- len
				(abs
				  (- (car bpt)
				     (car (vlax-safearray->list
					    (vlax-variant-value
					      (vla-get-InsertionPoint bl))))
				     )
				  )
				)
			     )
	)
      )
    );foreach
  
;;;*************************************************************************************
  (acet-error-restore)
  (vla-endundomark doc)
  );defun




(defun getbdyn (bl prop /)
  (car
    (vl-remove-if-not '(lambda (x) (= prop (vla-get-PropertyName x)))
      (vlax-safearray->list (vlax-variant-value(vla-GetDynamicBlockProperties bl)))
      )
    )
  );defun


;(do (getbdyn  (vlax-ename->vla-object (car (entsel))) "Расстояние1"))