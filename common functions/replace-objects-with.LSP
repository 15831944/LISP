(setq sampobj (vlax-ename->vla-object (car (entsel))))

(setq newobj (vla-copy sampobj))
(vla-delete newobj)


(vla-GetLoopAt sampobj 0 'o)
(vlax-variant-value o)
(do
  (car
    (vlax-safearray->list o)
    ))

(vla-get-OwnerID (vlax-ename->vla-object (car (entsel))))


(defun replace-objs-with ( /
			  ss
			  sampobj
			  newobj
			  )
  (setq ss (ssget "_I"))
  (if ss
    (progn
      (setq ss (ss->lsto* ss))
      (setq sampobj (vlax-ename->vla-object (car (entsel "\n...pick a sample object"))))

      (foreach obj ss
	(setq newobj (vla-copy sampobj))
	(vla-put-insertionpoint newobj (vla-get-insertionpoint obj))
	(vla-delete obj)
	)
      )
    (alert "\n для работы функции нужно чтобы был сформирован набор объектов")
    )
  );defun

