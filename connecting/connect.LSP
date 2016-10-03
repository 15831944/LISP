;;;Ф_ОБОЗ		UG38		ID
;;;ПОЗИЦИЯ		UT075.1		poz
;;;МАРКА_СВЯЗИ		UT075.1-2	mark
;;;СХ_ОБОЗ		P15		code
;;;ИМЯ_СИГНАЛА		Давление...	signal
;;;ОБОЗН		P15(UG38)	sign
;;;К_ПРИБОРУ/ПРИБОР	P15:X2:3	address


;;; 			VLA-GET-ATTRIBUTES см cnct-w-p
;(vla-select)















;;;;;*******************************************************************************
;;;;;*******************************************************************************
;;;;;*******************************************************************************
;;;;;*******************************************************************************
;;;;;*******************************************************************************
;;;;;*******************************************************************************
;;;;;*******************************************************************************
;;;**********************************************************************************
;;; есть блок-прибор с аттрибутом СХ_ОБОЗ и цифрой с номером клеммы
;;; и блок-провод с атрибутом "ПРИБОР"
;;; вставка поля в атрибут "Прибор" провода с содержимым типа Р45:6
;;;**********************************************************************************

;;; певеделанное с изменением названия аттрибутов в блоках
;;; 11_02_02

;;;Ф_ОБОЗ		UG38		ID
;;;ПОЗИЦИЯ		UT075.1		poz
;;;МАРКА_СВЯЗИ		UT075.1-2	mark
;;;СХ_ОБОЗ		P15		code
;;;ИМЯ_СИГНАЛА		Давление...	signal
;;;ОБОЗН		P15(UG38)	sign
;;;К_ПРИБОРУ/ПРИБОР	P15:X2:3	address/owner





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun cnct:genFieldString (obj) 
  (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-objectid obj)) ">%).TextString>%")
  )

