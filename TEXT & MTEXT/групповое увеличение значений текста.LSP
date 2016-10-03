(setq ss (ssget "_I")
      i 0
      )

(repeat (sslength ss)
    (setq eng (entget (ssname ss i))
          txn (atoi (cdr (assoc 1 eng)))
          txn (+ 300 txn)
          eng (subst (cons 1 (itoa txn)) (assoc 1 eng) eng)
          )
    (entmod eng)
    (entupd (ssname ss i))
          
    (setq i (1+ i))
    )







(setq ss (ssget "_I")
      i 0
      )

(repeat (sslength ss)
    (setq eng (entget (ssname ss i))
          tx (cdr (assoc 1 eng))
          ;txn (strcat "{\\fTimes New Roman CYR|b0|i0|c204;\\c0;" tx)
	  txn (strcat "{\\fTimes New Roman CYR|b0|i1|c204;\\c0;" tx "}")
	  eng (subst (cons 1 txn) (assoc 1 eng) eng)
          )
    (entmod eng)
    (entupd (ssname ss i))
          
    (setq i (1+ i))
    )