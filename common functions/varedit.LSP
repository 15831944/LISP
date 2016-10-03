;; 13_11_25
;; если есть переменная типа 2Хсипска
;; то эти 2 функции для ее удобного редактирования в акаде

;(setq #lst '(("project-number" "1744-1-АТМ5") ("object-name1" "Строительство ТЭЦ на местных видах топлива") ("object-name2" "в г. Лунинец") ("object-name3" "Вспомогательное оборудование.") ("project-name1" "2 пусковой комплекс. Главный корпус.") ("project-name2" "Вспомогательное оборудование.") ("project-name3" "КИП и А")))
;(vareditstart #lst)
;(vareditend #lst)



(defun vareditstart (varname)
  ;(setq varname '#lst)
  (setq #vareditobjects (cons varname (lst>objs (eval varname))))
  );defun



(defun vareditend ()
  (eval
    (list
    'setq
    (car #vareditobjects)
    (quote
      (mapcarx
	(lambda (x)
	  (vla-get-TextString (vla-HandleToObject #actdoc x))
	  )
	nil
	(cdr #vareditobjects)
	)
      )
    )
    )
  (mapcarx (lambda (x) (vla-delete (vla-HandleToObject #actdoc x))) nil (cdr #vareditobjects))
  (setq #vareditobjects nil)
  );defun
