8.37
8.40


(setq lst (ss->lsto* (ssget)))


(mapcar
  '(lambda (b)
     (mapcar
       '(lambda (att)
	  (vla-put-textstring att (strcat "$" (vla-get-TagString att) "$"))
	  )
       (getbattswcmatch b "*")
       )
     )
  lst
  )