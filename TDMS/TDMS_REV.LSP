;;; 14_07_10
;;; проект обработки разбитого узла собранного в одной модели чертежа
;;; раскидывает чертежи по файлам в папку D:\!!!TDMS\<номер узла>
;;; формирует в ТДМС объекты чертежей
;;; пока все

;;;   ДЛЯ ВНЕСЕНИЯ ИЗМЕНЕНИЙ



(load (strcat #lisppath "TDMS\\tdmslib.LSP"))
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX     global constants     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(setq tdmsfolder "d:/_TDMS/")



;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX     global variables     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(setq scale 1)
;(setq scale 50)
	



;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXX     selecting drawings     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(setq revNO 1)

;;  только листы с изм
(setq kulist (get-kol-uch))
(length kulist)




;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX         loading subfunctions      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(load (strcat #lisppath "Database/dblib.lsp"))
(load (strcat #lisppath "common functions/sssum.lsp"))
(load (strcat #lisppath "common functions/format-identification-gost.lsp"))






;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX     converting sheets data      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX




;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;ХХХХХХХ            преобразование списка sheet'ов
;ХХХХХХХ      на выходе получаем список вида
;ХХХХХХХ      (("1" (<Entity name: 7eadc730>)) ("2" (<Entity name: 7eaebed0>)) ("3" (<Entity name: 7eae7700>)) ("4" (<Entity name: 7eaa0658>)) ("5" (<Entity name: 7eab7958> <Entity name: 7eab7718> <Entity name: 7eab7318> <Entity name: 7eaf6f18> <Entity name: 7eaf6b18> <Entity name: 7eaf6718> <Entity name: 7eaf6318> <Entity name: 7eaf3f18> <Entity name: 7eaf3b18> <Entity name: 7eaf3718> <Entity name: 7eaf3318>)) ("6" (<Entity name: 7eaf0988>)) ("7" (<Entity name: 7eaf3020>)) ("8" (<Entity name: 7eaaf440> <Entity name: 7ea86e28> <Entity name: 7ea87550> <Entity name: 7ea9c1d8> <Entity name: 7ea9c698> <Entity name: 7eaaf6d8>)) ("9" (<Entity name: 7eaaf850> <Entity name: 7eaafc98> <Entity name: 7eaafdc8> <Entity name: 7eaafef8> <Entity name: 7eaa0068> <Entity name: 7eaafb28>)) ("10" (<Entity name: 7ea9da28>)) ("11" (<Entity name: 7eaf5430>)) ("12" (<Entity name: 7eae1c58>)) ("13" (<Entity name: 7eaf22a8>)) ("14" (<Entity name: 7ea9dd18>)) ("15" (<Entity name: 7ea9df40>)) ("16" (<Entity name: 7eaaf1a8>)) ("17" (<Entity name: 7eacc990> <Entity name: 7eacc048> <Entity name: 7eacc750> <Entity name: 7eaefec8> <Entity name: 7eaef6e8> <Entity name: 7ea96db0> <Entity name: 7ea96ee0> <Entity name: 7ea9d050> <Entity name: 7ea9d180> <Entity name: 7ea9d2b0> <Entity name: 7ea9d420> <Entity name: 7ea9d550> <Entity name: 7ea9d680> <Entity name: 7ea9d7b0> <Entity name: 7ea9d920> <Entity name: 7eac6e40>)) ("19" (<Entity name: 7eac4508> <Entity name: 7eaab250> <Entity name: 7eaab0d0> <Entity name: 7eab1f10> <Entity name: 7eab1d90> <Entity name: 7eab1828> <Entity name: 7eabd170> <Entity name: 7eac3f70> <Entity name: 7eac3db0> <Entity name: 7eac3bb0>)) ("20" (<Entity name: 7eac2e50>)))
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

; (setq ku (car (get-kol-uch)))
; (setq ku (car kulist))
(setq sheets (mapcar '(lambda (ku)
			(list (car (sepstr (get-lnumber ku) ".")) ku))
		     kulist))
(setq zipsheets (ziplist sheets))

(foreach sh zipsheets
  (if (> (length (cdr sh)) 1)
    (setq zipsheets (subst
		      (list
			(car sh)
			(vl-sort
			  (cdr sh)
			  '(lambda (a b)
			     (<
			       (atoi (cadr (sepstr (get-lnumber a) ".")))
			       (atoi (cadr (sepstr (get-lnumber b) ".")))
			       )))
			);list
		      sh
		      zipsheets))
    (setq zipsheets (subst (list (car sh) (cdr sh)) sh zipsheets))
    );if
  );foreach

(setq drawings (vl-sort zipsheets '(lambda (a b) (< (atoi (car a)) (atoi (car b))))))





;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX     creating  temp folder    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX      папка узла    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(setq unum (cdr (assoc 1 (entget (get-uznumber (car kulist))))))
;(setq unum (cdr (assoc 1 (entget (get-uznumber ku)))))
(setq uzfolder (strcat tdmsfolder unum "_rev" (itoa revNO) "/"))
(if (null (vl-file-directory-p uzfolder))
  (vl-mkdir uzfolder)
  )







;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXX           creating single-drawing  files        XXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX      DWG файлы     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun mkfiledwg (drw
		  /
		  drwnum
		  kulst
		  pts
		  sso
		  ;filname
		  )
  (setq drwnum (car drw)
	kulst (cadr drw)
	sso (vla-get-ActiveSelectionSet #actdoc))
  (vla-Clear sso)
  (foreach ku kulst
    (setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch ku)))
    (vl-cmdf "_zoom" "_W" (car pts) (cadr pts))
    (vla-select sso acSelectionSetCrossing
      (vlax-3d-point (car pts))
      (vlax-3d-point (cadr pts)))
    )
  (vla-Wblock #actdoc (strcat uzfolder unum " л" drwnum "_изм" (itoa revNO) ".dwg") sso)
  (vla-Clear sso)
  (vlax-release-object sso)
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(if (or
	(ssget "_X" '((0 . "LWPOLYLINE")))
	(ssget "_X" '((1 . "Копировал")))
	(ssget "_X" '((0 . "spdsFormat")))
	)
    (progn
      (alert "Чертеж не подготовлен
      \n  - разбейте SPDS-объекты и блоки
      \n  - уберите слово \"Копировал\"
      \n  - разбейте полилини")
      (exit)
      )
  ;(mapcar '(lambda (x) (mkfiledrw x)) drawings)
  (mapcar 'mkfiledwg drawings)
  );if
;(mkfiledwg (car drawings))
;(get-rightformatline<-koluch (car (entsel)))
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX










;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX      saves 2004    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

;;;; для перевода скинутых чертежей
;(setq uzfolder "d:/DownLoad/_Алик_/")

;;; 2013 acad мб не надо, итак сохраняет в 2004 формате
;;;; -----  НАДО НАДО 
(setq files (VL-DIRECTORY-FILES uzfolder "*.dwg" 1))
(foreach file files
  (setq fullname (strcat uzfolder file))
  (setq docs (vla-get-Documents #cad))
  (setq $doc (vla-open docs fullname))
  (vla-put-LineweightDisplay (vla-get-Preferences $doc) :vlax-true)
  (vla-saveas $doc fullname ac2004_dwg)
  (vla-close $doc)
  )




;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX     making PDF     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

;2013
(setq ktz-pdfplotter "ktz_pdfgostplotter.pc3")
(setq ktz-pdfgostplotterconfigname "gostplotterconfig")
;2008
;(setq ktz-pdfplotter "ktz_pdf_plotter_2008.pc3")
;(setq ktz-pdfgostplotterconfigname "gostplotterconfig")

;(setq scale 1)
(setq targ (getvar "TARGET"))

(defun pdfplotting ( / plotconfs pltcfg pts canlist namlist sheetnum uznum actlayout plot i )
(setq plotconfs (vla-get-PlotConfigurations #actdoc))
  ;(do plotconfs)
(setq pltcfg (vla-add plotconfs ktz-pdfgostplotterconfigname :vlax-true))
  ;(setq pltcfg1 (vla-add plotconfs "tst1" :vlax-true))
;(setq ku (car (entsel)))
  (setq i 0)
(foreach ku kulist
  ;(setq ku (nth 3 kulist))
  (setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch ku)))
  (vla-SetWindowToPlot pltcfg
      ;(vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (car pts))
      ;(vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (cadr pts)))
      ;;;  вариант со смещением targetа, возможо надо будет корректировка при другом масштабе
      (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- (car pts) targ))
      (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(mapcar '- (cadr pts) targ)))
  ;(vla-SetWindowToPlot pltcfg1
  ;    (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (car pts))
  ;    (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (cadr pts)))
  
  (vla-put-plotType pltcfg acWindow)
  (vla-put-ConfigName pltcfg ktz-pdfplotter)
  (setq canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames pltcfg))))
  (setq namlst(mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
  (vla-put-CanonicalMediaName pltcfg (nth (vl-position (strcat (if (> (abs (- (car (car pts)) (car (cadr pts)))) (abs (- (cadr (car pts)) (cadr (cadr pts))))) "w" "v") "A" (get-ftxte<-formatpts pts)) namlst) canlst))
  (vla-put-PlotRotation pltcfg 0)
  (vla-put-centerplot pltcfg :vlax-true)
  ;(vla-put-StyleSheet pltcfg "monochrome.ctb")
  (setq sheetnum (get-lnumber ku))
  (setq uznum (cdr (assoc 1 (entget (get-uznumber ku)))))
  (setq actlayout (vla-get-ActiveLayout #actdoc))
  (vla-copyfrom actlayout pltcfg)
  ;vla-SetLayoutsToPlot
  (setq plot (vla-get-plot #actdoc))
  ;чтобы не тормозило надо убирать галочки печать и публикация в фоне в настройках
  ;(vla-StartBatchMode plot (setq i (1+ i)))
  
  (vla-plotToFile plot (strcat uzfolder "BNP-" uznum " л" sheetnum "_изм" (itoa revNO) ".pdf") ktz-pdfplotter)
  );foreach
  );defun


(pdfplotting)
;(alert "\nNow You must go to TDMS folder and consolidate pdf lists")





;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX       pdf files merging  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun pdfmerge ( / shell app)
  (setq shell (vlax-get-or-create-object "wscript.shell"))
  (setq app "\"c:\\Program Files\\AdultPDF\\Ap PDF Split-Merge\\pdfspme_cmd.exe\" ")
  (mapcar
    '(lambda (drw / name script filenames)
       (setq name (strcat uzfolder "BNP-" (cdr (assoc 1 (entget (get-uznumber (car (cadr drw)))))) " л"))
       (while (vl-string-search "/" name) (setq name (vl-string-subst "\\" "/" name)))
       (setq filenames (mapcar '(lambda (sh) (strcat name (get-lnumber sh) "_изм" (itoa revNO) ".pdf")) (cadr drw)))
       (setq script (strcat app "-mer " (apply 'strcat (mapcar '(lambda (x) (strcat "-i \"" x "\" ")) filenames) ) (strcat "-o \"" name (car drw) "_изм" (itoa revNO) ".pdf" "\"")))
       (vlax-invoke-method shell "run" script 1 :vlax-true)
       (mapcar 'vl-file-delete filenames)
       )
    (vl-remove-if '(lambda (x) (> 2 (length (cadr x)))) drawings)
    )
  (vlax-release-object shell) (setq shell nil)
  );defun

(pdfmerge)














;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX       tdms processing    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



(setq tdms:str-dogovor "*010-59-12*")
(setq str-spec "*КП-00*")

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX      TDMS          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXX     	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(setq tdms-objekt (substr unum 1 (VL-STRING-POSITION 45 unum)))
;;  для теплосетей
;;(setq tdms-objekt "ТС - Тепловые сети г. Гродно")


(setq str-objekt (strcat "*" tdms-objekt "*")
      str-uz (strcat "*" unum " *"))
      

(load (strcat #lisppath "TDMS/tdms-tools.lsp"))
(load (strcat #lisppath "strings/norus.lsp"))
(load (strcat #lisppath "MATH/math-power.lsp"))
(defun formatstr->quanta4 (str / n1 n2)
  (if (= (strlen str) 2)
    (setq n1 (mapcar 'atoi (sepstr (substr (strcat str "x1") 2) "x")))
    (setq n1 (mapcar 'atoi (sepstr (substr str 2) "x"))));if
  (setq n2 (cadr n1)
	n1 (car n1))
  (* n2 (math-power 2 (- 4 n1)))
  );defun

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(setq tdms (vlax-get-or-create-object "TDMS.Application"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; выдирание бланк чертежа
(setq objs (vlax-get-property tdms "ObjectDefs"))
(setq 4ertdef (vlax-get-property objs "item" "Чертеж"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; выдирание типов ТДМС-файлов
(setq filedefs (vlax-get-property tdms "FileDefs"))
(setq dwgfiledef (vlax-get-property filedefs "item" "FILE_DWG2000"))
(setq pdffiledef (vlax-get-property filedefs "item" "FILETYPE_PDF"))

;;;; типы форматов
(setq tdmsclassformats (vlax-get-property
			 (vlax-get-property
			   (vlax-get-property
			     (vlax-get-property tdms "AttributeDefs")
			     "item" "ATTR_FORMAT")
			   "Classifier")
			 "Classifiers"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; нахождение нужного узла в дереве ТДМС
(setq tdms-uzc  (vlax-get-property (tdms-get-sub
			(vlax-get-property (tdms-get-sub
				(vlax-get-property (tdms-get-sub
					(vlax-get-property (tdms-get-sub
						(vlax-get-property
						  (vlax-get-property tdms "Root")
						  "Content")
						str-objekt) "Content")
					tdms:str-dogovor) "Content")
				str-spec) "Content")
			str-uz
			) "Content")
      );tdms-uzc



;(tdms-content tdms-uzc)
;(do (setq spec (gp tdms-uzc "Item" 2)))
;(tdms-content  (gp spec "Versions"))
;(do (vlax-get-Property tdms-uzc "Item" 1))
;(tdms-get-sub  "")


(if
  (dcl|YN "ATTENTION!!  will delete old files from tdms. continue?")
;(setq drw (car drawings))
(mapcar
  '(lambda (drw / kus quantity strformat tdmsclassformat tdms:drw tdms:drw:files fn nfile)
     (setq kus (cadr drw))
     (setq quantity (length kus))
     (setq strformat (norus (vl-string-left-trim "-" (format-detect (get-ftxte<-formatpts (get-formatpts<-rightformatline (get-rightformatline<-koluch (car kus))))))))
     (setq tdmsclassformat (vlax-invoke-method tdmsclassformats "Find" strformat))
     (setq tdms:drw (tdms-get-sub tdms-uzc (strcat "л." (car drw) "*")))
     (setq tdms:drw:files (vlax-get-property tdms:drw "Files"))
     
     (while
       (and
	 (> (gp tdms:drw:files "Count") 0)
	 (member (strcase (last (sepstr (setq fn (gp (gp tdms:drw:files "Item" 0) "FileName")) "."))) '("DWG" "PDF"))
	 )
       (vlax-invoke-method (gp tdms:drw:files "Item" fn) "Erase")
       (vlax-invoke-method tdms:drw "Update")
       )
     (setq nfile (vlax-invoke-method tdms:drw:files "Create" dwgfiledef (strcat uzfolder unum " л" (car drw) "_изм" (itoa revNO) ".dwg")))
     (vlax-invoke-method nfile "CheckIn" (strcat uzfolder unum " л" (car drw) "_изм" (itoa revNO) ".dwg"))
     (setq nfile (vlax-invoke-method tdms:drw:files "Create" pdffiledef))
     (vlax-invoke-method nfile "CheckIn" (strcat uzfolder "BNP-" unum " л" (car drw) "_изм" (itoa revNO) ".pdf"))
     (vlax-invoke-method tdms:drw "Update")
     )
  drawings
  );mapcar
  )

(mapcar (function (lambda (x)
		    (if (and x (not (vlax-object-released-p x)))
		      (vlax-release-object x)
		      )))
	(list
	  tdms:drw:files
	  tdms:drw
	  tdmsclassformat
	  tdmsclassformats
	  pdffiledef
	  dwgfiledef
	  docdef
	  objs
	  tdms-uzc
	  tdms
	)
	)































;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;ХХХХХХХ заполняемс содержимое узла
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(defun tdms-fill-uzc (datalist
		      /
		      kus		; ename список колуч-ей
		      quantity		; int количество листов
		      strformat		; string имя формата листа
		      tdmsclassformat	; class соответствующий имени формата
		      new4ert		; object новый отъект чертежа
		      attquant		; tdms attribute количество листов
		      atttdmsformat	; tdms attribute формат
		      atttdmsqa4	; tdms attribute количество листов А4
		      qa4		; int
		      files		; container файлов объекта чертеж
		      nfile		; file новый добавляемый фалй
		      )

  ;(setq line (car drawings))
(foreach line datalist
  (setq kus (cadr line))
  (setq quantity (length kus))
  (setq strformat (norus (vl-string-left-trim "-" (format-detect (get-ftxte<-formatpts (get-formatpts<-rightformatline (get-rightformatline<-koluch (car kus))))))))
  (setq tdmsclassformat (vlax-invoke-method tdmsclassformats "Find" strformat))

  
  (setq new4ert (vlax-invoke-method tdms-uzc "Create" 4ertdef))
  (tdms-putatt new4ert "Номер листа" (car line))
  (tdms-putatt new4ert "Наименование документа" (get-sheetname (car kus)))
  (setq attquant (vlax-get-property (vlax-get-property new4ert "Attributes") "item" "ATTR_QUANTITY"))
  (vlax-put-property attquant "Value" quantity)
  (setq atttdmsformat (vlax-get-property (vlax-get-property new4ert "Attributes") "item" "ATTR_FORMAT"))
  (vlax-put-property atttdmsformat "Classifier" tdmsclassformat)
  (setq atttdmsqa4 (vlax-get-property (vlax-get-property new4ert "Attributes") "item" "ATTR_REPETITIONS"))
  (setq qa4 (eval (cons '+ (mapcar '(lambda (x) (formatstr->quanta4
	     (norus (vl-string-left-trim "-" (format-detect (get-ftxte<-formatpts
	     (get-formatpts<-rightformatline (get-rightformatline<-koluch x)))))))
	     ) kus))))
  (vlax-put-property atttdmsqa4 "Value" qa4)
  (setq files (vlax-get-property new4ert "Files"))
  (setq nfile (vlax-invoke-method files "Create" dwgfiledef (strcat uzfolder unum " л" (car line)".dwg")))
  (vlax-invoke-method nfile "CheckIn" (strcat uzfolder unum " л" (car line)".dwg"))
  
  (setq nfile (vlax-invoke-method files "Create" pdffiledef))
  (vlax-invoke-method nfile "CheckIn" (strcat uzfolder "BNP-" unum " л" (car line)".pdf"))
  (vlax-invoke-method new4ert "Update")
  );foreach
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(tdms-fill-uzc drawings)

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX























;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXX                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;                спецификация                                                          
;;;XXXXXXXXXXX                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(setq scale 1)
(setq tdmsfolder "d:/_TDMS/")
(setq kulist (get-kol-uch))
(setq unum (cdr (assoc 1 (entget (get-uznumber (car kulist))))))
;(setq unum "1744-1-АТМ3.С1")
(setq uzfolder (strcat tdmsfolder unum "/"))
(if (null (vl-file-directory-p uzfolder))
  (vl-mkdir uzfolder))


;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX       making a single file      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun mkfilespecdwg (kulst / pts sso)
  (setq sso (vla-get-ActiveSelectionSet #actdoc))
  (vla-Clear sso)
  (foreach ku kulst
    (setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch ku)))
    (vl-cmdf "_zoom" "_W" (car pts) (cadr pts))
    (vla-select sso acSelectionSetCrossing
      (vlax-3d-point (car pts))
      (vlax-3d-point (cadr pts)))
    )
  (vla-Wblock #actdoc (strcat uzfolder unum ".dwg") sso)
  (vla-Clear sso)
  (vlax-release-object sso)
  );defun


(mkfilespecdwg kulist)


;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX       save as 2004       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(setq files (VL-DIRECTORY-FILES uzfolder "*.dwg" 1))
(foreach file files
  (setq fullname (strcat uzfolder file))
  (setq docs (vla-get-Documents #cad))
  (setq $doc (vla-open docs fullname))
  (vla-put-LineweightDisplay (vla-get-Preferences $doc) :vlax-true)
  (vla-saveas $doc fullname ac2004_dwg)
  (vla-close $doc)
  )




;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX       making PDF's       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(pdfplotting)



;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX       pdf files merging  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun pdfmergespec (kulist / shell app)
  (setq shell (vlax-get-or-create-object "wscript.shell"))
  (setq app "\"c:\\Program Files\\AdultPDF\\Ap PDF Split-Merge\\pdfspme_cmd.exe\" ")
  (setq name (strcat uzfolder "BNP-" (cdr (assoc 1 (entget (get-uznumber (car kulist)))))))
  (while (vl-string-search "/" name) (setq name (vl-string-subst "\\" "/" name)))
  (setq filenames (mapcar
		    '(lambda (ku) (strcat name " л" (get-lnumber ku) ".pdf"))
		    (vl-sort kulist '(lambda (a b) (< (atoi (get-lnumber a)) (atoi (get-lnumber b)))))
		    ))
  (setq script (strcat app "-mer " (apply 'strcat (mapcar '(lambda (x) (strcat "-i \"" x "\" ")) filenames)) (strcat "-o \"" name ".pdf" "\"")))
  (vlax-invoke-method shell "run" script 1 :vlax-true)
  (mapcar 'vl-file-delete filenames)
  (vlax-release-object shell) (setq shell nil)
  );defun

(pdfmergespec kulist)
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX






(setq docdef (vlax-get-property objs "item" "Документ"))
(setq dwgfiledef (vlax-get-property filedefs "item" "FILE_DWG2000"))
(setq pdffiledef (vlax-get-property filedefs "item" "FILETYPE_PDF"))


(setq quantity (length kulist))
(setq strformat (norus (vl-string-left-trim "-" (format-detect (get-ftxte<-formatpts (get-formatpts<-rightformatline (get-rightformatline<-koluch (car kulist))))))))
(setq tdmsclassformat (vlax-invoke-method tdmsclassformats "Find" strformat))
(setq newdoc (vlax-invoke-method tdms-uzc "Create" docdef))
;(tdms-putatt newdoc "Номер листа" (car line))
(tdms-putatt newdoc "Обозначение документа" (cdr (assoc 1 (entget (get-uznumber (car kulist))))))
(tdms-putatt newdoc "Наименование документа" (get-sheetname (car kulist)))



(setq attquant (vlax-get-property (vlax-get-property newdoc "Attributes") "item" "ATTR_QUANTITY"))
(vlax-put-property attquant "Value" quantity)


(setq atttdmsformat (vlax-get-property (vlax-get-property newdoc "Attributes") "item" "ATTR_FORMAT"))
(vlax-put-property atttdmsformat "Classifier" tdmsclassformat)
(setq atttdmsqa4 (vlax-get-property (vlax-get-property newdoc "Attributes") "item" "ATTR_REPETITIONS"))

(setq qa4 (eval (cons '+ (mapcar '(lambda (x) (formatstr->quanta4
	(norus (vl-string-left-trim "-" (format-detect (get-ftxte<-formatpts
		(get-formatpts<-rightformatline (get-rightformatline<-koluch x)))))))
				    ) kulist))))
(vlax-put-property atttdmsqa4 "Value" qa4)

(setq files (vlax-get-property newdoc "Files"))
(setq nfile (vlax-invoke-method files "Create" dwgfiledef) (strcat uzfolder unum ".dwg"))
(vlax-invoke-method nfile "CheckIn" (strcat uzfolder unum ".dwg"))
(setq nfile (vlax-invoke-method files "Create" pdffiledef))
(vlax-invoke-method nfile "CheckIn" (strcat uzfolder "BNP-" unum ".pdf"))
(vlax-invoke-method newdoc "Update")



;(do (vlax-get-property tdms-uzc "item" 2))
;(vlax-invoke-method  (vlax-get-property tdms-uzc "item" 2) "Erase")
;(do (vlax-get-property (vlax-get-property (vlax-get-property tdms-uzc "item" 2) "Attributes") "item" 2))








;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXX       clearing memory       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(mapcar (function (lambda (x)
		    (if (not (vlax-object-released-p x))
		      (vlax-release-object x)
		      )))
	(list
	  nfile
	  files
	  atttdmsqa4
	  atttdmsformat
	  tdmsclassformat
	  tdmsclassformats
	  attquant
	  newdoc
	  pdffiledef
	  dwgfiledef
	  docdef
	  objs
	  tdms-uzc
	  tdms
	  ; обязательно в обратном порядке
	)
	)

  (setq	tdms nil)
  (prin1)








thx!