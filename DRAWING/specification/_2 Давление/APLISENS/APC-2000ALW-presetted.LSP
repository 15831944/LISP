







!!!!   сделать запись заказа в тех единицах которые в катологе




; 13_05_16
; воспользовалс€ 13_11_05 - без исправлений
; APLISENS
; Ќѕ÷ ≈вроприбор
; APC-2000ALW


; генераци€ списка - части параграфа спецификации

;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(apc|get-scale 4.5)

(setq #apc|catranges
       '(
	 ;0 1  2   3     5	; по каталогу
	 (1 0 100 "ћѕа" 120)
	 (2 0 30 "ћѕа" 45)
	 (3 0 16 "ћѕа" 30)
	 (4 0 7 "ћѕа" 14)
	 (5 0 2.5 "ћѕа" 5)
	 (6 0 0.7 "ћѕа" 1.4)
	 (7 -100 600 "кѕа" 1400)
	 (8 -100 150 "кѕа" 400)
	 (9 0 200 "кѕа" 400)
	 (10 0 100 "кѕа" 200)
	 (11 -50 50 "кѕа" 200)
	 
	 (12 0 25 "кѕа" 100)
	 (13 -10 10 "кѕа" 100)
	 (14 -1.5 7 "кѕа" 50)
	 
	 (15 0 130 "акѕа" 200)
	 (16 0 700 "акѕа" 1400)
	 (17 0 2.5 "аћѕа" 5)
	 (18 0 7 "аћѕа" 14)
	)
      )





;считать будем в мегапаскал€х относительного давлени€ , поэтому переводим все в мегапаскали
(defun apс|calcranges (ranges)
   (mapcar
     '(lambda (x)
	(cond
	  ((= "кѕа" (nth 3 x))
	   (list (nth 0 x) (/ (nth 1 x) 1000.0) (/ (nth 2 x) 1000.0) "ћѕа")
	   )
	  ((= "акѕа" (nth 3 x))
	   (list (nth 0 x) (- (/ (nth 1 x) 1000.0) 0.1) (- (/ (nth 2 x) 1000.0) 0.1) "ћѕа")
	   )
	  ((= "кѕа абс" (nth 3 x))
	   (list (nth 0 x) (- (/ (nth 1 x) 1000.0) 0.1) (- (/ (nth 2 x) 1000.0) 0.1) "ћѕа")
	   )
	  ((= "аћѕа" (nth 3 x))
	   (list (nth 0 x) (- (nth 1 x) 0.1) (- (nth 2 x) 0.1) "ћѕа")
	   )
	  ((= "ћѕа абс" (nth 3 x))
	   (list (nth 0 x) (- (nth 1 x) 0.1) (- (nth 2 x) 0.1) "ћѕа")
	   )
	  (T x)
	  )
	)
     ranges
     )
  )





;(setq xlsline (car (cdr (nth 13 datazipped))))
;(setq xlsline (car (db|formatdata (excel>lst))))


