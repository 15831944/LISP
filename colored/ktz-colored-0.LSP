(defun c:ktz-colored-0 (
			/
			ss
			ent
			eng
			i
			)
  (setq ss	(ssget)
	i	-1
	)
  (repeat (sslength ss)
    (setq  i	(1+ i)
	   ent	(ssname ss i)
	   eng	(entget ent))
    (setq eng (subst '(62 . 256) (assoc 62 eng) eng))
    ;(if (assoc 62 eng) (setq eng (vl-remove (assoc 62 eng) eng)))
    (entmod eng)
    (entupd ent)
    );repeat
  (princ)
  );defun



(defun uncolor (obj / en eng)
  (setq en (vlax-vla-object->ename obj))
  (setq eng (entget en))
  (setq eng (subst '(62 . 256) (assoc 62 eng) eng))
  (entmod eng)
  (entupd en)
  );defun