
;	15_06_29


(load (strcat #lisppath "common functions\\pe-select.LSP"))

(setq #cbl:linklist '("CBL_FLD_HAND" "CBL_LST_HAND" "CBL_CNCT_HAND"))
(setq #cbl:exceptlist '("NOTE" "SIGN"))


(defun g:getmarks ( / marks m)
  (while (setq m (nentsel (apply 'strcat (mapcar '(lambda (x) (strcat x "\n")) (reverse marks)))))
    (setq marks (cons (kd-get-textstring (vlax-ename->vla-object (car m))) marks))
    )
  marks
  );defun


;	(setq ID "[ID]")
;	(setq frame '("#-A1" "##-B3" "FD-###" "##-##-df" "#-f-#"))
;	(ApplyIDToFrame ID frame)
;	res '("[ID]-A1" "[ID]-B3" "FD-[ID]" "[ID]-[ID]-df" "[ID]-f-[ID]") 
(defun ApplyIDToFrame (ID frame)
  (mapcar
    '(lambda (m / lst)
       (if (wcmatch m "*`#*")
	 (progn
	   (setq lst (sepstr* m))
	   (antisep (subst ID (nth (vl-position 'T (mapcar '(lambda (l) (wcmatch l "*`#*")) lst)) lst) lst) "")
	   )
	 m
	 )
       )
    frame)
  );defun


(defun assign-poz-to-marks (marks poz)
  (mapcar
    '(lambda (m / lst)
       (if (wcmatch m "*`#*")
	 (progn
	   (setq lst (sepstr* m))
	   (antisep (subst poz (nth (vl-position 'T (mapcar '(lambda (l) (wcmatch l "*`#*")) lst)) lst) lst) "")
	   )
	 m
	 )
       )
    marks)
  );defun



