;(setq obj (vlax-ename->vla-object (car (entsel))))
;(setq att (getbatt obj "FORMAT_NAME"))
;(setq vyb (getbdyn obj "¬˚·Ó"))


;-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
(defun c:cbr () 
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		) T));acet-error-init
  (cable-block-repare)
  (acet-error-restore)
  (vla-endundomark #actdoc)
);defun
;-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
(defun cable-block-repare ( / obj att att1 att2 att2)
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (setq att (getbatt obj "Œ“Œ¡–¿∆≈Õ»≈_“»œ¿"))
  (setq att1 (getbatt obj "“»œ_ ¿¡≈Àﬂ"))
  (setq att2 (getbatt obj "∆»À‹ÕŒ—“‹"))
  (setq att3 (getbatt obj "—≈◊≈Õ»≈"))
  (vla-put-Textstring att
    (strcat
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att1))
      ">%).TextString>%"
      "  "
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att2))
      ">%).TextString>%"
      "x"
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att3))
      ">%).TextString>%"      
      )
    )
  (vl-cmdf "_updatefield" (vlax-vla-object->ename att) "")
  );defun
;-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*