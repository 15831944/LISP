;;;; 13_05_01
;;;;;;;; ���� ���������� ������ ���������
;(load (strcat #lisppath "strings/editmark.lsp"))

(setq str "ND�12AP001")

(defun isstringKKS (str / frmt)
  (setq frmt (getmarkformat str))
  (cond
    ((equal
       '("eng" "eng" "eng" "num" "num" "eng" "eng" "num" "num" "num")
       (getmarkformat "ND�12AP001")
       )
     T)
    ()
    )
  );defun



;(lst>excel (mapcar '(lambda (x) (sepstr* (car x))) (excel>lst)))