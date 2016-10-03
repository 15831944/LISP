;;13_05_17
;;; mtxt|lib

(defun mtxt:getnumberoflines (obj / lsd p1 p2 height numberoflines)
  (setq lsd (vla-get-LineSpacingDistance obj))
  (vla-GetBoundingBox obj 'p1 'p2)
  (setq height (abs (- (cadr (vlax-safearray->list p1))
		       (cadr (vlax-safearray->list p2)))))
  (setq numberoflines (fix (1+ (/ (- height (rem height lsd)) lsd))))
  numberoflines
  );defun