;;; 13_10_16
;;; 14_03_11
;;; 14_03_25
;;; 15_07_20
;;;      -=AI=-=DI/DO=-=TSP=-
;;; подключения к шкафам контроллеров
;;; db - database
;;; пример структуры данных для отрисовки подключений
;;;   шкаф    клеммник  кабель     сигналы   .....


;;;      ("ШВО1Б"
;;;		("2XT11"
;;;		  	("UMA-4128"
;;;			  	("LBD70CP001" nil "Давление пара на эжектор основной" "420AI" "1" "2" "КВВГЭнг" "4,0000" "1,5" "1АТМ1" "UMA-4128" "Стенд датчиков UMA GZ021 " "ШВО1Б" "2XT11" "15" "16")
;;;				))
;;;		("2XT12"
;;;		  	("UMA-4129"
;;;			  	("LCA21CP001" nil "Давление на напоре конденсатного насоса LCA21AP001" "420AI" "1" "2" "КВВГЭнг" "19,0000" "1,5" "1АТМ1" "UMA-4129" "Стенд датчиков UMA GZ022 " "ШВО1Б" "2XT12" "1" "2")
;;;				("LCA22CP001" nil "Давление на напоре конденсатного насоса LCA22AP001" "420AI" "1" "2" "КВВГЭнг" "19,0000" "1,5" "1АТМ1" "UMA-4129" "Стенд датчиков UMA GZ022 " "ШВО1Б" "2XT12" "3" "4")
;;;				("LCA23CP001" nil "Давление в коллекторе конденсата подогревателей сетевой воды" "420AI" "1" "2" "КВВГЭнг" "19,0000" "1,5" "1АТМ1" "UMA-4129" "Стенд датчиков UMA GZ022 " "ШВО1Б" "2XT12" "5" "6")
;;;				("NDA21CP001" nil "Давление сетевой воды перед сетевым подогревателем NDD21AC001" "420AI" "1" "2" "КВВГЭнг" "19,0000" "1,5" "1АТМ1" "UMA-4129" "Стенд датчиков UMA GZ022 " "ШВО1Б" "2XT12" "7" "8")
;;;				("NDA21CP002" nil "Давление сетевой воды за сетевым подогревателем NDD21AC001" "420AI" "1" "2" "КВВГЭнг" "19,0000" "1,5" "1АТМ1" "UMA-4129" "Стенд датчиков UMA GZ022 " "ШВО1Б" "2XT12" "9" "10")
;;;				("NDA22CP001" nil "Давление сетевой воды перед сетевым подогревателем NDD22AC001" "420AI" "1" "2" "КВВГЭнг" "19,0000" "1,5" "1АТМ1" "UMA-4129" "Стенд датчиков UMA GZ022 " "ШВО1Б" "2XT12" "11" "12")
;;;				("NDA22CP002" nil "Давление сетевой воды за сетевым подогревателем NDD22AC001" "420AI" "1" "2" "КВВГЭнг" "19,0000" "1,5" "1АТМ1" "UMA-4129" "Стенд датчиков UMA GZ022 " "ШВО1Б" "2XT12" "13" "14")
;;;				)
;;;			("UMA-4130"
;;;			  	("NDA11CP001" nil "Давление на напоре сетевого насоса NDA11AP001" "420AI" "1" "2" "КВВГЭнг" "4,0000" "1,5" "1АТМ1" "UMA-4130" "Стенд датчиков UMA GZ023 " "ШВО1Б" "2XT12" "15" "16")
;;;				))
;;;		("2XT13"
;;;		  	("UMA-4131"
;;;			  	("NDA12CP001" nil "Давление на напоре сетевого насоса NDA12AP001" "420AI" "1" "2" "КВВГЭнг" "4,0000" "1,5" "1АТМ1" "UMA-4131" "Стенд датчиков UMA GZ024 " "ШВО1Б" "2XT13" "1" "2")
;;;				)
;;;			("UMA-4132"
;;;			  	("NDA50CP001" nil "Давление прямой сетевой воды на ЦТП за РК" "420AI" "1" "2" "КВВГЭнг" "7,0000" "1,5" "1АТМ1" "UMA-4132" "Стенд датчиков UMA GZ019 " "ШВО1Б" "2XT13" "3" "4")
;;;				("NDA60CP001" nil "Давление прямой сетевой воды на на выходе из мини-ТЭЦ" "420AI" "1" "2" "КВВГЭнг" "7,0000" "1,5" "1АТМ1" "UMA-4132" "Стенд датчиков UMA GZ019 " "ШВО1Б" "2XT13" "5" "6")
;;;				("PAB10CP001" nil "Давление оборотной охлаждающей воды на циркнасосную" "420AI" "1" "2" "КВВГЭнг" "7,0000" "1,5" "1АТМ1" "UMA-4132" "Стенд датчиков UMA GZ019 " "ШВО1Б" "2XT13" "7" "8")
;;;				)
;;;			("UMA-4133"
;;;			  	("NDB20CP001" nil "Давление в коллекторе обратной сетевой воды" "420AI" "1" "2" "КВВГЭнг" "4,0000" "1,5" "1АТМ1" "UMA-4133" "Стенд датчиков UMA GZ019 " "ШВО1Б" "2XT13" "9" "10")
;;;				)
;;;			("UMA-4134"
;;;			  	("NDB30CP001" nil "Давление сетевой воды на всасе сетевых насосов" "420AI" "1" "2" "КВВГЭнг" "4,0000" "1,5" "1АТМ1" "UMA-4134" "Стенд датчиков UMA GZ023 " "ШВО1Б" "2XT13" "11" "12"))
;;;			("UMA-4221"
;;;			  	("LAC11CP002" nil "Давление на напоре питательного насоса LAC11AP001" "420AI" "LAC11AP001(I+)" "24-" "КВВГЭнг" "5" "1,5" "1АТМ1" "UMA-4221" "Щит расходомеров, X1" "ШВО1Б" "2XT13" "13" "14")
;;;				("LAC12CP002" nil "Давление на напоре питательного насоса LAC12AP001" "420AI" "LAC12AP001(I+)" nil "КВВГЭнг" "5" "1,5" "1АТМ1" "UMA-4221" "Щит расходомеров, X1" "ШВО1Б" "2XT13" "15" "16")
;;;				)))



