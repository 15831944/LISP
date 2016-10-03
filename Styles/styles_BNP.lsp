;;;   BNP_styles


(vl-load-com)
(setq
  #cad (vlax-get-acad-object)
  #actdoc (vla-get-activedocument #cad)
  #modspace (vla-get-modelspace #actdoc)
  )

 ;"SPDS"
;;;(setq #spdstextstyle (vla-add (vla-get-TextStyles #actdoc) "SPDS"))
;;;(vla-put-fontFile #spdstextstyle "SPDS.shx")
;;;(vla-put-Height #spdstextstyle 0)
;;;(vla-put-LastHeight #spdstextstyle 5)



 ;"GOST 2.304"
;;;(setq #gosttextstyle (vla-add (vla-get-TextStyles #actdoc) "GOST 2.304"))
;;;(vla-put-fontFile #gosttextstyle "CS_Gost2304.shx")
;;;(vla-put-Height #gosttextstyle 0)
;;;(vla-put-LastHeight #gosttextstyle 2.5)


(setq    #STL:TEXTSTYLENAME 	"BNP")
(setq #STL:MLEADERSTYLENAME 	"BNP")
(setq     #STL:DIMSTYLENAME 	"BNP")
(setq   #STL:TABLESTYLENAME	"BNP")



;;; загружаем блок со стилями
(setq tmpblk (vla-InsertBlock #modspace (vlax-3d-point '(0 0 0))
	       (strcat #lisppath "styles\\BNP.dwg")
	       0.001 0.001 0.001 0))


;;	TEXT STYLE
(if (null (member #STL:TEXTSTYLENAME (mapcar 'vla-get-name (cont>list (vla-get-TextStyles #actdoc)))))
  (progn
    (setq #STL:TEXTSTYLE (vla-add (vla-get-TextStyles #actdoc) #STL:TEXTSTYLENAME))
    (vla-put-fontFile #STL:TEXTSTYLE "cs_gost2304.shx")
    ;(vla-put-fontFile #STL:TEXTSTYLE "pe_gost2304.shx")
    (vla-put-Height #STL:TEXTSTYLE 0)
    (vla-put-LastHeight #STL:TEXTSTYLE 2.5)
    )
  (progn
    (setq #STL:TEXTSTYLE (vla-item (vla-get-TextStyles #actdoc) #STL:TEXTSTYLENAME))
    (alert (strcat "\"" #STL:TEXTSTYLENAME "\"" " is already in the drawing!"))
    )
  )


;;	TEXT STYLE
(vla-put-ActiveTextStyle #actdoc #STL:TEXTSTYLE)
;;	DIM STYLE
(vla-put-ActiveDimStyle #actdoc (vla-item (vla-get-DimStyles #actdoc) #STL:DIMSTYLENAME))
;;	MLEADER STYLE
(setvar "CMLEADERSTYLE" #STL:MLEADERSTYLENAME)
;;	TABLE STYLE
(setvar "CTABLESTYLE" #STL:TABLESTYLENAME)
































