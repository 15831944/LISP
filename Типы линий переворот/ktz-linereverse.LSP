;;; переворачивает отрезок начало - в - конец
;;; нужно в ФС для типов линий с буквами чтобы небыли вверх ногами
;;; меняет точ. пару 11 и 10

(defun reverseline (obj / tmp)
    (setq tmp (vla-get-endPoint obj))
    (vla-put-endpoint obj (vla-get-startpoint obj))
    (vla-put-startpoint obj tmp)
    )


;;;;(defun c:rev () (lswa))
;;;(defun c:PID:LineRevese ( / catchit lst)
;;;  (if (not (setq lst (ssget "_I" '((0 . "LINE")))))
;;;    (setq lst (vl-catch-all-apply 'ssget (list '((0 . "LINE")))))
;;;    )
;;;  (cond
;;;    ((= 'VL-CATCH-ALL-APPLY-ERROR (type lst)) (VL-CATCH-ALL-ERROR-MESSAGE lst))
;;;    ((null lst) (princ))
;;;    ((= 'PICKSET (type lst))
;;;     (setq lst (ss->lsto* lst))
;;;     (mapcar 'reverseline lst)
;;;     )
;;;    );cond
;;;  );defun




;(islinetoreverse (vlax-ename->vla-object (car (entsel))))
(defun c:PID:LineRevese (/ islinetoreverse reverseline lst)
  ;(defun d2r (deg) (* pi (/ deg 180.0)))
  ;(defun r2d (rad) (* (/ 180 Pi) rad))

  (defun islinetoreverse (obj / ang)
    (setq ang (vla-get-angle obj))
    (cond
      ((= (fix ang) 0) nil)
      ((= (fix ang) 1) nil)
      ((= (fix ang) 3) T)
      ((= (fix ang) 4) T)
      )
    );defun

  (defun reverseline (obj / tmp)
    (setq tmp (vla-get-endPoint obj))
    (vla-put-endpoint obj (vla-get-startpoint obj))
    (vla-put-startpoint obj tmp)
    );defun
  (setq lst (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "LINE"))))))
  (mapcar '(lambda (ln)
	     (if (islinetoreverse ln)
	       (reverseline ln)
	       ))
	     lst)
  (princ)
  );defun










  ;(defun c:rev ()(ktz-linereverse))

;;;(defun ktz-linereverse ( / ss ent entg i n10 k11)
;;;  (princ "\nвыберите линии для переворачивания")
;;;  (setq ss (ssget '((0 . "LINE")))
;;;	i 0);setq
;;;  (repeat (sslength ss)
;;;    (setq ent	(ssname ss i)
;;;	  entg	(entget ent)
;;;	  n10	(cdr (assoc 10 entg))
;;;	  k11	(cdr (assoc 11 entg))
;;;	  
;;;	  );setq
;;;    
;;;    (setq entg (subst (cons 10 k11 )
;;;		      (assoc 10 entg)
;;;		      entg))
;;;    (setq entg (subst (cons 11 n10)
;;;		      (assoc 11 entg)
;;;		      entg))
;;;    (entmod entg)
;;;    (entupd ent)
;;;    (setq i (1+ i))
;;;    );repeat
;;;
;;;  );defun
;;;(defun reverse-line-obj (obj / sp ep)
;;;  (setq sp (vla-get-StartPoint obj) ep (vla-get-EndPoint obj));setq
;;;  (vla-put-startpoint obj ep)
;;;  (vla-put-endpoint obj sp)
;;;  );defun