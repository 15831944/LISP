(load (strcat #lisppath "XDictionaries\\XDictlib.LSP"))

;(setq #dicts (vla-get-Dictionaries #actdoc))
(setq #DB (vla-add (vla-get-Dictionaries #actdoc) "#DATABASE"))






;  ����-�����������
��� ������� #DB="#DATABASE"
� ����� � ������������� ������ ������ ������ ����� excel
������� ����� ������������� ���� ������� � ������� #DB

�������� ��� - ���� ��10.xlsx � ������� � ������ "��10"
� ������� ����� ������ ������ - xrecords
���������� ������������ ������� $tbl

(setq #cbnt10 (vla-AddObject #DB "��10" "AcDbDictionary"))


		������� �������� ���� ������

Xrecord "HEAD"
���������� $db:head
�������� '("cabinet" "clamp" "cl1" "cl2" "relay" "sign_type" "KKS" "mark1" "mark2" "cbl_KKS" "event" "equipment" "meas_name" "����" "������" "cab_type" "cores" "section" "place_field" "field_name")


$db:data - ��� ������ � ������� "rec*"
�������� '("table" () () () ... $$rec)
	Xrecord "REC1"
	���������� $$rec
	��������'("��10.1�" "1XT3" "1" "2" "1" "420AI+" "2FT350" "-1" "-2" "2UHA-4021" "" "" "������ ���������� ������� " "" "" "�������" "4" "1,5" "#��" "��-14")


��� �������� ���� �������� ������� � ����������� ����������� ������� - �� ��������
Xrecord "XLSETTINGS"
�������� '("rowheight=15" "colwidth=20,20,20,15,35,..." ... � ����� ��� ������ ���� .. ��)


������� ������ � �������� �������

���... �� ���� ������

cont>list - ����������� ��������� � ������

XD|names - ���� ������ ���� ������ �������

XD|getxrecord $tbl "name" = $$rec / nil
XD|getxrecdata $$rec - ����� ������ ������
??? XD|ask $tbl "name" 

XD|addxrecord $tbl "name" (val1 val2 val3 ...) - ��������� � ������� ������, ���� ��� ������ �����
XD|setxrecdata $$rec (val1 val2 val3 ...) - �������������� ������

XD|delxrecs $tbl '("name")











;(setq $db:head db:head)
;(setq $db:data db:data)







(XD|dictgetnames #DB) 


(XD|dictgetnames #cbnt10)


(XD|dictdivide #DB)

(XD|dictdivide #cbnt10)

















;(kd|setauthor (vlax-ename->vla-object (car (entsel))) "����������� �. �.")
(defun kd|setauthor ( obj name / exd authXR)
  (setq exd (vla-GetExtensionDictionary obj))
  (if (null (member "author" (XD|dictgetnames exd)))
    (setq authXR (vla-AddXRecord exd "author"))
    (setq authXR (vla-item exd "author"))
    )
  (XD|setxrecdata authXR (list name))
  ;(XD|getxrecdata	 authXR)
  );defun



;(kd|getauthor (vlax-ename->vla-object (car (nentsel))))
;(kd|getauthor (vlax-ename->vla-object (car (entsel))))
(defun c:kd|getauthor ()(kd|getauthor (vlax-ename->vla-object (car (entsel)))))
(defun kd|getauthor ( obj / exd authXR)
  (if
    (and
      (= :vlax-true (vla-get-HasExtensionDictionary obj))
      (setq exd (vla-GetExtensionDictionary obj))
      (member "author" (XD|getnames exd))
      )
    (XD|getxrecdata (vla-item exd "author"))
    )
  );defun










(setq lst (ss->lsto* (ssget "_X")))



(setq fn
(lambda ( / ss lst)
  (if (not (setq ss (ssget "_I" '((0 . "INSERT"))))) (setq ss (ssget '((0 . "INSERT")))))
  (if ss (setq lst (ss->lsto* ss)))
  (mapcar '(lambda (x) (kd|setauthor x "����������� �. �."))lst)
  )
      )

(setq fn
(lambda ( / ss lst)
  (if (not (setq ss (ssget "_I"))) (setq ss (ssget)))
  (if ss (setq lst (ss->lsto* ss)))
  (mapcar '(lambda (x) (kd|setauthor x "����������� �. �."))lst)
  )
      )

(fn)




