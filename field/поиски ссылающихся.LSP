(defun do (o) (vlax-dump-object o T))
(setq doc (vlax-get-acad-object))
(setq acdoc (vla-get-ActiveDocument doc))

(do (vla-get-dictionaries(vla-get-database acdoc)))

(vlax-for it (vla-get-dictionaries(vla-get-database acdoc))
    (vlax-dump-object it T))


(do (vla-item (vla-get-dictionaries(vla-get-database acdoc)) 1))


(setq fle (entget
(vlax-vla-object->ename
    (vla-item (vla-get-dictionaries(vla-get-database acdoc)) 1)
    )
)
      )

(setq flee (mapcar 'cdr (cdr (reverse (cdr (member (assoc 90 fle) fle))))))

(entget (cdr (assoc 330 (entget (cadr (reverse flee))))))

(mapcar '(lambda (x) (assoc 1 (reverse (entget x)))) flee)

;;;(do (vlax-ename->vla-object (car flee)))

;;;(do
;;;    (vla-ObjectIDToObject
;;;        acdoc
;;;        (vla-get-OwnerID (vlax-ename->vla-object (car flee)))
;;;        )
;;;    )

(entget (cadr flee))


(assoc 302 (reverse (entget (cadr flee))))


(setq pos
(vl-position "KAKT))Z"
(mapcar '(lambda (x)
             (cdr (assoc 302 (reverse (entget x))))
             )
        flee)
             )
      )

(nth pos flee)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq doc (vla-get-activedocument (vlax-get-acad-object)))

(vla-get-Dictionaries doc)

(do
  (setq dics (vla-get-Dictionaries doc))
  )

(do
  (vla-item dics "AcDbFieldList")
  )

(setq fldlstdict (vla-item dics 1))

(entget
  (vlax-vla-object->ename fldlstdict)
)

(setq eflds (vlax-vla-object->ename fldlstdict))

(setq lst (mapcar 'cdr (vl-remove-if-not '(lambda (x) (= 330 (car x)))(entget eflds))))

(setq olst (mapcar 'vlax-ename->vla-object lst))




(setq od (namedobjdict))

(setq lod (mapcar 'cdr (vl-remove-if-not '(lambda(x) (= 350 (car x))) (entget od))))

(setq eidset (mapcar 'cdr (vl-remove-if-not '(lambda(x) (= 330 (car x))) (entget (nth 1 lod)))))
(setq eidset(cddr eidset))

(setq eid (car eidset))

;;;(setq idset (mapcar 'vlax-ename->vla-object eidset))
;;;(setq item (car idset))



(setq eid (car eidset))

(setq eid2 (cdr (assoc 360 (entget eid))))

(setq eid3 (cdr (assoc 331 (entget eid2))))






(setq lofels (mapcar '(lambda (x)
			(cdr (assoc 331 (entget (cdr (assoc 360 (entget x))))))
			
			)
		     eidset))