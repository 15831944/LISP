(setq data (excel>lst))







(setq
  transdata
   '(
     ("����" "����")
     ("���" "����")
     ("�����" "�� ������")
     ("����������� ����" "����������� ����")
     ("������ ������� ����" "������ ������� ����")
     ("�������� ������� ����" "�������� ������� ����")
     ("������� ����" "������� ����")
     ("����������� ����" "����������� ����")
     ("���������" "����������")
     ("����������" "�����������")
     ("���������" "����������")
     ("������" "������")
     ("������" "������")
     ("������" "�������")
     ("������" "�������")
     ("����" "����")
     ("������" "������")
     ("�����" "�����")
     ("�����" "�����")
     ("�������" "��������")
     ("�������� ���" "��������� ����")
     ("�������� ������" "��������� �������")
     ("������� ���" "�������� ����")
     ("������� ������" "�������� �������")
     ("�������� �����" "�������� �����")
     ("��������" "��������")
     ("��������� ��������" "���������� ��������")
     ("�����" "������")
     ("������" "�������")
     ("������� �������" "������� �������")
     ("������������ �������" "������������ �������")

     ("�����������" "� ������������")
     ("�����������������" "� ������������������")
     ("���������" "� ����������")
     ("������" "� �������")
     ("����������� �����" "� ����������� �����")
     ("����������" "� ����������")
     ("��������� ���" "� ��������� ����")
     ("������������� �����" "� ������������� �����")
     )
  )
(setq
  transdata2
   '(
     "���-7. "
     "���-8. "
     "���-9. "
     "���-1. "
     "���-2. "
     "���-3. "
     "���-4. "
     "���-5. "
     "��-6�. " 
     "��-6�. " 
     "������� ��������� �2. "
     "���������. "
     )
  )


;(rl|convert line trline)
(defun rl|convert (line trline)
  (antisep (subst (vl-string-subst (cadr trline) (car trline) (cadr line)) (cadr line) line) " ")
  )
       


(setq res
(mapcar
  '(lambda (line / trline trl2)	;(setq line (nth 67 data))

     (cond
       ((setq trline (vl-remove-if-not '(lambda (l) (wcmatch (cadr line) (strcat (car l) "*"))) transdata))
	(rl|convert line (car trline))
	)

       ((setq trline (vl-remove-if-not '(lambda (l) (wcmatch (cadr line) (strcat l "*"))) transdata2))
	(setq trline (car trline))
	(if (setq trline2 (vl-remove-if-not '(lambda (l) (wcmatch (vl-string-subst "" trline (cadr line))(strcat (car l) "*"))) transdata))
	  (rl|convert (list (car line) (strcat (vl-string-subst "" trline (cadr line)) ". " (vl-string-subst "" ". " trline) ))(car trline2))
	  (antisep (list (car line) (strcat (vl-string-subst "" trline (cadr line)) ". " (vl-string-subst "" ". " trline) )) " ")
	  )
	)
       
       (T 
	(antisep line " ")
	)
       )

     
     )
  data
  ))









(lst>excel (mapcar 'list res))