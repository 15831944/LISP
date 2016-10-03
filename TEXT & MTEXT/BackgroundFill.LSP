
(mapcar '(lambda (x)
	   (vla-put-BackgroundFill x 0)
	   )
	(ss->lsto* (ssget '((0 . "MTEXT"))))
	)

