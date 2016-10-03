;(defun c:mf (/ et p)
;  (setq et (car (entsel "\n pick  a line")))
;  (setq p (getpoint "\n pick a point"))
;
;
; (ktz-move-line-to-pt et p)
;)					;


(defun ktz-move-line-to-pt (ent pt / pti en eng pf bpt)
  (if (eq (cdr (assoc 0 (entget ent)))
	  "LINE"
      )					;then
    (progn
      (setq eng (entget ent))


      (setq vector
	     (ktz-vect-dif (cdr (assoc 11 eng)) (cdr (assoc 10 eng)))
      )


      (setq eng	(subst (cons 10 pt)
		       (assoc 10 eng)
		       eng
		)
      )

      (setq eng	(subst (cons 11 (ktz-vect-sum pt vector))
		       (assoc 11 eng)
		       eng
		)
      )
      (entmod eng)
      (entupd ent)


    )					;progn
					;else
    (prompt "\n это не линия")
  )					;if
)					;defun