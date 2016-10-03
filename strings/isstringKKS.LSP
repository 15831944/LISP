;;;; 13_05_01
;;;;;;;; íàäî äîïèëèâàòü ïğè÷åì òğóäîåìêî
;(load (strcat #lisppath "strings/editmark.lsp"))

(setq str "NDÀ12AP001")

(defun isstringKKS (str / frmt)
  (setq frmt (getmarkformat str))
  (cond
    ((equal
       '("eng" "eng" "eng" "num" "num" "eng" "eng" "num" "num" "num")
       (getmarkformat "NDÀ12AP001")
       )
     T)
    ()
    )
  );defun



;(lst>excel (mapcar '(lambda (x) (sepstr* (car x))) (excel>lst)))