(setq ss (ssget "_I" '((0 . "INSERT"))))
(setq ss (ss->lsto* ss))

(setq lstkks (mapcar '(lambda (x) (vla-get-TextString (getbatt x "POZ"))) ss))
(setq lstkks (mapcar '(lambda (x) (vla-get-TextString (getbatt x "ID"))) ss))


(setq lstkks (vl-sort lstkks '(lambda (a b) (> a b))))