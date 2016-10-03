(defun lay-broken-field (
			 /
;;;			 ss
;;;			 sss
;;;			 i
;;;			 ent
			 )
  (setq	ss (ssget "_X"
		  '((-4 . "<OR")
		    (0 . "MTEXT")
		    (0 . "TEXT")
		    	(-4 . "<AND")
		    	(0 . "INSERT")
		    	(66 . 1)
		    	(-4 . "AND>")
		    (-4 . "OR>")
		    )
	   )
	i 0
	sss (ssadd)
  );setq
  
  (repeat (sslength ss)
    (setq ent (ssname ss i))
    (if (= (cdr (assoc 0 (entget ent))) "INSERT")
      ;then
      (progn
	(while (/= "SEQEND" (cdr (assoc 0 (entget (setq ent (entnext ent))))))
	  (lay-if-broken-field ent)
	  )
      );progn
      ;else
      (lay-if-broken-field ent)
      );if
    (setq i (1+ i))
    );repeat
);defun


(defun lay-if-broken-field (ent)
  (if (wcmatch (cdr (assoc 1 (entget ent))) "*`#*")
    (change-ent '(8 . "Broken-field") ent)
    )
);defun



