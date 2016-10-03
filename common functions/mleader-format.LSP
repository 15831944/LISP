;;;;;  13_07_31
(load (strcat #lisppath "strings\\kd-mtext-unformat.LSP"))

;(vlax-get-property (vlax-ename->vla-object (car (entsel))) "color")
(defun uncolor (obj) (vlax-put-property obj "color" 256))

;;;*********************************************************************************************
;;;***********************    1    *************************************************************
;;;*********************************************************************************************
;;;*********************************************************************************************
(defun c:mlf ( / ent)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list
			   "cmdecho" 0
			   "highlight" (getvar "highlight")
			   "limcheck" 0
			   "osmode" 0);list
			 T));acet-error-init
  (if (setq ent (entsel))
    (kd:mleader-format (car ent))
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;*********************************************************************************************
(defun c:ssmlf ( / lst)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0)T));acet-error-init
  (setq lst (get-ssofstrobj*))	
  (mapcar
    '(lambda (x)
       (kd:mleader-format (vlax-vla-object->ename x))
       )
    lst)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;*********************************************************************************************
;;;***********************    50   *************************************************************
;;;*********************************************************************************************
;;;*********************************************************************************************
(defun c:mlf50 ( / ent)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list
			   "cmdecho" 0
			   "highlight" (getvar "highlight")
			   "limcheck" 0
			   "osmode" 0);list
			 T));acet-error-init
  (if (setq ent (entsel))
    (kd:mleader-format-plan50 (car ent))
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;*********************************************************************************************
(defun c:ssmlf50 ( / lst)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0)T));acet-error-init
  (setq lst (get-ssofstrobj*))
  (mapcar
    '(lambda (x)
       (kd:mleader-format-plan50 (vlax-vla-object->ename x))
       )
    lst)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;*********************************************************************************************
;;;***********************   100   *************************************************************
;;;*********************************************************************************************
;;;*********************************************************************************************
(defun c:mlf100 ( / ent)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list
			   "cmdecho" 0
			   "highlight" (getvar "highlight")
			   "limcheck" 0
			   "osmode" 0);list
			 T));acet-error-init
  (if (setq ent (entsel))
    (kd:mleader-format-plan100 (car ent))
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;*********************************************************************************************
(defun c:ssmlf100 ( / lst)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0)T));acet-error-init
  (setq lst (get-ssofstrobj*))
  (mapcar
    '(lambda (x)
       (kd:mleader-format-plan100 (vlax-vla-object->ename x))
       )
    lst)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun



;;;*********************************************************************************************
;;;***********************    2    *************************************************************
;;;******************** когда нет высоких букв  ************************************************
;;;*********************************************************************************************
(defun c:mlf2 ( / ent)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list
			   "cmdecho" 0
			   "highlight" (getvar "highlight")
			   "limcheck" 0
			   "osmode" 0);list
			 T));acet-error-init
  (if (setq ent (entsel))
    (kd:mleader-format2 (car ent)	)
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;*********************************************************************************************
(defun c:ssmlf2 ( / lst)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0)T));acet-error-init
  (setq lst (get-ssofstrobj*))
  (mapcar
    '(lambda (x)
       (kd:mleader-format2 (vlax-vla-object->ename x))
       )
    lst)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun






;;;*********************************************************************************************
;;;***********************    3    *************************************************************
;;;******************** еще один вариант        ************************************************
;;;*********************************************************************************************
(defun c:mlf3 ( / ent)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list
			   "cmdecho" 0
			   "highlight" (getvar "highlight")
			   "limcheck" 0
			   "osmode" 0);list
			 T));acet-error-init
  (if (setq ent (entsel))
    (kd:mleader-format3 (car ent)	)
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;*********************************************************************************************
(defun c:ssmlf3 ( / lst)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0)T));acet-error-init
  (setq lst (get-ssofstrobj*))
  (mapcar
    '(lambda (x)
       (kd:mleader-format3 (vlax-vla-object->ename x))
       )
    lst)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun







