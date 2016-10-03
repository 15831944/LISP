
; hand взял из es_export_database
(setq xobj (vlax-ename->vla-object (handent "9868C")))
(do xobj)

(vla-GetXRecordData xobj 'sa1 'sa2)

(vlax-safearray->list sa1)
(vlax-safearray->list sa2)

(setq id (car (vlax-safearray->list
    (vlax-variant-value (car (vlax-safearray->list sa2))))))


(setq id (cadr (vlax-safearray->list
    (vlax-variant-value (cadr (vlax-safearray->list sa2))))))


(setq id (cadr (vlax-safearray->list
    (vlax-variant-value (nth 54 (vlax-safearray->list sa2))))))



(do (vla-objectidtoobject #actdoc id))