(defun c:run ( / )
       (ktz_ss_sortX)
);



;;; ������� ���� ������ ���� �� ��. ����, � ������ �� "���������"

(defun ktz_ss_sortX (
		     /
		     ss			;����� �����
		     pt1ss		;����� ������ ������ ������
		     pt2ss	
		     bp			;����� ������ ������� ������
		     pt1		;����� ���� ������ ���������
		     pt2
		     dpt1
		     dpt2
		     bpt		;����� ������� �������� �����
		     i
		     ent
		     dX			;���������� X ����� ��������� �����
		     ss-en		;����� ������ ���� ����������
		     base_block		;������� ����, ��������� ��� �������� ���������
		     			;�������� ��� �����������
		     mbp		;������� ��� �������������� ���������
		     ptm
		     ptkon
		     
		     )
  (alert "������� �� �� ����� ���������� ������� ���� �� ��������� ���� � ����������� ��� ����� ���������??")

  (setq	pt1ss		(getpoint "\n ������� ������ ����� ���� ������ ���� �������� :")
	pt2ss		(getpoint "\n ������ ������ (���������������) ���� :"))

  (command "_zoom" pt1ss pt2ss)

  (setq	ss		(ssget "_W" pt1ss pt2ss)
	base_block	(car (entsel "\n����� ������� ����"))
			; � ������ ��� ������ ���� ��� �����, �� ���� - ���� "���������"
	
	i		0
	
				; � ������ ��� ������ ���� ��� �����, �� ���� - ���� "���������"
	pt1		(getpoint "\n������� ������ ����� ��� ���� ������ ���������")
	pt2		(getpoint "\n������� ������ ����� ��� ���� ������ ���������")
	mbp		(getpoint "\n������� ������� ����� ��� �������������� ���������")
	bp		(getpoint "\n������� �����")
	dX		(getdist bp "\n��������� ����� ��������� X")
	
  );setq
  (setq bpt (cdr (assoc 10 (entget base_block))))
  
  (setq  dpt1	(list (- (car bpt) (car pt1))
		      (- (cadr pt1) (cadr bpt))
		);list
	 dpt2	(list (- (car pt2) (car bpt))
		      (- (cadr bpt) (cadr pt2))
		);list
	 mbp	(list (- (car bpt) (car mbp))
		      (- (cadr bpt) (cadr mbp))
		);list
   );setq

	
  
  


  

  
  (repeat (sslength ss)
    (setq ss-en (append ss-en (list (ssname ss i))))
    (setq i (1+ i))
  );repeat


  
(princ "\n ******************************************")
;;; ***************************************************************************
;;; ����� ���������������� �������
;;; ***************************************************************************
  
  (mapcar '(lambda (x)
	     (progn (princ "\n  -> ")
		    (princ x)
	     )
	   )
	  ss-en
  );mapcar
  


;;; ***************************************************************************
;;; ��������� ������ ���� �� �������� (��� �)
;;; ***************************************************************************

  (setq	ss-en	(vl-sort ss-en
			 '(lambda (a b)
			    (< (car (cdr (assoc 10 (entget a))))
			       (car (cdr (assoc 10 (entget b))))
			       )
			  )
		)
  )

  (princ "\n ******************************************")
;;; ***************************************************************************
;;; ����� �������������� �������
;;; ***************************************************************************

  (mapcar '(lambda (x)
	     (progn (princ "\n  -> ")
		    (princ x)
	     )
	   )
	  ss-en
  );mapcar


;;; ������� ����� �������� ������� ���� ����� ��������� ����������
;;; ��� ����� ��� ���� ����� �� ��� ������ � ����� ������ ������ �� ��� �
;;; ����� ����������� � ���� ��������� ����������
;;; ����� ��� �������� ��������� ��� �����������
;;; ���� �� ������ ���� �� ���������� ���� base_block
(princ "\n ******************************************")

(setq i 0)

(foreach ent ss-en
  (if (equal (assoc 8 (entget base_block))
	     (assoc 8 (entget ent)));=
    (progn
      (setq bpt (cdr(assoc 10 (entget ent))))
      (setq pt1 (list (- (car bpt) (car dpt1))
		       (+ (cadr bpt) (cadr dpt1)))
	    pt2 (list (+ (car bpt) (car dpt2))
		       (- (cadr bpt) (cadr dpt2)))
	    ptm (list (+ (car bpt) (car mbp))
		      (+ (cadr bpt) (cadr mbp)))
       );setq

      (setq ptkon (list (+ (car bp) (* dX i))
			(cadr bp)))


      (command "_move" "_W" pt1 pt2 "" ptm ptkon)

      ;(command "_rectangle" pt1 pt2)
      
      


      
      (setq i (1+ i))
    );progn
  );if


);foreach




					


  (princ)

);defun