;;; прога для копирования одной линии текстов в другую

(defun c:asd (
	      /
	      doc
	      parelist1
	      parelist2
	      ent
	      eng
	      i
	      ID
	      txt
	      j
	      	      )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init
    (list (list "cmdecho" 0
               "expert" nil
        );list
        T
  );list
 );acet-error-init

  
  (setq i 0)
  
  (setq ID (ktz-get-and-sort-pare-ss))
  (setq parelist1 (car ID)
	parelist2 (cadr ID)
	ID	nil)

(if T ;(= (length parelist1) (length parelist2))
  ;then
  (repeat (length parelist2)

    ;;;============================================================
    ;;; если надо извлекать текст из первого аттрибута блока
    ;(setq txt (cdr (assoc 1 (entget (entnext (car (nth i parelist1)))))))
    ;;;если надо просто текст то:
    ;(setq txt (cdr (assoc 1 (entget (car (nth i parelist1))))))
    ;;; если надо поле
    (setq ID (vla-get-objectid (vlax-ename->vla-object (car (nth i parelist1)))))
    (setq txt (strcat
		"датчиков -24V поз."
		"%<\\AcObjProp Object(%<\\_ObjId "
			       (itoa ID)
			       ">%).TextString>%"
			       ))
    ;;;============================================================
    ;;; если надо 2 текста в 1     (* 2 i),   (1+ (* 2 i))
;;;    (setq ID (vla-get-objectid (vlax-ename->vla-object (car (nth (1+ (* 2 i)) parelist1)))))
;;;    (setq txt (strcat
;;;		"поз."
;;;		txt
;;;		", поз."
;;;		"%<\\AcObjProp Object(%<\\_ObjId "
;;;		(itoa ID)
;;;		">%).TextString>%"
;;;		))




    ;;;============================================================


    
    (setq ent (car (nth i parelist2)))
    (setq eng (entget ent))
    (setq eng (subst (cons 1 txt) (assoc 1 eng) eng))
    (entmod eng)
    (entupd ent)
    




;;;    ;;;============================================================
;;;    ;;; в блок 4 аттрибута
;;;    (setq ent (car (nth i parelist2)))
;;;    (setq j 1)
;;;    (if (= 1 (cdr (assoc 66 (entget ent))))
;;;      ;then
;;;      (progn
;;;	(setq eng (entget (entnext ent)))
;;;	(while (/= (cdr (assoc 0 eng)) "SEQEND")
;;;	  
;;;	  (setq eng (subst (cons 1 (strcat txt "-" (itoa j)))
;;;			   (assoc 1 eng)
;;;			   eng))
;;;	  (entmod eng)
;;;	  (entupd ent)
;;;	  (setq eng
;;;
;;;		 (entget (entnext (cdr (assoc -1 eng))))
;;;		j (1+ j))
;;;
;;;	  );while
;;;      );progn
;;;      ;else
;;;      (progn
;;;      (setq eng (entget ent))
;;;	(setq eng (subst (cons 1 txt) (assoc 1 eng) eng))
;;;	(entmod eng)
;;;	(entupd ent)
;;;	
;;;	)
;;;      );if
;;;    ;;;============================================================
    (vl-cmdf "_updatefield" ent "")
    (setq i (1+ i))
    );repeat
  ;else
  (princ "\n несовпадает количество элементов")
);if

  (vla-endundomark doc)
  );defun




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