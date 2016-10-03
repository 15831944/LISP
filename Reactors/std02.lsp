





(vlr-remove-all)



(defun start-command (reactor execute-command)
  (princ (strcat "\n" (vlr-data reactor) " : control " (vl-princ-to-string execute-command)))
  )


(setq vlr_react (vlr-command-reactor "Command reactor" (list '(:vlr-commandwillstart . start-command))))





(setq vlr_react (vlr-command-reactor "Command reactor" (list '(:vlr-commandwillstart . start-command))))

(defun start-command (reactor execute-command)
  (cond
    ((= (strcase (car execute-command)) "LINE")
     (princ "\nCommandReactor. Command : LINE; #1")
     )
    )
  )

(setq vlr_react (vlr-command-reactor "Command reactor" (list '(:vlr-commandwillstart . start-command2))))

(defun start-command2 (reactor execute-command)
  (cond
    ((= (strcase (car execute-command)) "LINE")
     (princ "\nCommandReactor. Command : LINE; #2")
     )
    )
  )






(vlr-reactors)
(vlr-remove-all)
(vlr-types)

;;;:VLR-Linker-Reactor
;;;:VLR-Editor-Reactor
;;;:VLR-AcDb-Reactor
;;;:VLR-DocManager-Reactor
;;;:VLR-Command-Reactor
;;;:VLR-Lisp-Reactor
;;;:VLR-DXF-Reactor
;;;:VLR-DWG-Reactor
;;;:VLR-Insert-Reactor
;;;:VLR-Wblock-Reactor
;;;:VLR-SysVar-Reactor
;;;:VLR-DeepClone-Reactor
;;;:VLR-XREF-Reactor
;;;:VLR-Undo-Reactor
;;;:VLR-Window-Reactor
;;;:VLR-Toolbar-Reactor
;;;:VLR-Mouse-Reactor
;;;:VLR-Miscellaneous-Reactor
;;;:VLR-Object-Reactor


(vlr-reaction-names :VLR-Object-Reactor)























