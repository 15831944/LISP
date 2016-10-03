

(defun check-txt-overlay ( /
			  lays
			  errlay
			  )
  (defun chto:boundlim	(e / minp maxp)
    (vla-GetBoundingBox (if (= (type e) 'ENAME) (vlax-ename->vla-object e) e) 'minp 'maxp)
    (list (vlax-safearray->list minp) (vlax-safearray->list maxp))
    ) ;defun

  
  (acet-error-init
    (list (list	"cmdecho"		0
		"highlight"		(getvar "highlight")
		"regenmode"		0
		"attreq"		0
		"expert"		0
		"limcheck"		0
		"osmode"		0
		"pickstyle"		0
		) ;_ list
	  T
	  ) ;list
    ) ;acet-error-init
  ;(vl-cmdf "_erase" (ssget "_X" '((0 . "TEXT") (1 . ""))))
  

;;;  (if (ssget "_X" '((0 . "MTEXT")))
;;;    (progn
;;;      (alert "В чертеже присутствуют мультитекст\nкоманда отменена")
;;;      (acet-error-restore)
;;;      (exit)
;;;      );progn
;;;    );if



  (setq lays (vla-get-Layers #actdoc))
  (setq errlay (vla-add lays "errors_txtoverlay"))
  (vla-put-Plottable errlay :vlax-false)
  (vla-SetRGB #color 250 100 100)
  (vlax-put-property errlay "Truecolor" #color)
  (vla-regen #actdoc 0)

  (setq lst (ss->lsto* (ssget "_X" '((0 . "TEXT")))))
  (setq lst (vl-remove-if
    '(lambda (x / p1 p2)
       ;(setq x (nth 145 lst))
       (setq p1 (chto:boundlim x) p2 (cadr p1) p1 (car p1))
       (vl-cmdf "_ZOOM" "_O" (vlax-vla-object->ename x) "")
       (= 1 (sslength (ssget "_C" p1 p2)))
       )
    lst
    ))

  (mapcar
    '(lambda (x / c)
       (setq c (vla-addCircle #modspace (vla-get-InsertionPoint x) (* 3 (vla-get-Height x))))
       (vla-put-Layer c (vla-get-Name errlay))
       (vla-put-Lineweight c acLnWt100)
       )
    lst
    )
  (if lst
    (princ (strcat "\n   !!!! НАЙДЕНО  " (itoa (length lst)) " наездов текста !!!!!"))
    (princ)
    )
  ) ;defun

