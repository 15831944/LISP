;;; изменена 10_04_27
;;; прога дл€ копировани€ одной линии текстов (блоков) в другую
;;; использована при разработке проектов ћ“Ё÷-2
;;; -kakt00z-Щ  ©


(defun c:txtcon (/
	      lst1
	      lst2
	      ent
	      eng
	      i
	      j
	      ID
	      txt
	      ;natt1
	      ;natt2
	      k1
	      k2
	      )
  (vl-load-com)
  
  (setq		k1	1)
    		;k2	1)
  
  ;(setq		natt1	1
   ; 		natt2	1)

  (princ "\n [выделите исходные значени€]")
  (setq lst1 (ss->list (ssget '(
				(-4 . "<OR")
				(0 . "*TEXT")
				(0 . "insert")
				(-4 . "OR>")))))
  (princ "\n [выделите измен€емые элементы]")
  (setq lst2 (ss->list (ssget '(
				(-4 . "<OR")
				(0 . "*TEXT")
				(0 . "insert")
				(-4 . "OR>")))))
  (setq k2 (/ (length lst2) (length lst1)))
  (if (or
	(> (rem (length lst1) k1) 0)
	(> (rem (length lst2) k2) 0)
	);or
    (progn
      (alert "неправильна€ кратность наборов")
      (exit)
      )
    );if


  
;;;;;;;;;;;******************* go ****************
  (setq i 0)  
  (repeat (/ (length lst2) k2)
    
;;; просто копирование		===============================
;;;    (setq txt (cdr (assoc 1 (entget (nth (* i k1) lst1)))))
;;;============================================================
    
;;; вставка пол€		=======================================
    (setq ID (vla-get-objectid (vlax-ename->vla-object (nth (* i k1) lst1))))
    (setq txt (strcat
		
		"%<\\AcObjProp Object(%<\\_ObjId "
		(itoa ID)
		">%).TextString>%"
		"-"
		))
;;;============================================================
;;;    (setq j 0)
;;;    (repeat k2
;;;      (setq eng (entget (setq ent (nth (+ (* i k2) j) lst2))))
;;;      (setq eng (subst (cons 1
;;;			     (strcat txt (itoa (1+ j)))		;;;строка
;;;			     )
;;;		       (assoc 1 eng) eng))
;;;      (entmod eng)
;;;      (entupd ent)
;;;      (vl-cmdf "_updatefield" ent "")
;;;      (setq j (1+ j))
;;;      );repeat
    (setq i (1+ i))
    );repeat
  );defun









;;; изменена 10_04_27

;;; функци€ принимает набор (ss) и делает из него
;;; список вида ((ename1 x1)(ename2 x2)...(enamen xn))
;;; где x1, x2, ... , xn - параметр сортировки,
;;; сортирует его и выдает список (ename1 ename2 ... enamen)
;;; если обрабатываетс€ список блоков - то выдает список аттрибутов

;;; -kakt00z-Щ  ©



(defun ss->list	(ss / rule cmd1	cmd2 i lst ent natt)
  (initget 1 "x -x y -y")
  (setq rule (getkword "\n ќтсортировано по : [x/-x/y/-y] <x> \n"))
  (cond
 ;1
    ((= rule "x")
     (setq cmd1	'(car)
	   cmd2	'(<)
	   ) ;_ setq
     )
 ;2
    ((= rule "-x")
     (setq cmd1	'(car)
	   cmd2	'(>)
	   ) ;_ setq
     )
 ;3
    ((= rule "y")
     (setq cmd1	'(cadr)
	   cmd2	'(<)
	   ) ;_ setq
     )
 ;4
    ((= rule "-y")
     (setq cmd1	'(cadr)
	   cmd2	'(>)
	   ) ;_ setq
     )

    ) ;cond
  (setq i 0)
  (repeat (sslength ss)
    (setq lst
	   (append
	     lst
	     (list
	       (list (setq ent (ssname ss i))
		     (eval (append cmd1 '((cdr (assoc 10 (entget ent))))))
		     ) ;_ list
	       ) ;_ list
	     ) ;_ append
	  ) ;_ setq

    (setq i (1+ i))
    ) ;repeat
  (setq i 0)
;;;******************сортировка********************************
  (setq	lst (vl-sort lst
		     '(lambda (a b)
			(eval (append cmd2
				      '((cadr a)
					(cadr b)
					)
				      ) ;_ append
			      ) ;_ eval
			) ;_ lambda
		     ) ;_ vl-sort
	) ;_ setq
;;;************************************************************
  (setq lst (mapcar 'car lst))
  
  (if (= "INSERT" (cdr (assoc 0 (entget (car lst)))))
    (progn
      (setq natt (getint "\n ¬ведите пор€дковый номер аттрибута в блоке"))
      (mapcar '(lambda (x) (repeat natt (entnext x))) lst)
      )
    lst
    );if
  ) ;defun