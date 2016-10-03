

;;;'(
;;;  ("PI" "LAB11CP501" "Давление на всасе питательного насоса №1" nil "133" "пм" "0.42" "МПа"
;;;   "завод" nil nil "145" nil "32" nil nil nil nil "ПВТ"
;;;  )
;;; )
(defun gen-zakaz-zavod-P (xlslines
			  /
			  position
			  xlsline
			  strname
			  kol
			  paragraph
			  )
  ;(setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval(append(list 'strcat)(mapcar'(lambda (line)(strcat(cadr line)", "))xlslines)))))
  (if (= 1 (length xlslines))
    (progn
      (setq xlsline (car xlslines))
      (setq kol 1)
      (setq position (xlsgpar "KKS" xlsline))
      (cond
	
	((= "PI" (xlsgpar "func" xlsline))
	 (setq
	   strname "Манометр показывающий"
	    ))

	((= "PS" (xlsgpar "func" xlsline))
	 (setq
	   strname "Электроконтактный манометр"
	    ))

	((= "PT" (xlsgpar "func" xlsline))
	 (setq
	   strname "Преобразователь давления измерительный"
	    ))	
	);cond
      (setq paragraph (list (list
	     ;(strcat "{\\W0.8;\\T0.9;" position "}" )
	     position
	     (strcat strname)
	     ""
	     ""
	     ""
	     "шт."
	     (itoa kol)
	     ""
	     (if (member "remarks" xls-head)
	       (xlsgpar "remarks" xlsline)
	       ""
	       )
	     )))
      );end if =1
    (progn
      (alert "нужно переделать функцию\n
      gen-zakaz-zavod-P, т.к. она рассчитана\n
      только на 1 заводcкой датчик на 1 линии\n
      измерения")
      (exit)
      )
    )
   
  );defun