;;;*********************************************************************************************
;;;***********************    4    *************************************************************
;;;******************** еще один вариант        ************************************************
;;;*********************************************************************************************
(defun c:mlf4 ( / ent)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list
			   "cmdecho" 0
			   "highlight" (getvar "highlight")
			   "limcheck" 0
			   "osmode" 0);list
			 T));acet-error-init
  (if (setq ent (entsel))
    (kd:mleader-format4 (car ent)	)
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
;;;*********************************************************************************************
(defun c:ssmlf4 ( / lst)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0)T));acet-error-init
  (setq lst (get-ssofstrobj*))
  (mapcar
    '(lambda (x)
       (kd:mleader-format4 (vlax-vla-object->ename x))
       )
    lst)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun












































;(kd:mleader-format (car (entsel)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kd:mleader-format (ent / obj str lays lcol)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (setq obj (vlax-ename->vla-object ent))
  (setq str (kd:mtextstring-unformat
	      ;(vla-get-TextString obj)
	      (kd-get-TextString obj)
	      )
	;str (strcat "\\pxse0.92;" str)
	str (strcat "\\pxa0.4,se0.88;" str)
	)
  (vla-put-textstring obj str)
  (vla-put-TextHeight obj 2.5)
  
  ;(vla-put-TextLineSpacingStyle obj 2) 	;внизу
  ;(vla-put-TextLineSpacingFactor obj 0.72)	;внизу
  ;(vla-put-TextLineSpacingDistance obj 3)	;ненадо
  ;(vla-put-LandingGap obj 0)
  ;(vla-put-TextStyleName obj "GOST 2.304")
  ;(vla-put-TextStyleName obj "SPDS")

  ;(vla-put-ArrowheadType obj 19)
  
  (vla-put-DogLegged obj :vlax-false)
  ;(vla-put-DoglegLength obj 2)
  (vla-put-TextJustify obj 2)
  (vla-put-TextLeftAttachmentType obj 3)
  (vla-put-TextRightAttachmentType obj 3)
  (if (not (tblobjname "layer" "com_text"))
    (progn
      (command "_.-layer" "_new" "com_text" "_color" "161" "нумерация" "")
      (setq lays (vla-get-Layers #actdoc))
      (setq lcol (vla-GetInterfaceObject #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2))))
      (vla-SetRGB lcol 201 201 201)
      (vla-put-TrueColor (vla-item lays "com_text") lcol)
      )
    )
  (vla-put-layer obj "com_text")
  (uncolor obj)
  (vla-Update obj)
  (vla-put-TextLineSpacingStyle obj 2)
  (vla-put-TextLineSpacingFactor obj 0.96)
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kd:mleader-format-plan50 (ent / obj str lays lcol)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (setq obj (vlax-ename->vla-object ent)
	str (kd:mtextstring-unformat (vla-get-TextString obj))
	;str (strcat "\\pxse0.92;" str)
	str (strcat "\\pxa0.4,se0.88;" str)
	)
  (vla-put-textstring obj str)
  (vla-put-TextHeight obj 125)
  ;(vla-put-LandingGap obj 0)
  ;(vla-put-TextStyleName obj "GOST 2.304")
  ;(vla-put-TextStyleName obj "SPDS")
  ;(vla-put-ArrowheadType obj 19)
  (vla-put-DogLegged obj :vlax-false)
  ;(vla-put-DoglegLength obj 2)
  (vla-put-TextJustify obj 2)
  (vla-put-TextLeftAttachmentType obj 3)
  (vla-put-TextRightAttachmentType obj 3)
  (uncolor obj)
  (vla-put-TextLineSpacingStyle obj 2)
  (vla-put-TextLineSpacingFactor obj 0.96)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kd:mleader-format-plan100 (ent / obj str lays lcol)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (setq obj (vlax-ename->vla-object ent)
	str (vla-get-TextString obj)
	str (kd:mtextstring-unformat str)
	;str (strcat "\\pxse0.92;" str)
	str (strcat "\\pxa0.4,se0.88;" str)
	)
  (vla-put-textstring obj str)
  (vla-put-TextHeight obj 250)
  ;(vla-put-LandingGap obj 0)
  ;(vla-put-TextStyleName obj "GOST 2.304")
  ;(vla-put-TextStyleName obj "SPDS")
  ;(vla-put-ArrowheadType obj 19)
  ;(vla-put-DogLegged obj :vlax-false)
  (vla-put-DoglegLength obj 200)
  (vla-put-TextJustify obj 2)
  (vla-put-TextLeftAttachmentType obj 3)
  (vla-put-TextRightAttachmentType obj 3)
  (uncolor obj)
  (vla-put-TextLineSpacingStyle obj 2)
  (vla-put-TextLineSpacingFactor obj 0.96)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kd:mleader-format2 (ent / obj str lays lcol)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (setq obj (vlax-ename->vla-object ent)
	str (kd:mtextstring-unformat (vla-get-TextString obj))
	str (vl-string-subst "\\P" " " str)
	str (strcat "\\pxa0.4,se0.6;" str)
	)
  
  (vla-put-textstring obj str)
  (vla-put-TextHeight obj 2.5)
  ;(vla-put-LandingGap obj 0)
  ;(vla-put-TextStyleName obj "GOST 2.304")
  ;(vla-put-TextStyleName obj "SPDS")
  (vla-put-ArrowheadType obj 19)
  (vla-put-DogLegged obj :vlax-false)
  ;(vla-put-DoglegLength obj 2)
  (vla-put-TextJustify obj 2)
  (vla-put-TextLeftAttachmentType obj 3)
  (vla-put-TextRightAttachmentType obj 3)
  (if (not (tblobjname "layer" "com_text"))
    (progn
      (command "_.-layer" "_new" "com_text" "_color" "161" "нумерация" "")
      (setq lays (vla-get-Layers #actdoc))
      (setq lcol (vla-GetInterfaceObject #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2))))
      (vla-SetRGB lcol 201 201 201)
      (vla-put-TrueColor (vla-item lays "com_text") lcol)
      )
    )
  (vla-put-layer obj "com_text")
  (uncolor obj)
  (vla-put-TextLineSpacingStyle obj 2)
  (vla-put-TextLineSpacingFactor obj 0.96)
  );defun





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kd:mleader-format3 (ent / obj str lays lcol)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (setq obj (vlax-ename->vla-object ent)
	str (kd:mtextstring-unformat (vla-get-TextString obj))
	;str (vl-string-subst "\\P" " " str)
	str (strcat "\\pxse0.8;" str)
	)
  
  (vla-put-textstring obj str)
  (vla-put-TextHeight obj 2.5)
  ;(vla-put-LandingGap obj 0)
  ;(vla-put-TextStyleName obj "GOST 2.304")
  ;(vla-put-TextStyleName obj "SPDS")
  (vla-put-ArrowheadType obj 19)
  (vla-put-DogLegged obj :vlax-false)
  ;(vla-put-DoglegLength obj 2)  
  (vla-put-TextJustify obj 2)
  (vla-put-TextLeftAttachmentType obj 3)
  (vla-put-TextRightAttachmentType obj 3)
  (if (not (tblobjname "layer" "com_text"))
    (progn
      (command "_.-layer" "_new" "com_text" "_color" "161" "нумерация" "")
      (setq lays (vla-get-Layers #actdoc))
      (setq lcol (vla-GetInterfaceObject #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2))))
      (vla-SetRGB lcol 201 201 201)
      (vla-put-TrueColor (vla-item lays "com_text") lcol)
      )
    )
  (vla-put-layer obj "com_text")
  (uncolor obj)
  (vla-put-TextLineSpacingStyle obj 2)
  (vla-put-TextLineSpacingFactor obj 0.96)
  );defun








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kd:mleader-format4 (ent / obj str lays lcol)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  (setq obj (vlax-ename->vla-object ent)
	str (kd:mtextstring-unformat (vla-get-TextString obj))
	;str (vl-string-subst "\\P" " " str)
	str (strcat "\\pxa1.3,se0.5;" str)
	)
  
  (vla-put-textstring obj str)
  (vla-put-TextHeight obj 2.5)
  ;(vla-put-LandingGap obj 0)
  ;(vla-put-TextStyleName obj "GOST 2.304")
  ;(vla-put-TextStyleName obj "SPDS")
  (vla-put-ArrowheadType obj 19)
  (vla-put-DogLegged obj :vlax-false)
  ;(vla-put-DoglegLength obj 2)
  (vla-put-TextJustify obj 2)
  (vla-put-TextLeftAttachmentType obj 3)
  (vla-put-TextRightAttachmentType obj 3)
  (if (not (tblobjname "layer" "com_text"))
    (progn
      (command "_.-layer" "_new" "com_text" "_color" "161" "нумерация" "")
      (setq lays (vla-get-Layers #actdoc))
      (setq lcol (vla-GetInterfaceObject #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2))))
      (vla-SetRGB lcol 201 201 201)
      (vla-put-TrueColor (vla-item lays "com_text") lcol)
      )
    )
  (vla-put-layer obj "com_text")
  (uncolor obj)
  (vla-put-TextLineSpacingStyle obj 2)
  (vla-put-TextLineSpacingFactor obj 0.96)
  );defun






;;;
;;;
;;;
;;;;;;*********************************************************************************************
;;;(defun c:mtaf ( / ent)
;;;  (vla-startundomark #actdoc)
;;;  (acet-error-init (list (list
;;;			   "cmdecho" 0
;;;			   "highlight" (getvar "highlight")
;;;			   "limcheck" 0
;;;			   "osmode" 0);list
;;;			 T));acet-error-init
;;;  (if (setq ent (entsel))
;;;    (kd:mtextsttribute-format (car ent))
;;;    )
;;;  (acet-error-restore)
;;;  (vla-endundomark #actdoc)
;;;  );defun
;;;;;;*********************************************************************************************  
;;;
;;;
;;;(defun kd:mtextsttribute-format (ent / obj str lays lcol)
;;;  ;(setq obj (vlax-ename->vla-object (car (nentsel))))
;;;
;;;
;;;  (setq obj (vlax-ename->vla-object ent))
;;;
;;;
;;;
;;;  (setq str (kd:mtextstring-unformat (kd-get-TextString obj)))
;;;  (vla-put-TextString obj (strcat "\\pxa0.4,se0.88;" str))
;;;	
;;;
;;;
;;;  
;;;
;;;  (vla-put-LineSpacingStyle obj 2)
;;;  (vla-put-LineSpacingDistance obj 3.5)
;;;
;;;
;;;
;;;  
;;;  (setq str (kd:mtextstring-unformat
;;;	      ;(vla-get-TextString obj)
;;;	      (kd-get-TextString obj)
;;;	      )
;;;	;str (strcat "\\pxse0.92;" str)
;;;	str (strcat "\\pxa0.4,se0.88;" str)
;;;	)
;;;  (vla-put-textstring obj str)
;;;  (vla-put-TextHeight obj 2.5)
;;;  ;(vla-put-TextLineSpacingStyle obj 2) 	;внизу
;;;  ;(vla-put-TextLineSpacingFactor obj 0.72)	;внизу
;;;  ;(vla-put-TextLineSpacingDistance obj 3)	;ненадо
;;;  ;(vla-put-LandingGap obj 0)
;;;  ;(vla-put-TextStyleName obj "GOST 2.304")
;;;  (vla-put-ArrowheadType obj 19)
;;;  (vla-put-DogLegged obj :vlax-false)
;;;  ;(vla-put-DoglegLength obj 2)
;;;  (vla-put-TextJustify obj 2)
;;;  (vla-put-TextLeftAttachmentType obj 3)
;;;  (vla-put-TextRightAttachmentType obj 3)
;;;  (if (not (tblobjname "layer" "com_надписи"))
;;;    (progn
;;;      (command "_.-layer" "_new" "com_надписи" "_color" "161" "нумерация" "")
;;;      (setq lays (vla-get-Layers #actdoc))
;;;      (setq lcol (vla-GetInterfaceObject #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2))))
;;;      (vla-SetRGB lcol 201 201 201)
;;;      (vla-put-TrueColor (vla-item lays "com_надписи") lcol)
;;;      )
;;;    )
;;;  (vla-put-layer obj "com_надписи")
;;;  (uncolor obj)
;;;  (vla-Update obj)
;;;  (vla-put-TextLineSpacingStyle obj 2)
;;;  (vla-put-TextLineSpacingFactor obj 0.96)
;;;  )