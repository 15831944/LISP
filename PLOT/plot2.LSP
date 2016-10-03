(setq scale 1)
(setq ktz-pdfplotter "ktz_pdfgostplotter.pc3")
(load (strcat #lisppath "common functions/format-identification-gost.lsp"))

(setq plot (vla-get-plot #actdoc))
(setq plotconfs (vla-get-PlotConfigurations #actdoc))

(setq pltcfg (vla-add plotconfs "cfg1" :vlax-true))
(setq ku (car (entsel)))
(setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch ku)))
(vla-SetWindowToPlot pltcfg (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (car pts)) (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (cadr pts)))
(vla-put-plotType pltcfg acWindow)
(vla-put-ConfigName pltcfg ktz-pdfplotter)
(setq canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames pltcfg))))
(setq namlst (mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
(vla-put-CanonicalMediaName pltcfg (nth (vl-position (strcat (if (> (abs (- (car (car pts)) (car (cadr pts)))) (abs (- (cadr (car pts)) (cadr (cadr pts))))) "w" "v") "A" (get-ftxte<-formatpts pts)) namlst) canlst))
(vla-put-PlotRotation pltcfg 0)
(vla-put-centerplot pltcfg :vlax-true)
(vla-put-StyleSheet pltcfg "monochrome.ctb")
;(vla-get-StyleSheet (vla-get-ActiveLayout #actdoc)) ; "monochrome.ctb" 



(setq pltcfg (vla-add plotconfs "cfg2" :vlax-true))
(setq ku (car (entsel)))
(setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch ku)))
(vla-SetWindowToPlot pltcfg (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (car pts)) (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (cadr pts)))
(vla-put-plotType pltcfg acWindow)
(vla-put-ConfigName pltcfg ktz-pdfplotter)
(setq canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames pltcfg))))
(setq namlst (mapcar '(lambda (x) (vla-GetLocaleMediaName pltcfg x)) canlst))
(vla-put-CanonicalMediaName pltcfg (nth (vl-position (strcat (if (> (abs (- (car (car pts)) (car (cadr pts)))) (abs (- (cadr (car pts)) (cadr (cadr pts))))) "w" "v") "A" (get-ftxte<-formatpts pts)) namlst) canlst))
(vla-put-PlotRotation pltcfg 0)
(vla-put-centerplot pltcfg :vlax-true)
(vla-put-StyleSheet pltcfg "monochrome.ctb")
;(vla-get-StyleSheet (vla-get-ActiveLayout #actdoc)) ; "monochrome.ctb" 






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq layouts (vla-get-layouts #actdoc))
(do layouts)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq lo1 (vla-add layouts "lo1"))
(vla-put-ConfigName lo1 ktz-pdfplotter)
(setq ku (car (entsel)))
(vla-SetWindowToPlot lo1 (vlax-safearray-fill(vlax-make-safearray vlax-vbDouble '(0 . 1)) (car pts)) (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (cadr pts)))
(vla-put-plotType lo1 acWindow)
(setq canlst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames lo1))))
(setq namlst (mapcar '(lambda (x) (vla-GetLocaleMediaName lo1 x)) canlst))
(vla-put-CanonicalMediaName lo1 (nth (vl-position (strcat (if (> (abs (- (car (car pts)) (car (cadr pts)))) (abs (- (cadr (car pts)) (cadr (cadr pts))))) "w" "v") "A" (get-ftxte<-formatpts pts)) namlst) canlst))
;(vla-get-ModelType lo1)
(vla-put-PlotRotation lo1 0)
(vla-put-centerplot lo1 :vlax-true)
(vla-put-StyleSheet lo1 "monochrome.ctb")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq sa (vlax-make-safearray vlax-vbString '(0 . 0)))
(vlax-safearray-put-element sa 0 "lo1")
(vla-SetLayoutsToPlot plot sa )
(vla-plotToFile plot "D:\\_TDMS\\filename.pdf" ktz-pdfplotter)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





