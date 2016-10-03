;;;   pe_styles
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


(setq #STL:TEXTSTYLENAME "pe_gost")
(setq #STL:MLEADERSTYLENAME "pe_gost")
(setq #STL:DIMSTYLENAME "pe_gost")

;;	TEXT STYLE
(if (null (member #STL:TEXTSTYLENAME (mapcar 'vla-get-name (cont>list (vla-get-TextStyles #actdoc)))))
  (progn
    (setq #STL:TEXTSTYLE (vla-add (vla-get-TextStyles #actdoc) #STL:TEXTSTYLENAME))
    (vla-put-fontFile #STL:TEXTSTYLE "CS_Gost2304.shx")
    (vla-put-Height #STL:TEXTSTYLE 0)
    (vla-put-LastHeight #STL:TEXTSTYLE 2.5)
    )
  (alert (strcat "\"" #STL:TEXTSTYLENAME "\"" " is already in the drawing!"))
  )
(vla-put-ActiveTextStyle #actdoc #STL:TEXTSTYLE)



;;	DIM STYLE






;	(setq name "_ARCHTICK")

(defun _lispru-get-or-create-dimblock (name / err dimblk)
  (setq name "_ArchTick")
  ;|
*    Получение ename-указателя или создание блока с переданным именем
* Если name попадает под стандартные наименования:
"" || "_DOT"        || "_DOTSMALL" || "_DOTBLANK"    || "_ORIGIN"      ||
   || "_ORIGIN2"    || "_OPEN"     || "_OPEN90"      || "_OPEN30"      ||
   || "_CLOSED"     || "_SMALL"    || "_NONE"        || "_OBLIQUE"     ||
   || "_BOXFILLED"  || "_BOXBLANK" || "_CLOSEDBLANK" || "_DATUMFILLED" ||
   || "_DATUMBLANK" || "_INTEGRAL" || "_ARCHTICK"

*  То используется механизм через (setvar / getvar). В противном случае получается
* указатель на имеющийся блок с таким именем. Если такого блока нет, он создается
* пустым.
*    Примеры вызова:
(_lispru-get-or-create-dimblock "qwert")
(_lispru-get-or-create-dimblock "archtick")
|;
  (cond
    (
     (wcmatch (strcase (vl-string-left-trim "_" name)) (strcat "\"\",DOT,DOTSMALL,DOTBLANK,ORIGIN,ORIGIN2," "OPEN,OPEN90,OPEN30,CLOSED,SMALL," "NONE,OBLIQUE,BOXFILLED,BOXBLANK,CLOSEDBLANK," "DATUMFILLED,DATUMBLANK,INTEGRAL,ARCHTICK"))
     (if (vl-catch-all-error-p
           (setq err (vl-catch-all-apply
                       (function
                         (lambda ()
                           (setq dimblk (getvar "dimblk"))
                           (setvar "dimblk" (strcat "_" (vl-string-left-trim "_" name)))
                           (setvar "dimblk" dimblk)
                           (setq res (tblobjname "block" (strcat "_" (vl-string-left-trim "_" name))))
                           )
                         )
                       )
                 )
           )
       (princ)
       (setq res (tblobjname "block" (strcat "_" (getvar "dimblk"))))
       )
     (tblobjname "block" name)
     )
    (t
     (vla-add (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object))) (vlax-3d-point '(0. 0. 0.)) name)
     (tblobjname "block" name)
     )
    )
  );defun



;;;
;;;
;;;(setq dstyle
;;;
;;;(entmakex (list
;;;            (cons 0 "DIMSTYLE")
;;;            (cons 100 "AcDbSymbolTableRecord")
;;;            (cons 100 "AcDbDimStyleTableRecord")
;;;            (cons 2 "DimStyleName")
;;;            (cons 70 0)
;;;            (cons 40 (getvar "dimscale")) ;dimscale 
;;;            (cons 41 2.5) ;dimsz    
;;;            (cons 42 0.625) ;dimexo   
;;;            (cons 43 3.75) ;dimdli    
;;;            (cons 44 1.25) ;dimexe    
;;;            (cons 45 0.5) ;dimrnd   
;;;            (cons 46 0.0) ;dimdle   
;;;            (cons 140 2.5) ;dimtxt    
;;;            (cons 141 -2.5) ;dimcen   
;;;            (cons 143 0.005) ;dimaltf 
;;;            (cons 145 0) ;dimtvp
;;;            (cons 147 0.5) ;dimgap    
;;;            (cons 72 0) ;dimlim
;;;            (cons 73 0) ;dimtih   
;;;            (cons 74 0) ;dimtoh   
;;;            (cons 77 1) ;dimtad   
;;;            (cons 78 8) ;dimzin   
;;;            (cons 79 2) ;dimazin  
;;;            (cons 170 0) ;dimalt
;;;            (cons 172 1) ;dimtofl 
;;;            (cons 173 0) ;dimsah    
;;;            (cons 174 0) ;dimtix
;;;            (cons 175 1) ;dimsoxd
;;;            (cons 176 0) ;dimclrd
;;;            (cons 177 0) ;dimclre
;;;            (cons 178 0) ;dimclrt
;;;            (cons 179 1) ;dimadec
;;;            (cons 271 0) ;dimdec    
;;;            (cons 272 0) ;dimtdec 
;;;            (cons 275 1) ;dimaunit
;;;            (cons 277 2) ;dimlunit
;;;            (cons 278 44) ;dimdsep  
;;;            (cons 279 0) ;dimtmove
;;;            (cons 280 0) ;dimjust
;;;            (cons 281 0) ;dimsd1
;;;            (cons 282 0) ;dimsd2
;;;            (cons 283 0) ;dimtolj
;;;            (cons 284 8) ;dimtzin
;;;            (cons 288 0) ;dimupt
;;;            (cons 340 (tblobjname "style" (getvar "textstyle"))) ;dimtxtsty 
;;;            (cons 371 -2) ;dimlwd
;;;            (cons 372 -2) ;dimlwe
;;;            (cons 342 (_lispru-get-or-create-dimblock "_ArchTick"))
;;;            (cons 343 (_lispru-get-or-create-dimblock "_ArchTick"))
;;;            (cons 344 (_lispru-get-or-create-dimblock "_ArchTick"))
;;;            ) ;_ end of list
;;;          )) ;_ end of setq
;;;
;;;

































(if (null (member #STL:MLEADERSTYLENAME (mapcar 'vla-get-name (cont>list (vla-item (vla-get-dictionaries #actdoc) "ACAD_MLEADERSTYLE")))))
    (STL|addmleaderstyle #STL:MLEADERSTYLENAME)
    )

















(vla-put-ActiveTextStyle #actdoc #gosttextstyle)