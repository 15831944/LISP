


(defun c:bind-dims ( / change-ent #actdoc ss i)
  (defun change-ent (pointpare ent / entg)
    (setq entg (entget ent))
    (setq entg (subst pointpare (assoc (car pointpare) entg) entg))
    (entmod entg)
    (entupd ent)
    )
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (princ "\n������� ������� �������� ��� �������")
  (setq	ss (ssget '((0 . "DIMENSION"))) i -1)
  (repeat (sslength ss)
    (change-ent (cons 1 (rtos (cdr (assoc 42 (entget (ssname ss (setq i (1+ i)))))) 2 1)) (ssname ss i))
    )
  (vla-endundomark #actdoc)
  )


����� ������ �� ������ � ������ ������

����
(command "_.chprop" (ssget "_X" '((0 . "DIMENSION")(-4 . "<NOT")(1 . "")(-4 . "NOT>"))) "" "_c" 2 "")

���� - �� ���� ���������� ���� ��� � �������� - ����� ������
(command "_.chprop" (ssget "_X" '((0 . "DIMENSION")(-4 . "<NOT")(1 . "")(-4 . "NOT>"))) "" "_l" <�������> "")

���������
(sssetfirst nil (ssget "_X" '((0 . "DIMENSION")(-4 . "<NOT")(1 . "")(-4 . "NOT>"))))


