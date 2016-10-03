;;; 12_11_20
;;; 13_07_26
;;;  всеравно херовро сделано get-sh-number
;;;;;;  1:1

;;; ===============    GLOBAL    ================================

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
;;; =============================================================
(defun ipoint (obj) (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))


;;; income - active document
;;; outgo - ((x1 y1)(x2 y2)) - left-bot right-up
(defun getlinesBoundSS (
                        /
                        sset
                        listmin
                        listmax
                        minp
                        maxp
                        minx
                        miny
                        maxx
                        maxy
                        )
(setq sset   (vla-get-ActiveSelectionSet #actdoc))
(vla-clear sset)
(vla-SelectOnScreen sset
                    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
                    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("*"))
                    )
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








(defun formatassoc (ptlist / dopusk size)
    ;;; dopusk - погрешность в вырисовывании форматов
    ;;; если вылазят штампы как в мьянме - можно ставить
    ;;; около 80 - главное чтоб не больше 297
    (setq dopusk 2)
    (setq size (mapcar '- (cadr ptlist) (car ptlist)))
    (car (car (vl-member-if
	  '(lambda (x) (and (< (abs (- (cadr size) (caddr x))) dopusk)
			    (< (abs (- (car size) (cadr x))) dopusk)))
	  #gostformats)))
    );defun

;(formatassoc lst)



;;;; это говно надо доделать
(defun get-sh-number (ptlist
                      /
                      sset
		      tmp
                      )
  ;(setq ptlist (getlinesBoundSS))
  (setq sset (vla-get-ActiveSelectionSet #actdoc))
  (vla-clear sset)
  (vla-Select sset acSelectionSetWindow
  (vlax-3d-point (car ptlist))
  (vlax-3d-point (cadr ptlist))
  ;(vlax-3d-point (car lst))
  ;(vlax-3d-point (cadr lst))
  (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 1)) '(0 1))
  (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 1)) '("TEXT" "Лист"))
  )



  (cond
    ((= (vla-get-Count sset) 2)
     (progn
       (setq tmp (if (< (car (ipoint (vla-item sset 1))) (car (ipoint (vla-item sset 0)))) (vla-item sset 0)(vla-item sset 1)))
       (vla-clear sset)
       (vla-Select sset acSelectionSetWindow
	 (vla-get-InsertionPoint tmp)
	 (vlax-3d-point (list (+ (car (ipoint tmp)) 10)
			      (- (cadr (ipoint tmp)) 10)))
	 (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
	 (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("TEXT"))
	 )
       (if (= 1 (vla-get-Count sset))
	 (vla-get-TextString (vla-item sset 0))
	 (exit)
	 )
       )
     )
    ((= (vla-get-Count sset) 0)
     (progn
       (vla-clear sset)
       (vla-Select sset acSelectionSetWindow
	 (vlax-3d-point (car ptlist))
	 (vlax-3d-point (cadr ptlist))
	 (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 1)) '(0 0))
	 (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("INSERT"))
	 )
       (setq tmp
       (vl-remove-if-not
	 '(lambda (blk)
	    (member (vla-get-EffectiveName blk)
		    '("format-spec" "format" "РФ_format-spec" "РФ_format"))
	    )
	 (KD-CONTAINER->LIST sset)
	 ))
       (if (= 1 (length tmp)) (vla-get-TextString (getbatt (car tmp) "НОМЕР_ЛИСТА")) (exit))
       )

       
       )
    );cond
    

  
  (setq tmp
    (cond
      ((= (vla-get-Count sset) 0) "block")
      ((= (vla-get-Count sset) 2)
	 (if (< (car (ipoint (vla-item sset 1)))
		(car (ipoint (vla-item sset 0))))
	   (vla-item sset 0)
	   (vla-item sset 1)
	   );if
       )
      (T "error")
      );cond
	)


;;;  (vla-clear sset)
;;;  (vla-Select sset acSelectionSetWindow
;;;    (vla-get-InsertionPoint tmp)
;;;    (vlax-3d-point (list (+ (car (ipoint tmp)) 10)
;;;			 (- (cadr (ipoint tmp)) 10)))
;;;    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
;;;    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("TEXT"))
;;;    )
  (if (= 1 (vla-get-Count sset))
    (vla-get-TextString (vla-item sset 0))
    (exit)
    )
  );defun
;(get-sh-number (getlinesBoundSS))
;(get-sh-number lst)






(defun c:ss:plot ()
  (getlinesBoundSS)
  )