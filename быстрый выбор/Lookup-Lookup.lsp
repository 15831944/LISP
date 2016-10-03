; Выражаю глубочайшую признательность Полещуку Н.Н. и Кулик Анатолию (Kpblc) за внесенный вклад в данную программу.
; Сделано в ООО "Виртуальные строительные технологии" Лазебным А.В. (Supermax на DWG.RU и ABOC.RU)
; При создании программ были использованы фрагменты функций вышеупомянутых Специалистов с большой буквы.



(defun modes3 ( / ) (setq listlookup (nth (atoi (get_tile "b4")) n17)) (done_dialog)
); Указатель на выбранный Lookup. В переменной listlookup записано имя Lookup-a 

(defun read_listlookup ( / )
(setq lst (entget (TBLOBJNAME "block" (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel "Укажите нужный вам блок"))))) '("*")))
(setq aa (cdr (assoc 330 lst)))
(setq n17 nil)
(setq n15 (entget (car (setq lst_dict (mapcar 'cdr (vl-remove-if-not '(lambda(x) (= (car x) 360)) (entget (cdr (assoc 360 (entget aa))))))))))
(setq n16 (mapcar '(lambda(z) (setq n17 (cons (cdr (assoc 300 (entget (cdr z)))) n17))) 
(vl-remove-if-not '(lambda(y) (= (cdr (assoc 0 (entget (cdr y)))) "BLOCKLOOKUPACTION")) ;из всех словарей выбираем только "BLOCKLOOKUPACTION"
(vl-remove-if-not '(lambda(x) (= (car x) 360)) (entget (car lst_dict)))))) ;выбираем все словари со дин. свойствами
(setq n17 (reverse n17)) ;переворачиваем, а то он задом на перед собирается.

(vl-file-delete "0066Selection.dcl") ;Если есть такой файл, то его убить, поскольку он каждый раз создается с 0.
(setq dsl0066 (open "0066selection.dcl" "w")) ;Заполняем файл 0066selection.dcl необходимыми кнопками.
(write-line "np_lookup: dialog{label=\"Выбор нужного Lookup-a в блоке\";\n  :column{label=\" \";" dsl0066)
(write-line "  :text{label=\"Список существующих в блоке Lookup-ов\";alignment=centered;}" dsl0066)
(write-line "  :popup_list{label=\" \";list=\" \";value=\" \";key=\"b4\";width=35;alignment=centered;}" dsl0066)
(write-line "  :ok_button{label=\"Применить\";key=\"df3\";alignment=centered;fixed_width=true;}" dsl0066)
(write-line "  }}//" dsl0066)
(close dsl0066)

(if (/= (setq Sellookup (load_dialog "0066Selection.dcl")) -1)
(new_dialog "np_lookup" Sellookup "" (list 222 114)) (alert "Файл 0066Selection.dcl не найден"))
(action_tile "df3" "(modes3)") ; После срабатывания в переменной listlookup записано имя Lookup-a 
(mode_tile "accept" 1)
(start_list "b4")
(setq ddffdd (mapcar 'add_list n17))
(end_list)
(start_dialog)
) ;end "read_listlookup"

(read_listlookup)
(setq n18  (entget (cdr (car
(vl-remove-if-not '(lambda(y) (= (cdr (assoc 300 (entget (cdr y)))) listlookup)) ;из всех словарей выбираем только тот, чье имя совпадает с записанным в переменную listlookup
(vl-remove-if-not '(lambda(x) (= (car x) 360)) (entget (car lst_dict)))))))) ;выбираем все словари с дин. свойствами
(setq n19 (cdr (assoc 93 n18)))
(if (= n19 0) (prign (alert "Lookup не заполнен столбцами!") (ex_break_connect) (exit)))
(setq n21 nil)
(setq N_Y-end (cdr (assoc 92 n18)))
(setq N_X-end (+ 64 (cdr (assoc 93 n18))))
(while (/= (car (car n18)) 301) (setq n18 (cdr n18)))
(setq n18 (cdr n18))
(while (/= (car (car n18)) 303) (setq n21 (cons (car n18) n21)) (setq n18 (cdr n18)))
(setq n40 (reverse n21))


(read_listlookup)
(setq n18  (entget (cdr (car
(vl-remove-if-not '(lambda(y) (= (cdr (assoc 300 (entget (cdr y)))) listlookup)) ;из всех словарей выбираем только тот, чье имя совпадает с записанным в переменную listlookup
(vl-remove-if-not '(lambda(x) (= (car x) 360)) (entget (car lst_dict)))))))) ;выбираем все словари с дин. свойствами
(setq n19 (cdr (assoc 93 n18)))
(if (= n19 0) (prign (alert "Lookup не заполнен столбцами!") (ex_break_connect) (exit)))
(setq n21 nil)
(while (/= (car (car n18)) 301) (setq n21 (cons (car n18) n21)) (setq n18 (cdr n18)))
(setq n301 (car n18))
(setq n18 (cdr n18))
(while (= (car (car n18)) 302) (setq n18 (cdr n18))) ;очистить от 302 кодов начало оставшегося списка


(setq n23  nil)

(setq n24 (car n21))
(setq n25 (cdr (cdr n21)))
(setq n20 (reverse n25))
(setq n20 (append n20 (list (vl-list* 92 N_Y-end)) (list n24) (list n301)))
(setq n22 (append n20 n40 n18))
(setq n26 nil)
(while (/= (car (car n22)) 1071) (setq n26 (cons (car n22) n26)) (setq n22 (cdr n22))) ; Убиваем код 1071
(setq n22 (cdr n22))
(setq n22 (append (reverse n26) n22))
(setq n26 nil)
(while (/= (car (car n22)) 1010) (setq n26 (cons (car n22) n26)) (setq n22 (cdr n22))) ; Убиваем код 1010
(setq n22 (cdr n22))
(setq n22 (append (reverse n26) n22))
(entmod n22)
(entupd (cdr (car n22)))


