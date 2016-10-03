; 13_05_20
; APLISENS
; НПЦ Европрибор
; APR-2000ALW


; генерация списка - части параграфа спецификации
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;; доработать выбор для абсолютных давлений (вакуум) ; кПа
(setq #apr|catranges
   '((1 0 1.6 "МПа")
     (2 0 250 "кПа")
     (3 0 100 "кПа")
     (4 0 25 "кПа")
     (5 -10 10 "кПа")
     (6 -0.5 7 "кПа")
     (7 -2.5 2.5 "кПа")))
(setq #apr|calcranges
 (mapcar '(lambda (x) (if (= "МПа" (nth 3 x)) (list (nth 0 x) (fix (* 1000 (nth 1 x))) (fix (* 1000 (nth 2 x))) "кПа") x)) #apr|catranges))
   





(defun apr|getrange (xlsline / lst val valmin valnom valmax tmp)
  (setq valmin (phis|m->kpa (atof* (xlsgpar "min_val" xlsline))))
  (setq valnom (phis|m->kpa (atof* (xlsgpar "nom_val" xlsline))))
  (setq valmax (phis|m->kpa (atof* (xlsgpar "max_val" xlsline))))
  (setq val (max (* 1.3 valnom) (* 1.1 valmax)))
  (setq lst (vl-remove-if '(lambda (rang) (or (< valmin (nth 1 rang)) (> val (nth 2 rang))))#apr|calcranges))
  (setq tmp (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) lst))
  ;(assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges)
  ;добавим к этому "установленный диапазон"
  (append (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges) (list (fix valmin) (fix val)))
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
  (setq shtucer "С")
  (setq kol (length xlslines))
  (setq mesto "Стенд датчиков")
  (setq ispolnenie "стандартное")

  ;; по веннтилям
  ;; была договоренность такая
  ;; простые измерения - МО
  ;; VM-3 - на химию
  ;; см. по температуре, на высокую t - VM-1/Графит
  ;; но потом решили не замрачиваться и везде графит

  ;(setq sreda (xlsgpar "среда" xlsline))
  (setq kodventil "VM-3/графит")
  (setq nippel "2")
  (setq kreplenie "C-2")


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
	"установленный диапазон " (rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " " (nth 3 range) "\n"
	"исполнение " ispolnenie ", выходной сигнал 4...20 мА, HART" "\n"
	;"класс точности 0,1 %,"
	"присоединение " shtucer ", в комплекте:" "\n"
	"вентильный блок, "
	"комплект ниппелей " nippel ", "
	"крепление " kreplenie "\n"
	mesto
	)
      (strcat "{\\W0.9;"
	"APR-2000ALW/"
	(if (= ispolnenie "стандартное") "" (strcat ispolnenie "/"))
	(rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) "/"
	(rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " " (nth 3 range) "/" "\n"
	"/" shtucer "/" kodventil "/" nippel "/" kreplenie "\n"
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
    (gen-zakaz-sosudur xlslines)
    (list "")
    );paragraph
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraph
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

