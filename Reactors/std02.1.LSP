


(setq bref (vlax-ename->vla-object (car (nentsel))))

(defun PIM:alert (bref exec reactor)
  (cond
    ((null reactor) (alert "nil"))
    (T (alert (VL-PRIN1-TO-STRING (type reactor))))
    )
  )




(setq kdR (VLR-Object-Reactor
	    (list bref)
	    "PID_instrument:modified"
	    (list
	      ;'(:VLR-subObjModified . PIM:alert)
	      '(:vlr-modified . PIM:alert)
	      )
	    )
      )


The object has been modified. If the modification was canceled, also :vlr-cancelled and :vlr-modifyUndone will be fired.

A sub-entity of the object has been modified.
This event is triggered for modifications to vertices of polylines or meshes, and for attributes owned by block references.



Object events callback data
:vlr-cancelled
:vlr-erased
:vlr-unerased
:vlr-goodbye
:vlr-openedForModify
:vlr-modified
:vlr-modifyUndone
:vlr-modifiedXData
:vlr-unappended
:vlr-reappended
:vlr-objectClosed