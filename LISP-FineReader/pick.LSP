


(sssetfirst nil (ssget "_X" '(
			      (-4 . "<AND")
			      (0 . "TEXT")
			      	(-4 . "<OR")
			      	(1 . "������������ � ����������� ��������������")
			      	(1 . "�������")
			      	(1 . "���, �����, ")
			      	(1 . "����������� ���������")
			      	(1 . "��������� �����")
			      	(1 . "��� �����-")
			      	(1 . "�������,")
			      	(1 . "�������,")
			      	(1 . "���������")
			      	(1 . "�����-")
			      	(1 . "������������")
			      	(1 . "�������")
			      	(1 . "����-")
			      	(1 . "�����")
			      	(1 . "����-")
			      	(1 . "")
			      (1 . "������")
			      (1 . "�����")
			      (1 . "�������,")
			      (1 . "��")
			      (1 . "����������")
			      (1 . "����. � ����")
			      (1 . "����. ���. �")
			      (1 . "")
			      	(-4 . "OR>")
			      (-4 . "AND>")
			      )))



(defun pickX (
	      /
	      ss
	      ss1
	      X
	      i
	      )

  (setq X (cadr (cdr (assoc 10 (entget (car (entsel)))))))
  
  (setq ss 	(ssget );"_W" '((0 . "LINE")))
	i	0
	ss1	(ssadd)
	) ;_ ����� setq

       (repeat (sslength ss)
	 (if (or
	       (= X (cadr (cdr (assoc 10 (entget (ssname ss i))))))
	       (= X (cadr (cdr (assoc 11 (entget (ssname ss i))))))
	       );or

		
	   (setq ss1 (ssadd (ssname ss i) ss1))
	   );if
	 (setq i (1+ i))
	 );repeat
       (sssetfirst nil ss1)
 )






(defun pickX1 (
	      /
	       en
	      ss
	      ss1
	       L
	      X
	      i
	      )
  (setq en (car (entsel)))

  (setq L (distance
	    (cdr (assoc 10 (entget en)))
	    (cdr (assoc 11 (entget en)))
	    ))

  
  (setq ss 	(ssget "_X" '((0 . "LINE")));"_W" '((0 . "LINE")))
	i	0
	ss1	(ssadd)
	) ;_ ����� setq

       (repeat (sslength ss)
	 (if  (> L (distance (cdr (assoc 10 (entget (ssname ss i))))
			     (cdr (assoc 11 (entget (ssname ss i))))))
	 (setq ss1 (ssadd (ssname ss i) ss1))
	   );if
	 (setq i (1+ i))
	 );repeat
       (sssetfirst nil ss1)
 )