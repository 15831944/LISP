(setq data (excel>lst))







(setq
  transdata
   '(
     ("Вода" "воды")
     ("Пар" "пара")
     ("Напор" "на напоре")
     ("Питательная вода" "питательной воды")
     ("Прямая сетевая вода" "прямой сетевой воды")
     ("Обратная сетевая вода" "обратной сетевой воды")
     ("Сетевая вода" "сетевой воды")
     ("Охлаждающая вода" "охлаждающей воды")
     ("Конденсат" "конденсата")
     ("Паропровод" "паропровода")
     ("Подшипник" "подшипника")
     ("Крышка" "крышки")
     ("Стенка" "стенки")
     ("Корпус" "корпуса")
     ("Металл" "металла")
     ("Медь" "меди")
     ("Железо" "железа")
     ("Сталь" "стали")
     ("Масло" "масла")
     ("Водород" "водорода")
     ("Холодный газ" "холодного газа")
     ("Холодный воздух" "холодного воздуха")
     ("Горячий газ" "горячего газа")
     ("Горячий воздух" "горячего воздуха")
     ("Активная сталь" "активной стали")
     ("Цирквода" "циркводы")
     ("Аварийный подпиток" "аварийного подпитка")
     ("Ротор" "ротора")
     ("Баббит" "баббита")
     ("Рабочая колодка" "рабочей колодки")
     ("Установочная колодка" "установочной колодки")

     ("Конденсатор" "в конденсаторе")
     ("Конденсатосборник" "в конденсатосборнике")
     ("Коллектор" "в коллекторе")
     ("Фильтр" "в фильтре")
     ("Фильтрующая сетка" "в фильтрующей сетке")
     ("Аванкамера" "в аванкамере")
     ("Дренажный бак" "в дренажном баке")
     ("Уравнительная линия" "в уравнительнйо линии")
     )
  )
(setq
  transdata2
   '(
     "ПЭН-7. "
     "ПЭН-8. "
     "ПЭН-9. "
     "ПСН-1. "
     "ПСН-2. "
     "ПСН-3. "
     "ПСН-4. "
     "ПСН-5. "
     "СН-6А. " 
     "СН-6Б. " 
     "Упорный подшипник №2. "
     "Генератор. "
     )
  )


;(rl|convert line trline)
(defun rl|convert (line trline)
  (antisep (subst (vl-string-subst (cadr trline) (car trline) (cadr line)) (cadr line) line) " ")
  )
       


(setq res
(mapcar
  '(lambda (line / trline trl2)	;(setq line (nth 67 data))

     (cond
       ((setq trline (vl-remove-if-not '(lambda (l) (wcmatch (cadr line) (strcat (car l) "*"))) transdata))
	(rl|convert line (car trline))
	)

       ((setq trline (vl-remove-if-not '(lambda (l) (wcmatch (cadr line) (strcat l "*"))) transdata2))
	(setq trline (car trline))
	(if (setq trline2 (vl-remove-if-not '(lambda (l) (wcmatch (vl-string-subst "" trline (cadr line))(strcat (car l) "*"))) transdata))
	  (rl|convert (list (car line) (strcat (vl-string-subst "" trline (cadr line)) ". " (vl-string-subst "" ". " trline) ))(car trline2))
	  (antisep (list (car line) (strcat (vl-string-subst "" trline (cadr line)) ". " (vl-string-subst "" ". " trline) )) " ")
	  )
	)
       
       (T 
	(antisep line " ")
	)
       )

     
     )
  data
  ))









(lst>excel (mapcar 'list res))