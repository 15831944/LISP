(setq data (mapcar 'vla-get-textstring (ss->lsto (ssget))))
(setq cabs (mapcar '(lambda (x) (getbatt x "NOTE")) (ss->lsto (ssget))))
(mapcar '(lambda (a b) (vla-put-TextString a b)) cabs data)