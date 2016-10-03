;;; 13_05_23
;;; 14_03_28
;;; 14_12_01

(setq block-format-names-allowed '("format-spec" "tekon_format"))
(load (strcat #lisppath "PLOT\\plotlib.lsp"))
(setq #pdfpc3 "ktz_pdfgostplotter.pc3")
(setq #pdfpmp "ktz_pdfgostplotter.pmp")
(setq ktz-pdfgostplotterconfigname "gostplotterconfig")


(defun t|plotter|init ( / acpf PrinterConfigPath PrinterDescPath pc3path pmppath)
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
      (setq pmppath (getfiled "Укажите файл ktz_pdfgostplotter.pc3 " #pdfpmp "pc3" 64))
      (if pmppath (vl-file-copy pmppath (strcat PrinterDescPath "\\" #pdfpmp) nil))
      )
    )
  );defun
(t|plotter|init)

;(setq #pdfpc3 "ktz_pdf_plotter_2008.pc3")
;(setq #pdfpc3 "ktz_pdfgostplotter.pc3")
;(setq #pdfpc3 "\\\\Yakubovich-t410\\HP LaserJet 1020")






(defun c:t|plot ( / reg:devices)
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0)T))
  (setq reg:devices "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Devices")
  (setq #pdfpc3 (kd:dcl:pick-from-list (cons "ktz_pdfgostplotter.pc3" (vl-registry-descendents reg:devices "*"))))
  (t|plot)
  (acet-error-restore)
  (vla-endundomark #actdoc)  
  );defun




(defun t|plot ( / plt:folder sset lst)
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
		      (member (vla-get-EffectiveName o) block-format-names-allowed)
		      )) (KD-CONTAINER->LIST sset)))
     ;(plt:plot-blocks-formats (vl-sort lst '(lambda (a b) (< (atoi (vla-get-TextString (getbatt a "НОМЕР_ЛИСТА")))(atoi (vla-get-TextString (getbatt b "НОМЕР_ЛИСТА")))))))
     (plt:t|plot-blocks-formats (vl-sort lst '(lambda (a b) (< (atoi (vla-get-TextString (getbatt a "DRAWING_NUMBER" )))(atoi (vla-get-TextString (getbatt b "DRAWING_NUMBER")))))))
     )
    ; если просто набор
    (T (plt:t|plot-pts (getBoundSS sset)))
    );cond
  );defun





;(setq frmtlst (vl-sort lst '(lambda (a b) (< (atoi (vla-get-TextString (getbatt a "DRAWING_NUMBER" )))(atoi (vla-get-TextString (getbatt b "DRAWING_NUMBER")))))))

(defun plt:t|plot-blocks-formats (frmtlst / scale targ plot plotconfs pltcfg canlst namlst sheetnum uznum filename ext i)
  (setq scale (vla-get-XEffectiveScaleFactor (car frmtlst)))
  (setq ext ".pdf")
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
       (setq namlst (mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
       (cond
	 ;((= "ktz_pdf_plotter_2008.pc3" #pdfpc3)
	 ((= "ktz_pdfgostplotter.pc3" #pdfpc3)
	  (vla-put-CanonicalMediaName pltcfg
	    (nth (vl-position (strcat
	     (if (> (abs (- (car (car pts)) (car (cadr pts))))
		    (abs (- (cadr (car pts)) (cadr (cadr pts)))))
	       "w" "v") (vl-string-translate "Ах" "Ax" (vla-get-TextString (getbatt fo "FORMATNAME"))))
		   namlst)canlst))
	  (vla-put-PlotRotation pltcfg ac0degrees)
	  )
	 (T
	  (vla-put-CanonicalMediaName pltcfg "A4")
	  (vla-put-PlotRotation pltcfg ac90degrees)
	  )
	 )
       (vla-put-centerplot pltcfg :vlax-true)
       (vla-put-StyleSheet pltcfg "monochrome.ctb")
       (setq sheetnum (kd-get-TextString (cond ((getbatt fo "НОМЕР_ЛИСТА")) ((getbatt fo "DRAWING_NUMBER")))))
       (cond
	 ((< (atof* sheetnum) 10)
	  (setq sheetnum (strcat "0" sheetnum))
	  )
	 )
       (setq uznum (kd-get-TextString (cond ((getbatt fo "НОМЕР_УЗЛА")) ((getbatt fo "PROJECT_NUMBER")))))
       (vla-copyfrom (vla-get-ActiveLayout #actdoc) pltcfg)
       (setq plot (vla-get-plot #actdoc))
       ;если вылетает тут, то посмотреть действительно есть ли эта папка
       (cond
	 ((= "ktz_pdfgostplotter.pc3" #pdfpc3)
	  (setq filename (strcat plt:folder uznum "_" sheetnum))
	  (if (findfile (strcat filename ext))
	    (progn
	      (setq i 0)
	      (setq filename (strcat plt:folder uznum "_" sheetnum "[" (itoa i) "]"))
	      (while (findfile (strcat filename ext))
		(setq filename (strcat plt:folder uznum "_" sheetnum "[" (itoa (setq i (1+ i))) "]"))
		)
	      )
	    )
	  (vla-plotToFile plot (strcat filename ext) #pdfpc3)
	  )
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
(defun plt:t|plot-pts (pts / scale targ plot plotconfs pltcfg canlst namlst filename ext i)
  (setq scale 1)
  (setq ext ".pdf")
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
  (vla-put-StyleSheet pltcfg "monochrome.ctb")
  (vla-copyfrom (vla-get-ActiveLayout #actdoc) pltcfg)	
  (setq plot (vla-get-plot #actdoc))
  ;если вылетает тут, то посмотреть действительно есть ли эта папка
  (cond
    ;((= "ktz_pdf_plotter_2008.pc3" #pdfpc3)
    ((= "ktz_pdfgostplotter.pc3" #pdfpc3)
     (princ (strcat "\nPlotting to file in folder " plt:folder " format :  " (formatassoc pts) "\n"))
     (setq i 0) (setq filename (strcat plt:folder "BNP-" "any-plot" "[" (itoa i) "]"))
     (while (findfile (strcat filename ext)) (setq filename (strcat plt:folder "BNP-" "any-plot" "[" (itoa (setq i (1+ i))) "]")))
     (vla-plotToFile plot (strcat filename ext) #pdfpc3)
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


