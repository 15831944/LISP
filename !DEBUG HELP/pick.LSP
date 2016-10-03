


(sssetfirst
  nil
  (ssget "_X"
	 '(
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
	   ;(1 . "Подп. и дата")
	   ; (1 . "Взам. инв. №")
	   (1 . "")
	   (-4 . "OR>")
	   (-4 . "AND>")
	   )
	 ) ;_ ssget
  ) ;_ sssetfirst





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
(pickX)





;;; фильтр блоков по аттрибуту


(defun bfilter ( / lst samp tag str atts ss)
  (if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
    (setq ss (ssget '((0 . "INSERT"))))
    )
  (setq lst (ss->lsto* ss))
  (setq samp (nentsel))	(setq samp (vlax-ename->vla-object (car samp)))
  (setq tag (vla-get-TagString samp)) (setq str (vla-get-textString samp))
  (setq lst
	 (VL-REMOVE-IF-NOT '(lambda (x)
		(= str (vla-get-TextString (getbatt x tag)))
		;(= "" (vla-get-TextString (getbatt x tag)))			      
			      ) lst)
	 )
  (sssetfirst nil (lsto-to-ss lst))
  );defun