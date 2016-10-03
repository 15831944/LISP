
;;;;   СВТУ   
;;;    14_02_12


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load (strcat #lisppath "DataBase\\dblib.lsp"))
(load (strcat #lisppath "excel\\xlsformatlib.LSP"))
(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\spclib.lsp"))
(load (strcat #lisppath "DRAWING\\specification\\gostlib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))

(load (strcat #lisppath "DRAWING\\specification\\_4 Расход\\СВТУ\\gen-zakaz-SVTU.LSP"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(setq xls-head (car (excel>lst)) db:head xls-head)
;(setq xls-data (excel>lst))
;(setq xls-data (DB|FORMATDATA xls-data) db:data xls-data)


(setq xls-data (db|formatdata (excel>lst)))
       


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq datazipped (cdr (db|mapzip (cons "table" xls-data) "cpu")))



;(setq datazipped (ziplist (mapcar '(lambda (xlsline) (list (xlsgpar "cpu" xlsline) xlsline)) xls-data)))



;(setq paragdata (nth 3 datazipped))
(defun gen-paragraf  (paragdata)
  (gen-zakaz-SVTU paragdata)
  );defun









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;      ДЛЯ    ДАВЛЕНИЯ    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;   параметры вывода графы спецификации   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(setq
;;;  #spclist9stringsparamlist
;;;   '(
;;;     (("object" "MTEXT")("dpt" '( 0.8 -3 0))("attch" 1)("width" 18.4))  ;для давления
;;;     ;(("object" "TEXT") ("dpt" '( 10 -4 0))) ;для температуры
;;;     (("object" "MTEXT")("dpt" '( 22 -3 0))("attch" 1)("width" 126))
;;;     (("object" "MTEXT")("dpt" '( 152 -3 0))("attch" 1)("width" 56))
;;;     (("object" "TEXT")("dpt" '( 227.5 -4 0)))
;;;     (("object" "MTEXT")("dpt" '( 247 -3 0))("attch" 2)("width" 41))
;;;     (("object" "TEXT")("dpt" '( 300 -4 0)))
;;;     (("object" "TEXT")("dpt" '( 320 -4 0)))
;;;     (("object" "TEXT")("dpt" '( 342.5 -4 0)))
;;;     (("object" "MTEXT")("dpt" '( 357 -3 0))("attch" 1)("width" 36))
;;;     )
;;;  );spctblparamlist
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;(add-grapha (getpoint) (nth 3 (gen-paragraf pardata)))
;(add-grapha (getpoint) (nth 4 parstr))
;(setq list9strings (nth 3 (gen-paragraf pardata)))
;(setq pt (getpoint))
(defun add-grapha (pt list9strings / txtobj maxheight cpt)
  (setq cpt pt)
  (setq maxheight '())
  ;(setq p (nth 4 #spclist9stringsparamlist))
  (mapcar '(lambda (x p)
	     ;(setq x (cadr list9strings))
	     ;(setq p (cadr #spclist9stringsparamlist))
   (if x
     (cond
       ((= "MTEXT" (cadr (assoc "object" p)))
	(progn
	  (setq txtobj (vla-AddMtext #modspace (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))) (cadr (assoc "width" p)) x))
	  (vla-put-AttachmentPoint txtobj (cadr (assoc "attch" p)))
	  (vla-put-LineSpacingStyle txtobj acLineSpacingStyleExactly)
	  (vla-put-Height txtobj 2.5)
	  (vla-put-LineSpacingDistance txtobj 8)
	  (setq maxheight (append maxheight (list (mtxt:getnumberoflines txtobj))))
	  );progn
	)
       ((= "TEXT" (cadr (assoc "object" p)))
	(progn
	  (setq txtobj (vla-Addtext #modspace x (vlax-3d-point '(0 0 0)) 2.5))
	  (vla-put-Alignment txtobj 10)
	  (vla-put-TextAlignmentPoint txtobj (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))))
	  );progn
	);1
       )
     )
    )
	  list9strings			;x
	  ;#spclist9stringsparamlist	;p
	  #spc|addgraha:insertparamslist 
	  )
  ; и выдает точку вставки следующей графы
  (mapcar '- cpt (list 0 (* 8 (eval (append '(max) maxheight))) 0))
  ;(mapcar '- cpt (list 0 (* 8 (1+ (eval (append '(max) maxheight)))) 0))
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq pt (getpoint))



;(addparagraph (getpoint) (gen-paragraf (nth 8 datazipped2)))
;;;(defun addparagraph (pt parstr / cpt)
;;;  (setq cpt pt)
;;;  (mapcar '(lambda (grafa / nl)
;;;	     (setq cpt (add-grapha cpt grafa))
;;;	     )
;;;	  parstr)
;;;  ;(mapcar '- cpt (list 0 8 0))   ;;; - перенес в  addgrafa
;;;  cpt
;;;  )



(defun addparagraph2 (pt parstr / cpt)
  (setq cpt pt)
  (mapcar
    '(lambda (grafa / nl)
       (setq cpt (add-grapha cpt grafa))
       )
    parstr
    )
  cpt
  );defun




;#list_cpt
;;;; с отступом для след. лист
(defun addparagraph3 (pt parstr / cpt)
  (setq cpt pt)
  (mapcar
    '(lambda (grafa / nl)
	     (setq cpt (add-grapha cpt grafa))
	     ;вставка промежутка для разделения на листы
	     (if (>= (- (cadr #list_cpt) (cadr cpt)) 192 )
	       (progn
		 (setq cpt (mapcar '+ cpt '(0 -120 0))
		       #list_cpt cpt)
		 (vla-addline #modspace
		   (vlax-3d-point cpt)
		   (vlax-3d-point (mapcar '+ cpt '(-100 0 0)))
		   )
		 )
	       )
	     )
    parstr
    )
  cpt
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;   ДОБАВЛЕНИЕ ГРАФИКИ  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





(defun addpodrazdel2 (listforgendat / cpt )
  (setq cpt (getpoint)
	#list_cpt cpt)
  ;(setq pardata (nth 0 listforgendat))
  (mapcar '(lambda (pardata /)
	     (setq cpt (addparagraph2 cpt (gen-paragraf pardata)))
	     )
	  listforgendat)
  );defun
;(addparagraph (getpoint) (gen-paragraf pardata))



(defun addpodrazdel3 (listforgendat / cpt )
  (setq cpt (getpoint)
	#list_cpt cpt)
  ;(setq pardata (nth 0 listforgendat))
  (mapcar '(lambda (pardata /)
	     (setq cpt (addparagraph3 cpt (gen-paragraf pardata)))
	     )
	  listforgendat)
  );defun
;(addparagraph (getpoint) (gen-paragraf pardata))





	
;;;  Указываем 
(addpodrazdel2 datazipped)







;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . ""))))
;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . " "))))