;==================================================================================================================================
;==================================================================================================================================
;;  договоренности по типам сигналов
;;; 420AO - запитанный в контроллере аналоговый сигнал управления
;;; 420AI+ - активный аналоговый входной сигнал 4…20 мА, запитанный в нашей схеме 24 В - обычно положение регуляторов или от запитанных приборов например расходомеров
;;; 420AI - пассивный аналоговый входной сигнал 4…20 мА, который запитывает контроллер а не мы
;;; ТП    - сигналы от термопар
;;; ТСП - аналоговый входной сигнал термометра сопротивления по 3-х проводной схеме
;;; ТСП4 - аналоговый входной сигнал термометра сопротивления по 4-х проводной схеме
;;; 220DO - сигнал управления - сухой контакт для цепи 220 В
;;; 24DO - сигнал управления - сухой контакт для цепи 24 В
;;;   DO, DONO, DONC - сухой контакт в контроллере, участвующий в нашей схеме
;;; 220DI - дискретный входной сигнал запитанный напряжением 220 В
;;; 24DI - дискретный входной сигнал запитанный напряжением 24 В
;;;   DINO, DINC
;;;  * (если реле в контроллере держит 220 то можно и в цепь 220 на схеме), в лунинце у симатеков - держало
;;;     то есть не важно какой DO 220 или 24 - важно только NC или NO
;==================================================================================================================================
;==================================================================================================================================




;==================================================================================================================================
;==================================================================================================================================
;	$ - "tranclate"
;	если начинается с "-" - то добавлять "KKS"
;;	договоренности по типам полевых мест (сокращений)
;;	#
;      #Сборка
;      #Стенд
;      #БЭЗ
;      #КСпривода
;      #Датчик
;      #КС
;==================================================================================================================================
;==================================================================================================================================





;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
;(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))



