; 14_12_10
; Энергоприбор

;  $ - имена переменных которые используются в подфункциях

; $rezbaB - внутрення резьба бобышки / внешняя резьба гильзы
; $rezbaD - внутрення резьба гильзы / внешняя резьба датчика


;(setq xlslines (cdr (nth 0 datazipped)))



;;;    выбор бобышки


; $isp $quantity
;(setq xlslines (cdr (nth 12 datazipped)))
(defun EP|gen-zakaz-bobyshka (xlslines / EP:bobyshki btype rezbaB T_nom dL_izo)
  ;$Dtr_rasch
  ;$Lbob
  (setq EP:bobyshki
  '(("type" "skos" "rezba" "Lbob")
    ("0010" nil "М20х1,5" (40 100 120))
    ("0011" nil "М27x2,0" (50 70 100 250))
    ("0012" nil "М33x2,0" (70 90))
    ))
  (cond
    ((= "13" $isp) (setq btype "0012"))
    ((= "14" $isp) (setq btype "0010"))
    ((= "11" $isp) (setq btype "0010"))
    )
  (setq rezbaB (nth 2 (assoc btype EP:bobyshki)))
  (setq $Dtr_rasch (* 1.3 (atof* (xlsgpar "Lmch" (car xlslines)))))


  (cond
    ((setq T_nom (atof* (xlsgpar "nom_val" (car xlslines)))))
    ((setq T_nom (atof* (xlsgpar "max_val" (car xlslines)))))
    ((setq T_nom (atof* (xlsgpar "val_p_u" (car xlslines)))))
    (T (exit))
    )
  (if (or (null T_nom) (= 0 T_nom)  ) (exit))

  
  ;(setq Lbob (apply 'min (last (assoc btype EP:bobyshki))))
  (setq dL_izo (get-closer-from-table T_nom $Dtr_rasch #ТКП45-4.02-129-2009))
  (setq $Lbob (get-closer-from-row dL_izo (last (assoc btype EP:bobyshki))))
  
  (list
    (list
      ""
      (strcat "Бобышка: L=" (rtos* $Lbob) " мм, присоединение " rezbaB ", " (xlsgpar "material" (car xlslines))
	      "\nПо месту"
	      )
      (strcat "Б-" btype "-" (rtos* $Lbob) "-" (xlsgpar "material" (car xlslines)))
      ""
      (strcat "НПООО \"Энергоприбор\"" " " "г. Минск")
      "шт." (rtos* $quantity) "" "{\\T0.95;Аналог. Установить взамен существующих}"
      
      )
    )
  );defun
;(EP|gen-zakaz-bobyshka xlslines)






; $rezbaB $quantity
(defun EP|gen-zakaz-gilza (xlslines / EP:gilzy gtype tmp n L)	; $Gtype
;$Lmont
  (setq EP:gilzy
	 '(
  ("тип" "Pу" "isp" "L" "D" "d")
  ("0050" 25 "00" 80 12 9)
  ("0050" 25 "01" 100 12 9)
  ("0050" 25 "02" 120 12 9)
  ("0050" 25 "03" 160 12 9)
  ("0050" 25 "04" 200 12 9)
  ("0050" 25 "05" 250 12 9)
  ("0050" 25 "06" 320 12 9)
  ("0050" 25 "07" 400 12 9)
  ("0050" 25 "08" 500 12 9)
  ("0050" 25 "09" 630 12 9)
  ("0050" 25 "10" 80 14 11)
  ("0050" 25 "11" 100 14 11)
  ("0050" 25 "12" 120 14 11)
  ("0050" 25 "13" 160 14 11)
  ("0050" 25 "14" 200 14 11)
  ("0050" 25 "15" 250 14 11)
  ("0050" 25 "16" 320 14 11)
  ("0050" 25 "17" 400 14 11)
  ("0050" 25 "18" 500 14 11)
  ("0050" 25 "19" 630 14 11)
  ("0050" 25 "20" 80 15 11)
  ("0050" 25 "21" 100 15 11)
  ("0050" 25 "22" 120 15 11)
  ("0050" 25 "23" 160 15 11)
  ("0050" 25 "24" 200 15 11)
  ("0050" 25 "25" 250 15 11)
  ("0050" 25 "26" 320 15 11)
  ("0050" 25 "27" 400 15 11)
  ("0050" 25 "28" 500 15 11)
  ("0050" 25 "29" 630 15 11)
  ("0050" 25 "30" 80 16 12)
  ("0050" 25 "31" 100 16 12)
  ("0050" 25 "32" 120 16 12)
  ("0050" 25 "33" 160 16 12)
  ("0050" 25 "34" 200 16 12)
  ("0050" 25 "35" 250 16 12)
  ("0050" 25 "36" 320 16 12)
  ("0050" 25 "37" 400 16 12)
  ("0050" 25 "38" 500 16 12)
  ("0050" 25 "39" 630 16 12)
  ("0050" 25 "40" 800 16 12)
  ("0050" 25 "41" 1000 16 12)
  ("0050" 25 "42" 1250 16 12)
  ("0050" 25 "43" 1600 16 12)
  ("0050" 25 "44" 2000 16 12)
  ("0050" 25 "45" 2500 16 12)
  ("0050" 25 "46" 3150 16 12)
  ("0050" 25 "47" 80 20 16)
  ("0050" 25 "48" 100 20 16)
  ("0050" 25 "49" 120 20 16)
  ("0050" 25 "50" 160 20 16)
  ("0050" 25 "51" 200 20 16)
  ("0050" 25 "52" 250 20 16)
  ("0050" 25 "53" 320 20 16)
  ("0050" 25 "54" 400 20 16)
  ("0050" 25 "55" 500 20 16)
  ("0050" 25 "56" 630 20 16)
  ("0050" 25 "57" 800 20 16)
  ("0050" 25 "58" 1000 20 16)
  ("0050" 25 "59" 1250 20 16)
  ("0050" 25 "60" 1600 20 16)
  ("0050" 25 "61" 2000 20 16)
  ("0050" 25 "62" 2500 20 16)
  ("0050" 25 "63" 3150 20 16)
	   
  ("0060" 50 "00" 120 35 8.5)
  ("0060" 50 "01" 160 35 8.5)
  ("0060" 50 "02" 200 35 8.5)
  ("0060" 50 "03" 250 35 8.5)
  ("0060" 50 "04" 320 35 8.5)
  ("0060" 50 "05" 400 35 8.5)
  ("0060" 50 "10" 120 35 8.5)
  ("0060" 50 "11" 160 35 8.5)
  ("0060" 50 "12" 200 35 8.5)
  ("0060" 50 "13" 250 35 8.5)
  ("0060" 50 "14" 320 35 8.5)
  ("0060" 50 "15" 400 35 8.5)
 )
	 )

  (cond
    ((= "13" $isp) (setq gtype "0060"))
    ((= "11" $isp) (setq gtype "0050"))
    ((= "14" $isp) (setq gtype "0050"))
    )
  
  (setq tmp (tbl|filter EP:gilzy (strcat "тип=" gtype)))
  (setq $catLmch (get-closer-from-row (+ (* $Dtr_rasch 0.4) $Lbob)
		   ;$Lmch_old
		   (cdr (assoc "L" (db|transmat tmp)))))
  
  (setq n (vl-position $catLmch (assoc "L" (db|transmat tmp))))
  (setq tmp (nth n tmp))

  (list
    (list
      ""
      (strcat
	"Гильза защитная. Pу=" (rtos* (tbl|gpar (car EP:gilzy) tmp "Pу"))" МПа." "\n"
	"Монтажная длина " (rtos* $catLmch) " мм, материал " (xlsgpar "material" (car xlslines))
	)
      (strcat
	"ГЗ-"
	(tbl|gpar (car EP:gilzy) tmp "тип") "-"
	(tbl|gpar (car EP:gilzy) tmp "isp") "-"
	(rtos* (tbl|gpar (car EP:gilzy) tmp "Pу")) "-"
	(rtos* $catLmch) "-"
	(rtos* $d) "-"
	$rezbaD
	)
      ""
      (strcat "НПООО \"Энергоприбор\"" " " "г. Минск")
      "шт." (rtos* $quantity) "" "{\\T0.95;Аналог. Установить взамен существующих}"
      
      )
    )
  );defun











;;;$rezbaD
;;;$quantity
;;;$Lmch_old
;;;$catLmch
;;;$EP:cheholtype
;;;$isp
;;;$d
(defun EP|THA1199|gen-zakaz (xlslines
			     /
			     pozitions
			     xlsline
			     klass
			     Lmchrow
			     diapazon
			     NSX
			     )
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line) (strcat (xlsgpar "KKS" line) ", "))xlslines)))))
  (setq xlsline (car xlslines))
  (setq NSX "ХА(К)")
  (setq klass "2")
  (setq diapazon "-40...+800")
  (setq
    Lmchrow
     (cond
       ((= "14" $isp) '(80 100 120 160 200 250 320 400 500 630))
       ((= "13" $isp) '(200 250 320 400 500 630 800 1000))
       ((= "11" $isp) '(200 250 320 400 500 630 800 1000 1250 1600 2000 2500 3150))
       )
    )
  (if (null (member $catLmch Lmchrow)) (exit))
  
  (list
    (list
      pozitions
      (strcat
	"Преобразователь термоэлектрический хромель-алюмелевый:" "\n"
	"НСХ " NSX ". Диапазон измерений: " diapazon "°C""\n"
	"длина монтажной части " (rtos* $catLmch) " мм" "\n"
	"Класс допуска " klass
	)
      (strcat
	"ТХА-1199" "/"
	$isp "/"
	klass "/"
	(rtos* $catLmch) "/" (rtos* $d) "/"
	diapazon "°C" "\n"
	"ТУ РБ 37418148.005-99"
	)
      
      ""
      (strcat "НПООО \"Энергоприбор\"" " " "г. Минск")
      "шт." (rtos* $quantity) "" "{\\T0.95;Аналог. Установить взамен существующих}"
      )
    )
  );defun





;;;$rezbaD
;;;$quantity
;;;$Lmch_old
;;;$catLmch
;;;$EP:cheholtype
;;;$isp
;;;$d
(defun EP|TSP1199|gen-zakaz (xlslines
			     /
			     pozitions
			     xlsline
			     klass
			     Lmchrow
			     diapazon
			     NSX
			     )
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line) (strcat (xlsgpar "KKS" line) ", "))xlslines)))))
  (setq xlsline (car xlslines))
  (setq NSX "50П")
  (setq klass "B")
  (setq diapazon "-50...+500")
  (setq
    Lmchrow
     (cond
       ((= "14" $isp) '(80 100 120 160 200 250 320 400 500 630))
       ((= "13" $isp) '(200 250 320 400 500 630 800 1000))
       ((= "11" $isp) '(200 250 320 400 500 630 800 1000 1250 1600 2000 2500 3150))
       )
    )
  (if (null (member $catLmch Lmchrow)) (exit))
  
  (list
    (list
      pozitions
      (strcat
	"Термопреобразователь сопротивления платиновый" "\n"
	"НСХ " NSX ". Диапазон измерений: " diapazon "°C""\n"
	"длина монтажной части " (rtos* $catLmch) " мм" "\n"
	"Класс допуска " klass
	)
      (strcat
	"ТСП-1199" "/"
	$isp "/"
	NSX "/"
	"385" "/"
	klass "/"
	"3" "/"
	(rtos* $catLmch) "/" (rtos* $d) "/" "\n"
	"/" diapazon "°C" "\n"
	"ТУ РБ 37418148.004-99"
	)
      ""
      (strcat "НПООО \"Энергоприбор\"" " " "г. Минск")
      "шт." (rtos* $quantity) "" "{\\T0.95;Аналог. Установить взамен существующих}"
      )
    )
  );defun










;;;$rezbaD
;;;$quantity
;;;$Lmch_old
;;;$catLmch
;;;$EP:cheholtype
;;;$isp
;;;$d
(defun EP|TSM1199|gen-zakaz (xlslines
			     /
			     pozitions
			     xlsline
			     klass
			     Lmchrow
			     diapazon
			     NSX
			     )
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line) (strcat (xlsgpar "KKS" line) ", "))xlslines)))))
  (setq xlsline (car xlslines))
  (setq NSX "50М")
  (setq klass "B")
  (setq diapazon "-50...+180")
  (setq
    Lmchrow
     (cond
       ((= "14" $isp) '(80 100 120 160 200 250 320 400 500 630))
       ((= "13" $isp) '(200 250 320 400 500 630 800 1000))
       ((= "11" $isp) '(200 250 320 400 500 630 800 1000 1250 1600 2000 2500 3150))
       )
    )
  (if (null (member $catLmch Lmchrow)) (exit))
  
  (list
    (list
      pozitions
      (strcat
	"Термопреобразователь сопротивления медный" "\n"
	"НСХ " NSX ". Диапазон измерений: " diapazon "°C" "\n"
	"длина монтажной части " (rtos* $catLmch) " мм" "\n"
	"Класс допуска " klass
	)
      (strcat
	"ТСМ-1199" "/"
	$isp "/"
	NSX "/"
	"428" "/"
	klass "/"
	"3" "/"
	(rtos* $catLmch) "/" (rtos* $d) "/" "\n"
	"/" diapazon "°C" "\n"
	"ТУ РБ 37418148.004-99"
	)
      ""
      (strcat "НПООО \"Энергоприбор\"" " " "г. Минск")
      "шт." (rtos* $quantity) "" "{\\T0.95;Аналог. Установить взамен существующих}"
      )
    )
  );defun






























  

;(EP|gen-zakaz xlslines)
;(setq xlslines (cdr (nth 12 datazipped)))
(defun EP|gen-zakaz (
		     xlslines
		     /
		     xlsline
		     T_p_u	; temperature presetted upper
		     $rezbaD
		     zakazD zakazG zakazB
		     $EP:cheholtype
		     $quantity
		     $isp $d
		     $Lmch_old $catLmch
		     $Dtr_rasch
		     $Lbob
		     )
  
  (setq $rezbaD "М20х1,5")
  (setq T_p_u (atof* (xlsgpar "val_p_u" (car xlslines))))
  (setq $quantity (length xlslines))
  (setq $Lmch_old (atof* (xlsgpar "Lmch" (car xlslines))))


  ;;;;    очень стремное разделение
  (cond
    ((< $Lmch_old  200)
     (setq $EP:cheholtype "прямой")
     (setq $isp "14")
     (setq $d 8)
     )
    ((> T_p_u 390)
     (setq $EP:cheholtype "ступенчатый")
     (setq $isp "13")
     (setq $d 8)
     )
    (T
     (setq $EP:cheholtype "прямой")
     (setq $isp "11")
     (setq $d 10)
     )
    )

  (setq zakazB (EP|gen-zakaz-bobyshka xlslines))

  
  
  (setq zakazG (EP|gen-zakaz-gilza xlslines))
  
  (setq
    zakazD
     (cond
;;;       ((diap T_p_u 0 160)
;;;	(EP|TSP1098|gen-zakaz xlslines)
;;;	)
       ((diap T_p_u -50 180)
	(EP|TSM1199|gen-zakaz xlslines)
	)
       ((diap T_p_u -50 400)
	(EP|TSP1199|gen-zakaz xlslines)
	)
       ((diap T_p_u -40 800)
	(EP|THA1199|gen-zakaz xlslines)
	)
       (T (exit))
       )
    )
  (append
    zakazD
    zakazG
    zakazB
    )
  );defun


















  




