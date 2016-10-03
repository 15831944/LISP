;;  13_07_18
;;  15_07_13 - + поворот аттрибутов
(defun c:kd:explode (/ lst)
  (mapcar 'block-explode (ss->lsto* (ssget '((0 . "INSERT")))))
  )




;;;  13_07_01
;(block-explode (vlax-ename->vla-object (car (entsel))))
;(setq blo (vlax-ename->vla-object (car (entsel))))
;(mapcar 'block-explode (ss->lsto* (ssget)))
(defun block-explode (blo / atts txto obs blayer bcolor blineweight unplayers tmp catch)
  (setq blayer (vla-get-Layer blo))
  (setq bcolor (vla-get-color blo))
  (setq blineweight (vla-get-LineWeight blo))
  (setq unplayers (vl-remove-if '(lambda (x) (= :vlax-true (vla-get-Plottable x))) (kd-container->list (vla-get-Layers #actdoc))))
  
  (if (null (member blayer (mapcar 'vla-get-name unplayers)))
    (progn
   (if (= :vlax-true (vla-get-hasattributes blo))
     (if (= -1 (vlax-safearray-get-u-bound (vlax-variant-value (vla-getconstantattributes blo)) 1))
      (setq atts (vlax-safearray->list  (vlax-variant-value (vla-getattributes blo))))
      (setq atts (append (vlax-safearray->list  (vlax-variant-value (vla-getattributes blo))) (vlax-safearray->list  (vlax-variant-value (vla-GetConstantAttributes blo)))))
      ); if is const atts
     (setq atts '())
     )


  
  (mapcar
    '(lambda (att / tmp aeo)
       ;(setq att (vlax-ename->vla-object (car (nentsel))))
       (if (and
	     (null (member (vla-get-layer att) (mapcar 'vla-get-Name unplayers)))
	     (= (vlax-get-property att "Visible") :vlax-true)
	     )
	 (progn
	   
      (if (= :vlax-false (vlax-get-property att "MTextAttribute"))
	(progn
	  (setq txto (vla-AddText #modspace "" (vlax-3D-Point '(0 0 0)) 2.5))
	  (vlax-put-property txto "Alignment" (setq tmp (vlax-get-property att "Alignment")))
	  (if (= tmp 0)
	    (vlax-put-property txto "InsertionPoint" (vlax-get-property att "InsertionPoint"))
	    (vlax-put-property txto "TextAlignmentPoint" (vlax-get-property att "TextAlignmentPoint"))
	    )
	  (vlax-put-property txto "Backward" (vlax-get-property att "Backward"))
	  (vlax-put-property txto "Linetype" (vlax-get-property att "Linetype"))
	  (vlax-put-property txto "LinetypeScale" (vlax-get-property att "LinetypeScale"))
	  (vlax-put-property txto "ObliqueAngle" (vlax-get-property att "ObliqueAngle"))
	  

	  ;(setq att (vlax-ename->vla-object (car (nentsel))))
	  ;(setq txto (vlax-ename->vla-object (car (nentsel))))
	  (vlax-put-property txto "ScaleFactor" (vlax-get-property att "ScaleFactor"))

	  (vlax-put-property txto "StyleName" (vlax-get-property att "StyleName"))
	  (vlax-put-property txto "Thickness" (vlax-get-property att "Thickness"))
	  (vlax-put-property txto "UpsideDown" (vlax-get-property att "UpsideDown"))
	  );if txt

	
	;if mtext
	(progn
	  ;(setq att (vlax-ename->vla-object (car (nentsel))))
	  (setq aeo (member '(101 . "Embedded Object") (entget (vlax-vla-object->ename att))))
	  (setq txto (vla-AddMText #modspace (vlax-3D-Point '(0 0 0)) 0 ""))
	  ;(setq txto (vlax-ename->vla-object (car (nentsel))))
	  (vlax-put-property txto "AttachmentPoint" (- (vlax-get-property att "Alignment") 5))
	  (vlax-put-property txto "InsertionPoint" (vlax-get-property att "TextAlignmentPoint"))
	  (vlax-put-property txto "Width" (vlax-get-property att "MTextBoundaryWidth"))
	  (vlax-put-property txto "DrawingDirection" (vlax-get-property att "MTextDrawingDirection"))
	  (modent (vlax-vla-object->ename txto) (assoc 46 aeo))
	  (modent (vlax-vla-object->ename txto) (assoc 44 aeo))
	  ;(vlax-put-property txto "Rotation" (vlax-get-property att "Rotation"))
	  )
	);case mtext

    ;;;;; общие свойства для обоих
      (if (= 0 (setq tmp (vlax-get-Property att "color"))) (vlax-put-property txto "color" bcolor) (vlax-put-property txto "color" tmp))
      (if (= -2 (setq tmp (vlax-get-Property att "LineWeight"))) (vlax-put-property txto "LineWeight" blineweight) (vlax-put-property txto "LineWeight" tmp))
      (vla-put-Textstring txto (kd-get-Textstring att))
      (vlax-put-property txto "Height" (vlax-get-property att "Height"))
      (vlax-put-property txto "Rotation" (vlax-get-property att "Rotation"))
      (if (and (/= "0" blayer) (= "0" (vlax-get-Property att "layer"))) (vlax-put-property txto "Layer" blayer) (vlax-put-property txto "Layer" (vlax-get-Property att "layer")))
      ;(vla-addLine #modspace (vlax-3d-point '(0 0 0)) (vla-get-InsertionPoint txto))
      ;(vla-addLine #modspace (vlax-3d-point '(0 0 0)) (vla-get-InsertionPoint txto))
      );progn if visible and plottable
	 );if vis
       )
    atts
    ); mapcar attributes
  ;(kd-get-Textstring (car (nentsel)))



   (setq catch (vl-catch-all-apply 'vla-explode (list blo)))
   (cond
     ;((= (type catch) 'VLA-OBJECT) (princ))
     ((= (type catch) 'VARIANT) (setq obs (vlax-variant-value catch)))
     ((= (type catch) 'VL-CATCH-ALL-APPLY-ERROR)
      (princ (VL-CATCH-ALL-ERROR-MESSAGE catch))
      (princ (strcat "\nBlock : " (vla-get-EffectiveName blo) "\n"))
      (kd|resetblock blo)
      (setq obs (vlax-variant-value (vla-explode blo)))
      )
     )
   ;;   если тут вылетает - регенерировать блоки
  ;(setq obs (vlax-variant-value (vla-explode blo)))
   ;;    врде исправил
  (if (<= 0 (vlax-safearray-get-u-bound obs 1))
    (setq obs (vlax-safearray->list obs))
    (setq obs nil)
    )

  (mapcar
    '(lambda (o)
       ;(setq o (nth 15 obs))
       ;(setq o (vlax-ename->vla-object (car (nentsel))))
       (if (= "AcDbAttributeDefinition" (vlax-get-property o "ObjectName"))
	 (vla-delete o)
	 (progn
	   (if (= -2 (setq tmp (vlax-get-Property o "LineWeight")))
	     (vlax-put-property o "LineWeight" blineweight)
	     (vlax-put-property o "LineWeight" tmp)
	     )
	   (if (= 0 (setq tmp (vlax-get-Property o "color")))
	     (vlax-put-property o "color" bcolor)
	     (vlax-put-property o "color" tmp)
	     )
	   (if (and
		 (/= "0" blayer)
		 (= "0" (vlax-get-Property o "layer"))
		 )
	     (vlax-put-property o "Layer" blayer)
	     )	   
	   )
	 )
       )
    obs
    )
  
  
  (vla-delete blo)
   )
    )
  );defun




;;;
;;;;(setq att (vlax-ename->vla-object (car (nentsel))))
;;;
;;;(defun mtatt>mt (att / txto aeo boundaryheight)
;;;  (setq aeo (member '(101 . "Embedded Object") (entget (vlax-vla-object->ename att))))
;;;  (setq txto (vla-AddMText #modspace (vlax-3D-Point '(0 0 0)) 0 ""))
;;;  (vlax-put-property txto "AttachmentPoint" (- (vlax-get-property att "Alignment") 5))
;;;  (vlax-put-property txto "InsertionPoint" (vlax-get-property att "TextAlignmentPoint"))
;;;  (vlax-put-property txto "Width" (vlax-get-property att "MTextBoundaryWidth"))
;;;  (vlax-put-property txto "DrawingDirection" (vlax-get-property att "MTextDrawingDirection"))
;;;  (vlax-put-property txto "Height" (vlax-get-property att "Height"))
;;;  (vla-put-Textstring txto (kd-get-Textstring att))
;;;  (modent (vlax-vla-object->ename txto) (assoc 46 aeo))
;;;  (modent (vlax-vla-object->ename txto) (assoc 44 aeo))
;;;  (vla-update txto)
;;;  );defun
;;;



























