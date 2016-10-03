; 13_05_20
; APLISENS
; Ќѕ÷ ≈вроприбор
; APR-2000ALW


; генераци€ списка - части параграфа спецификации
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;; доработать выбор дл€ абсолютных давлений (вакуум) ; кѕа
(setq #apr|catranges
   '((1 0 1.6 "ћѕа")
     (2 0 250 "кѕа")
     (3 0 100 "кѕа")
     (4 0 25 "кѕа")
     (5 -10 10 "кѕа")
     (6 -0.5 7 "кѕа")
     (7 -2.5 2.5 "кѕа")))
(setq #apr|calcranges (mapcar '(lambda (x) (if (= "ћѕа" (nth 3 x)) (list (nth 0 x) (fix (* 1000 (nth 1 x))) (fix (* 1000 (nth 2 x))) "кѕа") x)) #apr|catranges))
   

;(aprdPTF|getrange xlsline)
(defun aprdPTF|getrange (xlsline / lst val scale tmp)
  (setq scale (atof* (xlsgpar "scale" xlsline)))
  (setq
    lst
     (vl-remove-if
       '(lambda (rang)  
	  (> (* 1.2 scale) (nth 2 rang))
	  )
       #apr|calcranges)
    )
  (setq
    tmp
     (mapcar
       '(lambda (x)
	  (nth 2 x)
	  )
       lst)
    )
  (append
    (assoc
      (car (nth (vl-position (apply 'min tmp) tmp) lst))
      #apr|catranges
      )
    
    (list 0 (fix scale))
    )
  );defun




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   13_05_06 - придумал монтажные части описывать отдельно
(if (null pointmnt|gen-zakaz-sosudur) (load (strcat #lisppath "DRAWING\\specification\\_9 монтаж\\pointmnt.LSP")))
(if (null gen-zakaz-diafragma) (load (strcat #lisppath "DRAWING\\specification\\_9 монтаж\\gen-zakaz-diafragma.lsp")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlslines (cdr pardata))
(defun gen-zakaz-dPTF-APR2000ALW  (xlslines / 
	xlsline pozitions range
	shtucer mesto kol ispolnenie
	;sreda
	kodventil nippel kreplenie
	paragraph
	)
  (setq
    paragraph
     (append
       (mapcar 'gen-1-dPTF-APR xlslines)
       (list
	 (list "")
	 ;(gen-zakaz-sosudur xlslines)
	 (pointmnt|gen-zakaz-sosudur xlslines)
	 (list "")
	 (gen-zakaz-diafragma xlslines)
	 (list "")
	 )
       );paragraph
    );setq
;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  paragraph
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlsline (cadr xlslines))
(defun gen-1-dPTF-APR
       (xlsline
	/
	range
	)
  (setq range (aprdPTF|getrange xlsline))
  (setq shtucer "—")
  (setq kol 1)
  (setq mesto (xlsgpar "place_sensor" xlsline))
  (setq ispolnenie "стандартное")
  (setq kodventil "VM-5/графит")
  (setq nippel "2")
  (setq kreplenie "C-2")
  
  (list
      ;(strcat "{\\W0.9;\\T0.9;" (xlsgpar "KKS" xlsline) "}" )
      (xlsgpar "KKS" xlsline)
      (strcat
	"ѕреобразователь измерительный разности давлений:" "\n"
	"основной диапазон " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) ", "
	"установленный диапазон " (rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " " (nth 3 range) "\n"
	"исполнение " ispolnenie ", выходной сигнал 4...20 мј, HART" "\n"
	;"класс точности 0,1 %,"
	"присоединение " shtucer ", в комплекте:" "\n"
	"вентильный блок, "
	"комплект ниппелей " nippel ", "
	"крепление " kreplenie "\n"
	mesto
	)
      (strcat "{\\W0.9;"
	"APR-2000ALW/"
	(if (= ispolnenie "стандартное") "" (strcat ispolnenie "/"))
	(rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) "/"
	(rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " " (nth 3 range) "/" "\n"
	"/" shtucer "/" kodventil "/" nippel "/" kreplenie "\n"
	"“” –Ѕ 390171150.001-2004"
	"}")
      ""
      (strcat "ќќќ \"≈вроприбор\"" "\n" "г. ¬итебск")
      "шт."
      (itoa kol)
      ""
      "јналог"
      )         
  );defun