(setq fldr (kd:getfolderdlg  "" ""))

(VL-DIRECTORY-FILES fldr 0)

(setq exclist (list
		"." ".."		
		"! ������������� ���������"
		"!!!! - ACAD system - !!!!"
		"!!!!! catalogs & documentations"
		"!!������� ������ �����������"
		"ACAD electrical" "AutomatiCS ADT" "SchematiCS"
		"KKS" "tmp" "out.txt"
		"_English" "_������� �����"
		"�������" "���������" "� 410"
		"�� ����" "������" "���.pdf"
		"�����������.jpg"	      "�������2.dwg"
		"�� 34.35.101-2003.doc"  "���� ��� ������"
		))




(vl-remove-if '(lambda (x) (member x exclist)) (VL-DIRECTORY-FILES fldr "*.*" 0))