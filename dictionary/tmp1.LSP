
(setq actdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
(vlax-dump-Object
  (setq o (vlax-ename->vla-object (car (nentsel))))
  T
  )

(vlax-dump-Object
  (setq o1 (vla-ObjectIDToObject actdoc (vla-get-ownerID o)))
)

(vlax-dump-Object
  (setq o2 (vla-ObjectIDToObject actdoc (vla-get-ownerID o1)))
)



(vlax-dump-Object
  owner
  T
  )
(vlax-dump-Object
  (vla-ObjectIDToObject actdoc (vla-get-ownerID owner))
  T
  )



;;; *************************************************************
(defun get-tree	(
		 /
		 actdoc
		 obj
		 tree
		 ID
		 )
  (setq actdoc (vla-get-ActiveDocument (vlax-get-acad-object))
	obj (vlax-ename->vla-object (car (nentsel)))
	tree '()
	;tree (list (vla-get-ObjectName obj))
	ID nil
	) ;_ setq
;ObjectName
  (while (/= 0 (setq ID (vla-get-OwnerID obj)))
    (setq tree (append (list (vla-get-ObjectName obj)) (list tree)))
    (setq obj (vla-ObjectIDToObject actdoc ID))
    ) ;_ while
  tree
  ) ;_ defun




;;; *************************************************************
