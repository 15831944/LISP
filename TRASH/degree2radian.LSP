;;;--------------------------------------------------------------;
;;; �������: Degrees->Radians;
;;;--------------------------------------------------------------;
;;; ��������: ������ ������� ����������� ��������, �������������� ����� � ������� (;)
;;; angular measurement in degrees, into its radian ;
;;; equivalent. There is no error checking on the ;
;;; numberOfDegrees parameter -- it is always ;
;;; expected to be a valid number. ;
;;;--------------------------------------------------------------;
(defun Degrees->Radians (numberOfDegrees) 
(* pi (/ numberOfDegrees 180.0)))