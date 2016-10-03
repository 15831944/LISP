


(sssetfirst nil (ssget "_X" '(
			      (-4 . "<AND")
			      (0 . "TEXT")
			      	(-4 . "<OR")
			      	(1 . "Наименование и техническая характеристика")
			      	(1 . "Позиция")
			      	(1 . "Тип, марка, ")
			      	(1 . "обозначение документа")
			      	(1 . "опросного листа")
			      	(1 . "Код обору-")
			      	(1 . "дования,")
			      	(1 . "изделия,")
			      	(1 . "материала")
			      	(1 . "Завод-")
			      	(1 . "изготовитель")
			      	(1 . "Единица")
			      	(1 . "изме-")
			      	(1 . "рения")
			      	(1 . "Коли-")
			      	(1 . "")
			      (1 . "чество")
			      (1 . "Масса")
			      (1 . "единицы,")
			      (1 . "кг")
			      (1 . "Примечание")
			      (1 . "Подп. и дата")
			      (1 . "Взам. инв. №")
			      (1 . "")
			      	(-4 . "OR>")
			      (-4 . "AND>")
			      )))



(defun pickX (
	      /
	      ss
	      ss1
	      X
	      i
	      )

  (setq X (cadr (cdr (assoc 10 (entget (car (entsel)))))))
  
  (setq ss 	(ssget );"_W" '((0 . "LINE")))
	i	0
	ss1	(ssadd)
	) ;_ конец setq

       (repeat (sslength ss)
	 (if (or
	       (= X (cadr (cdr (assoc 10 (entget (ssname ss i))))))
	       (= X (cadr (cdr (assoc 11 (entget (ssname ss i))))))
	       );or

		
	   (setq ss1 (ssadd (ssname ss i) ss1))
	   );if
	 (setq i (1+ i))
	 );repeat
       (sssetfirst nil ss1)
 )






(defun pickX1 (
	      /
	       en
	      ss
	      ss1
	       L
	      X
	      i
	      )
  (setq en (car (entsel)))

  (setq L (distance
	    (cdr (assoc 10 (entget en)))
	    (cdr (assoc 11 (entget en)))
	    ))

  
  (setq ss 	(ssget "_X" '((0 . "LINE")));"_W" '((0 . "LINE")))
	i	0
	ss1	(ssadd)
	) ;_ конец setq

       (repeat (sslength ss)
	 (if  (> L (distance (cdr (assoc 10 (entget (ssname ss i))))
			     (cdr (assoc 11 (entget (ssname ss i))))))
	 (setq ss1 (ssadd (ssname ss i) ss1))
	   );if
	 (setq i (1+ i))
	 );repeat
       (sssetfirst nil ss1)
 )