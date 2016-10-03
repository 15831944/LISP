;;  14_10_15
;(setq #pdfpc3 "bnp_pdfgostplotter.pc3")
(setq #pdfpc3 "ktz_pdfgostplotter.pc3")
;(setq #pdfpc3 "kaktooz-pdf.pc3")
(setq #an|dwrnuum "DRAWING_NUMBER")
(setq block-format-names-allowed '("format-spec" "format" "–‘_format-spec" "–‘_format" "tekon_format"))


(defun c:mklayouts ( / *err*)	
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0) T))
  (setq *err* (vl-catch-all-apply 'kd:mklayouts))
  (acet-error-restore)
  (vla-endundomark #actdoc)
  ;(if *err* (VL-CATCH-ALL-ERROR-MESSAGE *err*))
  *err*
  );defun


(defun c:mkl ( / ss)
  (setq ss (ssget "_X" '((0 . "INSERT"))))
  (vla-put-LineweightDisplay (vla-get-Preferences #actdoc) :vlax-true)
  (setq ss (ss->lsto* ss))
  (setq ss (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) '("tekon_format" "format-spec"))) ss))
  (mapcar 'kd:mklayout ss)
  
  )



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


(defun kd:mklayouts ( / #plotconfs #paper #Layouts errlist sset ;|lst block-format-names-allowed |; )
  (setq #plotconfs (vla-get-PlotConfigurations #actdoc))
  ;(setq #paper (vla-get-paperspace #actdoc)) 		;;  если делать переменной, то viewPort'ы не сохран€ютс€, как обновл€ть хз
  (setq #Layouts (vla-get-Layouts #actdoc))
  (setq errlist '())

  (setq sset (vla-get-ActiveSelectionSet #actdoc))
  (vla-clear sset)
  (vla-SelectOnScreen sset (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0)) (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("*")))
  (setq lst (vl-remove-if-not '(lambda (o) (and (= "AcDbBlockReference" (vla-get-ObjectName o))
						(member (vla-get-EffectiveName o) block-format-names-allowed)
						)) (cont>list sset)))
  (setq lst (vl-sort lst '(lambda (a b) (< (atof* (vla-get-textstring (getbatt a "DRAWING_NUMBER"))) (atof* (vla-get-textstring (getbatt b "DRAWING_NUMBER")))))))
  (mapcar
  (function (lambda (blk
	    /
	    loname size scale
	    p1 p2 cp
	    pltlocfg canlst namlst
	    layout vp blo
		     )
     ;(setq blk (vlax-ename->vla-object (car (entsel))))
     (setq loname (strcat (vla-get-TextString (getbatt blk #an|dwrnuum))))
     (if (member loname (mapcar 'vla-get-name (kd-container->list #Layouts)))
       (setq errlist (cons  (strcat "Layout " loname " не добавлен, так как уже существует!") errlist))
       (progn
	 ;(setq size (vlax-variant-value (vla-get-Value (getbdyn blk "¬ыбор"))))
	 (setq size (vlax-variant-value (vla-get-Value (getbdyn blk "Size"))))
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
	 ;============================================================
	 ;(setq blo (vla-get-Block layout))
	 ;(vla-delete (vla-item blo 2))
	 ;============================================================
	 (vla-copyfrom layout pltlocfg)
	 (vla-put-ActiveLayout #actdoc layout)
	 (vla-ZoomCenter #cad (vlax-3d-point '(0 0 0)) (getvar "VIEWSIZE"))     ;;;;  ќЅя«ј“≈Ћ№Ќќ !!!!
	 (setq vp (vla-AddPViewport (vla-get-paperspace #actdoc) (vlax-3d-point (mapcar '(lambda (x) (* x 0.5))(cdr size))) (cadr size) (caddr size)))
	 (vla-put-StandardScale vp acVpCustomScale)
	 (vla-put-CustomScale vp (/ 1.0 scale))
	 (vla-put-Target vp (vlax-3d-point cp))
	 (vla-put-ViewportOn vp :vlax-true)
	 (vlax-release-object vp)
	 (vlax-release-object layout)
	 (vlax-release-object pltlocfg)
	 (vla-ZoomAll #cad)
	 )
       )
     ))
  lst
  )
  (vla-regen #actdoc acAllViewports)
  (if errlist (alert (apply 'strcat (mapcar '(lambda (msg) (strcat msg "\n")) errlist))) (alert "Done!"))
  (setq errlist nil)
  );defun






;;;(setq #Layouts (vla-get-Layouts #actdoc))
;;;(length (setq llots (cont>list #Layouts)))
;;;(length (setq llots (vl-remove-if '(lambda (x) (= "Model"(vla-get-Name x))) llots)))
;;;
;;;(setq nllots
;;;(vl-sort llots
;;;	 '(lambda (a b)
;;;	    (<
;;;	      (atof* (vla-get-name a))
;;;	      (atof* (vla-get-name b))
;;;	      )
;;;	    )
;;;	 ))
;;;
;;;
;;;
;;;(mapcar
;;;  '(lambda (l)
;;;     (vla-put-taborder l 1)
;;;     )
;;;  (reverse nllots)
;;;  )








;(kd:mklayout (vlax-ename->vla-object (car (entsel))))


(defun kd:mklayout (blk /
		    loname size scale
		    p1 p2 cp
		    pltlocfg canlst namlst
		    layout vp blo
		    )
  ;(setq blk (vlax-ename->vla-object (car (entsel))))
     (setq loname (strcat (vla-get-TextString (getbatt blk #an|dwrnuum))))
     (if (member loname (mapcar 'vla-get-name (cont>list (vla-get-layouts #actdoc))))
       (setq errlist (cons  (strcat "Layout " loname " не добавлен, так как уже существует!") errlist))
       (progn
	 ;(setq size (vlax-variant-value (vla-get-Value (getbdyn blk "¬ыбор"))))
	 (setq size (vlax-variant-value (vla-get-Value (getbdyn blk "Size"))))
	 (setq size (assoc (strcat (cond ((= 65 (car (VL-STRING->LIST size))) "v")((= 192 (car (VL-STRING->LIST size))) "w")) "-A" (VL-LIST->STRING (cdr (VL-STRING->LIST size)))) #gostformats))
	 (if (= (setq scale (vla-get-XScaleFactor blk)) (vla-get-YScaleFactor blk)) (princ) (setq scale nil))
	 (setq p1 (kd:vlaxdata-extract (vla-get-InsertionPoint blk)))
	 (setq p2 (mapcar '+ p1 (mapcar '* (cdr size) (list (- scale) scale))))
	 (setq cp (mapcar '(lambda (v1 v2) (/ (+ v1 v2) 2.0)) p1 p2))

	 (setq pltlocfg (vla-add (vla-get-PlotConfigurations #actdoc) (strcat "pltconf_" loname "_" (car size)) :vlax-false))
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

	 (setq layout (vla-add (vla-get-layouts #actdoc) loname))
	 (vla-put-TabOrder layout 1)
	 ;============================================================
	 ;(setq blo (vla-get-Block layout))
	 ;(vla-delete (vla-item blo 2))
	 ;============================================================
	 (vla-copyfrom layout pltlocfg)
	 (vla-put-ActiveLayout #actdoc layout)
	 (vla-ZoomCenter #cad (vlax-3d-point '(0 0 0)) (getvar "VIEWSIZE"))     ;;;;  ќЅя«ј“≈Ћ№Ќќ !!!!
	 (setq vp (vla-AddPViewport (vla-get-paperspace #actdoc) (vlax-3d-point (mapcar '(lambda (x) (* x 0.5))(cdr size))) (cadr size) (caddr size)))
	 (vla-put-StandardScale vp acVpCustomScale)
	 (vla-put-CustomScale vp (/ 1.0 scale))
	 (vla-put-Target vp (vlax-3d-point cp))
	 (vla-put-ViewportOn vp :vlax-true)
	 (vlax-release-object vp)
	 (vlax-release-object layout)
	 (vlax-release-object pltlocfg)
	 (vla-ZoomAll #cad)
	 )
       )
  );defun





;деаем ч/б
;(vlax-for pc (vla-get-PlotConfigurations #actdoc) (vla-put-StyleSheet pc "monochrome.ctb") )













