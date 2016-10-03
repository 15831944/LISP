(vl-load-com)
(setq dclanumfile (strcat (getenv "temp") "\\dclanum.dcl")
      hand	(open dclanumfile "w"))

(foreach item
	 '("
dcl_ktz_numerator: dialog
	{label=\"ktz-numerator\";
	:edit_box{label=\"Порядковый номер аттрибута блока\"; key=\"pnatt\"; edit_width=6; value=1; children_alignment=centered; children_fixed_width=true;}
	:edit_box{label=\"Первая цифра нумерации (001)\"; key=\"z\"; edit_width=6; value=1;}
	:edit_box{label=\"Приращение\"; key=\"dz\"; edit_width=6; value=1;}
	:edit_box{label=\"Префикс\"; key=\"lit\"; edit_width=6;}
	:edit_box{label=\"Суффикс\"; key=\"suf\"; edit_width=6;}
	:spacer{height=1;}
	:row {
	      :radio_column{label=\"Сортировка\"; key=\"a\"; children_alignment=centered; children_fixed_width=true;
	      	:radio_button{label=\"XY\"; key=\"a1\"; value=\"1\";}
	      	:radio_button{label=\"YX\"; key=\"a2\"; value=\"0\";}
	      	}
	      :spacer{width=1;}	 
	      :radio_column{label=\"1-ый параметр\"; key=\"b\";
	         :radio_button{label=\"По возрастанию\"; key=\"b1\"; value=\"1\";}
	         :radio_button{label=\"По убыванию\"; key=\"b2\"; value=\"0\";}
	      	 }
	      :spacer{width=1;}   
	      :radio_column{label=\"2-ой параметр\"; key=\"c\";
	         :radio_button{label=\"По возрастанию\"; key=\"c1\"; value=\"0\";}
	         :radio_button{label=\"По убыванию\"; key=\"c2\"; value=\"1\";}
	         }
	      }
	      :paragraph{
	      	:text_part{label=\"При нумерации по двум координатам, ряды и\";}
	      	:text_part{label=\"колонны элементов должны быть строго ровными\";}
	      	}
	      	ok_cancel;
	      	}
	   ")
  
  (write-line item hand)
	 );foreach
(close hand)



(defun c:anum (/ dcl_id pnatt razr lit suf z dz sort sort1 sort2 lst)
  (if (< (setq
	   dcl_id (load_dialog
		    (strcat (getenv "temp") "\\dclanum.dcl")
		    ) ;_ конец load_dialog
	   ) ;_ конец setq
	 0
	 ) ;_ конец <
    (exit)
    ) ;if


  (if (not (new_dialog "dcl_ktz_numerator" dcl_id))
    (exit)
    ) ;_ конец if



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
		       )" "(setq lst (list pnatt z dz lit suf sort))"
      "(done_dialog)" ")") ;_ конец strcat
 ;_ конец strcat
    ) ; action-tile accept


  (start_dialog)
  (unload_dialog dcl_id)

  (if lst
    (ktz-numerator lst)
    ) ;_ конец if


  ) ;defun 





;;lst = '(n_att	z	dz	lit	suf	sort)
;;lst = '(1	"3"	1	"y"	"-1"	(1 1 1))
(defun ktz-numerator (lst    /	    n_att  z	  dz	 n	lit
		      suf    str    prefix sort	  ss	 i	en-lst
		      entg   ent    cmd1   cmd2	  cmd+-1 cmd+-2	txtsz
;;; наибольшая высотаа текста
		      tsz
;;; выстоа текущего текста
		      pXY    doc
		      )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)

  (acet-error-init
    (list (list	"cmdecho"
		0
		"expert"
		nil
		) ;list
	  T
	  ) ;list
    ) ;acet-error-init

  (if (not (setq ss (ssget "_I")))
    (setq ss (ssget))
    ) ;_ конец if


  (setq
    i	  0
    n_att (car lst)
    lst	  (cdr lst)
    z	  (car lst)
    lst	  (cdr lst)
    dz	  (car lst)
    lst	  (cdr lst)
    n	  (atoi z)
    lit	  (car lst)
    lst	  (cdr lst)
    suf	  (car lst)
    sort  (cadr lst)
    ) ;_ конец setq

  (if (not ss)
    (exit)
    ) ;_ конец if

  (if (= (strlen z)
	 (strlen (itoa n))
	 ) ;_ конец =
    (setq frefix nil
	  str lit
	  ) ;_ конец setq
    (setq prefix T)
    ) ;if
  (setq txtsz 0.1)

  (if (= 1 (car sort))
    (progn (setq cmd1 '(car)) (setq cmd2 '(cadr)))
    (progn (setq cmd1 '(cadr)) (setq cmd2 '(car)))
    ) ;if

  (if (= 1 (caddr sort))
    (progn
      (setq cmd+-2 '(<))
      (if (= 1 (cadr sort))
	(setq cmd+-1 '(>))
	(setq cmd+-1 '(<))
	) ;_ конец if
      ) ;progn
    (progn
      (setq cmd+-2 '(>))
      (if (= 1 (cadr sort))
	(setq cmd+-1 '(<))
	(setq cmd+-1 '(>))
	) ;_ конец if
      ) ;progn
    ) ;if



  (repeat (sslength ss)
    (if	(and
	  (not (equal
		 '(0 0 0)
		 (cdr (assoc 11 (entget (ssname ss i))))
		 ) ;_ конец equal
	       ) ;_ конец not
	  (equal '(0 . "*TEXT") (assoc 0 (entget (ssname ss i))))
	  ) ;and
      (setq pXY 11)
      (setq pXY 10)
      ) ;_ конец if
    (setq en-lst
	   (append
	     en-lst
	     (list
	       (list (setq ent (ssname ss i))
		     (list (car (setq ent (cdr (assoc pXY (entget ent)))))
			   (cadr ent)
			   ) ;_ конец list
		     ) ;_ конец list
	       ) ;_ конец list
	     ) ;append
	  ) ;setq

    (setq tsz (cdr (assoc 40 (entget (ssname ss i)))))
    (if	(> tsz txtsz)
      (setq txtsz tsz)
      ) ;_ конец if

    (setq i (1+ i))
    ) ;repeat   expt

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
				   ) ;_ конец append
			   ) ;eval
		     ) ;_ конец lambda
		  ) ;_ конец vl-sort
	) ;_ конец setq


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
				   ) ;_ конец append
			   ) ;eval
		     ) ;_ конец lambda
		  ) ;_ конец vl-sort
	) ;_ конец setq


  (foreach ent en-lst
    (setq ent (car ent))
    (if	(= "INSERT"
	   (cdr (assoc 0 (entget ent)))
	   ) ;_ конец =
      (repeat n_att (setq ent (entnext ent)))
      ) ;if
    (setq entg (entget ent))






;;;*****************************************************************************************
    (if	prefix
      (progn
	(setq str "")
	(repeat	(- (strlen z) (strlen (itoa (+ (* i dz) n))))
	  (setq str (strcat str "0"))
	  ) ;repeat
	(setq str    (strcat lit str)
	      prefix nil
	      ) ;_ конец setq



	) ;progn
      ) ;_ конец if


    (setq entg (subst (cons 1 (strcat str (itoa (+ (* i dz) n)) suf))
		      (assoc 1 entg)
		      entg
		      ) ;_ конец subst
	  ) ;_ конец setq


    (entmod entg)
    (entupd (cdr (assoc -1 entg)))
    (if	(< (strlen (itoa (+ (* i dz) n)))
	   (strlen (itoa (+ (* dz (1+ i)) n)))
	   ) ;_ конец <
      (setq prefix T)
      ) ;if
    (setq i (1+ i))
    ) ;foreach

  (vla-endundomark doc)
  (princ)
  ) ;defun