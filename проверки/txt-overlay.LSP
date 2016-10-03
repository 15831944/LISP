;;; изменена 10_04_26
;;; прога дает наложение текста на что-нить
;;; использована при разработке щита БП №4 Береза
;;; -kakt00z-™  ©

(vl-load-com)

(defun txtbox (e / eng)
  (setq eng (entget e))
  (setq pts (textbox eng))
  (list
    (vec-sum (car pts) (cdr (assoc 10 eng)))
    (vec-sum (cadr pts) (cdr (assoc 10 eng)))
    ) ;_ list
  ) ;defun









 ;(defun check-txt-overlay (
(defun ch (/ ss	i box over tmp)
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
  (vl-cmdf "_erase" (ssget "_X" '((0 . "TEXT") (1 . ""))))

;;;  (if (ssget "_X" '((0 . "MTEXT")))
;;;    (progn
;;;      (alert "В чертеже присутствуют мультитекст\nкоманда отменена")
;;;      (acet-error-restore)
;;;      (exit)
;;;      );progn
;;;    );if



  (setq	i    0
	over (ssadd)
	ss   (ssget "_X" '((0 . "TEXT")))
	) ;_ setq
  (repeat (sslength ss)
 ;(setq box (txtbox (ssname ss i)))
    (setq box (boundlim (ssname ss i)))
;;;    (setq nl (append nl (list (cons (sslength (ssget "_C" (car box) (cadr box)))
;;;				    (ssname ss i)))))



    (vl-cmdf "_ZOOM" "_O" (ssname ss i) "")

   (if	(and
	  (setq tmp (ssget "_C" (car box) (cadr box)))
	  (> (sslength tmp)
	     1
	     ) ;_ >
	  )
      (setq over (ssadd (ssname ss i) over))
      ) ;if

    (setq i (1+ i))
    ) ;_ repeat


  (acet-error-restore)
  (sssetfirst nil over)

  ) ;defun


 ;(command "_rectang" (car (setq box (txtbox (car (entsel))))) (cadr box))






(defun boundlim	(e / pt1 pt2 minp maxp)
  (vla-GetBoundingBox (vlax-ename->vla-object e) 'minp 'maxp)
  (setq pt1 (vlax-safearray->list minp))
  (setq pt2 (vlax-safearray->list maxp))
  (list pt1 pt2)
  ) ;defun