(defun cbl:putmarks (cab marks / matts i)
  (setq matts (getbattswcmatch cab "MARK#,MARK##,EP_ID##"))
  (mapcar '(lambda (a) (vla-put-TextString a "")) matts)
  (setq i -1)
  (foreach mrk (kd:sortmarks marks)
    (vla-put-textstring (nth (setq i (1+ i)) matts) mrk)
    )
  );defun



;;;******************************************************************************
;;; для блока кабеля cbl_fld - заполнение марок на трассах
;;;******************************************************************************



(defun c:cbl:pm () (g:cbl:putmarks))
(defun g:cbl:putmarks (/ m marks cblo)
  (setq marks (g:getmarks))
  (while (null (setq m (entsel "\nУкажите кабель..."))))
  (setq cblo (vlax-ename->vla-object (car m)))
  (cbl:putmarks cblo marks)
  );defun



;;;******************************************************************************
;;; для блока кабеля cbl_fld - заполнение марок жил на трассах
;;; из текстов с коробки зажимов
;;;******************************************************************************
(defun c:pmss () (ss:cbl:putmarks))
(defun ss:cbl:putmarks (/ ss cblo al matts i)
  (setq ss (ssget '((0 . "*TEXT") (-4 . "<NOT") (1 . "*Экран*") (-4 . "NOT>"))))
  (setq ss (mapcar '(lambda (x) (cdr (assoc 1 (entget x)))) (ss->sortedlst ss "content")))
  (setq cblo (vlax-ename->vla-object (car (entsel "\nУкажите кабель..."))))
  (cbl:putmarks cblo ss)
  );defun

;одни и те же марки в несколько кабелей
(defun ss:cbls:putmarks (/ ss ssbl al i)
  (setq ss (ssget '((0 . "*TEXT"))))
  (setq ss (mapcar '(lambda (x) (cdr (assoc 1 (entget x)))) (ss->sortedlst ss "content")))
  (setq ssbl (ss->lsto* (ssget '((0 . "INSERT")))))
  (mapcar '(lambda (cblo)
	     (cbl:putmarks cblo ss)
	     );lambda
	  ssbl
	  );mapcar
  );def
;;;******************************************************************************
;;; из блоков "клемма" с с клеммника
;;;******************************************************************************
(defun c:pmssb () (ss:cbl:putmarks-from-blocks))
(defun ss:cbl:putmarks-from-blocks (/ clams cblo matts strs)
  (setq clams (ss->lsto* (ssget '((0 . "INSERT")))))
  (setq matts (apply 'append (mapcar '(lambda (cl) (getbattswcmatch cl "MARK,EP_ID")) clams)))
  (setq strs (mapcar 'vla-get-textString matts))
  (setq strs (vl-sort strs '<))
  (setq strs (vl-remove-if '(lambda (x) (member x '("" " " "резерв" "экран" "Экран" "Shield"))) strs))
  (setq cblo (vlax-ename->vla-object (car (entsel "\nУкажите кабель..."))))
  (cbl:putmarks cblo strs)
  );defun
;;;******************************************************************************
;;;******************************************************************************
;;;******************************************************************************




;;;******************************************************************************
;;; из блоков с несколькими аттрибутами EP_ID*
;;;******************************************************************************
(defun c:pmssb2 () (ss:cbl:putmarks-from-block))
(defun ss:cbl:putmarks-from-block (/ clams cblo matts)
  (setq clams (ss->lsto* (ssget '((0 . "INSERT")))))
  (setq clams (apply 'append (mapcar '(lambda (x) (mapcar '(lambda (a) (vla-get-TextString a)) (getbattswcmatch x "EP_ID*"))) clams)))
  (setq clams (vl-sort clams '<))
  (setq clams (vl-remove-if '(lambda (x) (member x '("" " " "резерв" "экран" "Экран" "Shield"))) clams))
  (setq cblo (vlax-ename->vla-object (car (entsel "\nУкажите кабель..."))))
  (cbl:putmarks cblo clams)
  );defun
;;;******************************************************************************
;;;******************************************************************************
;;;******************************************************************************














;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;(cbl|getendpoint (vlax-ename->vla-object (car (entsel))))
;(setq obj (vlax-ename->vla-object (car (entsel))))
(defun cbl|getEndPoint (obj / ipt rot side cablength)
  (setq ipt (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
  (setq side (vlax-variant-value (vla-get-Value (getbdyn obj "cableSide"))))
  (setq rot (vla-get-Rotation obj))
  (setq cablength (+ 30 (vlax-variant-value (vla-get-Value (getbdyn obj "cabDist")))))

  (polar ipt rot
	 (cond
	   ((= 0 side) cablength)
	   ((= 1 side) (- cablength))
	   )
	 )
  );defun




;;;
;;;
;;;(setq pt (cbl|getEndPoint (vlax-ename->vla-object (car (entsel)))))
;;;(pe-select
;;;  (mapcar '+ pt '(1 1 0))
;;;  (mapcar '- pt '(1 1 0))
;;;  acSelectionSetCrossing '((0 . "LINE")))
;;;
;;;(setq pt (cbl|getEndPoint (vlax-ename->vla-object (car (entsel)))))
;;;(pe-select-at-point pt '((0 . "LINE")))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq obj (vlax-ename->vla-object (car (entsel))))
;(cbl|getCablePlank obj)
;(sssetfirst nil (ssadd (vlax-vla-object->ename (cbl|getCablePlank (vlax-ename->vla-object (car (entsel)))))))
(defun cbl|getCablePlank (obj / ssets sset result pt)
;;;  (setq ssets (vla-get-SelectionSets #actdoc))
;;;  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "getcableline")))
;;;    (setq sset (vla-add ssets "getcableline"))
;;;    (progn (vla-delete (vla-item ssets "getcableline")) (setq sset (vla-add ssets "getcableline")))
;;;    )
;;;  (vla-Clear sset)
;;;  (setq pt (cbl|getendpoint obj))	;(vla-AddCircle #modspace (vlax-3d-point pt) 2)
;;;  ;(vl-cmdf "_zoom" "_W" (car pts) (cadr pts))
;;;  (vla-SelectAtPoint sset
;;;    (vlax-3d-point pt)
;;;    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
;;;    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("LINE"))
;;;    )
;;;  (cond
;;;    ((= 1 (vla-get-count sset)) (setq result (vla-item sset 0)))
;;;    ((= 0 (vla-get-count sset)) (setq result nil))
;;;    (T (setq result (kd-container->list sset)))
;;;    )
;;;  (vla-clear sset)
;;;  (vla-Delete sset)
  (setq pt (cbl|getendpoint obj))
  ;(setq result (pe-select-at-point pt '((0 . "LINE"))))
  (setq result (pe-select (mapcar '+ pt '(0.3 0.3 0)) (mapcar '- pt '(0.3 0.3 0)) acSelectionSetCrossing '((0 . "LINE"))))
  ;(setq result (pe-select pt pt acSelectionSetCrossing '((0 . "LINE"))))
  (cond
    ((= 1 (length result)) (setq result (car result)))
    (T (setq result "error"))
    )
  result
  );defun


;(setq obj (vlax-ename->vla-object (car (entsel))))
;(sssetfirst nil (lst-to-ss (cbl|getCores (cbl|getCablePlank (vlax-ename->vla-object (car (entsel)))))))
(defun cbl|getCores (plankobj / ssets sset result dir)
;;;    (setq ssets (vla-get-SelectionSets #actdoc))
;;;    (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "getcableline")))
;;;      (setq sset (vla-add ssets "getcableline"))
;;;      (progn (vla-delete (vla-item ssets "getcableline")) (setq sset (vla-add ssets "getcableline")))
;;;      )
;;;    (vla-Clear sset)
;;;    (vla-select sset acSelectionSetCrossing
;;;      (vla-get-StartPoint plankobj)
;;;      (vla-get-EndPoint plankobj)
;;;      (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
;;;      (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("LINE"))
;;;      )
;;;    (cond
;;;      ((= 1 (vla-get-count sset)) (setq result (vla-item sset 0)))
;;;      ((= 0 (vla-get-count sset)) (setq result nil))
;;;      (T
;;;       (setq result (kd-container->list sset))
;;;       (setq result (vl-remove plankobj result))
;;;       )
;;;      )
;;;  (vla-clear sset)
;;;  (vla-Delete sset)

  (setq result
	 (pe-select
	   (variantextraction (vla-get-StartPoint plankobj))
	   (variantextraction (vla-get-EndPoint plankobj))
	   acSelectionSetCrossing
	   '((0 . "LINE"))
	   )
	)
  (setq result (vl-remove plankobj result))
  (vl-remove-if-not
    '(lambda (c)
       (geom|lineTrimmed plankobj c)
       )
    result
    )
  );defun



(defun geom|lineTrimmed (plankObj anyCore / dir fuzz)
  (setq fuzz 0.1)
  (cond
    ((member (fix (vla-get-angle plankobj)) '(1 4)); base line - vertical direction - horizontal
     (setq dir (car (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint plankobj)))))
     (or
       (< (abs (- dir (car (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint anyCore)))))) fuzz)
       (< (abs (- dir (car (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint anyCore)))))) fuzz)
       )
     )
    ((member (fix (vla-get-angle plankobj)) '(0 3 6)); base line - horizontal, direction - vertical
     (setq dir (cadr (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint plankobj)))))
     (or
       (< (abs (- dir (cadr (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint anyCore)))))) fuzz)
       (< (abs (- dir (cadr (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint anyCore)))))) fuzz)
       )
     )
    )
  );defun


(defun geom|linesOnePoint (obj1 obj2 / eqpoints sp1 sp2 ep1 ep2)
  ;(setq obj1 (vlax-ename->vla-object (car (entsel))))
  ;(setq obj2 (vlax-ename->vla-object (car (entsel))))
  (setq sp1 (vlax-safearray->list (vlax-variant-value (vla-get-startpoint obj1))))
  (setq sp2 (vlax-safearray->list (vlax-variant-value (vla-get-startpoint obj2))))
  (setq ep1 (vlax-safearray->list (vlax-variant-value (vla-get-endpoint obj1))))
  (setq ep2 (vlax-safearray->list (vlax-variant-value (vla-get-endpoint obj2))))
  (defun eqpoints (p1 p2 fuzz)
    (< (expt (apply '+ (mapcar '(lambda (x) (expt x 2)) (mapcar '- p1 p2))) 0.5) fuzz)
    )
  (or
    (eqpoints sp1 sp2 0.01)
    (eqpoints sp1 ep2 0.01)
    (eqpoints ep1 sp2 0.01)
    (eqpoints ep1 ep2 0.01)
    )
  );defun





;;;
;;;(defun c:asd ( / hl brefs)
;;;  (defun hl (lst) (sssetfirst nil (lst-to-ss lst)))
;;;  (hl
;;;    (setq brefs (geom|getNestedBRefs (vlax-ename->vla-object (car (entsel)))))
;;;    )
;;;
;;;;;;  (mapcar
;;;;;;    '(lambda (b / str)	;(setq b (nth 2 brefs))
;;;;;;       (if (setq str (getbatt b "MARK"))
;;;;;;	 (vla-get-textstring str)
;;;;;;	 )
;;;;;;       )
;;;;;;    brefs)
;;;
;;;  
;;;  );defun 

;(setq ans (geom|getNestedBRefs (vlax-ename->vla-object (car (entsel)))))
;(sssetfirst nil (lst-to-ss ans))


(defun geom|getNestedBRefs (obj / ) ; wayObjs)
  (setq wayObjs nil)
  ;(sssetfirst nil (lst-to-ss wayObjs))
  

(defun r:geom|getNested (obj / ssets sset pts result)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (setq wayObjs (cons obj wayObjs))
  ;(setq wayObjs (cons (vlax-ename->vla-object (car (entsel))) wayObjs))
  (setq ssets (vla-get-SelectionSets #actdoc))
  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "geom|getNested")))
    (setq sset (vla-add ssets "geom|getNested"))
    (progn (vla-delete (vla-item ssets "geom|getNested")) (setq sset (vla-add ssets "geom|getNested")))
    )
  (vla-Clear sset)
  (setq pts (append (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint obj))) (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint obj)))))
  (vla-SelectByPolygon sset acSelectionSetFence
    (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble (cons 0 (1- (length pts)))) pts)
    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 3)) '(-4 0 0 -4))
    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 3)) '("<OR" "INSERT" "LINE" "OR>"))
    )
  (setq result (kd-container->list sset))
  ;(sssetfirst nil (lst-to-ss result))
  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "geom|getNested")))
    (progn
      (vla-clear (vla-item ssets "geom|getNested"))
      (vla-delete (vla-item ssets "geom|getNested"))
      )
    )
  (vlax-release-object sset) (setq sset nil)
  ;(princ (length result))
  (setq result (vl-remove-if '(lambda (o) (member o wayObjs)) result))
  ;(sssetfirst nil (lst-to-ss wayObjs))
  ;(sssetfirst nil (lst-to-ss result))

  ;  убираем пересекающие линии
  (setq result (vl-remove-if-not '(lambda (c) (cond ((= "AcDbBlockReference" (vla-get-objectname c)) T) ((= "AcDbLine" (vla-get-objectname c)) (geom|lineTrimmed obj c)))) result))

   
  (while (member "AcDbLine" (mapcar 'vla-get-objectname result))
    (setq result
	   (apply 'append
    (mapcar
      '(lambda (o)	;(setq o (nth 0 result))
	 (cond
	   ((= "AcDbBlockReference" (vla-get-objectname o))
	    (list o)
	    )
	   ((= "AcDbLine" (vla-get-objectname o))
	    (r:geom|getNested o)
	    )
	   )
	 )
      result))
	  )
    )
  result
  );defun

  (r:geom|getNested obj)

  );defun





;;;;(cbl|getclam (vlax-ename->vla-object (car (entsel))))
;;;(defun cbl|getclam (obj / ssets sset result pt pts)
;;;  ;(setq obj (vlax-ename->vla-object (car (entsel))))
;;;  (setq ssets (vla-get-SelectionSets #actdoc))
;;;  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "cbl|getclam")))
;;;    (setq sset (vla-add ssets "cbl|getclam"))
;;;    (progn (vla-delete (vla-item ssets "cbl|getclam")) (setq sset (vla-add ssets "cbl|getclam")))
;;;    )
;;;  (vla-Clear sset)
;;;  (setq pts (append (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint obj))) (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint obj)))))
;;;  
;;;  (vla-SelectByPolygon sset acSelectionSetFence
;;;    (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble (cons 0 (1- (length pts)))) pts)
;;;    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
;;;    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("INSERT"))
;;;    )
;;;  (cond
;;;    ((= 1 (vla-get-count sset)) (setq result (vla-item sset 0)))
;;;    ((= 0 (vla-get-count sset))
;;;     (vla-Clear sset)
;;;     (vla-select sset acSelectionSetCrossing
;;;       (vla-get-StartPoint obj)
;;;       (vla-get-EndPoint obj)
;;;       (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
;;;       (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("LINE"))
;;;       )
;;;     (setq result (kd-container->list sset))
;;;     (setq result (vl-remove obj result))
;;;     (setq result (vl-remove-if-not '(lambda (c) (geom|linesOnePoint obj c)) result))
;;;     (if (= 1 (length result)) (setq result (cbl|getclam (car result))))
;;;     )
;;;    ((> (vla-get-count sset) 1)
;;;     (setq result (vl-remove-if-not '(lambda (bobj) (getbatt bobj "MARK")) (kd-container->list sset)))
;;;     (if (= 1 (length result)) (setq result (cbl|getclam (car result))))
;;;     )
;;;    )
;;;  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "cbl|getclam")))
;;;    (progn
;;;      (vla-clear (vla-item ssets "cbl|getclam"))
;;;      (vla-delete (vla-item ssets "cbl|getclam"))
;;;      )
;;;    )
;;;  result
;;;  );defun


;(cbl|getclam (vlax-ename->vla-object (car (entsel))))
;(setq obj (vlax-ename->vla-object (car (entsel))))
(defun cbl|getclam (obj / ssets sset result pt pts)
  (setq result (pe-select
		 (variantextraction (vla-get-StartPoint obj))
		 (variantextraction (vla-get-EndPoint obj))
		 acSelectionSetCrossing
		 '((0 . "INSERT"))))

  
  (cond
    ((> 1 (length result))
     (setq result "many blocks")
     )
    ((= 1 (length result))
     (setq result (car result))
     )
    (T
     (setq result (pe-select
		    (variantextraction (vla-get-StartPoint obj))
		    (variantextraction (vla-get-EndPoint obj))
		    acSelectionSetCrossing
		    '((0 . "LINE"))))
     (setq result (vl-remove obj result))
     (setq result (vl-remove-if-not '(lambda (c) (geom|linesOnePoint obj c)) result))
     (mapcar 'cbl|getclam result)
     )
    )
  result
  );defun










;(cbl|getclamstring (vlax-ename->vla-object (car (entsel))))
(defun cbl|getclamstring (core dir / ssets sset result p1 p2 pts)
  ;(setq core (vlax-ename->vla-object (car (entsel))))
  ;(setq dir 1)
  (setq ssets (vla-get-SelectionSets #actdoc))
  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "cbl|getclamstring")))
    (setq sset (vla-add ssets "cbl|getclamstring"))
    (progn (vla-delete (vla-item ssets "cbl|getclamstring")) (setq sset (vla-add ssets "cbl|getclamstring")))
    )
  (vla-Clear sset)

  (setq p1 (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint core))))
  (setq p2 (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint core))))
  (cond
    ;cable going to the right
    ;core line going to the right
    ((and (= 1 dir) (= 0 (vla-get-angle core)))
     (setq p1 p1 p2 (polar p1 pi 13))
     )
    ;cable going to the left
    ;core line going to the left
    ((and (= 0 dir) (= pi (vla-get-angle core)))
     (setq p1 p1 p2 (polar p1 0 13))
     )
    ;cable going to the right
    ;core line going to the left
    ((and (= 1 dir) (= pi (vla-get-angle core)))
     (setq p1 p2 p1 (polar p1 pi 13))
     )
    ;cable going to the left
    ;core line going to the right
    ((and (= 0 dir) (= 0 (vla-get-angle core)))
     (setq p1 p2 p1 (polar p1 0 13))
     )
    )
  ;(vla-addline #modspace (vlax-3d-point p1)(vlax-3d-point p2) )
  (setq pts (append p1 p2))
  (vla-SelectByPolygon sset acSelectionSetFence
    (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble (cons 0 (1- (length pts)))) pts)
    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("*TEXT"))
    )
  (cond
    ((= 1 (vla-get-count sset)) (setq result (vla-item sset 0)))
    ((= 0 (vla-get-count sset))
     (vla-Clear sset)
     (vla-select sset acSelectionSetCrossing
       (vla-get-StartPoint core)
       (vla-get-EndPoint core)
       (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
       (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("LINE"))
       )
     (setq result (kd-container->list sset))
     (setq result (vl-remove core result))
     (setq result (vl-remove-if-not '(lambda (c) (geom|linesOnePoint obj c)) result))
     (if (= 1 (length result))
       (setq result (cbl|getclam (car result)))
       )
     )
    )
  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "cbl|getclamstring")))
    (progn
      (vla-clear (vla-item ssets "cbl|getclamstring"))
      (vla-delete (vla-item ssets "cbl|getclamstring"))
      )
    )
  result
  );defun



















(defun c:ss:cbl:pullmarks ( / lst bnames)
  (vla-startundomark #actdoc)
;;;  (setq bnames '("cbl_cnct"))
;;;  ;(setq lst (ss:getBRefs '("cbl_cnct")))
;;;  (if (null (setq lst (ssget "_I" (list '(0 . "INSERT") (8 . "0") (cons 2 (antisep (cons "`*U*" bnames) ","))))))
;;;    (setq lst (ssget (list '(0 . "INSERT") (cons 2 (antisep (cons "`*U*" bnames) ",")) (8 . "0")))))
;;;  (setq lst (ss->lsto* lst))
;;;  (setq lst (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) bnames)) lst))
;;;  (length lst)
  (setq lst (ss->lsto* (ssget "_I")))
  (mapcar 'cbl:pullmarks lst)
  (vla-endundomark #actdoc)
  );defun

(defun c:cbl:pullmarks ( / cab)
  (if (setq cab (entsel "Select a cable:   "))
    (progn
      (setq cab (vlax-ename->vla-object (car cab)))
      (cbl:pullmarks cab)
    )
    )
  );defun


(defun cbl:pullmarks (cab / gettouched planka dir cores clams marks matts i)
  ;(setq cab (vlax-ename->vla-object (car (entsel "cable"))))
  (setq dir (vlax-variant-value (vla-get-Value (getbdyn cab "cableSide"))))
  (setq planka (cbl|getcableplank cab))		;(sssetfirst nil (lst-to-ss (list planka)))
  (setq cores (cbl|getcores planka))		;(sssetfirst nil (lst-to-ss cores))
  (setq clams (mapcar 'cbl|getclam cores))	;(sssetfirst nil (lst-to-ss clams))
  (setq marks
     (vl-remove 'nil
       (mapcar
	 '(lambda (b / att)
	    (if (setq att (getbatt b "MARK"))
	      (kd-get-textstring att)
	      (if (= "arrow" (vla-get-EffectiveName b))
		;(cbl|getclamstring )
		;(exit)
		"PE"
		)
	      )
	    )
	 clams
	 )))
  ;(setq clams (mapcar '(lambda (c) (cbl|getclamstring c dir)) cores))
  ;(setq marks (mapcar 'kd-get-textstring clams))
  (setq marks (vl-sort marks '<))
  (setq matts (getbattswcmatch cab "MARK#,MARK##,EP_ID##"))
  (mapcar '(lambda (a) (vla-put-TextString a "")) matts)
  (setq i -1)
  (foreach mrk marks
    (vla-put-textstring (nth (setq i (1+ i)) matts) mrk)
    )
  );defun


(defun c:cbl:pushMarks ( / cab)
  (if (setq cab (entsel "Select a cable:   "))
    (progn
      (setq cab (vlax-ename->vla-object (car cab)))
      (cbl:pushMarks cab)
      )
    )
  );defun


(defun cbl:pushMarks (cab / planka dir cores clams marks matts i)
  ;(setq cab (vlax-ename->vla-object (car (entsel "cable"))))
  (setq dir (vlax-variant-value (vla-get-Value (getbdyn cab "cableSide"))))
  (setq planka (cbl|getcableplank cab))		;(sssetfirst nil (lst-to-ss (list planka)))
  (setq cores (cbl|getcores planka))		;(sssetfirst nil (lst-to-ss cores))
  (setq clams (mapcar 'cbl|getclam cores))	;(sssetfirst nil (lst-to-ss clams))\
  (setq clams (vl-sort clams '(lambda (a b)
				(>
				  (cadr (variantextraction (vla-get-InsertionPoint a)))
				  (cadr (variantextraction (vla-get-InsertionPoint b)))
				  ))))
  (setq marks
     (vl-remove 'nil
       (mapcar
	 '(lambda (b / att)
	    (car (getbattswcmatch b "MARK,EP_ID"))
	    )
	 clams
	 )))

  (setq cores (getbattswcmatch cab "MARK#,MARK##,EP_ID##"))
  (setq cores (vl-remove-if '(lambda (str) (or (= "" str))) (mapcar 'vla-get-textstring cores)))
  (if (= (length cores) (length marks))
    (mapcar '(lambda (m c) (vla-put-TextString m c)) marks cores)
    )
  );defun








(defun c:cbl:showconnections ( / cab planka cores clams)
  (setq cab (vlax-ename->vla-object (car (entsel "cable"))))
  (setq planka (cbl|getcableplank cab))
  ;(sssetfirst nil (lst-to-ss (list planka)))
  ;(setq planka (vlax-ename->vla-object (car (entsel))))
  (setq cores (cbl|getcores planka))
  ;(length cores)
  ;(length (vl-remove planka cores))
  ;(sssetfirst nil (lst-to-ss cores))
  (setq clams
	 (mapcar
	   '(lambda (x / re)	;(setq x (vlax-ename->vla-object (car (entsel))))
	      (setq re (cbl|getclam x))
	      (if (listp re)
		(cbl|getclam (car (vl-remove planka re)))
		re
		)
	      )
	   cores)
	)
  (sssetfirst nil (lst-to-ss clams))
  )




;(sssetfirst nil (lst-to-ss (car clams)))











(defun c:cbl:pullmarks2 ( / cab gettouched planka dir cores clams marks matts i)
  (setq cab (vlax-ename->vla-object (car (entsel "cable"))))
  (setq dir (vlax-variant-value (vla-get-Value (getbdyn cab "cableSide"))))
  (setq planka (cbl|getcableplank cab))
  
  (setq clams (vl-remove-if-not '(lambda (o) (getbatt o "MARK")) (geom|getNestedBrefs planka)))	;(sssetfirst nil (lst-to-ss clams))
  (setq marks (vl-remove 'nil (mapcar '(lambda (b) (kd-get-textstring (getbatt b "MARK"))) clams)))
  (setq marks (origlist marks))
  (setq marks (vl-sort marks '<))
  (setq matts (getbattswcmatch cab "MARK#,MARK##,EP_ID##"))
  (mapcar '(lambda (a) (vla-put-TextString a "")) matts)
  (setq i -1)
  (foreach mrk marks
    (vla-put-textstring (nth (setq i (1+ i)) matts) mrk)
    )
  );defun




;;;
;;;
;;;;;	    маленька проверка на жилы кабелей
;;;
;;;
;;;(setq
;;;  #cbl:Catalog
;;;   '(
;;;     ("ВВГнг(А)-LS"  1 2 3 4 5 6)
;;;     ("КВВГнг(А)-LS" 4 5 7 10 14 19 27 37)
;;;     ("КВВГЭнг(А)-LS" 4 5 7 10 14 19 27 37)
;;;    
;;;     )
;;;   )
;;;
;;;
;;;
;;;(setq cabs (ss->lsto* (ssget "_I")))
;;;(length cabs)
;;;
;;;(setq errors '())
;;;
;;;
;;;(mapcar
;;;  '(lambda (cab / matts marks i TYP coreAtt coresUsed catCQ)	;(setq cab (nth 13 cabs)) (setq cab (vlax-ename->vla-object (car (entsel))))
;;;     ;(sssetfirst nil (lst-to-ss (list cab)))
;;;     (setq TYP (vla-get-TextString (getbatt cab "CBL_TYPE")))
;;;     (setq coreAtt (getbatt cab "CBL_CQ"))
;;;     (setq matts (getbattswcmatch cab "MARK#,MARK##,EP_ID##"))
;;;     (setq marks (origlist (vl-remove '"" (mapcar 'vla-get-textstring matts))))
;;;     ;(mapcar '(lambda (a) (vla-put-TextString a "")) matts)
;;;     ;(setq i -1)
;;;     ;(foreach mrk marks
;;;     ;  (vla-put-textstring (nth (setq i (1+ i)) matts) mrk)
;;;     ;  )
;;;     (setq coresUsed (length marks))
;;;     (setq catCQ (car (vl-remove-if '(lambda (c) (<= c coresUsed)) (cdr (assoc TYP #cbl:Catalog)))))
;;;
;;;     ;;;;;;;;;;;;;;;;;;;;;;   П Р О В Е Р К А ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     (if (/= catCQ
;;;	   ;(car (vl-remove-if '(lambda (c) (< c nc)) (cdr (assoc TYP #cbl:Catalog))))
;;;	   (atoi (vla-get-TextString coreAtt))
;;;	   )
;;;       (setq errors (cons cab errors))
;;;       )
;;;     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;
;;;     
;;;     ;;;;;;;;;;;;;;;;;;;;;;   П Р О В Е Р К А ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     ;;;;;;;;;;;;;;;;;;;;;; С   У С Т А Н О В К О Й ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;     (cond
;;;       ((wcmatch (vla-get-TextString coreAtt) "*`#*")
;;;	(vla-put-TextString coreAtt (itoa catCQ))
;;;	)
;;;       (T
;;;	(cond
;;;	  ((/= (vla-get-TextString coreAtt) (itoa catCQ))
;;;	   (setq errors (cons cab errors))
;;;	   )
;;;	  )
;;;	)
;;;       )
;;;     )
;;;  cabs)
;;;
;;;
;;;(sssetfirst nil (lst-to-ss errors))
;;;
;;;










;;;
;;;
;;;;;;******************************************************************************
;;;;;;******************************************************************************
;;;;;;******************************************************************************
;;;; ; ;;    вытаскиваем позицию присоединения из жилы
;;;(setq lst (ss->lsto* (ssget "_I")))
;;;
;;;(mapcar
;;;  '(lambda (cab / m)
;;;     (setq m (vla-get-TextString (getbatt cab "MARK1")))	;(setq m "3NX-371-A1")
;;;     (vla-put-TextString (getbatt cab "LOCCAB")
;;;       (antisep (reverse (cdr (reverse (sepstr m "-")))) "-")
;;;       )
;;;     )
;;;  lst)
;;;
;;;;;;  когда тепереь в аттрибуте LOCCAB - позиция задвижки - переписываем туда от базы - код присоединения в сборке
;;;
;;;(setq prjBase (excel>lst))
;;;
;;;(mapcar
;;;  '(lambda (cab / p line)	;(setq cab (nth 13 lst))
;;;     (setq m (vla-get-TextString (getbatt cab "LOCCAB")))
;;;     (vla-put-TextString (getbatt cab "LOCCAB")
;;;       (antisep (cdr (assoc m prjBase)) ":")
;;;       )
;;;     )
;;;  lst)



;;;******************************************************************************
;;;******************************************************************************
;;;******************************************************************************

;d:\_LISP\проверки\проверка последовательности нумерации.lsp
(defun check-cablenumbers-override (/ lst data)
  (setq lst (mapcar
	      '(lambda (x)
		 (vla-get-TextString (getbatt x "NUMBER")))
	      (ss->lsto* (ssget '((0 . "INSERT"))))))
  (setq data (mapcar '(lambda (x) (list x 0)) lst))
  (mapcar
    '(lambda (x / ass)
       (setq ass (assoc x data))
       (setq data (subst (list (car ass) (1+ (cadr ass))) ass data))
       (princ)
       )
    lst)
  (setq data (mapcar 'reverse data))
  );defun









;   add jumper
(defun c:aj ( /
	     get_osmode
	     curSnapMode
	     
	     makeSA countPoints
	     bpt ang stepheight XDir YDir step
	     pline
	     time drag grpt
	     ) 
  (setq curSnapMode (getvar "snapmode"))
  (defun get_osmode (/ cur_mode mode$)
    (setq mode$ "")
    (if (< 0 (setq cur_mode (getvar "osmode")) 16383)
      (mapcar
        '(lambda (x)
           (if (not (zerop (logand cur_mode (car x)))) (setq mode$ (strcat mode$ (cadr x))))
	   )
	'(
          (0    "_non,")
          (1    "_end,")
          (2    "_mid,")
          (4    "_cen,")
          (8    "_nod,")
          (16   "_qua,")
          (32   "_int,")
          (64   "_ins,")
          (128  "_per,")
          (256  "_tan,")
          (512  "_nea,")
          (1024 "_qui,")
          (2048 "_app,")
          (4096 "_ext,")
          (8192 "_par")
         )
	)
      )
    mode$
    );defun

  (defun makeSA (ptlist / lst sa)
    (setq lst (apply 'append ptlist))
    (setq sa (vlax-make-safearray vlax-vbDouble (cons 0  (1- (length lst)))))
    (vlax-safearray-fill sa lst)
    sa
    );defun

  (defun countPoints (curPT)
    (list
      bpt
      ;X2
      (mapcar '+ bpt
      (list
	(cond
	  ((= "Right" XDir) (+ (* step stepheight)))
	  ((= "Left" XDir) (- (* step stepheight)))
	  )
	(cond
	  ((= "Up" YDir) (+ (/ (* step stepheight (sin ang)) (cos ang))))
	  ((= "Down" YDir) (- (/ (* step stepheight (sin ang)) (cos ang))))
	  )
	0
	))
      ;X3
      (mapcar '+ curPT
      (list
	(cond
	  ((= "Right" XDir) (* step stepheight))
	  ((= "Left" XDir) (- (* step stepheight)))
	  )
	(cond
	  ((= "Up" YDir) (- (/ (* step stepheight (sin ang)) (cos ang))))
	  ((= "Down" YDir) (+ (/ (* step stepheight (sin ang)) (cos ang))))
	  )
	0
	))
      ;X4
      curPT
      )
    );defun



  
  (setq ang (/ pi 6))
  (setq stepheight 1)
  (setq XDir "Right")
  (setq YDir "Down")
  (setq bpt (getpoint))
  (setq step 3)



  
  (setq curOSnap (getvar "osmode"))
  (setq pline (vla-AddPolyline #modspace (makeSA (list '(0 0 0) '(0 0 0) '(0 0 0) '(0 0 0)))))

  (setq time T)

  (while time
	(setq drag (grread t 1 0))
	(cond
	  ((= 5 (car drag))
	   (if (null (setq grpt (osnap (cadr drag) (get_osmode)))) (setq grpt (cadr drag)))
	   ;(setq grpt (cadr drag))
	   (cond
	     ((> (- (car grpt) (car bpt)) (* 3 stepheight)) (setq XDir "Right"))
	     ((> (- (car bpt) (car grpt)) (* 3 stepheight)) (setq XDir "Left"))
	     )
	   (cond
	     ((> (- (cadr grpt) (cadr bpt)) (* 3 stepheight)) (setq YDir "Up"))
	     ((> (- (cadr bpt) (cadr grpt)) (* 3 stepheight)) (setq YDir "Down"))
	     )
	   (vla-put-Coordinates pline (makeSA (countPoints grpt)))
	   )
	  ((= 3 (car drag))
	   (setq grpt (cadr drag))
	   (setq time nil)
	   )
	  ((= 2 (car drag))
	   ;(setvar "osmode" curOSnap)
	   (setvar "snapmode" (+  2 (~ (getvar "snapmode"))))
	   ;(alert "key")
	   )
	  )
	)
  
  );defun




(defun c:cbl:printcores ()
  (cbl|printCores (vlax-ename->vla-object (car (entsel))))
  )

(defun cbl|printCores (cab / cpt eps ang)
  ;(setq cab (vlax-ename->vla-object (car (entsel))))
  (setq eps (vl-remove '"" (mapcar 'vla-get-textstring (getbattswcmatch cab "MARK#,MARK##,EP_ID##"))))
  (setq ang (vla-get-Rotation cab))
  (setq cpt (polar (cbl|getEndPoint cab) (- ang (/ Pi 2)) -2.5))
  ;(vla-AddCircle #modspace (vlax-3d-point cpt) 5)

  (mapcar
    '(lambda (str / txto)
       (setq txto (vla-Addtext #modspace str (vlax-3d-point '(0 0 0))2.5))
       (vla-put-Alignment txto 12)
       (vla-put-TextAlignmentPoint txto (vlax-3d-point (polar cpt ang 1)))
       (vla-put-Rotation txto ang)
       (vlax-release-object txto)
       (setq cpt (polar cpt (- ang (/ Pi 2)) 5))
       )
    eps
    )
  )