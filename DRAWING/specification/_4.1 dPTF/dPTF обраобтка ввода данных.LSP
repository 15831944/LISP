;;; ударные начинания
;;; 13_05_20


;;;; dPTL - APR
;;;    13_05_16

;;;; давление dPTF
;;;    13_11_05

;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\spclib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
;(load (strcat #lisppath "DATA-Tables\\ziplist.LSP"))
(load (strcat #lisppath "MATH\\m-kpa.lsp"))
(load (strcat #lisppath "DataBase\\dblib.LSP"))
(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))

;(load (strcat #lisppath "specification\\_2 Давление\\gen-zakaz-zavod-P.LSP"))
;(load (strcat #lisppath "specification\\_3 Уровень\\APLISENS\\gen-zakaz-APR-2000ALW.LSP"))
;(load (strcat #lisppath "MATH\\m-kpa.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\_4.1 dPTF\\APLISENS\\gen-zakaz-dPTF-APR-2000ALW.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\_4.1 dPTF\\МЕТРАН\\gen-zakaz-dPTF-metran3051.lsp"))


;(load (strcat #lisppath "specification\\_2 Давление\\gen-zakaz-zavod-P.LSP"))


;(setq xls-head (mapcar 'vla-get-textstring (ss->lsto (ssget))))
;(setq xls-head (mapcar 'vla-get-textstring (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "*TEXT"))) "x"))))
;(setq xls-data (mapcarx vla-get-textstring nil (ss->tbl (ssget))))
;(length xls-data)



;(defun spc|gen-data ()
  (setq xls-data (excel>tbl))
    
;для расходомеров
(setq xls-head (car xls-data)
      xls-data (cdr xls-data)
      data (xls|formatdata xls-data))


;; 2-й ввод
(setq xls-head (car (excel>lst)))
(setq data (DB|FORMATDATA (excel>lst)))


  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; заменяем диезы на nil
;(setq data (mapcar '(lambda (line) (mapcar '(lambda (x) (if (= "#" x) nil x)) line))xls-data))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(setq xlsline (nth 14 xls-data))


(setq datazipped
  (ziplist
    (mapcar
      ;(setq xlsline (car data))
     '(lambda (xlsline)
	(list
	  (xlsgpar "meas_name" xlsline)
	  xlsline
	  )
	)
     data)
    )
  )
;)





  
    








;(setq pardata (nth 0 datazipped))
;(gen-paragraf pardata)
(defun gen-paragraf (pardata / parname p prot)
  (setq
    parname
     (strcat
      "{\\W0.9;\\T0.95;"
      (xlsgpar "meas_name" (car (cdr pardata))) " "
      (setq p (xlsgpar "P" (car (cdr pardata)))) "\\~"
      (if (> 10 (atof* p)) "МПа, " "кПа, ")
      (xlsgpar "T" (car (cdr pardata))) "\\~%%dC, "
      (xlsgpar "nom_val" (car (cdr pardata))) "\\~"
      (xlsgpar "units" (car (cdr pardata))) "\n"
      "}" )

     )
  (append
    (list
      (list nil parname)
      (list "")
      )

    (cond
      (
       (apply '= (append '("APR-2000ALW") (mapcar '(lambda (x) (xlsgpar "прототип" (car (cdr pardata)))) (cdr pardata))))
       (gen-zakaz-dPTF-APR2000ALW (cdr pardata))
       )
      (
       (apply '= (append '("Метран 3051-SMV") (mapcar '(lambda (x) (xlsgpar "прототип" (car (cdr pardata)))) (cdr pardata))))
       (gen-zakaz-dPTF-metran3051 (cdr pardata))
       )
      )
    )
  );defun









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;      ДЛЯ    ДАВЛЕНИЯ    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;   параметры вывода графы спецификации   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
  #spclist9stringsparamlist
   '(
     (("object" "MTEXT")("dpt" '( 0.8 -3 0))("attch" 1)("width" 18.4))  ;для давления
     ;(("object" "TEXT") ("dpt" '( 10 -4 0))) ;для температуры
     (("object" "MTEXT")("dpt" '( 22 -3 0))("attch" 1)("width" 126))
     (("object" "MTEXT")("dpt" '( 152 -3 0))("attch" 1)("width" 56))
     (("object" "TEXT")("dpt" '( 227.5 -4 0)))
     (("object" "MTEXT")("dpt" '( 247 -3 0))("attch" 2)("width" 41))
     (("object" "TEXT")("dpt" '( 300 -4 0)))
     (("object" "TEXT")("dpt" '( 320 -4 0)))
     (("object" "TEXT")("dpt" '( 342.5 -4 0)))
     (("object" "MTEXT")("dpt" '( 357 -3 0))("attch" 1)("width" 36))
     )
  );spctblparamlist
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;(spcadd|grapha (getpoint) (nth 3 (gen-paragraf pardata)))
;(spcadd|grapha (getpoint) (nth 4 parstr))
;(setq list9strings (nth 3 (gen-paragraf pardata)))
;(setq pt (getpoint))
(defun spcadd|grapha (pt list9strings / txtobj maxheight cpt)
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
	  #spclist9stringsparamlist	;p
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
;;;	     (setq cpt (spcadd|grapha cpt grafa))
;;;	     )
;;;	  parstr)
;;;  ;(mapcar '- cpt (list 0 8 0))   ;;; - перенес в  addgrafa
;;;  cpt
;;;  )



;#list_cpt
(defun addparagraph3 (pt parstr / cpt)
  (setq cpt pt)
  (mapcar
    '(lambda (grafa / nl)
	     (setq cpt (spcadd|grapha cpt grafa))
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



;;;(defun addpodrazdel2 (listforgendat / cpt list_cpt)
;;;  (setq cpt (getpoint)
;;;	list_cpt cpt)
;;;
;;;  ;(setq pardata (nth 0 listforgendat))
;;;  (mapcar '(lambda (pardata /)
;;;	     (setq cpt (addparagraph cpt (gen-paragraf pardata)))
;;;	     ;вставка промежутка для разделения на листы
;;;	     (if (>= (- (cadr list_cpt) (cadr cpt)) 192)
;;;	       (progn
;;;		 (setq cpt (mapcar '+ cpt '(0 -120 0))
;;;		       list_cpt cpt)
;;;		 (vla-addline #modspace
;;;		   (vlax-3d-point cpt)
;;;		   (vlax-3d-point (mapcar '+ cpt '(-100 0 0)))
;;;		   )
;;;		 )
;;;	       )
;;;	     )
;;;	  listforgendat)
;;;  );defun





;(setq listforgendat datazipped)
(defun addpodrazdel3 (datazipped / cpt )
  (setq cpt (getpoint)
	#list_cpt cpt)
  ;(setq pardata (nth 4 listforgendat))
  (mapcar '(lambda (pardata /)
	     ;(setq pardata (car datazipped))
	     (setq cpt (addparagraph3 cpt (gen-paragraf pardata)))
	     )
	  datazipped)
  );defun
;(addparagraph (getpoint) (gen-paragraf pardata))






(addpodrazdel3 datazipped)


(alert "Заказ метрана не рассчитан на объединение нескольких позиций")

 





;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . ""))))
;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . " "))))