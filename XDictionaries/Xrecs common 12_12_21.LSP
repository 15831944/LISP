;12_12_21
; ������� ����������������� ������������� ����������� ������ ��������

;*********************************************************************************
; ����������� ������ ������ � xrecord (� ��� ���������)
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
; ���������/�������� x-������ � �������
; dict - �������
; xrname - ������� x-������
; val - ������ ������
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
; ��������� ���� �� � ������� x-������ � ����� ���������
; ���� �� - ������ ������, ���� ��� - nil
; dict - �������
; xrname - ������� x-������
(defun kd:getXrec (dict xrname / xr lst)
  (vlax-for item dict (setq lst (append lst (list (vla-get-name item)))))
  (if (member xrname lst)
    (setq xr (vla-item dict xrname))
    )
  );defun
;(kd:getXrec exd "testrecname")
;(kd:getxrecdata (kd:getXrec exd "testrecname"))
;*********************************************************************************





;;;; �� ����� ������ �����
(setq xr (add-xr-to-dict maindict uniqxrname xrlistval))
(add-xr-to-dict (vla-GetExtensionDictionary obj)
  maindictname (list (vla-get-Handle xr)))

;����� ������� �� ������� ������ � �������� ������� ���������
;� � ������ ���������� �� ��� ������ handle