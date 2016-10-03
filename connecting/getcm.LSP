;;; get cable members
;;; изменена 10_08_10
;;; прога дл€ 
;;; выделени€ (соответственно и подсчета) ингридиентов кабел€
;;; тыкаешь по планке кабел€ - подсвечиваютс€ его жилы
;;; использована при разработке проектов Ѕерезовской √–Ё—
;;; -kakt00z-Щ  ©


;;;;
;;;(vla-intersectwith
;;;  (vlax-ename->vla-object (car (entsel)))
;;;  (vlax-ename->vla-object (car (entsel)))
;;;  ) 
;;;
;;;(vlax-dump-Object (vlax-ename->vla-object (car (entsel))) T)



(defun c:cm (/ ss)
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0
			       "highlight" (getvar "highlight")
			       "limcheck" 0
			       "osmode" 0
			       ) T);list
    );acet-error-init
  
  (setq ss (get-cable-members))
  
  (acet-error-restore)
  (vla-endundomark #actdoc)
  (sssetfirst nil ss)
  );defun

;(sssetfirst nil (get-cable-members))


(defun get-cable-members ( / lobj pt)

  (if (setq lobj (entsel))
    (setq lobj (car lobj))
    )
  (vl-cmdf "_zoom" "_o" lobj "")
  (setq lobj (vlax-ename->vla-object lobj))
  (setq	lst (ss->lsto* (ssget "_f" (list
	(vlax-safearray->list (vlax-variant-value (vla-get-StartPoint lobj)))
	(setq pt (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint lobj))))
	) '((0 . "LINE")))))
  (setq lst
	 (vl-remove-if
	   '(lambda (x)
	      (and
		(> (abs (- (car pt) (car (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint x)))))) 0.01)
		(> (abs (- (car pt) (car (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint x)))))) 0.01)
		)
	      )
	   (vl-remove lobj lst)
	   )
	 )
  ;(sssetfirst nil (lst-to-ss (mapcar 'vlax-vla-object->ename lst)))
  (lst-to-ss (mapcar 'vlax-vla-object->ename lst))
  );defun









;;;
;;;(defun get-cable-members ( /
;;;	      e
;;;	      eng
;;;	      p1
;;;	      p2
;;;	      o
;;;	      x
;;;	      ss
;;;	      i
;;;	      corient 		; направление линии кабел€
;;;	      )
;;;  
;;;  (setq e (car (entsel))
;;;	eng (entget e)
;;;	p1 (cdr (assoc 10 eng))
;;;	p2 (cdr (assoc 11 eng))
;;;	)
;;;  (cond
;;;    ((= (car p1) (car p2)) (setq corient "V"))
;;;    ((= (cadr p1) (cadr p2)) (setq corient "H"))
;;;    (T ((princ "кабель не ортогонален")(exit)))
;;;    )
;;;
;;;  (setq	x (car p1))
;;;  (vl-cmdf "_zoom" "_o" e "")
;;;  
;;;  (setq	ss (ssget "_f" (list p1 p2))
;;;	ss (ssdel e ss )
;;;	i 0)
;;;  (repeat (sslength ss)
;;;    (if (or
;;;	  (= "INSERT" (cdr (assoc 0 (entget (ssname ss i)))))
;;;	  (= "*TEXT" (cdr (assoc 0 (entget (ssname ss i)))))
;;;	  (< (- (cadr (assoc 10 (entget (ssname ss i)))) (cadr (assoc 11 (entget (ssname ss i))))) 0.01)
;;;	  (and
;;;	    (> (abs (- x (cadr (assoc 10 (entget (ssname ss i)))))) 0.01)
;;;	    (> (abs (- x (cadr (assoc 11 (entget (ssname ss i)))))) 0.01)
;;;	    )
;;;	  )
;;;      (setq ss (ssdel (ssname ss i) ss))
;;;      (setq i (1+ i))
;;;      )
;;;    )
;;;  ss
;;;  );defun