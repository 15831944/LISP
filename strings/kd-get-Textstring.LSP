; 13_07_15
;(kd-get-TextString (car (nentsel)))
;(kd-get-TextString (car (entsel)))
;(setq obj (car (entsel)))


(defun kd-get-TextString (obj / o en str)
  ;(setq obj (car (nentsel)))
  (setq o (cond ((= 'ENAME (type obj)) (vlax-ename->vla-object obj)) ((= 'VLA-OBJECT (type obj)) obj)))
  (setq en (vlax-vla-object->ename o))
  (cond
    ((= "MULTILEADER" (cdr (assoc 0 (entget en))))
     (setq str (cdr (assoc 304 (entget en))))
     (if (= "" str) (setq str (vla-get-TextString o)))
     (setq str (list str))
     )
    (T (setq str (vl-remove-if-not '(lambda (x) (member (car x) '(3 1))) (entget en))))
    )

  (if (and
	(= "AcDbAttribute" (vla-get-ObjectName o))
	(= :vlax-true (vla-get-MTextAttribute o))
	)
    (setq str (cdr str))
    )
  
  (cond
    ((and (= 1 (length str)) (atom (car str))) (car str))
    ((and (= 1 (length str)) (null (assoc 3 str))) (cdar str))
    ((and (= 2 (length str)) (null (assoc 3 str))) (cdadr str))
    ((and (= 2 (length str)) (assoc 3 str)) (apply 'strcat (mapcar 'cdr str)))
    ((and (= 3 (length str)) (assoc 3 str)) (apply 'strcat (mapcar 'cdr str)))
    ((and (< 3 (length str)) (assoc 3 str)) (apply 'strcat (mapcar 'cdr str)))
    )
  );defun