(defun c:att (/ blksel)
  (while
    (/=	"INSERT"
	(cdr
	  (assoc 0
		 (entget (car (setq blksel (entsel "\n������� ����"))))
	  )
	)
    )
     (princ "\n��� �� ����")
  )					;while

  (cdr
    (assoc 1 (entget (ktz-get-blk-attrib-ename-by-pt blksel)))
  )
)					;defun