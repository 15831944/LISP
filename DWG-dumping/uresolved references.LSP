(setq tmp (vlax-get-property #actdoc "Database"))


(setq tmp (vlax-get-property tmp "Dictionaries"))
(setq tmp (vlax-get-property #actdoc "Dictionaries"))

(do
  (vla-delete
(vla-item
  (do (vla-item tmp 3))

0)
)
  )




(vlax-for i tmp
  (princ (vla-get-ObjectName i))
  (princ "\n")
  )




(setq tmp3 (vla-item tmp 3))
(vla-getname tmp3 (vla-item tmp3 0))

(setq aid (vla-item tmp "ACAD_IMAGE_DICT"))
(do (vla-item aid 0))

(vla-delete
  (vla-item aid 0)
  )




(setq cad (vlax-get-acad-object))
(setq actdoc (vla-get-ActiveDocument cad))
(setq lays (vla-get-layers actdoc))
(setq cl (vla-item lays "СУ_текст"))



(setq ss (ssget "_X" '((8 . "невидимые_аттриуты"))))
(sslength ss)

(entget (ssname ss 0))

(vl-cmdf "_ZOOM" "_O" (ssname ss 0) "")


(setq ss (ssget "_X" '((0 . "невидимые_аттриуты"))))
(setq ss (ssget "_X" '((0 . "коро"))))



(setq cad (vlax-get-acad-object))
(setq actdoc (vla-get-activedocument cad))
(setq ut (vla-get-utility actdoc))
(setq regapps (vla-get-RegisteredApplications actdoc))
(vlax-for it regapps (princ (strcat "\n" (vla-get-name it))))
(do (vla-item regapps 32))


(setq l (vla-item (vla-get-layers actdoc) "коро"))
(entget (setq el (vlax-vla-object->ename l)))

(entget (cdr (assoc 330 (entget el))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(do actdoc)

(setq layers (vla-get-Layers actdoc))
(do (vla-item layers "сущ."))

(vla-delete (vla-item layers "сущ."))

(ssget "_X" '((8 . "сущ.")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(do #actdoc)

(progn
  (setq str "")
  (foreach x (mapcar 'cdr (vl-remove-if-not
			    (function (lambda (x) (= (car x) 3)))
			    (entget (namedobjdict)))) (setq str (strcat str "\n" x)))
  (princ str)
  T)


(do
  (vla-item (vla-get-FileDependencies tmp) 2)
  )


(setq dicts (vlax-get-property #actdoc "Dictionaries"))

(do (vla-item dicts "ACAD_IMAGE_DICT"))