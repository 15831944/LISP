;;; ����-��� �����, ���� ����������!!! � �������������� ID �������� �����

(defun c:run ( / )
       (ktz_ss_sortX)
);



;;; ������� ���� ������ ���� �� ��. ����, � ������ �� "���������"

(defun ktz_ss_sortX (
		     /
		     ss			;����� �����
		     sss		;��������
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
		     tmpbp		;��� ���������
		     
		     )


  (setq base_block	(car (entsel "\n����� ������� ����"))
			; � ������ ��� ������ ���� ��� �����, �� ���� - ���� "���������"
	ss		(ssget)		;"\n������� �������")
			

	
	i		0
	
				; � ������ ��� ������ ���� ��� �����, �� ���� - ���� "���������"
	pt1		(getpoint "\n������� ������ ����� ��� ���� ������ ���������")
	pt2		(getpoint "\n������� ������ ����� ��� ���� ������ ���������")
	bp		(getpoint "\n������� �����")
	dX		(getdist bp "\n��������� ����� ��������� X")
	
  );setq
  (setq bpt (cdr (assoc 10 (entget base_block))))
  
  (setq  dpt1	(list (- (car pt1) (car bpt))
		      (- (cadr pt1) (cadr bpt))
		      (- (caddr pt1) (caddr bpt))
		);list
	 dpt2	(list (- (car pt2) (car bpt))
		      (- (cadr pt2) (cadr bpt))
		      (- (caddr pt2) (caddr bpt))
		);list
   );setq

	
  
  


  

  
  (repeat (sslength ss)
    (setq ss-en (append ss-en (list (ssname ss i))))
    (setq i (1+ i))
  );repeat


  

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
  (princ "\n ")



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
;;; ��� ����� ��� ���� ����� �� ��� ������ � ����� ������ ������
;;; ����� ����������� � ���� ��������� ����������
;;; ����� ��� �������� ��������� ��� �����������
;;; ���� �� ������ ���� �� ���������� ���� base_block


(setq i 0)

(foreach ent ss-en
  (if (= (assoc 8 (entget base_block))
	 (assoc 8 (entget ent)));=
    (progn
      (setq bpt (cdr(assoc 10 (entget ent))))
      (setq pt1 (list (+ (car bpt) (car dpt1))
		       (+ (cadr bpt) (cadr dpt1))
		       (+ (caddr bpt) (caddr dpt1))
		 )
	    );
      (setq pt2 (list (+ (car bpt) (car dpt2))
		       (+ (cadr bpt) (cadr dpt2))
		       (+ (caddr bpt) (caddr dpt2))
		 )
	    );

      (command "_rectangle" pt1 pt2)
      
      ;(setq sss (ssget "_W" pt1 pt2))
      


      
      (setq i (1+ i))
    );progn
  );if


);foreach




					


  (princ)

);defun





;(while INSNAMES (setq OUTPUT (cons (cons (car INSNAMES)(- LEN (setq LEN (length (setq INSNAMES (vl-remove (car INSNAMES) INSNAMES)))))) OUTPUT)))



;;;(defun c:bsel (/) ;;; ����� ���� ����������� ������ �� ������
;;;  (setvar "cmdecho" 0) 
;;;  (sssetfirst 
;;;    nil 
;;;    (setq bSet 
;;;      (ssget 
;;;        "_C" 
;;;        (list 
;;;          (assoc 2 (entget (car (entsel "Select sample block: ")))) 
;;;        ) 
;;;      ) 
;;;    ) 
;;;  ) 
;;;  (terpri) 
;;;  (princ(strcat "*** "(itoa(sslength bSet)) " bloks selected ***")) 
;;;  (princ) 
;;;)

