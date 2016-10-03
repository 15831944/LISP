(vl-load-com)
(defun line-draw ()
  (setq adoc (vla-get-activedocument (vlax-get-acad-object))
	myspace (vla-get-modelspace adoc)
	apt (getpoint)
	pt (getpoint apt)
	myline (vla-addline myspace (vlax-3d-point apt) (vlax-3d-point pt))
	linereactor (vlr-object-reactor (list myline) "Line reactor" '((:vlr-modified . print-length)))
	)
  (princ)
  )

(defun print-length (
		     a
		     b
		     c
		     )
  (cond
    ((vlax-property-available-p a "Length")
     (alert (strcat "Длина составляет " (rtos (vla-get-length a))))
     )
    )
  )