;(setq obj (vlax-ename->vla-object (car (entsel))))
;(cnct:getbpick (vlax-ename->vla-object (car (entsel))))
(defun cnct:getbpick (obj / ip ang flip sset pt ans)
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
  (setq ang (vla-get-Rotation obj))
  ;(setq flip (vlax-variant-value (vla-get-value (cnct:getbdyn obj "Flip state1"))))
  ;(setq flip (vlax-variant-value (vla-get-value (cnct:getbdyn obj "Direction"))))
  (if (setq flip (cnct:getbdyn obj "Direction"))
    (setq flip (vlax-variant-value (vla-get-value flip)))
    (setq flip 0)
    )
  (setq pt (polar ip (+ ang (* flip pi)) 2.5))
  (vla-zoomwindow #cad (vlax-3d-point (polar pt 0 80)) (vlax-3d-point (polar pt pi 80)))
  (setq ans (nentselp "" pt))
  ans
  );defun




;(setq bref (vlax-ename->vla-object (car (entsel))))
(defun cnct:getbdyn (bref propertyname / dps)
  (setq dps (vlax-variant-value (vla-GetDynamicBlockProperties bref)))
  (if (>= (vlax-safearray-get-u-bound dps 1) 0)
    (car (vl-remove-if-not '(lambda (x) (= propertyname (vla-get-PropertyName x))) (vlax-safearray->list dps)))
    )
  );defun



;;	pick	-	nentsel result
;(setq mode T)
;;	mode	-	isFieldNedded
;;			T - whith field
(defun cnct|getAddressFromObjTree (pick mode / pinatt parents)
  ;(setq pick (nentsel))
  (setq pinatt (vlax-ename->vla-object (car pick)))
  (if (member (vla-get-ObjectName pinatt) '("AcDbText" "AcDbMText" "AcDbAttribute"))
    (progn
      (cond
	((= 2 (length pick))
	 (if mode
	   (cnct:genFieldString pinatt)
	   (vla-get-TextString pinatt)
	   )
	 )
	((= 4 (length pick))
	 (setq parents (mapcar 'vlax-ename->vla-object (last pick)))
	 (if mode
	   (strcat
	     (antisep (reverse (mapcar '(lambda (prnt / code) (if (setq code (getbatt prnt "CODE")) (cnct:genFieldString code) "")) parents)) ":")
	     ":"
	     (cnct:genFieldString pinatt)
	     )
	   (strcat
	     (antisep (reverse (mapcar '(lambda (prnt / code) (if (setq code (getbatt prnt "CODE")) (vla-get-textstring code) "")) parents)) ":")
	     ":"
	     (vla-get-TextString pinatt)
	     )
	   )
	 )
	)
      )
    "*error-string-is-absent*"
    )
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:cnct-w-P ( / wire blockpick)
  (if (null #actdoc) (setq #actdoc (vla-get-activedocument (vlax-get-acad-object))))
  (vla-startundomark #actdoc)
  ;(acet-error-init (list (list	"cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (setq wire (vlax-ename->vla-object (car (entsel "\nУкажите провод...\n"))))
  (setq blockpick (nentsel "\nукажите номер клеммы прибора\n"))
  (cnct:w-p wire blockpick)
  ;(acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:cnct-ws-P ( / wires)
  (if (null #actdoc) (setq #actdoc (vla-get-activedocument (vlax-get-acad-object))))
  (vla-startundomark #actdoc)
  ;(acet-error-init (list (list	"cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (setq wires (ss:getBRefs '("wiring_провод" "wiring_wire")))
  ;(setq wires (vl-remove-if-not '(lambda (w) (= "wiring_провод" (vla-get-EffectiveName w))) (ss->lsto* (ssget '((0 . "INSERT"))))))
  (if wires
    (mapcar
      '(lambda (w)	;(setq w (vlax-ename->vla-object (car (entsel))))
	(cnct:w-p w (cnct:getbpick w))
	)
      wires)
    )
  ;(acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq wblock (vlax-ename->vla-object (car (entsel "\nУкажите провод...\n"))))
;(setq bpick (nentsel))
(defun cnct:w-p (wblock bpick /
		 oal			; object attributes list
		 awOWNER		; an attribute of a wire "OWNER"
		 str			; ADDRESS
		 )
  (setq oal (getbattswcmatch wblock "OWNER,WR_PIN,ПРИБОР"))
  (if (= 1 (length oal)) (setq awOWNER (car oal)) (exit))
  (setq str (cnct|getAddressFromObjTree bpick T))

  (if (and
	(vlax-write-enabled-p awOWNER)
	(vlax-property-available-p awOWNER 'TextString)
	str
	(/= str "*error-string-is-absent*")
	)
    (vla-put-textstring awOWNER str)
    )
  (vl-cmdf "_updatefield" (vlax-vla-object->ename awOWNER) "")
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




















;; 14_01_29
;; jumper-to-clam
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:cnct-j-k ( / wire clam)  
  (vla-startundomark #actdoc)
  (acet-error-init (list (list	"cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq wire (vlax-ename->vla-object (car (entsel "\n1. Укажите провод...\n"))))
  (setq clam (vlax-ename->vla-object (car (entsel "\n2. укажите клемму...\n"))))
  (if
    (and
      (member (vla-get-EffectiveName wire) '("wiring_провод" "монтаж_провод"))
      (member (vla-get-EffectiveName clam)
	      '("wiring_STS-2.5-MT" "wiring_STS-2.5" "wiring_STS-2.5-PE" "wiring_ST-4-HESI" "wiring_ST-4-HEDI"))
      )
    (cnct:j-k wire clam)
    (princ "\nans: не соответствуют блоки")
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (acet-error-restore)
  (vla-endundomark #actdoc)  
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;"MARK" "ADDRESS" "TYPE" "OWNER"
;(setq wire (vlax-ename->vla-object (car (entsel))))
;(setq clam (vlax-ename->vla-object (car (entsel))))
(defun cnct:j-k (wire clam)
  (vla-put-TextString (getbatt wire "MARK") "")
  (vla-put-TextString (getbatt wire "OWNER")
    (strcat
      (cnct:genfieldstring (getbatt clam "CLAMP"))
      ":"
      (cnct:genfieldstring (getbatt clam "NUMBER"))
      )
    )
  (vl-cmdf "_updatefield" (vlax-vla-object->ename wire) "")
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; 14_01_29
;; jumper-to-jumper
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:cnct-j-j ( / wire1 wire2)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list	"cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq wire1 (vlax-ename->vla-object (car (entsel "\n1. Укажите провод...\n"))))
  (setq wire2 (vlax-ename->vla-object (car (entsel "\n2. укажите клемму...\n"))))
  (if
    (and
      (member (vla-get-EffectiveName wire1) '("wiring_провод" "монтаж_провод"))
      (member (vla-get-EffectiveName wire2) '("wiring_провод" "монтаж_провод"))
      )
    (cnct:j-j wire1 wire2)
    (princ "\nans: не соответствуют блоки")
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (acet-error-restore)
  (vla-endundomark #actdoc)  
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;"MARK" "ADDRESS" "TYPE" "OWNER"
;(setq wire1 (vlax-ename->vla-object (car (entsel))))
;(setq wire2 (vlax-ename->vla-object (car (entsel))))
(defun cnct:j-j (wire1 wire2)
  (vla-put-TextString (getbatt wire1 "ADDRESS")
    (cnct:genfieldstring (getbatt wire2 "OWNER")))
  (vla-put-TextString (getbatt wire2 "ADDRESS")
    (cnct:genfieldstring (getbatt wire1 "OWNER")))

  (if (/= (vla-get-TextString (getbatt wire1 "TYPE")) (vla-get-TextString (getbatt wire2 "TYPE"))) (alert "не совпадают типы проводов"))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename wire1) "")
  (vl-cmdf "_updatefield" (vlax-vla-object->ename wire2) "")
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





























;;;(car (entsel "\nУкажите провод...\n"))
;;;
;;;  (setq bpick (nentsel "\nукажите номер клеммы прибора\n"))
;;;  (while (= "ATTRIB" (cdr (assoc 0 (entget (car bpick)))))
;;;    (setq bpick (nentsel "\nНЕЛЬЗЯ УКАЗЫВАТЬ АТТРИБУТЫ\n"))
;;;    )

;;;
;;;nentsel
;;;ssnamex
;;; певеделанное с изменением названия аттрибутов в блоках
;;; 11_02_02
(defun connect-wire-to-device (
			       wire		;ename провода
			       bpick		; block pickpiont by nentsel
		   /
		   oal			; object attributes list
		   tag			; tagstring of an attribute object
		   aCONNECTEDTO		; an attribute of a wire "CONNECTEDTO"
		   str
		   aCODE		;an attribute of pribor named "CODE"
		   )
  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    wire
		    )))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ;CONNECTEDTO
      ((member tag '("OWNER" "ПРИБОР")) (setq aCONNECTEDTO att))
      );cond
    )
  (if (null aCONNECTEDTO) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))

  (setq str "")

  (if (> (length bpick) 2)
    (progn
      (foreach block (mapcar 'vlax-ename->vla-object (reverse (car (reverse bpick))))
	(setq oal (vlax-safearray->list (vlax-variant-value (vla-GetAttributes block))))
	(foreach att oal
	  (setq tag (vla-get-tagstring att))
	  (cond
	    ((member tag '("CODE" "СХ_ОБОЗ")) (setq aCODE att))
	    );cond
	  );foreach attribute
	(if aCODE (setq str (strcat str
				    "%<\\AcObjProp Object(%<\\_ObjId "
				    (itoa (vla-get-objectid aCODE))
				    ">%).TextString>%"
				    ":"
				    )))
	);foreach block
      (if (setq tag (assoc 1 (entget (car bpick))))
	(setq str (strcat str (cdr tag)))
	(setq str (vl-string-right-trim ":" str))
	)
      );progn
    (setq str (strcat
		"%<\\AcObjProp Object(%<\\_ObjId "
		(itoa (vla-get-objectid (vlax-ename->vla-object(car bpick))))
		">%).TextString>%"
		))
    );if has parent

  (if (and
	(vlax-write-enabled-p aCONNECTEDTO)
	(vlax-property-available-p aCONNECTEDTO 'TextString))
    (vlax-put aCONNECTEDTO 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename aCONNECTEDTO) "")
  (princ)
  );defun









































;;; певеделанное с изменением названия аттрибутов в блоках
;;; 11_02_02

(defun c:cnct-k-w (/

		   oal			; object attributes list
		   tag			; tagstring of an attribute object
		   awOWNER	; an attribute of a wire "OWNER"
		   awMARK		; an att if wire named "mark"
		   awADDRESS		; an att of wire named "address" (to clamp)

		   acNUMBER
		   acCLAMP
		   acMARK
		   acADDRESS
		   
		  )
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T));acet-error-init

  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    (car (entsel "\nУкажите провод...\n")))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("WR_PIN" "OWNER" "ПРИБОР")) (setq awOWNER att))
      ((member tag '("EP_ID" "MARK" "МАРКА")) (setq awMARK att))
      ((member tag '("ADDRESS" "К_КЛЕММЕ")) (setq awADDRESS att))
      );cond
    )
  (if (null (or awOWNER awMARK awADDRESS)) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))


  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    (car (entsel "\nУкажите клемму...\n")))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("NUMBER" "НОМЕР_КЛЕММЫ" "PIN" "CODE")) (setq acNUMBER att))
      ((member tag '("EP_ID" "MARK" "МАРКА_СВЯЗИ")) (setq acMARK att))
      ((member tag '("CLAMP" "NКЛЕММНИКА")) (setq acCLAMP att))
      ((member tag '("ADDRESS" "К_ПРИБОРУ")) (setq acADDRESS att))
      );cond
    )
  (if (null (or acNUMBER acCLAMP acMARK acADDRESS)) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))


  ;awADDRESS -------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid acCLAMP))
	      ">%).TextString>%"
	      ":"
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid acNUMBER))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p awADDRESS)
	   (vlax-property-available-p awADDRESS 'TextString))
    (vlax-put awADDRESS 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename awADDRESS) "")


  ;acADDRESS -------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid awOWNER))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p acADDRESS)
	   (vlax-property-available-p acADDRESS 'TextString))
    (vlax-put acADDRESS 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename acADDRESS) "")


  ;acMARK ----------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid awMARK))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p acMARK)
	   (vlax-property-available-p acMARK 'TextString))
    (vlax-put acMARK 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename acMARK) "")
  
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun










;;; певеделанное с изменением названия аттрибутов в блоках
;;; 11_02_02
(defun c:cnct-pr (
		  /
		  oal			; object attributes list
		  tag			; tagstring of an attribute object
		  aCODE
		  aSIGN
		  aPOZ
		  str
		  )
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list	"cmdecho"	0
		"highlight"	(getvar "highlight")
		"limcheck"	0
		"osmode"	0
		) ;list
	  T) ;list
    ) ;acet-error-init
  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    (car (entsel "\nУкажите прибор...\n")))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("CODE" "СХ_ОБОЗ")) (setq aCODE att))
      ((member tag '("SIGN" "ОБОЗН")) (setq aSIGN att))
      ((member tag '("EL_KKSID" "KKSID" "ID" "POZ" "Ф_ОБОЗ" "ПОЗИЦИЯ")) (setq aPOZ att))
      ;((member tag '("ID")) (setq aPOZ att))
      );cond
    )
  (if (null (and aCODE aSIGN aPOZ)) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid aCODE))
	      ">%).TextString>%"
	      "("
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid aPOZ))
	      ">%).TextString>%"
	      ")"
	      ))
  (if (and (vlax-write-enabled-p aSIGN)
	   (vlax-property-available-p aSIGN 'TextString))
    (vlax-put aSIGN 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename aSIGN) "")
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun







;;; SIGN без скобок с ID
;;; 14_01_28
(defun c:cnct-pr* (
		  /
		  oal			; object attributes list
		  tag			; tagstring of an attribute object
		  aCODE
		  aSIGN
		  aPOZ
		  str
		  )
  
  (vla-startundomark #actdoc)
  (acet-error-init (list (list	"cmdecho" 0 "highlight"	(getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (setq oal (vlax-safearray->list (vlax-variant-value
	(vla-GetAttributes (vlax-ename->vla-object (car (entsel "\nУкажите прибор...\n")))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("CODE" "СХ_ОБОЗ")) (setq aCODE att))
      ((member tag '("SIGN" "ОБОЗН")) (setq aSIGN att))
      );cond
    )
  (if (null (and aCODE aSIGN
		 ;aPOZ
		 )) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid aCODE))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p aSIGN)
	   (vlax-property-available-p aSIGN 'TextString))
    (vlax-put aSIGN 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename aSIGN) "")
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun







;;; певеделанное с изменением названия аттрибутов в блоках
;;; 11_02_02

(defun c:cnct-w-k (/

		   oal			; object attributes list
		   tag			; tagstring of an attribute object
		   awOWNER		; an attribute of a wire "OWNER"
		   awMARK		; an att if wire named "mark"
		   awADDRESS		; an att of wire named "address"

		   acNUMBER
		   acCLAMP
		   acMARK
		   acADDRESS
		   
		  )
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init

  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    (car (entsel "\nУкажите провод...\n")))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("OWNER" "ПРИБОР")) (setq awOWNER att))
      ((member tag '("MARK" "МАРКА")) (setq awMARK att))
      ((member tag '("ADDRESS" "К_КЛЕММЕ")) (setq awADDRESS att))
      );cond
    )
  (if (null (or awOWNER awMARK awADDRESS)) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))


  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    (car (entsel "\nУкажите клемму...\n")))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("NUMBER" "PIN" "НОМЕР_КЛЕММЫ")) (setq acNUMBER att))
      ((member tag '("MARK" "МАРКА_СВЯЗИ")) (setq acMARK att))
      ((member tag '("CLAMP" "NКЛЕММНИКА")) (setq acCLAMP att))
      ((member tag '("ADDRESS" "К_ПРИБОРУ")) (setq acADDRESS att))
      );cond
    )
  (if (null (or acNUMBER acCLAMP acMARK acADDRESS)) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))


  ;awADDRESS ---------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid acCLAMP))
	      ">%).TextString>%"
	      ":"
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid acNUMBER))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p awADDRESS)
	   (vlax-property-available-p awADDRESS 'TextString))
    (vlax-put awADDRESS 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename awADDRESS) "")


  ;acADDRESS -------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid awOWNER))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p acADDRESS)
	   (vlax-property-available-p acADDRESS 'TextString))
    (vlax-put acADDRESS 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename acADDRESS) "")


  ;awMARK ----------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid acMARK))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p awMARK)
	   (vlax-property-available-p awMARK 'TextString))
    (vlax-put awMARK 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename awMARK) "")
  
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun


























;;; певеделанное с изменением названия аттрибутов в блоках и самих блоков
;;; 11_07_11

(defun c:cnct-w-w (/

		   oal			; object attributes list
		   tag			; tagstring of an attribute object
		   aw1OWNER		; an attribute of a wire1 "OWNER"
		   aw1MARK		; an att if wire1 named "mark"
		   aw1ADDRESS		; an att of wire1 named "address" (to clamp)

		   aw2OWNER		; an attribute of a wire2 "OWNER"
		   aw2MARK		; an att if wire2 named "mark"
		   aw2ADDRESS		; an att of wire2 named "address" (to clamp)
		  )
  
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T));acet-error-init

  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    (car (entsel "\nУкажите провод - источник потенциала ...\n")))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("WR_PIN" "OWNER" "ПРИБОР")) (setq aw1OWNER att))
      ((member tag '("EP_ID" "MARK" "МАРКА")) (setq aw1MARK att))
      ((member tag '("ADDRESS" "К_КЛЕММЕ")) (setq aw1ADDRESS att))
      );cond
    )
  (if (null (or aw1OWNER aw1MARK aw1ADDRESS)) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))


  
  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    (car (entsel (strcat
				   "Укажите "
				   (vla-get-textstring aw1ADDRESS)
				   " для подключения к "
				   (vla-get-textstring aw1OWNER)
				   " потенциала "
				   (vla-get-textstring aw1MARK)
				   ))))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("WR_PIN" "OWNER" "ПРИБОР")) (setq aw2OWNER att))
      ((member tag '("EP_ID" "MARK" "МАРКА")) (setq aw2MARK att))
      ((member tag '("ADDRESS" "К_КЛЕММЕ")) (setq aw2ADDRESS att))
      );cond
    )
  (if (null (or aw2OWNER aw2MARK aw2ADDRESS)) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))

  ;aw1ADDRESS -------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid aw2OWNER))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p aw1ADDRESS)
	   (vlax-property-available-p aw1ADDRESS 'TextString))
    (vlax-put aw1ADDRESS 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename aw1ADDRESS) "")


  ;aw2ADDRESS -------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid aw1OWNER))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p aw2ADDRESS)
	   (vlax-property-available-p aw2ADDRESS 'TextString))
    (vlax-put aw2ADDRESS 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename aw2ADDRESS) "")


  

  ;acMARK ----------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid aw1MARK))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p aw2MARK)
	   (vlax-property-available-p aw2MARK 'TextString))
    (vlax-put aw2MARK 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename aw2MARK) "")
  
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun















