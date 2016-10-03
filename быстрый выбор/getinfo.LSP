;;; функция возвращает список слоев, имеющих место в указанном выборе объектов


(defun c:getinfo (
		  /
		  ss
		  ent
		  i
		  lay
		  laylist
		  )
  (setq i 0
	laylist '()
	)

  (if
    (setq ss (ssget "_I"))
    ;then
    (princ)
    ;else
    (setq ss (ssget))
    );if

  (repeat (sslength ss)
    (setq ent (ssname ss i))
    (setq lay (cdr (assoc 8 (entget ent))))
    (if (not (member lay laylist))
      (setq laylist (append laylist (list lay)))

    );if
    (setq i (1+ i))
    );repet

  (princ laylist)
  
  );defun