; 13_05_16
; ЮМАС
; Завод теплотехнических приборов г. Минск
; МП100


; генерация списка - части параграфа спецификации
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;; доработать выбор для абсолютных давлений (вакуум)
(setq
  #jumasMP|catranges
   '(
     (1 0 60 "МПа")
     (2 0 40 "МПа")
     (3 0 25 "МПа")
     (4 0 16 "МПа")
     (5 0 10 "МПа")
     (6 0 6 "МПа")
     (7 0 4 "МПа")
     (8 0 2.5 "МПа")
     (9 0 1.6 "МПа")
     (10 0 1.0 "МПа")
     (11 0 0.6 "МПа")
     (12 0 0.4 "МПа")
     (13 0 250 "кПа")
     (14 0 160 "кПа")
     (15 0 100 "кПа")
     (16 0 60 "кПа")
     )
  )

(setq #jumasMP|calcranges
 (mapcar
   '(lambda (x)
      (if (member (nth 3 x) '("кПа" "кПа абс"))
	(list
	  (nth 0 x)
	  (/ (nth 1 x) 1000.0)
	  (/ (nth 2 x) 1000.0)
	  (cond
	    ((= (nth 3 x) "кПа") "МПа")
	    ((= (nth 3 x) "кПа абс") "МПа абс")
	    )
	  )
	x)
      )
   #jumasMP|catranges)
      )


;(setq xlsline (cadr (cdr (nth 14 datazipped))))
;(setq xlsline (car (excel>lst)))
(defun jumasMP|getrange (xlsline / lst valsafe valmin valnom valmax units tmp)
  (setq valmin (atof* (xlsgpar "min_val" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  ;13_05_28 новшество лять ... каждый раз по новому
  ;(setq valsafe (max (* 1.38 valnom) (* 1.38 valmax)))
  (setq valsafe (max (* 1.38 valnom) (* 1.1 valmax)))
  
  (setq units (xlsgpar "units" xlsline))
  (setq lst (vl-remove-if '(lambda (rang) (or(< valmin (nth 1 rang))(> valsafe (nth 2 rang)))) #jumasMP|calcranges))
  (setq lst (vl-remove-if-not '(lambda (x) (= units (nth 3 x))) lst))
  (setq tmp (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) lst))
  ;(assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges)
  ;добавим к этому "установленный диапазон"
  (append
    (setq tmp (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #jumasMP|catranges))
    (list (nth 1 tmp) (/ (fix (* 10 valsafe)) 10.0)))
  );defun
;(#jumasMP|getrange xlsline)













;(setq xlslines (cdr proto))
;(setq xlslines (cdr (cadr (cadr (nth 16 datazipped2)))))
(defun gen-zakaz-jumas
       (xlslines /
	xlsline
	pozitions
	range
	mesto
	diamkorp
	klass
	kol
	paragraf
	)

  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  ;"LAB32CP001, LAB32CP002" 


  (setq xlsline (car xlslines))
  (setq range (jumasMP|getrange (car xlslines)))
  (setq diamkorp 100)	;диаметр корпуса
  (setq klass 1.5)
  (setq kol (length xlslines))
  (setq mesto (xlsgpar "place_sensor" xlsline))
  ;;;; для APC-2000ALW
	;; по веннтилям
  	;; была договоренность такая
  	;; простые измерения - МО
  	;; VM-1 - на химию
  	;; см. по температуре, на высокую t - VM-1/Графит
  	;; но потом решили не заморачиваться и везде графит
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ПАРАГРАФ    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  
  (setq
    paragraf
     (list
       (list
	 ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	 pozitions
	 (strcat
	"Манометр показывающий с радиальным штуцером без фланца:" "\n"
	"Диапазон измерения " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range)", " 
	"класс точности " (rtos* klass) "\n"
	mesto
	)
      (strcat
	"МП" (itoa diamkorp) "М (" (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) ") "(nth 3 range)"-" (rtos* klass) "\n"
	"ТУ РБ 37388602.002-96"
	)
      ""
      (strcat "СООО \"Завод теплотехнических приборов\"" " " "г. Минск")
      "шт."
      (itoa kol)
      ""
      "Аналог"
      );grafa
    )
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraf
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;










;;;;; доработать выбор для абсолютных давлений (вакуум)
(setq
  #jumasMVP|catranges
   '(
     (1 -100 60 "кПа абс")
     (2 -100 150 "кПа абс")
     (3 -100 300 "кПа абс")
     (4 -100 500 "кПа абс")
     (5 -0.1 0.9 "МПа абс")
     (6 -0.1 1.5 "МПа абс")
     (7 -0.1 2.4 "МПа абс")
     )
  )

(setq #jumasMVP|calcranges
 (mapcar
   '(lambda (x)
      (if (member (nth 3 x) '("кПа" "кПа абс"))
	(list
	  (nth 0 x)
	  (/ (nth 1 x) 1000.0)
	  (/ (nth 2 x) 1000.0)
	  (cond
	    ((= (nth 3 x) "кПа") "МПа")
	    ((= (nth 3 x) "кПа абс") "МПа абс")
	    )
	  )
	x)
      )
   #jumasMVP|catranges)
      )

;(setq xlsline (cadr (cdr (nth 14 datazipped))))
;(setq xlsline (car (excel>tbl)))
(defun jumasMVP|getrange (xlsline / lst valsafe valmin valnom valmax units tmp)
  (setq valmin (atof* (xlsgpar "min_val" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  ;13_05_28 новшество лять ...
  (setq valsafe (max (* 1.38 valnom) (* 1.38 valmax)))
  (setq units (xlsgpar "units" xlsline))
  (setq lst (vl-remove-if '(lambda (rang) (or(< valmin (nth 1 rang))(> valsafe (nth 2 rang))))#jumasMVP|calcranges))
  (setq lst (vl-remove-if-not '(lambda (x) (= units (nth 3 x))) lst))
  (setq tmp (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) lst))
  ;(assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges)
  ;добавим к этому "установленный диапазон"
  (append
    (setq tmp (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #jumasMVP|catranges))
    (list (nth 1 tmp) (/ (fix (* 10 valsafe)) 10.0)))
  );defun
;(jumasMVP|getrange xlsline)





;(setq xlslines (cdr proto))
;(setq xlslines (cdr (cadr (cadr (nth 16 datazipped2)))))
(defun gen-zakaz-jumas-MVP
       (xlslines /
	xlsline
	pozitions
	range
	mesto
	diamkorp
	klass
	kol
	paragraf
	)

  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  ;"LAB32CP001, LAB32CP002" 
  (setq xlsline (car xlslines))
  (setq range (jumasMVP|getrange (car xlslines)))
  (setq diamkorp 100)	;диаметр корпуса
  (setq klass 1.5)
  (setq kol (length xlslines))
  (setq mesto (xlsgpar "place_sensor" xlsline))
  
  (setq
    paragraf
     (list
       (list
	 ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	 pozitions
	 (strcat
	"Мановакуумметр показывающий с радиальным штуцером без фланца:" "\n"
	"Диапазон измерения " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range)", " 
	"класс точности " (rtos* klass) "\n"
	mesto
	)
      (strcat
	"МВП" (itoa diamkorp) "М (" (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) ") "(nth 3 range)"-" (rtos* klass) "\n"
	"ТУ РБ 37388602.002-96"
	)
      ""
      (strcat "СООО \"Завод теплотехнических приборов\"" " " "г. Минск")
      "шт."
      (itoa kol)
      ""
      "Аналог"
      );grafa
    )
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraf
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;(setq xlslines (cdr proto))
;(setq xlslines (cdr (cadr (cadr (nth 22 datazipped2)))))
(defun gen-zakaz-jumas-EKM
       (xlslines /
	xlsline
	pozitions
	range
	mesto
	diamkorp
	klass
	kol
	paragraf
	)
  
  (setq pozitions (spc|gsfxl3 '("KKS") '(", ") xlslines))


  (setq xlsline (car xlslines))
  (setq range (jumasMP|getrange (car xlslines)))
  (setq diamkorp 100)	;диаметр корпуса
  (setq klass 1.5)
  (setq kol (length xlslines))
  (setq mesto (xlsgpar "place_sensor" xlsline))
  ;;;; для APC-2000ALW
	;; по веннтилям
  	;; была договоренность такая
  	;; простые измерения - МО
  	;; VM-1 - на химию
  	;; см. по температуре, на высокую t - VM-1/Графит
  	;; но потом решили не заморачиваться и везде графит
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ПАРАГРАФ    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  
  (setq
    paragraf
     (list
       (list
	 ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	 pozitions
	 (strcat
	   "Манометр показывающий сигнализирующий с радиальным штуцером," "\n"
	   "без фланца, на микровыключателях:" "\n"
	   
	"диапазон измерения " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range)", " 
	"класс точности " (rtos* klass) ", базовая схема исполнения" "\n"
	mesto
	)
      (strcat
	"ЭкМ" (itoa diamkorp) "Вм ("
	(rtos* (nth 1 range))
	"..."
	(rtos* (nth 2 range))
	") "
	(nth 3 range)
	"-"
	(rtos* klass)
	"\n"
	"ТУ РБ 37388602.002-96"
	)
      ""
      (strcat "СООО \"Завод теплотехнических приборов\"" " " "г. Минск")
      "шт."
      (itoa kol)
      ""
      "Аналог"
      );grafa
    )
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraf
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       