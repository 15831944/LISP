

;;;'(
;;;  ("PI" "LAB11CP501" "�������� �� ����� ������������ ������ �1" nil "133" "��" "0.42" "���"
;;;   "�����" nil nil "145" nil "32" nil nil nil nil "���"
;;;  )
;;; )
(defun gen-zakaz-zavod-P (xlslines
			  /
			  position
			  xlsline
			  strname
			  kol
			  paragraph
			  )
  ;(setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval(append(list 'strcat)(mapcar'(lambda (line)(strcat(cadr line)", "))xlslines)))))
  (if (= 1 (length xlslines))
    (progn
      (setq xlsline (car xlslines))
      (setq kol 1)
      (setq position (xlsgpar "KKS" xlsline))
      (cond
	
	((= "PI" (xlsgpar "func" xlsline))
	 (setq
	   strname "�������� ������������"
	    ))

	((= "PS" (xlsgpar "func" xlsline))
	 (setq
	   strname "����������������� ��������"
	    ))

	((= "PT" (xlsgpar "func" xlsline))
	 (setq
	   strname "��������������� �������� �������������"
	    ))	
	);cond
      (setq paragraph (list (list
	     ;(strcat "{\\W0.8;\\T0.9;" position "}" )
	     position
	     (strcat strname)
	     ""
	     ""
	     ""
	     "��."
	     (itoa kol)
	     ""
	     (if (member "remarks" xls-head)
	       (xlsgpar "remarks" xlsline)
	       ""
	       )
	     )))
      );end if =1
    (progn
      (alert "����� ���������� �������\n
      gen-zakaz-zavod-P, �.�. ��� ����������\n
      ������ �� 1 �����c��� ������ �� 1 �����\n
      ���������")
      (exit)
      )
    )
   
  );defun