
(setq #pdfpc3 "bnp_pdfgostplotter.pc3")
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
(setq #plotconfs (vla-get-PlotConfigurations #actdoc))








(setq blk (vlax-ename->vla-object (car (entsel))))
(setq size (vlax-variant-value (vla-get-Value (getbdyn blk "�����"))))
(setq size (assoc (strcat (cond ((= 65 (car (VL-STRING->LIST size))) "v")((= 192 (car (VL-STRING->LIST size))) "w")) "-A" (VL-LIST->STRING (cdr (VL-STRING->LIST size)))) #gostformats))
(if (= (setq scale (vla-get-XScaleFactor blk)) (vla-get-YScaleFactor blk)) (princ) (setq scale nil))
(setq p1 (kd:vlaxdata-extract (vla-get-InsertionPoint blk)))
(setq p2 (mapcar '+ p1 (mapcar '* (cdr size) (list (- scale) scale))))
(setq cp (mapcar '(lambda (v1 v2) (/ (+ v1 v2) 2.0)) p1 p2))



(setq loname (strcat (vla-get-TextString (getbatt blk "�����_����")) " �." (vla-get-TextString (getbatt blk "�����_�����"))))
(setq pltlocfg (vla-add #plotconfs (strcat "pltconf_" loname "_" (car size)) :vlax-false))
(vla-put-ConfigName pltlocfg "bnp_pdfgostplotter.pc3")
(vla-put-StandardScale pltlocfg 1)
(vla-SetCustomScale pltlocfg 1 1)
(vla-put-PlotRotation pltlocfg ac0degrees)
(setq canlst (kd:vlaxdata-extract (vla-GetCanonicalMediaNames pltlocfg)))
(setq namlst (mapcar '(lambda (x) (vla-GetLocaleMediaName pltlocfg x)) canlst))
(vla-put-CanonicalMediaName pltlocfg (nth (vl-position (vl-string-subst "" "-" (car size)) namlst) canlst))
(vla-put-plotType pltlocfg acLayout)
(vla-put-PlotViewportBorders pltlocfg :vlax-false)
(vla-put-ScaleLineweights pltlocfg :vlax-false)



(setq layout (vla-add (vla-get-Layouts #actdoc) loname))
(vla-put-TabOrder layout 1)
(vla-copyfrom layout pltlocfg)
(vla-put-ActiveLayout #actdoc layout)
(vla-ZoomCenter #cad (vlax-3d-point '(0 0 0)) (getvar "VIEWSIZE"))     ;;;;  ����������� !!!!
(setq #paper (vla-get-paperspace #actdoc))
(setq vp (vla-AddPViewport #paper (vlax-3d-point (mapcar '(lambda (x) (* x 0.5))(cdr size))) (cadr size) (caddr size)))
(vla-put-StandardScale vp acVpCustomScale)
(vla-put-CustomScale vp (/ 1.0 scale))
(vla-put-Target vp (vlax-3d-point cp))
(vla-put-ViewportOn vp :vlax-true)
;(vla-ZoomAll #cad)
;(vla-regen #actdoc acAllViewports)
