;;; певеделанное с изменением названия аттрибутов в блоках и самих блоков
;;; 12_07_30

(defun c:cnct-k-k (/

		   oal			; object attributes list
		   tag			; tagstring of an attribute object
		   
		   ak1CLAMP		; an attribute of a klamp1 "CLAMP"
		   ak1NUMBER		; an attribute of a klamp1 "NUMBER"
		   ak1MARK		; an att if klamp1 named "mark"
		   ak1ADDRESS		; an att of klamp1 named "address" (to clamp)

		   ak2CLAMP		; an attribute of a klamp2 "CLAMP"
		   ak2NUMBER		; an attribute of a klamp2 "NUMBER"
		   ak2MARK		; an att if klamp2 named "mark"
		   ak2ADDRESS		; an att of klamp2 named "address" (to clamp)
		  )
  
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init

  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    (car (entsel "\nУкажите клемму-источник марки...\n")))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("CLAMP")) (setq ak1CLAMP att))
      ((member tag '("NUMBER" "ПРИБОР")) (setq ak1NUMBER att))
      ((member tag '("MARK" "МАРКА")) (setq ak1MARK att))
      ((member tag '("ADDRESS" "К_КЛЕММЕ")) (setq ak1ADDRESS att))
      );cond
    )
  (if (null (or ak1CLAMP ak1NUMBER ak1MARK ak1ADDRESS)) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))

  (setq oal (vlax-safearray->list
	      (vlax-variant-value
		(vla-GetAttributes
		  (vlax-ename->vla-object
		    (car (entsel "\nУкажите провод...\n")))))))
  (foreach att oal
    (setq tag (vla-get-tagstring att))
    (cond
      ((member tag '("CLAMP")) (setq ak2CLAMP att))
      ((member tag '("NUMBER" "ПРИБОР")) (setq ak2NUMBER att))
      ((member tag '("MARK" "МАРКА")) (setq ak2MARK att))
      ((member tag '("ADDRESS" "К_КЛЕММЕ")) (setq ak2ADDRESS att))
      );cond
    )
  (if (null (or ak2CLAMP ak2NUMBER ak2MARK ak2ADDRESS)) (progn (alert "\nне найден соответствующий атрибут в блоке") (exit)))

  ;ak1ADDRESS -------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid ak2CLAMP))
	      ">%).TextString>%"
	      ":"
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid ak2NUMBER))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p ak1ADDRESS)
	   (vlax-property-available-p ak1ADDRESS 'TextString))
    (vlax-put ak1ADDRESS 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename ak1ADDRESS) "")


  ;ak2ADDRESS -------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid ak1CLAMP))
	      ">%).TextString>%"
	      ":"
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid ak1NUMBER))
	      ">%).TextString>%"	      
	      ))
  (if (and (vlax-write-enabled-p ak2ADDRESS)
	   (vlax-property-available-p ak2ADDRESS 'TextString))
    (vlax-put ak2ADDRESS 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename ak2ADDRESS) "")


  

  ;ak2MARK ----------------------------------------------------------------
  (setq str (strcat
	      "%<\\AcObjProp Object(%<\\_ObjId "
	      (itoa (vla-get-objectid ak1MARK))
	      ">%).TextString>%"
	      ))
  (if (and (vlax-write-enabled-p ak2MARK)
	   (vlax-property-available-p ak2MARK 'TextString))
    (vlax-put ak2MARK 'TextString str))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename ak2MARK) "")
  
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun








;;;**********************************************************************************
;;; есть блок-прибор с аттрибутом  CODE (СХ_ОБОЗ)
;;; и блок-провод с атрибутом "OWNER"
;;; вставка поля в атрибут "OWNER" провода содержимого аттрибута CODE блока-прибора


(defun c:cnct-ws-h (/ ss attowner prib #actdoc i)
  
  (vla-startundomark #actdoc)
  (acet-error-init (list (list	"cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (princ "\nвыберите провода\n")
  ;(setq	ss (ss:getBRefs '("wiring_провод")))
  (setq ss (ssget '(( 0 . "INSERT"))))
  (setq prib (vlax-ename->vla-object (car (entsel "\nукажите прибор\n"))))
  (setq prib (getbatt prib "CODE"))
  
  (if (null prib)
    (progn
      (alert "'\nне найден атрибут CODE в блоке")
      (exit)
      ) ;_ progn
    ) ;if

  (setq prib (strcat "%<\\AcObjProp Object(%<\\_ObjId "
		       (itoa (vla-get-objectid prib))
		       ">%).TextString>%"
		       ))


  (setq i 0)
  (repeat (sslength ss)
    (setq attowner (getbatt (vlax-ename->vla-object (ssname ss i)) "OWNER"))
    (if (null attowner)
      (progn
	(alert "'\nне найден атрибут OWNER в блоке")
	(exit)
	) ;_ progn
      ) ;if
    (vla-put-TextString attowner prib)
    ;(vla-update attowner)
    (vl-cmdf "_updatefield" (vlax-vla-object->ename attowner) "")
    (setq i (1+ i))
    ) ;repeat


  (acet-error-restore)
  (vla-endundomark #actdoc)
  ) ;defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; когда есть 2 ряда блоков - ссылок друг на друга

(defun c:cnct-ws ( / srtBrefs ss srcBName srclst destlst)
  (defun srtBrefs (lst / rule nlsto)
    (initget 1 "x -x y -y content")
    (setq rule (getkword "\n Правило сортировки : [x/-x/y/-y] <x> \n"))
    (cond
      ((= rule "x") (setq nlsto (vl-sort lst '(lambda (a b) (< (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))))))))
      ((= rule "y") (setq nlsto (vl-sort lst '(lambda (a b) (< (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))))))))
      ((= rule "-x") (setq nlsto (vl-sort lst '(lambda (a b) (> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))))))))
      ((= rule "-y") (setq nlsto (vl-sort lst '(lambda (a b) (> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))))))))
      )
    nlsto
    );defun
  (vla-startundomark #actdoc)
  (if (and
	(setq ss (ss:getBRefs '("mnt_w-MTR" "mnt_w-MJB")))
	(setq srcBName (entsel))
	)
    (progn
      (setq ss (srtBrefs ss))
      (setq srcBName (vla-get-EffectiveName (vlax-ename->vla-object (car srcBName))))
      (setq srclst (vl-remove-if-not '(lambda (b) (= srcBName (vla-get-EffectiveName b))) ss))
      (setq destlst (vl-remove-if '(lambda (b) (= srcBName (vla-get-EffectiveName b))) ss))
      (if (= (length srclst) (length destlst))
	(mapcar
	  '(lambda (s d)	;(setq s (car srclst) d (car destlst))
	     (vla-put-textstring (getbatt d "MARK") (cnct:genFieldString (getbatt s "MARK")))
	     (vla-put-textstring (getbatt d "ADDRESS") (cnct:genFieldString (getbatt s "OWNER")))
	     (vla-put-textstring (getbatt s "ADDRESS") (cnct:genFieldString (getbatt d "OWNER")))
	     )
	  srclst destlst)
	)
      )
    )
  (vl-cmdf "_updatefield" (lst-to-ss ss) "")
  (vla-endundomark #actdoc)
  );defun












;если нужна перемычка с одного клеммника на другой - делаем:
;подключаем каждый провод к своей клемме как к прибору (cnct-w-Pc)и
;делаем cnct-w-w

(defun c:cnct-w-pc (
		    /
		    aw
		    awOWNER
		    ac
		    acNUMBER
		    acCLAMP
		    )
  (setq aw (vlax-ename->vla-object (car (entsel "\nукажите провод\n")))
	awOWNER (getbatt aw "OWNER")
	ac (vlax-ename->vla-object (car (entsel "\nукажите клемму\n")))
	acNUMBER (getbatt ac "NUMBER")
	acCLAMP (getbatt ac "CLAMP")
	)
  (if (and
	aw
	awOWNER
	ac
	acNUMBER
	acCLAMP
	)
    (progn
      (vla-put-TextString awOWNER
	(strcat
	  "%<\\AcObjProp Object(%<\\_ObjId "
	  (itoa (vla-get-objectid acCLAMP))
	  ">%).TextString>%"
	  ":"
	  "%<\\AcObjProp Object(%<\\_ObjId "
	  (itoa (vla-get-objectid acNUMBER))
	  ">%).TextString>%"
	  );strcat
	)
      )
    )
  (vl-cmdf "_updatefield" (vlax-vla-object->ename aw) "")
  );defun



(defun c:cnct-destroy ( / own obj fc ids fldstr mspsids)
  (if (setq obj (nentsel))
    (progn
      (setq obj (vlax-ename->vla-object (car obj)))
      (setq fc (kd:getfieldcode obj))
      (setq mspsids (list (vla-get-ObjectID #modspace)))
      (setq ids (mapcar '(lambda (x) (atoi (car (sepstr x ">%)")))) (cdr (sepstr fc "ObjId "))))
      (if (member 0 ids) (setq ersedobjs T ids (vl-remove 0 ids)))
      (setq srcObjs (mapcar '(lambda (x) (vla-ObjectIDToObject #actdoc x)) ids))
      (mapcar
	'(lambda (o / co)	;(setq o (car srcObjs))
	   (setq co o)
	   (while (null (member (vla-get-OwnerID co) mspsids))
	     (setq co (vla-ObjectIDToObject #actdoc (vla-get-OwnerID co)))
	     )
	   (vlax-put-property co "Color" 2)
	   (vla-put-textstring o "####")
	   )
	srcObjs)
      (vla-put-textstring obj "####")
      (setq own obj)
      (while (null (member (vla-get-OwnerID co) mspsids))
	(setq own (vla-ObjectIDToObject #actdoc (vla-get-OwnerID own)))
	)
      (vlax-put-property own "Color" 2)
      )
    )
  );defun











(defun c:MJBmnt ( / XTclamp wires)
  (vla-startundomark #actdoc)
  (princ "\nSelect XT clamp : ...")
  (setq XTclamp (ss:getBRefs '("mnt_БЭЗ-XT")))
  (princ "\nSelect wires to connect : ...")
  (setq wires (ss:getBRefs '("mnt_w-MJB")))
  (mapcar
    '(lambda (w / mrk XTcl XSw pt)	;(setq w (nth 3 wires))
       (setq mrk (kd-get-textstring (getbatt w "MARK")))
       (setq XTcl
	      (vl-remove-if-not	;(setq c (nth 8 XTclamp))
		'(lambda (c)
		   (and
		     (= mrk (kd-get-textstring (getbatt c "MARK")))
		     (wcmatch (kd-get-textstring (getbatt c "ADDRESS")) "XS*")
		     )
		   )
		XTclamp)
	     )
       (if (and
	     XTcl
	     (setq XSw (car (car (kd:getFieldOwners (kd:getfieldcode (getbatt (car XTcl) "ADDRESS"))))))
	     )
	 (progn
	   (setq pt (VARIANTEXTRACTION (vla-get-InsertionPoint XSw)))
	   (setq pt (mapcar '+ pt '(0 5 0)))
	   (vla-put-InsertionPoint w (vlax-3d-point pt))
	   (setq XTclamp (vl-remove (car XTcl) XTclamp))
	   )
	 )
       )
    wires
    )
  (vla-endundomark #actdoc)
  (princ)
  );defun






;;;   для моентажных схем привода - перезаливаем марки в клеммник БЭЗа

;;	указываемклеммник

(defun c:MJB-XS->XT ( / clams)
  (vla-startundomark #actdoc)
  (setq clams (ss->lsto* (ssget '((0 . "INSERT")))))
  (mapcar
  '(lambda (cl / addr fc)
     (setq addr (getbatt cl "ADDRESS"))
     (setq fc (kd:getfieldcode addr))
     (if (and (vl-string-search "%<\\Ac" fc) (vl-string-search ">%" fc))
       (vla-put-textstring
	 (getbatt cl "MARK")
	 (kfl:IDtoFC
	   (vla-get-objectID (getbatt (vla-ObjectIDToObject #actdoc (vla-get-OwnerID (vla-ObjectIDToObject #actdoc (atoi (car (sepstr (cadr (sepstr fc "ObjId ")) ">%)")))))) "MARK"))
	   )
	 )
       )
     (vl-cmdf "_updatefield" (vlax-vla-object->ename cl) "")
     )
  clams
  )
  (vla-endundomark #actdoc)
  );defun



(defun c:MJB-XT->XS ( / XTclamp)
  (vla-startundomark #actdoc)
  (setq XTclamp (ss:getBRefs '("mnt_БЭЗ-XT")))
  (mapcar
  '(lambda (cl / addr fc wire)	;(setq cl (car XTclamp))
     (setq addr (getbatt cl "ADDRESS"))
     (setq fc (kd:getfieldcode addr))
     (if
       (and
	 (vl-string-search "%<\\Ac" fc)
	 (vl-string-search ">%" fc)
	 (setq wire (kd:getFieldOwners fc))
	 (= 1 (length wire))
	 (setq wire (car (car wire)))
	 )
       (progn
	 (vla-put-textstring (getbatt wire "MARK") (cnct:genFieldString (getbatt cl "MARK")))
	 (vl-cmdf "_updatefield" (vlax-vla-object->ename wire) "")
	 )
       )
     )
  XTclamp)
  (vla-endundomark #actdoc)
  );defun