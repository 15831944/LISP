
(defun change-ent (
		   pointpare ;�������� ���� ����  (2 . "�������")
		   ent ;<��� �������: 7eae4080>
		   /
		   entg ;entget
		   )
  (setq entg (entget ent))
  (setq	entg (subst pointpare
		    (assoc (car pointpare) entg)
		    entg
		    ) ;_ subst
	) ;_ setq
  (entmod entg)
  (entupd ent)
  ) ;defun






;;; ����������� ����� ������� ������� �� "�����" �����������

(defun c:text-int-adj (/ pf px ent mshtb ss i)

  (setq mshtb (getreal "\n����� ��� �����"))
  (princ "\n ����� ������" )

  (setq ss (ssget))
  (setq i 0)
  (repeat (sslength ss)
    (setq ent (ssname ss i))
    (if (= (cdr (assoc 72 (entget ent))) 0)
      (setq pf 10)
      (setq pf 11)
     );if
    (setq px (cdr (assoc pf (entget ent))))
    (setq px (list (* (fix (/ (car px) mshtb)) mshtb)		;X
	           (* (fix (/ (cadr px) mshtb)) mshtb)		;Y
	           (* (fix (/ (caddr px) mshtb)) mshtb)		;Z
     ));setq
    (change-ent (cons pf px) ent)
    (setq i (1+ i))

  );repeat
);defun

;;;====================================================================