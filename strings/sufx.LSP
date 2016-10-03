; 12_11_28
; 14_01_08



(defun c:ss:sufx ( / lst pr sf)
  (setq lst (kd:dclget '("префикс" "суффикс")))
  (setq pr (car lst) sf (cadr lst))
  (ss:sufx pr sf)
  )


(defun ss:sufx (pref suf  / lst)
  (setq lst (get-ssofstrobj*))
  (mapcar '(lambda (x)
	     (vla-put-textstring x (strcat pref (vla-get-textstring x) suf))
	     )lst)
  );defun


(defun c:ss:sum ( / ans)
  (vla-startundomark #actdoc)
  (setq ans (ss:sum))
  (vla-endundomark #actdoc)
  (princ (rtos* ans))
  (princ)
  );defun

(defun ss:sum ( / lst)
  (setq lst (ssget* '((0 . "*TEXT"))))
  (if (= 'PICKSET (type lst))
    (apply '+ (mapcar 'atof* (mapcar 'kd-get-textstring (ss->lsto* lst))))
    )
  );defun



;;;(defun ss:sufx (pref suf
;;;	     /
;;;	     ss
;;;	     )
;;;  (if (not (setq ss (ssget "_I" '((0 . "*TEXT")))))
;;;    (setq ss (ssget '((0 . "*TEXT"))))
;;;    ) ;_ конец if
;;;  (setq ss (mapcar 'vlax-ename->vla-object (ss->list* ss)))
;;;
;;;  (mapcar '(lambda (x)
;;;	     (vla-put-textstring x (strcat pref (vla-get-textstring x) suf))
;;;	     ) ss)
;;;  );defun



