



(defun txt2att (
		/
		actdoc		
		ms		;modek space
		te		;text entity
		teng
		to
		ao		;attribute obj
		proplist
		;val
		;ctoct		;command to convert type to s

		)

  (setq actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (setq ms (vla-get-ModelSpace actdoc))
  (vla-startundomark actdoc)
  
  (acet-error-init
    (list (list "cmdecho"	0
		"highlight"	(getvar "highlight")
		"limcheck"	0
		"osmode"	0
		);list
	  T
	  );list
    );acet-error-init
  (setq proplist (list
		   "Alignment"
		   "Backward"
		   "Height"
		   "Layer"
		   "Linetype"
		   "Lineweight"
		   "ObliqueAngle"
		   "Rotation"
		   "ScaleFactor"
		   "StyleName"
		  ; "TextAlignmentPoint"
		   "color"
		   "InsertionPoint"
		   ))

  (setq te (car (entsel))
	teng (entget te))
  (setq to (vlax-ename->vla-object te))
  
  (setq ao (vla-AddAttribute ms
	     (cdr (assoc 40 teng))
	     8
	     ""
	     (vlax-3D-Point (cdr (assoc 10 teng)))
	     (getstring "\nвведите тег")
	     (cdr (assoc 1 teng))
	     )
	)


  (foreach item proplist
     (eval (list (read (strcat "VLA-PUT-" item))
		 ao
		 (eval (list (read (strcat "VLA-GET-" item)) to))
		 ))
    );foreach
  
;(vla-put-Alignment to)
  



  
  (acet-error-restore)
  (vla-endundomark actdoc)
  ao
  );defun



(defun do (obj)(vlax-dump-object obj T))

;;;(do(vlax-ename->vla-object (car (entsel))))
;;;
;;;
;;;(vla-get-TextAlignmentPoint (vlax-ename->vla-object (car (entsel))))
