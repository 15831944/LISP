


(do
  (nth 2 (kd-container->list (vla-get-RegisteredApplications #actdoc)))
  )


(entget (vlax-vla-object->ename (nth 1 (kd-container->list (vla-get-RegisteredApplications #actdoc)))))



(mapcar
  '(lambda (x)
     (vla-get-name x)
     )
  (kd-container->list (vla-get-RegisteredApplications #actdoc))
  )



(entget (vlax-vla-object->ename (vla-item (vla-get-RegisteredApplications #actdoc) "RAK")))



(ssget "_X" '((1000 . "RAK")))


(setq e (car (entsel)))
(entget e)



(setq e (entnext))
(while (setq e (entnext e))
  (setq eng (entget e '("*")))
  (setq a 
  (vl-remove-if
    '(lambda (x)
       (or
	 (member (car x) '(-1 1 0 11 13 14 15 16 281 146 292 282 141 142 63 421 17 38 39
			 170 61
			 72 73 6 7 51 110 111 112 79 410 348 340 12 74 68 91 90 68 69 330
			 360 102 370 5 100 67 8 62 2 10 40 41 42 43 50 70 71 44 45 210
			 1002 280 66
			 ))
	 ;(= ACET-TEXTMASK (car (cdr (assoc -3 x))))
	 
	 
	 )
       )
    eng
    )
	)
  (if a
    (progn
      (setq latseng a)
      (princ a)
      (princ "\n")
      )
    )
  )
  
(entget (setq e (entnext e)))


(do (vla-HandleToObject #actdoc "1F63F8"))