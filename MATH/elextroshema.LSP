
;;;  целесообразно рассчитывать схемы только метолом потенициалов



--|-|_1_|-|_2_|-|_3_|-|-|_5_|-|--
  |		      |	      |	
  |-------------|_4_|--	      |
  |			      |
  ----------------------|_6_|--



(p (list (s (list (p (list (s (list r1 r2 r3)) r4)) r5)) r6))




(defun s (lst)
  (apply '+ lst)
  )



(defun p (lst)
  (/ 1.0
     (apply '+
	    (mapcar
	      '(lambda (x)
		(/ 1.0 x)
		)
	      lst
	      )
	    )
     )
  )


(setq
  r1 1
  r2 2
  r3 3
  r4 4
  r5 5
  r6 6
  )



(p (list (s (list (p (list (s (list r1 r2 r3)) r4)) r5)) r6))