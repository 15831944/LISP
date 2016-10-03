


(setq mn 31 rn 8) ; количество  модулей и реле
(setq mnl nil rnl nil)
(setq res nil)


(while (> mn 24) (setq mnl (cons (itoa mn) mnl)) (setq mn (1- mn)))
(while (> rn 0) (setq rnl (cons (itoa rn) rnl)) (setq rn (1- rn)))


(setq res
       (mapcar
	 '(lambda (mn)
	    (mapcar
	      '(lambda (rn)
		 (list
		   ;(strcat "ADX-" mn) rn "" "" "11" "14"
		   ;(strcat "DIX-" mn) rn "" "" "A1" "A2"
		   ;(strcat "DOX-" mn) rn "" "" "11" "14"
		   (strcat "ADX-" mn) rn ;"" "" "11" "14"
		   )
		 )
	      rnl
	      )
	    )
	 mnl
	 )
      )





(lst>excel (apply 'append res))









(setq mn 20 rn 8) ; количество  модулей и реле
(setq mnl nil rnl nil )
(setq res nil)

(while (> mn 0) (setq mnl (cons (itoa mn) mnl)) (setq mn (1- mn)))
(while (> rn 0) (setq rnl (cons (itoa rn) rnl)) (setq rn (1- rn)))


(setq res
       (mapcar
	 '(lambda (mn)
	    (mapcar
	      '(lambda (rn)
		 (list
		   (strcat "AD-" mn ":" (itoa (1- (* 4 (atoi rn))))) "[jumper]"
		   )
		 )
	      rnl
	      )
	    )
	 mnl
	 )
      )

(setq res 
(mapcar
  '(lambda (line / h c)	;(setq line (nth 13 res))
     (setq h (car line))
     (setq c (car h))
     (cons
       (list c (strcat (car (sepstr c ":")) ":21"))
       (cdr line)
       )
     )
  res))

(lst>excel (apply 'append res))








