(defun do (i) (vlax-dump-object i))

(vlax-dump-Object
(vla-get-ActiveDocument(vlax-get-acad-object))
T)

(do
    (setq rapps (vla-get-RegisteredApplications (vla-get-ActiveDocument(vlax-get-acad-object))))
)

(vlax-for app rapps
  (princ (strcat "\n" (vla-get-Name app)))
  )

(vlax-dump-Object
  (setq e (vla-item
    (vla-get-RegisteredApplications (vla-get-ActiveDocument(vlax-get-acad-object)))
    4))
  T)

(vlax-for it (vla-get-RegisteredApplications (vla-get-ActiveDocument(vlax-get-acad-object)))
    (vlax-dump-object it T)
    )



(defun vla-container->list (obj / lst col i)
  (setq lst '() i -1)
  (if (setq col (vla-get-Count obj))
    (repeat col (setq lst (append lst (list (vla-item obj (setq i (1+ i)))))))
    )
  lst
  )

(setq listapps (vla-get-RegisteredApplications (vla-get-ActiveDocument(vlax-get-acad-object))))
(mapcar 'vla-get-name (vla-container->list listapps))



(vlax-ldata-list "*")


;;; ************************************************************************
;;; выводит список словарей ***********************************************
;;; ************************************************************************

(progn
  (setq str "")
  (foreach x (mapcar 'cdr (vl-remove-if-not
			    (function (lambda (x) (= (car x) 3)))
			    (entget (namedobjdict)))) (setq str (strcat str "\n" x)))
  (princ str)
  T)





;;; ************************************************************************
; проверка наличия словаря расширения у олбъекта
;;; ************************************************************************
(setq hased (vla-get-HasExtensionDictionary (vlax-ename->vla-object (car (nentsel)))))
;;; ************************************************************************

(setq obj (vlax-ename->vla-object (car (nentsel))))
(setq exd (vla-GetExtensionDictionary obj))


(car (vlax-ldata-get (vlax-ename->vla-object (car (entsel))) "*"))

(entget (car (entsel)) '("*"))






(setq blref (vlax-ename->vla-object (car (entsel))))


(setq cad (vlax-get-acad-object))
(setq adoc (vla-get-activedocument cad))


(do
  (setq blks (vla-get-blocks adoc))
  )

(do (vla-item blks 10))
(do
  (vla-item blks "монтаж_тумблер")
  )