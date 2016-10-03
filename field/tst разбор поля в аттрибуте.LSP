(setq obj (getbatt (pickobj) "LOCFLD"))


(do (setq acflddictd (vla-item (vla-GetExtensionDictionary obj) 0)))
(mapcar 'print (entget (vlax-vla-object->ename acflddictd)))



(do (setq acdbfield (vla-item acflddictd 0)))
(mapcar 'print (entget (vlax-vla-object->ename acdbfield)))

(vla-GetObject acflddictd "ACFD_FIELD_VALUE")

