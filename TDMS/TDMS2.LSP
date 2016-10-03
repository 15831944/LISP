;; 15_08_07

(load (strcat #lisppath "math\\math-fix.lsp"))
(load (strcat #lisppath "DataBase\\dblib.lsp"))



;;;    !!!!   СДАВАТЬ в таком порядке :
;;;		1 задания заводу
;;;		2 основной узел
;;;		3 спецификации


;;   DWG PARAMETERS

;;;(setq	OLD
;;;  BLK:BlocksName '("format-spec" "format" "РФ_format-spec" "РФ_format")
;;;  TAG:ProjectNumber "НОМЕР_УЗЛА"
;;;  TAG:ContractName '("ОБЪЕКТ1" "ОБЪЕКТ2" "ОБЪЕКТ3")
;;;  TAG:ProjectName '("УЗЕЛ1" "УЗЕЛ2" "УЗЕЛ3")
;;;  TAG:DrawingName '("ЧЕРТЕЖ1" "ЧЕРТЕЖ2" "ЧЕРТЕЖ3")
;;;  TAG:DRWNumber "НОМЕР_ЛИСТА"
;;;  TAG:SheetQuantity "КОЛИЧ_ЛИСТОВ"
;;;  TAG:FormatName "FORMAT_NAME"
;;;  )


; из addformat.lsp
;(setq #FormatBlockName "format")
;(setq #FormatBlockName-spec "format-spec")
;(setq #FormatBlockName "RU_format")
;(setq #FormatBlockName-spec "RU_format-spec")

(setq
  ;BLK:BlocksNames '("format-spec" "format")
  BLK:BlocksNames (list #FormatBlockName #FormatBlockName-spec)
  TAG:ProjectNumber "PROJECT_NUMBER"
  TAG:ContractName '("PROJECT_CONTRACTNAME1" "PROJECT_CONTRACTNAME2" "PROJECT_CONTRACTNAME3")
  TAG:ProjectName '("PROJECT_NAME1" "PROJECT_NAME2" "PROJECT_NAME3")
  TAG:DrawingName '("DRAWING_NAME1" "DRAWING_NAME2" "DRAWING_NAME3")
  TAG:DRWNumber "DRAWING_NUMBER"
  TAG:SheetQuantity "DRAWING_SHEETQUANTITY"
  TAG:FormatName "FORMATNAME"
  )







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  interface
;; 
(setq #prj:params
   '(
     "datatype"
     "handle"
     "project_number"
     
     "project_contractname"
     "project_name"
     "drawing_name"
     
     "drawing_number"
     "sheet_number"
     "drawing_sheetquantity"
     
     "formatname"
     "sheet_orient"
     "scale"
     "format_layout"
     "bottomleftpoint"
     "toprightpoint"
     )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(prj|getdrwparamsfromblock bobj)
;(prj|getdrwparamsfromblock (vlax-ename->vla-object (car (entsel))))





(defun prj|getdrwparamsfromblock (bobj / drwnum shtnum shtq formatsizename ori lbpt rtpt)
  ;(setq bobj (vlax-ename->vla-object (car (entsel))))
  (vla-GetBoundingBox bobj 'lbpt 'rtpt)
  (setq lbpt (vlax-safearray->list lbpt))
  (setq rtpt (vlax-safearray->list rtpt))

  (setq formatsizename (vla-get-TextString (getbatt bobj TAG:FormatName)))
  (cond
    ((= 192 (car (vl-string->list formatsizename)))
     (setq ori "w" formatsizename (strcat "w-" "A" (vl-list->string (cdr (vl-string->list formatsizename))))))
    ((= 65 (car (vl-string->list formatsizename)))
     (setq ori "v" formatsizename (strcat "v-" "A" (vl-list->string (cdr (vl-string->list formatsizename))))))
    (T "error")
    )
  (setq drwnum (vla-get-TextString (getbatt bobj TAG:DRWNumber)))
  
  (cond
    ((wcmatch (vla-get-EffectiveName bobj) "*spec*")
     (if (wcmatch drwnum "*.*")
       (setq drwnum (sepstr drwnum ".") shtnum (cadr drwnum) drwnum (car drwnum) shtq "")
       (setq shtnum drwnum drwnum "")
       )
     (list  
       "blockframespec"
       (list "handle" (vla-get-handle bobj))
       (list "project_number" (vla-get-TextString (getbatt bobj TAG:ProjectNumber)))
       (list "drawing_number" drwnum)
       (list "sheet_number" shtnum)
       (list "formatname" formatsizename)
       (list "sheet_orient" ori)
       ;(list "scale" (math-fix (vla-get-XScaleFactor bobj)))
       (list "scale" (vla-get-XScaleFactor bobj))
       (list "format_layout" (vla-get-Handle (vla-ObjectIDToObject #actdoc (vla-get-OwnerID bobj))))
       (list "bottomleftpoint" lbpt)
       (list "toprightpoint" rtpt)       
       )
     )
    
    (T
     (if (wcmatch drwnum "*.*")
       (setq drwnum (sepstr drwnum ".") shtnum (cadr drwnum) drwnum (car drwnum) shtq (vla-get-TextString (getbatt bobj TAG:SheetQuantity)))
       (setq shtnum "1" shtq (vla-get-TextString (getbatt bobj TAG:SheetQuantity)))
       )
     (list
       "blockframe"
       (list "handle" (vla-get-handle bobj)) 
       (list "project_number" (vla-get-TextString (getbatt bobj TAG:ProjectNumber)))
       (list "project_contractname" (cond ((listp TAG:ContractName) (antisep (mapcar '(lambda (x) (vla-get-TextString (getbatt bobj x))) TAG:ContractName) " ")) ((= 'STR (type TAG:ContractName)) (vla-get-TextString (getbatt bobj TAG:ContractName))) (T "ERROR")))
       (list "project_name" (cond ((listp TAG:ProjectName) (antisep (mapcar '(lambda (x) (vla-get-TextString (getbatt bobj x))) TAG:ProjectName) " ")) ((= 'STR (type TAG:ProjectName)) (vla-get-TextString (getbatt bobj TAG:ProjectName))) (T "ERROR")))
       (list "drawing_name" (cond ((listp TAG:DrawingName) (antisep (mapcar '(lambda (x) (vla-get-TextString (getbatt bobj x))) TAG:DrawingName) " ")) ((= 'STR (type TAG:DrawingName)) (vla-get-TextString (getbatt bobj TAG:DrawingName))) (T "ERROR")))
       (list "drawing_number" drwnum)
       (list "sheet_number" shtnum)
       (list "drawing_sheetquantity" shtq)
       (list "formatname" formatsizename)
       (list "sheet_orient" ori)
       (list "scale" (math-fix (vla-get-XScaleFactor bobj)))
       (list "format_layout" (vla-get-Handle (vla-ObjectIDToObject #actdoc (vla-get-OwnerID bobj))))
       (list "bottomleftpoint" lbpt)
       (list "toprightpoint" rtpt)
       )
     )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(prj|getdrwparamsfromblock tobj)
;(prj|getdrwparamsfromblock (vlax-ename->vla-object (car (entsel))))
(defun prj|getdrwparamsfromkoluch (tobj / drwnum shtnum shtq frmtype formatsizename ori pts scale)
  ;(setq tobj (vlax-ename->vla-object (car (entsel))))
  (setq scale (/ (vla-get-Height tobj) 2.5))
  (setq frmtype (FG|getframetype tobj))
  (setq pts (FG|getpts tobj))
  (setq formatsizename (FG|formatsizedetect pts))
  (setq ori (chr (car (vl-string->list formatsizename))))
  (setq drwnum (FG|getsheetnumber tobj))

  (cond
    ((= frmtype "purgedframespec")
     (if (wcmatch drwnum "*.*")
       (setq drwnum (sepstr drwnum ".") shtnum (cadr drwnum) drwnum (car drwnum))
       (setq shtnum drwnum drwnum "")
       )
     (list
       "purgedframespec"
       (list "handle" (vla-get-handle tobj))
       (list "project_number" (FG|getprjnumber tobj))
       (list "drawing_number" drwnum)
       (list "sheet_number" shtnum)
       (list "formatname" formatsizename)
       (list "sheet_orient" ori)
       (list "scale" scale)
       (list "format_layout" (vla-get-Handle (vla-ObjectIDToObject #actdoc (vla-get-OwnerID tobj))))
       (list "bottomleftpoint" (car pts))
       (list "toprightpoint" (cadr pts))
       )
     )
    ((= frmtype "purgedframe")
     (if (wcmatch drwnum "*.*")
       (setq drwnum (sepstr drwnum ".") shtnum (cadr drwnum) drwnum (car drwnum) shtq (FG|getsheetquantity tobj))
       (setq shtnum "1" shtq (FG|getsheetquantity tobj))
       )
     (list
       "purgedframe"
       (list "handle" (vla-get-handle tobj))
       (list "project_number" (FG|getprjnumber tobj))
       (list "project_contractname" (FG|getcontractname tobj))
       (list "project_name" (FG|getprjname tobj))
       (list "drawing_name" (FG|getdrwname tobj))
       (list "drawing_number" drwnum)
       (list "sheet_number" shtnum)
       (list "drawing_sheetquantity" shtq)
       (list "formatname" formatsizename)
       (list "sheet_orient" ori)
       (list "scale" scale)
       (list "format_layout" (vla-get-Handle (vla-ObjectIDToObject #actdoc (vla-get-OwnerID tobj))))
       (list "bottomleftpoint" (car pts))
       (list "toprightpoint" (cadr pts))
       )
     )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






(defun prj|drwsident ( / ssets sset lst)
  ;(if (null (vl-file-directory-p (setq plt:folder "d:/_TDMS/"))) (vl-mkdir plt:folder))
  ;(if (null (vl-file-directory-p plt:folder)) (vl-mkdir plt:folder) )

  (setq ssets (vla-get-SelectionSets #actdoc))
    (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "prj|drwsident")))
      (setq sset (vla-add ssets "prj|drwsident"))
      (progn (vla-delete (vla-item ssets "prj|drwsident")) (setq sset (vla-add ssets "prj|drwsident")))
      )
    (vla-Clear sset)
  (setq sset (vla-get-ActiveSelectionSet #actdoc)) (vla-clear sset)
  (vla-SelectOnScreen sset (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0)) (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("*")))
  (setq lst nil)
  (vlax-for item sset
    ;(setq item (vlax-ename->vla-object (car (entsel))))
    (cond
      ((and (= "AcDbBlockReference" (vla-get-ObjectName item)) (member (vla-get-EffectiveName item) BLK:BlocksNames))
       (setq lst (append lst (list (prj|getdrwparamsfromblock item)))))
      ((and (= "AcDbText" (vla-get-ObjectName item)) (wcmatch (vla-get-TextString item) "Кол. уч[~?@],Кол. уч[~?@],Кол.уч[~?@],Кол.уч"))
       (setq lst (append lst (list (prj|getdrwparamsfromkoluch item)))))
      ((and (= "AcDbMText" (vla-get-ObjectName item)) (wcmatch (vla-get-TextString item) "*Кол. уч[~?@]*,*Кол. уч[~?@]*,*Кол.уч[~?@]*,*Кол.уч*"))
       (setq lst (append lst (list (prj|getdrwparamsfromkoluch item)))))
      )
    );for
  lst
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun prj|items (lst pp) (vl-remove-if-not '(lambda (sheet) (equal (assoc (car pp) (cdr sheet)) pp)) lst))
(defun prj|getproperty (lst propname) (cadr (assoc propname (cdr lst))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



















(length (setq prj:alldata (prj|drwsident)))











;;;   площадь выпуска в м2
(rtos (apply '+ (mapcar '(lambda (line) (/ (apply '* (cdr (assoc (cadr (assoc "formatname" line)) #gostformats))) 1000000.0 )) (mapcar 'cdr prj:alldata))) 2)




(length (setq prj:maindata (vl-remove-if '(lambda (drw) (wcmatch (cadr (assoc "project_number" (cdr drw))) "*.С*")) prj:alldata)))
(length (setq prj:drwdata (vl-remove-if '(lambda (drw) (member (car drw) '("purgedframespec" "blockframespec"))) prj:maindata)))
(length (setq prj:specsdata (vl-remove-if-not '(lambda (drw) (wcmatch (cadr (assoc "project_number" (cdr drw))) "*.С*,*.С,*.C*,*.C")) prj:alldata)))





(setq #tdmsfolder "d:/_TDMS/")

(defun prj|mkfolder (pn / folder)
  (setq folder (strcat #tdmsfolder pn "/"))
  (if
    (null (vl-file-directory-p folder))
    (vl-mkdir folder))
  folder
  )



(setq prj:number (prj|getproperty (car prj:drwdata) "project_number"))
(setq prj:folder (prj|mkfolder prj:number))



  




;#################################################################################
;#################################################################################
;#################################################################################
;###################                                        ######################
;###################            GLOBAL   VARIABLES          ######################
;###################                                        ######################
;#################################################################################
;#################################################################################

(setq plotter "ktz_pdfgostplotter.pc3")
(setq pltcfgname "gostplotterconfig")
(setq target (getvar "TARGET"))
(setq plotconfs (vla-get-PlotConfigurations #actdoc))
(setq pltcfg (vla-add plotconfs pltcfgname :vlax-true))
(setq plot (vla-get-plot #actdoc))
;canlist namlist





;(setq tdms:str-dogovor "010-59-12")
(setq tdms:str-dogovor "29/Э-13 (918-58-13)")
(setq tdms:department "КП-00")
(setq tdms:customer "1791")

(load (strcat #lisppath "TDMS/tdmslib.lsp"))
(load (strcat #lisppath "strings/norus.lsp"))











;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(setq #tdms (vlax-get-or-create-object "TDMS.Application"))
;(vlax-put-property #tdms "Visible" :vlax-true)
(setq tdms:objDefs (gp #tdms "ObjectDefs"))
(setq tdms:drwDef (gp tdms:objDefs "item" "Чертеж"))
(setq tdms:docDef (gp tdms:objDefs "item" "Документ"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; выдирание типов ТДМС-файлов
(setq tdms:fileDefs (gp #tdms "FileDefs"))
(setq dwgfiledef (gp tdms:fileDefs "item" "FILE_DWG2000"))
(setq pdffiledef (gp tdms:fileDefs "item" "FILETYPE_PDF"))
(setq tdms:classformats (gp (gp (gp (gp #tdms "AttributeDefs") "item" "ATTR_FORMAT") "Classifier")"Classifiers"))

(setq tdms:prjcontent
       (gp
	 (tdms|child
	   (tdms|child (tdms|child (tdms|child (gp #tdms "Root") (strcat "*" tdms:customer "*")) (strcat "*" tdms:str-dogovor "*")) (strcat "*" tdms:department "*"))
	   (strcat prj:number " ")
	   )
	 "Content")
      )






;#################################################################################
;#################################################################################
;#################################################################################






;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXX           creating single-drawing  files        XXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX      DWG файлы     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


(defun prj|mkdwgfile (sheets / sso fname folder curpnum)
  ;(setq sheets (prj|items prj:maindata (list "drawing_number" "11")))
  (setq sso (vla-get-ActiveSelectionSet #actdoc)) (vla-Clear sso)
  (mapcar
    '(lambda (sh / p1 p2) ;(setq sh (car drwdata))
       (setq p1 (cadr (assoc "bottomleftpoint" (cdr sh))))
       (setq p2 (cadr (assoc "toprightpoint" (cdr sh))))
       (vl-cmdf "_zoom" "_W" p1 p2)
       (vla-select sso acSelectionSetCrossing (vlax-3d-point p1) (vlax-3d-point p2))
       )
    sheets)
  (if (= prj:number (setq curpnum (prj|getproperty (car sheets) "project_number")))
    (setq fname (strcat prj:folder prj:number " л " (prj|getproperty (car sheets) "drawing_number") ".dwg"))
    (progn
      (setq folder (prj|mkfolder (strcat prj:number "/" curpnum)))
      (setq fname (strcat folder curpnum (if (wcmatch curpnum "*.С*") "" " л ") (prj|getproperty (car sheets) "drawing_number") ".dwg"))
      ))
  (vla-Wblock #actdoc fname sso)
  (vla-Clear sso)
  (vlax-release-object sso)
  fname
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq dwgfiles
(mapcar
  '(lambda (drwn / shts)
     (setq shts (prj|items prj:maindata (list "drawing_number" drwn)))
     (prj|mkdwgfile shts)
     )
  (mapcar '(lambda (d) (prj|getproperty d "drawing_number") ) prj:drwdata)
  )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(defun prj|mkdwgfiles (/ drwnumbers)
;;;  (setq drwnumbers (vl-sort (mapcar '(lambda (d) (prj|getproperty d "drawing_number") ) prj:drwdata) '(lambda (a b) (< (atoi a)(atoi b)))))
;;;  (mapcar
;;;    '(lambda (drwnum / drwdata sso)
;;;       ;(setq drwnum (nth 10 drwnumbers))
;;;       (setq drwdata (prj|items prj:alldata (list "drawing_number" drwnum)))
;;;       (setq sso (vla-get-ActiveSelectionSet #actdoc)) (vla-Clear sso)
;;;       (mapcar
;;;	 '(lambda (sh / p1 p2) ;(setq sh (car drwdata))
;;;	    (setq p1 (cadr (assoc "bottomleftpoint" (cdr sh))))
;;;	    (setq p2 (cadr (assoc "toprightpoint" (cdr sh))))
;;;	    (vl-cmdf "_zoom" "_W" p1 p2)
;;;	    (vla-select sso acSelectionSetCrossing (vlax-3d-point p1) (vlax-3d-point p2))
;;;	    )
;;;	 drwdata
;;;	 )
;;;       (vla-Wblock #actdoc (strcat prj:folder prj:number " л " drwnum ".dwg") sso)
;;;       (vla-Clear sso)
;;;       (vlax-release-object sso)
;;;       )
;;;    drwnumbers
;;;   )
;;;  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(prj|mkdwgfiles)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX      saves 2004    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun dwgsaves2004 (file / docs $doc)
  (setq docs (vla-get-Documents #cad))
  (setq $doc (vla-open docs file))
  (vla-put-LineweightDisplay (vla-get-Preferences $doc) :vlax-true)
  (vla-saveas $doc file ac2004_dwg)
  (vla-close $doc)
  file
  );defun

(mapcar 'dwgsaves2004 dwgfiles)

;;;(defun prj|dwgfilesto2004 ( / files docs $doc)
;;;  (setq files (VL-DIRECTORY-FILES prj:folder "*.dwg" 1))
;;;  (foreach file files
;;;    (setq fullname (strcat prj:folder file))
;;;    (setq docs (vla-get-Documents #cad))
;;;    (setq $doc (vla-open docs fullname))
;;;    (vla-put-LineweightDisplay (vla-get-Preferences $doc) :vlax-true)
;;;    (vla-saveas $doc fullname ac2004_dwg)
;;;    (vla-close $doc)
;;;    )
;;;  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(prj|dwgfilesto2004)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX     making PDF     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


;(setq sheets (prj|items prj:maindata (list "drawing_number" "11")))

(defun prj|mkpdffile (sheets / folder curpnum fname q files shell app script)
  (if (= prj:number (setq curpnum (prj|getproperty (car sheets) "project_number")))
    (setq fname (strcat prj:folder "BNP-" prj:number " л " (prj|getproperty (car sheets) "drawing_number")))
    (progn
      (setq folder (prj|mkfolder (strcat prj:number "/" curpnum)))
      (setq fname (strcat folder "BNP-" curpnum (if (wcmatch curpnum "*.С*") "" " л ") (prj|getproperty (car sheets) "drawing_number")))
      ))
  (setq q (length sheets))
  (setq files 
  (mapcar
    '(lambda (sh / p1 p2 fn ) ;(setq sh (car sheets))
       (setq p1 (cadr (assoc "bottomleftpoint" (cdr sh))))
       (setq p2 (cadr (assoc "toprightpoint" (cdr sh))))
       (vla-SetWindowToPlot pltcfg
	 (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- p1 target))
	 (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(mapcar '- p2 target))
	 )
       (vla-put-plotType pltcfg acWindow)
       (vla-put-ConfigName pltcfg plotter)
       (setq canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames pltcfg))))
       (setq namlst (mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
       (vla-put-CanonicalMediaName pltcfg (nth (vl-position (apply 'strcat (sepstr (cadr (assoc "formatname" (cdr sh))) "-")) namlst)canlst))
       (vla-put-PlotRotation pltcfg 0)
       (vla-put-centerplot pltcfg :vlax-true)
       (vla-copyfrom (vla-get-ActiveLayout #actdoc) pltcfg)
       (vla-plotToFile plot (setq fn (strcat fname (if (= 1 q) "" (strcat "." (prj|getproperty sh "sheet_number"))) ".pdf")) plotter)
       fn
       )
    (vl-sort sheets '(lambda (a b) (< (atoi (prj|getproperty a "sheet_number")) (atoi (prj|getproperty b "sheet_number")))))
    )
  )
  (if (> q 1)
    (progn
      (setq shell (vlax-get-or-create-object "wscript.shell"))
      (setq app "\"c:\\Program Files\\AdultPDF\\Ap PDF Split-Merge\\pdfspme_cmd.exe\" ")
      (setq script (strcat app "-mer " (apply 'strcat (mapcar '(lambda (x) (strcat "-i \"" x "\" ")) files))(strcat "-o \"" fname ".pdf" "\"")))
      (vlax-invoke-method shell "run" script 1 :vlax-true)
      (mapcar 'vl-file-delete files)
      (vlax-release-object shell)
      )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(prj|mkpdffile sheets)
;(prj|mkpdffile prj:maindata)

(mapcar
  '(lambda (drwn / shts)
     (setq shts (prj|items prj:maindata (list "drawing_number" drwn)))
     (prj|mkpdffile shts)
     )
  (mapcar '(lambda (d) (prj|getproperty d "drawing_number")) prj:drwdata)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;(setq shell (vlax-get-or-create-object "wscript.shell"))
;;;(setq app "\"c:\\Program Files\\AdultPDF\\Ap PDF Split-Merge\\pdfspme_cmd.exe\" ")
;;;(setq script (strcat app "-mer "
;;;  (apply 'strcat
;;;    (mapcar
;;;      '(lambda (x)
;;;	 (strcat "-i \"" x "\" "))
;;;      (VL-DIRECTORY-FILES prj:folder (strcat "*" prj:number "*.pdf" ) 1)
;;;      ))
;;;		     (strcat "-o \"" prj:folder prj:number ".pdf" "\"")))
;;;
;;;(vlax-invoke-method shell "run" script 1 :vlax-true)
;;;(vlax-release-object shell) (setq shell nil)






;;;
;;;(defun prj|pdfplot (/ drwnumbers)
;;;  (setq drwnumbers (vl-sort (mapcar '(lambda (d) (prj|getproperty d "drawing_number")) prj:drwdata) '(lambda (a b) (< (atoi a)(atoi b)))))
;;;  (mapcar
;;;    '(lambda (drwnum / drwdata) ;(setq drwnum "1")
;;;       (setq drwdata (prj|items prj:maindata (list "drawing_number" drwnum)))
;;;       (mapcar
;;;	 '(lambda (sh / p1 p2) ;(setq sh (car drwdata))
;;;	    (setq p1 (cadr (assoc "bottomleftpoint" (cdr sh))))
;;;	    (setq p2 (cadr (assoc "toprightpoint" (cdr sh))))
;;;	    (vla-SetWindowToPlot pltcfg
;;;	      (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- p1 targ))
;;;	      (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(mapcar '- p2 targ))
;;;	      )
;;;	    (vla-put-plotType pltcfg acWindow)
;;;	    (vla-put-ConfigName pltcfg plotter)
;;;	    (setq canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames pltcfg))))
;;;	    (setq namlst (mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
;;;	    (vla-put-CanonicalMediaName pltcfg (nth (vl-position (apply 'strcat (sepstr (cadr (assoc "formatname" (cdr sh))) "-")) namlst)canlst))
;;;	    (vla-put-PlotRotation pltcfg 0)
;;;	    (vla-put-centerplot pltcfg :vlax-true)
;;;	    (vla-copyfrom (vla-get-ActiveLayout #actdoc) pltcfg)
;;;	    (vla-plotToFile plot
;;;	      (strcat
;;;		prj:folder "BNP-" prj:number " л "
;;;		(cadr (assoc "drawing_number" (cdr sh)))
;;;		(if (or (= "1" drwnum)  (member (cadr (assoc "drawing_sheetquantity" (cdr (car (vl-remove-if-not '(lambda (d) (member (car d) '("purgedframe" "blockframe") )) drwdata))))) '("1" "")))
;;;		  "" (strcat "." (cadr (assoc "sheet_number" (cdr sh))))
;;;		  )
;;;		".pdf")
;;;	      plotter)
;;;	    )
;;;	 drwdata
;;;	 )
;;;       )
;;;    drwnumbers
;;;    )
;;;  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(prj|pdfplot)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;;;
;;;;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;;;;XXXXXXXXXXXXXXXXXXX       pdf files merging  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;(defun prj|mainpdfmerge ( / shell app mergenumbers)
;;;  (setq mergenumbers (origlist (mapcar '(lambda (x) (cadr (assoc "drawing_number" (cdr x)))) (vl-remove-if-not '(lambda (x) (member (car x) '("blockframespec" "purgedframespec"))) prj:maindata))))
;;;  (setq shell (vlax-get-or-create-object "wscript.shell"))
;;;  (setq app "\"c:\\Program Files\\AdultPDF\\Ap PDF Split-Merge\\pdfspme_cmd.exe\" ")
;;;  (mapcar
;;;    '(lambda (num / shts name filenames script)  ;(setq num (car mergenumbers))
;;;       (setq shts (vl-sort (prj|items prj:maindata (list "drawing_number" num)) '(lambda (a b) (< (atoi (cadr (assoc "sheet_number" (cdr a)))) (atoi (cadr (assoc "sheet_number" (cdr b))))))))
;;;       (setq name (strcat  prj:folder "BNP-" prj:number " л " num))
;;;       (while (vl-string-search "/" name) (setq name (vl-string-subst "\\" "/" name)))
;;;       (setq filenames (mapcar '(lambda (sh) (strcat name "." (cadr (assoc "sheet_number" (cdr sh))) ".pdf")) shts))
;;;       (setq script (strcat app "-mer " (apply 'strcat (mapcar '(lambda (x) (strcat "-i \"" x "\" ")) filenames)) (strcat "-o \"" name ".pdf" "\"")))
;;;       (vlax-invoke-method shell "run" script 1 :vlax-true)
;;;       (mapcar 'vl-file-delete filenames)
;;;       )
;;;    mergenumbers
;;;    )
;;;  (vlax-release-object shell) (setq shell nil)
;;;  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(prj|mainpdfmerge)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;














;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX       tdms processing    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

;;;
;;;
;;;(setq tdms:str-dogovor "*040-197-11*")
;;;(setq tdms:specialization "*КП-00*")
;;;
;;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;;XXXXXXXXXXXXXXXXXXXXXXX      TDMS          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;;XXXXXXXXXXXXXXXXXXXXXXX     	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;
;;;;(setq tdms:contraktname (substr unum 1 (VL-STRING-POSITION 45 unum)))
;;;;;  для теплосетей
;;;
;;;(setq tdms:contraktname "ТС - Тепловые сети г. Гродно")
;;;(setq str-objekt (strcat "*" tdms:contraktname "*")
;;;      
;;;      str-uz (strcat "*" prj:number "*")
;;;      ;str-uz "1747-1-АТМ1"
;;;      )
;;;(load (strcat #lisppath "TDMS/tdms-tools.lsp"))
;;;(load (strcat #lisppath "strings/norus.lsp"))
;;;(load (strcat #lisppath "MATH/math-power.lsp"))
;;;
;;;
;;;(defun formatstr->quanta4 (str / n1 n2)
;;;  (if (= (strlen str) 2)
;;;    (setq n1 (mapcar 'atoi (sepstr (substr (strcat str "x1") 2) "x")))
;;;    (setq n1 (mapcar 'atoi (sepstr (substr str 2) "x"))))
;;;  (setq n2 (cadr n1)
;;;	n1 (car n1))
;;;  (* n2 (math-power 2 (- 4 n1)))
;;;  );defun
;;;
;;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;(setq tdms (vlax-get-or-create-object "TDMS.Application"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; выдирание бланк чертежа
;;;(setq tdms:objDefs (vlax-get-property tdms "ObjectDefs"))
;;;(setq tdms:drwDef (vlax-get-property tdms:objDefs "item" "Чертеж"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; выдирание типов ТДМС-файлов
;;;(setq tdms:fileDefs (vlax-get-property tdms "FileDefs"))
;;;(setq dwgfiledef (vlax-get-property tdms:fileDefs "item" "FILE_DWG2000"))
;;;(setq pdffiledef (vlax-get-property tdms:fileDefs "item" "FILETYPE_PDF"))
;;;
;;;;;;; типы форматов
;;;(setq tdmsclassformats (vlax-get-property
;;;			 (vlax-get-property
;;;			   (vlax-get-property
;;;			     (vlax-get-property tdms "AttributeDefs")
;;;			     "item" "ATTR_FORMAT")
;;;			   "Classifier")
;;;			 "Classifiers"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; нахождение нужного узла в дереве ТДМС
;;;(setq tdms:prjcontent  (vlax-get-property (tdms-get-sub
;;;			(vlax-get-property (tdms-get-sub
;;;				(vlax-get-property (tdms-get-sub
;;;					(vlax-get-property (tdms-get-sub
;;;						(vlax-get-property
;;;						  (vlax-get-property tdms "Root")
;;;						  "Content")
;;;						str-objekt) "Content")
;;;					tdms:str-dogovor) "Content")
;;;				str-spec) "Content")
;;;			str-uz) "Content")
;;;      );tdms-uzc
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;ХХХХХХХ заполняемс содержимое узла
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



(defun prj|exportdrw (sheets / newdrw curpnum folder fname)
;  #tdms
;  tdms:objDefs
;  tdms:drwDef
;  tdms:docDef
;  tdms:fileDefs
;  dwgfiledef
;  pdffiledef
;  tdms:classformats
;  tdms:prjcontent

  
  ;(setq sheets (prj|items prj:maindata (list "drawing_number" "5")))
  (setq newdrw (vlax-invoke-method tdms:prjcontent "Create" tdms:drwDef))
  (tdms-putatt newdrw "Номер листа" (prj|getproperty (car sheets) "drawing_number"))
  (tdms-putatt newdrw "Наименование документа" (prj|getproperty (car (prj|items sheets (list "sheet_number" "1"))) "drawing_name"))
  (tdms-putatt newdrw "ATTR_QUANTITY" (length sheets))
  (vlax-put-property (gp (gp newdrw "Attributes") "item" "ATTR_FORMAT") "Classifier" (vlax-invoke-method tdms:classformats "Find" (vl-string-left-trim "vw-" (prj|getproperty (car sheets) "formatname"))))
  (vlax-put-property (gp (gp newdrw "Attributes") "item" "ATTR_REPETITIONS") "Value" (apply '+ (mapcar '(lambda (x) (FG|A4Encount (vl-string-left-trim "wv-" (prj|getproperty x "formatname")))) sheets)))
  (if (= prj:number (setq curpnum (prj|getproperty (car sheets) "project_number")))
    (setq fname (strcat prj:folder prj:number " л " (prj|getproperty (car sheets) "drawing_number") ".dwg"))
    (progn
      (setq folder (prj|mkfolder (strcat prj:number "/" curpnum)))
      (setq fname (strcat folder curpnum " л " (prj|getproperty (car sheets) "drawing_number") ".dwg"))
      ))
  (setq nfile (vlax-invoke-method (gp newdrw "Files") "Create" dwgfiledef fname))
  (vlax-invoke-method nfile "CheckIn" fname)

  (if (= prj:number (setq curpnum (prj|getproperty (car sheets) "project_number")))
    (setq fname (strcat prj:folder "BNP-" prj:number " л " (prj|getproperty (car sheets) "drawing_number") ".pdf"))
    (progn
      (setq folder (prj|mkfolder (strcat prj:number "/" curpnum)))
      (setq fname (strcat folder "BNP-" curpnum " л " (prj|getproperty (car sheets) "drawing_number") ".pdf"))
      ))
  (setq nfile (vlax-invoke-method (gp newdrw "Files") "Create" pdffiledef))
  (vlax-invoke-method nfile "CheckIn" fname)
  
  (vlax-invoke-method newdrw "Update")
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;  run
(mapcar	
  '(lambda (drwn / shts) ;(setq drwn "2")
     (setq shts (prj|items prj:maindata (list "drawing_number" drwn)))
     (prj|exportdrw shts)
     )
  (mapcar '(lambda (d) (prj|getproperty d "drawing_number")) prj:drwdata)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	



















;;;(defun prj|exportmaintotdms (
;;;		      /
;;;		      kus		; ename список колуч-ей
;;;		      quantity		; int количество листов
;;;		      strformat		; string имя формата листа
;;;		      tdmsclassformat	; class соответствующий имени формата
;;;		      new4ert		; object новый отъект чертежа
;;;		      attquant		; tdms attribute количество листов
;;;		      atttdmsformat	; tdms attribute формат
;;;		      atttdmsqa4	; tdms attribute количество листов А4
;;;		      qa4		; int
;;;		      files		; container файлов объекта чертеж
;;;		      nfile		; file новый добавляемый фалй
;;;		      )
;;;
;;;  ;(setq line (car (vl-sort prj:drwdata '(lambda (a b) (< (atoi (cadr (assoc "drawing_number" (cdr a)))) (atoi (cadr (assoc "drawing_number" (cdr b)))))))))
;;;
;;;  (foreach line (vl-sort prj:drwdata '(lambda (a b) (< (atoi (prj|getproperty a "drawing_number")) (atoi (prj|getproperty b "drawing_number")))))
;;;    (setq quantity (prj|getproperty line "drawing_sheetquantity"))
;;;    (setq quantity (if (or (= "" quantity) (= "1" (prj|getproperty line "drawing_number"))) 1 (atoi quantity)))
;;;
;;;
;;;    (setq strformat (vl-string-left-trim "vw-" (prj|getproperty line "formatname")))
;;;    (setq tdmsclassformat (vlax-invoke-method tdmsclassformats "Find" strformat))
;;;
;;;    (setq new4ert (vlax-invoke-method tdms:prjcontent "Create" 4ertdef))
;;;    (tdms-putatt new4ert "Номер листа" (cadr (assoc "drawing_number" (cdr line))))
;;;    (tdms-putatt new4ert "Наименование документа" (cadr (assoc "drawing_name" (cdr line))))
;;;
;;;    (setq attquant (vlax-get-property (vlax-get-property new4ert "Attributes") "item" "ATTR_QUANTITY"))
;;;    (vlax-put-property attquant "Value" quantity)
;;;    
;;;
;;;    (setq atttdmsformat (vlax-get-property (vlax-get-property new4ert "Attributes") "item" "ATTR_FORMAT"))
;;;    (vlax-put-property atttdmsformat "Classifier" tdmsclassformat)
;;;
;;;    (setq atttdmsqa4 (vlax-get-property (vlax-get-property new4ert "Attributes") "item" "ATTR_REPETITIONS"))
;;;
;;;
;;;    (setq qa4 (apply '+
;;;     (mapcar
;;;      '(lambda (x)
;;;	 (FG|A4Encount 
;;;	   (vl-string-left-trim "wv-" (prj|getproperty x "formatname"))
;;;	   )
;;;
;;;	 )
;;;      (vl-remove-if-not '(lambda (x) (= (cadr (assoc "drawing_number" (cdr line))) (cadr (assoc "drawing_number" (cdr x))))) prj:maindata)
;;;      )))
;;;    
;;;    (vlax-put-property atttdmsqa4 "Value" qa4)
;;;    (setq files (vlax-get-property new4ert "Files"))
;;;
;;;    (setq nfile (vlax-invoke-method files "Create" dwgfiledef (strcat prj:folder prj:number " л " (cadr (assoc "drawing_number" (cdr line)))".dwg")))
;;;    (vlax-invoke-method nfile "CheckIn" (strcat prj:folder prj:number " л " (cadr (assoc "drawing_number" (cdr line)))".dwg"))
;;;
;;;    (setq nfile (vlax-invoke-method files "Create" pdffiledef))
;;;    (vlax-invoke-method nfile "CheckIn" (strcat prj:folder "BNP-" prj:number " л " (cadr (assoc "drawing_number" (cdr line)))".pdf"))
;;;    (vlax-invoke-method new4ert "Update")
;;;    );foreach
;;;  );defun
;;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;(prj|exportmaintotdms)

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX




;;; ЗЗ




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXX                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;                спецификации                                                          
;;;XXXXXXXXXXX                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX





(length (setq s (prj|items prj:alldata (list "project_number" (strcat prj:number ".С")))))
(dwgsaves2004 (prj|mkdwgfile s))
(prj|mkpdffile s)





(length (setq s1 (prj|items prj:alldata (list "project_number" (strcat prj:number ".С1")))))
(dwgsaves2004 (prj|mkdwgfile s1))
(prj|mkpdffile s1)
		





(length (setq s2 (prj|items prj:alldata (list "project_number" "1747-1-АТМ1.С2"))))
(dwgsaves2004 (prj|mkdwgfile s2))
(prj|mkpdffile s2)







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





(length (setq prj:specsdata (vl-remove-if-not '(lambda (drw) (wcmatch (cadr (assoc "project_number" (cdr drw))) "*.С*")) prj:alldata)))


(setq specs (origlist (mapcar '(lambda (l) (cadr (assoc "project_number" (cdr l)))) prj:specsdata)))


(mapcar
  '(lambda (cspcnum			;current specification number
	    ;(setq cpscnum  (car specs))
	    /
	    cur:spc sso docs $doc
	    dwgfilename pdffilename
	    cspc:folder
	    plotter pltcfgname targ plotconfs pltcfg plot canlst namlst
	    mergeapp shell spcpdfname filenames
	    tdmsclassformat quantity strformat docdef newdoc attquant atttdmsformat atttdmsqa4 qa4 files nfile
	    )
     (setq cur:spc (vl-sort (prj|items prj:specsdata (list "project_number" cspcnum)) '(lambda (a b) (< (atoi (prj|getproperty a "sheet_number")) (atoi (prj|getproperty b "sheet_number"))))))
     (setq cspc:folder (strcat #tdmsfolder prj:number "/" cspcnum "/"))
     (if (null (vl-file-directory-p prj:folder)) (vl-mkdir prj:folder))


     (setq sso (vla-get-ActiveSelectionSet #actdoc)) (vla-Clear sso)
     (mapcar
       '(lambda (sh / p1 p2) ;(setq sh (car drwdata))
	  (setq p1 (cadr (assoc "bottomleftpoint" (cdr sh))))
	  (setq p2 (cadr (assoc "toprightpoint" (cdr sh))))
	  (vl-cmdf "_zoom" "_W" p1 p2)
	  (vla-select sso acSelectionSetCrossing (vlax-3d-point p1) (vlax-3d-point p2))
	  )
       cur:spc
       )
     (setq dwgfilename (strcat prj:folder cspcnum ".dwg"))
         
     (vla-Wblock #actdoc dwgfilename sso)
     (vla-Clear sso)
     (vlax-release-object sso)

     (setq docs (vla-get-Documents #cad))
     (setq $doc (vla-open docs dwgfilename))
     (vla-put-LineweightDisplay (vla-get-Preferences $doc) :vlax-true)
     (vla-saveas $doc dwgfilename ac2004_dwg)
     (vla-close $doc)

     (setq plotter "ktz_pdfgostplotter.pc3")
     (setq pltcfgname "gostplotterconfig")
     (setq targ (getvar "TARGET"))
     (setq plotconfs (vla-get-PlotConfigurations #actdoc))
     (setq pltcfg (vla-add plotconfs pltcfgname :vlax-true))
     (setq plot (vla-get-plot #actdoc))

     (mapcar
       '(lambda	(sh / p1 p2)		;(setq sh (car cur:spc))
	  (setq p1 (cadr (assoc "bottomleftpoint" (cdr sh))))
	  (setq p2 (cadr (assoc "toprightpoint" (cdr sh))))
	  (vla-SetWindowToPlot pltcfg
	    (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- p1 targ))
	    (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- p2 targ)))
	  (vla-put-plotType pltcfg acWindow)
	  (vla-put-ConfigName pltcfg plotter)
	  (setq	canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames pltcfg))))
	  (setq namlst (mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
	  (vla-put-CanonicalMediaName pltcfg (nth (vl-position (apply 'strcat (sepstr (cadr (assoc "formatname" (cdr sh))) "-")) namlst) canlst))
	  (vla-put-PlotRotation pltcfg 0)
	  (vla-put-centerplot pltcfg :vlax-true)
	  (vla-copyfrom (vla-get-ActiveLayout #actdoc) pltcfg)
	  (vla-plotToFile plot
	    (strcat prj:folder "BNP-" prj:number" л " (cadr (assoc "sheet_number" (cdr sh))) ".pdf")
	    plotter)
	  )
       cur:spc
       );mapcar

     
     (if (setq mergeapp (findfile "C:\\Program Files\\AdultPDF\\Ap PDF Split-Merge\\pdfspme_cmd.exe"))
       (progn
	 (setq shell (vlax-get-or-create-object "wscript.shell"))
	 (setq mergeapp (strcat "\"" mergeapp "\" "))
	 (setq spcpdfname (strcat  prj:folder "BNP-" cspcnum))
	 (while (vl-string-search "/" spcpdfname) (setq spcpdfname (vl-string-subst "\\" "/" spcpdfname)))
	 (setq filenames (mapcar '(lambda (sh) (strcat spcpdfname " л " (cadr (assoc "sheet_number" (cdr sh))) ".pdf")) cur:spc))
	 (setq script (strcat mergeapp "-mer " (apply 'strcat (mapcar '(lambda (x) (strcat "-i \"" x "\" ")) filenames)) (strcat "-o \"" (setq pdffilename (strcat spcpdfname  ".pdf"))"\"")))
	 (vlax-invoke-method shell "run" script 1 :vlax-true)
	 (mapcar 'vl-file-delete filenames)
	 (vlax-release-object shell)
	 (setq shell nil)
	 )
       (exit)
       )

     ;   cur:spc
     (setq quantity (itoa (length cur:spc)))
     (setq strformat (vl-string-left-trim "vw-" (cadr (assoc "formatname" (cdr (car cur:spc))))))
     (setq tdmsclassformat (vlax-invoke-method tdms:classformats "Find" strformat))
     
     (setq newdoc (vlax-invoke-method tdms:prjcontent "Create" tdms:docDef))
     (tdms-putatt newdoc "Обозначение документа" cspcnum)
     (tdms-putatt newdoc "Наименование документа" (prj|getproperty (car (prj|items cur:spc '("drawing_number" "1"))) "drawing_name"))
     (setq attquant (vlax-get-property (vlax-get-property newdoc "Attributes") "item" "ATTR_QUANTITY"))
     (vlax-put-property attquant "Value" quantity)
     (setq atttdmsformat (vlax-get-property (vlax-get-property newdoc "Attributes") "item" "ATTR_FORMAT"))
     (vlax-put-property atttdmsformat "Classifier" tdmsclassformat)
     (setq atttdmsqa4 (vlax-get-property (vlax-get-property newdoc "Attributes") "item" "ATTR_REPETITIONS"))
     (setq qa4 (apply '+ (mapcar '(lambda (x) (FG|A4Encount (VL-STRING-LEFT-TRIM "wv-" (prj|getproperty x "formatname")))) cur:spc)))
     (vlax-put-property atttdmsqa4 "Value" qa4)
     (setq files (vlax-get-property newdoc "Files"))
     (setq nfile (vlax-invoke-method files "Create" dwgfiledef dwgfilename))
     (vlax-invoke-method nfile "CheckIn" dwgfilename)
     (setq nfile (vlax-invoke-method files "Create" pdffiledef))
     (vlax-invoke-method nfile "CheckIn" pdffilename)
     (vlax-invoke-method newdoc "Update")
         
     )
  specs
  );mapcar



(gc)