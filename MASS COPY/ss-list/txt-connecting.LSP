;;; �������� 10_04_27
;;; ����� ��� ����������� ����� ����� ������� (������) � ������
;;; ������������ ��� ���������� �������� ����-2
;;; -kakt00z-�  �


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

  (princ "\n [�������� �������� ��������]")
  (setq lst1 (ss->list (ssget '(
				(-4 . "<OR")
				(0 . "*TEXT")
				(0 . "insert")
				(-4 . "OR>")))))
  (princ "\n [�������� ���������� ��������]")
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
      (alert "������������ ��������� �������")
      (exit)
      )
    );if


  
;;;;;;;;;;;******************* go ****************
  (setq i 0)  
  (repeat (/ (length lst2) k2)
    
;;; ������ �����������		===============================
;;;    (setq txt (cdr (assoc 1 (entget (nth (* i k1) lst1)))))
;;;============================================================
    
;;; ������� ����		=======================================
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
;;;			     (strcat txt (itoa (1+ j)))		;;;������
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









;;; �������� 10_04_27

;;; ������� ��������� ����� (ss) � ������ �� ����
;;; ������ ���� ((ename1 x1)(ename2 x2)...(enamen xn))
;;; ��� x1, x2, ... , xn - �������� ����������,
;;; ��������� ��� � ������ ������ (ename1 ename2 ... enamen)
;;; ���� �������������� ������ ������ - �� ������ ������ ����������

;;; -kakt00z-�  �



(defun ss->list	(ss / rule cmd1	cmd2 i lst ent natt)
  (initget 1 "x -x y -y")
  (setq rule (getkword "\n ������������� �� : [x/-x/y/-y] <x> \n"))
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
;;;******************����������********************************
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
      (setq natt (getint "\n ������� ���������� ����� ��������� � �����"))
      (mapcar '(lambda (x) (repeat natt (entnext x))) lst)
      )
    lst
    );if
  ) ;defun