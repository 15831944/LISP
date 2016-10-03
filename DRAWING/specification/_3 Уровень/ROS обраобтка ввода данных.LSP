;;; объединяем приборы РОС по параметрам заказа
;;; как в температуре


(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))
(load (strcat #lisppath "specification\\spclib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
(load (strcat #lisppath "DATA-Tables\\ziplist.LSP"))

(load (strcat #lisppath "specification\\_3 Уровень\\РОС\\gen-zakaz-ROS.LSP"))







;;  1-й ввод
;(setq xls-data (excel>tbl)) (setq xls-head (car xls-data) data (spc|mm->m (xls|formatdata (cdr xls-data))))
; последующие

(setq xls-data (excel>tbl))
(setq data (xls|formatdata xls-data))


;(setq xls-data (excel>tbl))
;(setq xls-head (car xls-data)
;      xls-data (cdr xls-data))


(setq datazipped
  (ziplist
    (mapcar
     '(lambda (xlsline / tmp)
	(list
	  (strcat
	    (if (setq tmp (xlsgpar "прототип" xlsline)) tmp "")
	    (if (setq tmp (xlsgpar "Diam_tr" xlsline)) tmp "")
	    (if (setq tmp (xlsgpar "min_val" xlsline)) tmp "")
	    (if (setq tmp (xlsgpar "nom_val" xlsline)) tmp "")
	    (if (setq tmp (xlsgpar "max_val" xlsline)) tmp "")
	    (if (setq tmp (xlsgpar "scale" xlsline)) tmp "")
	    )
	  
	  xlsline
	  )
	)
     data)
    )
  )





;(gen-zakaz-ROS301  (cdr (car datazipped)))

;;;

;; принимает 1 запись из полного перечня datazipped
;; формирует список списков добавления для addparagraf
;; pardata - data line for paragraph
;(setq pardata (car datazipped))

(defun gen-paragraf (pardata / parname tail)
  (setq xlslinesLE (cdr pardata))

  (setq parname (VL-STRING-LEFT-TRIM ",\n" (apply 'strcat (mapcar '(lambda (xlsline) (strcat (xlsgpar "meas_name" xlsline) " " (xlsgpar "scale" xlsline) " " (xlsgpar "units" xlsline) ",\n")) xlslinesLE))))
      
  (list
    (list "" parname)
    (list "")
    (cond
      ((= "РОС-301" (xlsgpar "прототип" (car xlslinesLE)))
       (gen-zakaz-ROS301 xlslinesLE)
       )
      
      );cond
    (list "" (spc|gsfxl2 "place_cpu" xlslinesLE) "" "" "" "" "" "" "")
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


(defun add-grapha (pt list9strings / txtobj maxheight cpt)
  (setq cpt pt)
  (setq maxheight '())
  (mapcar '(lambda (x p)
	     ;(setq x (cadr list9strings))
	     ;(setq p (cadr #spclist9stringsparamlist))
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
	  list9strings			;x
	  #spclist9stringsparamlist	;p
	  )
  ; и выдает точку вставки следующей графы
  (mapcar '- cpt (list 0 (* 8 (eval (append '(max) maxheight))) 0))
  )


;; принипмает список списков strings 
;добавляет
(defun addparagraph (pt grflst / cpt)
  (setq cpt pt)
  (mapcar '(lambda (grafa / nl)
	     (setq cpt (add-grapha cpt grafa))
	     )
	  grflst)
  (mapcar '- cpt (list 0 8 0))
  )




;; принимает отформатированный перечень точек измерения,
;; объединенный по одинаковым признакам
;; добавляет несколько параграфов в спецификацию
;; отмеряя нужное расстояние для следующих листов
(defun addpodrazdel (listforgendat / cpt list_cpt)
  (setq cpt (getpoint)
	list_cpt cpt)

  ;(setq pardata (nth 0 listforgendat))
  (mapcar '(lambda (pardata /)
	     (setq cpt (addparagraph cpt (gen-paragraf pardata)))
	     ;вставка промежутка для разделения на листы
	     (if (>= (- (cadr list_cpt) (cadr cpt)) 192)
	       (progn
		 (setq cpt (mapcar '+ cpt '(0 -120 0))
		       list_cpt cpt)
		 (vla-addline #modspace
		   (vlax-3d-point cpt)
		   (vlax-3d-point (mapcar '+ cpt '(-100 0 0)))
		   )
		 )
	       )
	     )
	  listforgendat)

  )






(addpodrazdel datazipped)

;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . ""))))