
(defun c:pline|explode (/ ss)
  (if (null (setq ss (ssget "_I")))
    (setq ss (ssget))
    )
  (if ss
    (mapcar 'explode-pline (ss->lsto* ss))
    )
  );defun

(defun explode-pline (obj / ) ; olst CW LW nLW)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (if (setq CW (getconstantwidth obj))
    (progn
      (setq LW (vlax-get-property obj "Lineweight"))
      (setq olst (vlax-safearray->list (vlax-variant-value (vlax-invoke-method obj "Explode"))))
      ;(vlax-put-property obj "Truecolor" black)
      ;(vlax-put-property obj "color" 250)

      (setq nLW (max (* 10 (fix (* 10 CW))) LW))
      (cond
	((= nLW 10)  (setq nLW 9))
	((> nLW 100) (setq nLW 120))
	)
      
      (foreach item olst
	(vlax-put-property item "Lineweight" nLW)
	;(vlax-put-property item "Truecolor" black)
	);foreach
      (vla-delete obj)
      )
    );if cw
  );defun

;(setq plo (vlax-ename->vla-object (car (entsel))))
;(getconstantwidth plo)

(defun getconstantwidth (plo / lc nos low i sw ew w)
  (setq lc (vlax-safearray->list (vlax-variant-value (vla-get-coordinates plo))))
  (setq nos (/ (length lc) 2))
  (setq low '() i 0)
  (repeat nos
    (vla-GetWidth plo i 'sw 'ew)
    (setq low (append low (list  sw ew)))
    (setq i (1+ i))
  )
  (setq w (islistequal low))
  (if (= w 0)
    0.3
    w
    )
  )

(defun islistequal (lst / len)
  (setq len (length lst))
  (cond ((< 2 len)(if (= (car lst) (cadr lst))
		    (islistequal (cdr lst))
		    nil))
    ((and (= 2 len) (= (car lst) (cadr lst))) (car lst))
    (T nil)
    )
  );defun