

(setq obj (vlax-ename->vla-object (car (entsel))))


(defun smarttextrotate (obj / ang justify)
  (setq ang (* 180 (/ (vla-get-Rotation obj) Pi)))

  (cond
    (()())
    )
  
  )