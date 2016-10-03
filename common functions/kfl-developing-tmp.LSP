

;;;project globals
(setq kfl-dict-name "ktzfieldlinks")



(defun kfl-get-or-make-dict (/
			     )
  )


(setq txto (vlax-ename->vla-object (car (entsel))))
(do txto)
(setq txto-edc (vla-GetExtensionDictionary txto))	;extension dictionary container

(do txto-edc)

(setq xrec (vla-addxrecord txto-edc "xrectxto"))
(do xrec)




(vlax-map-collection txto-edc '(lambda (x) (princ (strcat vla-get-name "\n" ))))



(vlax-for x (vla-get-dictionaries actdoc)
  (princ (strcat
     (vla-get-ObjectName x) "\t\t"
     (if (vlax-property-available-p x 'Name)
       (vla-get-Name x)
       "\t"
     ) "\t\t"
     "\n"
     )))



(vlax-for x txto-edc
  (princ (strcat
     (vla-get-ObjectName x) "\t\t"
     (if (vlax-property-available-p x 'Name)
       (vla-get-Name x)
       "\t"
     ) "\t\t"
     "\n"
     )))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq actdoc-dicts (vla-get-dictionaries actdoc))

0 (do actdoc-dicts)
1	(do (vla-item actdoc-dicts 3))
2		(do (vla-item (vla-item actdoc-dicts 6) 0))




(vlax-for x actdoc-dicts
  (princ (strcat
     (vla-get-ObjectName x) "\t\t"
     (if (vlax-property-available-p x "Name")
       (vla-get-Name x)
       "\t"
     ) "\t\t"
     "\n"
     )))

(do (vla-item actdoc-dicts "ktz-cabels"))
	(do (vla-item (vla-item actdoc-dicts "ktz-cabels") 1))
;;================================================================
(setq kfl-dict (vla-add actdoc-dicts kfl-dict-name))
(do kfl-dict)

(vla-addobject kfl-dict "test_stringobjid" "")

(vla-addxrecord kfl-dict "test_xrecordname3")
(setq kfl-dict_xrecord (vla-addxrecord kfl-dict "test_xrecordname"))

(do kfl-dict_xrecord)
(entget (vlax-vla-object->ename kfl-dict_xrecord))
;(vla-Delete kfl-dict_xrecord1)

(setq sa1 (vlax-safearray-fill
	   (vlax-make-safearray vlax-vbInteger '(0 . 2))
	   (list 1001 140 2)))
(setq sa2 (vlax-safearray-fill
	   (vlax-make-safearray vlax-vbvariant '(0 . 2))
	   (list kfl-dict-name 14 "asda")))



(vlax-safearray->list sa2)

(vla-SetXRecordData kfl-dict_xrecord sa1 sa2)


(vla-GetXRecordData kfl-dict_xrecord 'a 'b)
(vlax-safearray->list a)
(vlax-safearray->list b)







(vlax-for x kfl-dict
  (princ (strcat
     (vla-get-ObjectName x) "\t\t"
     (if (vlax-property-available-p x "Name")
       (vla-get-Name x)
       "\t"
     ) "\t\t"
     "\n"
     )))

