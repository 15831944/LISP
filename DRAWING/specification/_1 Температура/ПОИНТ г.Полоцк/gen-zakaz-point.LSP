; 13_08_28
; 13_11_05
; ТС-Б-У ПШ (Полоцк, "ПОИНТ")
; ТП-Б-У ПШ (Полоцк, "ПОИНТ")
; 13_12_27
; ТС-Б ПШ (Полоцк, "ПОИНТ")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq #point|cheholtype "ступенчатый")
;(setq #point|cheholtype "прямой")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; погружаемый
; ПШ
; клеммная головка E
(setq #point:headtype "Е")

;;;; договорились брать все гильзы - цилиндрические цельноточенные резьбовые, из нерж. стали
;;;;  или ГЦР.111 или ГЦР.112
;;;; на давление 25 МПа (то есть диаметр 16 / 18)
;;;; в установка параметров - ф самой функции генерации заказа




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(defun getlbobysh (xlsline / Dn OT)
;;;  (setq OT (xlsgpar "sampling_device" xlsline))
;;;  (setq Dn (atof* (xlsgpar "Diam_tr" xlsline)))
;;;  ;договоренность про бобышки
;;;  (cond ((< Dn 150) 40) ((>= Dn 150) 80))
;;;  );defun
;;;;(getlbobysh xlsline)

;(setq xlsline (car xlslines))
;(setq xlsline (car (DB|FORMATDATA(excel>lst))))
;     1!!!!!!!!!!!!   по хорошему длину бобышки надо выбирать по изоляции трубы
(defun point|*get*Lbobysh (xlsline / Dn OT)
  ; договоренность про бобышки - это если заказываем сами 40 или 80 мм - в зависимости от диаметра
  ; если бобышка ОТ-шная то по госту 01 ОСТ 108.530.01 их длина 80
  (setq OT (xlsgpar "sampling_device" xlsline))
  (cond
    ((and OT (/= OT "") (= OT "01 ОСТ 108.530.01")) 80)
    ((or (null OT) (= OT "")) (setq Dn (atof* (xlsgpar "Diam_tr" xlsline)))(cond ((< Dn 150) 40) ((>= Dn 150) 80)))
    (T (princ "\nНЕ распознан тип бобышки") (exit))
    )
  );defun
;(point|*get*Lbobysh xlsline)






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlsline (nth 14 data))
(defun point-TP|*get*Trange (xlsline / valsafe valnom valmax scval #point-TP|catrangesT)
  (setq #point-TP|catrangesT '(600 700 800 900))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  (setq valsafe (max (* 1.2 valnom) (* 1.2 valmax)))
  (setq scval (apply 'min (vl-remove-if '(lambda (x) (<= (- x valsafe) 0)) #point-TP|catrangesT)))
  (list 0 scval)
  );defun
;(point-TP|*get*Trange xlsline)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlsline (nth 14 data))
(defun point-TS|*get*Trange (xlsline / valsafe valnom valmax scval #point-TS|catrangesT)
  (setq #point-TS|catrangesT '(50 80 100 150 180 200 250 300 400 500))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  (setq valsafe (max (* 1.2 valnom) (* 1.2 valmax)))
  (setq scval (apply 'min (vl-remove-if '(lambda (x) (<= (- x valsafe) 0)) #point-TS|catrangesT)))
  (list 0 scval)
  );defun
;(point-TS|*get*Trange xlsline)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlsline (cadr (car datazipped)))
(defun point-TP|*get*Lmont (xlsline / Dn Lb Lmin Lmax #point-TP|catrangesLmch  Lsafe) 
  (setq #point-TP|catrangesLmch '(120 160 200 250 320 400 500 630 800 1000 1600 2000 2500 3150))
  (setq Lb (point|*get*Lbobysh xlsline))		;длина бобышки
  (setq Dn (atof* (xlsgpar "Diam_tr" xlsline)))
  (setq Lsafe (+ (* 0.35 Dn) Lb))
  (apply 'min (vl-remove-if '(lambda (x) (<= (- x Lsafe) 0)) #point-TP|catrangesLmch))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(point-TP|*get*Lmont xlsline)
(defun point-TS|*get*Lmont (xlsline / Dn Lb Lmin Lmax #point-TS|catrangesLmch  Lsafe) 
  (setq #point-TS|catrangesLmch '(80 100 120 160 200 250 320 400 500 630 800 1000 1250 1600 2000 2500 3150))
  (setq Lb (point|*get*Lbobysh xlsline))		;длина бобышки
  (setq Dn (atof* (xlsgpar "Diam_tr" xlsline)))
  ;(setq Lsafe (+ (* 0.37 Dn) Lb))
  (setq Lsafe (+ (* 0.35 Dn) Lb))
  (apply 'min (vl-remove-if '(lambda (x) (<= (- x Lsafe) 0)) #point-TS|catrangesLmch))
  );defun
;(point-TS|*get*Lmont xlsline)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point|*get*Lnar (xlsline / Tmax)
  (setq Tmax (* 1.1 (cadr (point-TS|*get*Trange xlsline))))
  (cond
    ((diap Tmax -100 399) 50)
    ((diap Tmax 0    799) 120)
    ((diap Tmax 800 1000) 160)
    ((> Tmax        1000) 200)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  (defun point|get-diam-mch ( / tmp)
;;;    (setq tmp (* L_mch 1.1))
;;;    (cond
;;;      ;((diap tmp 0 320) 6)
;;;      ((diap tmp 0 1000) 8)
;;;      (T 10)
;;;      )
;;;    );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlslines xlslinesTT)
(defun point-TP|gen-zakaz-dat (xlslines /
			       Dschup Dmont
			       kol range
			       Lmont Lnar
			       spytype
			       pozitions
			       )
  (setq spytype "И")	;;;; тип спая по каталогу
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  (setq Dschup 8)
  (setq Dmont 10)
  (setq kol (length xlslines))
  (setq range (point-TP|*get*Trange (car xlslines)))
  (setq Lmont (point-TP|*get*Lmont (car xlslines)))
  (setq Lnar (point|*get*Lnar (car xlslines)))

  (list
    (list
      ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
      pozitions
      (strcat
	"Преобразователь термоэлектрический унифицированный погружной:" "\n"
	"класс точности 0,5 %, диапазон измерения (" (rtos* (car range)) "...+" (rtos* (cadr range)) ") °C," "\n"
	"длина монтажной части " (rtos* Lmont) " мм, диаметр монтажной части " (rtos* Dmont) " мм," "\n"
	"тип крепления - подвижный штуцер, длина наружной части " (rtos* Lnar) " мм," "\n"
	"присоединение M20x1,5, напряжение питания 24 В, IP65"
	)
      (strcat
	"ТП-Б-У (4-20)мА-(±0,5)-" spytype "-П-" "\n"
	"-(" (rtos* (car range)) "..." (rtos* (cadr range)) ")-" (rtos* Lmont) "/" (rtos* Dmont)
	(cond
	  ((= "ступенчатый" #point|cheholtype) "-(60/8)")
	  ((= "прямой" #point|cheholtype) "")
	  (T "")
	  )
	"-\n"
	"-ПШ." (rtos* Lnar) ".М20х1,5-" #point:headtype "\n"
	"ТУ РБ 390184271.012-2008"
	)
      ""
      (strcat "ООО \"ПОИНТ\"" " " "г. Полоцк")
      "шт." (rtos* kol) "" "Аналог"
      )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point-TS|gen-zakaz-dat (xlslines /
			       Dschup Dmont
			       kol range
			       Lmont Lnar
			       pozitions
			       )
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  ; у ступенчатых чехлов других вариантов тут нет
  ; spytype - все правильно , в ТС-Б в заказе не пишется
  (setq Dschup 8)
  (setq Dmont 10)
  (setq kol (length xlslines))
  (setq range (point-TS|*get*Trange (car xlslines)))
  (setq Lmont (point-TS|*get*Lmont (car xlslines)))
  (setq Lnar (point|*get*Lnar (car xlslines)))

  (list
    (list
      (strcat "{\\W0.8;\\T0.9;" pozitions "}" )
      (strcat
	"Термопреобразователь сопротивления унифицированный погружной:" "\n"
	"класс точности 0,5 %, диапазон измерения (" (rtos* (car range)) "...+" (rtos* (cadr range)) ") °C," "\n"
	"длина монтажной части " (rtos* Lmont) " мм, диаметр монтажной части " (rtos* Dmont) " мм," "\n"
	"тип крепления - подвижный штуцер, длина наружной части " (rtos* Lnar) " мм," "\n"
	"присоединение M20x1,5, напряжение питания 24 В, IP65"
	)
      (strcat
	"ТС-Б-У (4-20)мА-(±0,5)-П-" "\n"
	"-(" (rtos* (car range)) "..." (rtos* (cadr range)) ")-" (rtos* Lmont) "/" (rtos* Dmont)
	(cond
	  ((= "ступенчатый" #point|cheholtype) "-(60/8)")
	  ((= "прямой" #point|cheholtype) "")
	  (T "")
	  )
	"-\n"
	"-ПШ." (rtos* Lnar) ".М20х1,5-" #point:headtype "\n"
	"ТУ РБ 03 10 1826 08"
	)
      ""
      (strcat "ООО \"ПОИНТ\"" " " "г. Полоцк")
      "шт." (rtos* kol) "" "Аналог"
      )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point-TSB|gen-zakaz-dat (xlslines /
				NSH
				shemasoed
				shemasoedtxt
				klass
			       Dschup Dmont
			       kol range
			       Lmont Lnar
			       pozitions
			       )
  (setq klass "B")
  (setq shemasoed "x3")
  (setq shemasoedtxt (cond
	   ((= shemasoed "x2") "двухпроводная схема соединений")
	   ((= shemasoed "x3") "трехпроводная схема соединений")
	   ((= shemasoed "x4") "четырехпроводная схема соединений")))
  
  (setq NSH "Pt100")
  (setq range '(0 250))
  
  
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  ; у ступенчатых чехлов других вариантов тут нет
  ; spytype - все правильно , в ТС-Б в заказе не пишется
  (setq Dschup 8)
  (setq Dmont 10)
  (setq kol (length xlslines))
  
  
  (setq Lmont (point-TS|*get*Lmont (car xlslines)))
  (setq Lnar (point|*get*Lnar (car xlslines)))

  (list
    (list
      (strcat "{\\W0.8;\\T0.9;" pozitions "}" )
      (strcat
	"Термопреобразователь сопротивления. НСХ \"" NSH "\", класс допуска " klass "\n"
	 shemasoedtxt ", " "диапазон измерения (" (rtos* (car range)) "...+" (rtos* (cadr range)) ") °C," "\n"
	"длина монтажной части " (rtos* Lmont) " мм, диаметр монтажной части " (rtos* Dmont) " мм," "\n"
	"тип крепления - подвижный штуцер, длина наружной части " (rtos* Lnar) " мм," "\n"
	"присоединение M20x1,5, с пластиковой клеммной головкой, IP65"
	)
      (strcat
	"ТС-Б-" NSH "-" klass "-" shemasoed "-П-" "\n"
	"-(" (rtos* (car range)) "..." (rtos* (cadr range)) ")-" (rtos* Lmont) "/" (rtos* Dmont)
	(cond
	  ((= "ступенчатый" #point|cheholtype) "-(60/8)")
	  ((= "прямой" #point|cheholtype) "")
	  (T "")
	  )
	"-\n"
	"-ПШ." (rtos* Lnar) ".М20х1,5-" #point:headtype "\n"
	"ТУ РБ 03 10 1826 08"
	)
      ""
      (strcat "ООО \"ПОИНТ\"" " " "г. Полоцк")
      "шт." (rtos* kol) "" "Аналог"
      )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point|gen-zakaz-gilza (xlslines / kol Dnar Lmont)
  ;;;; цельноточеная - ГЦР.111
  (cond
    ((= "ступенчатый" #point|cheholtype) (setq gtype "ГЦР.111"))
    ((= "прямой" #point|cheholtype) (setq gtype "ГЦР.112"))
    (T (setq gtype "ГЦР.112"))
    )
  
  (setq kol (length xlslines))
  (cond
    ((= gtype "ГЦР.111") (setq Dnar 16))
    ((= gtype "ГЦР.112") (setq Dnar 18))
    (T (exit))
    )

  (cond
    ((= "ТС-Б-У" (xlsgpar "прототип" (car xlslines)))
     (setq Lmont (point-TS|*get*Lmont (car xlslines))))
    ((= "ТС-Б" (xlsgpar "прототип" (car xlslines)))
     (setq Lmont (point-TS|*get*Lmont (car xlslines))))
    ((= "ТП-Б-У" (xlsgpar "прототип" (car xlslines)))
     (setq Lmont (point-TP|*get*Lmont (car xlslines))))
    ((= "ТП-Б" (xlsgpar "прототип" (car xlslines)))
     (setq Lmont (point-TP|*get*Lmont (car xlslines))))
    )
 
  (list
    (list
      ""
      (strcat
	"Гильза цилиндрическая резьбовая "
	(cond
	  ((member gtype '("ГЦР.111" "ГЦР.112"
			   ;"ГЦР.121" "ГЦР.131"
			   )) "цельноточеная")
	  (T "сварная")
	  ) ":\n"
	"внешний диаметр " (rtos* Dnar) " мм, длина монтажной части " (rtos* Lmont) " мм," "\n"
	"присоединение M20x1,5, условное давление 25\\~МПа, материал\\~12Х18Н10Т;"
	)
      (strcat gtype "-M20x1,5-" (rtos* Dnar) "-"(rtos* Lmont)"-25")
      ""
      (strcat "ООО \"ПОИНТ\"" " " "г. Полоцк")
      "шт." (rtos* kol) "" "Аналог"
      )
    )
  );defun
;(point|gen-zakaz-gilza xlslinesTT)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point|gen-zakaz-bobyshka (xlslines / tmpr sreda sd kol Dnar Lbob TM-uzel-par TM-uzel-voda rezba)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq TM-uzel-par "1744-1-ТМ20")
  (setq TM-uzel-voda "1744-1-ТМ20")
  (setq rezba "М20х1,5")
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq kol (length xlslines))
  (setq Lbob (point|*get*Lbobysh (car xlslines)))
  (setq tmpr (atof* (xlsgpar "nom_val" (car xlslines))))
  (setq sreda (cond ((>= tmpr 200) "пар") ((< tmpr 200) "вода")))
  (setq sd (xlsgpar "sampling_device" (car xlslines)))
  (cond
    (
     (= sd "01 ОСТ 108.530.01")
     (list
       (list
	 ""
	 (strcat "Бобышка: L=" (rtos* Lbob) " мм, присоединение " rezba)
	 sd "" "" "шт." (rtos* kol) ""
	 (strcat
	   "{\\W0.9;\\T0.9;"
	   "Заказ по спецификации "
	   (cond
	     ((= sreda "пар") TM-uzel-par)
	     ((= sreda "вода") TM-uzel-voda)
	     )
	   "}"
	   )
	 )
       )
     )

    
    ((= sd "")
     (setq Lbob (point|*get*Lbobysh (car xlslines)))
     (list
       (list
	 ""
	 (strcat "Бобышка: L=" (rtos* Lbob) " мм, присоединение " rezba ", Ст.20")
	 (strcat "1/28-" (rtos* Lbob) "-" rezba)
	 "" "ООО \"ПОИНТ\" г. Полоцк"  "шт." (rtos* kol) "" "Аналог"
	 )
       )
     )
    );cond чей заказ бобышки
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point|gen-zakaz-rasshiritel (xlslines / Dn kol typ)
  (setq Dn (atof* (xlsgpar "Diam_tr" (car xlslines))))
  (if (< Dn 40)
    (progn
      (setq kol (length xlslines))
      (setq typ (get-closer-from-row Dn '(25 32 38)))
      (list
	(list
	  "" "Расширитель прямой с бобышкой, для установки приборов, 12Х18Н10Т"
	  (strcat "57x" (rtos* typ) "-M20x1,5-Б") "" "ООО \"ПОИНТ\" г. Полоцк" "шт." (rtos* kol) "" ""
	  )
	)
      )
    );if
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1
(defun point-TP|*gen*zakaz (xlslines)
  (append
    (point-TP|gen-zakaz-dat xlslines)		;;;; (("" "" ""))
    (point|gen-zakaz-gilza xlslines)
    (point|gen-zakaz-bobyshka xlslines)
    (point|gen-zakaz-rasshiritel xlslines)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point-TS|*gen*zakaz (xlslines)
  (append
    (point-TS|gen-zakaz-dat xlslines)		;;;; (("" "" ""))
    (point|gen-zakaz-gilza xlslines)
    (point|gen-zakaz-bobyshka xlslines)
    (point|gen-zakaz-rasshiritel xlslines)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point-TSB|*gen*zakaz (xlslines)
  (append
    (point-TSB|gen-zakaz-dat xlslines)		;;;; (("" "" ""))
    (point|gen-zakaz-gilza xlslines)
    (point|gen-zakaz-bobyshka xlslines)
    (point|gen-zakaz-rasshiritel xlslines)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (gen-zakaz-point-TS xlslinesTT)




