(setq l (ss->lsto* (ssget)))


(setq l (mapcar '(lambda (x)
		   (getbatt x "POZ")
		   ) l))


(setq l (mapcar '(lambda (x)
		   (vla-get-textstring x)
		   ) l))

(setq l (vl-sort l '(lambda (a b)
		      (> a b)
		      )))