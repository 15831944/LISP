;(load (strcat #lisppath "specification/spclib.lsp"))

(defun any-to-string (any /)
  ;(setq any '( 1 2 3 ))
  (cond
    ((null any) "")
    ((= (type any) 'STR) any)
    ((= (type any) 'INT) (itoa any))
    ((= (type any) 'REAL) (rtos any))
    ((= (type any) 'VLA-OBJECT) (vla-get-ObjectName any))
    ((= (type any) 'ENAME) (cdr (assoc 0 (entget any))))
    ((= (type any) 'LIST)
     ;(apply 'strcat (mapcar '(lambda (x) (strcat (any-to-string x) " ")) any))
     (mapcar 'any-to-string any)
     )
    )
  );defun

;(setq any '(5.2 5.4 3))
;(any-to-string '(5.2 5.4 3))

