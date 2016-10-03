(load (strcat #lisppath "DataBase\\dblib.lsp"))
(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))
(load (strcat #lisppath "Strings\\kd-sortstrings.LSP"))

;(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))
;(load (strcat #lisppath "DRAWING\\specification\\spclib.lsp"))
;(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))





(setq db:head (car (excel>lst)))
(setq db:data (cons "table" (db|formatdata (excel>lst))))
(setq db:data (cons "table" (vl-remove-if '(lambda (x) (apply '= (cons "" x))) (cdr db:data))))


(assoc "Не открыто" (vcfstr>data (db|gpar "interfacedata" (car (cdr db:data)))))


(db|vcf>lst "interface" (car (cdr db:data)))



(db|mapzip db:data "interface")




(setq lst
(mapcar
  '(lambda (x)
     ;(db|vcf>lst "interface" x)
     (db|gpar "KKS" x)
     )
  (cdr db:data)
  ))

(length lst)


(setq lst
(mapcar
  '(lambda (x) ;(setq x (car (cdr db:data)))
     (mapcar
       '(lambda (st)	;(setq st (car (cdr (db|vcf>lst "interface" x))))
	  (mapcar
	    '(lambda (si)	;(setq si (car (cdr st)))
	       (list
		 (car st)
		 si
		 (db|gpar "KKS" x)
		 (db|gpar "название арматуры" x)
		 (db|gpar "сборка" x)
		 (car (cdr (assoc si (cdr (db|vcf>lst "interfacedata" x)))))
		 (cadr (cdr (assoc si (cdr (db|vcf>lst "interfacedata" x)))))
		 )
	       )
	    (cdr st)
	    )
	  
	  
	  )
       (cdr (db|vcf>lst "interface" x))
       )
     )
  (cdr db:data)
  )
      )




(lst>excel
  (apply 'append (apply 'append lst))
  )





(setq tbl (db|vcf>lst "interface" (car (cdr db:data))))
(setq subtbl (db|vcf>lst "interfacedata" (car (cdr db:data))))


(defun tblreplacement (tbl / as)
  (if (atom tbl)
    (if (setq as (assoc tbl (cdr subtbl)))
      as
      tbl
      )
    (mapcar 'tblreplacement tbl)
    )
  )


(setq res (tblreplacement tbl))










(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\spclib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
(load (strcat #lisppath "DataBase\\dblib.LSP"))
(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))



;; 2-й ввод
(setq xls-head (car (excel>lst)))
(setq ШТ1Б (DB|FORMATDATA (excel>lst)))
(setq ШТ2А (DB|FORMATDATA (excel>lst)))
(setq ШТ2Б (DB|FORMATDATA (excel>lst)))



(setq data (append ШТ1Б ШТ2А ШТ2Б))


(lst>excel data)
(length ШТ1Б)
(length ШТ2А)
(length ШТ2Б)
(length data) ;464


(length
  (vl-remove-if '(lambda (x / val) (setq val (xlsgpar "Присвоение" x)) (member val '("" "Резерв")))data)
  )
;256
;; хмм... у меня в перечне 253

(length
  (vl-remove-if '(lambda (x / val) (setq val (xlsgpar "Присвоение" x)) (null (member val '("" "Резерв"))))data)
  )
;208


























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;  T R A N S L A T E  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(setq #tr|dictionary (DB|FORMATDATA  (excel>lst)))
(setq #tr|dictionary
 (mapcar
  '(lambda (b)
     (list
       (vla-get-TextString (getbatt b "NUMBER"))
       (str|remove-multi-lines (vla-get-TextString (getbatt b "SIGNALNAME")))
       (str|remove-multi-lines (vla-get-TextString (getbatt b "LOCFLD")))
       (vla-get-TextString (getbatt b "TYPE"))
       (vla-get-TextString (getbatt b "CORES"))
       (vla-get-TextString (getbatt b "SECTION"))
       )
     )
  (ss->lsto* (ssget "_I"))
  ))


(setq tr|target (ss->lsto* (ssget "_I")))
(setq tr|target (excel>lst))



(length tr|target )
(length #tr|dictionary)
;;;;;;;;;;;;;;;;;;;;|
(mapcar
  '(lambda (x)
     )
  tr|target)
;;;;;;;;;;;;;;;;;;;;|

(setq res
(mapcar
  '(lambda (x / num)
     (if (setq num (car x))
       (assoc num #tr|dictionary)
       '(nil nil nil nil nil nil)
       )
     )
  tr|target
  )
      )
(lst>excel res)



(mapcar
  '(lambda (x / attsrc atttarg)
     (setq attsrc (getbatt x "ID"))
     (setq atttarg (getbatt x "NAME"))

     (vla-put-TextString atttarg
       (cadr (assoc (vla-get-TextString attsrc) #tr|dictionary))
       )
     )
  tr|target)



(tr|translate tr|target "ID" "ID" #tr|dictionary)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tr|translate (blst srctag targtag dict)
  (mapcar
    '(lambda (x / attsrc atttarg)
       (setq attsrc (getbatt x srctag))
       (setq atttarg (getbatt x targtag))
       (vla-put-TextString atttarg
	 (cadr (assoc (vla-get-TextString attsrc) dict))
	 )
       )
    blst)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load (strcat #lisppath "excel\\xlsformatlib.LSP"))

(setq #tr|dictionary (DB|FORMATDATA  (excel>lst)))



(while (setq KKS (nentsel))
  (progn
    (setq KKS (vla-get-TextString (vlax-ename->vla-object (car KKS))))
    (setq line (assoc KKS #tr|dictionary))
    (vla-put-TextString (vlax-ename->vla-object (car (nentsel)))
      (strcat (cadr line) " " (caddr line))
      )
    )
  )







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;  14_02_13


(load (strcat #lisppath "DataBase\\dblib.lsp"))



(setq db:head (car (excel>lst)))
(setq db:data (append '("table") (excel>lst)))
(setq db:data (vl-remove '(nil nil) db:data))

;;;  заполняем блоки pwr_подвал в схеме питания
;;; excel отсортирована по каналам блоков питания
;1 вариант
(setq blocks (ss->lsto (ssget)))
(mapcar
  '(lambda (b d)
     (vla-put-TextString (getbatt b "ID") (db|gpar "KKS" d))
     (vla-put-TextString (getbatt b "SIGNALNAME") (db|gpar "meas_name" d))
     )
  blocks
  (cdr db:data)
  )

;2 вариант - самый универсальный
(setq translatelst '(("KKS" "ID")("meas_name" "SIGNALNAME")))
(setq blocks (ss->lsto (ssget)))
(mapcar
  '(lambda (b d)
     (mapcar
       '(lambda (pp)
	  (vla-put-TextString (getbatt b (cadr pp)) (db|gpar (car pp) d))
	  )
       translatelst
       )
     )
  blocks
  (cdr db:data)
  )




;3 вариант тыкалка
;; заполняем аттрибуты блоков из таблицы екселя
;; such as "func_затвор-с-электроприводом"
(mapcar
  '(lambda (line / obj)
     (setq obj (vlax-ename->vla-object (car (entsel (car line)))))
     (vla-put-TextString (getbatt obj "ID") (car line))
     (vla-put-TextString (getbatt obj "NAME") (cadr line))
     (vlax-put-property obj "color" 256)
     )
  (cdr db:data)
  )











