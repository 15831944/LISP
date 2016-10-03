(setq #pdfpc3 "bnp_pdfgostplotter.pc3")



;;;(defun c:mklayouts ( / )
;;;  (vla-startundomark #actdoc)
;;;  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0) T))
;;;  (vl-catch-all-apply '(kd:mklayouts))
;;;  (acet-error-restore)
;;;  (vla-endundomark #actdoc)
;;;  );defun





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kd:vlaxdata-extract (var)
  (cond
    ((= 'LIST (type var)) (mapcar 'kd:vlaxdata-extract var))
    ((= 'safearray (type var)) (kd:vlaxdata-extract (vlax-safearray->list var)))
    ((= 'variant (type var)) (kd:vlaxdata-extract (vlax-variant-value var)))
    (T var)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(defun kd:mklayouts ( / #plotconfs #paper #Layouts errlist sset lst block-format-names-allowed)
  (setq block-format-names-allowed '("format-spec" "format" "–‘_format-spec" "–‘_format"))
  (setq #plotconfs (vla-get-PlotConfigurations #actdoc))
  ;(setq #paper (vla-get-paperspace #actdoc))
  (setq #Layouts (vla-get-Layouts #actdoc))
  (setq errlist '())

  (setq sset (vla-get-ActiveSelectionSet #actdoc))
  (vla-clear sset)
  (vla-SelectOnScreen sset (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0)) (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("*")))
  (setq lst (vl-remove-if-not '(lambda (o) (and (= "AcDbBlockReference" (vla-get-ObjectName o)) (member (vla-get-EffectiveName o) block-format-names-allowed) )) (kd-container->list sset)))


(mapcar
  (function (lambda (blk
	    /
	    ;loname size scale
	    ;p1 p2 cp
	    ;pltlocfg canlst namlst
	    ;layout vp
	    )
     ;(setq blk (vlax-ename->vla-object (car (entsel))))
     (setq loname (strcat (vla-get-TextString (getbatt blk "ÕŒÃ≈–_”«À¿")) " Î." (vla-get-TextString (getbatt blk "ÕŒÃ≈–_À»—“¿"))))
     (if (member loname (mapcar 'vla-get-name (kd-container->list #Layouts)))
       (setq errlist (cons  (strcat "Layout " loname " ÌÂ ‰Ó·‡‚ÎÂÌ, Ú‡Í Í‡Í ÛÊÂ ÒÛ˘ÂÒÚ‚ÛÂÚ!") errlist))
       (progn
	 (setq size (vlax-variant-value (vla-get-Value (getbdyn blk "¬˚·Ó"))))
	 (setq size (assoc (strcat (cond ((= 65 (car (VL-STRING->LIST size))) "v")((= 192 (car (VL-STRING->LIST size))) "w")) "-A" (VL-LIST->STRING (cdr (VL-STRING->LIST size)))) #gostformats))
	 (if (= (setq scale (vla-get-XScaleFactor blk)) (vla-get-YScaleFactor blk)) (princ) (setq scale nil))
	 (setq p1 (kd:vlaxdata-extract (vla-get-InsertionPoint blk)))
	 (setq p2 (mapcar '+ p1 (mapcar '* (cdr size) (list (- scale) scale))))
	 (setq cp (mapcar '(lambda (v1 v2) (/ (+ v1 v2) 2.0)) p1 p2))



	 (setq pltlocfg (vla-add #plotconfs (strcat "pltconf_" loname "_" (car size)) :vlax-false))
	 (vla-put-ConfigName pltlocfg #pdfpc3)
	 (vla-put-StandardScale pltlocfg 1)
	 (vla-SetCustomScale pltlocfg 1 1)
	 (vla-put-PlotRotation pltlocfg ac0degrees)
	 (setq canlst (kd:vlaxdata-extract (vla-GetCanonicalMediaNames pltlocfg)))
	 (setq namlst (mapcar '(lambda (x) (vla-GetLocaleMediaName pltlocfg x)) canlst))
	 (vla-put-CanonicalMediaName pltlocfg (nth (vl-position (vl-string-subst "" "-" (car size)) namlst) canlst))
	 (vla-put-plotType pltlocfg acLayout)
	 (vla-put-PlotViewportBorders pltlocfg :vlax-false)
	 (vla-put-ScaleLineweights pltlocfg :vlax-false)


	 (setq layout (vla-add #Layouts loname))
	 (vla-put-TabOrder layout 1)
	 (vla-copyfrom layout pltlocfg)
	 (vla-put-ActiveLayout #actdoc layout)
	 (vla-ZoomCenter #cad (vlax-3d-point '(0 0 0)) (getvar "VIEWSIZE"))     ;;;;  Œ¡ﬂ«¿“≈À‹ÕŒ !!!!
	 (setq vp (vla-AddPViewport (vla-get-paperspace #actdoc) (vlax-3d-point (mapcar '(lambda (x) (* x 0.5))(cdr size))) (cadr size) (caddr size)))
	 (vla-put-StandardScale vp acVpCustomScale)
	 (vla-put-CustomScale vp (/ 1.0 scale))
	 (vla-put-Target vp (vlax-3d-point cp))
	 (vla-put-ViewportOn vp :vlax-true)
	 ;(vlax-release-object vp)
	 ;(vlax-release-object layout)
	 ;(vlax-release-object pltlocfg)
	 ;(vla-ZoomAll #cad)
	 ;(vla-regen #actdoc acAllViewports)
	 )
       )
     ))
  lst
  )
  ;(if errlist (alert (apply 'strcat (mapcar '(lambda (msg) (strcat msg "\n")) errlist))) (alert "Done!"))
  (setq errlist nil)
;  );defun






















