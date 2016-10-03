; 13_10_31
; MARK
; ООО "ВЗОР" г.Нижний Новгород
; MARK-602
; генерация списка - части параграфа спецификации




;(defun gen-zakaz-MARK602 (paragdata / dblines montazhBP namerecord BPrecord GPrecord sensors DATrecord602 $catdat $catSvEvg)

;(setq paragdata (nth 0 datazipped))
;(setq paragdata (nth 1 datazipped))
;(setq paragdata (nth 2 datazipped))

(setq $catdat '((200  "ДП-003МП" "BP30.10.000")(2000 "ДП-025С" "BP30.02.000")(20000 "ДП-2С" "BP30.02.000-01")))
(setq $catSvEvg '(10 200 1000 5000))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun genstrparvalforname (dbline / pnom pmin pmax)
  ;(setq dbline (car dblines))
  (setq pnom (db|gpar "nom_val" dbline)
	pmin (db|gpar "min_val" dbline)
	pmax (db|gpar "max_val" dbline))
  (cond
    ((/= pnom "") pnom)
    ((and (/= pmin pmax "" )) (strcat pmin "-" pmax))
    ((/= "" pmax) (strcat "<" pmax))
    ((/= "" pmin) (strcat ">" pmin))
    (T (princ "\n НЕ ОПОЗНАН ПАРАМЕТР") (exit))
    );cond
  );defun
;(genstrparvalforname (cadr paragdata))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(MARK|gen-paragraph-name dblines)
(defun MARK|gen-paragraph-name (dblines)
  (strcat "{\\W0.9;\\T0.95;" (vl-string-right-trim "\n"  (apply 'strcat  (mapcar
	'(lambda (dbline / p)
	   (strcat
	     (db|gpar "meas_name" dbline) " "
	     (genstrparvalforname dbline) "\\~"
	     (db|gpar "units" dbline) "\n"
	     ))
	dblines))) "}" )
    );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (gendiapforSvEvg (cadr paragdata)))
(defun gendiapforSvEvg (dbline /  pmin pnom pmax)
  (setq pnom (db|gpar "nom_val" dbline)
	pmin (db|gpar "min_val" dbline)
	pmax (db|gpar "max_val" dbline))
  (get-closer-from-row (max (* (atof* pmin) 2.0) (* (atof* pnom) 1.6)(* (atof* pmax) 1.2)) $catSvEvg)
  );defun



