;;; изменена 10_06_01
;;; запуск программы с коммандной строки :
;;; cleanup
;;; прога для разбивания блоков и очистки файла от мусора
;;; разбивает блоки, спдс-объекты, полилинии,
;;; ВНИМАНИЕ!!! все описания блоков из чертежа будут удалены
;;; использовать хорошо обдумав последствия
;;; -kakt00z-™  ©

(vl-load-com)

(defun c:cleanup (
		  /
		  doc
		  ms
		  lays
		  errlay
		  c_red
	      ss
	      i
	      los
	      ltodel
		  
	      )
  
    (setq doc (vla-get-activedocument (vlax-get-acad-object)))
    (setq ms (vla-get-ModelSpace doc))
    (vla-startundomark doc)
    (acet-error-init
        (list (list "cmdecho" 0
                    "highlight" (getvar "highlight")
                    "limcheck" 0
                    "osmode" 0
                    );list
              T);list
    );acet-error-init
  (setq c_red (vla-GetInterfaceObject (vlax-get-acad-object) "AutoCAD.AcCmColor.18"))
  (vla-put-entityColor c_red -1023410175) 
  (setq lays (vla-get-Layers doc))
  (setq errlay (vla-add lays "errors"))
  (vla-put-Plottable errlay :vlax-false)
  (vlax-put-property errlay "Truecolor" c_red)

  ;(setq ut (vla-get-utility doc))
  ;(vla-sendmodelessoperationstart ut "string")
  ;(vla-sendmodelessoperationended ut "string")

  (vla-sendcommand doc "_spexplodeall ")


  (setq blocks (vla-get-Blocks doc))
  (do (vla-item blocks 5))


  


  
  (setq i 0)

  (setq ss (ssget "_X" '((0 . "INSERT"))))
  (if ss
    (repeat (sslength ss)
      (if (and
              (ssname ss i)
              (= 1 (cdr (assoc 66 (entget (ssname ss i)))))
              )
	;(burst-one (ssname ss i))
	(block-explode (vlax-ename->vla-object (ssname ss i)))
	(vl-cmdf "_explode" (ssname ss i))
	)
      (setq i (1+ i))
      );repeat
    )
  
  (setq ss (ssget "_X" '((0 . "*TEXT") (-4 . "<OR") (1 . "") (1 . " ")(-4 . "OR>"))))
  (if ss (vl-cmdf "_erase" ss ""))


    (setq ss (ssget "_X" '((370 . 0))))
    (setq i 0)
    (if ss
      (repeat (sslength ss)
	(setq eng (vl-remove '(370 . 0) (entget (ssname ss i))))
	(entmod eng)
	(entupd (ssname ss i))
	(setq i (1+ i))
	);repeat
      )

  
  (setq ss (ssget "_X" '((1 . "Копировал"))))
  (if ss (vl-cmdf "_erase" ss ""))

  ;(vl-cmdf "_.explode" (ssget "_X" '((0 . "LWPOLYLINE"))) "\n")

  (setq ss (ssget "_X" '((0 . "*POLYLINE"))))
  (if ss
    (progn
      (setq ss (ss->list* ss))
      (load "d:/LISP WORKING/explode/explode-pline.LSP")
      (mapcar '(lambda(x) (explode-pline (vlax-ename->vla-object x))) ss)
      )
    )

  
  (vla-purgeall doc)
  ;(fields-destroy)
  ;(field-check)
  ;\n удалить непечатаемое
  (setq i 0
	ltodel '())
  
  (setq los (vla-get-Layers doc))
  (repeat (vla-get-count los)
    (if (= :vlax-false (vla-get-plottable (vla-item los i)))
      (setq ltodel (append ltodel (list (vla-item los i))))
      )
    (setq i (1+ i))
    )

  (foreach layer ltodel
    (setq ss (ssget "_X" (list (cons 8 (vla-get-name layer)))))
    (if ss (vl-cmdf "_erase" ss ""))
    )
  
;;;  (vlax-dump-Object (vla-item  (vla-get-Layers doc) 2))
;;;  (tblsearch "Layer" "невидимые_аттриуты")
;;;  (tblsearch "Layer" "*")
  
  ;\n выполнить проверку на наезжание текстов txt-overlay.LSP
  ;(check-txt-overlay)

  (alert "\n
  \n проверить слой errors на наличие ошибок - сломанные поля и \"наезд\" текста,
  \n на общих видах обработать пересечение DIN-реек
  \n так же запустим прогу из экспресса OVERKILL
  \n                  ДИАМЕТРЫ И КВАДРАТЫ %%C
	 ")
  

  (acet-error-restore)
  (vla-endundomark doc)
  );defun


;(vlax-dump-object (vlax-ename->vla-object (car (entsel))) T)











(defun field-check (
		    /
		    objlist
		    i
		    ss
		    bl
		    str
		    ent
		    isAttNotAdded
		    n
		    )

  (setq	objlist	'(
		  (-4 . "<OR")
		  (0 . "TEXT")
		  (0 . "MTEXT")
		  (0 . "ATTRIB")
		  (0 . "ATTDEF")
		  (-4 . "<AND")
		  (0 . "INSERT")
		  (66 . 1)
		  (-4 . "AND>")
		  (-4 . "OR>")
		  )
	i	0
	ss1	(ssadd)
	n	0
	) ;setq
  (setq ss (ssget "_X" objlist))

  (princ "\nКоличество подозреваемых носителей сломанных полей : ")
  (princ (sslength ss))
  (princ "\n")
  (repeat (sslength ss)
    (setq ent (ssname ss i))
    (if	(= "INSERT" (cdr (assoc 0 (entget ent))))
      (progn
	(setq ent (entnext ent)
	      isattnotadded T
	      ) ;_ конец setq
	(while isattnotadded
	  (setq str (cdr (assoc 1 (entget ent))))
	  ;(setq str (vl-string->list str))
	  (if
	    (or
	      (member 35 (vl-string->list str))
	      (wcmatch str "*----*")
	      )
	    (progn
	      (setq bl (entget (cdr (assoc 330 (entget ent))))
		    isattnotadded	nil
		    ) ;_ конец setq
	      (setq bl (subst '(8 . "errors") (assoc 8 bl) bl))
	      (setq bl (subst '(62 . 256) (assoc 62 bl) bl))
	      (entmod bl)
	      (entupd (cdr (assoc -1 bl)))
	      (setq n (1+ n))
	      )
	    ) ;if member
	  (setq ent (entnext ent))
	  (if isattnotadded
	    (setq isattnotadded
		   (/= "SEQEND" (cdr (assoc 0 (entget ent))))
		  ) ;_ конец setq
	    ) ;_ конец if
	  ) ;while
	) ;progn
      ;else
      (progn
	(setq str (cdr (assoc 1 (entget ent))))
	;(setq str (vl-string->list str))
	(if (or
	      (member 35 (vl-string->list str))
	      (wcmatch str "*----*")
	      )
	  (progn
	    (setq bl (entget ent))
	    (setq bl (subst '(8 . "errors") (assoc 8 bl) bl))
	    (setq bl (subst '(62 . 256) (assoc 62 bl) bl))
	    (entmod bl)
	    (entupd (cdr (assoc -1 bl)))
	    (setq n (1+ n))
	    )
	  ) ;if member
	) ;_ конец progn
      ) ;if insert
    (setq i (1+ i))
    ) ;_ конец repeat
  (princ "\nКоличество обладателей сломанных полей : ")
  (princ n)
  ) ;defun








(defun fields-destroy (
	     /
	     ss
	     fltr
	     i
	     elist
	     )
  (setq fltr '((-4 . "<OR")
	       (0 . "*TEXT")
	       (0 . "ATTDEF")
	       (0 . "INSERT")
	       (-4 . "OR>"))
	i	0
	elist '()
	)
  (setq ss (ssget "_X" fltr))
  (repeat (sslength ss)
    (if (= "INSERT" (cdr (assoc 0 (entget (ssname ss i)))))
      (if (= 1 (cdr (assoc 66 (entget (ssname ss i)))))
	(setq elist (append elist (get-bl-atts (ssname ss i))))
	)
      (setq elist (append elist (list (vlax-ename->vla-object (ssname ss i)))))
      );if
    (setq i (1+ i))
    )

  (foreach item elist
    (delete-field
        ;(vlax-ename->vla-object
            item
        ;    )
        )
    )
  );defun
;;;******************************************************************************
;(defun delete-field (obj / str)
;  (if (and (= "AcDbBlockReference" (vla-get-ObjectName obj)) (= :vlax-true (vla-get-HasAttributes obj)))
;    (mapcar 'delete-field (vlax-safearray->list (vlax-variant-value (vla-GetAttributes obj))))
;    (progn
;      ;(setq str (vla-get-TextString obj))
;      (setq str (cdr (assoc 1 (entget (vlax-vla-object->ename obj)))))
;      (vla-put-textstring obj "dsf")
;      (vlax-put-property obj "TextString" str)
 ;     )
 ;   )
 ; );defun
;;;******************************************************************************
;(delete-field (vlax-ename->vla-object (car (entsel))))
;;;(vlax-dump-object
;;;(vlax-ename->vla-object (car (entsel))) T
;;;)
;;;
;;;(wcmatch (vla-fieldcode (vlax-ename->vla-object (car (entsel))))"*%<\\*")


(defun get-bl-atts (e)
    (vlax-safearray->list (vlax-variant-value(vla-getattributes (vlax-ename->vla-object e))))
    )
;;;******************************************************************************

;;;(setq atl (get-bl-atts (car (entsel))))




(Defun BURST-ONE (BNAME / BENT ANAME ENT ATYPE AENT AGAIN ENAME
                     ENT BBLOCK SS-COLOR SS-LAYER SS-LTYPE mirror ss-mirror
		     SS-LWEIGHT  ;_New VVA
		     TMP         ;_New VVA
		     attlist     ;_New VVA 20.03.2009
		     
                     mlast)
      (Setq
         BENT   (EntGet BNAME)
         BLAYER (ITEM 8 BENT)
         BCOLOR (ITEM 62 BENT)
         BBLOCK (ITEM 2 BENT)
         BCOLOR (Cond
                   ((> BCOLOR 0) BCOLOR)
                   ((= BCOLOR 0) "BYBLOCK")
                   ("BYLAYER")
                )
         BLTYPE (Cond ((ITEM 6 BENT)) ("BYLAYER"))
         BLWEIGHT (Cond
		    ((not (ITEM 370 BENT)) "BYLAYER") ;_Add VVA BURST LWEIGHT SECTION
		    ((minusp (ITEM 370 BENT)) "_D")     ;_Default ;_Add VVA BURST LWEIGHT SECTION
		    ((ITEM 370 BENT))                   ;_Add VVA BURST LWEIGHT SECTION
		    ("BYLAYER")                         ;_Add VVA BURST LWEIGHT SECTION
		    )                                       ;_Add VVA BURST LWEIGHT SECTION
      );setq
  
      (Setq ELAST (LASTENT))
      (If (and (EXPLODABLE BBLOCK) (= 1 (ITEM 66 BENT)))
         (Progn
            (Setq ANAME BNAME)
            (While (Setq
                      ANAME (EntNext ANAME)
                      AENT  (EntGet ANAME)
                      ATYPE (ITEM 0 AENT)
                      AGAIN (= "ATTRIB" ATYPE)
                   )
               (bump "Converting attributes")
	      
               (if (or (zerop (logand (cdr (assoc 70 AENT)) 1)) ;_Change by VVA Attr fix 03.09.2008 Not hidden attribute
		       (zerop (logand (cdr (assoc 70 AENT)) 9))	;_Add by kakt00z 1.06.2010
		       )
		 (progn
		  (setq tmp (cdr (assoc 2 AENT)))           ;_ add VVA 20.03.2009
	          (ATT-TEXT AENT)                           ;_Change by VVA Attr fix 03.09.2008
		  (setq attlist (cons (list tmp (entlast)) attlist)) ;_ add VVA 20.03.2009
		  )
		 )                                          ;_Change by VVA Attr fix 03.09.2008
            )
         )
      )
         (Progn
            (bump "Exploding block")
            (acet-explode BNAME)
         )
      (Setq
         SS-LAYER (SsAdd)
         SS-COLOR (SsAdd)
         SS-LTYPE (SsAdd)
         SS-LWEIGHT (SsAdd)    ;_Add VVA BURST LWEIGHT SECTION
         ENAME    ELAST
      )
      (While (Setq ENAME (EntNext ENAME))
         (bump "Gathering pieces")
         (Setq
            ENT   (EntGet ENAME)
            ETYPE (ITEM 0 ENT)
         )
         (If (= "ATTDEF" ETYPE)
            (Progn
	      (setq tmp (cdr(assoc 2 ENT)))                             ;_ add VVA 20.03.2009
	      (setq attlist (vl-remove (assoc tmp attlist) attlist))
	      ;(setq attlist (subst nil (assoc tmp attlist) attlist))    ;_ add VVA 20.03.2009
;;;               (If (BITSET (ITEM 70 ENT) 2)   ;_Rem by VVA Attr fix   03.09.2008
;;;                  (ATT-TEXT ENT)              ;_Rem by VVA Attr fix   03.09.2008
;;;               )                              ;_Rem by VVA Attr fix   03.09.2008
               (EntDel ENAME)
            )
            (Progn
               (If (= "0" (ITEM 8 ENT))
                  (SsAdd ENAME SS-LAYER)
               )
               (If (= 0 (ITEM 62 ENT))
                  (SsAdd ENAME SS-COLOR)
               )
;;; BURST FIX BUG by Vladimir Azarko aka VVA 03.09.2008
;;;	      (If (= "BYBLOCK" (ITEM 6 ENT))                          ;_Rem by VVA    03.09.2008
;;;                  (SsAdd ENAME SS-LTYPE)                           ;_Rem by VVA    03.09.2008
;;;               )                                                   ;_Rem by VVA    03.09.2008
	      
;_ -> START Change VVA BURST LTYPE
               (If (= "BYBLOCK" (strcase (cond ((ITEM 6 ENT))("")))) 
	       (if (= "0" (ITEM 8 ENT))(SsAdd ENAME SS-LTYPE)
		 (progn
		   (if (= "BYLAYER" (strcase (cond ((ITEM 6 BENT))("BYLAYER")))) ;_Block line type bylayer
		    (Command "_.chprop" ENAME "" "_LT" (ITEM 6 (entget (TBLOBJNAME "LAYER" BLAYER))) "")
		    (SsAdd ENAME SS-LTYPE) 
		     )
		   )
		 )
	     )
;_ <- END Change VVA BURST LTYPE
	      
	;_ -> START Change VVA BURST LWEIGHT SECTION
	(If (= -2 (ITEM 370 ENT)) ;_ -> BYBLOCK LWEIGHT
	       (if (= "0" (ITEM 8 ENT))
		 (SsAdd ENAME SS-LWEIGHT)
		 (progn
		   (if (NOT (ITEM 370 BENT)) ;_Block LWEIGHT BYLAYER
		    (Command "_.chprop" ENAME "" "_LW"
			     (if (minusp (setq TMP (ITEM 370 (entget (TBLOBJNAME "LAYER" BLAYER)))))
			       "_D"
			       (* TMP 0.01))
				   "")
		    (SsAdd ENAME SS-LWEIGHT) 
		     )
		   )
		 )
	     )
	;_ <- END Change VVA BURST LWEIGHT SECTION
            )
         )
      )
     (foreach itm attlist                 ;_ add VVA 20.03.2009
       (if itm (progn                     ;_ add VVA 20.03.2009
		 (setq tmp (cadr itm))    ;_ add VVA 20.03.2009
		 (ssdel tmp SS-LAYER)     ;_ add VVA 20.03.2009
		 (ssdel tmp SS-COLOR)     ;_ add VVA 20.03.2009
		 (ssdel tmp SS-LTYPE)     ;_ add VVA 20.03.2009
		 (ssdel tmp SS-LWEIGHT)   ;_ add VVA 20.03.2009
		 (ENTDEL (cadr itm))      ;_ add VVA 20.03.2009
		 )                        ;_ add VVA 20.03.2009
	 )                                ;_ add VVA 20.03.2009
       )                                  ;_ add VVA 20.03.2009
      (If (> (SsLength SS-LAYER) 0)
         (Progn
            (bump "Fixing layers")
            (Command
               "_.chprop" SS-LAYER "" "_LA" BLAYER ""
            )
         )
      )
      (If (> (SsLength SS-COLOR) 0)
         (Progn
            (bump "Fixing colors")
            (Command
               "_.chprop" SS-COLOR "" "_C" BCOLOR ""
            )
         )
      )
      (If (> (SsLength SS-LTYPE) 0)
         (Progn
            (bump "Fixing linetypes")
            (Command
               "_.chprop" SS-LTYPE "" "_LT" BLTYPE ""
            )
         )
      )
    (If (> (SsLength  SS-LWEIGHT) 0)                                 ;_Add VVA BURST LWEIGHT SECTION
        (Progn (bump "Fixing lineweightes")                            ;_Add VVA BURST LWEIGHT SECTION
	   (Command "_.chprop"  SS-LWEIGHT "" "_LW" (if (numberp BLWEIGHT)(* BLWEIGHT 0.01) BLWEIGHT)  "")   ;_Add VVA BURST LWEIGHT SECTION
        )                                                              ;_Add VVA BURST LWEIGHT SECTION
     )                                                                ;_Add VVA BURST LWEIGHT SECTION
  (setq SS-LAYER nil SS-COLOR nil SS-LTYPE nil SS-LWEIGHT NIL)
     )

   ;-----------------------------------------------------
   ; Item from association list
   ;-----------------------------------------------------
   (Defun ITEM (N E) (CDR (Assoc N E)))
   ;-----------------------------------------------------
   ; Error Handler
   ;-----------------------------------------------------
 
  (acet-error-init
    (list
      (list "cmdecho" 0
            "highlight" 1
      )
      T     ;flag. True means use undo for error clean up.
    );list
  );acet-error-init
 
 
   ;-----------------------------------------------------
   ; BIT SET
   ;-----------------------------------------------------
 
   (Defun BITSET (A B) (= (Boole 1 A B) B))
 
   ;-----------------------------------------------------
   ; BUMP
   ;-----------------------------------------------------
 
   (Setq bcnt 0)
   (Defun bump (prmpt)
      (Princ
         (Nth bcnt '("\r-" "\r\\" "\r|" "\r/"))
      )
      (Setq bcnt (Rem (1+ bcnt) 4))
   )
 
   ;-----------------------------------------------------
   ; Convert Attribute Entity to Text Entity
   ;-----------------------------------------------------
 
   (Defun ATT-TEXT (AENT / TENT ILIST INUM)
      (Setq TENT '((0 . "TEXT")))
      (ForEach INUM '(8
            6
            38
            39
            62
            67
            210
	    370	      
            10
            40
            1
            50
            41
            51
            7
            71
            72
            73
            11
            74
         )
         (If (Setq ILIST (Assoc INUM AENT))
            (Setq TENT (Cons ILIST TENT))
         )
      )
      (Setq
         tent (Subst
                 (Cons 73 (item 74 aent))
                 (Assoc 74 tent)
                 tent
              )
      )
      (EntMake (Reverse TENT))
   )
 
   ;-----------------------------------------------------
   ; Find True last entity
   ;-----------------------------------------------------
 
   (Defun LASTENT (/ E0 EN)
      (Setq E0 (EntLast))
      (While (Setq EN (EntNext E0))
         (Setq E0 EN)
      )
      E0
   )
 
   ;-----------------------------------------------------
   ; See if a block is explodable. Return T if it is, 
   ; otherwise return nil
   ;-----------------------------------------------------
 
   (Defun EXPLODABLE (BNAME / B expld)
      (setq BLOCKS (vla-get-blocks 
                     (vla-get-ActiveDocument (vlax-get-acad-object)))
       )
      
      (vlax-for B BLOCKS (if (and (= :vlax-false (vla-get-islayout B))
                                  (= (strcase (vla-get-name B)) (strcase BNAME)))
                      (setq expld (= :vlax-true (vla-get-explodable B)))
           )
       )
       expld
    )








(defun check-txt-overlay (
			  /
			  ss
			  i
			  box
			  over
			  tmp
			  )
  (acet-error-init
    (list (list	"cmdecho"		0
		"highlight"		(getvar "highlight")
		"regenmode"		0
		"attreq"		0
		"expert"		0
		"limcheck"		0
		"osmode"		0
		"pickstyle"		0
		) ;_ list
	  T
	  ) ;list
    ) ;acet-error-init
  (vl-cmdf "_erase" (ssget "_X" '((0 . "TEXT") (1 . ""))))

;;;  (if (ssget "_X" '((0 . "MTEXT")))
;;;    (progn
;;;      (alert "В чертеже присутствуют мультитекст\nкоманда отменена")
;;;      (acet-error-restore)
;;;      (exit)
;;;      );progn
;;;    );if



  (setq	i    0
	over (ssadd)
	ss   (ssget "_X" '((0 . "TEXT")))
	) ;_ setq
  (repeat (sslength ss)
 ;(setq box (txtbox (ssname ss i)))
    (setq box (boundlim (ssname ss i)))
    ;(princ "\n")
    ;(princ box)
;;;    (setq nl (append nl (list (cons (sslength (ssget "_C" (car box) (cadr box)))
;;;				    (ssname ss i)))))
    (vl-cmdf "_ZOOM" "_O" (ssname ss i) "")
    (if	(and
	  (setq tmp (ssget "_C" (car box) (cadr box)))
	  (> (sslength tmp)
	     1
	     ) ;_ >
	  )
      (progn
	(setq over (entget (ssname ss i)))
	(setq over (subst '(8 . "errors") (assoc 8 over) over))
	(setq over (subst '(62 . 256) (assoc 62 over) over))
	(entmod over)
	(entupd (cdr (assoc -1 over)))
	)
      ) ;if
    (setq i (1+ i))
    ) ;_ repeat
  (princ)
  ) ;defun


 ;(command "_rectang" (car (setq box (txtbox (car (entsel))))) (cadr box))






(defun boundlim	(e / pt1 pt2 minp maxp)
  (vla-GetBoundingBox (vlax-ename->vla-object e) 'minp 'maxp)
  (setq pt1 (vlax-safearray->list minp))
  (setq pt2 (vlax-safearray->list maxp))
  (list pt1 pt2)
  ) ;defun






;;;;;;(block-explode o)
;;;(block-explode (vlax-ename->vla-object (car (entsel))))
;;;(setq blo (vlax-ename->vla-object (car (entsel))))
;;;(setq doc (vla-get-activedocument (vlax-get-acad-object)))
;;;(setq ms (vla-get-ModelSpace doc))
;;;(vla-explode (vlax-ename->vla-object (car (entsel))))

(defun block-explode (blo
                      /
                      proplist
                      curpl
                      atts
                      txto
;;;                      doc
;;;                      ms
                      obs
                      )
;;;  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
;;;    (setq ms (vla-get-ModelSpace doc))
;;;  (vla-startundomark doc)
;;;  
;;;  (acet-error-init
;;;    (list (list "cmdecho" 0
;;;		"highlight" (getvar "highlight")
;;;		"limcheck" 0
;;;		"osmode" 0
;;;		);list
;;;	  T
;;;	  );list
;;;    );acet-error-init


    
    (setq proplist (list
                   "Alignment"
                   "Backward"
                   "Height"
                   "Layer"
                   "Linetype"
                   "LinetypeScale"
                   "ObliqueAngle"
                   "Rotation"
                   "ScaleFactor"
                   "StyleName"
                   "TextAlignmentPoint"
                   "InsertionPoint"                   
                   "TextString"
                   "Thickness"
                   "UpsideDown"
                   )
      )


;(setq blo (vlax-ename->vla-object (car (entsel))))
  
  (if (= :vlax-true (vla-get-hasattributes blo))
    (setq atts (vlax-safearray->list  (vlax-variant-value (vla-getattributes blo))))
    (setq atts '())
    )
  

    (foreach att atts
        ;(if (= :vlax-false (vlax-get-property att "Invisible"))
	(if (= :vlax-true (vlax-get-property att "Visible"))  
        ;;;///////////////////////////////////////////////////////
            (if (= :vlax-false (vlax-get-property att "MTextAttribute"))
                (progn
                    (setq txto (vla-AddText ms "" (vlax-3D-Point '(0 0 0)) 2.5))
                    (foreach p proplist
                        (if (vlax-property-available-p txto p T)
                            (progn
                                (if (and
                                        (= p "TextAlignmentPoint")
                                        (= 0 (vlax-get-property txto "Alignment"))
                                        )
                                    (princ)
                                    (vlax-put-property txto p (vlax-get-property att p))
                                    )
                                )
                            )
                        )
                    )
                (progn
                    (setq txto (vla-AddMText ms (vlax-3D-Point '(0 0 0)) 0 ""))
                    (foreach p (append proplist '("MTextAttribute" "MTextAttributeContent" "MTextBoundaryWidth" "MTextDrawingDirection"))
                        (if (vlax-property-available-p txto p T)
                            (progn
                                (vlax-put-property txto p (vlax-get-property att p))
                                )
                            )
                        )                    
                    )
                )
        ;;;///////////////////////////////////////////////////////
        )
        );foreach

    (setq obs (vlax-safearray->list (vlax-variant-value (vla-explode blo))))
    
    
    (foreach o obs
        (if (= (vlax-get-property o "Lineweight") -2)
            (vlax-put-property o "Lineweight" (vlax-get-property blo "Lineweight"))
            )
        (if (= "AcDbAttributeDefinition" (vlax-get-property o "ObjectName"))
            (vla-delete o)
            )
        )
    (vla-delete blo)
    
;;;    (acet-error-restore)
;;;    (vla-endundomark doc)
    );defun


;;;(setq wipes (vl-remove-if-not '(lambda (x) (= "AcDbWipeout" (vla-get-ObjectName x))) obs))
;;;(vla-GetBoundingBox (car wipes) 'minp 'maxp)
;;;  (setq pt1 (vlax-safearray->list minp))
;;;  (setq pt2 (vlax-safearray->list maxp))
;;;
;;;(sssetfirst nil (ssget "_C" pt1 pt2))
;;;







;;;(setq obs (vla-explode (vlax-ename->vla-object (car (entsel)))))
;;;(vlax-dump-object
;;;    (nth 6
;;;         (vlax-safearray->list
;;;             (vlax-variant-value
;;;                 obs
;;;                 ))) T)
;;;
;;;
;;;   Invisible = 0
;;;
;;;   MTextAttribute = 0
;;;   MTextAttributeContent = ""
;;;   MTextBoundaryWidth = 0.0
;;;   MTextDrawingDirection = 5


;;;   Alignment = 14
;;;   Backward = 0
;;;   Height = 2.5
;;;   InsertionPoint = (1992.76 149.641 0.0)
;;;   Layer = "0"   
;;;   Linetype = "ByLayer"
;;;   LinetypeScale = 1.0
;;;   ObliqueAngle = 0.0
;;;   Rotation = 1.5708
;;;   ScaleFactor = 1.0
;;;   StyleName = "GOST 2.304"
;;;   TextAlignmentPoint = (1993.51 170.266 0.0)
;;;   TextString = "VC10T39BN-1"
;;;   Thickness = 0.0
;;;   UpsideDown = 0

;|«Visual LISP© Format Options»
(80 4 50 2 nil "end of " 80 50 2 0 2 nil nil nil T)
;*** НЕ добавляйте текст под комментариями! ***|;


;;;;;;****************************************************************************
;;;;(defun do (obj)(vlax-dump-object obj T))
;;;(defun pline-explode (e
;;;                      /
;;;                      obj
;;;                      lw
;;;                      clist
;;;                      n
;;;                      i
;;;                      no
;;;                      )
;;;    ;(setq e (car (entsel)))
;;;    (setq obj (vlax-ename->vla-object e)
;;;          flag T
;;;          width '())
;;;    
;;;
;;;    (setq lw (vlax-get-property
;;;                 ;(vlax-ename->vla-object (car (entsel)))
;;;                 obj
;;;                 "Lineweight"
;;;                 )
;;;          )
;;;    (if (= lw -1)
;;;        (progn
;;;            (setq clist (vlax-safearray->list
;;;                            (vlax-variant-value
;;;                                (vlax-get-property
;;;                                    obj
;;;                                    "Coordinates"))))
;;;            (setq n (/ (length clist) 2))
;;;            (setq i 0)
;;;            (repeat  n
;;;                (vla-GetWidth obj i 'sw 'ew)
;;;                (if (= sw ew)
;;;                    (setq width (append width (list sw)))
;;;                    (setq flag nil)
;;;                    )
;;;                (setq i (1+ i))
;;;                )
;;;            (if flag
;;;                (progn
;;;                    (if (= :vlax-true (vlax-get-property obj "Closed"))
;;;                        (setq clist (append clist (list (car clist) (cadr clist)))
;;;                              n (1+ n))
;;;                        )
;;;                    (setq i 0)
;;;                    (repeat  (1- n)
;;;                        (setq no
;;;                        (vla-addLine ms
;;;                                     (vlax-3d-point (nth (* 2 i) clist) (nth (1+ (* 2 i)) clist))
;;;                                     (vlax-3d-point (nth (* 2 (1+ i)) clist) (nth (1+ (* 2 (1+ i))) clist))
;;;                                     )
;;;                              )
;;;                        (vlax-put-property no "Lineweight" (* 100 (nth i width)))
;;;                        (vlax-put-property no "Linetype" (vlax-get-property obj "Linetype"))
;;;                        
;;;                        (setq i (1+ i))
;;;                        )
;;;                    (vla-delete obj)
;;;                )
;;;                )
;;;            )
;;;        (progn
;;;            (vla-explode obj)
;;;            (vla-delete obj)
;;;            )
;;;        )
;;;    
;;;    );defun
;;;    


;;;
;;;(setq e (car (entsel)))
;;;(defun pline-explode (e
;;;		      /
;;;		      obj
;;;		      w
;;;		      ss
;;;		      )
;;;  (setq obj (vlax-ename->vla-object e))
;;;  (if (setq w (vlax-get-Property  obj "ConstantWidth"))
;;;    (setq ss (vla-explode obj))
;;;    )
;;;  
;;;  
;;;  
;;;  )
;;;
;;;
;;;
;;;
;;;(vlax-property-available-p obj "ConstantWidth")
;;;
;;;(vlax-invoke-method obj "vla-get-Property" obj "ConstantWidth")
;;;
;;;(vlax-get-Property obj "ConstantWidth")
;;;
;;;
;;;(vla-GetWidth obj 'v 'm)
;;;
;;;(vlax-invoke-method obj "GetWidth")
;;;
;;;
;;;(setq coordlist
;;;(vlax-safearray->list
;;;  (vlax-variant-value
;;;    (vla-get-Coordinates obj)
;;;    ))
;;;      )
;;;(setq i 0
;;;      a T)
;;;
;;;(while a
;;;  (vla-getWidth obj i 'a 'b)
;;;  (setq w (append w (list a b)))
;;;  (setq i (1+ i))
;;;  )
;;;
;;;
;;;
;;;(vla-getWidth obj 1 'a 'b )
;;;  
