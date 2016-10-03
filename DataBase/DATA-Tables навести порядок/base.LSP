


(defun base (/
	     elst1
	     elist2
	     elist3
	     ;bs
	     poz
	     txt
	     flt
	     i
	     ;klist
	     chered

	     namlist
	     pozlist
	     marklist
	     e
	     eng
	     nof		;number of signals
	     doc
	     )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init
  
  

  (setq elist1 (ss->sorted-lst "/nукажите позиции"))
  (setq elist2 (ss->sorted-lst "/nукажите имена сигналов"))
  (setq elist3 (ss->sorted-lst "/nукажите имена марки хвостов"))

  (setq	bs '()
	chered '()
	klist '()
	namlist '()
	pozlist '()
	i  0
	) ;_ setq




  (repeat (length elist1)
;    (if
;      (< 7 (strlen
    (setq poz (cdr (assoc 1 (entget (nth i elist1)))))
;    ))
;      (progn
    
	(setq txt (mt->t (cdr (assoc 1 (entget (nth i elist2))))))
        (setq mark (cdr (assoc 1 (entget (nth i elist3)))))
	(setq bs (append bs (list
			      (list
				mark
				poz
				txt
				) ;_ cons
			      ) ;_ list
			 ) ;_ append
	      ) ;_ setq
;	);progn
;      );if

    (setq i (1+ i))
    ) ;repeat

  (setq nof (length bs))

  
	
  (setq klist (ss->sorted-lst "/nукажите марки на клеммнике"))
  (setq klist (mapcar '(lambda (x) (cdr (assoc 1 (entget x))))
		      klist
		      )
	)
;;;  (if (/= (* nof 3) klist)
;;;    (progn
;;;      (alert "не все сигналы на клеммнике")
;;;      (exit)
;;;      )
;;;    )
  
  (setq i 0)
;  (repeat (/ (length klist) 3)
;;;  (repeat (length klist)
;;;    (setq chered (append chered (list
;;;				  (substr (nth i klist) 1 (vl-string-position (ascii "-") (nth i klist)))
;;;				  )))
;;;    (setq i (+ i 3))
;;;    );repeat

  (setq namlist (ss->sorted-lst "/nукажите имена сигналов в подключении"))

  (if (/= nof (length namlist))
    (progn
      (alert (strcat "количество сигналов должно быть " (itoa nof)))
      (exit)
      )
    )
  
  (setq i 0)

  (repeat (length namlist)
    (setq e (nth i namlist))
    (setq eng (entget e))
    (setq eng (subst
;		(cons 1 (cdr (assoc (nth i chered) bs)))
		(cons 1 (caddr (assoc (nth i klist) bs)))
		(assoc 1 eng)
		eng
		))
    (entmod eng)
    (entupd e)
    (setq i (1+ i))
    )




  (setq pozlist (ss->sorted-lst "/nукажите позиции сигналов в подключении"))
  (if (/= nof (length pozlist))
    (progn
      (alert "не совпадает количество позиций")
      (exit)
      )
    )
  
  (setq i 0)

  (repeat (length pozlist)
    (setq e (nth i pozlist))
    (setq eng (entget e))
    (setq eng (subst
		;(cons 1 (nth i chered))
		(cons 1 (cadr (assoc (nth i klist) bs)))
		(assoc 1 eng)
		eng
		))
    (entmod eng)
    (entupd e)
    (setq i (1+ i))
    )






  (setq marklist (ss->sorted-lst "/nукажите марки в подключении"))
  (if (/= nof (length marklist))
    (progn
      (alert "не совпадает количество марок")
      (exit)
      )
    )
  
  (setq i 0)

  (repeat (length marklist)
    (setq e (nth i marklist))
    (setq eng (entget e))
    (setq eng (subst
		;(cons 1 (nth i chered))
		(cons 1 (nth i klist))
		(assoc 1 eng)
		eng
		))
    (entmod eng)
    (entupd e)
    (setq i (1+ i))
    )
  

  (acet-error-restore)
  (vla-endundomark doc)
  ) ;defun



(defun mt->t (mtxt
	      /
	      txt
	      tmp
	      i
	     )
  ;(setq txt (vl-string->list (cdr (assoc 1 (entget (car (entsel)))))))
  (setq txt (vl-string->list mtxt))

  (setq	i   0
	tmp '()
  )
  (repeat (length txt)
    (if	(and
	  (= 92 (nth i txt))
	  (= 80 (nth (1+ i) txt))
	)
      (progn
	(setq i (1+ i))
	(setq tmp (append tmp (list 32)))
      )
      (setq tmp (append tmp (list (nth i txt))))
    )					;if
    (setq i (1+ i))
  );repeat
  (vl-list->string (vl-remove-if 'null tmp))
  )








(defun make-signal-base (/
			 pozs
			 descriptions
			 k
			 i
			 )
  (setq signal-base '())
  (setq pozs (mapcar '(lambda (x) (cdr (assoc 1 (entget x))))
		     (ss->sorted-lst "/nукажите позиции")
		     )
	)
  (setq descriptions (mapcar '(lambda (x) (cdr (assoc 1 (entget x))))
			     (ss->sorted-lst "/nукажите имена сигналов")
			     )
	)

  (if (= (length descriptions) (setq k (length pozs)))
    (progn
      (setq i 0)
      (repeat k
	(setq signal-base (append signal-base (list
						(cons (nth i pozs) (nth i descriptions))
						)))
	(setq i (1+ i))
	)
      );progn
    (progn
      (princ "\nне совпадает количество сигналов и их описаний")
      (exit)
      )
    )
  signal-base
  );defun




;;;(defun make-cable-base (
;;;			/
;;;			cables
;;;			)
;;;  (setq cable-base '())
;;;  (setq cables (mapcar '(lambda (x) (cdr (assoc 1 (entget x))))
;;;		     (ss->sorted-lst "/nукажите марки кабелей")
;;;		     ))
;;;  
;;;
;;;  
;;;  )



(defun get-base220AC (
		  /
		  pozs
		  signal-names
		  marka-A
		  marka-N
		  i
		  baza
		  doc

		  
		  )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init
  (alert "\nфаза извлечения данных")
  
  (setq	pozs	     (ss->sorted-lst "/nукажите позиции")
	signal-names (ss->sorted-lst "/nукажите имена сигналов")
	marka-A	     (ss->sorted-lst "/nукажите марку фазы")
	marka-N	     (ss->sorted-lst "/nукажите марку нейтрали")
	i	     0
	baza	     '()
	) ;_ setq
  (repeat (length pozs)
    (setq baza (append baza
		       (list
			 (list
			 (nth i pozs)
			 (nth i signal-names)
			 (nth i marka-A)
			 (nth i marka-N)
			 )

			 ) ;_ list
		       ) ;_ append
	  ) ;_ setq

    (setq i (1+ i))
    ) ;_ repeat
    
  (acet-error-restore)
  (vla-endundomark doc)
  baza
  ;(alert "\nфаза заполнения")
  ) ;defun






(defun put-base220AC (baza
		  /
		  pozs
		  signal-names
		  marka-A
		  marka-N
		  i
		  baza-to-put
		  doc

		  
		  )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init
  (alert "\nфаза заполнения")
  
  (setq	pozs		(ss->sorted-lst "/nукажите позиции")
	signal-names	(ss->sorted-lst "/nукажите имена сигналов")
	marks		(ss->sorted-lst "/nукажите марки")
	marka-A (car marks)
	marka-N (cadr marks)
	i	     0
	baza-to-put	     '()
	) ;_ setq
  
  (repeat (length baza)
    (setq baza-to-put (append baza-to-put
		       (list
			 (list
			   (nth i pozs)
			   (nth i signal-names)
			   (nth i marka-A)
			   (nth i marka-N)
			 )

			 ) ;_ list
		       ) ;_ append
	  ) ;_ setq

    (setq i (1+ i))
    ) ;_ repeat

  (putbase baza baza-to-put)
    
  (acet-error-restore)
  (vla-endundomark doc)
  ;baza
  
  ) ;defun


;;;(defun putbase (
;;;		/
;;;		)
;;;  );defun