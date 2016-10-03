(defun txt->char (e
		  /
		  ;e
		  eg
		  eo
		  p1
		  p2
		  len
		  rot
		  ip
		  str
		  strl
		  lens
		  sl
		  i
		  bp
		  )
  
;(setq e (car (entsel)))
(setq eg (entget e))
(setq eo (vlax-ename->vla-object e))
;(vlax-dump-object eo T)

(vla-GetBoundingBox eo 'p1 'p2)
(setq p1 (vlax-safearray->list p1))
(setq p2 (vlax-safearray->list p2))
;для гориз
(setq len (- (car p2) (car p1)))

(setq rot (vla-get-ObliqueAngle eo))


(setq ip (vla-get-InsertionPoint eo))
(setq ip (vlax-safearray->list (vlax-variant-value ip)))

(setq str (vla-get-TextString eo))
(setq strl (vl-string->list str))
(setq lens (strlen str))


(setq sl (/ len lens))


(setq i 0)
(repeat lens
  (setq bp (list
	     (+ (car ip) (* i sl))
	     (cadr ip)
	     ;(- (cadr ip) i)
	     ))
  ;(ascii " ") 32
  (if
    (/= 32 (nth i strl)	)
  (entmake (list
	     '(0 . "TEXT")
	     '(40 . 2.5)
	     (assoc 7 eg)
	     (cons 10 bp)
	     (cons 1 (chr (nth i strl)))
	     ))
  )
  (setq i (1+ i))
  )
)




(defun ssx (
	    /
	    ss
	    i
	    )
  (setq ss (ssget)
	i 0)
  (repeat (sslength ss)
    (txt->char (ssname ss i))
    (setq i (1+ i))
    )
  
  );defun