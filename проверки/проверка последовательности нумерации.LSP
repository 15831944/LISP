;;; ���� ��������������� ������� ��������� ���������
;;; 301 302 ,,, n, ����������� ����������� (��������)
;;; ����� ���������� �� �� ��������� ��� ������ �� ��� �����

(defun chechnums (
		  /
		  olst
		  cn
		  i
		  )
  (setq olst (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget) "-y")))
  (setq cn (atoi (vla-get-textstring (car olst)))
	i 0)

  (repeat (length olst)
    (if (= cn (atoi (vla-get-textstring (nth i olst))))
      (setq i (1+ i) cn (1+ cn))
      (princ cn)
      );if
    )
  (princ)
  );defun
