(defun c:qwer (
	       /
	       bset
	       bent
	       ent
	       i
	       cont
	       )

  (setq bset (ssget "_X" '((0 . "INSERT") (66 . 1)))
	i	0
	cont	0)

  (repeat (sslength bset)
    (setq ent (entnext (ssname bset i)))
    (while
      (= (cdr (assoc 0 (entget ent))) "ATTRIB")
      (if (= (cdr (assoc 8 (entget ent))) "SU")
	(progn
	  (changelayer ent)
	  (setq cont (1+ cont))
	);progn
	);if
      (setq ent (entnext ent))
      );while
    

    (setq i (1+ i))
    );repeat

  (princ cont)
  );defun

(defun changelayer (
		    enty
		    /
		    attentg
		    )
  (setq attentg (entget enty))
  (setq attentg (subst '(8 . "0") (assoc 8 attentg) attentg)) ; слой
  (entmod attentg)
  (entupd enty)
  

  );end






