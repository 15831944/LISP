;;; version  12_10_24
;(command "_-scalelistedit" "С" "Д" "В")

;(command "_-scalelistedit" "R" "Y" "E")

(VL-LOAD-COM)
(setq #cad (vlax-get-acad-object)
      #actdoc (vla-get-activedocument #cad)
      #modspace (vla-get-modelspace #actdoc))




;;;*****************************************************************************
;;;*****************************************************************************
(setq #lisppath "D:\\_LISP\\")
;;;*****************************************************************************
;;; смотреть vla-get-Version #cad
(load (strcat #lisppath "strings\\strcut.lsp"))



(setq catchit
       (vl-catch-all-apply
	 'vla-GetInterfaceObject
	 (list #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2)))
	 )
      )

;;;(if (vl-catch-all-error-p catchit)
;;;  (setq catchit
;;;	 (vl-catch-all-apply
;;;	   'vla-GetInterfaceObject
;;;	   (list #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2)))
;;;	   )
;;;	)
;;;  )
;(VL-CATCH-ALL-ERROR-MESSAGE catchit)
(if (= (type catchit) 'VLA-OBJECT)
  (progn
    (setq #color catchit)
    (vla-SetRGB #color 250 100 100)
    (setq catchit nil)
    )
  );if

;;; далее будем программировать так
(princ (strcat
	 "\n"
	 "функции с префиксом \"c:\" - ввод из ком строки"
	 "\n"
	 "функции с префиксом \"g:\"  - укакзание одиночных объектов"
	 "\n"
	 "функции с префиксом \"ss:\" - укакзание наборами ssget"
	 "\n"	 
	 "функции без префикса     - требующие аргументов"
	 "\n"
	 "функции с постфиксом \"*\" - укакзание наборами ssget без сортировки"
	 "\n"
	 "переменные ПРЕфиксом \"*\" - при междокументной работе"
	 "\n"
	 "переменные префиксом \"#\" - глобальные по документу"
	 "\n"
	 ))




;;;*****************************************************************************
;;;*******   словари расширенных данных [графических элементов]   **************
;;;*******                ExtensionDictionary                     **************
;;;*****************************************************************************
;;; d:\LISP WORKING\field\ktzfieldlinks.LSP
(setq #kflsrcID "kflsourceID")		;hand объекта-источника поля
(setq #kfldestID "kfldestID")		;hand объекта(ов) приемников поля
(setq #current-selection-set nil)
;;;*****************************************************************************
;;;*****************************************************************************



;;;*****************************************************************************
;;;*******   глобальные словари #actdoc расширений   ***************************
;;;*******      (vla-get-Dictionaries #actdoc)       ***************************
;;;*****************************************************************************
;;;  d:\LISP WORKING\XRecordData\xrecdata2.LSP
;;; (setq #kksdictname "KD_branches")	;сыорй вариант для KKS-веток в ФС
;;;*****************************************************************************
;;;*****************************************************************************




(defun ktz-load	(/ path flist fnames)
  (vl-file-directory-p #lisppath)
  

;;;*****************************************************************************
;;;   Attribs in block
;;;*****************************************************************************
  
  (setq path "blocks and attribs\\")
  (setq	fnames (list
		 "ktz-attedit.LSP"
 		 "ktz-reset-block.lsp"
		 "copy block atts.LSP"		 
		)
  )
  (foreach f fnames
    (load (strcat #lisppath path f))
  );foreach

;;;*****************************************************************************
;;;   TEXT & MTEXT
;;;*****************************************************************************
  
  (setq path "TEXT & MTEXT\\")
  (setq	fnames (list
		 "center-txt.lsp"
		 "justification\\txtjust.LSP"
		 "txt-to-mtxt\\txt-to-mtxt.LSP"
		)
  )
  (foreach f fnames
    (load (strcat #lisppath path f))
  );foreach


;;;*****************************************************************************
;;;   common functions
;;;*****************************************************************************
  
  (setq path "common functions/")
  (setq	fnames (list
		 ;"ktz-get-blk-attrib-ename-by-pt.lsp"
		 ;"ktz-get-blk-attrib-ename.LSP"
		 ;"ktz-move-block-to-pt.LSP"
		 ;"ktz-move-line-to-pt.LSP"
		 ;"text-int-adj.lsp"
		 "to-layer.lsp"
		 ;"ktz-line-length.lsp"
		 ;"vector.lsp"
		 "mleader-format.LSP"
		 "ss-to-lst.LSP"
		 "put-linear-dimention.lsp"
		 "do.lsp"
		 "getbatt.lsp"
		 "getbdyn.lsp"
		 "mapcarx.lsp"
		 "format-identification-gost.lsp"
		 "lst-to-ss.LSP"
		 "ss-to-tbl.LSP"
		 "ss-odd.LSP"
		 "zoomtohand.lsp"
		 "anti-spds-textstyles.LSP"
		 "pickobj.LSP"
		 "kd-pick-from-list.LSP"
		 "diap.LSP"
		 "get-ssofstrobj.LSP"
		)
  )


  (foreach f fnames
    (load (strcat #lisppath path f))
  );foreach


;;;*****************************************************************************
;;;   field
;;;*****************************************************************************

  (setq path "field\\")
  (setq	fnames (list
		 ;"ktz-paste-field.LSP"
		 "ktz-txtcopy.LSP"
		 "get-fld-owner.LSP"
		 "ktz-field-delete.lsp"
		 "ktzfieldlinks.LSP"
		 "field-repare.LSP"
		 "getfieldcode.lsp"
		)
  )
  (foreach f fnames
    (load (strcat #lisppath path f))
  );foreach


;;;*****************************************************************************
;;;   connecting
;;;*****************************************************************************

  (setq path "connecting\\")
  (setq	fnames (list
		 "connect.LSP"
		 "getcm.LSP"

		)
  )
  (foreach f fnames
    (load (strcat #lisppath path f))
  );foreach

  
  
;;;*****************************************************************************
;;;   strings
;;;*****************************************************************************

  (setq path "strings\\")
  (setq	fnames (list
		 "any-to-string.lsp"
		 "sufx.LSP"
		 "lisplist.LSP"
		 "editmark.LSP"
		 "str-antimtext.lsp"
		 "norus.lsp"
		 "kd-get-Textstring.LSP"
		)
  )
  (foreach f fnames
    (load (strcat #lisppath path f))
  );foreach
  
  ;sufx.LSP
  
  
  
  
;;;*****************************************************************************
;;;   Other
;;;*****************************************************************************
 
  (load (strcat #lisppath "excel\\tbl-to-excel.LSP"))
  (load (strcat #lisppath "считалка\\kd-anum-v2.2.LSP"))
  ;(load (strcat #lisppath "Построения\\ktz-klamp-sort.LSP"))
  (load (strcat #lisppath "Построения\\aligning.LSP"))
  (load (strcat #lisppath "Построения\\arrange blocks.LSP"))
  ;;;;;;(load (strcat #lisppath "Взрывание\\cleanup.LSP"))
  (load (strcat #lisppath "Explode\\clean.LSP"))
  (load (strcat #lisppath "PLOT\\ssplot.LSP"))
  (load (strcat #lisppath "быстрый выбор\\ktz_pick.LSP"))
  (load (strcat #lisppath "быстрый выбор\\kd-block-filter-by-att.LSP"))
  (load (strcat #lisppath "colored\\ktz-colored.LSP"))
  (load (strcat #lisppath "colored\\ktz-colored-0.LSP"))
  (load (strcat #lisppath "MASS COPY\\txt-mass-copy.LSP"))
  (load (strcat #lisppath "MASS COPY\\relcopy.LSP"))
  (load (strcat #lisppath "Files\\shell.LSP"))
  (load (strcat #lisppath "Files\\file-to-list.LSP"))
  (load (strcat #lisppath "DCL\\dcledt.LSP"))
  (load (strcat #lisppath "DCL\\dcl-pick-from-list.LSP"))
  (load (strcat #lisppath "DCL\\dclget.LSP"))
  (load (strcat #lisppath "hyperlinks\\put-hyper-remark.LSP"))
  (load (strcat #lisppath "XRecordData\\xrecs.LSP"))
  
  (prompt (strcat "\n *** ktz-load is done ***\nto edit autoload file - look for " #lisppath " folder\n"))


;;;*****************************************************************************
;;;   Некоторые начальные настройки рабочего пространства
;;;*****************************************************************************

(setvar "INETLOCATION" "")
(setvar "griptips" 0)
(setvar "snapunit" '(0.5 0.5 ))
(setvar "textsize" 2.5)
;(setvar "textstyle" "GOST 2.304")
;(setvar "textstyle" "gost")
(setvar "mirrtext" 0)
(setvar "HPANG" 0.0)
(setvar "HPNAME" "ANSI31")
(setvar "ZOOMFACTOR" 60)
(setvar "CURSORSIZE" 100)
(setvar "BLIPMODE" 0)
(setvar "TSPACETYPE" 2)
(setvar "TSPACEFAC" 1.92)
(setvar "INSUNITS" 4)
(setvar "osmode" 4159)


(load (strcat #lisppath "клавиатура адаптация anti-rus.LSP"))  
);defun

(ktz-load)


