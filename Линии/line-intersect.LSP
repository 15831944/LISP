(defun line-intersect (
		       /
		       doc
		       ss
		       l1
		       eng1
		       l2
		       eng2
		       pt
		       )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init

;;;  (if (not (setq ss (ssget "_I" '((0 . "LINE")))))
;;;    (setq ss (ssget '((0 . "LINE"))))
;;;    );if

  (while (null l1)
    (setq l1 (car (entsel)))
    );while
  
  (while (null l2)
    (setq l2 (car (entsel)))
    );while

  (setq eng1 (entget l1)
	eng2 (entget l2)
	pt (inters
	     (cdr (assoc 10 eng1))
	     (cdr (assoc 11 eng1))
	     (cdr (assoc 10 eng2))
	     (cdr (assoc 11 eng2))
	     )
	)
  (vl-cmdf "_break" l1 pt)
  (vl-cmdf "_break" l2 pt)
  (acet-error-restore)
  (vla-endundomark doc)
  );defun