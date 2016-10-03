;;;   сумма длин в дизеле (до 9-ти)
(defun c:asd ( / lst)
  (if (not (setq lst (ssget "_I" '((0 . "ARC,LINE"))))) (setq lst (ssget '((0 . "ARC,LINE")))))
  (setq lst (ss->lsto* lst))

  
;%<\AcObjProp Object(%<\_ObjId 2128579984>%).Length>%

;%<\AcObjProp Object(%<\_ObjId 2128579984>%).Length \f "%lu6">%
;%<\AcObjProp Object(%<\_ObjId 2128579992>%).ArcLength \f "%lu6">%


;%<\AcDiesel $(+,6,5)>%

;%<\AcDiesel $(+,"6",5)>%




;%<\AcDiesel $(+,$(eval,%<\AcObjProp Object(%<\_ObjId 2128579984>%).Length>%),5)>%

;%<\AcDiesel $(+,
;	       $(eval, %<\AcObjProp Object(%<\_ObjId 2128579984>%).Length>%),
;	       $(eval,%<\AcObjProp Object(%<\_ObjId 2128579992>%).ArcLength>%)
;	       )>%


(vla-addtext #modspace

(strcat
  "%<\\AcDiesel $(+,"
(antisep
(mapcar
  '(lambda (x)	;(setq x (nth 0 lst))
     (strcat
       "$(eval,"
       "%<\\AcObjProp Object"
       (strcat "(%<\\_ObjId " (itoa (vla-get-objectid x)) ">%)")
       (cond
	 ((= "AcDbLine" (vla-get-objectname x))".Length>%")
	 ((= "AcDbArc" (vla-get-objectname x))".ArcLength>%")
	 (T "")
	 )
       ")"
       )
     )
  lst
  )
",")
  ")>%"
  )
  (vlax-3d-point (getpoint))
  25
  )
  )













%<\AcDiesel $(+,$(eval, AcObjProp Object(%<\_FldPtr 2123594416>%).Length),$(eval, AcObjProp Object(%<\_FldPtr 2123594440>%).ArcLength))>%
%<\AcDiesel $(+,$(eval, %<\AcObjProp Object(%<\_ObjId 2128579984>%).Length>%),$(eval,%<\AcObjProp Object(%<\_ObjId 2128579992>%).ArcLength>%))>%





%<\AcDiesel $(+,
	       $(+,
		    $(eval, %<\AcObjProp Object(%<\_ObjId 2128579984>%).Length>%),
		    $(eval,%<\AcObjProp Object(%<\_ObjId 2128579992>%).ArcLength>%)
		),
	       10)>%


(defun dsl|mklengthexpr (obj)
  (strcat
    ;"$(eval,"
    "%<\\AcObjProp Object(%<\\_ObjId "
    (itoa (vla-get-objectID obj))
    ">%)."
    (cond
      ((= "AcDbLine" (vla-get-objectname obj))	"Length")
      ((= "AcDbArc" (vla-get-objectname obj))	"ArcLength")
      (T "")
      )
    ">%"
    ;")"
    )
  );defun


(defun dsl|mkpropIDexpression (obj prop)
  (strcat
    "$(eval,"
    "%<\\AcObjProp Object(%<\\_ObjId "
    (itoa (vla-get-objectID obj))
    ">%)." prop ">%"
    ")"
    )
  )	


;;;   сумма длин в дизеле (свыше 9-ти)


(defun c:asd (/ lst code)
  (if (not (setq lst (ssget "_I" '((0 . "ARC,LINE"))))) (setq lst (ssget '((0 . "ARC,LINE")))))
  (setq lst (ss->lsto* lst))
  (vla-addtext #modspace
    (setq code (strcat "%<\\AcDiesel " (dsl|recmklengthexpr (arrange lst 8)) ">%"))
    (vlax-3d-point (getpoint))
    25
    )
  code
  );defun


(defun dsl|recmklengthexpr (lst)
  (if (listp lst)
    (strcat "$(+," (antisep (mapcar 'dsl|recmklengthexpr lst) ",") ")")
    (dsl|mklengthexpr lst)
    )
  )




(defun arrange (lst quant / ans)
  (defun ar (lst q / i sublst ans)
    (setq i -1 ans '() sublst '())
    (mapcar
      '(lambda (x)
	 (if (= i (1- q))
	   (progn (setq i 0)
	   (setq ans (append ans (list (reverse sublst))))
	   (setq sublst (list x))
	   )
	 (setq sublst (cons x sublst) i (1+ i))
	 )
       )
      lst
      )
    (append ans (list (reverse sublst)))
    )
  (setq ans lst)
  (while (> (length ans) quant)
    (setq ans (ar ans quant))
    )
  ans
  );defun

	



%<\AcDiesel $(vla-get-length, Object(%<\_ObjId 2128579976>%),Length)>%

(defun c:asd2 ( / pt pe area)
  (setq pt (getpoint))
  (vl-cmdf "_.-boundary" pt "")
  (setq pe (vlax-ename->vla-object (entlast)))
  (setq area (/ (vla-get-Area pe) 1000000))
  (vla-delete pe)
  (vla-addtext #modspace (rtos area) (vlax-3d-point pt) 25)
  )
