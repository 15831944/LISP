;;; находим символ, заменяем на другой
(defun chrep (to
	      /
	      ;to
	      strl
	      nstr
	      )
  ;(setq to (vlax-ename->vla-object (car (entsel))))
  (setq
	strl (VL-STRING->LIST(vla-get-TextString to))
	nstr '())
  
  (foreach item strl
    (cond
      ;((= 78 item) (setq nstr (append nstr (list 51 78))))	;
      ;((= 40 item) (setq nstr (append nstr (list 10 40))))	; (+enter
      ;((= 80 item) (princ))					; del enter
      ;((= 47 item) (princ))					; del enter
      ;((= 80 item) (setq nstr (append nstr (list 32))))	; (+enter
      ;((= 219 item) (setq nstr (append nstr (list 10))))	; (+enter
      ((= 95 item) (setq nstr (append nstr (list 10))))		; _ -> enter
      
      
      ;((= 92 item) (setq nstr (append nstr (list 32))))	; / на " "
      ;((= 34 item) (setq nstr (append nstr (list 32))))	; """  на " "
      ;((= 10 item) (setq nstr (append nstr (list 32))))	;
      (T (setq nstr (append nstr (list item))))
      );
    )
  (vla-put-TextString to (vl-list->string nstr))
  );defun

;40 (
;92 \
;80 P
;10 \n


(defun chrep* (
	       /
	       ss
	       i
	       )
  (setq ss (ssget)
	i 0)
  (repeat (sslength ss)
    (chrep (vlax-ename->vla-object(ssname ss i)))
    (setq i (1+ i))
    )
  )