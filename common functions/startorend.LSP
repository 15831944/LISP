; lobj - line object (AcDbLine)
; pt - '(32.0 35.0 0.0)
; выдает :
; какое свойство линии (StartPoint) или (EndPoint) ближе
; к точке pt для использования извлечения свойств

(defun startorend (lobj pt)
  (if (>
	(distance pt (vlax-safearray->list(vlax-variant-value (vla-get-startpoint lobj))))
	(distance pt (vlax-safearray->list(vlax-variant-value (vla-get-endpoint lobj)))))
    "EndPoint"
    "StartPoint"
    )
  );defun