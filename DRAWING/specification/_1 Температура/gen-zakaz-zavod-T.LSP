

;;;'(
;;;  ("PI" "LAB11CP501" "�������� �� ����� ������������ ������ �1" nil "133" "��" "0.42" "���"
;;;   "�����" nil nil "145" nil "32" nil nil nil nil "���"
;;;  )
;;; )
;(setq xlslines (cdr pardata))
(defun gen-zakaz-zavod-T (xlslines
			  /
			  strname
			  kol
			  paragraph
			  pozitions
			  tmp
			  )
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  (setq kol (length xlslines))
  (cond
    ((= "TT" (xlsgpar "func" (car xlslines)))
     (setq
       strname (strcat "�������������������� ������������� ���������� ��� \"" (xlsgpar "sign_type" (car xlslines)) "\"")
       ))
    ((= "TE" (xlsgpar "func" (car xlslines)))
     (setq
       strname (strcat "����������")
       ))    
;;;    ((= "PS" (xlsgpar "func" xlsline))
;;;     (setq
;;;       strname "����������������� ��������"
;;;       ))
;;;    ((= "PT" (xlsgpar "func" xlsline))
;;;     (setq
;;;       strname "��������������� �������� �������������"
;;;       ))
    );cond

  (append
    (list
      (list
	;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	pozitions
	(strcat strname)
	(if (setq tmp (xlsgpar "remarks" (car xlslines))) tmp "")
	"" "" "��." (rtos* kol) ""
	(if (setq tmp (xlsgpar "��������" (car xlslines))) tmp "")
	)
      )
    (point|gen-zakaz-bobyshka xlslines)
    )
  );defun