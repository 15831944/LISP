(defun qwe (
	    /
	    e
	    eng
	    bp24data
	    app
	    )
(setq e (car (entsel))
      eng (entget e)
      app "contacts")
(regapp app)
(setq bp24data
       (list
	 (list
	   -3
	   (list
	     app
	     ;(cons 1000 "pitanie")
	     (cons 1002 "{")
	     (cons 1012 (getpoint))
	     (cons 1012 (getpoint))
	     (cons 1012 (getpoint))
	     (cons 1002 "}")
	     )
	   )
	 )
       );set list
  (setq eng (append eng bp24data))
  (entmod eng)
  (entupd e)
  )





(defun mkline-to-c (
		    /
		    e
		    eng
		    app
		    pt
		    data
		    ptlist
		    i
		    )

  (setq e (car (entsel))
	eng (entget e)
	app "contacts"
	pt (getpoint)
	i 0
	)
  (setq data (cdadr (assoc -3 (entget e (list app)))))
;;;  (setq data (vl-remove-if-not
;;;	       (function (lambda (x) (= (car x) 1002)))
;;;	       data))



  (setq ptlist
	 (mapcar 'cdr
		 (vl-remove-if-not
		   (function (lambda (x) (/= (car x) 1002)))
		   (cdadr (assoc -3 (entget e (list app))))
		   ))
	);setq
  (foreach item ptlist
    (entmake  (list '(0 . "LINE")
		    (cons 10 pt)
		    (cons 11 item)
		    '(100 . "AcDbEntity")
		    '(370 . 60))
	      )
    )

  )



;;;(mapcar 'cdr
;;;(vl-remove-if-not
;;;	       (function (lambda (x) (/= (car x) 1002)))
;;;  (cdadr (assoc -3 (entget e (list app))))
;;;  ))
blockrepresentationdata