;;; 13_07_26


;(setq #actdoc (vla-get-activedocument acad))
(SETQ #gostformats
           '(("w-A4" 297 210)
             ("w-A4x3" 630 297)
             ("w-A4x4" 841 297)
             ("w-A4x5" 1051 297)
             ("w-A4x6" 1261 297)
             ("w-A4x7" 1471 297)
             ("w-A4x8" 1682 297)
             ("w-A4x9" 1892 297)
             ("w-A3" 420 297)
             ("w-A3x3" 891 420)
             ("w-A3x4" 1189 420)
             ("w-A3x5" 1486 420)
             ("w-A3x6" 1783 420)
             ("w-A3x7" 2080 420)
             ("w-A2" 594 420)
             ("w-A2x3" 1261 594)
             ("w-A2x4" 1682 594)
             ("w-A2x5" 2102 594)
             ("w-A1" 841 594)
             ("w-A1x3" 1783 841)
             ("w-A1x4" 2378 841)
             ("w-A0" 1189 841)
             ("w-A0x2" 1682 1189)
             ("w-A0x3" 2523 1189)
             ("v-A4" 210 297)
             ("v-A4x3" 297 630)
             ("v-A4x4" 297 841)
             ("v-A4x5" 297 1051)
             ("v-A4x6" 297 1261)
             ("v-A4x7" 297 1471)
             ("v-A4x8" 297 1682)
             ("v-A4x9" 297 1892)
             ("v-A3" 297 420)
             ("v-A3x3" 420 891)
             ("v-A3x4" 420 1189)
             ("v-A3x5" 420 1486)
             ("v-A3x6" 420 1783)
             ("v-A3x7" 420 2080)
             ("v-A2" 420 594)
             ("v-A2x3" 594 1261)
             ("v-A2x4" 594 1682)
             ("v-A2x5" 594 2102)
             ("v-A1" 594 841)
             ("v-A1x3" 841 1783)
             ("v-A1x4" 841 2378)
             ("v-A0" 841 1189)
             ("v-A0x2" 1189 1682)
             ("v-A0x3" 1189 2523)
            )
      )



;;; income - active document
;;; outgo - ((x1 y1)(x2 y2)) - left-bot right-up
(defun getBoundSS (sset / 
                        listmin listmax
                        minp maxp
                        minx miny
                        maxx maxy
                        )
;;;  (setq sset   (vla-get-ActiveSelectionSet #actdoc))
;;;  (vla-clear sset)
;;;  (vla-SelectOnScreen sset
;;;                    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
;;;                    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("*"))
;;;                    )
(setq listmin '()
      listmax '()
      minp nil
      maxp nil
      )
(vlax-for anEntity sset
    (progn
        ;(setq minp nil maxp nil)
        (vla-getboundingbox anEntity 'minp 'maxp)
        (setq listmin (append listmin (list minp)))
        (setq listmax (append listmax (list maxp)))
        ))
    (setq minx (apply 'min (mapcar 'car (mapcar 'vlax-safearray->list listmin))))
    (setq miny (apply 'min (mapcar 'cadr (mapcar 'vlax-safearray->list listmin))))
    (setq maxx (apply 'max (mapcar 'car (mapcar 'vlax-safearray->list listmax))))
    (setq maxy (apply 'max (mapcar 'cadr (mapcar 'vlax-safearray->list listmax))))
    (list (list minx miny)(list maxx maxy))
    );defun

;(setq lst (getlinesBoundSS))
;(vl-cmdf "_rectang" (car lst) (cadr lst))





;(setq ptlist (list (getpoint) (getpoint)))
;(formatassoc ptlist)
;(formatassoc (list (getpoint) (getpoint)))
(defun formatassoc (ptlist / dopusk size tmp)
  ;;; dopusk - погрешность в вырисовывании форматов
  ;;; если вылазят штампы как в мьянме - можно ставить
  ;;; около 80 - главное чтоб не больше 297
  (setq dopusk 2)
  (setq size (mapcar '(lambda (a b ) (abs (- a b))) (cadr ptlist) (car ptlist)))
  (while
    (null (setq tmp (vl-member-if
	   '(lambda (x)
	      ;(setq x (nth 14 #gostformats))
	      (and (< (abs (- (cadr size) (caddr x))) dopusk)
		   (< (abs (- (car size) (cadr x))) dopusk))
	      )
	   #gostformats)
		))
    (setq dopusk (+ 2 dopusk))
    )
(car (car tmp))
);defun

;(formatassoc lst)