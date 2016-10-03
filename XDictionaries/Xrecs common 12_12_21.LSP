;12_12_21
; желание структуризировать использование расширенных данных объектов

;*********************************************************************************
; присваивает список данных к xrecord (к уже созданной)
;*********************************************************************************
(defun kd:setxrecdata (xrec val / sa1 sa2)
  (if (listp val)
    (progn
      (setq sa1 (vlax-safearray-fill
		  (vlax-make-safearray vlax-vbInteger (cons 0  (1- (length val))))
		  (mapcar '(lambda (x) (cond
			       ((= (type x) 'STR) 301)
			       ((= (type x) 'INT) 451)
			       ((= (type x) 'REAL) 140)
			       )
			     ) val)))
      (setq sa2 (vlax-safearray-fill
		(vlax-make-safearray vlax-vbvariant (cons 0 (1- (length val))))
		val))
      (vla-SetXRecordData xrec sa1 sa2)
      )
    (princ "\nkd:setxrecdata : value must be a list")
    )
  );defun

;*********************************************************************************
; добавляет/заменяет x-запись к словарю
; dict - словарь
; xrname - назване x-записи
; val - список данных
(defun add-xr-to-dict (dict xrname val / xr lst)
  ;(setq lst '())
  ;(vlax-for item dict (setq lst (append lst (list (vla-get-name item)))))
  ;(if (member xrname lst)
  ;  (setq xr (vla-addxrecord dict xrname))
  ;  )
  (setq xr (vla-addxrecord dict xrname))
  (kd:setxrecdata xr val)
  xr
  )
;(add-xr-to-dict (vla-GetExtensionDictionary obj) "testrecname1" '("fuck"))
;(add-xr-to-dict dict "testrecname1" '("fuck"))
;*********************************************************************************




;*********************************************************************************
;(kd:getxrecdata xr)
(defun kd:getxrecdata (xrec / sa1 sa2)
  (if xrec
    (progn
      (vla-getXrecordData xrec 'sa1 'sa2)
      (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
      )
    )
  );defun
;*********************************************************************************

;*********************************************************************************
; проверяет есть ли у словаря x-запись с таким названием
; если да - выдает запись, если нет - nil
; dict - словарь
; xrname - назване x-записи
(defun kd:getXrec (dict xrname / xr lst)
  (vlax-for item dict (setq lst (append lst (list (vla-get-name item)))))
  (if (member xrname lst)
    (setq xr (vla-item dict xrname))
    )
  );defun
;(kd:getXrec exd "testrecname")
;(kd:getxrecdata (kd:getXrec exd "testrecname"))
;*********************************************************************************





;;;; из всего вывожу смысл
(setq xr (add-xr-to-dict maindict uniqxrname xrlistval))
(add-xr-to-dict (vla-GetExtensionDictionary obj)
  maindictname (list (vla-get-Handle xr)))

;таким образом мы создаем запись в основном солваре документа
;а в объект запихиваем на эту запись handle