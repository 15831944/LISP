

(defun c:SortAttDefs ( / obj blk attdefs mtaproplist proplist srtRule)
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (setq blk (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName obj)))
  (setq attdefs (vl-remove-if-not (function (lambda (x) (= "AcDbAttributeDefinition" (vla-get-objectname x)))) (cont>list blk)))
  ;(do (car attdefs))

  (setq mtaproplist
	 '(
	   "MTextAttributeContent"
	   "MTextBoundaryWidth"
	   "MTextDrawingDirection"
	   )
	)
(setq proplist
       '(
	 "MTextAttribute"
	 "Backward"
	 "Constant"
	 "EntityTransparency"
	 "Height"
	 "Invisible"
	 "Layer" "Linetype" "LinetypeScale" "Lineweight" "LockPosition"
	 "Material" "Mode" "Normal" "ObliqueAngle"
	 ;"PlotStyleName"
	 "Preset"
	 "PromptString"
	 "Rotation"
	 "ScaleFactor"
	 "StyleName"
	 "TagString"
	 "TextAlignmentPoint"
	 "InsertionPoint"
	 "Alignment"
	 ;"TextGenerationFlag"
	 "TextString" "Thickness" "TrueColor" "UpsideDown" "Verify"
	 "Visible"
	 )
      )
  (setq propvals (mapcar '(lambda (attdef) (mapcar
					     '(lambda (p) (list p (eval (list (read (strcat "vla-get-" p)) attdef))))
					     (if (= (vla-get-MTextAttribute attdef) :vlax-false)
					       proplist
					       (concat proplist mtaproplist)
					       )
					     )
			    )
			 attdefs
			 )
	)
  ;;  определение порядка
;;;  (setq propvals
;;;	 (vl-sort propvals
;;;		  '(lambda (pv1 pv2)
;;;		     (>
;;;		       (cadr (vlax-safearray->list (vlax-variant-value (cadr (assoc "InsertionPoint" pv1)))))
;;;		       (cadr (vlax-safearray->list (vlax-variant-value (cadr (assoc "InsertionPoint" pv2)))))
;;;		       )
;;;		     )
;;;		  ))
  (setq srtRule (dcl:ManualSort (mapcar '(lambda (att) (cadr (assoc "TagString" att))) propvals)))


  
  (setq propvals
  (mapcar
    '(lambda (tag)
       (car
       (vl-remove-if-not
	 '(lambda (pv)
	    (member (list "TagString" tag) pv)
	   )
	 propvals
	 )
       )
       )
    srtRule)
	)




  



  ;(setq ado (nth 13 attdefs))
  ;(setq pvs (nth 13 propvals))

  
  ;(setq ado (nth 6 attdefs))
  ;(setq pvs (nth 6 propvals))
  ;(setq done '())




  (mapcar
    '(lambda (ado)
       (vla-delete ado)
       (vlax-release-object ado)
       (setq ado nil)
       )
    attdefs
    )


  
  (mapcar
    '(lambda (pvs / ado mode height pvstail)
       (setq height (cadr (assoc "Height" pvs)))

       (setq
	 mode
	  (+
	    (if (= :vlax-true (cadr (assoc "Invisible" pvs))) acAttributeModeInvisible 0)
	    (if (= :vlax-true (cadr (assoc "Constant" pvs))) acAttributeModeConstant 0)
	    (if (= :vlax-true (cadr (assoc "Verify" pvs))) acAttributeModeVerify 0)
	    (if (= :vlax-true (cadr (assoc "Preset" pvs))) acAttributeModePreset 0)
	    (if (= :vlax-true (cadr (assoc "LockPosition" pvs))) acAttributeModeLockPosition 0)
	    (if (= :vlax-true (cadr (assoc "MTextAttribute" pvs))) acAttributeModeMultipleLine 0)
	    ))
       
       (setq ado (vla-AddAttribute blk
		   height
		   mode
		   (cadr (assoc "PromptString" pvs))
		   (cadr (assoc "InsertionPoint" pvs))
		   (cadr (assoc "TagString" pvs))
		   (cadr (assoc "TextString" pvs))
		   ))

       (setq pvstail pvs)
       (setq pvstail (vl-remove (assoc "Height" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "Invisible" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "Constant" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "Verify" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "Preset" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "LockPosition" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "MTextAttribute" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "PromptString" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "InsertionPoint" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "TagString" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "TextString" pvstail) pvstail))
       

       
       (if
	 (and
	   (= :vlax-false (cadr (assoc "MTextAttribute" pvs)))
	   (/= 0 (cadr (assoc "Alignment" pvs)))
	   )
	 (progn
	   (vla-put-alignment ado (cadr (assoc "Alignment" pvs)))
	   (vla-put-TextAlignmentPoint ado (cadr (assoc "TextAlignmentPoint" pvs)))
	   )
	 (progn
	   (vla-put-InsertionPoint ado (cadr (assoc "InsertionPoint" pvs)))
	   )
	 )
       (setq pvstail pvs)
       (setq pvstail (vl-remove (assoc "TextAlignmentPoint" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "InsertionPoint" pvstail) pvstail))
       (setq pvstail (vl-remove (assoc "Alignment" pvstail) pvstail))


       
       
       (mapcar
	 '(lambda (pv)	;(setq pv (car (car propvals)))
	    (eval
	      (list
		(read (strcat "vla-put-" (car pv)))
		ado
		(cadr pv)
		)
	      )
	    )
	 pvstail
	 )

       (vlax-release-object ado)
       )
    propvals
    )
  );defun




















