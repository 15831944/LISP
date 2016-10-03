; 13_05_16
; воспользовалс€ 13_11_05 - без исправлений
; APLISENS
; Ќѕ÷ ≈вроприбор
; APC-2000ALW


; генераци€ списка - части параграфа спецификации

;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;; бзик по шкалам, стереть об€зательно
;;; —≈ хочет брать установленный диапазон измерений датчика
;; из стандартных шкал манометров

(setq #MP|scale '(0.06 0.1 0.16 0.2 0.25 0.4 0.6 0.7 1.0 1.6 2.5 4.0 6.0 10.0 16.0 25.0 40.0 60.0)) ;ћѕа

;(apc|get-scale 4.5)

(setq #apc|catranges
       '(
	 ;0 1  2   3      4    5
	 (1 0 100 "ћѕа")
	 (2 0 30 "ћѕа")
	 (3 0 16 "ћѕа")
	 (4 0 7 "ћѕа")
	 (5 0 2.5 "ћѕа")
	 (6 0 0.7 "ћѕа")
	 (7 -100 600 "кѕа")
	 (8 -100 150 "кѕа")
	 (9 0 200 "кѕа")
	 (10 0 100 "кѕа")
	 (11 -50 50 "кѕа")
	 (12 0 25 "кѕа")
	 (13 -10 10 "кѕа")
	 (14 -1.5 7 "кѕа")
	 (15 0 130 "кѕа абс")
	 (16 0 700 "кѕа абс")
	 (17 0 2.5 "ћѕа абс")
	 (18 0 7 "ћѕа абс")
	)
      )

;считать будем в мегапаскал€х, поэтому переводим все в мегапаскали
(setq #apс|calcranges
 (mapcar
   '(lambda (x)
      (if (member (nth 3 x) '("кѕа" "кѕа абс"))
	(list
	  (nth 0 x)
	  (/ (nth 1 x) 1000.0)
	  (/ (nth 2 x) 1000.0)
	  (cond
	    ((= (nth 3 x) "кѕа") "ћѕа")
	    ((= (nth 3 x) "кѕа абс") "ћѕа абс")
	    )
	  )
	x)
      )
   #apc|catranges)
      )
   


;(setq xlsline (car (cdr (nth 13 datazipped))))
;(setq xlsline (car (excel>tbl)))
(defun apс|getrange (xlsline / lst valsafe valmin valnom valmax units tmp scval)
  (setq valmin (atof* (xlsgpar "min_val" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  ;(setq valsafe (max (* 1.5 valnom) (* 1.2 valmax)))
  ;13_05_28 новшество л€ть ...
  (setq valsafe (max (* 1.1 valnom) (* 1.1 valmax)))
  (setq units (xlsgpar "units" xlsline))
  ;;; ну пон€тно, да? (—≈)
  (setq scval (apply 'min (vl-remove-if  '(lambda (x) (<= (- x (if (member units '("ћѕа" "ћѕа абс")) valnom (/ valnom 1000.0)))0)) #MP|scale)))
  
  (setq lst (vl-remove-if '(lambda (rang) (or(< valmin (nth 1 rang))(> valsafe (nth 2 rang))))#apс|calcranges))
  (setq lst (vl-remove-if-not '(lambda (x) (= units (nth 3 x))) lst))
  (setq tmp (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) lst))
  ;(assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges)
  ;добавим к этому "установленный диапазон"
  (append
    (setq tmp (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apc|catranges))
;;;    (if (> valnom 2)
;;;      ;;;;; то что было до "гениальных" идей —≈
;;;      (list (nth 1 tmp) (if (member (nth 3 tmp) '("ћѕа" "ћѕа абс"))
;;;			  (math-fix (* 1.1 valsafe))
;;;			  (* 1000 (math-fix (* 1.1 valsafe)))
;;;			  ))
;;;
;;;      
;;;      (list (nth 1 tmp) (if (member (nth 3 tmp) '("ћѕа" "ћѕа абс"))
;;;			  (/ (math-fix (* 10 (* 1.1 valsafe))) 10.0)
;;;			  (* 1000 (/ (math-fix (* 10 (* 1.1 valsafe))) 10.0))
;;;			  ))
      ;; теперь выполн€ем бзики динозавров
    (list
      (nth 1 tmp)
      (if (member (nth 3 tmp) '("ћѕа" "ћѕа абс")) scval (* 1000 scval))
      )
    )
  );defun
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

  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines))))
  ;"LAB32CP001, LAB32CP002" 


  (setq xlsline (car xlslines))
  (setq range (apс|getrange (car xlslines)))
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

  
  (setq shtucer "ћ")
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
	   "установленный диапазон " (rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " "(nth 3 range) "\n"
	   "исполнение " ispolnenie ", выходной сигнал 4...20 мј, HART" "\n"
	   (if kodventil (strcat "вентиль " kodventil) "")
	   (if nippel (strcat "ниппель " nippel ", ") "")
	   (if kreplenie (strcat "крепление " kreplenie) "")
	   "\n"
	   mesto
	   )
	 (strcat
	   "{\\W0.9;" "APC-2000ALW/"
	   (if (= ispolnenie "стандартное") "" (strcat ispolnenie "/"))
	   (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) "/"
	   (rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " " (nth 3 range) "/" "\n"
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

