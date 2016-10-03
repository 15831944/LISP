;;; 13_02_26
 ;;; работает на 2008 акаде с pdf-hotfix (обновленный pdfplot9.hdi)
  (vl-load-com)

(defun ss-to-pdf ( /
		  targ
		  kulist
		  scale
		  tdmsfolder
		  plotconfs
		  pltcfg
		  pts
		  sheetnum
		  uznum
		  actlayout
		  plot
		  )
  (setq targ (getvar "TARGET"))
  (setq kulist (get-kol-uch))
  (setq scale (/ (cdr (assoc 40 (entget (car kulist)))) 2.5))
  (setq tdmsfolder "D:/_TDMS/")
  
  ;2013
  ;(setq ktz-pdfplotter "ktz_pdfgostplotter.pc3")
  ;(setq ktz-pdfgostplotterconfigname "gostplotterconfig")
  ;2008
  (setq ktz-pdfplotter "ktz_pdf_plotter_2008.pc3")
  (setq ktz-pdfgostplotterconfigname "gostplotterconfig")  
  ;(setq ktz-pdfplotter "ktz_pdfgostplotter.pc3")
  ;(setq plotter "ktz_pdf_plotter_2008.pc3")
  ;(setq plotter "DWG To PDF.pc3")

  
  (setq plotconfs (vla-get-PlotConfigurations #actdoc))
  (setq pltcfg (vla-add plotconfs ktz-pdfgostplotterconfigname :vlax-true))


  
  (foreach ku kulist
    (setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch ku)))
    (vla-SetWindowToPlot pltcfg
      ;(vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1))(car pts))		;;; вариант без смещения TARGET
      ;(vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(cadr pts)))		;;; вариант без смещения TARGET
      ;;;  вариант со смещением targetа, возможо надо будет корректировка при другом масштабе
      (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- (car pts) targ))
      (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(mapcar '- (cadr pts) targ)))
    (vla-put-plotType pltcfg acWindow)
    (vla-put-ConfigName pltcfg ktz-pdfplotter)
    (vla-put-CanonicalMediaName pltcfg
      (strcat "UserDefinedMetric ("
	      (rtos (/ (- (caadr pts) (caar pts)) scale))
	      ".00 x "
	      (rtos (/ (- (cadadr pts) (cadar pts)) scale))
	      ".00MM)"))
    (vla-put-PlotRotation pltcfg ac0degrees)
    (vla-put-centerplot pltcfg :vlax-true)
    (vla-put-StyleSheet pltcfg "monochrome.ctb")
    (setq sheetnum (get-lnumber ku))
    (setq uznum (cdr (assoc 1 (entget (get-uznumber ku)))))
    (setq uzfolder (strcat tdmsfolder uznum "/"))
    (if (null (vl-file-directory-p uzfolder))
      (vl-mkdir uzfolder)
      )
    (setq actlayout (vla-get-ActiveLayout #actdoc))
    (vla-copyfrom actlayout pltcfg)
    (setq plot (vla-get-plot #actdoc))
    (vla-plotToFile plot (strcat uzfolder "BNP-" uznum " л" sheetnum ".pdf") ktz-pdfplotter)
    );foreach
  (vlax-release-object plot)
  (setq plot nil)
  (vlax-release-object actlayout)
  (setq actlayout nil)
  (vlax-release-object pltcfg)
  (setq pltcfg nil)
  (vlax-release-object plotconfs)
  (setq plotconfs nil)
  );defun

