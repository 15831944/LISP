(setq lst (ss->tbl (ssget)))


(mapcar
  '(lambda (ls)
     (mapcar 'vla-get-textstring ls)
     )
  lst)

(setq blks (ss->lsto* (ssget)))


(mapcar '(lambda (b l)
	   (vla-put-TextString (getbatt b "SIGNALNAME") (vla-get-TextString (nth 0 l)))
	   (vla-put-TextString (getbatt b "NUMBER") (vla-get-TextString (nth 1 l)))
	   (vla-put-TextString (getbatt b "LOCFLD") (vla-get-TextString (nth 2 l)))
	   (vla-put-TextString (getbatt b "LOCCAB") (vla-get-TextString (nth 3 l)))
	   (vla-put-TextString (getbatt b "TYPE") (vla-get-TextString (nth 4 l)))
	   (vla-put-TextString (getbatt b "CORES") (vla-get-TextString (nth 5 l)))
	   (vla-put-TextString (getbatt b "SECTION") (vla-get-TextString (nth 6 l)))
	   (vla-put-TextString (getbatt b "LENGTH") "###")
	   ) blks lst)