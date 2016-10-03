;;; 13_02_07

(setq ktz-pdfplotter "ktz_pdfgostplotter.pc3")
(setq ktz-pdfgostplotterconfigname "gostplotterconfig")


(defun ss-to-pdf ( /
		  ;cad
		  ;actdoc
		  actlay

		  kulist
		  unum
		  tdmsfolder
		  uzfolder
		  plot
		  plotconfs
		  pltcfg
		  pts
		  sheetnum
		  uznum
		  targ
		  )
  (vl-load-com)
  (setq targ (getvar "TARGET"))
;;;  (setq cad (vlax-get-acad-object)
;;;	actdoc (vla-get-activedocument cad))
  
  (setq actlayout (vla-get-activelayout #actdoc))
  (setq kulist (get-kol-uch))
  ;;;(setq ku (car kulist))
  (setq scale (/ (cdr (assoc 40 (entget (car kulist)))) 2.5))
  (setq unum (cdr (assoc 1 (entget (get-uznumber (car kulist))))))
  (setq tdmsfolder "D:/_TDMS/")
  (setq uzfolder (strcat tdmsfolder unum "/"))

  ;(setq ktz-pdfplotter "ktz_pdfgostplotter.pc3")
  ;(setq ktz-pdfplotter "DWG To PDF.pc3")
  ;(setq ktz-pdfgostplotterconfigname "gostplotterconfig")
  ;(vla-delete (vla-item plotconfs 0))


  (setq plot (vla-get-plot #actdoc))
  (setq plotconfs (vla-get-PlotConfigurations #actdoc))


  ;(vla-item plotconfs ktz-pdfgostplotterconfigname)
  ;(vla-item plotconfs "dfg")
  
  (setq pltcfg (vla-add plotconfs ktz-pdfgostplotterconfigname :vlax-true))
  (vla-put-ConfigName pltcfg ktz-pdfplotter)
  (vla-put-CenterPlot pltcfg :vlax-true)

  (foreach ku kulist
    ;(setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch (car kulist))))
    (setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch ku)))



    ;(vla-get-CanonicalMediaName pltcfg)
    ;(vla-get-CanonicalMediaName actlayout)
    (vla-put-CanonicalMediaName pltcfg (strcat "UserDefinedMetric (" (rtos (/ (- (caadr pts) (caar pts)) scale)) ".00 x " (rtos (/ (- (cadadr pts) (cadar pts)) scale))".00MM)"))
    ;(vla-put-CanonicalMediaName pltcfg "UserDefinedMetric (594.00 x 841.00MM)")


    
    (vla-SetWindowToPlot actlayout
      ;(vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1))(car pts))		;;; вариант без смещения TARGET
      ;(vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(cadr pts)))		;;; вариант без смещения TARGET
      ;;;  вариант со смещением targetа, возможо надо будет корректировка при другом масштабе
      (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- (car pts) targ))
      (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(mapcar '- (cadr pts) targ)))

    ;(vla-Regen #actdoc acAllViewports)
    

    ;(vla-put-plotType pltcfg acWindow)
    ;(vla-put-plotType pltcfg 4)
    ;;;;;;
    (vla-put-plotRotation pltcfg ac0degrees)
    ;;;;;;
    (vla-put-StyleSheet pltcfg "monochrome.ctb")
    (vla-RefreshPlotDeviceInfo pltcfg)
    (vla-copyfrom actlayout pltcfg)
    (vla-RefreshPlotDeviceInfo actlayout)
    (vla-Regen #actdoc acAllViewports)
    
    (setq sheetnum (get-lnumber ku))
    (setq uznum (cdr (assoc 1 (entget (get-uznumber ku)))))
    (vla-plotToFile plot (strcat uzfolder "BNP-" uznum " л" sheetnum ".pdf"))
    ;(vla-plotToFile plot "D:\123.pdf")
    (vlax-release-object plot)
    );foreach

  );defun

;;;
;;;
;;;(defun zxc ( /
;;;	    cad
;;;	    actdoc
;;;	    )
;;;  (setq cad (vlax-get-acad-object)
;;;	actdoc (vla-get-activedocument cad))
;;;  
;;;  );defun