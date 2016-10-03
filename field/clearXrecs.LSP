;;;
;;;(setq ex (vla-GetExtensionDictionary (vlax-ename->vla-object (car (entsel)))))
;;;
;;;(do
;;;  (vla-GetXRecordData (vla-item ex #kflsrcID) 'a 'b)
;;;  )
;;;
;;;(setq ID (vlax-variant-value (car (vlax-safearray->list B))))
;;;
;;;(vla-ObjectIdToObject #actdoc ID)
;;;
;;;
;;;
;;;(do (vla-item ex #kflsrcID))
;;;
;;;
;;;(vla-item (vla-GetExtensionDictionary (vlax-ename->vla-object (car (entsel)))) #kflsrcID)
;;;
;;;
;;;(setq obj
;;;       (vlax-ename->vla-object (car (entsel)))
;;;      )
;;;
;;;(do (vlax-ename->vla-object (car (entsel))))
;;;
;;;
;;;(vlax-safearray->list
;;;  (vlax-variant-value(vla-GetAttributes (vlax-ename->vla-object (car (entsel))))))
;;;





(defun clearXrecs (obj / catchit)
  (if (and
	(= "AcDbBlockReference" (vla-get-ObjectName obj))
	(= :vlax-true (vla-get-HasAttributes obj))
	)
    (mapcar 'clearXrecs (vlax-safearray->list (vlax-variant-value (vla-GetAttributes obj))))
(if (and
  (member (vla-get-objectname obj) '("AcDbText" "AcDbMText" "AcDbAttribute" "AcDbAttributeDefinition" "AcDbMLeader"))
  (vla-get-HasExtensionDictionary obj)
  (= 'VLA-OBJECT (type (setq catchit (vl-catch-all-apply
				       'vla-item (list
						   (vla-GetExtensionDictionary obj) #kflsrcID)))))
  (vlax-method-applicable-p obj "FieldCode")
  (= (vla-get-TextString obj) (vla-FieldCode obj))
  );and
  (progn
    (vla-delete catchit)
    (vlax-release-object catchit)
    (setq i (1+ i))
    )
)
    )
  );defun
(setq i 0)


(setq ss (ss->lsto* (ssget)))

(mapcar 'clearXrecs ss)