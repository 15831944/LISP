
;;;у	йня какаято

(defun do (o) (vlax-dump-object o T))


(defun fixfield (
		 /
		 actdoc
		 eo
		 str
		 fc
		 )
  (setq actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark actdoc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init




  
  
  (setq eo (vlax-ename->vla-object (car (entsel))))
  (if (vlax-method-applicable-p eo "FieldCode")
    (setq fc (vlax-invoke-method eo "fieldcode"))
    (exit)
    )

  (setq str (substr fc 1 (vl-string-search "%<" fc)))
  ;(setq fc (vl-string-left-trim str fc))

  ;(vl-string-right-trim "%<\\AcObjProp Object(%<\\_ObjId 1234567890>%).TextString>%" fc)
;;;(vl-string-right-trim ">%).TextString>%" fc)
;;;(vl-string-left-trim ">%).TextString>%" fc)

  (setq fc (strcat
	     "%<\\AcObjProp Object(%<\\_ObjId "
	     (itoa (vla-get-objectid (vlax-ename->vla-object (car (entsel)))))
	     ">%).TextString>%"
	     ))

  (and
    (vlax-write-enabled-p eo)
    (vlax-method-applicable-p eo "FieldCode") ;_есть метод FieldCode
    (vlax-property-available-p eo "TextString")
    ;(setq fc (vlax-invoke eo "FieldCode"))
    (setq fc (strcat str fc))
    (vlax-put eo "TextString" fc)
    )
  (acet-error-restore)
  (vla-endundomark actdoc)
  
  );defun