(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))
(load (strcat #lisppath "DataBase\\dblib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
(load (strcat #lisppath "Strings\\kd-sortstrings.LSP"))


(setq BN:TERMINAL "cnct_PLC_CLAMPHEAD")
(setq BN:SIG220DIO "cnct_PLC_2")
(setq BN:SIG420 "cnct_PLC_4")






;;;(defun db|cabinetsort (lst)
;;;  (defun clampformat (str / r c) (setq c (sepstr str (cond ((wcmatch str "*XT*") "XT") ((wcmatch str "*K*") "K"))) r (atoi (car c)) c (atoi (cadr c))) (+ (* 1000 r) c))
;;;  (if (null db:head) (exit))
;;;   (vl-sort
;;;     lst
;;;     '(lambda (a b / clampA clampB)
;;;	(setq clampA (db|gpar "TERMINAL" a) clampB (db|gpar "TERMINAL" b))
;;;	(and
;;;	  (<= (atoi (vl-string-translate "АБ" "12" (cadr (sepstr (db|gpar "CABINET" a) ".")))) (atoi (vl-string-translate "АБ" "12" (cadr (sepstr (db|gpar "CABINET" b) ".")))))
;;;	  (<= (clampformat (db|gpar "TERMINAL" a)) (clampformat (db|gpar "TERMINAL" b)))
;;;	  (< (atoi (vl-string-subst "" "KL" (db|gpar "relay" a)))
;;;	     (atoi (vl-string-subst "" "KL" (db|gpar "relay" b))))
;;;	  )))
;;;  );defun







(setq #smezhniki nil)
;(setq #smezhniki "belov")

;;;(defun db|mapzip (lst parstr / head tail)
;;;  ;(setq lst db:data)
;;;  (if (atom (cadadr lst))
;;;    (append (list (car lst)) (ziplist (mapcar '(lambda (xlsline) (list (db|gpar parstr xlsline) xlsline ))(cdr lst))))
;;;    (append (list (car lst)) (mapcar '(lambda (x) (db|mapzip x parstr)) (cdr lst)))
;;;    )
;;;  )



;;;  в excel сортируем : sign_type - N кабеля - KKS - mark1 - mark2
;;;  это если подключения не давали



(db|getdata 'db:head 'db:data)(princ)
	

(length (cdr db:data))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;если надо
(setq db:head (car (excel>lst)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq db:data (cons "table" (db|formatdata (excel>lst))))
;(setq lst (excel>lst))
;(lst>excel db:data)    тест на соответствие пустых ячеек





;making tree
;(setq tree:cabinets (db|mapzip db:data "CABINET"))
;(setq tree:clamps (db|mapzip tree:cabinets "TERMINAL"))
;(setq tree:cables (db|mapzip tree:clamps "CBL_ID"))
;;;  для аналоговых - достаточно, но для дискретных задвижечный - нужен еще один уровень
;; и вотеще что - его можно сделать по месту...
;;; хм ... так же как и разбиение на кабели в конкретном клеммнике
;(setq tree:valves (db|mapzip tree:cables "KKS"))




;(setq lst3 (db|mapzip lst2 "N кабеля"))
;(setq lst4 (db|mapzip lst3 "KKS"))
;(gr|addall lst4)




;;; запись на диск
;(setq file-path "D:\\123.txt" hand (open file-path "w")) (prin1 lst1 hand) (close hand)
;;; проверим - есть ли в одном кабеле разные сигналы
;(apply 'and (mapcar '(lambda (cab / tmp) (= (mapcar '(lambda (sig) (db|gpar "sign_type" sig))(cdr cab)))) (cdr lst1)))
;T - нет
; то есть мы смело можем сортировать перечень сигналов пл типу игнала


(defun go ()
  (setq startpt (getpoint) pt startpt)
  (setq #cables-to-consolidate '())
  (gr|addall db:data)
  #cables-to-consolidate
;;;  (alert (strcat
;;;	   "\n BJH60-5057 жилу объединить в контроллере"
;;;	   "\n 2UHA-4033 объединить AO AI"
;;;	   ))
  );defun


;(gr|addcabinet (nth 1 lst4))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   M A I N     F U N C T I O N S   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(gr|addall lst4)
(defun gr|addall (db)
  ;(setq db db:data)
  (mapcar
    '(lambda (x)
       ;(setq db (car (cdr (db|mapzip db "CABINET"))))
       (gr|addcabinet x)
       (setq startpt (mapcar '+ startpt '(302 0 0)))
       (setq pt startpt)
       )
    (cdr (db|mapzip db "CABINET"))
    )
  (alert
    (strcat
    "\n проверить символ КАППА в названии хим сигналов"
    "\n посмотреть кабели ГЕРДА и др. кот. пишутся не так как КВВГЭ - дин.свойство экранированности"
    "\n проверить нестандартные марки и перемычки"
    "\n многостроковые длинные аттрибуты!!  наезды"
    "\n проверять точность чисел"
    "\n заменить названия модулей в автокаде на нормальные"
    "\n могут пересекатся перемычки которые проходят в несколько ярусов"
    )
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq db (nth 1 lst4))
;(setq db (nth 1 lst4))
;(setq db (nth 2 lst4))
(defun gr|addcabinet (db / bobj stype)	;(setq db (nth 2 (db|mapzip db:data "CABINET")))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) (strcat #lisppath "!blocking\\controller\\controller_cabinet.dwg") 1 1 1 0))
  (vla-put-TextString (getbatt bobj "CABINET") (car db))
  (setq pt (mapcar '+ pt '(0 -10 0)))
  (mapcar 'gr|add-clamp (cdr (db|mapzip db "TERMINAL")))
  );defun
;(gr|addcabinet db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;модуль
;(setq db (nth 1 (nth 1 lst4)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(tr|extract tree:cables)
(defun tr|extract (db / tail)
  (setq tail db)
  (if (null (apply 'and (mapcar 'atom db)))
    (progn
      (while (atom (car (setq tail (cdr tail)))))
      (tr|extract (car tail))
      )
    db
    )
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;модуль


;(setq db (assoc "1K5" (cdr (db|mapzip (assoc "ШК20.2А" (cdr (db|mapzip db:data "CABINET"))) "TERMINAL"))))
;(setq pt (getpoint)) (gr|add-clamp db)

;;;(setq dbx (db|mapzip db:data "CABINET"))
;;;(setq str "ШК20.2Б")
;;;
;;;(defun db|item (dbx str)
;;;  (assoc str (cdr dbx))
;;;  )




(defun gr|add-clamp (db / bobj stype)
  ;(setq db (nth 1 (db|mapzip (nth 2 (db|mapzip db:data "CABINET")) "TERMINAL")))
  ;(setq db (assoc "1K8" (cdr (db|mapzip (assoc "ШК20.2Б" (cdr (db|mapzip db:data "CABINET"))) "TERMINAL"))))

  (setq pt (mapcar '+ pt '(0 -10 0)))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 10 0))) BN:TERMINAL 1 1 1 0))
  (vla-put-TextString (getbatt bobj "TERMINAL") (car db))
  (mapcar 'gr|add-cable (cdr (db|zipsorted (cons (car db) (vl-sort (cdr db) '(lambda (a b) (< (atoi (db|gpar "PIN1" a)) (atoi (db|gpar "PIN1" b)))))) "CBL_ID")))
  (setq pt (mapcar '+ pt '(0 -10 0)))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





; конкретный кабель на конкретном клеммнике (может быть часть кабеля, если он на разных клеммниках)
;(setq db (assoc "BJH40-2091" (cdr (db|mapzip (assoc "1K9" (cdr (db|mapzip (assoc "ШК20.3Б" (cdr (db|mapzip db:data "CABINET"))) "TERMINAL"))) "CBL_ID"))))
; весь кабель по базе
;;;(setq db (assoc "BJH40-2091" (cdr (db|mapzip db:data "CBL_ID"))))
;;;(setq #cables-to-consolidate nil)
;;;(setq pt (getpoint)) (gr|add-cable db)


;;;(setq db (assoc "11BXB11 2004" (cdr (db|mapzip db:data "CBL_ID"))))
;;;(setq db (assoc "UM-503" (cdr (db|mapzip db:data "CBL_ID"))))

(defun gr|add-cable (db / bobj lobj ctype tmp sect marksincable modmarks connectedcores i stype thiscable iscableelsewere bridges cabstartX cablevel bridgestep)
  (setq bridgestep 1.5)
  (setq cabstartX 100)		; длина блока кабель

  ; если кабель встречается в базе еще где-нить, кроме этого клеммника
  ; помечаем желтый флаг, и добавляем в список для контроля, если еще не в нем
  (setq thiscable (assoc (car db) (cdr (db|mapzip db:data "CBL_ID"))))
  (if (/= (length thiscable) (length db)) (progn (setq iscableelsewere T) (if (null (member (car db) #cables-to-consolidate)) (setq #cables-to-consolidate (cons (car db) #cables-to-consolidate)))))

  (setq stype (list
     (vl-string-trim " " (db|gpar "PIN1" (tr|extract db)))
     (vl-string-trim " " (db|gpar "PIN2" (tr|extract db)))
     (vl-string-trim " " (db|gpar "PIN3" (tr|extract db)))
     (vl-string-trim " " (db|gpar "PIN4" (tr|extract db)))
     ))
  (setq stype (apply 'strcat (mapcar '(lambda (x) (cond ((= "" x) "0") (T "1"))) stype)))

    

  ; если кабель не пустой, отрисовываем соединения и вставляем блок
  (if (/= "" (car db))
    (progn

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; рисуем подключение кабеля
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ; то что на модуле, полностью все марки в пределах данного кабеля
      
   (setq modmarks (apply 'append (mapcar '(lambda (s)
	(cond
	  ;((= stype "1100") (list (db|gpar "MARK1" (tr|extract db)) (db|gpar "MARK2" (tr|extract db))))
	  ;((= stype "1110") (list (db|gpar "MARK1" (tr|extract db)) (db|gpar "MARK2" (tr|extract db)) (db|gpar "MARK3" (tr|extract db))))
	  ;((= stype "1111") (list (db|gpar "MARK1" (tr|extract db)) (db|gpar "MARK2" (tr|extract db)) (db|gpar "MARK3" (tr|extract db)) (db|gpar "MARK4" (tr|extract db))))

	  ((= stype "1100") (list (db|genmarkforcad "MARK1" s) (db|genmarkforcad "MARK2" s)))
	  ((= stype "1111") (list (db|genmarkforcad "MARK1" s) (db|genmarkforcad "MARK2" s) (db|genmarkforcad "MARK3" s) (db|genmarkforcad "MARK4" s)))
	  
	  (T (list (db|genmarkforcad "MARK1" s) (db|genmarkforcad "MARK2" s)))
	   )
	) (cdr db))))
  
  (setq marksincable (origlist modmarks))	;;  то что в жилах кабеля, без повторений
  ;(setq i 0) (mapcar '(lambda (x) (vla-put-TextString (getbatt bobj (strcat "MARK" (itoa (setq i (1+ i))))) x)) marksincable)
  (setq connectedcores '())
  
  (setq cstpt (mapcar '+ pt '(0 -2.5 0)))

  ; количество разных марок, встречающихся на клеммнике в пределах одного кабеля, более 1 раза
  ;(setq bridges (deoriglist modmarks))
   (setq bridges (vl-remove "" (deoriglist modmarks)))
  (if bridges
    (setq cablevel (* (1+ (length bridges)) bridgestep))
    (setq cablevel (* 2 bridgestep))
    )

  (mapcar
    '(lambda (x)
       ;(setq x (nth 1 modmarks))
       (cond
	 ((= "" x) (princ))
	 ((member x marksincable)
	  (vla-addline #modspace (vlax-3D-point cstpt) (vlax-3D-point (mapcar '+ cstpt (list (- cablevel) 0 0))))
	  (setq marksincable (vl-remove x marksincable))
	  )
	 ;перемычка
	 (T
	  (vla-addline #modspace
	    (vlax-3D-point cstpt)
	    (vlax-3D-point (mapcar '+ cstpt (list (- (* (1+ (vl-position x bridges)) bridgestep)) 1 0)))
	    )
	  (vla-addline #modspace
	    (vlax-3D-point (mapcar '+ cstpt (list (- (* (1+ (vl-position x bridges)) bridgestep)) 1 0)))
	    (vlax-3D-point (mapcar '+ cstpt (list (- (* (1+ (vl-position x bridges)) bridgestep)) (1- (* (1+ (vl-position x connectedcores)) 5)) 0)))
	    )
	  (vla-addline #modspace
	    (vlax-3D-point (mapcar '+ cstpt (list (- (* (1+ (vl-position x bridges)) bridgestep)) (1- (* (1+ (vl-position x connectedcores)) 5)) 0)))
	    (vlax-3D-point (mapcar '+ cstpt (list 0 (* (1+ (vl-position x connectedcores)) 5) 0)))
	    )
	  )
	 )
       (setq connectedcores (cons x connectedcores))
       (setq cstpt (mapcar '+ cstpt '(0 -5 0)))
       )
    modmarks
    )

  ;планка
   (if (vl-remove "" (origlist modmarks))
     (setq lobj(vla-addline #modspace
       (vlax-3D-point (mapcar '+ pt (list (- cablevel) -2.5 0)))
       (vlax-3D-point (mapcar '+ pt (list
				   (- cablevel)
				   (- (+ 2.5 (* 5 (vl-position (last
								 ;(origlist modmarks)
								 (vl-remove "" (origlist modmarks))
								 ) modmarks))))
				   0)))
    ))
     )
   (vla-put-layer lobj "planks")
  ;блок
  (setq	bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt (list (- cabstartX) -5 0)))
	       ;(strcat #lisppath "!blocking\\cablelist\\cbl_cnct.dwg")
	       "cbl_cnct"
	       1 1 1 0))
   (vla-put-layer bobj "cbls")
  (vla-put-Value (getbdyn bobj "cabDist") (vlax-make-variant (- (- cabstartX 30) cablevel) 5))
  (vla-put-Value (getbdyn bobj "shldDist") (vlax-make-variant (- (- cabstartX 30) 20 ) 5))
  (vla-put-TextString (getbatt bobj "CBL_ID") (car db)) 
  (vla-put-TextString (getbatt bobj "CBL_TYPE") (setq ctype (db|gpar "CBL_TYPE" (tr|extract db))))
  (vla-put-TextString (getbatt bobj "CBL_CORES") (db|gpar "CBL_CORES" (tr|extract db)))
  (if (null (wcmatch (setq sect (db|gpar "CBL_SECTION" (tr|extract db))) "*[`.`,]*")) (setq sect (strcat sect ",0")))
  (vla-put-TextString (getbatt bobj "CBL_SECTION") sect)
  (if iscableelsewere (vlax-put-property bobj "color" 2))
  ; заполняем аттрибуты
  (vla-put-TextString (getbatt bobj "ADDRESS")
    (cond
      ; если составное и подразумевает склеивание других параметров
      ((= (db|gpar "FLD_TYPE" (tr|extract db)) "[MDC]")	(strcat "Шкаф сборки задвижек " (db|gpar "FLD_ID" (tr|extract db))))
      ;((= (db|gpar "FLD_TYPE" (tr|extract db)) "[MJB]")	(strcat "УВРУ электропривода " (db|gpar "LOOP_ID" (tr|extract db)) "-XT1"))
      ((= (db|gpar "FLD_TYPE" (tr|extract db)) "[MJB]")	(strcat "УВРУ электропривода " (db|gpar "FLD_ID" (tr|extract db))))
      ((= (db|gpar "FLD_TYPE" (tr|extract db)) "[ИПК]")	(strcat "Панель реле ИПК " (db|gpar "FLD_ID" (tr|extract db))))


      
      ;((= (db|gpar "FLD_TYPE" (tr|extract db)) "#Датчик")	(strcat "Датчик поз. " (db|gpar "LOOP_ID" (tr|extract db))))
      ;((= (db|gpar "FLD_TYPE" (tr|extract db)) "#Стенд")	(strcat "Стенд датчиков " (db|gpar "FLD_ID" (tr|extract db))))
      ;((= (db|gpar "FLD_TYPE" (tr|extract db)) "#КС")	(strcat "Коробка соединительная " (db|gpar "FLD_ID" (tr|extract db))))
      ; если уже заполненная графа
      ;(T (db|gpar "fld_name" (tr|extract db)))
      )
    )
  (vla-put-TextString (getbatt bobj "CABINET") (strcat "Шкаф контроллеров " (db|gpar "CABINET" (tr|extract db)) ", " (db|gpar "TERMINAL" (tr|extract db))))
  (vla-put-Textstring (getbatt bobj "SIGN") (strcat "%<\\AcObjProp Object(%<\\_ObjId "
						    (itoa (vla-get-ObjectID (getbatt bobj "CBL_TYPE")))
						    ">%).TextString>%" "  " "%<\\AcObjProp Object(%<\\_ObjId "
						    (itoa (vla-get-ObjectID (getbatt bobj "CBL_CORES")))
						    ">%).TextString>%" "x" "%<\\AcObjProp Object(%<\\_ObjId "
						    (itoa (vla-get-ObjectID (getbatt bobj "CBL_SECTION"))) ">%).TextString>%"))
  (if
    (or
      (member ctype '("КВВГЭнг" "КВВГЭ" "КВВГЭнг-LS" "КВВГЭнг(А)-LS" "КМТВЭВнг(А)-LS" "МКЭШВнг(А)-LS"))
      (wcmatch sect "*Э*")
      )
      (vla-put-Value (getbdyn bobj "Shielding") "Экран")
    (vla-put-Value (getbdyn bobj "Shielding") "БезЭкрана"))
  ;;;  заполняем аттрибуты марок кабеля
  (setq i 0) (mapcar '(lambda (x) (vla-put-TextString (getbatt bobj (strcat "MARK" (itoa (setq i (1+ i))))) x)) (origlist modmarks))
  )
    ) ; if is cable (если есть подключения)



  (cond
    ((= stype "1100") (mapcar 'gr|add-signal2 (cdr db)))
    ((= stype "1111") (mapcar 'gr|add-signal4 (cdr db)))
    (T (princ (strcat "\n gr|add-cable: неизвестный тип сигнала - \"" stype "\"")))
    )
  
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;

;(setq db '("ШВО.5А" "K7" "KL1" "11" "14" "220DO" "A12" "A11" "BJH50-2502" "2LAB51AA001" "Открыть" "Клапан запорный № 1 на основной  линии узла питания котла" "КВВГнг" "14" "1,5" "#Сборка" "BJH50, Ш2" ""))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq db (cadr db))
(defun gr|add-signal2 (db / bobj str adr)

  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) BN:SIG220DIO 1 1 1 0))
  (vla-put-TextString (getbatt bobj "LOOP_ID") (db|gpar "LOOP_ID" db))
  (vla-put-TextString (getbatt bobj "NAME") (db|gpar "NAME" db))
  (vla-put-TextString (getbatt bobj "EVENT") (db|gpar "EVENT" db))
  (vla-put-TextString (getbatt bobj "MARK1") (db|gpar "MARK1" db))
  (vla-put-TextString (getbatt bobj "MARK2") (db|gpar "MARK2" db))
  (vla-put-TextString (getbatt bobj "PIN1") (db|gpar "PIN1" db))
  (vla-put-TextString (getbatt bobj "PIN2") (db|gpar "PIN2" db))
  (setq pt (mapcar '+ pt '(0 -10 0)))
  );defun
;(gr|add-signalDI db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun gr|add-signal4 (db / bobj str adr)

  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) BN:SIG420 1 1 1 0))
  (vla-put-TextString (getbatt bobj "LOOP_ID") (db|gpar "LOOP_ID" db))
  (vla-put-TextString (getbatt bobj "NAME") (db|gpar "NAME" db))
  ;(vla-put-TextString (getbatt bobj "EVENT") (db|gpar "EVENT" db))
  (vla-put-TextString (getbatt bobj "MARK1") (db|gpar "MARK1" db))
  (vla-put-TextString (getbatt bobj "MARK2") (db|gpar "MARK2" db))
  (vla-put-TextString (getbatt bobj "MARK3") (db|gpar "MARK3" db))
  (vla-put-TextString (getbatt bobj "MARK4") (db|gpar "MARK4" db))
  (vla-put-TextString (getbatt bobj "PIN1") (db|gpar "PIN1" db))
  (vla-put-TextString (getbatt bobj "PIN2") (db|gpar "PIN2" db))
  (vla-put-TextString (getbatt bobj "PIN3") (db|gpar "PIN3" db))
  (vla-put-TextString (getbatt bobj "PIN4") (db|gpar "PIN4" db))
  (setq pt (mapcar '+ pt '(0 -20 0)))
  )



;;;(defun db|genmarkforcad (mark db / str)
;;;    ;(setq markparamname "MARK1")
;;;    ;(setq mark (db|gpar markparamname (cadr db)))
;;;    ;(setq mark "76")
;;;  (db|gpar mark db)
;;;  )


(defun db|genmarkforcad (mark db / str)
    ;(setq markparamname "MARK1")
    ;(setq mark (db|gpar markparamname db))
    ;(setq mark "76")
  (setq str (db|gpar mark db))
  (setq str
	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (cond
      ((wcmatch str "-*")
       (strcat (db|gpar "LOOP_KKSID" db) str))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ((and
;	 (member str '("1" "2" "3" "4"       "16" "18"))
;	 (db|gpar "KKS" db)
;	 )
;       (strcat (db|gpar "KKS" db) "-" str))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      ( (and
;	  (member str '("-1" "-2" "-3" "-4"  "-16" "-18"))
;	  (db|gpar "KKS" db)
;	  )
 ;      (strcat (db|gpar "KKS" db) str))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ((and
	 (member str '("16-" "16+" "18-" "18+"))
	 (db|gpar "LOOP_KKSID" db)
	 )
       (strcat (db|gpar "LOOP_KKSID" db) "-" (strcut str 0 -1)))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;для марок электрических схем задвижек
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ( (and
	   (or
	     (wcmatch str "A*")
	     (wcmatch str "N*")
	     (wcmatch str "*c")
	     )
	   (db|gpar "LOOP_KKSID" db)
	   )
       (strcat (db|gpar "LOOP_KKSID" db) "-" str))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      ( (and
;;;	   (> (atoi str) 0)
;;;	   (< (atoi str) 100)
;;;	   (/= "" (db|gpar "KKS" db))
;;;	   )
;;;       (strcat (db|gpar "KKS" db) "-" str))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (T str)
       )
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  );setq
    (if (wcmatch str "*c")
      (strcut str 0 -1)
      str
      )
     );defun








(go)



;;;;     проверка
;;;;	1 последовательноть расположения реле 1-16
;;;;	2 создаем базу кабелей в модели
;;;;	3 проходимся в ручную объединяя повторяющиеся кабели























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun blk|getendpoint (obj)
    (mapcar
      (cond
	((= 0 (vlax-variant-value (vla-get-Value (getbdyn obj "cableSide")))) '+)
	((= 1 (vlax-variant-value (vla-get-Value (getbdyn obj "cableSide")))) '-)
	)
      (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj)))
      (list (+ 30 (vlax-variant-value (vla-get-Value (getbdyn obj "cabDist")))) 0 0)
      )
    );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq obj (vlax-ename->vla-object (car (entsel))))
(defun getcableline (obj / ssets sset result pt)
  (setq ssets (vla-get-SelectionSets #actdoc))
  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "getcableline")))
    (setq sset (vla-add ssets "getcableline"))
    (progn (vla-delete (vla-item ssets "getcableline")) (setq sset (vla-add ssets "getcableline")))
    )
  (vla-Clear sset)
  (setq pt (blk|getendpoint obj))
  ;(vl-cmdf "_zoom" "_W" (car pts) (cadr pts))
  (vla-select sset acSelectionSetCrossing
    (vlax-3d-point pt)
    (vlax-3d-point pt)
    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("LINE"))
  )
  (cond
    ((= 1 (vla-get-count sset)) (setq result (vla-item sset 0)))
    ((= 0 (vla-get-count sset)) (setq result nil))
    (T (setq result (kd-container->list sset)))
    )
  (vla-clear sset)
  (vla-Delete sset)
  result
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:cc () (conscables))
(defun conscables ( / objlink objmain markstoadd enptymarks marksinmain)
  (setq objlink (vlax-ename->vla-object (car (entsel "link"))))
  (setq objmain (vlax-ename->vla-object (car (entsel "main"))))
  (if (/= (vla-get-TextString (getbatt objlink "CBL_ID")) (vla-get-TextString (getbatt objmain "CBL_ID")))
    (progn (princ (strcat "\nРазные номера кабелей")) (exit)))
  (setq marksinmain (mapcar 'vla-get-TextString (vl-remove-if    '(lambda (att) (= "" (vla-get-TextString att))) (getbattswcmatch objmain "MARK*"))))
  (setq markstoadd (vl-remove-if '(lambda (att) (or (= "" (vla-get-TextString att)) (member (vla-get-TextString att) marksinmain))) (getbattswcmatch objlink "MARK*")))
  (setq enptymarks (vl-remove-if-not '(lambda (att) (= "" (vla-get-TextString att))) (getbattswcmatch objmain "MARK*")))
  (if (> (length enptymarks) (length markstoadd)) (mapcar '(lambda (ato mrk) (vla-put-TextString ato (vla-get-TextString mrk)) (vla-put-TextString mrk "")) enptymarks markstoadd))
  (setq e1 (vlax-vla-object->ename (getcableline objmain)))
  (setq e2 (vlax-vla-object->ename (getcableline objlink)))
  (command "_join"  e1 e2 "")
  (vlax-put-property objmain "color" 256)
  (vla-delete objlink)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(blk|getendpoint (vlax-ename->vla-object (car (entsel))))
;(getcableline (vlax-ename->vla-object (car (entsel))))


(defun c:cc2 () (conscables2))
(defun conscables2 ( / es links objmain markstoadd enptymarks marksinmain mainaddrstr planka mpt txto c)
  (while (setq es (entsel "link")) (setq links (cons (vlax-ename->vla-object (car es)) links)))
  (setq objmain (vlax-ename->vla-object (car (entsel "main"))))
  (if (null (apply '= (mapcar '(lambda (x) (vla-get-TextString (getbatt x "CBL_ID"))) (cons objmain links)))) (progn (princ (strcat "\nРазные номера кабелей")) (exit)))
  
  (setq marksinmain (mapcar 'vla-get-TextString (vl-remove-if    '(lambda (att) (= "" (vla-get-TextString att))) (getbattswcmatch objmain "MARK*"))))
  (setq markstoadd (vl-remove-if '(lambda (att) (or (= "" (vla-get-TextString att)) (member (vla-get-TextString att) marksinmain))) (apply 'append (mapcar '(lambda (x) (getbattswcmatch x "MARK*")) links))))
  (setq enptymarks (vl-remove-if-not '(lambda (att) (= "" (vla-get-TextString att))) (getbattswcmatch objmain "MARK*")))
  (if (> (length enptymarks) (length markstoadd)) (mapcar '(lambda (ato mrk) (vla-put-TextString ato (vla-get-TextString mrk)) (vla-put-TextString mrk "")) enptymarks markstoadd))
  (mapcar
    '(lambda (x / cpt arpt ar txto)
       (setq mainaddrstr (cons (last (sepstr (vla-get-TextString (getbatt x "ADDRESS")) " ")) mainaddrstr))
       (setq cpt (blk|getendpoint x))
       (setq arpt (mapcar '+ cpt '(-31 0 0)))
       (vla-addline #modspace (vlax-3d-point cpt) (vlax-3d-point arpt))
       (vla-InsertBlock #modspace (vlax-3d-point arpt) (strcat #lisppath "!blocking\\arrow.dwg") 1 1 1 Pi)
       (setq txto (vla-Addtext #modspace (strcat "В кабель " (vla-get-TextString (getbatt objmain "CBL_ID")) ", см. "
						 (last (sepstr (vla-get-TextString (getbatt objmain "CABINET")) " "))) (vlax-3d-point '(0 0 0))2.5))
       (vla-put-Alignment txto 11)
       (vla-put-TextAlignmentPoint txto (vlax-3d-point (mapcar '+ arpt '(-6 0 0))))
       )
    links
    )
  (setq planka  (getcableline objmain))
  (setq mpt (car (vl-sort (list (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint planka))) (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint planka)))) '(lambda (a b)(< (cadr a) (cadr b))))))
  (vla-addline #modspace (vlax-3d-point mpt) (vlax-3d-point (mapcar '+ mpt '(0 -2.5 0))))
  (vla-addline #modspace (vlax-3d-point (mapcar '+ mpt '(0 -2.5 0))) (vlax-3d-point (mapcar '+ mpt '(-5 -2.5 0))))
  (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ mpt '(-5 -2.5 0))) (strcat #lisppath "!blocking\\arrow.dwg") 1 1 1 Pi)
  (setq txto (vla-Addtext #modspace (antisep mainaddrstr ", ") (vlax-3d-point '(0 0 0))2.5))
  (vla-put-Alignment txto 11)
  (vla-put-TextAlignmentPoint txto (vlax-3d-point (mapcar '+ mpt '(-11 -2.5 0))))
  (mapcar 'vla-delete links)
  (vlax-put-property objmain "color" 256)
  );defun


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





(setq cablelist (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT")))))) (length cablelist)




(defun c:sw ( / obj cnum lst)
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (setq cnum (vla-get-TextString (getbatt obj "CBL_ID")))
  (setq lst (vl-remove-if-not '(lambda (x) (if (= (type (vl-catch-all-apply 'vla-ObjectIDToObject (list #actdoc (vla-get-ObjectID x)))) 'VLA-OBJECT)
					     (= cnum (vla-get-TextString (getbatt x "CBL_ID")))
					     )
				 ) cablelist))
  (mapcar '(lambda (x) (vlax-put-property x "color" 4)) lst)
  (sssetfirst nil (lst-to-ss lst))
  )



(defun c:dp ( / bb bt atts mrk pts pb pt)
  (setq bb (vlax-ename->vla-object (car (entsel))))
  (setq bt (vlax-ename->vla-object (car (entsel (vla-get-TextString (getbatt bb "MARK2"))))))
  (setq atts (concat (getbattswcmatch bb "MARK*") (getbattswcmatch bt "MARK*")))
  
  (setq mrk (vl-remove 'nil (mapcar '(lambda (a) (if (member (vla-get-TextString a) (mapcar 'vla-get-TextString (cdr (member a atts))))a)) atts)))
  (cond
    ((null mrk)(exit))
    ((= 1 (length mrk))(setq mrk (vla-get-TextString (car mrk))))
    ((> (length mrk) 1) (setq mrk (kd:dcl:pick-from-list (mapcar 'vla-get-TextString mrk))))
    )
  (setq atts (vl-remove-if-not '(lambda (x) (= mrk (vla-get-TextString x))) atts))

  (setq pts 
  (mapcar
    '(lambda (x)
       (mapcar '+ (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint x)))'(-1 1.25 0))
       )
    atts))

  (setq pts (vl-sort pts '(lambda (a b) (> (cadr a) (cadr b)))))
  (setq pt (car pts) pb (cadr pts))

  (vla-addline #modspace (vlax-3d-point pb) (vlax-3d-point (mapcar '+ pb '(-1.5 1 0))))
  (vla-addline #modspace (vlax-3d-point pt) (vlax-3d-point (mapcar '+ pt '(-1.5 -1 0))))
  (vla-addline #modspace (vlax-3d-point (mapcar '+ pb '(-1.5 1 0))) (vlax-3d-point (mapcar '+ pt '(-1.5 -1 0))))

  );defun










;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; проверка на повторение кабелей - origlist
(setq lst (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))
(length lst)
(mapcar '(lambda (x) (vla-get-TextString (getbatt x "CBL_ID"))) lst)
(length (origlist (mapcar '(lambda (x) (norus (vla-get-TextString (getbatt x "CBL_ID")))) lst)))




;; проверка на повторение НОМЕРОВ кабелей - origlist
(setq lst (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))
(setq lst (vl-remove-if-not '(lambda (x) (= "cbl_lst" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))
(length lst)

(setq lst (mapcar '(lambda (x) (vla-get-TextString (getbatt x "CBL_ID"))) lst))
(setq ls lst)

(while ls
  (setq tmp (car ls) ls (cdr ls))
  (if (member tmp ls)
    (progn (princ tmp) (exit))
    )
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq zadsDI (ziplist (cdr (excel>lst))))
(setq zadsDO (ziplist (cdr (excel>lst))))
(length zadsDI)
(length zadsDO)
(equal zadsDI zadsDO)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  


(setq regs (ziplist (cdr (excel>lst))))
(length regs)

(setq regs (mapcar 'car regs))
(mapcar 'norus regs)



(setq zads (ziplist (cdr (excel>lst))))
(setq zads (vl-remove '(nil) zads))
(length zads)

(setq zads (mapcar 'car zads))
(mapcar 'norus zads)
(vl-sort zads '(lambda (a b) ( a b)))


(vl-remove 'nil
(mapcar
  '(lambda (x)
     (if (member x regs)
       (princ x)
       )
     )
  zads)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; проверка есть ли такие кабели в которых присутствуют разные типы сигналов
;lst - номер кабеля - тип сигнала
(setq lst (excel>lst))
(setq lst (mapcar 'cdr (ziplist lst)))

(apply 'and
 (mapcar
  '(lambda (x)
     (apply '= x)
     )
  lst)
)
;T - значит в каждом кабеле - только один тип сигнала - можно спокойно сортировать - тип сигнала - номер кабеля
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;; массовое редактирование содержимого аттрибутов
(setq lst (ss->lsto* (ssget "_I" )))
(setq lst (mapcar '(lambda (x) (getbatt x "MEAS_NAME")) lst))

(mapcar
  '(lambda (x / str)
     (vla-put-TextString x (strcat (vla-get-TextString x) ". Положение" ))
     )
  lst)



;;; массовое редактирование аттрибутов

(setq lst (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget "_I" '((0 . "INSERT"))))))
;(length (VL-STRING->LIST (vla-get-TextString (getbatt (vlax-ename->vla-object (car (entsel))) "LOCFLD"))))

(mapcar
  '(lambda (cab / destatt l)
     (setq destatt (getbatt cab "ADDRESS"))
     (setq l (length (VL-STRING->LIST (vla-get-TextString destatt))))
     (cond
       ((diap l 50 56) (vla-put-ScaleFactor destatt 0.9))
       ((diap l 56 65)       (vla-put-ScaleFactor destatt 0.8))
       (T (princ))
       )
     )
  lst
  )