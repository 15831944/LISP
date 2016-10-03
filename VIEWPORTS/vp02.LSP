

(setq #pdfpc3 "bnp_pdfgostplotter.pc3")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun vk_ZoomTo (Center) (vla-ZoomCenter (vlax-get-acad-object) (vlax-3d-point Center) (getvar "VIEWSIZE")))
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


(setq plotconfs (vla-get-PlotConfigurations #actdoc))
(setq blk (vlax-ename->vla-object (car (entsel))))
(setq size (vlax-variant-value (vla-get-Value (getbdyn blk "¬ыбор"))))
(setq size (assoc (strcat (cond ((= 65 (car (VL-STRING->LIST size))) "v")((= 192 (car (VL-STRING->LIST size))) "w")) "-A" (VL-LIST->STRING (cdr (VL-STRING->LIST size)))) #gostformats))
(if (= (setq scale (vla-get-XScaleFactor blk)) (vla-get-YScaleFactor blk)) (princ) (setq scale nil))
(setq p1 (kd:vlaxdata-extract (vla-get-InsertionPoint blk)))
(setq p2 (mapcar '+ p1 (mapcar '* (cdr size) (list (- scale) scale))))
(setq cp (mapcar '(lambda (v1 v2) (/ (+ v1 v2) 2.0)) p1 p2))



;(do (vla-item #paper 0))
(setq loname (strcat (vla-get-TextString (getbatt blk "Ќќћ≈–_”«Ћј")) " л." (vla-get-TextString (getbatt blk "Ќќћ≈–_Ћ»—“ј"))))
(setq pltlocfg (vla-add plotconfs (strcat "pltconf_" loname "_" (car size)) :vlax-false))
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


(vla-put-PlotOrigin pltlocfg
  (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1))
    (mapcar '(lambda (x) (* x 0.5))(cdr size))
	    
    )
  )












(setq layout (vla-add (vla-get-Layouts #actdoc) loname))
(vla-put-TabOrder layout 1)
(vla-copyfrom layout pltlocfg)
(vla-put-ActiveLayout #actdoc layout)
(vk_ZoomTo '(0 0 0))		;;;;  ќЅя«ј“≈Ћ№Ќќ !!!!
(setq #paper (vla-get-paperspace #actdoc))
(setq vp (vla-AddPViewport #paper (vlax-3d-point '(0 0 0)) (cadr size) (caddr size)))
(vla-put-StandardScale vp acVpCustomScale)
(vla-put-CustomScale vp scale)
(vla-put-Target vp (vlax-3d-point cp))
(vla-put-ViewportOn vp :vlax-true)
(vla-ZoomAll #cad)
(vla-regen #actdoc acAllViewports)
;(vla-put-Target vp (vlax-3d-point '(0 0 0)))



;;;;    в   идеально, только на виде при настройке печати - фигн€, а так - работает









































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(vla-AddCircle #modspace (vlax-3d-point p1) 40)
;(vla-AddCircle #modspace (vlax-3d-point p2) 40)

(do (vla-get-Views #actdoc))
(entget (vlax-vla-object->ename (vla-get-Views #actdoc)))


(do #actdoc)
(do (vla-get-PaperSpace #actdoc))
;(vla-get-ActiveUCS #actdoc)


(vla-put-ConfigName (vla-get-ActiveLayout #actdoc) "None")
(do (vla-get-ActiveLayout #actdoc))


(do (vla-item (vla-get-Layouts #actdoc) 2))


(do #modspace)
(do (vla-get-Layout #modspace))
(vla-put-PlotOrigin (vla-get-Layout #modspace)
  (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (list 0 0))
  )













(defun vk_ZoomTo (Center)
  (vla-ZoomCenter
    (vlax-get-acad-object)
    (vlax-3d-point Center)
    (getvar "VIEWSIZE")
    )
  )

(defun vk_CenterViewport (Viewport Center / ADoc)
  (setq	ADoc	 (vla-get-ActiveDocument (vlax-get-acad-object))
	Viewport (if (= (type Viewport) 'ENAME)
		   (vlax-ename->vla-object Viewport)
		   Viewport
		 )
  )
  (vla-put-MSpace ADoc :vlax-true)
  (vla-put-ActivePViewport ADoc Viewport)
  (vk_ZoomTo Center)
  (vla-put-MSpace ADoc :vlax-false)
)
(defun vk_Mx*Vec (m v)
  (mapcar (function (lambda (r) (apply '+ (mapcar '* r v)))) m)
)
(defun vk_RotatePoint2d	(P Ang / s c)
  (setq	s (sin Ang)
	c (cos Ang)
  )
  (vk_Mx*Vec (list (list c (- s)) (list s c)) P)
)
(defun vk_GetAssVal (Key InList) (cdr (assoc Key InList)))
(defun vk_RotateViewPort (Viewport Ang / TwAng Center)
  (setq	TwAng  (vk_GetAssVal 51 (entget Viewport))
	Center (vk_RotatePoint2d (vk_GetAssVal 12 (entget Viewport)) (- TwAng))
  )
  (vla-put-TwistAngle (vlax-ename->vla-object Viewport) (+ TwAng Ang))
  (vk_CenterViewport Viewport Center)
)






  

  





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq  vp (car (entsel)))
(setq vp (vlax-ename->vla-object vp))
(do (vlax-ename->vla-object vp))
;   Target = (5704.72 -3952.85 0.0)
;(vlax-extract-data (vla-get-target vp))
(vla-AddCircle #modspace (vla-get-target vp) 40)


(entget (car (nentsel)))



(assoc 16 eng)

(assoc 13 eng)
(assoc 17 eng)

;;;;   может быть установка в 17 помогла


(vla-put-TwistAngle (vlax-ename->vla-object vp) (* (/ pi 180) 0))
(assoc 12 (entget vp))	;(12 25857.2 35968.4 0.0) 
(assoc 16 (entget vp)) 	;0 0 1

(vla-put-TwistAngle (vlax-ename->vla-object vp) (* (/ pi 180) 90))
(assoc 12 (entget vp))	;(12 25857.2 35968.4 0.0) 
(assoc 16 (entget vp)) 	;0 0 1

(modent vp '(13 0.0 1.0 0.0))

(entget (cdr (assoc 330 (entget vp))))




(setq vp (car (entsel)))
(setq oldcvport (getvar "CVPORT"))
(setvar "CVPORT" 2)
(setq mcpt (assoc 12 (entget vp)))
(setq deg 90)

(modent vp (cons 17 (cdr mcpt)))


(vla-put-TwistAngle (vlax-ename->vla-object vp) (* (/ pi 180) deg))

(setq eng (entget vp))
(setq eng (subst mcpt (assoc 12 eng) eng))
(entmod eng)
(entupd (cdr (assoc -1 eng)))







(vla-update (vlax-ename->vla-object vp))






;;;
;;;(setq loeng (entget (vlax-vla-object->ename layout)))
;;;(setq loenghead (reverse (cdr (member '(100 . "AcDbPlotSettings") (reverse loeng)))))
;;;(setq pslo (cutlist loeng '(100 . "AcDbPlotSettings") '(100 . "AcDbLayout")))
;;;(setq lotail (cdr (member '(100 . "AcDbLayout") loeng)))
;;;(setq pslo (subst (cons 1 ktz-pdfgostplotterconfigname) (assoc 1 pslo) pslo))
;;;(setq loeng (append loenghead pslo lotail))
;;;(entmod loeng)
;;;(entupd (cdr (assoc -1 loeng)))