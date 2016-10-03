(defun c:asd (
	      /
	      ss
	      ent
	      lay
	      thick
	      entg
	      i
	      )


  (setq thick	60
	lay	"ׁ׃_טחל1"
	i	0
	)

(if (setq ss (ssget "_P"))
  (princ)
  (setq ss (ssget))
  );if

  (repeat (sslength ss)
    (setq ent (ssname ss i))
    (setq entg (entget ent))
    (setq entg (vl-remove (assoc 370 entg) entg))
    (setq entg (vl-remove (assoc 8 entg) entg))
    
    (setq entg (append (list (cons 370 thick)) entg))
    (setq entg (append (list (cons 8 lay)) entg))
    (entmod entg)
    (entupd ent)
    (setq i (1+ i))
    );repeat

  (princ)
  );defun