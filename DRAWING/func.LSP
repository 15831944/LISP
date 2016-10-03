;;;  заполняем блоки типа "func_элемент"
;;;  данными из блоков "func_затвор-с-электроприводом"
;;;  полем

(defun c:funcellink ( / obj valve)
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (setq valve (func|get-valve-from-element obj))
  (vla-put-TextString (getbatt obj "POZ") (kfl:IDtoFC (vla-get-ObjectID (getbatt valve "ID"))))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename obj) "")
  );defun


(defun func|get-valve-from-element (obj / p1 p2 ss)
  (vla-GetBoundingBox obj 'p1 'p2)
  (setq ss (ssget "_C" (vlax-safearray->list p1) (vlax-safearray->list p2)))
  (if (= 1 (length (setq ss (vl-remove-if '(lambda (x) (= "AcDbBlockReference" (vla-get-ObjectName x))) (ss->lsto* ss)))))
    (setq ss (car ss)) (exit)
    )
  (vla-GetBoundingBox ss 'p1 'p2)
  (setq ss (ssget "_C" (vlax-safearray->list p1) (vlax-safearray->list p2)))
  (if (= 1 (length (setq ss (vl-remove-if '(lambda (x) (or (= "AcDbLine" (vla-get-ObjectName x)) (= "func_элемент" (vla-get-EffectiveName x)))) (ss->lsto* ss)))))
    (setq ss (car ss)) (exit)
    )
  ss
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;  когда овалы давлений стоят на схеме
;;;  переносим их в подвал

;(setq count 1)

(defun c:fde ( / oval mbpt osm ss)
  ;(vla-startundomark #actdoc)
  ;(acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0  "osmode" 0
;		) T));acet-error-init
  (setq oval (vlax-ename->vla-object (car (entsel))))
  ;(setq mbpt (mapcar '+ (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint oval))) '(0 8 0)))
  (setq ss (func|downel oval))
  
  ;(setq osm (getvar "osmode"))
  ;(setvar "osmode" 4159)
  ;(setvar "osmode" 0)
  (sssetfirst nil ss)

  
  ;(vl-cmdf "_move" ss "" mbpt)
  ;(vla-sendcommand #actdoc "(vl-cmdf \"_move\" ss \"\" mbpt)")
  ;(vla-sendcommand #actdoc "(setvar \"osmode\" osm)")
  
  ;(setvar "osmode" osm)
  ;(acet-error-restore)
  ;(vla-endundomark #actdoc)
  )

(defun func|downel (oval / bpt pt schtxt podvtxt podvline proptxt ss)
  (setq bpt (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint oval))))
  (setq pt (func|getlinept oval))

  (setq podvline (vla-addLine #modspace (vlax-3d-point (mapcar '+ bpt '(0 5 0)))(vlax-3d-point (mapcar '+ bpt '(0 33 0)))))
  (vla-put-Layer podvline "func_связи")
  (setq podvtxt (vla-Addtext #modspace "##" (vlax-3d-point '(0 0 0)) 2.5))
  (vla-put-Layer podvtxt "func_связи")
  (vla-put-Alignment podvtxt 13)
  (vla-put-TextAlignmentPoint podvtxt (vlax-3d-point (mapcar '+ bpt '(0 33 0))))
  
  (setq proptxt (vla-Addtext #modspace "####" (vlax-3d-point '(0 0 0)) 2.5))
  (vla-put-Layer proptxt "func_связи")
  (vla-put-Alignment proptxt 12)
  (vla-put-TextAlignmentPoint proptxt (vlax-3d-point (mapcar '+ bpt '(0 9 0))))
  (vla-put-Rotation proptxt (/ pi 2))


  (setq schtxt (vla-Addtext #modspace "##" (vlax-3d-point '(0 0 0)) 2.5))
  (vla-put-Layer schtxt "func_связи")
  (cond
    ((= (* 0 pi) (angle bpt pt))		;; влево
     (vla-put-Alignment schtxt 11)
     (vla-put-TextAlignmentPoint schtxt (vlax-3d-point (mapcar '+ pt '(-1 0 0))))
     )
    ((= (* 0.5 pi) (angle bpt pt))		;; вверх
     (vla-put-Alignment schtxt 7)
     (vla-put-TextAlignmentPoint schtxt (vlax-3d-point (mapcar '+ pt '(0 -1 0))))
     )
    ((= (* 1 pi) (angle bpt pt))		;; вправо
     (vla-put-Alignment schtxt 9)
     (vla-put-TextAlignmentPoint schtxt (vlax-3d-point (mapcar '+ pt '(1 0 0))))
     )
    ((= (* 1.5 pi) (angle bpt pt))		;; вниз
     (vla-put-Alignment schtxt 13)
     (vla-put-TextAlignmentPoint schtxt (vlax-3d-point (mapcar '+ pt '(0 0 0))))
     )
    )
  (vla-put-TextString schtxt (kfl:IDtoFC (vla-get-ObjectID podvtxt)))
  (lst-to-ss (list oval podvline podvtxt proptxt))
  );defun





(defun func|getlinept (oval / p1 p2 line)
  ;(setq oval (vlax-ename->vla-object (car (entsel))))
  (vla-GetBoundingBox oval 'p1 'p2)
  (setq line (ssget "_C" (vlax-safearray->list p1) (vlax-safearray->list p2)))
  (if (= 1 (length (setq line (vl-remove-if '(lambda (x) (= "AcDbBlockReference" (vla-get-ObjectName x))) (ss->lsto* line)))))
    (setq line (car line)) (exit)
    )
  (setq p1 (vla-IntersectWith line oval acExtendNone))
  (setq p1 (vlax-safearray->list (vlax-variant-value p1)))
  (if (= 6 (length p1))
    (list (car p1) (cadr p1))
    p1
    )
	
  );defun






(defun func|getIntersectionPoints (obj / p1 p2 sslst)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (vla-GetBoundingBox obj 'p1 'p2)
  (setq sslst (ss->lsto* (ssget "_C" (vlax-safearray->list p1) (vlax-safearray->list p2))))
  (setq sslst (vl-remove obj sslst))
  (mapcar
    '(lambda (x / ip)  ;(setq x (car sslst))
       (setq ip (vlax-safearray->list (vlax-variant-value (vla-IntersectWith obj x acExtendNone))))
       (if (= 6 (length ip)) (list (car ip) (cadr ip)) ip )
       )
    sslst
    )
  );defun




;;;(defun c:qwe (/ bobj gr g1 g2)
;;;  (setq bobj (vlax-ename->vla-object (car (entsel))))
;;;  (while
;;;    (progn
;;;      (setq gr (grread 't 15 2)
;;;	    g1 (car gr)
;;;	    g2 (cadr gr)
;;;	    )
;;;      (vla-put-InsertionPoint bobj (vlax-3D-point g2))
;;;      (= 5 g1)
;;;    )
;;;  )
;;;)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(setq lst (car (ss->tbl (ssget))))


(mapcar
  '(lambda (x / e)
     (setq e (vlax-ename->vla-object (car (entsel))))
     (vla-put-TextString e (kfl:IDtoFC (vla-get-ObjectID x)))
     )
  lst
  )


;;;; когда надо отобразить зеркально выноску-связь с текстом на 1 мм от линии
;;;; когда рисуем сноски давления





(defun func|changelinkdirection ( / ss ip gr g1 g2 ang v1 v2 al)

(setq ss (ss->lsto* (ssget)))
(mapcar
  '(lambda (x)
     (cond
       ((= "AcDbText" (vla-get-objectname x))(setq otxt x))
       ((= "AcDbLine" (vla-get-objectname x))(setq oline x))
       )
     )
  ss
  )

(setq ip (car (func|getIntersectionPoints oline)))
(while
  (progn
    (vla-put-StartPoint oline (vlax-3d-point ip))
    (setq gr (grread 't 15 0) g1 (car gr) g2 (cadr gr))
    ;(setq g2 (getpoint))
    (setq ang (angle ip g2))
    (cond
      ((or (diap ang (* 7 (/ pi 4)) (* 2 pi)) (diap ang 0 (* 1 (/ pi 4))))
       (setq v1 '(3 0 0) v2 '(4 0 0) al 9))	;right
      ((diap ang (* 1 (/ pi 4)) (* 3 (/ pi 4)))
       (setq v1 '(0 3 0) v2 '(0 3 0) al 13))	;up
      ((diap ang (* 3 (/ pi 4)) (* 5 (/ pi 4)))
	(setq v1 '(-3 0 0) v2 '(-4 0 0) al 11))	;left
      ((diap ang (* 5 (/ pi 4)) (* 7 (/ pi 4)))
	(setq v1 '(0 -3 0) v2 '(0 -4 0) al 7))	;down
      )
    (vla-put-EndPoint oline (vlax-3d-point (mapcar '+ ip v1)))
    (vla-put-Alignment otxt al)
    (vla-put-TextAlignmentPoint otxt (vlax-3d-point (mapcar '+ ip v2)))
    
    
    (= 5 g1)
    )
  )
  );defun
