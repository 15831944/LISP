




;;;;;;;;;;;;;;; ��� ,,,,, � ������� ���������




;;;;; �������������� �����

;;; ������ ����� ��� - ��� ������� �� �������� -
;;; 1 ������ ����� ���������
;;; 2 �������� � ������� ������� TEXT � ������������� ������ ���������
;;; 3 ����� � �������������� ����������
;;; ��� ������� �����, ��������� ����������, ������ ����� � ������ � ��������

(defun putstringtoatt (
		       /
		       ptatt
		       oatt
		       attstr
		       otxt
		       )
  (setq oatt nil)
  (setq otxt nil)
  (while (null oatt)
    (setq oatt (nentsel "\n������� ��������"))
    )
  (setq oatt (vlax-ename->vla-object (car oatt)))
  (setq attstr (vla-get-TextString oatt))
  (vla-put-textstring oatt "")
  ;;; ��� ���� ���������� ��� ������������ �����
  (setq otxt (vla-AddText #modspace attstr (vla-get-InsertionPoint oatt) (vla-get-Height oatt)))
  (vla-put-alignment otxt (vla-get-alignment oatt))
  (vla-put-TextAlignmentPoint otxt (vla-get-TextAlignmentPoint oatt))
  (vl-cmdf "_ddedit" (vlax-vla-object->ename otxt) "")
  (vla-put-textstring oatt (vla-get-TextString otxt))
  (vla-Delete otxt)
  (princ)
  );defun
