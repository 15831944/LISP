(defun do (o) (vlax-dump-object o T))

(vlax-dump-object
      (vla-get-Activedocument
	(vlax-get-acad-object)
	)
  )

(vlax-dump-object
    (vla-get-Dictionaries
      (vla-get-Activedocument
	(vlax-get-acad-object)
	)
      )
  )



(vlax-dump-object
 (vla-item
    (vla-get-Dictionaries
      (vla-get-Activedocument
	(vlax-get-acad-object)
	)
      )
    5)
  )
;


(vlax-dump-object
  
  (vla-item 
  (vla-item
    (vla-get-Dictionaries
      (vla-get-Activedocument
	(vlax-get-acad-object)
	)
      )
    12)
  3)
  T
  )

  

(do (vlax-ename->vla-object (car (entsel))))
(setq eo (vlax-ename->vla-object (car (entsel))))
(do eo)


(vlax-write-enabled-p eo)
    (vlax-method-applicable-p eo "FieldCode") ;_есть метод FieldCode
    (vlax-property-available-p eo "TextString")
    (vlax-invoke eo "FieldCode")
    (setq fc (strcat str fc))
    (vlax-put eo "TextString" fc)

