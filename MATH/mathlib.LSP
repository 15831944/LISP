;(defun iseven )






; gcd ; ���
; ~ ���������� ������ ����� �� -1
; (~ -2) ��� ������ ���������� ����������

; rem


;(command "_audit" "_Y")




;	�� ������ '("A" "B" "C" "D")
;	����� ������� ������ '(("A" "B") ("A" "C") ("A" "D") ("B" "C") ("B" "D") ("C" "D"))
;	�� ���� ������ �������� ������ + ���������� ��������������

;(setq tmp '("A" "B" "C" "D" "E"))

(defun ways (members)
  (if members
    (append
      (mapcar
	'(lambda (x)
	   (list (car members) x)
	   )
	(cdr members))
      (ways (cdr members))
      )
    )
  );defun
