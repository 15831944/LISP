;;; �������� 10_05_28
;;; ����� ��� �������������� ������� � ������� ������,
;;; ����� ��� � ������� ������� � ��������� ������
;;; ������������ ��� ���������� ���� �� �4 ������
;;; -kakt00z-�  �



(defun c:movetolike (
		   /
		   e
		   se
		   spt
		   bpt
		   )
  (setq e (car (entsel "\n������� ������ ��� ��������������... : ")))
  (setq se (car (entsel "\n������� ������ ��� ������� ������� �����... : ")))
  (setq spt (getpoint "\n������� ��������� ������� �����... : "))
  (setq bpt (vec-sum
	      (cdr (assoc 10 (entget e)))
	      (vec-dif
		spt
		(cdr (assoc 10 (entget se)))
		)
	      ))

  (command "_move" e "" bpt)
  )