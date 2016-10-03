;;  14_04_25
;; соответствует vp4.3.LSP
(vl-load-com)
(setq #pdfpc3 "bnp_pdfgostplotter.pc3")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;    MAIN   FUNCTION    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:mklayouts ( / *err*)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0) T))
  (setq *err* (vl-catch-all-apply 'kd:mklayouts))
  (acet-error-restore)
  (vla-endundomark #actdoc)
  *err*
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




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
(defun kd-container->list (objc / lst) (vlax-for o objc (setq lst (append lst (list o)))) lst)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getbatt (bobj tag / al)
  (if
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (<= 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al)))
    (car (vl-remove-if-not '(lambda (x) (wcmatch (vla-get-tagstring x) (strcat tag "," (strcase tag))))al))
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getbdyn (bl prop /)
  (car (vl-remove-if-not '(lambda (x) (= prop (vla-get-PropertyName x)))
	 (vlax-safearray->list (vlax-variant-value(vla-GetDynamicBlockProperties bl)))))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(ktzplotter|init)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun kd:mklayouts ( / #plotconfs #paper #Layouts errlist sset lst block-format-names-allowed)
  (setq block-format-names-allowed '("format-spec" "format" "РФ_format-spec" "РФ_format"))
  (setq #plotconfs (vla-get-PlotConfigurations #actdoc))
  ;(setq #paper (vla-get-paperspace #actdoc)) 		;;  если делать переменной, то viewPort'ы не сохраняются, как обновлять хз
  (setq #Layouts (vla-get-Layouts #actdoc))

  (setq sset (vla-get-ActiveSelectionSet #actdoc))
  (vla-clear sset)
  (vla-SelectOnScreen sset (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0)) (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("*")))
  (setq lst (vl-remove-if-not '(lambda (o) (and (= "AcDbBlockReference" (vla-get-ObjectName o)) (member (vla-get-EffectiveName o) block-format-names-allowed) )) (kd-container->list sset)))


  (mapcar
    (function (lambda (blk
	    /
	    loname size scale
	    p1 p2 cp
	    pltlocfg canlst namlst
	    layout vp
	    )
     ;(setq blk (vlax-ename->vla-object (car (entsel))))
     (setq loname (strcat (vla-get-TextString (getbatt blk "НОМЕР_УЗЛА")) " л." (vla-get-TextString (getbatt blk "НОМЕР_ЛИСТА"))))
     (if (member loname (mapcar 'vla-get-name (kd-container->list #Layouts)))
       (setq errlist (cons  (strcat "Layout " loname " не добавлен, так как уже существует!") errlist))
       (progn
	 (setq size (vlax-variant-value (vla-get-Value (getbdyn blk "Выбор"))))
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
	 (vla-ZoomCenter #cad (vlax-3d-point '(0 0 0)) (getvar "VIEWSIZE"))     ;;;;  ОБЯЗАТЕЛЬНО !!!!
	 (setq vp (vla-AddPViewport (vla-get-paperspace #actdoc) (vlax-3d-point (mapcar '(lambda (x) (* x 0.5))(cdr size))) (cadr size) (caddr size)))
	 (vla-put-StandardScale vp acVpCustomScale)
	 (vla-put-CustomScale vp (/ 1.0 scale))
	 (vla-put-Target vp (vlax-3d-point cp))
	 (vla-put-ViewportOn vp :vlax-true)
	 (vlax-release-object vp)
	 (vlax-release-object layout)
	 (vlax-release-object pltlocfg)
	 ;(vla-ZoomAll #cad)
	 )
       )
     ))
  lst
  )
  (vla-regen #actdoc acAllViewports)
  (if errlist (alert (apply 'strcat (mapcar '(lambda (msg) (strcat msg "\n")) errlist))) (alert "Done!"))
  (setq errlist nil)
  );defun

(princ
  (strcat
    "\n ****************************************************************** "
    "\n Type \"mklayouts\" in the Command Line to activate the program ... "
    "\n ****************************************************************** "
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;EOF





















