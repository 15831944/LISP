;;; ��������� ���������� ������ �������� �������� �� �� �������� ��� ��������
;;; � �������� ����� � ������������
;;; � ������� ����� ����� ����������� ��� ��������� ���������� ����� ��������� ��� ������� �� ����������� �� ���������������

;;; ��� - ����� � �����������
;;; 11_02_01

(defun c:ktz-X->Y-justify (
			   /
			   lst
			   bpt
			   vect
			   i
			   )
  (setq lst (ktz-ss->sorted-lst)
  	bpt (getpoint "\n������� ����� � ������� ����� �������� ����������\n")
  	vect (getpoint bpt "\n������� ����� �������� ��������\n")
	i 0)
  (setq vect (vec-dif bpt vect))
  (repeat (length lst)
    (change-ent
      (cons 10 (vec-dif bpt (vec-comp vect i)))
      (car (nth i lst))
      )
    (setq i (1+ i))
    )
  );defun



;;; ������ �� selection set ������ ���� ((ent1 �������� ����������)...)
(defun ktz-ss->sorted-lst (
			   /
			   ent
			   sort-rule
			   ss
			   i
			   entlist
			   cmd1
			   cmd2
			   )
  (princ "\n [�������� �������� ��������� ��������]")
  (setq ss (ssget '(
		    (-4 . "<OR")
		    (0 . "*TEXT")
		    (0 . "insert")
		    (-4 . "OR>"))))
  (initget 1 "x -x y -y")
  (setq sort-rule (getkword "\n ������������� �� : [x/-x/y/-y] <x> \n"))
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
    (setq entlist
	   (append entlist
		   (list (list (setq ent (ssname ss i))
			       (eval (append cmd1 '((cdr (assoc 10 (entget ent))))))
			 )
		   )
	   )
    )
    (setq i (1+ i))
  );repeat
;;;************************************************************
  (setq	entlist (vl-sort entlist
			  '(lambda (a b)
			     (eval (append cmd2 '((cadr a)
						  (cadr b)
						  )
					   )))))
;;;************************************************************
  entlist
  );defun





;;;   ;;; �������� ��� ������ ���������� �������
;;;(progn
;;;(setq i 0
;;;      li (ktz-ss->sorted-lst))
;;;(repeat (length li)
;;;  (setq txt (strcat
;;;	      "\n"
;;;	      (itoa i)
;;;	      "      "
;;;	      (cdr (assoc 1 (entget (car (nth i li)))))
;;;	      "\n"
;;;	      ))
;;;  (princ txt)
;;;  (setq i (1+ i))
;;;  )
;;;)