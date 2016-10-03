(defun ktz-get-and-sort-pare-ss (
			       
				 /
				 ent
				 sort-rule
				 ss
				 i
				 entlist1
				 entlist2
				 cmd1
				 cmd2
				 )
  
  
  (princ "\n [выделите исходные текстовые элементы]")
  (setq ss (ssget '(
		    (-4 . "<OR")
		    (0 . "*TEXT")
		    (0 . "insert")
		    (-4 . "OR>"))))
  (initget 1 "x -x y -y")
  (setq sort-rule (getkword "\n Отсортировано по : [x/-x/y/-y] <x> \n"))
  (cond
    ;1
    ((= sort-rule "x")
     (setq cmd1 '(car)
	   cmd2 '(<)
	   ))
    ;2
    ((= sort-rule "-x")
     (setq cmd1 '(car)
	   cmd2 '(>)
	   ))
    ;3
    ((= sort-rule "y")
     (setq cmd1 '(cadr)
	   cmd2 '(<)
	   ))
    ;4
    ((= sort-rule "-y")
     (setq cmd1 '(cadr)
	   cmd2 '(>)
	   ))
    
    );cond

  (setq i 0)
  (repeat (sslength ss)
    (setq entlist1
	   (append entlist1
		   (list (list (setq ent (ssname ss i))
			       (eval (append cmd1 '((cdr (assoc 10 (entget ent))))))
			 )
		   )
	   )
    )

    (setq i (1+ i))
  );repeat
  (setq i 0)
;;;************************************************************
  (setq	entlist1 (vl-sort entlist1
			  '(lambda (a b)
			     (eval (append cmd2 '((cadr a)
						  (cadr b)
						  )
					   )
				   )
			     )
			  )
  )
;;;************************************************************

  (princ "\n [выделите изменяемые текстовые значения]")
  (setq ss (ssget '(
		    (-4 . "<OR")
		    (0 . "*TEXT")
		    (0 . "insert")
		    (-4 . "OR>"))))
  (initget 1 "x -x y -y")
  (setq sort-rule (getkword "\n Отсортировано по : [x/-x/y/-y] <x> \n"))
  (cond
    ;1
    ((= sort-rule "x")
     (setq cmd1 '(car)
	   cmd2 '(<)
	   ))
    ;2
    ((= sort-rule "-x")
     (setq cmd1 '(car)
	   cmd2 '(>)
	   ))
    ;3
    ((= sort-rule "y")
     (setq cmd1 '(car)
	   cmd2 '(<)
	   ))
    ;4
    ((= sort-rule "-y")
     (setq cmd1 '(car)
	   cmd2 '(>)
	   ))
    
    );cond

  (setq i 0)
  (repeat (sslength ss)
    (setq entlist2
	   (append entlist2
		   (list (list (setq ent (ssname ss i))
			       (eval (append cmd1 '((cdr (assoc 10 (entget ent))))))
			 )
		   )
	   )
    )

    (setq i (1+ i))
  );repeat
  (setq i 0)
;;;************************************************************
  (setq	entlist2 (vl-sort entlist2
			  '(lambda (a b)
			     (eval (append cmd2 '((cadr a)
						  (cadr b)
						  )
					   )
				   )
			     )
			  )
  )
;;;************************************************************

  (list entlist1 entlist2)
  );defun