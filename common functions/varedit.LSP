;; 13_11_25
;; ���� ���� ���������� ���� 2�������
;; �� ��� 2 ������� ��� �� �������� �������������� � �����

;(setq #lst '(("project-number" "1744-1-���5") ("object-name1" "������������� ��� �� ������� ����� �������") ("object-name2" "� �. �������") ("object-name3" "��������������� ������������.") ("project-name1" "2 �������� ��������. ������� ������.") ("project-name2" "��������������� ������������.") ("project-name3" "��� � �")))
;(vareditstart #lst)
;(vareditend #lst)



(defun vareditstart (varname)
  ;(setq varname '#lst)
  (setq #vareditobjects (cons varname (lst>objs (eval varname))))
  );defun



(defun vareditend ()
  (eval
    (list
    'setq
    (car #vareditobjects)
    (quote
      (mapcarx
	(lambda (x)
	  (vla-get-TextString (vla-HandleToObject #actdoc x))
	  )
	nil
	(cdr #vareditobjects)
	)
      )
    )
    )
  (mapcarx (lambda (x) (vla-delete (vla-HandleToObject #actdoc x))) nil (cdr #vareditobjects))
  (setq #vareditobjects nil)
  );defun
