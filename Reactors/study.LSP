(vlr-types)		;Выводит список всех типов реакторов.
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

(vlr-reactors)
(vlr-type vlr-ktz-react)


(vlr-reaction-names :vlr-object-reactor)
;;;:VLR-cancelled
;;;:VLR-copied
;;;:VLR-erased
;;;:VLR-unerased
;;;:VLR-goodbye
;;;:VLR-openedForModify
;;;:VLR-modified
;;;:VLR-subObjModified
;;;:VLR-modifyUndone
;;;:VLR-modifiedXData
;;;:VLR-unappended
;;;:VLR-reappended
;;;:VLR-objectClosed



(vlr-reaction-names :VLR-Editor-Reactor)

;;;:VLR-unknownCommand
;;;:VLR-commandWillStart
;;;:VLR-commandEnded
;;;:VLR-commandCancelled
;;;:VLR-commandFailed
;;;:VLR-lispWillStart
;;;:VLR-lispEnded
;;;:VLR-lispCancelled
;;;:VLR-beginClose
;;;:VLR-beginDxfIn
;;;:VLR-abortDxfIn
;;;:VLR-dxfInComplete
;;;:VLR-beginDxfOut
;;;:VLR-abortDxfOut
;;;:VLR-dxfOutComplete
;;;:VLR-beginDwgOpen
;;;:VLR-endDwgOpen
;;;:VLR-dwgFileOpened
;;;:VLR-databaseConstructed
;;;:VLR-databaseToBeDestroyed
;;;:VLR-beginSave
;;;:VLR-saveComplete
;;;:VLR-sysVarWillChange
;;;:VLR-sysVarChanged



(vlr-reaction-names :VLR-Mouse-Reactor)
;;;:VLR-beginDoubleClick
;;;:VLR-beginRightClick

(vlr-reaction-names :VLR-DocManager-Reactor)
;;;:VLR-documentCreated
;;;:VLR-documentToBeDestroyed
;;;:VLR-documentLockModeWillChange
;;;:VLR-documentLockModeChangeVetoed
;;;:VLR-documentLockModeChanged
;;;:VLR-documentBecameCurrent
;;;:VLR-documentToBeActivated
;;;:VLR-documentToBeDeactivated


(vlr-reaction-names :VLR-Window-Reactor)
;(:VLR-docFrameMovedOrResized :VLR-mainFrameMovedOrResized) 




(vlr-remove-all)
(setq obj (vlax-ename->vla-object (car (entsel))))
(setq beep-r (vlr-object-reactor (list obj) nil (list '(:VLR-modified . vlr-beep-reaction))))
(vlr-pers beep-r)
