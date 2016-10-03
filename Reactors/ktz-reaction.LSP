
;(vlax-dump-object (vlax-ename->vla-object (car (entsel)))T)

(vl-load-com)
(vlr-remove-all)
(setq obj (vlax-ename->vla-object (car (entsel))))
(setq VLR-ktz-react (vlr-object-reactor (list obj) nil (list '(:VLR-modified . ktz-reaction))))

;(setq VLR-ktz-react (vlr-object-reactor (list obj) nil (list '(:vlr-objectClosed . ktz-reaction))))
(vlr-pers VLR-ktz-react)

(defun ktz-reaction (
		  a-object
		  b-vlr-object
		  c-data
		  /
;;;		     a
;;;		     b
;;;		     c
		     ;flag

		     ;ocirc
		  )
  (setq ocirc a-object
	flag nil)
  (if (null flag)
    (progn
      (vla-SendCommand
	(vla-get-ActiveDocument
	  (vlax-get-acad-object))
	;"(alert \"Привет!\") "
	"(vla-put-color ocirc 1)" ;; цикл
	)
      (setq flag T)
    );progn
    );if
  ;(alert "Пока еще нет привета")
;;;  (setq a a-object
;;;	b b-vlr-object
;;;	c c-data)

  ;(princ (vlax-method-applicable-p a-object "setcolor"))
;(vlax-property-available-p a "color")
 ;(vla-put-color ocirc  3)


  

;;;  (princ a-object)
;;;  (princ "\n")
;;;  (princ a-object)
;;;  (princ "\n")
;;;  (princ c-data)
;;;  (princ "\n")
  );defun

