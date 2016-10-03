(setq obj (vlax-ename->vla-object (car (entsel))))

(vlax-dump-object obj T)

(setq dynproplist
(vlax-safearray->list
  (vlax-variant-value
    (vla-GetDynamicBlockProperties obj)
    ) ;_ vlax-variant-value
  ) ;_ vlax-safearray->list
      )

(length dynproplist)
(vlax-dump-object 
(nth 2 dynproplist)
T
)



(vla-get-AllowedValues (nth 2 dynproplist))


(vlax-variant-value
  (nth 2
       (vlax-safearray->list
	 (vlax-variant-value
	   (vla-get-AllowedValues (nth 2 dynproplist))
	   ) ;_ vlax-variant-value
	 ) ;_ vlax-safearray->list
       ) ;_ nth
  ) ;_ vlax-variant-value



(vlax-make-variant "ts")


(setq sa
       (vlax-make-variant
	 (vlax-safearray-fill
	   (vlax-make-safearray vlax-vbString '(0 . 0))
	   '("ts")
	   ) ;_ vlax-safearray-fill
	 ) ;_ vlax-make-variant
      ) ;_ setq















(vlax-variant-value
  (nth 2
       (vlax-safearray->list
	 (vlax-variant-value
	   (vla-get-AllowedValues (nth 0 dynproplist))
	   ) ;_ vlax-variant-value
	 ) ;_ vlax-safearray->list
       ) ;_ nth
  ) ;_ vlax-variant-value





















(setq obj (vlax-ename->vla-object (car (entsel))))

(vlax-dump-object obj T)

(setq efname (vla-get-EffectiveName obj))

; block record
(setq blrec (cdr (assoc 330 (entget (tblobjname "block" efname) '("*")))))
(cdr (assoc 360 (entget blrec))) ; dictionary


(setq lst-dict
       (mapcar 'cdr
	       (vl-remove-if-not
		 '(lambda (x) (= (car x) 360))
		 (dictsearch
		   (cdr (assoc 360 (entget blrec)))
		   "ACAD_ENHANCEDBLOCK"
		   ) ;_ dictsearch
		 ) ;_ vl-remove-if-not
	       ) ;_ mapcar
      ) ;_ setq



(setq n17 nil)
(setq
  n15 (entget
	(car (setq
	       lst-dict	(mapcar	'cdr
				(vl-remove-if-not
				  '(lambda (x) (= (car x) 360))
				  (entget (cdr (assoc 360 (entget blrec))))
				  ) ;_ vl-remove-if-not
				) ;_ mapcar
	       ) ;_ setq
	     ) ;_ car
	) ;_ entget
  ) ;_ setq

(setq
  n16 (mapcar
	'(lambda (z)
	   (setq n17 (cons (cdr (assoc 300 (entget (cdr z)))) n17))
	   ) ;_ lambda
	(vl-remove-if-not
	  '(lambda (y)
	     (= (cdr (assoc 0 (entget (cdr y)))) "BLOCKLOOKUPACTION")
	     ) ;из всех словарей выбираем только "BLOCKLOOKUPACTION"
	  (vl-remove-if-not
	    '(lambda (x) (= (car x) 360))
	    (entget (car lst-dict))
	    ) ;_ vl-remove-if-not
	  ) ;_ vl-remove-if-not
	) ;_ mapcar
  ) ;выбираем все словари с дин. свойствами



















(assoc 330 (tblsearch "block" efname '("*")))

(entget (setq aa (cdr (assoc -2 (tblsearch "BLOCK" efname)))))
(vl-load-com)
