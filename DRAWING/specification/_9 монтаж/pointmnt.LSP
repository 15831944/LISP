;13_11_06
;(setq xlslines (cdr (nth 1 datazipped)))

(defun pointmnt|gen-zakaz-sosudur (xlslines / quant mater typ)
  (setq quant (length xlslines))
  
  (if (= "dPTF" (xlsgpar "func" (car xlslines))) (setq quant (* 2 quant)))

  (setq mater "�")	;;; ����� 20
  ;(setq mater "�")	;;; 12�18�10�
  ;(setq mater "�")	;;; ����� ����� ���������
  ;;; �������� ��� ������
  (setq typ "��-10-01-�")
  (if (< (* 1.2 (atof* (xlsgpar "P" (car xlslines)))) 10)
    (list "" "����� �������������" typ "" "��� \"�����\" �. ������" "��." (rtos* quant) "" "������")
    (list "" "!!! ###  �������� ��� ������ �� ��������  ### !!!" "" "" "" "" "" "" "")
    )
  );defun





;;;;;   ������ �������� ������� ������ ������ ���������������� �����

;;;
;;;'(
;;;  	(10
;;;   		(01
;;;    			("���"
;;;     				("��20" "��-10-01-� (���-14-�20x1,5)")
;;;     				("12�" "��-10-01-� (���-14-�20x1,5)")
;;;    			)
;;;   		)
;;;   		(02
;;;    			("�1/2"
;;;     				("��20" "��-10-02-� (�1/2)")
;;;     				("12�" "��-10-02-� (�1/2)")
;;;    			)
;;;    			("Rc1/2"
;;;     				("��20" "��-10-02-� (Rc1/2)")
;;;     				("12�" "��-10-02-� (Rc1/2)")
;;;    			)
;;;   		)
;;;  	)
;;;  	(25
;;;   		(02
;;;    			("�1/2"
;;;     				("��20" "��-25-02-� (�1/2)")
;;;     				("12�" "��-25-02-� (�1/2)")
;;;    			)
;;;    			("Rc1/2"
;;;     				("��20" "��-25-02-� (Rc1/2)")
;;;     				("12�" "��-25-02-� (Rc1/2)")
;;;    			)
;;;   		)
;;;  	)
;;; )