(defun ortoline (
		 /
		 doc
		 p1
		 p2
		 p3
		 pv
		 linedeg
		 pvdeg
		 )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init

  (setq p1 (getpoint)
	p2 (getpoint p1)
	pv (getpoint)
	pvdeg (min
		(* (/ (angle p1 pv) pi) 180)
		)
	linedeg (/ (* (/ (angle p1 p2) pi) 180) 4)
	;linedeg (min (/ (angle p1 p2)2) (/ (angle p2 p1) 2))
	;pvdeg (min (/ (angle p1 pv)2) (/ (angle p2 pv) 2))
	)
  (princ "\n угол линии\n")
  (princ linedeg)
  (princ "\n разница\n")
  (princ (- linedeg pvdeg))
  (princ "\n условие\n")
  (princ  (> linedeg pvdeg))
  (princ "\n конец условия\n")
  
  (if (and
	(> linedeg pvdeg)
;;;	(or
;;;	(and
;;;	  (> linedeg 0)
;;;	  (< linedeg 90)
;;;	  )
;;;	(and
;;;	  (> linedeg 180)
;;;	  (< linedeg 270)
;;;	  )
;;;	)
	)
    (setq p3 (list (car p2) (cadr p1)))
    (setq p3 (list (car p1) (cadr p2)))
    );if

  
  (entmake  (list '(0 . "LINE")
		  (cons 10 p1)
		  (cons 11 p3)
		  '(100 . "AcDbEntity")
		  '(370 . 60)
		  )
	    )
  (entmake  (list '(0 . "LINE")
		  (cons 10 p3)
		  (cons 11 p2)
		  '(100 . "AcDbEntity")
		  '(370 . 60)))

  (acet-error-restore)
  (vla-endundomark doc)  
  );defun



  (setq p1 (getpoint)
	p2 (getpoint p1)
	an (getangle p1))
(- (angle p1 p2) an)