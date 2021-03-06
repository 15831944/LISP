;;;--------------------------------------------------------------;
;;; �������: 3dPoint->2dPoint ;
;;;--------------------------------------------------------------;
;;; ��������: ��� ������� ������������ ���� ��������, �������������� ����� � ������� (;)
;;; 3D point (list of three integers or reals), and ;
;;; converts it into a 2D point (list of two reals).;
;;; There is no error checking on the 3D point ;
;;; parameter -- it is assumed to be a valid point. ;
;;;--------------------------------------------------------------;
;;; ��������: �������� ������� �������� ����������, ����� ����� � ������� (;)
;;; function won�t crash a program if it is passed a ;
;;; null value, or some other kind of data type than a ;
;;; 3D point. ;
;;;--------------------------------------------------------------;
(defun 3dPoint->2dPoint (3dpt)
  (list (float(car 3dpt)) (float(cadr 3dpt)))
)
