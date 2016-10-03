;;;;   сцепека 2-х файлов excel


(tbl|getdata 'tbl:src)

(db|getdata 'db:head 'db:data)
(setq missed '())

(setq newdata
(mapcar
  '(lambda (line / newline oldpoz df)	;(setq line (nth 13 (cdr db:data)))
     (setq oldpoz (db|gpar "old_POZ" line))
     (if (setq df (tbl|filter tbl:src (strcat "old_poz=" oldpoz)))
       (progn
	 (setq newline (db|spar line "old_сбрк" (tbl|gpar (car df) (cadr df) "#сбрк")))
	 (setq newline (db|spar newline "old_Ш" (tbl|gpar (car df) (cadr df) "#Ш")))
	 newline
	 )
       (progn
	 (setq missed (cons oldpoz missed))
	 line
	 )
       )
     )
  (cdr db:data)
  ))


(lst>excel (cons db:head newdata))




;;	не найдено из старых позиций из нового проекта - в старых сборках
;; то есть некоторые задвижки или не совпали или их небыло в старых сборках
;missed
;'("РК-10" "327" "326" "207" "106" "377" "376" "340" "336" "227" "226" "225" "224" "172" "162" "152" "142" "135" "132" "116а" "116" "101а" "1" "5" "4" "3" "2" "179а" "365" "367" "к377" "328" "338" "339" "394" "RM55S01" "RM55S02" )


;;  прогон наоборот - по старой сборке  -  посмотрим всё ли есть в новом проекте






(setq AbsentInNewBase nil)
(setq ManyInNewBase nil)
;db:head
(mapcar
  '(lambda (line / srcoldpoz res)	;(setq line (nth 13 tbl:src))
     (setq srcoldpoz (car line))	;(setq srcoldpoz "неизв.12")
     (setq res (db|filter (cdr db:data) (strcat "old_POZ=" srcoldpoz)))
     (cond
       ((= 1 (length res)) (princ))
       ((null res) (setq AbsentInNewBase (cons srcoldpoz AbsentInNewBase)))
       ((> (length res) 1) (setq ManyInNewBase (cons srcoldpoz ManyInNewBase)))
       )
     )
  (cdr tbl:src)
  )

;AbsentInNewBase
;("неизв.14" "неизв.13" "неизв.12" "неизв.11" "125" "неизв.10" "86П" "11А" "12" "347 ЩТЩУ" "310(309)" "308" "306" "89" "67" "262А" "254-255" "102А" "130" "неизв.09" "неизв.08" "133А" "131А" "200" "307" "270" "269" "140" "137" "неизв.07" "неизв.06" "неизв.05" "340рк" "336рк" "365(67П)" "367(89П)" "370" "348" "мигание.04" "137рк" "116рк" "116Арк" "142рк" "135рк" "132рк" "02" "01" "мигание.03" "130" "172рк" "162рк" "152рк" "106рк" "101Арк" "неизв.04" "неизв.03" "376рк" "02рк" "01рк" "неизв.02" "РН-2" "РН-1" "229" "227рк" "226рк" "225рк" "224рк" "229" "мигание.02" "250рк" "207рк" "неизв.01" "198" "197" "283(383)" "284" "282" "281" "мигание.01") 

