
;;; ���������� ename ��������� �����, ��������� � ����� ��������
;;;********************************************************************************************
;;; 
;;;
;;;	����� ��, ��� ��������� ����� �������, ���� ������� nentsel !!!!!!   ����������!!
;;;
;;;


(defun ktz-get-blk-attrib-ename-by-pt (block-ent-sel	 / 
				       blk 			;����
				       pt 			;����� (����� ���� ������)
				       att 			;��������� ��������
				       n-att 			;������ ��� ��������
				       pt-att 			;����� ��� �������
				       c-dist 			;��������� ����������
				       min-dist 		;����������� ����������
				       n			;����� ����. � ����������� �����������
				       i
				      )

  (if

    (=	"INSERT" (cdr (assoc 0 (entget (car block-ent-sel)))))
    ;than
    (progn
	  
  (setq
    blk	     (car block-ent-sel)
    pt	     (cadr block-ent-sel)
    att	(entnext blk)
    i	     0
    min-dist 0
  )
 

  (while
    (/= (cdr (assoc 0 (entget att))) "SEQEND")
;;; ������������� ��� ������� ���������� ��������
     (if
       (equal (cdr (assoc 11 (entget att))) '(0.0 0.0 0.0))
       ;than
       (setq pt-att (cdr (assoc 10 (entget att))))
       ;else
       (setq pt-att (cdr (assoc 11 (entget att))))
     );if
    
;;; ������ ���������� � ���� ��� ������ �� ���������� � ���

     (setq c-dist (ktz-getrasst pt pt-att))
     (if (or (= min-dist 0)
	     (> min-dist c-dist)
	 );or
     ;then
       (progn
	 (setq min-dist c-dist)
	 (setq n-att att)
       );progn
       
       );if
     
     (setq att (entnext att))
     (setq i (1+ i))
  );while
  );progn
    ;else
    )
n-att    
);defun