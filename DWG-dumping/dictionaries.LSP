(setq obj (vlax-ename->vla-object (car (entsel))))

(do obj)

(setq actdoc (vla-get-activedocument (vlax-get-acad-object)))
(DO (vla-get-dictionaries #actdoc))
(vlax-for x (vla-get-dictionaries #actdoc)
  (princ (strcat
     (vla-get-ObjectName x) "\t\t"
     (if (vlax-property-available-p x 'Name)
       (vla-get-Name x)
       "\t"
     ) "\t\t"
     "\n"
     )))

(do
  (vla-item(vla-item (vla-get-dictionaries actdoc) 15) 0)
  )

(do
  ;(vla-GetExtensionDictionary		
    (vla-item (vla-get-dictionaries actdoc) 1)
   ; )
  )




"MCS_STREAM_DICT"
(setq mcs (vla-item (vla-get-dictionaries #actdoc) "AcDbVariableDictionary"))
(setq a (vla-GetExtensionDictionary obj))
(setq vloobj (vla-item a 0))



(do mcs)
(do (vla-item mcs 2))
(vlax-for x mcs
  (princ (strcat
     (vla-get-ObjectName x) "\t\t"
     (if (vlax-property-available-p x 'Name)
       (vla-get-Name x)
       "\t"
     ) "\t\t"
     "\n"
     )))

(do (vla-item mcs 1))
(setq xrec (vla-item mcs 3))


(assoc 1033 (entget (vlax-vla-object->ename xrec)))

(vla-GetXRecordData xrec 'a 'b)
(vlax-safearray->list a)
(vl-remove-if '(lambda (x) (= x 1004)) (vlax-safearray->list a))

(vlax-safearray->list b)
(length (vlax-safearray->list b))

(length 
(vlax-safearray->list
  (vlax-variant-value
    (nth 2
	 (vlax-safearray->list b)
	 )
    )
  )
)




(do (vlax-ename->vla-object (car (entsel))))
(do #actdoc)

(vla-AuditInfo #actdoc :vlax-false)