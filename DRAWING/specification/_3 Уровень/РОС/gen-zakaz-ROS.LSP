; 13_05_18
; Теплоприбор
; РОС-301

;(setq xlslines (cdr (car datazipped)))
(defun gen-zakaz-ROS301
       (xlslines 
	/
	pozs
	height
	l1
	l2
	l3
	kol
	)
  (setq kol (length xlslines))
  (setq pozs (spc|gsfxl "KKS" ",\n" xlslines))
  
  
  (setq height (atof* (xlsgpar "scale" (car xlslines))))
  (setq l1 (atof* (xlsgpar "min_val" (car xlslines))))
  (setq l2 (atof* (xlsgpar "nom_val" (car xlslines))))
  (setq l3 (atof* (xlsgpar "max_val" (car xlslines))))
  
  (if (= 0 l1) (setq l1 nil))
  (if (= 0 l2) (setq l2 nil))
  (if (= 0 l3) (setq l3 nil))


  (cond
    ((= "vert" (xlsgpar "Diam_tr" (car xlslines)))
     (progn
       (if l1 (setq l1 (- height l1)))
       (if l2 (setq l2 (- height l2)))
       (if l3 (setq l3 (- height l3)))
       )
     )
    ((= "horiz" (xlsgpar "Diam_tr" (car xlslines)))
     (setq
       l1 0.1
       l2 0.1
       l3 0.1
       )
     )
    (T (progn (alert (strcat "не указан способ\nмонтажа датчиков РОС\n" pozs))(exit)))
    );cond
    
  (list
    pozs
    (strcat
      "Датчик-реле уровня. Питание ~ 220 В. Монтаж "
      (cond
	((= "vert" (xlsgpar "Diam_tr" (car xlslines))) "вертикальный")
	((= "horiz" (xlsgpar "Diam_tr" (car xlslines))) "горизонтальный")
	)
      )
    (strcat
      "РОС-301-1-УХЛ3-("
      (vl-string-right-trim ";"
	(strcat
	  (rtos* l1) ";"
	  (rtos* l2) ";"
	  (rtos* l3) ";"
	  )
	)

      ")" "\n"
      "ТУ 25-2408.0009-88"
      )
    ""
    "ОАО \"Теплоприбор\"\nг. Рязань"
    "шт."
    (itoa kol)
    ""
    "Аналог"
    )
  );defun