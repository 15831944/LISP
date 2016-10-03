;;VovKa
;;http://www.theswamp.org/index.php?topic=33041.msg384927#msg384927
(defun CreateLayer (Name FrzLock Color LType Plot? LWeight Desc)
  (entmakex
    (list (cons 0 "LAYER")
	  (cons 100 "AcDbSymbolTableRecord")
	  (cons 100 "AcDbLayerTableRecord")
	  (cons 2 Name)
	  (cons 70 FrzLock)
	  (cons 62 Color)
	  (cons 6 LType)
	  (cons 290 Plot?)
	  (cons 370 LWeight)
	  (list -3 (list "AcAecLayerStandard" (cons 1000 "") (cons 1000 Desc)))
    )
  )
)


(defun C:MLDT (/ *error* accol  acsp adoc end first head lr mid mlead ort p1 p2 ptarr qtxt str_text tail tdown tup txtstyle)
;;fixo () 2012 * all rights released
(vl-load-com)
  
  (defun *error*  (msg) 

    (vla-endundomark 
      (vla-get-activedocument 
   (vlax-get-acad-object) 
   ) 
      )     
    (if (and msg
      (not 
   (member  msg  '("console break" "Function cancelled" "quit / exit abort") 
     ) 
   )
	     )
       (princ (strcat "\nError: " msg)) 
       )
    
(if qtxt(setvar 'qtextmode qtxt))
(if ort (setvar 'orthomode ort))
    )
(or adoc
    (setq adoc
	   (vla-get-activedocument
	     (vlax-get-acad-object)
	     )
	  )
    )
(if (and
      (= (getvar "tilemode") 0)
      (= (getvar "cvport") 1)
      )
  (setq acsp (vla-get-paperspace adoc))
  (setq acsp (vla-get-modelspace adoc))
  )
(vla-startundomark adoc)
  
  (setq qtxt (getvar 'qtextmode))
  (setvar 'qtextmode 0)
  (setq ort (getvar 'orthomode))
(setvar 'orthomode 0)
  
(if (not (tblsearch "layer" "Light_выноски_размеры_текст"))
  (progn
    (CreateLayer
      "Light_выноски_размеры_текст"
      0
      54
      "continuous"
      0
      -3
      "Слой для выносок размеров")
    (setq lr (vla-item (vla-get-layers adoc)
		       "Light_выноски_размеры_текст"))
    (setq accol (vla-get-truecolor lr))
    (vla-setrgb accol 255 255 255)
    (vla-put-truecolor lr accol)
    (vl-catch-all-apply 'vlax-release-object (list accol))))

  (setq txtstyle (vla-item (vla-get-textstyles adoc) "Standard"))
  
  (if (not
	(equal (strcase (vla-get-fontfile txtstyle)) "TIMES.TTF"))
    (vl-catch-all-apply
      '(lambda ()
	 (progn
	   (setq fontfile (findfile (strcat (getenv "WINDIR") "\\fonts\\times.ttf")))
	   (vla-put-fontfile txtstyle fontfile)
	   )
	 )
      )
    )
  
(while 
(setq p1 (getpoint "\nТочка вставки лидера >> \n"))
(setq p2 (getpoint p1 "\nЕочка вставки текста >> \n"))


(setq head  "\\A1; "
      mid   "{\\H0.7x;\\S\\"
      tail  "/"
      end   ";}"
      first (getstring t "\nЗаголовок: ")
      tup   (getstring t "\nЧто верхнем индексе? : ")
      tdown (getstring t "\nЧто в нижнем индексе? : ")
      )


(setq str_text (strcat head first " " mid tup tail tdown end))

(setq ptarr (vlax-make-variant
	      (vlax-safearray-fill
		(safearray vlax-vbdouble '(0 . 5))
		(apply 'append (list p1 p2))))
      )

(setq mlead (vla-addmleader acsp ptarr 0))
(vla-put-leadertype mlead 1)
(vla-put-arrowheadblock mlead "_Oblique")
(vla-put-arrowheadsize mlead 1)
(vla-put-contenttype mlead acMTextContent)
(vla-put-textstylename mlead "Standard")  
(vla-put-TextLeftAttachmentType mlead acAttachmentMiddle)
(vla-put-TextRightAttachmentType mlead acAttachmentMiddle)
(vla-put-TextFrameDisplay mlead :vlax-false)	  ;<-- to display text frame :vlax-true 
(vla-put-textheight mlead 2.5)			  ;<--change  text height here
 ( vla-put-textwidth mlead 0.0)
(vla-put-landinggap mlead 0.07)
(vla-put-textlinespacingdistance mlead 4.17)
  
 (vla-put-textdirection mlead acLeftToRight) 
(vla-put-textstring mlead str_text)

(vla-put-doglegged mlead :vlax-true)
(vla-put-dogleglength mlead 1.5)
;;borrowed from Lee Mac:
(vla-setdoglegdirection
  mlead
  0
  (vlax-3D-point
    (list
      (if (<= (car p1) (car p2))
	1
	-1)
      0
      0
      )
    )
  )
(if (> (car p2) (car p1))

  (vla-put-TextJustify mlead acAttachmentPointMiddleLeft)

  (vla-put-TextJustify mlead acAttachmentPointMiddleRight)
  
  )

(vla-put-leaderlineweight mlead -3)
(vla-put-layer mlead "Light_выноски_размеры_текст")
(setq accol (vla-get-truecolor mlead))
(vla-put-colorindex accol 256)
(vla-put-leaderlinecolor mlead accol)
(vl-catch-all-apply 'vlax-release-object (list accol))
(vla-setleaderlinevertices mlead 0 ptarr )
(vl-catch-all-apply 'vlax-invoke-method (list mlead 'evaluate))
(vla-update mlead)
);_end while
 (*error* nil)
(princ)
)
(princ "\n\t===\tСтарт команды: MLDT\t===\n")
(prin1)
(or (vl-load-com)(princ))

