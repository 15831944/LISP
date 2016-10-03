;;; обратить внимание на сортировку, по чем она сделана


(defun c:ktz-numerator (/
			ss
			i
			n_att
			ent_list
			ename_get
			def
			ent

			)

  (setq def 1)
  (setq	ss (ssget)
	i  0
  )
  (initget 6)
  (setq	n_att (getint "\n порядковый номер аттрибута в блоке <1>:"))
  (if (not n_att) (setq n_att def))
  (setq
    lit	(getstring "\n перед номером <>:")
    z	(getint "\n цифру с которой начать - : <1>")
    )
    (if (not z) (setq z def))
  
;;; создаем список с именами объектов и параметром для сортировки
  (repeat (sslength ss)
    (setq ent_list
	   (append ent_list
		   (list (list (setq ent (ssname ss i))
			       (car (cdr (assoc 10 (entget ent)))) ;X
			 )
		   )
	   )
    )

    (setq i (1+ i))
  )					;repeat
  (setq i 0)



;;;************************************************************
  (setq	ent_list (vl-sort ent_list
			  '(lambda (a b)
			     (<	(cadr a)
				(cadr b)
			     )
			   )
		 )
  )
;;;************************************************************

  (foreach ent ent_list
    (setq ent (car ent))
    (if (= "INSERT"
	   (cdr(assoc 0 (entget ent))))
    (repeat n_att (setq ent (entnext ent))))
    (setq ename_get (entget ent))
    (setq ename_get (subst (cons 1 (strcat lit (itoa (+ i z))))
			   (assoc 1 ename_get)
			   ename_get
		    )
    )


    (entmod ename_get)
    (entupd (cdr (assoc -1 ename_get)))
    (setq i (1+ i))
  )					;foreach

)					;defun




















(defun numerator (n_att
		  z
		  lit
		  /
		  ss
		  i
		  n_att
		  ent_list
		  ename_get
		  def
		  ent

			)

  (setq def 1)
  (setq	ss (ssget)
	i  0
  )
;;;  (initget 6)
;;;  (setq	n_att (getint "\n порядковый номер аттрибута в блоке <1>:"))
;;;  (if (not n_att) (setq n_att def))
;;;  (setq
;;;    lit	(getstring "\n перед номером <>:")
;;;    z	(getint "\n цифру с которой начать - : <1>")
;;;    )
;;;    (if (not z) (setq z def))
  
;;; создаем список с именами объектов и параметром для сортировки
  (repeat (sslength ss)
    (setq ent_list
	   (append ent_list
		   (list (list (setq ent (ssname ss i))
			       (car (cdr (assoc 10 (entget ent)))) ;X
			 )
		   )
	   )
    )

    (setq i (1+ i))
  )					;repeat
  (setq i 0)



;;;************************************************************
  (setq	ent_list (vl-sort ent_list
			  '(lambda (a b)
			     (<	(cadr a)
				(cadr b)
			     )
			   )
		 )
  )
;;;************************************************************

  (foreach ent ent_list
    (setq ent (car ent))
    (if (= "INSERT"
	   (cdr(assoc 0 (entget ent))))
    (repeat n_att (setq ent (entnext ent))))
    (setq ename_get (entget ent))
    (setq ename_get (subst (cons 1 (strcat lit (itoa (+ i z))))
			   (assoc 1 ename_get)
			   ename_get
		    )
    )


    (entmod ename_get)
    (entupd (cdr (assoc -1 ename_get)))
    (setq i (1+ i))
  );foreach

);defun