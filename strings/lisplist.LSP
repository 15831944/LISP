;;; находим символ ), заменяем на )[enter]
(defun lisplist (
		 /
		 to
		 strl
		 nstr
		 )
  (setq to (vlax-ename->vla-object (car (entsel))))
  (setq strl (VL-STRING->LIST(vla-get-TextString to))
	nstr '())
  
  (foreach item strl
    (cond
      ;((= 78 item) (setq nstr (append nstr (list 51 78))))	;
      ((= 41 item) (setq nstr (append nstr (list 41 10))))	; (+enter
      ;((= 80 item) (princ))					; del enter
      ;((= 47 item) (princ))					; del enter
      ;((= 80 item) (setq nstr (append nstr (list 32))))	; (+enter
      ;((= 219 item) (setq nstr (append nstr (list 10))))	; (+enter
      ;((= 95 item) (setq nstr (append nstr (list 10))))		; _ -> enter
      
      
      ;((= 92 item) (setq nstr (append nstr (list 32))))	; / на " "
      ;((= 34 item) (setq nstr (append nstr (list 32))))	; """  на " "
      ;((= 10 item) (setq nstr (append nstr (list 32))))	;
      (T (setq nstr (append nstr (list item))))
      );
    )
  (vla-put-TextString to (vl-list->string nstr))
  );defun


(defun lisplist2 (
		  /
		  mto
		  tobjs
		 strl
		 nstr
		  tmp
		 )
  (defun tmp (obj / str)
    ;(setq obj (vlax-ename->vla-object (car (entsel))))
    (setq str (vl-string->list (KD-GET-TEXTSTRING obj)))
    (setq str (vl-remove-if '(lambda (x) (member x '(34 40 41))) str))
    (vla-put-TextString obj (vl-list->string str))
    )
  (setq tobjs (ssget '((0 . "TEXT"))))
  (if (null tobjs)
    (alert "Надо разбить!")
    (mapcar 'tmp (ss->lsto* tobjs))
    )
  );defun