
(defun kkadd (/ line od nplay ip bobj tbl)
  ;-----------------------------------------------------------------------------;
  (defun line (l pt1 pt2 / lo p1 p2)						;
    (setq lo (vla-addLine #modspace (vlax-3d-point pt1) (vlax-3d-point pt2)))	;
    (vla-put-layer lo l) lo							;
    )										;
  ;-----------------------------------------------------------------------------;

  (while (null od)
    (setq od (entsel "\nУкажите форматку общих данных"))
  )
  (setq od (vlax-ename->vla-object (car od)))

  (setq nplay (vla-add (vla-get-layers #actdoc) "non printed"))
  (vla-put-plottable nplay 0)
  (vlax-put-Property nplay "Truecolor" #color)

  (setq ip (getpoint "\nУкажите точку вставки"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LINES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (line	"non printed"
	(MAPCAR '+ IP '(210.0 0.0 0.0))
	(MAPCAR '+ IP '(0.0 0.0 0.0))
  )
  (line	"non printed"
	(MAPCAR '+ IP '(0.0 0.0 0.0))
	(MAPCAR '+ IP '(0.0 -297.0 0.0))
  )
  (line	"non printed"
	(MAPCAR '+ IP '(210.0 -297.0 0.0))
	(MAPCAR '+ IP '(210.0 0.0 0.0))
  )
  (line	"non printed"
	(MAPCAR '+ IP '(0.0 -297.0 0.0))
	(MAPCAR '+ IP '(210.0 -297.0 0.0))
  )
  (setq	bobj (vla-InsertBlock
	       #modspace
	       (vlax-3d-point (MAPCAR '+ IP '(20.0 -17.0 0.0)))
	       "d:\\LISP WORKING\\Контрольная карта\\kk_tbl1.dwg"
	       1
	       1
	       1
	       0
	     )
  )
  (setq tbl (vla-explode bobj))
  (vla-delete bobj)
  (vlax-release-object bobj)
  (setq bobj nil)
  (setq tbl (car (vlax-safearray->list (vlax-variant-value tbl))))
  (vla-setText
    tbl
    0
    1
    (strcat
      (vla-get-TextString (getbatt od "ОБЪЕКТ1"))
      (vla-get-TextString (getbatt od "ОБЪЕКТ2"))
      (vla-get-TextString (getbatt od "ОБЪЕКТ3"))
    )
  )
  (vla-setText tbl 1 1 "б/г")
  (vla-setText
    tbl
    2
    1
					;(vl-string-right-trim "КИПиИА ."
    (strcat
      (vla-get-TextString (getbatt od "УЗЕЛ1"))
      (vla-get-TextString (getbatt od "УЗЕЛ2"))
      (vla-get-TextString (getbatt od "УЗЕЛ3"))
    )
					;)
  )
  (vla-setText
    tbl
    3
    1
    (vla-get-TextString (getbatt od "НОМЕР_УЗЛА"))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq	txt (vla-addText
	      #modspace
	      "Договор   №"
	      (vlax-3d-point '(0 0 0))
	      3
	    )
  )
  (vla-put-Alignment txt 8)
  (vla-put-TextAlignmentPoint
    txt
    (vlax-3d-point (MAPCAR '+ IP '(165.0 -5.0 0.0)))
  )

  (setq	txt (vla-addText
	      #modspace
	      "###-###-##"
	      (vlax-3d-point '(0 0 0))
	      3
	    )
  )
  (vla-put-Alignment txt 6)
  (vla-put-TextAlignmentPoint
    txt
    (vlax-3d-point (MAPCAR '+ IP '(166.0 -5.0 0.0)))
  )





  (setq	txt (vla-addText
	      #modspace
	      "Контрольная  карточка  №"
	      (vlax-3d-point '(0 0 0))
	      3
	    )
  )
  (vla-put-Alignment txt 14)
  (vla-put-TextAlignmentPoint
    txt
    (vlax-3d-point (MAPCAR '+ IP '(122.0 -15.0 0.0)))
  )

  (setq	txt (vla-addText
	      #modspace
	      "####/19"
	      (vlax-3d-point '(0 0 0))
	      3
	    )
  )
  (vla-put-Alignment txt 12)
  (vla-put-TextAlignmentPoint
    txt
    (vlax-3d-point (MAPCAR '+ IP '(124.0 -15.0 0.0)))
  )
  (vla-update tbl)



  (setq ip (MAPCAR '+ IP (list 0.0 (- -17 (vla-get-height tbl)) 0.0)))


  (setq	bobj (vla-InsertBlock
	       #modspace
	       (vlax-3d-point (MAPCAR '+ IP '(20.0 0.0 0.0)))
	       "d:\\LISP WORKING\\Контрольная карта\\kk_tbl2.dwg"
	       1
	       1
	       1
	       0
	     )
  )
  (vla-explode bobj)
  (vla-delete bobj)
  (vlax-release-object bobj)


  (setq	txt (vla-addText
	      #modspace
	      "%<\\AcVar Date \\f \"M.d.yyyy\">%"
	      (vlax-3d-point '(0 0 0))
	      3
	    )
  )
  (vla-put-Alignment txt 12)
  (vla-put-TextAlignmentPoint
    txt
    (vlax-3d-point (MAPCAR '+ IP '(32.0 -6.0 0.0)))
  )

)





;;;;;********************************************************************************************
;;;;;********************************************************************************************
;;;;;********************************************************************************************
;;;;;********************************************************************************************
;;;;;********************************************************************************************
;;;;;********************************************************************************************



;(mordadd)
(defun mordadd (/ line od nplay ip bobj tbl)
  ;-----------------------------------------------------------------------------;
  (defun line (l pt1 pt2 / lo p1 p2)						;
    (setq lo (vla-addLine #modspace (vlax-3d-point pt1) (vlax-3d-point pt2)))	;
    (vla-put-layer lo l) lo							;
    )										;
  ;-----------------------------------------------------------------------------;
  (while (null od)
    (setq od (entsel "\nУкажите форматку общих данных"))
  )
  (setq od (vlax-ename->vla-object (car od)))

  (setq nplay (vla-add (vla-get-layers #actdoc) "non printed"))
  (vla-put-plottable nplay 0)
  (vlax-put-Property nplay "Truecolor" #color)

  (setq ip (getpoint "\nУкажите точку вставки"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LINES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (line	"non printed"
	(MAPCAR '+ IP '(210.0 0.0 0.0))
	(MAPCAR '+ IP '(0.0 0.0 0.0))
  )
  (line	"non printed"
	(MAPCAR '+ IP '(0.0 0.0 0.0))
	(MAPCAR '+ IP '(0.0 -297.0 0.0))
  )
  (line	"non printed"
	(MAPCAR '+ IP '(210.0 -297.0 0.0))
	(MAPCAR '+ IP '(210.0 0.0 0.0))
  )
  (line	"non printed"
	(MAPCAR '+ IP '(0.0 -297.0 0.0))
	(MAPCAR '+ IP '(210.0 -297.0 0.0))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
  (setq	bobj (vla-InsertBlock
	       #modspace
	       (vlax-3d-point (MAPCAR '+ IP '(10.0 -10.0 0.0)))
	       "d:\\LISP WORKING\\Контрольная карта\\kk_tblmord.dwg"
	       1 1 1 0 )
  )
  (setq tbl (vla-explode bobj))
  (vla-delete bobj)
  (vlax-release-object bobj)
  (setq bobj nil)
  (setq tbl (car (vlax-safearray->list (vlax-variant-value tbl))))
  
  (vla-setText
    tbl
    3    0
    (strcat
      (vla-get-TextString (getbatt od "ОБЪЕКТ1")) "\\P"
      (vla-get-TextString (getbatt od "ОБЪЕКТ2")) "\\P"
      (vla-get-TextString (getbatt od "ОБЪЕКТ3"))
    )
  )
  (vla-setText
    tbl
    4    0
    ;(vl-string-right-trim "КИПиА. "
    (strcat
      (vla-get-TextString (getbatt od "УЗЕЛ1")) " "
      (vla-get-TextString (getbatt od "УЗЕЛ2")) " "
      (vla-get-TextString (getbatt od "УЗЕЛ3")) " "
    )
					;)
  )
  (vla-setText
    tbl
    6    0
    (vla-get-TextString (getbatt od "НОМЕР_УЗЛА"))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (vla-update tbl)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;;;;;;;;;;;;;;;;;;;;;;;;;  РАМКА  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
  (setq bobj (line	"0"
	(MAPCAR '+ IP (list 10.0 -10.0 0.0))
	(MAPCAR '+ IP (list 110.0 -10.0 0.0))
	       )) (vla-put-Lineweight bobj 50)
    (setq bobj (line	"0"
	(MAPCAR '+ IP (list 10.0 (- -10.0 (vla-get-height tbl)) 0.0))
	(MAPCAR '+ IP (list 110.0 (- -10.0 (vla-get-height tbl)) 0.0))
	       )) (vla-put-Lineweight bobj 50)
  (setq bobj (line	"0"
	(MAPCAR '+ IP (list 10.0 -10.0 0.0))
	(MAPCAR '+ IP (list 10.0 (- -10.0 (vla-get-height tbl)) 0.0))
	       )) (vla-put-Lineweight bobj 50)
  (setq bobj (line	"0"
	(MAPCAR '+ IP (list 110.0 -10.0 0.0))
	(MAPCAR '+ IP (list 110.0 (- -10.0 (vla-get-height tbl)) 0.0))
	       )) (vla-put-Lineweight bobj 50)
  

    (setq bobj (line	"0"
	(MAPCAR '+ IP (list 7.0 -7.0 0.0))
	(MAPCAR '+ IP (list 113.0 -7.0 0.0))
	       )) (vla-put-Lineweight bobj 20)
    (setq bobj (line	"0"
	(MAPCAR '+ IP (list 7.0 (- -13.0 (vla-get-height tbl)) 0.0))
	(MAPCAR '+ IP (list 113.0 (- -13.0 (vla-get-height tbl)) 0.0))
	       )) (vla-put-Lineweight bobj 20)
  (setq bobj (line	"0"
	(MAPCAR '+ IP (list 7.0 -7.0 0.0))
	(MAPCAR '+ IP (list 7.0 (- -13.0 (vla-get-height tbl)) 0.0))
	       )) (vla-put-Lineweight bobj 20)
  (setq bobj (line	"0"
	(MAPCAR '+ IP (list 113.0 -7.0 0.0))
	(MAPCAR '+ IP (list 113.0 (- -13.0 (vla-get-height tbl)) 0.0))
	       )) (vla-put-Lineweight bobj 20)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
);defun

