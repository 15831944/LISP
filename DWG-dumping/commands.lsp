(sssetfirst nil (ssadd (get-line-from-format (car (entsel)))))



(defun c:pick_layer (/ layer ss)
  (setq layer (assoc 8 (entget (car (entsel "\n������� ������ � ������ �����")))))
  (setq ss (ssget "_P" (list layer)))
  (sssetfirst nil ss)  
)





(sssetfirst nil (ssget "_X" '((8 . "1"))))

