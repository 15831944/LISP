;;; должна подсвечивать тесксты с повторяющимся содержимым


(defun c:txt-double (
		   /
		   ssall
		   listall
		     lst
		     sslist
		   en
		   ss
		     ent
		     txt
		     tpx
		   i
		   )

  (setq ssall (ssget "_X" '((0 . "text"))))
  (setq listall (append))
  (setq i 0)

  
  (repeat (sslength ssall)
    (setq ent (ssname ssall i)
	  txt (cdr (assoc 1 (entget ent))))
    
    (if (setq tpx (assoc txt listall))
      ;then
      (setq listall (subst
		      (cons txt (1+ (cdr tpx)))
		      tpx
		      listall
		      ))
      ;else
      (setq listall (append listall (list
				      (cons (cdr (assoc 1 (entget ent)))1)
				      )))
      );if
    (setq i (1+ i))
    );repeat
  (foreach en listall
    (if
      (> (cdr en) 1)
      (setq lst (append lst (list en)))
      )
    );foreach
  lst

(setq ss (ssadd))
  (setq sslist (append))
  (foreach en lst
    (setq sslist (append sslist (ssget "_X" (list (cons 1 (car en))))))
    )

  ;(foreach en sslist (sssetfirst nil en))
  sslist
  );defun
  



;;; (subst  tpx (cons txt (1+ (cdr tpx))) listall)