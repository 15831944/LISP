;; 14_04_15.3
;; 14_06_03 изменил (унифицировал) названия полей
;; 15_09_04
;; 15_12_16
;; 16_03_28
(vl-load-com)
(setq #cad (vlax-get-acad-object)
      #actdoc (vla-get-activedocument #cad)
      #modspace (vla-get-modelspace #actdoc))

(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))

(setq #FormatLayerName "com_formats")


;(setq #FormatBlockName "format")
;(setq #FormatBlockName-spec "format-spec")
(setq #FormatBlockName "RU_format")
(setq #FormatBlockName-spec "RU_format-spec")




;(setq #blockformatpath "\\\\srv-energo\\acad\\\\!_Стандарт\\Blocks\\format.dwg")
;(setq #blockformatpath "\\\\srv-energo\\acad\\\\!_Стандарт\\Blocks\\formatJaroslavl.dwg")
;(setq #blockformatpath (strcat #lisppath "!blocking\\formatJaroslavl.dwg"))

(setq #blockformatpath (strcat #lisppath "!blocking\\" #FormatBlockName ".dwg"))
(setq #blockformatpath-spec (strcat #lisppath "!blocking\\" #FormatBlockName-spec ".dwg"))

(setq
  #AttsNameList
   '("PROJECT_NUMBER"
     "PROJECT_CONTRACTNAME1"
     "PROJECT_CONTRACTNAME2"
     "PROJECT_CONTRACTNAME3"
     "PROJECT_NAME1"
     "PROJECT_NAME2"
     "PROJECT_NAME3"
     ))

(setq #DrwNumberTag "DRAWING_NUMBER")
(setq #DrwShQty "DRAWING_SHEETQUANTITY")
(setq #AttsDrwNamesList '("DRAWING_NAME1" "DRAWING_NAME2" "DRAWING_NAME3"))

(if (= "RU_format" #FormatBlockName) (setq #ShtNumberTag "SHEET_NUMBER"))





(defun c:PRJ:AddDrw ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T));acet-error-init
  (AddDrw (getpoint))
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
(defun c:PRJ:AddSht ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T));acet-error-init
  (AddSht (getpoint))
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun AddDrw (pt / blk attfn)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun prj|InsertBlock (ptvar path scX scY scZ ang / blk)
    (cond
      ((= 1 (vla-get-ActiveSpace #actdoc))
       (setq blk (vla-InsertBlock #modspace ptvar path scX scY scZ ang)))
      ((= 0 (vla-get-ActiveSpace #actdoc))
       (setq blk (vla-InsertBlock (vla-get-Block (vla-get-ActiveLayout #actdoc)) ptvar path scX scY scZ ang)))
      (T (alert "Wrong space") (exit)))
    blk
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun sht|UpdateFormatName (blk / attfn)
    (setq attfn (getbatt blk "FORMATNAME"))
    (vla-put-Textstring attfn (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID blk)) ">%).Parameter(31).lookupString>%"))
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (if (and
	pt
	(if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list (vla-get-Blocks #actdoc) #FormatBlockName)))
	  (setq blk (prj|insertblock (vlax-3d-point pt) #blockformatpath 1 1 1 0))
	  (setq blk (prj|insertblock (vlax-3d-point pt) #FormatBlockName 1 1 1 0))
	  )
	)
    (progn
      (if (not (tblobjname "layer" #FormatLayerName)) (command "_.-layer" "_new" #FormatLayerName "_color" "250" #FormatLayerName ""))
      (vla-put-layer blk #FormatLayerName)
      (sht|updateformatname blk)
      (PRJ|dateUpdate blk)
      (prj|init)
      (prj|LinkSheet blk)
      (vl-cmdf "_updatefield" (vlax-vla-object->ename blk) "")
      )
    )
  blk
  );defun




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun AddSht ( pt / blk attfn sht|updateformatname )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun prj|insertblock (ptvar path scX scY scZ ang / blk)
    (cond
      ((= 1 (vla-get-ActiveSpace #actdoc))
       (setq blk (vla-InsertBlock #modspace ptvar path scX scY scZ ang)))
      ((= 0 (vla-get-ActiveSpace #actdoc))
       (setq blk (vla-InsertBlock (vla-get-Block (vla-get-ActiveLayout #actdoc)) ptvar path scX scY scZ ang)))
      (T (alert "Wrong space") (exit)))
    blk
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun sht|updateformatname (blk / attfn)
    (setq attfn (getbatt blk "FORMATNAME"))
    (vla-put-Textstring attfn (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID blk)) ">%).Parameter(15).lookupString>%"))
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (if (and
	pt
	(if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list (vla-get-Blocks #actdoc) #FormatBlockName-spec)))
	  (setq blk (prj|insertblock (vlax-3d-point pt) #blockformatpath-spec 1 1 1 0))
	  (setq blk (prj|insertblock (vlax-3d-point pt) #FormatBlockName-spec 1 1 1 0))
	  )
	)
    (progn
      (if (not (tblobjname "layer" #FormatLayerName)) (command "_.-layer" "_new" #FormatLayerName "_color" "250" #FormatLayerName ""))
      (vla-put-layer blk #FormatLayerName)
      (sht|updateformatname blk)
      (prj|init)
      (prj|LinkSheet blk)
      (vl-cmdf "_updatefield" (vlax-vla-object->ename blk) "")
      )
    )
  blk
  );defun


(defun c:PRJ:EditAtts ( / ss props)
  (prj|init)
  (setq props (sui|getcustomprops))
  (setq props (sui|dcledittab props))
  (mapcar '(lambda (p) (sui|addcustomprop (car p) (cadr p))) props)
  (if (and (setq ss (ssget "_X" '((0 . "INSERT"))))
	   (setq ss (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (list #FormatBlockName #FormatBlockName-spec))) (ss->lsto* ss))))
    (progn (mapcar 'prj|LinkSheet ss) (setq ss (lst-to-ss ss)) (vl-cmdf "_updatefield" ss ""))
    )
  );defun



(defun prj|init ( / props)
  (setq props (sui|GetCustomProps))
  (cond
    ((null props)
     (setq props (sui|dcledittab (mapcar '(lambda (x) (list x "")) #AttsNameList)))
     (mapcar '(lambda (p) (sui|AddCustomProp (car p) (cadr p))) props))
    ((equal #AttsNameList (mapcar 'car props)) (princ))
    (T
     (sui|RemoveThisProps #AttsNameList)
     (mapcar '(lambda (p) (sui|AddCustomProp (car p) (cadr p))) (mapcar '(lambda (pr / ass) (if (setq ass (assoc pr props)) ass (list pr ""))) #AttsNameList))
     )
    )
  );defun


(defun sui|GetCustomProps ( / sui quant lst paramname paramval)
  (setq sui (vla-get-SummaryInfo #actdoc))
  (setq quant (vla-NumCustomInfo sui))
  (while (>= (setq quant (1- quant)) 0)
    (vla-GetCustomByIndex sui quant 'paramname 'paramval)
    (setq lst (append lst (list (list paramname paramval))))
    )
  (reverse lst)
  );defun


(defun sui|RemoveThisProps (lst / props sui quant)
  (setq sui (vla-get-SummaryInfo #actdoc))
  (setq quant (vla-NumCustomInfo sui))
  (setq props (mapcar 'car (sui|getcustomprops)))
  (mapcar '(lambda (pr) (if (member pr props) (vla-RemoveCustomByKey sui pr))) lst)
  );defun




(defun sui|AddCustomProp (pn pv / sui quant lst n)
  (setq sui (vla-get-SummaryInfo #actdoc))
  (setq quant (vla-NumCustomInfo sui))
  (setq lst (sui|getcustomprops))
  (if (and lst (assoc pn lst))
    (progn (vla-SetCustomByKey sui pn pv) (princ (strcat "\nProperty { " pn " } has changed to " pv)))
    (progn (vla-AddCustomInfo sui pn pv) (princ (strcat "\nProperty { " pn " } has added as " pv)))
    )
  );defun


;;  вписываем в блок поля из свойств чертежа
(defun c:prj:LinkSheet ( / blk)
  (if (setq blk (entsel))
    (prj|LinkSheet (vlax-ename->vla-object (car blk)))
    )
  )

(defun c:prj:LinkSheet-ss ( / lst)
  (if (setq lst (ssget "_I"))
    (progn
      (setq lst (ss->lsto* lst))
      (mapcar 'prj|LinkSheet lst)
      )
    )
  )

;	(setq blk (vlax-ename->vla-object (car (entsel))))
(defun prj|LinkSheet (blk / custprops atts)
  (if (member (vla-get-EffectiveName blk) (list #FormatBlockName #FormatBlockName-spec "RU_format-content"))
    (progn
      (setq atts (vlax-safearray->list (vlax-variant-value (vla-GetAttributes blk))))
      (setq custprops (sui|getcustomprops))
      (mapcar
	'(lambda (prop)	;(setq prop (nth 0 #AttsNameList))
	   (if (member prop (mapcar 'vla-get-TagString atts))
	     (if (/= "" (cadr (assoc prop custprops)))
	       (vla-put-TextString (getbatt blk prop) (strcat "%<\\AcVar CustomDP." prop ">%"))
	       (vla-put-TextString (getbatt blk prop) "")
	       )
	     )
	   )
	#AttsNameList
	)
      (vl-cmdf "_updatefield" (vlax-vla-object->ename blk) "")
      )
    )
  );defun



;(setq data (sui|getcustomprops))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sui|dcledittab (data / names props dlgname dclfilename
		      dcl-file-path hand dcl_id i lst kd:dcledittab_done)
  (setq names (mapcar 'car data)) (setq props (mapcar 'cadr data))
  (setq props
  (mapcar
    '(lambda (x / val tail)
       (if (vl-string-search "\"" x)
	 (progn
	   (setq val (reverse (sepstr x "\"")))
	   (setq tail (car val))
	   (setq val (mapcar '(lambda (s) (strcat s "\\\"")) (reverse (cdr val))))
	   (setq val (strcat (apply 'strcat val) tail))
	   ) x )) props))
  
  (setq props
  (mapcar
    '(lambda (x)	;(setq x (car props))
       (if (vl-string-search "\n" x)
	 (vl-string-subst "\\\\P" "\n" x)
	 x
	 )
       )
    props)
	)
  
  (setq dlgname "kd_dcledittab")
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  (defun kd:dcledittab_done ( / lst i val)
    (setq lst '() i 0)
    (repeat (length props)
      (setq val (get_tile (strcat "key" (itoa i))))
      (while (vl-string-search "\\P" val) (setq val (vl-string-subst "\n" "\\P" val)))
      (setq lst (append lst (list val)))
      (setq i (1+ i))
      )
    (done_dialog)
    lst
    );defun
  (setq dcl-file-path (strcat (getenv "temp") dclfilename) hand (open dcl-file-path "w"))
  (mapcar '(lambda (x) (write-line x hand)) (list dlgname ": dialog" "{label=\"kakt00z dcltab edit window\";"))
  (setq i 0)
  (repeat (length props)
    (write-line (strcat
		  ":edit_box"
		  "{"
		  	"label=\"" (nth i names) "\";"
		  	"value=\"" (nth i props) "\";"
		  	"key=\"" (strcat "key" (itoa i)) "\";"
		  	"edit_width=40;"
		  	"allow_accept=true;"
		  	(if (= i 0) "active=true;" "")
		  "}")
      hand)
    (setq i (1+ i))
    );repeat
  (mapcar '(lambda (x) (write-line x hand)) '( ":spacer{width=1;}" "ok_cancel;" "}"))
  (close hand)
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0) (not (new_dialog dlgname dcl_id))) (exit)) ;if
  (action_tile "accept"		"(setq lst (kd:dcledittab_done))")
  (start_dialog)
  (unload_dialog dcl_id)
  (mapcar 'list names lst)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;  вписываем в чертеж поля из блока
(defun c:sui|import ( / blk) (sui|resetfromformat))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sui|resetfromformat (/ obj sui quant paramname paramval lst)
  ;#AttsNameList
  (if
    (and
      (setq obj (entsel))
      (setq obj (vlax-ename->vla-object (car obj)))
      (= "AcDbBlockReference" (vla-get-objectname obj))
      (= #FormatBlockName (vla-get-EffectiveName obj))
      )
    (progn
      (mapcar
	'(lambda (an / str)	;(setq an (nth 1 #AttsNameList))
	   (setq str (vla-get-TextString (getbatt obj an)))
	   (if (vl-string-search "\P" str)
	     (setq str (vl-string-subst "\n" "\\P" str))
	     )
	   (sui|addcustomprop an str)
	   )
	#AttsNameList
	)
      )
    )
  (princ)
  );progn
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






(defun c:prj:NumberSheets ( / drawings FirstSheetNumber)
  (setq drawings (ss:SelectCurrentProjectDrawings))
  (if (and
	#ShtNumberTag
	(setq FirstSheetNumber (car (kd:dclget '("Номер первого листа :"))))
	)
    (progn
      (setq FirstSheetNumber (1- (atoi FirstSheetNumber)))
      (mapcar
	'(lambda (drw)
	   (vla-put-TextString
	     (getbatt drw #ShtNumberTag)
	     (setq FirstSheetNumber (1+ FirstSheetNumber))
	     )
	   )
	(apply 'append (mapcar 'cdr drawings))
	)
      )
    )
  );defun





(defun c:prj:PasteContent () (vect:PasteProjectContent (prj:GenerateProjectContentForProject)))
(defun c:prj:PasteContent-CNT () (vect:PasteProjectContent (prj:GenerateProjectContentForContent)))





(defun checkSheetNumbers (prjcontent / i message)
  (setq i 0 message '())
  (if (/= (atoi (vla-get-textstring (getbatt (cadr (car prjcontent)) #DrwShQty))) (car (last prjcontent)))
    (setq message (cons (strcat (itoa (setq i (1+ i))) ". Не совпадает общее количество листов в проекте.\n") message))
    )

  
  (mapcar
    '(lambda (drw)
       (if
	 (and
	   (/= "" (vla-get-textstring (getbatt (cadr drw) #DrwShQty)))
	   (/= 1 (car drw))
	   )
	 (setq message (cons (strcat (itoa (setq i (1+ i))) ". Не верно указано общее количество листов в л. " (vla-get-textstring (getbatt (cadr drw) #DrwNumberTag)) ".\n") message)))
       )
    (vl-remove-if '(lambda (drw) (> (length drw) 2)) prjcontent)
    )

  
  (mapcar
    '(lambda (drw / mainSheet sheets shtsquant lastNumber)	;(setq drw (car (vl-remove-if '(lambda (drw) (< (length drw) 3)) prjcontent)))
       (setq mainSheet (vl-remove-if '(lambda (item) (or (= (type item) 'INT) (/= (vla-get-EffectiveName item) #FormatBlockName))) drw))
       (if (= 1 (length mainSheet)) (setq mainSheet (car mainSheet)))
       (setq sheets (vl-remove mainSheet (cdr drw)))
       (setq sheets (vl-sort sheets '(lambda (a b)
				       (<		;(setq a (vlax-ename->vla-object (car (entsel))))
					 (atoi (cadr (sepstr (vla-get-TextString (getbatt a #DrwNumberTag)) ".")))
					 (atoi (cadr (sepstr (vla-get-TextString (getbatt b #DrwNumberTag)) ".")))
					 )
				       )))
       (setq shtsquant (vla-get-textstring (getbatt mainSheet #DrwShQty)))
       (setq lastNumber (sepstr (vla-get-textstring (getbatt (last sheets) #DrwNumberTag)) "."))
       (if (/= shtsquant (cadr lastNumber))
	 (setq message (cons (strcat (itoa (setq i (1+ i))) ". Не верно указано общее количество листов в л. "
				     (vla-get-textstring (getbatt (cadr drw) #DrwNumberTag)) ".\n") message))
	 )
       )
    (vl-remove-if '(lambda (drw) (< (length drw) 3)) prjcontent)
    )
  
  (if message
    (progn
      (defun tbl|addmtext (str pt wdth alp / txtobj)
	(setq txtobj (vla-AddMtext #modspace (vlax-3d-point pt) wdth str))
	(vla-put-AttachmentPoint txtobj alp)
	(vla-put-LineSpacingStyle txtobj acLineSpacingStyleExactly)
	(vla-put-Height txtobj 2.5)
	(vla-put-LineSpacingDistance txtobj 8)
	txtobj
	)
      (alert (apply 'strcat (reverse message)))
      (tbl|addmtext (apply 'strcat (reverse message)) (getpoint) 60 1)
      )
    )
  );defun


(defun ss:SelectCurrentProjectDrawings (/ drawings prjcontent)
  (alert "Select drawing for current project")
  (if (null (setq drawings (ssget "_I" (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," #FormatBlockName-spec "," "`*U*"))))))
    (setq drawings (ssget (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," #FormatBlockName-spec "," "`*U*"))))))
  (setq drawings (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (list #FormatBlockName #FormatBlockName-spec))) (ss->lsto* drawings)))
  (setq drawings (vl-remove-if '(lambda (x) (wcmatch (kd-get-textstring (getbatt x "PROJECT_NUMBER")) "*.C*,*.С*")) drawings))
  (setq drawings (vl-sort drawings '(lambda (a b) (< (atoi (vla-get-textstring (getbatt a #DrwNumberTag))) (atoi (vla-get-textstring (getbatt b #DrwNumberTag)))))))
  (setq prjcontent (ziplist (mapcar '(lambda (d) (list (atoi (car (sepstr (vla-get-TextString (getbatt d #DrwNumberTag)) "."))) d)) drawings)))
  (checkSheetNumbers prjcontent)
  prjcontent
  );defun


(defun prj:GenerateProjectContentForProject ( / prjcontent textlist)
  (setq prjcontent (ss:SelectCurrentProjectDrawings))
  (setq textlist
  (mapcar
    '(lambda (drw)
       (cond
	 ((= 2 (length drw))
	  (list
	    (itoa (car drw))
	    (vl-string-trim " " (antisep (mapcar '(lambda (nt) (vla-get-textstring (getbatt (cadr drw) nt))) #AttsDrwNamesList) " "))
	    ))
	 (T
	  (list
	    (strcat
	      (itoa (car drw))
	      ".1..."
	      (itoa (car drw))
	      "."
	      (itoa (1- (length drw)))
	      )
	    (vl-string-trim " "
	      (antisep
		(mapcar
		  '(lambda (nt)
		     (vla-get-textstring
		       (getbatt
			 (car (vl-remove-if-not '(lambda (dw) (getbattswcmatch dw
								(strcat "*" (strcut (car #AttsDrwNamesList) 0 -1) "*")
								)) (cdr drw)))

			 ;(cadr drw)
			 nt))
		     )
		  #AttsDrwNamesList)
		" ")
	      )
	    ))
	 )
       )
    prjcontent
    ))
  textlist
  );defun


(defun prj:GenerateProjectContentForContent ( / prjcontent textlist shtnums)
  (setq prjcontent (ss:SelectCurrentProjectDrawings))
  (setq textlist
  (mapcar
    '(lambda (drw)	;(setq drw (nth 4 prjcontent))
       (cond
	 ((= 2 (length drw))
	  (list
	    (strcat "л. " (itoa (car drw)))
	    (vl-string-trim " " (antisep (mapcar '(lambda (nt) (vla-get-textstring (getbatt (cadr drw) nt))) #AttsDrwNamesList) " "))
	    (strcat "л. " (vla-get-textstring (getbatt (cadr drw) #ShtNumberTag)))
	    ))
	 
	 (T
	  (setq shtnums (mapcar 'itoa (vl-sort (mapcar '(lambda (d) (atoi (vla-get-textstring (getbatt d #ShtNumberTag))) ) (cdr drw))'<)))
	  (list
	    (strcat
	      "лл. " (itoa (car drw)) ".1"
	      (cond ((= 2 (length shtnums))", ") ((< 2 (length shtnums))"..."))
	      (itoa (car drw)) "."(itoa (1- (length drw))))
	    (vl-string-trim " "
	      (antisep
		(mapcar
		  '(lambda (nt)
		     (vla-get-textstring
		       (getbatt
			 (car (vl-remove-if-not '(lambda (dw) (getbattswcmatch dw
								(strcat "*" (strcut (car #AttsDrwNamesList) 0 -1) "*")
								)) (cdr drw)))

			 ;(cadr drw)
			 nt))
		     )
		  #AttsDrwNamesList)
		" ")
	      )
	    (strcat "лл. " (car shtnums)
		    (cond ((= 2 (length shtnums))", ") ((< 2 (length shtnums))"..."))
		    (last shtnums))
	    );list
	  )
	 )
       )
    prjcontent
    ))
  textlist
  );defun








(defun vect:PasteProjectContent (lst / tbl|addtext tbl|addmtext bpt)
  (defun tbl|addtext (str pt / txtobj)
    (setq txtobj (vla-Addtext #modspace str (vlax-3d-point '(0 0 0)) 2.5))
    (vla-put-Alignment txtobj 10)
    (vla-put-TextAlignmentPoint txtobj (vlax-3d-point pt))
    txtobj
    );defun
  (defun tbl|addmtext (str pt wdth alp / txtobj)
    (setq txtobj (vla-AddMtext #modspace (vlax-3d-point pt) wdth str))
    (vla-put-AttachmentPoint txtobj alp)
    (vla-put-LineSpacingStyle txtobj acLineSpacingStyleExactly)
    (vla-put-Height txtobj 2.5)
    (vla-put-LineSpacingDistance txtobj 8)
    txtobj
    );defun
  (setq bpt (getpoint "\n....Pick an upper left coner of fill area of the table"))

  
  (cond
    ((= 2 (length (car lst)))
     (mapcar
       '(lambda (line / mtxtobj)
	  (tbl|addtext (car line) (mapcar '+ bpt '(7.5 -4 0)))
	  (setq mtxtobj (tbl|addmtext (cadr line) (mapcar '+ bpt '(17 -3 0)) 137 1 ))
	  (setq bpt (mapcar '+ bpt (list 0 (* -8 (mtxt:getnumberoflines mtxtobj)) 0)))
	  )
       lst)
     )
    ((= 3 (length (car lst)))
     (mapcar
       '(lambda (line / mtxtobj)
	  (tbl|addmtext (car line) (mapcar '+ bpt '(32 -3 0)) 25 3)
	  (tbl|addmtext (caddr line) (mapcar '+ bpt '(156 -3 0)) 28 1)
	  (setq mtxtobj (tbl|addmtext
			 ; (strcat "{\\W0.9;\\T0.9;"
				  (cadr line)
			;	  "}")
			  (mapcar '+ bpt '(62 -3 0)) 92 1))
	  (setq bpt (mapcar '+ bpt (list 0 (* -8 (mtxt:getnumberoflines mtxtobj)) 0)))
	  )
       lst)
     )
    )
  (princ)
  );defun







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:PRJ:InsertDrw () (PRJ|insert-drawing-in-project))
(defun PRJ|insert-drawing-in-project ( / drawings prjcontent drwobj prjnum drwnum tochange)
  (princ "\n Select all the Drawings of the project")
  (if (null (setq drawings (ssget "_I" (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," #FormatBlockName-spec "," "`*U*"))))))
    (setq drawings (ssget (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," #FormatBlockName-spec "," "`*U*"))))))
  ;(sslength drawings)
  (setq drawings (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (list #FormatBlockName #FormatBlockName-spec)))(ss->lsto* drawings)))
  ;(length drawings)
  ;(sssetfirst nil (lst-to-ss drawings))

  
  (setq drwobj (vlax-ename->vla-object (car (entsel))))
  (setq prjnum (kd-get-textstring (getbatt drwobj "PROJECT_NUMBER")))
  (setq drwnum (sepstr (kd-get-textstring (getbatt drwobj #DrwNumberTag)) "."))
  (setq drawings (vl-remove drwobj drawings))
  (setq drawings (vl-remove-if '(lambda (b) (/= (kd-get-textstring (getbatt b "PROJECT_NUMBER")) prjnum)) drawings))
  (setq prjcontent (ziplist (mapcar '(lambda (d) (list (atoi (car (sepstr (vla-get-TextString (getbatt d #DrwNumberTag)) "."))) d))drawings)))

  (cond
    ((= 1 (length drwnum))
     (setq tochange (vl-remove-if '(lambda (pci) (< (car pci) (atoi (car drwnum)))) prjcontent))
     (mapcar
       '(lambda (dw / tmpa)
	  (cond
	    ((= 1 (length (cdr dw)))
	     (setq tmpa (getbatt (cadr dw) #DrwNumberTag))
	     (vla-put-TextString tmpa (itoa (1+ (car dw))))
	     )
	    ((> (length (cdr dw)) 1)
	    (mapcar
	      '(lambda (l / tmpl)
		 (setq tmpl (getbatt l #DrwNumberTag))
		 (vla-put-TextString tmpl (antisep (list (itoa (1+ (car dw))) (cadr (sepstr (vla-get-TextString tmpl) "."))) "."))
		 )
	      (cdr dw)
	      )
	     )
	    )
	  )
       tochange)
     )

    ((= 2 (length drwnum))
     (setq tochange (vl-remove-if '(lambda (pci) (/= (atoi (car drwnum)) (car pci)))prjcontent))
     (setq tochange (vl-remove-if '(lambda (l) (< (atoi (cadr (sepstr (vla-get-TextString (getbatt l #DrwNumberTag)) "."))) (atoi (cadr drwnum))))(cdr (car tochange))))

     (mapcar
       '(lambda (l / tmpl strl)
	  (setq tmpl (getbatt l #DrwNumberTag))
	  (setq strl (sepstr (vla-get-TextString tmpl) "."))
	  (vla-put-TextString tmpl (antisep (list (car strl) (itoa (1+ (atoi (cadr strl))))) "."))
	  )
       tochange
       )
     )
    );cond
  ;  устанавливаем общее куоличество листов
  (cond
    ((= 2 (length (assoc 1 prjcontent)))
     (vla-put-TextString
       (getbatt (cadr (assoc 1 prjcontent)) #DrwShQty)
       (itoa (1+ (length prjcontent)))
       )
     )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:PRJ:RemoveDrw () (PRJ|remove-drawing-from-project))
(defun PRJ|remove-drawing-from-project ( / drawings prjcontent drwobj prjnum drwnum tochange)
  (princ "\n Select all the Drawings of the project")
  (if (null (setq drawings (ssget "_I" (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," #FormatBlockName-spec "," "`*U*"))))))
    (setq drawings (ssget (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," #FormatBlockName-spec "," "`*U*"))))))
  ;(sslength drawings)
  (setq drawings (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (list #FormatBlockName #FormatBlockName-spec)))(ss->lsto* drawings)))
  ;(length drawings)
  ;(sssetfirst nil (lst-to-ss drawings))

  
  (setq drwobj (vlax-ename->vla-object (car (entsel))))
  (setq prjnum (kd-get-textstring (getbatt drwobj "PROJECT_NUMBER")))
  (setq drwnum (sepstr (kd-get-textstring (getbatt drwobj #DrwNumberTag)) "."))
  (setq drawings (vl-remove drwobj drawings))
  
  (setq drawings (vl-remove-if '(lambda (b) (/= (kd-get-textstring (getbatt b "PROJECT_NUMBER")) prjnum)) drawings))
  (setq prjcontent (ziplist (mapcar '(lambda (d) (list (atoi (car (sepstr (vla-get-TextString (getbatt d #DrwNumberTag)) "."))) d))drawings)))


  
  (cond
    ((= 1 (length drwnum))
     (setq tochange (vl-remove-if '(lambda (pci) (< (car pci) (atoi (car drwnum)))) prjcontent))

     
     (mapcar
       '(lambda (dw / tmpa)	;(setq dw (car tochange))
	  (cond
	    ((= 1 (length (cdr dw)))
	     (setq tmpa (getbatt (cadr dw) #DrwNumberTag))
	     (vla-put-TextString tmpa (itoa (1- (car dw))))
	     )
	    ((> (length (cdr dw)) 1)
	     (mapcar
	       '(lambda (l / tmpl)
		  (setq tmpl (getbatt l #DrwNumberTag))
		  (vla-put-TextString tmpl (antisep
					     (list
					       (itoa (1- (car dw)))
					       (cadr (sepstr (vla-get-TextString tmpl) ".")))
					     "."))
		  )
	       (cdr dw)
	       )
	     )
	    )
	  )
       tochange)




     
     )

    ((= 2 (length drwnum))
     (setq tochange (vl-remove-if '(lambda (pci) (/= (atoi (car drwnum)) (car pci)))prjcontent))
     (setq tochange (vl-remove-if '(lambda (l) (< (atoi (cadr (sepstr (vla-get-TextString (getbatt l #DrwNumberTag)) "."))) (atoi (cadr drwnum))))(cdr (car tochange))))

     (mapcar
       '(lambda (l / tmpl strl)
	  (setq tmpl (getbatt l #DrwNumberTag))
	  (setq strl (sepstr (vla-get-TextString tmpl) "."))
	  (vla-put-TextString tmpl (antisep (list (car strl) (itoa (1- (atoi (cadr strl))))) "."))
	  )
       tochange
       )
     )
    );cond
  ;  устанавливаем общее куоличество листов
  (cond
    ((= 2 (length (assoc 1 prjcontent)))
     (vla-put-TextString
       (getbatt (cadr (assoc 1 prjcontent)) #DrwShQty)
       (itoa  (length prjcontent))
       )
     )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
















(defun c:PRJ:LinkSheetsToDrawing () (PRJ|lstd))

(defun PRJ|lstd ( / drwobj sheets drwnum i)
  (princ "\nSelect sheets...")
  (if (null (setq sheets (ssget "_I" (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName-spec "," "`*U*"))))))
    (setq sheets (ssget (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName-spec "," "`*U*"))))))
  (setq sheets (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (list #FormatBlockName-spec)))(ss->lsto sheets)))
  (setq drwobj (vlax-ename->vla-object (car (entsel "Select first sheet..."))))
  (setq drwnum (car (sepstr (kd-get-textstring (getbatt drwobj #DrwNumberTag)) ".")))
  (vla-put-textstring (getbatt drwobj #DrwNumberTag) (strcat drwnum ".1"))
  (vla-put-textstring (getbatt drwobj #DrwShQty) (itoa (1+ (length sheets))))
  (setq i 1)
  (mapcar '(lambda (sht) (vla-put-textstring (getbatt sht #DrwNumberTag) (strcat drwnum "." (itoa (setq i (1+ i)))))) sheets)
  (princ)
  );defun



(defun c:PRJ:DateFreeze ( / drawings)
  (if (null (setq drawings (ssget "_I" (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," "`*U*"))))))
    (setq drawings (ssget (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," "`*U*"))))))
  (setq drawings (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (list #FormatBlockName))) (ss->lsto* drawings)))
  (mapcar
    '(lambda (drw / atts)	;(setq drw (nth 3 drawings))
       (setq atts (getbattswcmatch drw "DATE*"))
       (mapcar
	 '(lambda (att / str)	;(setq att (nth 2 atts))
	    (setq str (kd-get-TextString att))
	    (vla-put-textstring att "#delete-field#tempstring#")
	    (vlax-put-property att "TextString" str)
	    )
	 atts
	 )
       (princ)
       )
    drawings
    )
  );defun


(defun c:PRJ:DateReset ( / drawings)
  (if (null (setq drawings (ssget "_I" (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," "`*U*"))))))
    (setq drawings (ssget (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," "`*U*"))))))
  (setq drawings (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (list #FormatBlockName))) (ss->lsto* drawings)))
  (mapcar 'PRJ|dateUpdate drawings)
  );defun


(defun PRJ|dateUpdate (blk / atts)
    ;(setq blk (vlax-ename->vla-object (car (entsel))))
    ;(setq atts (getbattswcmatch blk "ДАТА*"))
    (setq atts (getbattswcmatch blk "DATE*"))
    (mapcar
      '(lambda (att / n)	;(setq att (nth 2 atts))
	 (setq n (cadr (sepstr* (vla-get-tagstring att))))
	 (cond
	   ((and
	      (= "" (vla-get-textstring (getbatt blk (strcat "POST" n))))
	      (= "" (vla-get-textstring (getbatt blk (strcat "NAME" n))))
	      )
	    (vla-put-Textstring att "")
	    )
	   ((and
	      (/= "" (vla-get-textstring (getbatt blk (strcat "POST" n))))
	      (/= "" (vla-get-textstring (getbatt blk (strcat "NAME" n))))
	      )
	    (if (= "RU_format" #FormatBlockName)
	      (vla-put-Textstring att "%<\\AcVar Date \\f \"dd.MM.yy\">%")
	      (vla-put-Textstring att "%<\\AcVar Date \\f \"MM.yy\">%")
	      )
	    )
	   )
	 )
      atts
      )
    );defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun c:PRJ:DateSet ( / drawings date)
  (if (null (setq drawings (ssget "_I" (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," "`*U*"))))))
    (setq drawings (ssget (list '(0 . "INSERT") (cons 2 (strcat #FormatBlockName "," "`*U*"))))))
  (setq drawings (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (list #FormatBlockName))) (ss->lsto* drawings)))
  (setq date (car (kd:dclget '("Установить дату: "))))
  (mapcar '(lambda (d) (DRW|DateSet d date)) drawings)
  );defun

(defun DRW|DateSet (blk date / atts)
    ;(setq blk (vlax-ename->vla-object (car (entsel))))
    ;(setq atts (getbattswcmatch blk "ДАТА*"))
    (setq atts (getbattswcmatch blk "DATE*"))
    (mapcar
      '(lambda (att / n)	;(setq att (nth 2 atts))
	 (setq n (cadr (sepstr* (vla-get-tagstring att))))
	 (cond
	   ((and
	      (= "" (vla-get-textstring (getbatt blk (strcat "POST" n))))
	      (= "" (vla-get-textstring (getbatt blk (strcat "NAME" n))))
	      )
	    (vla-put-Textstring att "")
	    )
	   ((and
	      (/= "" (vla-get-textstring (getbatt blk (strcat "POST" n))))
	      (/= "" (vla-get-textstring (getbatt blk (strcat "NAME" n))))
	      )
	    (vla-put-Textstring att date)
	    )
	   )
	 )
      atts
      )
    );defun





;EOF