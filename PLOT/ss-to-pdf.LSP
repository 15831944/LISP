(defun ss-to-pdf ( /
;;;		  cad
;;;		  actdoc
;;;		  actlay
;;;
;;;		  kulist
;;;		  unum
;;;		  tdmsfolder
;;;		  uzfolder
;;;		  ktz-pdfplotter
;;;		  ktz-pdfgostplotterconfigname
;;;		  plot
;;;		  plotconfs
;;;		  pltcfg
;;;		  pts
;;;		  sheetnum
;;;		  uznum
		  )
  (vl-load-com)
  (setq cad (vlax-get-acad-object)
	actdoc (vla-get-activedocument cad)
	actlayout (vla-get-activelayout actdoc))

  (setq kulist (get-kol-uch))
  ;;;(setq ku (car kulist))
  (setq scale (/ (cdr (assoc 40 (entget (car kulist)))) 2.5))
  (setq unum (cdr (assoc 1 (entget (get-uznumber (car kulist))))))
  (setq tdmsfolder "d:/!!! TDMS/")
  (setq uzfolder (strcat tdmsfolder unum "/"))

  (setq ktz-pdfplotter "ktz_pdfgostplotter.pc3")
  (setq ktz-pdfgostplotterconfigname "gostplotterconfig")
  ;(vla-delete (vla-item plotconfs 0))


  (setq plot (vla-get-plot actdoc))
  (setq plotconfs (vla-get-PlotConfigurations actdoc))
  (setq pltcfg (vla-add plotconfs ktz-pdfgostplotterconfigname :vlax-true))
  (vla-put-ConfigName pltcfg ktz-pdfplotter)

  (foreach ku kulist
    (setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch ku)))



    ;(vla-get-CanonicalMediaName pltcfg)
    ;(vla-get-CanonicalMediaName actlayout)
    (vla-put-CanonicalMediaName pltcfg (strcat "UserDefinedMetric (" (rtos (/ (- (caadr pts) (caar pts)) scale)) ".00 x " (rtos (/ (- (cadadr pts) (cadar pts)) scale))".00MM)"))
    ;(vla-put-CanonicalMediaName pltcfg "UserDefinedMetric (594.00 x 841.00MM)")
    
    (vla-SetWindowToPlot pltcfg (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(car pts))(vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(cadr pts)))
    (vla-put-plotType pltcfg 4)
    ;;;;;;
    (vla-put-plotRotation pltcfg ac0degrees)
    ;;;;;;
    (vla-put-StyleSheet pltcfg "monochrome.ctb")
    (vla-copyfrom actlayout pltcfg)
    
    (setq sheetnum (get-lnumber ku))
    (setq uznum (cdr (assoc 1 (entget (get-uznumber ku)))))
    (vla-plotToFile plot (strcat uzfolder "BNP-" uznum " ë" sheetnum ".pdf"))
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