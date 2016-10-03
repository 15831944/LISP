;;; функция типа mapcar тока ей пофиг сложность списка
;;; если спосок однотипный
(defun mapcarx (func arg lst )
  (if (= 'list (type lst))
    (mapcar '(lambda (x) (mapcarx func arg x)) lst)
    (if arg
      (func lst arg)
      (func lst)
      )
    );if
  );defun
;(mapcarx vla-get-TextString nil lst)


(defun mapcar12 (func arg1 arg2 lst)
  (mapcar '(lambda (x) (func x arg1 arg2)) lst)
  );defun