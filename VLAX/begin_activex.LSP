(defun do (obj)(vlax-dump-object obj T))
(do a_doc)





(setq cad (vlax-get-Acad-Object))
(do cad)
(setq doclist (vla-get-Documents cad))
(do doclist)
(vla-get-Count doclist)
(setq a_doc (vla-item doclist 1))		;;; активный -1, неактивный - 0
(do a_doc)

(vlax-property-available-p cad "ACTIVEDOCUMENT")
     ;(vlax-method-applicable-p
;       VLA-GET-ACTIVEDOCUMENT
(setq actdoc (vla-get-ActiveDocument cad))
(do actdoc)
(setq ms (vla-get-modelspace actdoc))

(setq blocks (vla-get-Blocks actdoc))
