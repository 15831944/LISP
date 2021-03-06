
(defun c:anum (/ dcl_id	pnatt razr lit suf z dz sort sort1 sort2 lst)
  (if (< (setq
	   dcl_id (load_dialog
		    "D:\\LISP WORKING\\��������\\dcl-ktz-numerator.DCL"
		    ) ;_ ����� load_dialog
	   ) ;_ ����� setq
	 0
	 ) ;_ ����� <
    (exit)
    );if


  (if (not (new_dialog "dcl_ktz_numerator" dcl_id))
    (exit)
    ) ;_ ����� if



  (action_tile
    "accept"
    (strcat
      "(progn"
      "(setq	pnatt	(atoi (get_tile \"pnatt\"))
		z	(get_tile \"z\")
		dz	(atoi (get_tile \"dz\"))
		lit	(get_tile \"lit\")
		suf	(get_tile \"suf\")
		sort	(list
			(atoi (get_tile \"a1\"))
			(atoi (get_tile \"b1\"))
			(atoi (get_tile \"c1\"))
			)
		       )"
      "(setq lst (list pnatt z dz lit suf sort))"
      "(done_dialog)"
      ")"
      ) ;_ ����� strcat
    ); action-tile accept


  (start_dialog)
  (unload_dialog dcl_id)

  (if lst (ktz-numerator lst))


  );defun 





;;lst = '(n_att	z	dz	lit	suf	sort)
;;lst = '(1	"3"	1	"y"	"-1"	(1 1 1))
(defun ktz-numerator (lst
		  /
		  n_att
		  z
		  dz    
		  n
		  lit
		  suf    
		  str
		  prefix
		  sort
		  ss
		  i
		  en-lst
		  entg
		  ent
		  cmd1
		  cmd2
		  cmd+-1
		  cmd+-2
		  txtsz		;;; ���������� ������� ������
		  tsz		;;; ������ �������� ������
		  pXY
		  doc
		  )
  (vl-load-com)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)

  (acet-error-init
    (list (list	"cmdecho"
		0
		"expert"
		nil
		)			;list
	  T
	  )				;list
    )					;acet-error-init

  (if (not (setq ss (ssget "_I")))
    (setq ss (ssget))
    ) ;_ ����� if


  (setq	
	i     0
	n_att	(car lst)	lst	(cdr lst)
	z	(car lst)	lst	(cdr lst)
	dz	(car lst)	lst	(cdr lst)
	n	(atoi z)	
	lit	(car lst)	lst	(cdr lst)
	suf     (car lst)	sort	(cadr lst)
	) ;_ ����� setq

  (if (not ss) (exit))

  (if (= (strlen z)
	 (strlen (itoa n)))
    (setq frefix nil
	  str lit)
    (setq prefix T)
    );if
  (setq txtsz 0.1)

  (if (= 1 (car sort))
    (progn (setq cmd1 '(car)) (setq cmd2 '(cadr)))
    (progn (setq cmd1 '(cadr)) (setq cmd2 '(car)))
    );if
  
  (if (= 1 (caddr sort))
    (progn
      (setq cmd+-2 '(<))
      (if (= 1 (cadr sort))
	(setq cmd+-1 '(>))
	(setq cmd+-1 '(<))
	) ;_ ����� if
      )	;progn
    (progn
      (setq cmd+-2 '(>))
      (if (= 1 (cadr sort))
	(setq cmd+-1 '(<))
	(setq cmd+-1 '(>))
	) ;_ ����� if
      );progn
    );if



  (repeat (sslength ss)
    (if	(and
	  (not (equal
		 '(0 0 0)
		 (cdr (assoc 11 (entget (ssname ss i))))
		 ) ;_ ����� equal
	       ) ;_ ����� not
	  (equal '(0 . "*TEXT") (assoc 0 (entget (ssname ss i))))
	  );and
      (setq pXY 11)
      (setq pXY 10)
      ) ;_ ����� if
    (setq en-lst
	   (append
	     en-lst
	     (list
	       (list (setq ent (ssname ss i))
		     (list (car (setq ent (cdr (assoc pXY (entget ent)))))
			   (cadr ent)
			   ) ;_ ����� list
		     ) ;_ ����� list
	       ) ;_ ����� list
	     );append
	  );setq

    (setq tsz (cdr (assoc 40 (entget (ssname ss i)))))
    (if	(> tsz txtsz)
      (setq txtsz tsz)
      ) ;_ ����� if

    (setq i (1+ i))
    )					;repeat   expt

  (setq i 0)


  (setq	en-lst
	 (vl-sort en-lst
		  '(lambda (a b)
		     (eval (append cmd+-1
				   '((-
				      (eval (append cmd1 '((cadr a))))
				      (eval (append cmd1 '((cadr b))))
				      )
				     txtsz
				     )
				   ) ;_ ����� append
			   )		;eval
		     ) ;_ ����� lambda
		  ) ;_ ����� vl-sort
	) ;_ ����� setq


  (setq	en-lst
	 (vl-sort en-lst
		  '(lambda (a b)
		     (eval (append cmd+-2
				   '((-
				      (eval (append cmd2 '((cadr a))))
				      (eval (append cmd2 '((cadr b))))
				      )
				     txtsz
				     )
				   ) ;_ ����� append
			   );eval
		     ) ;_ ����� lambda
		  ) ;_ ����� vl-sort
	) ;_ ����� setq

  
  (foreach ent en-lst
    (setq ent (car ent))
    (if	(= "INSERT"
	   (cdr (assoc 0 (entget ent)))
	   ) ;_ ����� =
      (repeat n_att (setq ent (entnext ent)))
      );if
    (setq entg (entget ent))






;;;*****************************************************************************************
    (if prefix
      (progn
	(setq str "")
	(repeat 	(- (strlen z) (strlen (itoa (+ (* i dz) n))))
	  (setq str (strcat str "0"))
	  );repeat
	(setq str (strcat lit str)
	      prefix nil)
	
	
	
      );progn
      )

    
    (setq entg (subst (cons 1 (strcat str (itoa (+ (* i dz) n)) suf))
		      (assoc 1 entg)
		      entg
		      ) ;_ ����� subst
	  ) ;_ ����� setq


    (entmod entg)
    (entupd (cdr (assoc -1 entg)))
    (if (< (strlen (itoa (+ (* i dz) n)))
	   (strlen (itoa (+ (* dz (1+ i)) n)))
	   )
      (setq prefix T)
      );if
    (setq i (1+ i))
    );foreach

  (vla-endundomark doc)
  (princ)
  )					;defun