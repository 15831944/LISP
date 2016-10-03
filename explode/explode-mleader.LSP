;;; 13_11_12
;;; acad 2013 - работает
;;; ломались диаметры при текстовом стиле mleaders GOST, добавил приндительтное SPDS - в c:mlf

;(explode-mleader (vlax-ename->vla-object (car (entsel))))
;;;(defun explode-mleader (obj / en txto)
;;;  
;;;  ;(setq obj (vlax-ename->vla-object (car (entsel))))
;;;  ;(setq txto (vla-AddMText #modspace (vlax-3D-Point '(0 0 0)) 0 ""))
;;;  ;(vlax-put-property txto "AttachmentPoint" (vlax-get-property obj "TextJustify"))
;;;  ;(vlax-put-property txto "Width" (vlax-get-property obj "TextWidth"))
;;;  ;(vlax-put-property txto "Height" (vlax-get-property obj "TextHeight"))
;;;  ;(vlax-put-property txto "Layer" (vlax-get-property obj "Layer"))
;;;  ;(vlax-put-property txto "DrawingDirection" (vlax-get-property obj "TextDirection"))
;;;  ;(vla-put-Textstring txto (kd-get-Textstring obj))
;;;
;;;
;;;
;;;  ;(vlax-put-property txto "LineSpacingDistance" (vlax-get-property obj "TextLineSpacingDistance"))
;;;  ;(vlax-put-property txto "LineSpacingFactor" (vlax-get-property obj "TextLineSpacingFactor"))
;;;  ;(vlax-put-property txto "LineSpacingStyle" (vlax-get-property obj "TextLineSpacingStyle"))
;;;  ;(vlax-put-property txto "StyleName" (vlax-get-property obj "TextStyleName"))
;;;
;;;
;;;  ;(vlax-get-property obj "HasExtensionDictionary")
;;;  ;(vlax-get-property dict "HasExtensionDictionary")
;;;  ;(setq dict (vla-GetExtensionDictionary obj))
;;;  ;(entget (vlax-vla-object->ename dict))
;;;  
;;;  ;(vla-GetLeaderIndex obj 1)
;;;
;;;
;;;
;;;  
;;;  ;(vlax-put-property txto "InsertionPoint" (vlax-get-property obj "TextDirection"))
;;;  ;(vlax-put-property txto "InsertionPoint" (vlax-3d-point (getpoint)))
;;;
;;;
;;;  ;(vla-put-DogLegged obj :vlax-false)
;;;
;;;
;;;
;;;  ;(vla-put-TextLineSpacingFactor obj 3)
;;;
;;;
;;;  
;;;  
;;;  ;(setq en (vlax-variant-value (vla-explode obj)))
;;;  (setq en (vlax-vla-object->ename obj))
;;;  ;(reverse (member "}" (reverse (member "{ACAD_XDICTIONARY" (mapcar 'cdr (entget en))))))
;;;  (vl-cmdf "_.explode" "_o" en)
;;;  ;(vl-cmdf "_.explode")
;;;  (princ)
;;;  );defun




(defun explode-mleaders ( / ss mleaderslayername layname lays lst echo)
  (setq echo (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  
  (setq layname "_lsp_mleader-explode-layer")
  (setq mleaderslayername "com_text")
  ;(setq lst (ss->lsto* (ssget "_X" '((0 . "MULTILEADER")))))
  (if
    (setq lst (ssget "_X" '((0 . "MULTILEADER"))))
    (progn
      (setq lst (ss->lsto* lst))
      
  (if (not (tblobjname "layer" layname))
    (progn
      (command "_.-layer" "_new" layname "_color" "161" layname "")
      ;(setq lays (vla-get-Layers #actdoc))
      ;(setq lcol (vla-GetInterfaceObject #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2))))
      ;(vla-SetRGB lcol 201 201 201)
      ;(vla-put-TrueColor (vla-item lays "com_надписи") lcol)
      )
    )

  (if (not (tblobjname "layer" mleaderslayername))
    (progn
      (command "_.-layer" "_new" mleaderslayername "_color" "254" mleaderslayername "")
      ;(setq lays (vla-get-Layers #actdoc))
      ;(setq lcol (vla-GetInterfaceObject #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2))))
      ;(vla-SetRGB lcol 201 201 201)
      ;(vla-put-TrueColor (vla-item lays "com_надписи") lcol)
      )
    )    
      
  (mapcarx vla-put-layer layname lst)
  (mapcar '(lambda (x) (vl-cmdf "_explode" "_o" (vlax-vla-object->ename x))) lst)

      (if (setq lst (ss->lsto* (setq ss (ssget "_X" (list '(0 . "*LINE") (cons 8 layname))))))
	(mapcarx vla-put-layer mleaderslayername lst)
	)

      (if (setq lst (ss->lsto* (setq ss (ssget "_X" (list '(0 . "INSERT") (cons 8 layname))))))
	(mapcarx vla-put-layer mleaderslayername lst)
	)

      (if (setq lst (ss->lsto* (setq ss (ssget "_X" (list '(0 . "*TEXT") (cons 8 layname))))))
	
  (mapcar
    '(lambda (x / th)
       (setq th (vla-get-height x))
       (vla-put-layer x mleaderslayername)
       (vla-move x (vlax-3d-point '(0 0 0)) (vlax-3d-point (list 0 (* 0.2 th) 0)))
       (vla-put-LineSpacingStyle x 2)
       (vla-put-LineSpacingFactor x 0.96)
       ;(uncolor x)
       (vlax-put-property x "color" 256)
       )
    lst)
	)

  ;(mapcarx vla-Update nil lst)
  ;(vla-Regen #actdoc acActiveViewport)      

      
  (if (setq ss (ssget "_X" (list '(2 . "_None") (cons 8 layname))))
    (progn
      (setq lst (ss->lsto* ss))
      (mapcarx vla-delete nil lst)
      )
    )
  
  (vla-Delete (vla-item (vla-get-Layers #actdoc) layname))
      )
    )
  (setvar "cmdecho" echo)
  );defun