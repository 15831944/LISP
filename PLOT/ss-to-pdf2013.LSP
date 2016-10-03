;;;  13_02_07

(setq tdmsfolder "d:/_TDMS/")
(setq ktz-pdfplotter "ktz_pdfgostplotter.pc3")
(setq ktz-pdfgostplotterconfigname "gostplotterconfig")

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;’’’’’’’ вспомогательные функции
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(load (strcat #lisppath "DataBase\\dblib.lsp"))
(load (strcat #lisppath "common functions/sssum.lsp"))
(load (strcat #lisppath "common functions/format-identification-gost.lsp"))






(defun ss-to-pdf ( /
		  kulist
		  scale
		  sheets
		  zipsheets
		  drawings
		  unum
		  uzfolder
		  targ
		  plotconfs
		  pltcfg
		  pts
		  canlist
		  namlist
		  sheetnum
		  uznum
		  actlayout
		  plot
		  i
		  )
  
  (setq kulist (get-kol-uch))
  (setq scale (/ (cdr (assoc 40 (entget (car kulist)))) 2.5))
  (princ (strcat "\n" (itoa (length kulist))))


  ;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ;’’’’’’’            преобразование списка sheet'ов
  ;’’’’’’’      на выходе получаем список вида
  ;’’’’’’’      (("1" (<Entity name: 7eadc730>)) ("2" (<Entity name: 7eaebed0>)) ("3" (<Entity name: 7eae7700>)) ("4" (<Entity name: 7eaa0658>)) ("5" (<Entity name: 7eab7958> <Entity name: 7eab7718> <Entity name: 7eab7318> <Entity name: 7eaf6f18> <Entity name: 7eaf6b18> <Entity name: 7eaf6718> <Entity name: 7eaf6318> <Entity name: 7eaf3f18> <Entity name: 7eaf3b18> <Entity name: 7eaf3718> <Entity name: 7eaf3318>)) ("6" (<Entity name: 7eaf0988>)) ("7" (<Entity name: 7eaf3020>)) ("8" (<Entity name: 7eaaf440> <Entity name: 7ea86e28> <Entity name: 7ea87550> <Entity name: 7ea9c1d8> <Entity name: 7ea9c698> <Entity name: 7eaaf6d8>)) ("9" (<Entity name: 7eaaf850> <Entity name: 7eaafc98> <Entity name: 7eaafdc8> <Entity name: 7eaafef8> <Entity name: 7eaa0068> <Entity name: 7eaafb28>)) ("10" (<Entity name: 7ea9da28>)) ("11" (<Entity name: 7eaf5430>)) ("12" (<Entity name: 7eae1c58>)) ("13" (<Entity name: 7eaf22a8>)) ("14" (<Entity name: 7ea9dd18>)) ("15" (<Entity name: 7ea9df40>)) ("16" (<Entity name: 7eaaf1a8>)) ("17" (<Entity name: 7eacc990> <Entity name: 7eacc048> <Entity name: 7eacc750> <Entity name: 7eaefec8> <Entity name: 7eaef6e8> <Entity name: 7ea96db0> <Entity name: 7ea96ee0> <Entity name: 7ea9d050> <Entity name: 7ea9d180> <Entity name: 7ea9d2b0> <Entity name: 7ea9d420> <Entity name: 7ea9d550> <Entity name: 7ea9d680> <Entity name: 7ea9d7b0> <Entity name: 7ea9d920> <Entity name: 7eac6e40>)) ("19" (<Entity name: 7eac4508> <Entity name: 7eaab250> <Entity name: 7eaab0d0> <Entity name: 7eab1f10> <Entity name: 7eab1d90> <Entity name: 7eab1828> <Entity name: 7eabd170> <Entity name: 7eac3f70> <Entity name: 7eac3db0> <Entity name: 7eac3bb0>)) ("20" (<Entity name: 7eac2e50>)))
  ;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
  (setq zipsheets (vl-sort zipsheets '(lambda (a b) (< (atoi (car a)) (atoi (car b))))))
  (setq drawings zipsheets)

  (setq unum (cdr (assoc 1 (entget (get-uznumber (car kulist))))))
  (setq uzfolder (strcat tdmsfolder unum "/"))
  (if (null (vl-file-directory-p uzfolder)) (vl-mkdir uzfolder))
  (setq targ (getvar "TARGET"))


  (setq plotconfs (vla-get-PlotConfigurations #actdoc))
  (setq pltcfg (vla-add plotconfs ktz-pdfgostplotterconfigname :vlax-true))
  ;(setq ku (car (entsel)))
  (setq i 0)
(foreach ku kulist
  (setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch ku)))
  (vla-SetWindowToPlot pltcfg
      (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (mapcar '- (car pts) targ))
      (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))(mapcar '- (cadr pts) targ)))
  (vla-put-plotType pltcfg acWindow)
  (vla-put-ConfigName pltcfg ktz-pdfplotter)
  (setq canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames pltcfg))))
  (setq namlst(mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
  (vla-put-CanonicalMediaName pltcfg
      (nth (vl-position (strcat (if (> (abs (- (car (car pts)) (car (cadr pts))))
				       (abs (- (cadr (car pts)) (cadr (cadr pts)))))
				  "w" "v") "A" (get-ftxte<-formatpts pts))
	     namlst)canlst))
  (vla-put-PlotRotation pltcfg 0)
  (vla-put-centerplot pltcfg :vlax-true)
  (vla-put-StyleSheet pltcfg "monochrome.ctb")
  (setq sheetnum (get-lnumber ku))
  (setq uznum (cdr (assoc 1 (entget (get-uznumber ku)))))
  (setq actlayout (vla-get-ActiveLayout #actdoc))
  (vla-copyfrom actlayout pltcfg)
  (setq plot (vla-get-plot #actdoc))
  ;чтобы не тормозило надо убирать галочки печать и публикаци€ в фоне в настройках
  (vla-plotToFile plot (strcat uzfolder "BNP-" uznum " л" sheetnum ".pdf") ktz-pdfplotter)
  );foreach
  (alert "\nNow You must go to TDMS folder and consolidate pdf lists")
  )










