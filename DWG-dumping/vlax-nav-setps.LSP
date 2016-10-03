
(setq cad (vlax-get-acad-object))
(setq actdoc (vla-get-activedocument cad))
(setq obj (vlax-ename->vla-object (car (entsel))))


(do obj)
(do
  (setq obj (vla-GetExtensionDictionary obj))
  )



(do
  (setq obj (vla-Item obj 0))
  )

;;back
(do
  (setq obj (vla-objectidtoobject actdoc (vla-get-OwnerID obj)))
  )





(progn
(vlax-for x obj
  (princ (strcat
     (vla-get-ObjectName x)
     "\t\t"
     (if (vlax-property-available-p x 'Name) (vla-get-Name x) "\t\t")
     "\t"
     (if (vlax-property-available-p x 'Count) (itoa (vla-get-Count x)) "\t\t")
     "\n"
     )))
(princ)
)

(mapcar '(lambda (x)
	   (prin1 x)
	   (princ "\n")
	   ) (entget (vlax-vla-object->ename obj)))(princ)

;;;;  XREC
(vla-GetXRecordData obj 'a 'b)

(vlax-safearray->list a)

(vlax-safearray->list b)
(length (vlax-safearray->list b))
