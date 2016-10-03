;12_12_21
; хрень тока для полей (ktz-field-links)

;14_02_26
; сделано не хорошо
; добавляется одноименная X-запись в основной словарь объекта
; а надо делать словарь "ktzFildLinks" и в нем по порядку добавлять каждую добавленную ссылку поля
; а еще сделать функцию kfl-update, которая бы синхронизировала записи - то есть
; при обновлении проверяла имеющиеся записи на соответствие встречных записей у ссылающихся
; т.е. например если бы я удалил из чертежа объекты, которые присутствуют в этих записях, чтобы они удалялись

; в общем тут говно написано

(defun kfl-put-xrecdata (obj tag val / oexd xrec sa1 sa2)
  (setq oexd (vla-GetExtensionDictionary obj))
  (setq xrec (vla-addxrecord oexd tag))
  (setq sa1 (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) (list 301)))
  (setq sa2 (vlax-safearray-fill (vlax-make-safearray vlax-vbvariant '(0 . 0)) (list val)))
  (vla-SetXRecordData xrec sa1 sa2)
  );defun

(defun kfl-get-xrecdata (obj tag / o oexd xr a b)
  ;(setq obj (vlax-ename->vla-object (car (nentsel))))
  ;(setq tag #kfl-xrecname)
  ;(setq tag "kflsourceID")
  (if (and
	(= :vlax-true (vla-get-HasExtensionDictionary obj))
	(setq oexd (vla-GetExtensionDictionary obj))
	(setq xr (vla-item oexd tag))
	)
    (progn
      (vla-GetXRecordData xr 'a 'b)
      ;(vlax-safearray->list a)
      (car (mapcar 'vlax-variant-value (vlax-safearray->list b)))
      )
    nil
    )
  );defun

(defun kfl-get-xtags (obj / oexd xr taglist)
  (setq taglist '())
  (if (vla-get-HasExtensionDictionary obj)
    (progn
      (setq oexd (vla-GetExtensionDictionary obj))
      ;(vlax-for xr oexd (print (strcat "\n" (vla-get-name xr))))
      (vlax-for xr oexd (setq taglist (append taglist (list (vla-get-name xr)))))
      (princ)
      )
    )
  taglist
  )






















;(do (vlax-ename->vla-object (car (nentsel))))


;(kfl-get-xtags (vlax-ename->vla-object (car (nentsel))))
;(kfl-put-xrecdata (vlax-ename->vla-object (car (nentsel))) "ID" "FIT")
;(kfl-put-xrecdata (vlax-ename->vla-object (car (nentsel))) "POZ" "UC123")

;(kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) "ID")
;(kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) "ACAD_FIELD")
;(kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) "tag")

;(kfl-put-xrecdata (vlax-ename->vla-object (car (nentsel))) "ID" "FIT")

;(kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) "kflsourceID")
