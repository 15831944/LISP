
;("j1" (R1:1 VT1:coll C2:1 OA))
;("j2" (C1:1 VT1:base R1:2))
;("j3" (C2:2 VT1:emit SA1:2 IN))
(load "d:\\LISP WORKING\\common functions\\pickobj.lsp")
(load "d:\\LISP WORKING\\common functions\\lst-strlst.lsp")

(defun connectjoint ( / jobj str)
  (setq jobj (pickobj))
  (vla-put-textstring
    (getbatt jobj "JOINTS")
    (lst->strlst (mapcar '(lambda (x) (vla-get-objectid (vlax-ename->vla-object x))) (ss->list* (ssget))))
    )
  );defun
;(connectjoint)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; элементы в схеме и их контакты
("IN" (c+ c0))


;связи в схеме