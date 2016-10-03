

; список объектов блоков
(setq blolst (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT"))))))



; список obj блоков-элемент
(vl-remove-if-not
  '(lambda (x) (= "ФС_элемент" (vla-get-effectivename x)))
  (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
  )





; список obj блоков-элемент с ID "H"
(setq objlst
(vl-remove-if-not
  '(lambda (x) (= "H" (vla-get-textstring (getbatt x "ID"))))
  (vl-remove-if-not
    '(lambda (x) (= "ФС_элемент" (vla-get-effectivename x)))
    (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
    ))
      )

(showss objlst)


(selblkatt "ФС_элемент" "POZ" "UA-###")
(selblkatt "ФС_элемент" "ID" "H")


(defun selblkatt (bname tag str
	    /
	    objlst
	    )
  (setq objlst
	 (vl-remove-if-not
	   '(lambda (x) (= str (vla-get-textstring (getbatt x tag))))
	   (vl-remove-if-not
	     '(lambda (x) (= bname (vla-get-effectivename x)))
	     (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
	     ))
	)
  (showss objlst)
  );defun



(defun showss (lst
	       /
	       elst
	       ss
	       )
  (setq elst (mapcar 'vlax-vla-object->ename objlst))
  (setq ss (ssadd))
  (foreach e elst
    (setq ss (ssadd e ss))
    )
  (sssetfirst nil ss)
  (setq ss nil)
  );defun