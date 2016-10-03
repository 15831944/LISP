; 13_05_20
; APLISENS
; НПЦ Европрибор
; APR-2000ALW


; генерация списка - части параграфа спецификации
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;; доработать выбор для абсолютных давлений (вакуум) ; кПа
(setq #apr|catranges
   '((1 0 1.6 "МПа" 25)
     (2 0 250 "кПа" 25)
     (3 0 100 "кПа" 25)
     (4 0 25 "кПа" 25)
     (5 -10 10 "кПа" 25)
     (6 -0.5 7 "кПа" 4)
     (7 -2.5 2.5 "кПа" 4)
     )
      )

;считать будем в мегапаскалях относительного давления , поэтому переводим все в мегапаскали
(defun apr|calcranges (ranges)
   (mapcar
     '(lambda (x)
	(cond
	  ((= "кПа" (nth 3 x)) (list (nth 0 x) (/ (nth 1 x) 1000.0) (/ (nth 2 x) 1000.0) "МПа"))
	  (T x)
	  )
	)
     ranges
     )
  )
;(apr|calcranges #apr|catranges)




;(setq #apr|calcranges
; (mapcar '(lambda (x) (if (= "МПа" (nth 3 x)) (list (nth 0 x) (fix (* 1000 (nth 1 x))) (fix (* 1000 (nth 2 x))) "кПа") x)) #apr|catranges))
   




;(setq xlsline (car (DB|FORMATDATA (excel>lst))))

(defun apr|getrange (xlsline
		     /
		     units
		     valmin uniVmin
		     valnom uniVnom
		     valmax uniVmax
		     catdiaps uniVdiap
		     ans
		     tmp
		     )
  (setq units (xlsgpar "units" xlsline))
  (setq valmin (atof* (xlsgpar "val_p_l" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "val_p_u" xlsline)))
  (cond
    ((= "МПа" units)
     (setq uniVmin valmin)
     (setq uniVnom valnom)
     (setq uniVmax valmax)
     )
    ((= "кПа" units)
     (setq uniVmin (/ valmin 1000.0))
     (setq uniVnom (/ valnom 1000.0))
     (setq uniVmax (/ valmax 1000.0))
     )
    )
  ;(setq val (max (* 1.3 valnom) (* 1.1 valmax)))
  
  (setq
    ans
     (vl-remove-if
       '(lambda (rang)
	  (or
	    (< uniVmin (nth 1 rang))
	    (> uniVmax (nth 2 rang))
	    )
	  )
       (apr|calcranges #apr|catranges)
       )
    )


  (setq catdiaps (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) ans))
  (setq tmp (apply 'min catdiaps))
  ;(assoc (car (nth (vl-position tmp catdiaps) ans)) #apr|catranges)
  ;добавим к этому "установленный диапазон"
  (concat
    (assoc (car (nth (vl-position tmp catdiaps) ans)) #apr|catranges)
    (list (fix valmin) (fix valnom))
    )
  );defun




(setq #elemer|sosudur
   '(
     ("СУ-6,3-2-" 6.3)
     ("СУ-6,3-4-" 6.3)
     ("СУ-25-2-" 25)
     ("СУ-40-" 40)
     ))


(defun gen-zakaz-sosudur (xlslines / kol lst CP tmp mater)
  (setq kol (length xlslines))
  (if (= "dPTF" (xlsgpar "func" (car xlslines))) (setq kol (* 2 kol)))
  (setq mater "А")
  (setq CP (atof* (xlsgpar "P" (car xlslines))))
  (setq lst (vl-remove-if '(lambda (rang) (> CP (nth 1 rang))) #elemer|sosudur))
  (setq tmp (mapcar '(lambda (x) (nth 1 x)) lst))
  (setq tmp (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #elemer|sosudur))
  (list "" "Сосуд уравнительный" (strcat (car tmp) mater) "" "НПО \"Элемер\"\nг. Москва" "шт." (rtos* kol) "" "Аналог")
  );defun




;(setq xlslines (cdr pardata))


(defun gen-zakaz-APR2000ALW  (xlslines / 
	xlsline pozitions range
	shtucer mesto kol ispolnenie
	;sreda
	kodventil nippel kreplenie
	paragraph
	)

  
  (setq pozitions (spc|gsfxl "KKS" ", " xlslines))
  (setq range (apr|getrange (car xlslines)))

  (setq kol (length xlslines))
  ;(setq mesto "Стенд датчиков")
  (setq mesto (xlsgpar "place_sensor" (car xlslines)))
  (setq ispolnenie "стандартное")

  ;; по веннтилям
  ;; была договоренность такая
  ;; простые измерения - МО
  ;; VM-3 - на химию
  ;; см. по температуре, на высокую t - VM-1/Графит
  ;; но потом решили не замрачиваться и везде графит




  
  ;;  для вентильного блока
  ;(setq sreda (xlsgpar "среда" xlsline))

  ;(setq shtucer "С")
  ;(setq kodventil "VM-3/графит")
  ;(setq nippel "2")
  ;(setq kreplenie "C-2")



    ;;;  стандартные настройки
  (setq shtucer "P")
  ;(setq kodventil "M0")
  ;(setq nippel "SO")
  ;(setq kreplenie "AL")

  

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ПАРАГРАФ    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  
  (setq paragraph
   (list
    (list
      ;(strcat "{\\W0.9;\\T0.9;" pozitions "}" )
      pozitions
      (strcat
	"Преобразователь измерительный разности давлений:" "\n"
	"основной диапазон " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) ", "
	"установленный диапазон " (rtos* (nth 5 range)) "..." (rtos* (nth 6 range)) " " (nth 3 range) "\n"
	"исполнение " ispolnenie ", выходной сигнал 4...20 мА, HART" "\n"
	;"класс точности 0,1 %,"
	"присоединение " shtucer ", "
	(cond
	  ((and kodventil nippel (not (= "" kodventil nippel)))
	   (strcat
	     "в комплекте:" "\n"
	     "вентильный блок, " kodventil ", "
	     "комплект ниппелей " nippel ", "
	     )
	   )
	  (T "")
	)
	(if (and kreplenie (not (= "" kreplenie))) (strcat "крепление " kreplenie) "")
	"\n"
	mesto
	)
      (strcat "{\\W0.9;"
	"APR-2000ALW/"
	(if (= ispolnenie "стандартное") "" (strcat ispolnenie "/"))
	(rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) "/"
	(rtos* (nth 5 range)) "..." (rtos* (nth 6 range)) " " (nth 3 range) "/" "\n"
	"/" shtucer
	      (if (and kodventil (not (= "" kodventil))) (strcat "/" kodventil) "")
	      (if (and nippel (not (= "" nippel))) (strcat "/" nippel) "")
	      (if (and kreplenie (not (= "" kreplenie))) (strcat "/" kreplenie) "")
	      "\n"
	"ТУ РБ 390171150.001-2004"
	"}")
      ""
      (strcat "ООО \"Европрибор\"" "\n" "г. Витебск")
      "шт."
      (itoa kol)
      ""
      "Аналог"
      );grafa
    (list "")
    ;(gen-zakaz-sosudur xlslines)
    ;(list "")
    );paragraph
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraph
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

