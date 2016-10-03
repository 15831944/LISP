; 13_05_07
; ТСП Метран-226
; рис. 2 (ПШ)
;  (setq diam_schup 10)
;  (setq diam_mch 10)
;(setq sens-kod 02)

; генерация списка - части параграфа спецификации

;;;;;;;;;;;;;            !!!!!!!!!!!!!!!!            13_11_11    надо перепроверить


;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;принимаем список paramlist:
;;;   0		  1	2	3		4	5		6
;;; D_tru	nom_val max 	прототип	P	бобышка		kol
;;;("57"	"20"	"#"	"Метран-226"	"0,6"	"#"		"3")
;;;("57"	"250"	"#"	"Метран-226"	"4,3"	"ОТ"		"2") 


;(setq paramlist (append (caddr datalineforparagraph) (list (itoa (length (cadr datalineforparagraph))))))

(defun gen-zakaz-metran226 (xlslines / paramlist 
			   CP_ CT_nom CT_max D_truby
			   bobyshka-OT L_bobysh
			   sens-kod			;код исполнения оборудования
			   klass-dopuska		;класс допуска
			   shema			;схема подключения
			   T_diap			;диапазон температуры
			   L_mch
			   L_nch
			   subparagraph
			   kol
			    pozitions
			   )
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  (setq
    paramlist
     (list
       (xlsgpar "Diam_tr" (car xlslines))
       (xlsgpar "nom_val" (car xlslines))
       (xlsgpar "max_val" (car xlslines))
       (xlsgpar "прототип" (car xlslines))
       (xlsgpar "P" (car xlslines))
       (xlsgpar "sampling_device" (car xlslines))
       (rtos* (length xlslines))
       )
     )

  

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;  выбор параметров комплекта датчика  ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; CP_ МПа
  (if (and
	(setq CP_ (nth 4 paramlist))
	(isnumericstring CP_)
	)
    (setq CP_ (atof* CP_))
    (setq CP_ 0.1)
    )


  (setq CT_nom (atof* (nth 1 paramlist)))
  (setq CT_max (atof (nth 2 paramlist)))
  ;(setq CT_ (max (* 1.6 (atof* (nth 1 paramlist))) (* 1.2 (atof (nth 2 paramlist)))))
  (setq D_truby (atoi (nth 0 paramlist)))
  (setq kol (nth 6 paramlist))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;; толщина изоляци
  ;(load (strcat #lisppath "specification\\толщина изоляции.LSP")) ; ТКП45-4.02-129-2009 = list
  ;(setq dL_izo (get-closer-from-table CT_ D_truby #ТКП45-4.02-129-2009))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;     по хорошему нужно учитывать для выбора составляющих
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     БОБЫШКА     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq bobyshka-OT (or (> CP_ 2.6) (= "ОТ" (nth 5 paramlist))))
  ; бобышка метран 2010-01
  (defun metran226|get-L_bobysh (/)
    (cond
      ((< D_truby 150) 40)
      ((>= D_truby 150) 60)
      )
    );defun
  (setq L_bobysh (if bobyshka-OT
		   80
		   (metran226|get-L_bobysh)))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ДАТЧИК      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




  (defun metran226|get-sens-kod (/ lst)
    "02"
    )
  (setq sens-kod (metran226|get-sens-kod))

  (setq shema 4)


  (defun metran226|get-diap ( / tmp lst)
    (setq lst '((-70 500)(-30 350)(-50 200)(-30 200)))
    (setq tmp (* CT_nom 1.6))
;;;    (mapcar
;;;      '(lambda (x)
;;;	 (diap 20 (car x) (cadr x))
;;;	 )
;;;      lst)
    "-70...500"
    )
  (setq T_diap (metran226|get-diap))
  
  

  (defun metran226|get-klass (/ lst)
    ;(setq lst '((-70 500)(-30 350)(-50 200)(-30 200)))
    "B"
    )
  (setq klass-dopuska (metran226|get-klass))


    

  (defun metran226|get-L_mont (/ lst condidatelist Lmch_min Lmch_max)
    (setq lst '(60 80 100 120 160 200 250 320 400 500 630 800 1000 1250 1600 2000))
    (setq Lmch_min (+ (/ D_truby 3.0) L_bobysh))
    (setq Lmch_max (+ (/ D_truby 1.8) L_bobysh))
    (setq condidatelist (vl-remove-if '(lambda (x)
					 (or (< x Lmch_min)
					     (> x Lmch_max))) lst))
    (if condidatelist
      (eval (append '(min) condidatelist))
      (eval (append '(min) lst))	;временная мера изза гребаных технологов с трубой 57 на 400 градусах
;;;      (if (< D_truby (- (car lst)  L_bobysh))
;;;	(alert "слишком тонкая труба и короткая бобышка\nнет такой длины монтажной части")
;;;	(car lst)
;;;	)
      )
  );defun
  (setq L_mch (metran226|get-L_mont))

  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq L_nch 120)




  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ПАРАГРАФ    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  (append
    (list
    (list
      ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
      pozitions
      (strcat
	"Термопреобразователь сопротивления платиновый:" "\n"
	"НСХ \"Pt100\", класс допуска "klass-dopuska", диапазон измерения " T_diap "\\~%%dC," "\n"
	"длина монтажной части " (itoa L_mch) " мм," "\n"
	"тип крепления - подвижный штуцер, M20x1,5, степень защиты IP65" "\n"
	"в комплекте:"
	)
      
      (strcat
	"ТСП Метран-226-" sens-kod "-" (itoa L_mch) "-" klass-dopuska "-"(itoa shema)"-1-" "\n"
	"-Н10-(" T_diap ")%%dC-У1.1-ГП" "\n"
	"ТУ 4211-03-12580824-2002"
	)
      ""
      (strcat "ПГ \"Метран\"\nг. Челябинск")
      "шт."
      kol
      ""
      "Аналог"
      )
   
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (list
      ""
      (strcat
	     "Гильза защитная сварная:" "\n"
	     "длина монтажной части " (itoa L_mch) " мм, присоединение M20x1,5," "\n"
	     "условное давление 25 МПа, материал 12Х18Н10Т"
	     )
      (strcat
	"2001-02-M20x1,5-M20x1,5-Н10-"(itoa L_mch) "\n"
	"ТУ 3742-002-07503230-2007"
	)
      ""
      (strcat "ПГ \"Метран\"\nг. Челябинск")
      "шт."
      kol
      ""
      "Аналог"
      );list
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    )
  (point|gen-zakaz-bobyshka xlslines)
  )
    

  
  );defun