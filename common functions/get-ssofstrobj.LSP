






(defun get-ssofstrobj ( / ss objl tag attlst)
  (if (and (not (setq ss (ssget "_I" '((0 . "*TEXT,INSERT,MULTILEADER")))))
	  (null (setq ss (ssget '((0 . "*TEXT,INSERT,MULTILEADER"))))))
    (exit))
  (setq ss (ss->list ss))
  (setq objl (mapcar 'vlax-ename->vla-object ss))
  ;(setq objl (list (vlax-ename->vla-object (car (entsel)))))
  (if (= "AcDbBlockReference" (vla-get-ObjectName (car objl)))
    (if (= 1 (length (setq attlst (vlax-safearray->list (vlax-variant-value (vla-GetAttributes (car objl)))))))
      (setq objl (mapcar '(lambda (b) (car (vlax-safearray->list (vlax-variant-value (vla-GetAttributes b))))) objl))
      (setq tag (kd:dcl:pick-from-list (mapcar 'vla-get-TagString attlst)) objl (mapcar '(lambda (x) (getbatt x tag)) objl))
      )
    objl
    )
  );defun






(defun get-ssofstrobj* ( / ss objl tag)
  (if (and (not (setq ss (ssget "_I" '((0 . "*TEXT,INSERT,MULTILEADER")))))
	  (null (setq ss (ssget '((0 . "*TEXT,INSERT,MULTILEADER"))))))
    (exit))
  (setq ss (ss->list* ss))
  (setq objl (mapcar 'vlax-ename->vla-object ss))
  (if (= "AcDbBlockReference" (vla-get-ObjectName (car objl)))
    (setq tag
	(kd:dcl:pick-from-list
	  (mapcar 'vla-get-TagString (vlax-safearray->list(vlax-variant-value
		(vla-GetAttributes (car objl))
		))))
	  objl (mapcar '(lambda (x) (getbatt x tag)) objl)
	  )
    objl
    )
  );defun


(defun pick ( / obj)
  (if
    (and
      (setq obj (entsel))
      (setq obj (vlax-ename->vla-object (car obj)))
      )
    obj
    nil
    )
  )