
(defun swapattscontent ()
(mapcar '(lambda (x / a b tmp)
	   (setq tmp (vla-get-TextString (setq b (getbatt x "LOCCAB"))))
	   (vla-put-TextString b (vla-get-TextString (setq a (getbatt x "LOCFLD"))))
	   (vla-put-TextString a tmp)
	   )
(ss->lsto* (ssget))
)
  )

  
