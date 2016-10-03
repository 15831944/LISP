(defun c:att (/ blk)
  (while
    (/=	"INSERT"
	(cdr
	  (assoc 0
		 (entget (setq blk (car (entsel "\nукажите блок"))))
	  )
	)
    )
     (princ "\nэто не блок")
  );while

  (cdr (assoc 1 (entget (setq att (ktz-get-blk-attrib-ename blk)))))
  
  );defun