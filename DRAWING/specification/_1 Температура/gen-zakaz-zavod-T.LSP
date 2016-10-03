

;;;'(
;;;  ("PI" "LAB11CP501" "Давление на всасе питательного насоса №1" nil "133" "пм" "0.42" "МПа"
;;;   "завод" nil nil "145" nil "32" nil nil nil nil "ПВТ"
;;;  )
;;; )
;(setq xlslines (cdr pardata))
(defun gen-zakaz-zavod-T (xlslines
			  /
			  strname
			  kol
			  paragraph
			  pozitions
			  tmp
			  )
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  (setq kol (length xlslines))
  (cond
    ((= "TT" (xlsgpar "func" (car xlslines)))
     (setq
       strname (strcat "Термопреобразователь сопротивления платиновый НСХ \"" (xlsgpar "sign_type" (car xlslines)) "\"")
       ))
    ((= "TE" (xlsgpar "func" (car xlslines)))
     (setq
       strname (strcat "Термоппара")
       ))    
;;;    ((= "PS" (xlsgpar "func" xlsline))
;;;     (setq
;;;       strname "Электроконтактный манометр"
;;;       ))
;;;    ((= "PT" (xlsgpar "func" xlsline))
;;;     (setq
;;;       strname "Преобразователь давления измерительный"
;;;       ))
    );cond

  (append
    (list
      (list
	;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	pozitions
	(strcat strname)
	(if (setq tmp (xlsgpar "remarks" (car xlslines))) tmp "")
	"" "" "шт." (rtos* kol) ""
	(if (setq tmp (xlsgpar "комплект" (car xlslines))) tmp "")
	)
      )
    (point|gen-zakaz-bobyshka xlslines)
    )
  );defun