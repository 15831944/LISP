;;; ударные продолжения - допиливаю выбор МАРКов
;;; 13_10_31
;;;                    МАРКИ    (ВЗОР)


(load (strcat #lisppath "DataBase\\dblib.LSP"))
(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))
(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\spclib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))


;(setq xls-data (excel>tbl))
;(setq xls-head (car xls-data)
;      xls-data (cdr xls-data))


(setq db:head (car (excel>lst)))




(setq db:data (db|formatdata (excel>lst)))


;; собираем по приборам
(setq datazipped (cdr (db|mapzip (append '("table") db:data) "комплект")))




;;;;;    собственно тут обоработка ВВОдА данных и заканчивается ,
;;;;   далее по каждому элементу списка datazipped мы будем формировать list-таблици формата вывода в специф.



;;;   выбор типа МАРКа

;(setq paragdata (nth 5 datazipped))
(defun gen-paragraf  (paragdata)
  (if (apply '=  (mapcar '(lambda (line) (db|gpar "прототип" line))(cdr paragdata)))
    (cond
      ((= "МАРК-409" (db|gpar "прототип" (cadr paragdata)))
       (gen-zakaz-MARK409 paragdata))
      ((= "МАРК-602" (db|gpar "прототип" (cadr paragdata)))
       (gen-zakaz-MARK602 paragdata))
      ((= "МАРК-902" (db|gpar "прототип" (cadr paragdata)))
       (gen-zakaz-MARK902 paragdata))
      ((= "МАРК-1002" (db|gpar "прототип" (cadr paragdata)))
       (gen-zakaz-MARK1002 paragdata))
      (T (princ (strcat "\n прототип "(db|gpar "прототип" (cadr paragdata)) " не описан в программе")))
      );cond
    (progn (princ "\n У датчиков развные прототипы, этот вариант не описан!!! ") (exit))
    )
  );defun



;;;(setq datatoadd '(
;;;  ("a1" "a2" "a3" "a4" "a5" "a6" "a7" "a8" "a9")
;;;  ("b1" "b2" "b3" "b4" "b5" "b6" "b7" "b8" "b9")
;;;  ("c1" "c2" "c3" "c4" "c5" "c6" "c7" "c8" "c9")
;;;(		  "" "" "" "" "" "" "" "" "")
;;;(  "d1" "d2" "d3" "d4" "d5" "d6" "d7" "d8" "d9")
;;;  ))





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



;;;(defun addpodrazdel2* (listforgendat / cpt list_cpt)
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

(defun addpodrazdel2 (listforgendat / cpt )
  (setq cpt (getpoint)
	#list_cpt cpt)
  ;(setq pardata (nth 0 listforgendat))
  (mapcar
    '(lambda (pardata /) (setq cpt (addparagraph2 cpt (gen-paragraf pardata))))
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





	

(addpodrazdel2 datazipped)









;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . ""))))
;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . " "))))