;;; ������� ��������, ������ �� �������� � �������� start end
(defun diap (val start end)
  (and
    (> end start)
    (<= val end)
    (>= val start)
    )
  )