(defun apс|getrange (xlsline
		     /
		     units
		     catdiaps uniVdiap
		     valmin uniVmin
		     valnom uniVnom
		     valmax uniVmax
		     ans
		     
		     tmp
		     nomerdiap
		     scval
		     )\
  ;;  считываем введенные параметры
  (setq units (xlsgpar "units" xlsline))
  (setq valmin (atof* (xlsgpar "val_p_l" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "val_p_u" xlsline)))
  ;  переводим всЄ в относительные мегапаскали
  (cond
    ((= "ћѕа" units)
     (setq uniVmin valmin)
     (setq uniVnom valnom)
     (setq uniVmax valmax)
     )
    
    ((member units '("аћѕа" "ћѕа абс"))
     (setq uniVmin (- valmin 0.1))
     (setq uniVnom (- valnom 0.1))
     (setq uniVmax (- valmax 0.1))
     )
    
    ((= "кѕа" units)
     (setq uniVmin (/ valmin 1000.0))
     (setq uniVnom (/ valnom 1000.0))
     (setq uniVmax (/ valmax 1000.0))
     )
    ((member units '("акѕа" "кѕа абс"))
     (setq uniVmin (/ (- valmin 100) 1000.0))
     (setq uniVnom (/ (- valnom 100) 1000.0))
     (setq uniVmax (/ (- valmax 100) 1000.0))
     )
    )
  ;;  высчитываем диапазоны измерений
  (setq uniVdiap (abs (- uniVmin uniVmax)))
  ;;  в зависимости от величин (относительные или абсолютыне) отсеваем диапазоны которые не удовлетвор€ют параметрам
  (setq
    ans
     (vl-remove-if
       '(lambda (rang)
	  (or
	    (< uniVmin (nth 1 rang))
	    (> uniVmax (nth 2 rang))
	    )
	  )
       (cond
	 ((member units '("акѕа" "кѕа абс" "аћѕа" "ћѕа абс"))
	  (apс|calcranges (vl-remove-if '(lambda (line) (< (nth 0 line)  15))#apc|catranges))
	  )
	 (T
	  (apс|calcranges (vl-remove-if '(lambda (line) (>= (nth 0 line)  15))#apc|catranges))
	  )
	 )
       )
    )

  
  ;;  ищем  минимальный диапазон
  (setq catdiaps (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) ans))
  (cond
    ((member units '("акѕа" "кѕа абс" "аћѕа" "ћѕа абс"))
     (setq tmp (apply 'min (vl-remove-if '(lambda (d) (> (* uniVdiap 1.35) d)) catdiap)))
     )
    (T (setq tmp (apply 'min catdiaps))
     )
    )
  (if (null tmp) (setq tmp (apply 'min catdiaps)))

  ;; по номеру каталога выдаем искомый диапазон
  (setq nomerdiap (car (nth (vl-position tmp catdiaps) ans)))
  (append
    (setq tmp (assoc nomerdiap #apc|catranges))
    (list
      (nth 1 tmp)
      (if (member (nth 3 tmp) '("ћѕа" "аћѕа" "ћѕа абс")) uniVnom (* 1000 uniVnom))
      )
    )
  );defun

;(setq xlsline (car (db|formatdata (excel>lst))))
;(apс|getrange xlsline)









;;;;; доработать выбор дл€ абсолютных давлений (вакуум)
;;;(setq
;;;  #apc|scalelist
;;;   '(
;;;     (0 100)
;;;     (0 30)
;;;     (0 16)
;;;     (0 7)
;;;     (0 2.5)
;;;     (0 0.7)
;;;     (-0.1 0.6)
;;;     (-0.1 0.15)
;;;     (0 0.2)
;;;     (0 0.1)
;;;     (-0.05 0.05)
;;;     (0 0.025)
;;;     (-0.01 0.01)
;;;     )
;;;  )
;;;
;;;
;;;(defun apc|get-scale (nval / lst mval)
;;;  ;(setq nval 4.3)
;;;  ;(* nval 1.5)
;;;  (setq lst
;;;  (vl-remove-if-not
;;;    '(lambda (di)
;;;       ;(< (* nval 1.5) (cadr di))
;;;       (< nval (cadr di))
;;;       ) #apc|scalelist)
;;;	)
;;;  (setq mval (apply 'min (mapcar 'cadr lst)))
;;;  (car
;;;    (vl-remove-if-not
;;;      '(lambda (di)
;;;	 (= mval (cadr di))
;;;	 ) #apc|scalelist)
;;;    )
;;;  )
;;;








;(setq xlslines (cdr proto))
;(setq xlslines (cdr (car (cadr (nth 15 datazipped2)))))
(defun gen-zakaz-APC2000ALW
       (xlslines /
	xlsline
	pozitions

	;CP_
	;CPmin_
	;CPmax_
	;osn-diapazon
	range
	
	mesto
	shtucer
	ispolnenie
	sreda
	kodventil
	nippel
	kreplenie
	kol
	grafa
	)

  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", ")) xlslines))))
  ;"LAB32CP001, LAB32CP002" 


  (setq xlsline (car xlslines))
  (setq range (apс|getrange (car xlslines)))

  (cond
    ((= (nth 3 range) "акѕа") (setq range (subst "кѕа абс" "акѕа" range)))
    ((= (nth 3 range) "аћѕа") (setq range (subst "ћѕа абс" "аћѕа" range)))
    )

  
  ;(setq range (apс|getrange xlsline))
;;;  (setq CP_ (xlsgpar "nom_val" xlsline)
;;;	CPmin_ (xlsgpar "min_val" xlsline)
;;;	CPmax_ (xlsgpar "max_val" xlsline)
;;;	)
    
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;  выбор параметров комплекта датчика  ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; CP_ ћѕа
;;;  (if (and
;;;	(setq CP_ (xlsgpar "nom_val" xlsline))
;;;	(isnumericstring CP_)
;;;	(setq CP_ (atof* CP_))
;;;	)
;;;    (setq CPmax_ (max (* 1.6 CP_) (* 1.2 (atof* CPmax_))))
;;;    (progn (alert "\n не указано давление") (exit))
;;;    )

  
  ;(setq osn-diapazon (apc|get-scale CPmax_))

  
  
  (setq kol (length xlslines))
  (setq mesto (xlsgpar "place_sensor" xlsline))
  
  ;(setq ispolnenie "SN")
  (setq ispolnenie "стандартное")


  ;(setq sreda (xlsgpar "среда" xlsline))



  
  ;; по веннтил€м
  ;; была договоренность така€
  ;; простые измерени€ - ћќ - это до 160 —
  ;; VM-1 - до 230 —
  ;; VM-1/графит - на химию - до 500 —
  ;; см. по температуре, на высокую t - VM-1/√рафит
  ;; но потом решили не заморачиватьс€ и везде графит - это в лунинце


  ;(setq kodventil "VM-1/графит")
  ;;; на сетевой воде достаточно ћќ - до 160 — - Ќќ ‘≈ сказал поставить VM-1

  ;;;  стандартные настройки
  (setq shtucer "ћ")
  (setq kodventil "M0")
  (setq nippel "SO")
  (setq kreplenie "AL")
  
  ; в ѕЌ—-‘ ‘≈ сказал поставить VM-1
  ; и к тому же и вентиль и ниппель заказывать в конце спецификации стандартный - потому что прокладки нет
  ; оставить только крепление
  ;(setq kodventil nil)
  ;(setq nippel nil)
  ;(setq kreplenie "AL")

 

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ѕј–ј√–ј‘    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq
    grafa
     (list
       (list
	 ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	 pozitions
	 (strcat
	   "ѕреобразователь давлени€ измерительный (интеллектуальный):" "\n"
	   "основной диапазон " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range)", "
	   "установленный диапазон " (rtos* (nth 5 range)) "..." (rtos* (nth 6 range)) " "(nth 3 range) "\n"
	   "исполнение " ispolnenie ", выходной сигнал 4...20 мј, HART" "\n"
	   (if kodventil (strcat "вентиль " kodventil ", ") "")
	   (if nippel (strcat "ниппель " nippel ", ") "")
	   (if kreplenie (strcat "крепление " kreplenie) "")
	   "\n"
	   mesto
	   )
	 (strcat
	   "{\\W0.9;" "APC-2000ALW/"
	   (if (= ispolnenie "стандартное") "" (strcat ispolnenie "/"))
	   (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) "/"
	   (rtos* (nth 5 range)) "..." (rtos* (nth 6 range)) " " (nth 3 range) "/" "\n"
	   "/" shtucer
	   (if kodventil (strcat "/" kodventil) "")
	   (if nippel (strcat "/" nippel) "")
	   (if kreplenie (strcat "/" kreplenie) "")
	   "\n"
	   "“” –Ѕ 390171150.001-2004" "}"
	   )
	 ""
	 (strcat "ќќќ \"≈вроприбор\"" "\n" "г. ¬итебск") "шт." (itoa kol) "" "јналог"
	 );grafa
       )
    );setq
  grafa
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

