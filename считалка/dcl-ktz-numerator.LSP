
(defun sh-num (
	       /
	       dcl_id
	       pnatt
	       razr
	       lit
	       z
	       sort
	       sort1
	       sort2
	       lst
	       )
  (if (< (setq dcl_id (load_dialog "D:\\LISP WORKIG\\считалка\\dcl-ktz-numerator.DCL"))
	 0)
    (exit)
    );if

  
  (if (not (new_dialog "dcl_ktz_numerator" dcl_id))
    (exit))



    (action_tile "accept"
      (strcat
	"(setq	pnatt	(atoi (get_tile \"pnatt\"))
		z	(atoi (get_tile \"z\"))
		razr	(atoi (get_tile \"razr\"))
		lit	(atoi (get_tile \"lit\"))
		sort	(list
			(atoi (get_tile \"a1\"))
			(atoi (get_tile \"b1\"))
			(atoi (get_tile \"c1\"))
			)
		       )"
	"(setq lst (list pnatt z razr lit sort))"
	"(princ z)"
	"(done_dialog)"
	";(numerator lst)"
	
	)
    ); action-tile accept


  (start_dialog)
  (unload_dialog dcl_id)



  
  (princ)
);defun 






;;lst = '(1 3 nil "y" (1 1 1))
(defun numerator (lst
		  /
		  n_att
		  z
		  razr
		  lit
		  sort
		  
		  ss
		  i
		  en-lst
		  entg
		  ent
		  cmdXY
		  cmd+-1
		  cmd+-2
		  )


  (setq	ss 	(ssget)
	i	0
	n_att	(car lst)	lst	(cdr lst)
	z	(car lst)	lst	(cdr lst)
	razr	(car lst)	lst	(cdr lst)
	lit	(car lst)	sort	(cadr lst)
	)
  (princ ss)
  (princ n_att)
  (princ "\n")
  (princ z)
  (princ "\n")
  (princ razr)
  (princ "\n")
  (princ lit)
  (princ "\n")
  (mapcar 'princ sort)
  (princ "\n")

  (if (= 1 (car sort))
    (setq cmdXY '(car))
    (setq cmdXY '(cadr))
    );if

  (if (= 1 (cadr sort))
    (setq cmd+-1 '(<))
    (setq cmd+-1 '(>))
    );if


  

;;; создаем список с именами объектов и параметром для сортировки
  
  (repeat (sslength ss)
    (setq en-lst
	   (append en-lst
		   (list (list (setq ent (ssname ss i))
			       (eval (append cmdXY '((cdr (assoc 10 (entget ent)))))) ;X
			       )
		   )
	   )
    )

    (setq i (1+ i))
  )					;repeat
  (setq i 0)



;;;************************************************************
  (setq	en-lst (vl-sort en-lst
			  '(lambda (a b)
			     (eval (append cmd+-1 '((cadr a)
						    (cadr b))
					   )
			     )
			   )
		 )
  )
;;;************************************************************

  (foreach ent en-lst
    (setq ent (car ent))
    (if (= "INSERT"
	   (cdr(assoc 0 (entget ent))))
    (repeat n_att (setq ent (entnext ent))))
    (setq entg (entget ent))
    (setq entg (subst (cons 1 (strcat lit (itoa (+ i z))))
			   (assoc 1 entg)
			   entg
		    )
    )


    (entmod entg)
    (entupd (cdr (assoc -1 entg)))
    (setq i (1+ i))
  );foreach
(princ)
);defun