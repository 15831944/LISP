;;; 14_03_28 - не менять - версия файла
(vl-load-com)
;; файл ssplot-ex 14_03_28.LSP
;; Пояснения к программе :
;; Программа позволяет вывести на печать несколько чериежей выделив их "скопом"

;; ЗАПУСК программы производится из командной строки автокада путем ввода букв:
;; kd:plot[enter]





(setq #pdfpc3 "ktz_pdfgostplotter.pc3")
(setq #pdfpmp "ktz_pdfgostplotter.pmp")
(setq ktz-pdfgostplotterconfigname "gostplotterconfig")




(defun c:kd:plot ( / reg:devices)
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0)T))
  (setq reg:devices "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Devices")
  (setq #pdfpc3 (kd:dcl:pick-from-list (cons "ktz_pdfgostplotter.pc3" (vl-registry-descendents reg:devices "*"))))
  (kd:plot)
  (acet-error-restore)
  (vla-endundomark #actdoc)  
  );defun




(defun kd:plot ( / plt:folder sset lst)
  (if (null (vl-file-directory-p (setq plt:folder "d:/_TDMS/"))) (vl-mkdir plt:folder))
  (if (null (vl-file-directory-p plt:folder)) (vl-mkdir plt:folder) )
  (setq sset   (vla-get-ActiveSelectionSet #actdoc))
  (vla-clear sset)
  (vla-SelectOnScreen sset (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0)) (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("*")))
  (cond
    ; если есть блок "format"
    ((setq lst (vl-remove-if-not
		 '(lambda (o)
		    (and
		      (= "AcDbBlockReference" (vla-get-ObjectName o))
		      (member (vla-get-EffectiveName o) '("format-spec" "format" "РФ_format-spec" "РФ_format"))
		      )) (KD-CONTAINER->LIST sset)))
     (plt:plot-blocks-formats (vl-sort lst '(lambda (a b) (< (atoi (vla-get-TextString (getbatt a "НОМЕР_ЛИСТА")))(atoi (vla-get-TextString (getbatt b "НОМЕР_ЛИСТА")))))))
     )
    ; если просто набор
    (T (plt:plot-pts (getBoundSS sset)))
    );cond
  );defun






(defun plt:plot-blocks-formats (frmtlst / scale targ plot plotconfs pltcfg canlst namlst sheetnum uznum )
  (setq scale (vla-get-XEffectiveScaleFactor (car frmtlst)))
  (setq targ (getvar "TARGET"))
  (setq plotconfs (vla-get-PlotConfigurations #actdoc))
  (setq pltcfg (vla-add plotconfs ktz-pdfgostplotterconfigname :vlax-true))  
  (mapcar
    ;(setq fo (car frmtlst))
    '(lambda (fo / p1 p2 pts )
       (vla-GetBoundingBox fo 'p1 'p2)
       (setq pts (list (reverse (cdr (reverse (vlax-safearray->list p1)))) (reverse (cdr (reverse (vlax-safearray->list p2))))))
       (vla-SetWindowToPlot pltcfg
	 (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- (car pts) targ))
	 (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- (cadr pts) targ)))
       (vla-put-plotType pltcfg acWindow)
       (vla-put-ConfigName pltcfg #pdfpc3)
       (setq canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames pltcfg))))
       (setq namlst(mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
       (cond
	 ;((= "ktz_pdf_plotter_2008.pc3" #pdfpc3)
	 ((= "ktz_pdfgostplotter.pc3" #pdfpc3)
	  (vla-put-CanonicalMediaName pltcfg
	    (nth (vl-position (strcat
	     (if (> (abs (- (car (car pts)) (car (cadr pts))))
		    (abs (- (cadr (car pts)) (cadr (cadr pts)))))
	       "w" "v") (vl-string-translate "Ах" "Ax" (vla-get-TextString (getbatt fo "FORMAT_NAME"))))
		   namlst)canlst))
	  (vla-put-PlotRotation pltcfg ac0degrees)
	  )
	 (T
	  (vla-put-CanonicalMediaName pltcfg "A4")
	  (vla-put-PlotRotation pltcfg ac90degrees)
	  )
	 )
       (vla-put-centerplot pltcfg :vlax-true)
       ;(vla-put-StyleSheet pltcfg "monochrome.ctb")
       (setq sheetnum (vla-get-TextString (getbatt fo "НОМЕР_ЛИСТА")))
       (setq uznum (vla-get-TextString (getbatt fo "НОМЕР_УЗЛА")))
       (vla-copyfrom (vla-get-ActiveLayout #actdoc) pltcfg)
       (setq plot (vla-get-plot #actdoc))
       ;если вылетает тут, то посмотреть действительно есть ли эта папка
       (cond
	 ((= "ktz_pdfgostplotter.pc3" #pdfpc3) (vla-plotToFile plot (strcat plt:folder "BNP-" uznum " л" sheetnum ".pdf") #pdfpc3))
	 (T (vla-plotToDevice plot #pdfpc3))
	 )
       (princ)
       )
    frmtlst
    );mapcar
  (vlax-release-object plot)
  (setq plot nil)
  (vlax-release-object pltcfg)
  (setq pltcfg nil)
  (vlax-release-object plotconfs)
  (setq plotconfs nil)
  );defun







;;; печать просто набора
(defun plt:plot-pts (pts / scale targ plot plotconfs pltcfg canlst namlst )
  (setq scale 1)
  (setq targ (getvar "TARGET"))
  (setq plotconfs (vla-get-PlotConfigurations #actdoc))
  
  (setq pltcfg (vla-add plotconfs ktz-pdfgostplotterconfigname :vlax-true))
  (vla-SetWindowToPlot pltcfg
    (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- (car pts) targ))
    (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- (cadr pts) targ)))
  (vla-put-plotType pltcfg acWindow)
       (vla-put-ConfigName pltcfg #pdfpc3)
       (setq canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames pltcfg))))
       (setq namlst(mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
  (cond
    ;((= "ktz_pdf_plotter_2008.pc3" #pdfpc3)
    ((= "ktz_pdfgostplotter.pc3" #pdfpc3)
     (vla-put-CanonicalMediaName pltcfg
       (nth (vl-position (VL-STRING-SUBST "" "-" (formatassoc pts)) namlst)canlst))
     (vla-put-PlotRotation pltcfg ac0degrees)
     )
    (T
     (vla-put-CanonicalMediaName pltcfg "A4")
     (vla-put-PlotRotation pltcfg ac90degrees)
     )
    );cond
  (vla-put-centerplot pltcfg :vlax-true)
  ;(vla-put-StyleSheet pltcfg "monochrome.ctb")
  (vla-copyfrom (vla-get-ActiveLayout #actdoc) pltcfg)	
  (setq plot (vla-get-plot #actdoc))
  ;если вылетает тут, то посмотреть действительно есть ли эта папка
  (cond
    ;((= "ktz_pdf_plotter_2008.pc3" #pdfpc3)
    ((= "ktz_pdfgostplotter.pc3" #pdfpc3)
     (princ (strcat "\nPlotting to file in folder " plt:folder "\n"))
     (vla-plotToFile plot (strcat plt:folder "BNP-" "any-plot" ".pdf") #pdfpc3)
     )
    (T
     (vla-plotToDevice plot #pdfpc3)
     )
    );cond
  (vlax-release-object plot)
  (setq plot nil)
  (vlax-release-object pltcfg)
  (setq pltcfg nil)
  (vlax-release-object plotconfs)
  (setq plotconfs nil)
  (princ)
  (princ plt:folder)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kd:dcl:pick-from-list (items / itemsdcl dlgname dclfilename dcl-file-path hand dcl_id strlist i out)
  (defun dcl:formatstring (str / val tail)
    (if (vl-string-search "\"" str)
	 (progn
	   (setq val (reverse (sepstr str "\"")))
	   (setq tail (car val))
	   (setq val (mapcar '(lambda (s) (strcat s "\\\"")) (reverse (cdr val))))
	   (setq val (strcat (apply 'strcat val) tail))
	   )
	 str
	 )
    );defun
  (setq itemsdcl (mapcar 'dcl:formatstring items))
  (setq dlgname "pick_from_lst")	; must NOT contain "-"
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  ;-----------------------------------------------------------
  (defun kd:dcl-pfl_done ( / out)
    (setq out (get_tile (strcat dlgname "key")))
    (done_dialog)
    out
    );defun
  ;-----------------------------------------------------------  

  ;;;;*******************************************************************

  (setq dcl-file-path (strcat (getenv "temp") dclfilename)
	hand (open dcl-file-path "w"))
  
  ;;; генерация dcl-файла
  (mapcar '(lambda (x) (write-line x hand))
	  (list
	    dlgname
	    ": dialog"
	    "{label=\"kakt00z developing dcl-pick-from-list window\";"
	    "width=80;"
	    ":list_box{"
	    	(strcat "label=\"Select an item ... "  "\";" )
	    	(strcat "key=\""  dlgname "key\";")
		(strcat "list=\""
		   (eval (append '(strcat) (mapcar '(lambda (x) (strcat x "\\n")) itemsdcl)))
			"\";");strcat
	    	"fixed_width_font=false;"
	    "}"
	    ":spacer{width=1;}"
	    "ok_cancel;"
	    "}"
	    ))
  (close hand)
  ;;;;*******************************************************************
  
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0)
	  (not (new_dialog dlgname dcl_id)))
    (exit)
    ) ;if

  (action_tile "accept"		"(setq out (kd:dcl-pfl_done))")
  (action_tile "is_default"	"(setq out (kd:dcl-pfl_done))")
  (action_tile "cancel" 	"(done_dialog 0)")
  (start_dialog)
  (unload_dialog dcl_id)
  (nth (atoi out) items)
  );defun




;;; 13_07_26
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
(defun getBoundSS (sset / listmin listmax minp maxp minx miny maxx maxy)
(setq listmin '() listmax '() minp nil maxp nil)
(vlax-for anEntity sset
    (progn
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
(defun formatassoc (ptlist / dopusk size tmp)
  (setq dopusk 2)
  (setq size (mapcar '(lambda (a b ) (abs (- a b))) (cadr ptlist) (car ptlist)))
  (while
    (null (setq tmp (vl-member-if
	   '(lambda (x)
	      (and (< (abs (- (cadr size) (caddr x))) dopusk)
		   (< (abs (- (car size) (cadr x))) dopusk))
	      )
	   #gostformats)
		))
    (setq dopusk (+ 2 dopusk))
    )
(car (car tmp))
);defun





(defun ktzplotter|init ( / acpf PrinterConfigPath PrinterDescPath pc3path pmppath)
  (setq acpf (vla-get-Files (vla-get-Preferences #cad)))
  (setq PrinterConfigPath (vla-get-PrinterConfigPath acpf))
  (if (null (findfile (strcat PrinterConfigPath "/" #pdfpc3)))
    (progn
      (setq pc3path (getfiled "Укажите файл ktz_pdfgostplotter.pc3 " #pdfpc3 "pc3" 64))
      (if pc3path (vl-file-copy pc3path (strcat PrinterConfigPath "\\" #pdfpc3) nil))
      )
    )
  (setq PrinterDescPath (vla-get-PrinterDescPath acpf))
  (if (null (findfile (strcat PrinterDescPath "/" #pdfpmp)))
    (progn
      (setq pmppath (getfiled "Укажите файл ktz_pdfgostplotter.pmp " #pdfpmp "pmp" 64))
      (if pmppath (vl-file-copy pmppath (strcat PrinterDescPath "\\" #pdfpmp) nil))
      )
    )
  );defun

(defun kd-container->list (objc / lst)
  (vlax-for o objc (setq lst (append lst (list o))))
  lst
  )



(ktzplotter|init)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;