;(genSENSOR dbline)
(defun genSENSOR (dbline /  MP pmin pnom pmax tmp curcat)
  (setq MP (and (vl-string-search "мп" (db|gpar "прототип" dbline)) (member (db|gpar "place_sensor" dbline) '("по месту" "По месту" "по-месту" "по_месту"))))
  (if MP (setq curcat $catdat) (setq curcat (cdr $catdat)))
  (setq pnom (atof* (db|gpar "nom_val" dbline)))
  (setq pmin (atof* (db|gpar "min_val" dbline)))
  (setq pmax (atof* (db|gpar "max_val" dbline)))
  (setq tmp (max (* pmin 2.0) (* pnom 1.6) (* pmax 1.2)))
  (setq tmp (car (vl-remove-if '(lambda (x) (> tmp (car x))) curcat)))
  (if (and MP (null (= (cadr tmp) "ДП-003МП")))
    (progn (princ "\n  ОШИБКА, нельзя поставить магистрально-погружной датчик на указанный диапазон измерений !!")
      (princ "\n") (princ (apply 'strcat (mapcar '(lambda (x) (strcat x " ")) dbline))) (princ)
      (exit)
      ))
  (list (if MP "МП" "ГП") tmp)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq montazhBP (vl-remove 'nil (mapcar '(lambda (x) (db|gpar "place_cpu" x)) (cdr paragdata))))
(if (and (apply '= montazhBP)
	 (null (member (car montazhBP) '("по месту" "По месту" "по-месту" "по_месту"))))
  (setq montazhBP "щит") (setq montazhBP "стена")
  )

;(setq paragdata (nth 0 datazipped))
;(setq paragdata (nth 1 datazipped))
;(setq paragdata (nth 2 datazipped))
;(setq dbline (nth 0 (cdr paragdata)))
(setq sensors (mapcar 'genSENSOR (cdr paragdata)))

;((T (20000 "ДП-2С")) (T (20000 "ДП-2С"))) 


(setq namerecord (append
     (list "")
     (cond
       ((vl-string-search "409" (db|gpar "прототип" (cadr paragdata)))
	(list "Анализатор растворенного кислорода с двумя каналами измерения\nв комплекте:" "МАРК-409" (if (= "стена" montazhBP)"/1") "\nТУ 4215-037-39232169-2004"))
       ((vl-string-search "602" (db|gpar "прототип" (cadr paragdata)))
	(list "Кондуктометр-солемер с двумя каналами измерения\nв комплекте:" "МАРК-602" (if (null (caar sensors))"МП") (if (= "стена" montazhBP)"/1") "\nТУ 4215-025-39232169-2006"))
       ((vl-string-search "902" (db|gpar "прототип" (cadr paragdata)))
	(list "pH-метр с двумя каналами измерения\nв комплекте:" "МАРК-902" (if (null (caar sensors))"МП") (if (= "стена" montazhBP)"/1") "\nТУ 4215-024-39232169-2006"))
       ((vl-string-search "1002" (db|gpar "прототип" (cadr paragdata)))
	(list "Анализатор натрия с двумя каналами измерения\nв комплекте:" "МАРК-1002" (if (= "стена" montazhBP)"/1") "\nТУ 4215-028-39232169-2010"))
       );cond
     (list "" "ООО \"ВЗОР\"\nг.Нижний Новгород" "компл." "1" "" "Аналог")
     )
  );setq





(setq
  BPrecord
   (list
     (car paragdata)
     (strcat
      "Блок преобразовательный " (cond ((= montazhBP "щит") "щитового") ((= montazhBP "стена") "настенного")) " исполнения/t/t/t 1\\~шт.\n"
      "диапазон измерения:\n"
      (strcat "Канал A: " (strcat "0..." (rtos* (gendiapforSvEvg (cadr paragdata))) " " (db|gpar "units" (cadr paragdata)) "\n"))
      (strcat "Канал B: " (if (caddr paragdata) (strcat "0..." (rtos* (gendiapforSvEvg (caddr paragdata))) " " (db|gpar "units" (caddr paragdata)) "\n") "резерв"))
      "Выходной сигнал: 4...20\\~мА. Питание\\~~220\\~В\n"
      (db|gpar "place_cpu" (cadr paragdata))
      )
     (strcat "БП\n"
      (cond
	((and (vl-string-search "409" (db|gpar "прототип" (cadr paragdata)))                     )
	 "BP37.01.000")
	((and (vl-string-search "602" (db|gpar "прототип" (cadr paragdata))) (= montazhBP "щит") )
	 "BP30.01.000")
	((and (vl-string-search "602" (db|gpar "прототип" (cadr paragdata))) (= montazhBP "стена"))
	 "BP42.01.000")
	((and (vl-string-search "902" (db|gpar "прототип" (cadr paragdata))) (= montazhBP "щит"))
	 "BP31.01.000")
	((and (vl-string-search "1002" (db|gpar "прототип" (cadr paragdata))) (= montazhBP "щит"))
	 "BP49.01.000")
	)
	     )
     )
  );setq 




(setq
  GPrecord
   (if (apply '= (append (mapcar 'car sensors) '("ГП")))
     (list
       (strcat "{\\W0.95;\\T0.9;" (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (dbline) (strcat (db|gpar "KKS" dbline) "QR01, "))(cdr paragdata))))"}")
       (strcat "Гидропанель \t\t\t\t\t\t\t\t\t" (rtos* (length (cdr paragdata))) "\\~шт.\n" (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (dbline) (strcat (db|gpar "place_sensor" dbline) ", "))(cdr paragdata)))))
       (cond
	 ((and (vl-string-search "409" (db|gpar "прототип" (cadr paragdata)))) "ГП-409\nBP37.04.100")
	 ((and (vl-string-search "602" (db|gpar "прототип" (cadr paragdata)))) "ГП-602\nBP30.08.000")
	 ((and (vl-string-search "902" (db|gpar "прототип" (cadr paragdata)))) "ГП-902\nBP31.04.000")
	 ((and (vl-string-search "1002" (db|gpar "прототип" (cadr paragdata)))) "ГП-1002\nBP49.02.000")
	 )
       )
     );if
  );setq



(defun genDATrecord602 ()
  (if (apply 'equal sensors)
    (list
      (list
	(strcat "{\\W0.95;\\T0.9;" (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (dbline) (strcat (db|gpar "KKS" dbline) "QP01, "))(cdr paragdata))))"}")
	(strcat "Датчик проводимости\t\t\t\t\t\t\t\t" (rtos* (length sensors)) "\\~шт.\n"
		(cond
		  ((apply '= (append (mapcar 'car sensors) '("ГП"))) "Гидропанель")
		  ((apply '= (append (mapcar 'car sensors) '("МП"))) "по месту")
		  (T (exit))
		  ))
	(strcat (cadr (cadar sensors)) "\n" (caddr (cadar sensors)))
	)
      )
    
    (mapcar
      '(lambda (dbline / sensor)    ;(setq dbline (cadr paragdata))
	 (setq sensor (genSENSOR dbline))
	 (list
	   (strcat "{\\W0.95;\\T0.9;" (db|gpar "KKS" dbline) "QP01""}")
	   (strcat "Датчик проводимости\t\t\t\t\t\t\t\t1\\~шт.\n"
		   (cond
		     ((= "ГП" (car sensor)) "Гидропанель")
		     ((= "МП" (car sensor)) "по месту")
		     (T (exit))
		     ))
	   (strcat (cadadr sensor) "\n" (caddr (cadr sensor)))
	   )
	 )
      (cdr paragdata)
      )
    );if
  );defun

(setq DATrecord602 (genDATrecord602))

















  
  









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     Р  У     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq #MARK602|diaplist
   '(
     2000
     20000
     )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun SVTU|gendataRU (xlslinesF)
  (mapcar
    ;(setq xlsline (car xlslinesF))
    '(lambda (xlsline / DN)
       (setq DN (rtos* (cadr (assoc (atof* (xlsgpar "Diam_tr" xlsline)) (mapcar 'reverse #SVTU|Dy-DN)))))
       (list
	 (strcat (xlsgpar "KKS" xlsline) "QP01")
	 DN
	 (xlsgpar "place_sensor" xlsline)
	 ))xlslinesF)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq lstRU (SVTU|gendataRU xlslinesF))
(defun gen-grafaRU (lstRU / out)
  (if (and (= 2 (length lstRU)) (= (cadar lstRU) (cadadr lstRU)))
    (setq out (list (list
	   (strcat "{\\W0.8;\\T0.85;" (car (car lstRU)) ",\n" (car (cadr lstRU)) "}")
	   (strcat "Участок расходомерный DN " (cadr (car lstRU)) "						2\\~шт." "\n" (caddr (car lstRU)))
	   (strcat "РУ-" (cadr (car lstRU)))
	   )))
    ;(setq x (car lstRU))
    (setq out (mapcar '(lambda (x)
        (list
	  (strcat "{\\W0.8;\\T0.85;" (car x) "}")
	  (strcat "Участок расходомерный DN " (cadr x) "							1\\~шт." "\n" (caddr x))
	  (strcat "РУ-" (cadr x)))
			 )lstRU))
    );if
  ;(append lst(list "" "" "" "" "" "" "" "" ""))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    ДАТЧИКИ    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(SVTU|getDFdiap xlsline)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun SVTU|getDFdiap (xlsline / fmin fmax lst actfmin actfmax)
  (setq lst (assoc
	 (cadr (assoc (atof* (xlsgpar "Diam_tr" xlsline)) (mapcar 'reverse #SVTU|Dy-DN)))
	 #SVTU|RUlist))
    (setq fmin (nth 2 lst))
    (setq fmax (nth 4 lst))
    (setq actfmin (xlsgpar "min_val" xlsline))
    (setq actfmax (xlsgpar "max_val" xlsline))
    (if (or (null actfmin) (= "" actfmin) (= "#" actfmin)) (setq actfmin fmin) (setq actfmin (atof* actfmin)))
    (if (or (null actfmax) (= "" actfmax) (= "#" actfmax)) (setq actfmax fmax) (setq actfmax (atof* actfmax)))
    (if (and (>= actfmin fmin) (<= actfmax fmax)) (strcat (rtos* fmin) "..." (rtos* fmax) "\\~" (xlsgpar "units" xlsline))
      (progn (alert (strcat "\nне SVTU выбор диапазона\n не проходит данный диапазон расходов по диаметру\n" "позиция" (xlsgpar "KKS" xlsline)))
	(exit)))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(SVTU|expandFdats xlslinesF)
(defun SVTU|expandFdats (xlslinesF / explines)
  (setq explines '())
  ;(setq xlsline (car xlslinesF))
  ;(SVTU|genqdat xlsline)
  ;get quantity of Flow sensors
  (defun SVTU|genqdat (xlsline) ;(setq dN 80)
    (cond ((diap (cadr (assoc (atof* (xlsgpar "Diam_tr" xlsline)) (mapcar 'reverse #SVTU|Dy-DN))) 32 150) 2)
	  ((diap (cadr (assoc (atof* (xlsgpar "Diam_tr" xlsline)) (mapcar 'reverse #SVTU|Dy-DN))) 200 1000) 4))
    );defun
  (mapcar
    '(lambda (xlsline / qdat str i)
       (setq qdat (SVTU|genqdat xlsline))
       (setq i 64 str "")
       (repeat qdat
	 (setq  explines (append explines(list
		  (subst (strcat (xlsgpar "KKS" xlsline) (chr (setq i (1+ i)))) (xlsgpar "KKS" xlsline) xlsline))))
	 );repeat
       )xlslinesF)
  explines
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(SVTU|gendataFT xlslinesF)
(defun SVTU|gendataFT (xlslinesF)
  (ziplist (mapcar '(lambda (xlsline) (list (SVTU|getDFdiap xlsline) xlsline))
      (SVTU|expandFdats xlslinesF)))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;(gen-grafsdat xlslinesF)
(defun gen-grafsdat (lstFT)
  (mapcar
    					;(setq xlslines (cadr (mapcar 'cdr lst)))
    '(lambda (xlslines)
       (list
	 (strcat "{\\W0.95;\\T0.9;" (spc|gsfxl "KKS" ",\n" xlslines)"}")
	 (strcat
	   "Датчик расхода ультразвуковой"
	   "						"
	   (rtos* (length xlslines))
	   "\\~шт.\n"
	   "с фторопластовым уплотнительным кольцом\n"
	   "Диапазон измерений: " (SVTU|getDFdiap (car xlslines)) "\n" "По месту"
	   )
	 "ДР"
	 )
       )
    (mapcar 'cdr lstFT))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;  (spc|gsfxl3
;;;    '("meas_name" "P" "T" "nom_val" "units")
;;;    (list " " (if (> 10 (atof* p)) "МПа, " "кПа, ")        )
;;;    xlslinesF)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq kompldata (nth 2 datazipped))
;(setq kompldata (nth 5 datazipped))
(defun gen-zakaz-SVTU
       (kompldata	;komlekt data
	/
	xlslines
	xlslinesF
	xlslinesT
	qkompl			;komplekt quantity
	pogresh			; погрешность - М1 или М2 - пока не буду писать табл. 3.1
	modif			; модификация прибора табл. 3.1

	strnames
	strSVTUzakaz
	
	strVychkks
	outlist
	)

  ;(setq pogresh "(М1)")
  (setq pogresh "")
  (setq modif "3")
  (setq strVychkks (car kompldata))
  (setq xlslines (cdr kompldata))
  (setq qkompl 1)
  ;;; эту переменную мы будем дополнять в процессе генерации данных
    
  (setq xlslinesF (vl-remove-if-not '(lambda (x) (= "FT" (xlsgpar "func" x))) xlslines))
  (setq xlslinesT (vl-remove-if-not '(lambda (x) (= "TTF" (xlsgpar "func" x))) xlslines))



  (setq strSVTUzakaz
     (strcat
       "{\\W0.9;"
       "СВТУ10М"
       pogresh
       "-"
       modif
       "-"
       (vl-string-right-trim "/" (apply 'strcat
        (mapcar '(lambda (x) (strcat "РУ" (vl-string-left-trim "РУ-" (cadr x)) "/"))(SVTU|gendataRU xlslinesF))))
       "-"
       (vl-string-right-trim "/" (apply 'strcat
	 (mapcar '(lambda (xlsline / DN gpars)
		    (setq DN (DN->Dy (atof* (xlsgpar "Diam_tr" (car xlslines)))))
		    (setq gpars (assoc DN #SVTU|gilzvars))
		    (strcat (rtos* (nth 5 gpars)) "в" (rtos* (nth 4 gpars)) "г" "/")
		    )
		 (mapcar 'cdr (SVTU|gendataTSP xlslinesT)))
					))
       "-\n"
       "[метражF]-[метражT]-М/АТ1-220\n"
       "ТУ РБ 191182855.001-2011"
       "}"
       ))






  
  
  (append
    (list
      (list "" (SVTU|gen-paragraph-name xlslinesF) "" "" "" "" "" "" "")
      (list "" "Тепловодосчетчик" strSVTUzakaz "" "ООО \"КИПпромэнерго\"\nг. Минск" "Компл." qkompl "" "Аналог")
      (list "" "В состав комплекта входит:" "" "" "" "" "" "" "")
      (list strVychkks (strcat "Вычислитель									1\\~шт.\nВыходной сигнал 4...20 мА, питание ~220 В, 50 Гц\n" (xlsgpar "place_cpu" (car xlslinesF))) (strcat "СВТУ-10М-" modif) "" "" "" "" "" "")
      (list "" "" "" "" "" "" "" "" "")
      )
    (gen-grafaRU (SVTU|gendataRU xlslinesF))
    (list (list "" "" "" "" "" "" "" "" ""))
    (gen-grafsdat (SVTU|gendataFT xlslinesF))
    (list (list "" "" "" "" "" "" "" "" ""))
    (gen-grafsTSP (SVTU|gendataTSP xlslinesT))
    (list (list "" "" "" "" "" "" "" "" ""))
    (gen-grafaothers)
    (list
      (list "" "" "" "" "" "" "" "" "")
      (list "" "" "" "" "" "" "" "" "")
      )
    )

;;;  (setq
;;;    outlist
;;;     (append
;;;    (list
;;;      (list "" "В состав комплекта входит:" "" "" "" "" "" "" "")
;;;      (list strVychkks (strcat "Вычислитель									1\\~шт.\nВыходной сигнал 4...20 мА, питание ~220 В, 50 Гц\n" (xlsgpar "place_cpu" (car xlslinesF))) (strcat "СВТУ-10М-" modif) "" "" "" "" "" "")
;;;      (list "" "" "" "" "" "" "" "" "")
;;;      )
;;;    (gen-grafaRU (SVTU|gendataRU xlslinesF))
;;;    (list (list "" "" "" "" "" "" "" "" ""))
;;;    (gen-grafsdat (SVTU|gendataFT xlslinesF))
;;;    (list (list "" "" "" "" "" "" "" "" ""))
;;;    (gen-grafsTSP (SVTU|gendataTSP xlslinesT))
;;;    (list (list "" "" "" "" "" "" "" "" ""))
;;;    (gen-grafaothers)
;;;    (list
;;;      (list "" "" "" "" "" "" "" "" "")
;;;      (list "" "" "" "" "" "" "" "" "")
;;;      )
;;;    )
;;;     )
;;;  (append
;;;    (list
;;;      (list "" (SVTU|gen-paragraph-name xlslinesF) "" "" "" "" "" "" "")
;;;      (list "" "Тепловодосчетчик" strSVTUzakaz "" "ООО \"КИПпромэнерго\"\nг. Минск" "Компл." qkompl "" "Аналог")
;;;      )
;;;    outlist
;;;    )
  );defun


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  ;)