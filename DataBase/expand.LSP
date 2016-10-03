;;;  14_12_30  EXPAND Table




;	самое простое (в примере - троекратное) размножение строк

(setq prjData (excel>lst))

(setq res (apply 'append (mapcar '(lambda (line) (list line line line)) prjData)))
(lst>excel res)


(setq prjData (excel>lst))

(lst>excel
  (mapcar
    '(lambda (line)
       (list
	 (car line)
	 (antisep (cdr line) ", ")
	 )
       )
    (ziplist prjData)
    )
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; преобрпзование таблицы - перечня сигналов - в таблицу подключений
; т.е. расширение таблицы когда есть 2 однотипных столбца
; пример - есть таблица сигналов с шапкой:
; "cabinet" "clamp" "relay" ["cl1" "cl2" "mark1" "mark2"]
; вот то что в скобках надо преобразовать в таблицу с бОльшим количеством строк
; с шапкой "cabinet" "clamp" "relay" "cl" "mark"

;(setq tbl (db|formatdata (excel>lst)))
;(setq vcf:rule "clam=cl1,cl2,cl3;mark=mark1,mark2,mark3")
;(setq vcf:rule "EVENT=EVENT1,EVENT2,EVENT3,EVENT4,EVENT5,EVENT6,EVENT7,EVENT8,EVENT9;M=M1,M2,M3,M4,M5,M6,M7,M8,M9")
;(setq tbl (db|formatdata (excel>lst)))
;(setq vcf:rule "CL=CL1,CL2,CL3,CL4;CL_DESC=CL1_DESC,CL2_DESC,CL3_DESC,CL4_DESC;M=M1,M2,M3,M4")
;(lst>excel (tbl|expand-columns tbl vcf:rule))
;(lst>excel (tbl|expand-columns (db|formatdata (excel>lst)) "MARK=MARK1,MARK2,MARK3,MARK4,MARK5,MARK6,MARK7,MARK8,MARK9,MARK10,MARK11,MARK12"))
;(lst>excel (tbl|expand-columns (db|formatdata (excel>lst)) "POZSIGN=POZSIGN1,POZSIGN2,POZSIGN3,POZSIGN4,POZSIGN5,POZSIGN6"))
(defun tbl|expand-columns (tbl vcf:rule / $head exp:ruledata res)
  (setq $head (car tbl))
  (setq exp:ruledata (db|transmat (vcfstr>data vcf:rule)))
  ;(("clam" "mark") ("cl1" "mark1") ("cl2" "mark2"))

  (setq
    res
     (mapcar
       '(lambda (line)
	  (mapcar
	    '(lambda (oldtags / otvals)
	       (mapcar
		 '(lambda (tag)
		    (setq otvals (cons (tbl|gpar $head line tag) otvals))
		    )
		 (reverse oldtags)
		 )
	       (cond
		 (
		  (or
		    (apply '= (cons "" otvals))
		    (apply '= (cons nil otvals))
		    )
		  '("tbl|expand-columns=null")
		  )
		 (T (concat otvals line))
		 )
	       )
	    (cdr exp:ruledata)
	    )
	  )
       (cdr tbl)
       )
    )
  (setq res (apply 'append res))
  (setq res (vl-remove '("tbl|expand-columns=null") res))
  (setq res (cons (concat (car exp:ruledata) $head) res))
  (tbl|delcolumns res (apply 'append (cdr exp:ruledata)))
  );defun
;(setq data (db|formatdata (excel>lst)))
;(setq ans (tbl|expand-columns data "mark=mark1,mark2,mark3;clamm=cl1,cl2,cl3"))
;(setq ans (tbl|expand-columns data "M=M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,M13,M14"))
;(setq ans (tbl|expand-columns data "M=MARK1,MARK2,MARK3,MARK4,MARK5,MARK6,MARK7,MARK8,MARK9,MARK10"))
;(setq ans (tbl|expand-columns data "УПР=У1,У2,У3,У4"))
;(lst>excel ans)
;
;(setq tbl (db|formatdata (excel>lst)))
;(setq vcf:rule "EVENT=EVENT1,EVENT2,EVENT3,EVENT4,EVENT5,EVENT6,EVENT7,EVENT8,EVENT9;M=M1,M2,M3,M4,M5,M6,M7,M8,M9")
;(lst>excel (tbl|expand-columns tbl vcf:rule))
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;









;;   преобразование перечня подключений в перечень сигналов (expand наоборот)
(setq tbl (excel>lst))
;(setq res (tbl|zipsorted tbl "KKS"))
(setq data (cdr tbl) db:head (car tbl))
(setq res (db|mapzip* (cons "table" data) '("T1" "T2" "T1" "MOD_NUM" "SOCKET" "KKS"))) (princ)



(setq ans
(mapcar
  '(lambda (sig / val)	;(setq sig (nth 1 res))
     (setq val (nth 1 sig))
     (setq val (cons (db|gpar "CL" (nth 2 sig)) val))
     (setq val (cons (db|gpar "CL" (nth 3 sig)) val))
     (setq val (cons (db|gpar "CL" (nth 4 sig)) val))

     (setq val (cons (db|gpar "M" (nth 2 sig)) val))
     (setq val (cons (db|gpar "M" (nth 3 sig)) val))
     (setq val (cons (db|gpar "M" (nth 4 sig)) val))

     (setq val (cons (db|gpar "DESC" (nth 2 sig)) val))
     (setq val (cons (db|gpar "DESC" (nth 3 sig)) val))
     (setq val (cons (db|gpar "DESC" (nth 4 sig)) val))     
     )
  (cdr res)
  ))
(setq newhead db:head)
(setq newhead (cons "CL2" newhead))
(setq newhead (cons "CL3" newhead))
(setq newhead (cons "CL4" newhead))
(setq newhead (cons "M2" newhead))
(setq newhead (cons "M3" newhead))
(setq newhead (cons "M4" newhead))
(setq newhead (cons "CL2_DESC" newhead))
(setq newhead (cons "CL3_DESC" newhead))
(setq newhead (cons "CL4_DESC" newhead))

(lst>excel (cons newhead ans))




(setq lst (mapcar 'car (excel>lst)))
(DEORIGLIST lst)
(lst>excel (mapcarx sepstr "\n" lst))
(lst>excel (mapcarx sepstr "," lst))



(lst>excel (mapcarx sepstr " " (mapcar 'car (excel>lst))))
(lst>excel (mapcarx sepstr "х" (mapcar 'car (excel>lst))))








(setq res (list-odd tbl 2))

(setq res (list-odd
   
	    
	    (append
	      (cdr tbl)
	      (list (car tbl)))

	    2))

(lst>excel res)







(setq blks (vl-remove-if-not '(lambda (x) (= "act_mnt_cbl-outer" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))

(setq cabs (vl-remove-if-not '(lambda (b) (wcmatch (kd-get-textstring (getbatt b "LOCFLD")) "*CAB*,*CDB*,*CGB*,*ПТК*"))blks))
(length cabs)

(sssetfirst nil (lst-to-ss cabs))




(setq #clbase (tbl|blrefs>table (vl-remove-if-not '(lambda (x) (= "act_mnt_cbl-outer" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT")))))))
(length #clbase)





























































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; когда в 1 столбце таблицы указаны значения через запятую, функция размножает строки
; для каждого значения
;(setq tbl (db|formatdata (excel>lst)))
;(setq tag "POZ")
(defun tbl|expand-split-column (tbl tag / $head res tmpcolname)
  (setq tmpcolname "TMP")
  (setq $head (car tbl))
  (setq
    res
     (mapcar
       '(lambda (line / tagvals)	;(setq line (nth 1 (cdr tbl)))
	  (setq tagvals (sepstr (tbl|gpar $head line tag) ","))
	  (mapcar '(lambda (tv) (cons tv line)) tagvals)
	  )
       (cdr tbl)
       )
    )
  (setq res (apply 'append res))
  (setq res (cons (cons tmpcolname $head) res))
  (setq res (tbl|delcolumn res tag))
  );defun
;(setq data (db|formatdata (excel>lst)))
;(setq ans (tbl|expand-split-column data "row"))
;(lst>excel ans)
;(lst>excel (tbl|expand-split-column (db|formatdata (excel>lst)) "POZ"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; когда в 1 столбце таблицы указаны значения через ":" функция размножает этот столбец на подстолбцы - дерево
; для каждого значения
; пример : [ADDRESS] "@CABPSU:@UG:@CH:1+"
; разделяет колонку на [UNIT]:[ITEM]:[CLAMP]:[CLAM]

;(setq tbl #$Lnks)
;(setq tag "ADDRESS")
;(setq delimiter ":")


(defun tbl|expand-tree-split-column (tbl tag delimiter / i newtagslist $head res)
  ;;;  анализ
  (setq i (1+ (apply 'max (mapcar '(lambda (x) (length (sepstr x delimiter))) (cdr (assoc tag (db|transmat tbl)))))))
  (setq newtagslist nil)
  (while (> (setq i (1- i)) 0) (setq newtagslist (cons (strcat tag (itoa i)) newtagslist)))
  ;;;;;;;;;;;

  (setq $head (car tbl))
  (setq
    res
     (mapcar
       '(lambda (line / tagvals)	;(setq line (nth 1 (cdr tbl)))
	  (setq tagvals (sepstr (tbl|gpar $head line tag) delimiter))
	  (repeat (- (length newtagslist) (length tagvals))
	    (setq tagvals (cons "" tagvals))
	    )
	  (concat tagvals line)
	  )
       (cdr tbl)
       )
    )
  
  (setq res (cons (concat newtagslist $head) res))
  (setq res (tbl|delcolumn res tag))
  );defun



;(setq data (db|formatdata (excel>lst)))
;(setq ans (tbl|expand-tree-split-column data "POZSIGN" ", "))
;(lst>excel ans)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; декомпозиция данных проекта

;	1 DETLEV=40 - loops - контуры измерения
;	2 DETLEV=60 - links - электрические связи (провода)
;	3 DETLEV=80 - connections - подключения - каждое подключение каждого конца провода в строке данных


;  loops -> links



;	TAGS = [MARK ADDR1 ADDR2]
;	LOCATION = [SUBSYST:EQUIP:CLAMP:CLAM]
;	LOCATION = [UNIT:ITEM:TERM:PIN]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tbl|expand-M:MARK (line)
  (list
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-0")
	      "@FLD::@Sensor:SCT"		; "=LOOP_KKSID:X:SCT"
	      "@CABMARK:@P:CHA:SCT"		; "+CAB_KKSID:=P:CHA"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-1")
	      "@CABMARK:@P:XS:5+"		; "+CAB_KKSID:=P:5+"
	      "@CABCTRL:@MODUL:@CHAN:2+"	; "+CAB_KKSID:#MOD:#CLAM"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-2")
	      "@CABMARK:@P:XS:6-"		; "+CAB_KKSID:=.P:6-"
	      "@CABCTRL:@MODUL:@CHAN:1-"	; "+CAB_KKSID:#MOD:#CLAM"
	      ) line)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tbl|expand-M:4W (line)
  (list
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-take")
	      ":::PIPE"
	      "@FLD:@Stand:@Sensor:take"
	      ) line)    
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-1")
	      "@FLD:@Stand:@Sensor:1L"
	      "@CABPSU:@UG:@CH:1+"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-2")
	      "@FLD:@Stand:@Sensor:2N"
	      "@CABPSU:@UG:@CH:2-"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-3")
	      "@FLD:@Stand:@Sensor:3+"
	      "@CABCTRL:@MODUL:@CHAN:2+"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-4")
	      "@FLD:@Stand:@Sensor:4-"
	      "@CABCTRL:@MODUL:@CHAN:1-"
	      ) line)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tbl|expand-M:2W (line)
  (list
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-take")
	      ":::PIPE"
	      "@FLD:@Stand:@Sensor:take"
	      ) line)       
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-1")
	      "@FLD:@Stand:@Sensor:1"
	      "@CABCTRL:@MODUL:@CHAN:1-"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-2")
	      "@FLD:@Stand:@Sensor:2"
	      "@CABPSU:@UG:@CH:2-"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-3")
	      "@CABPSU:@UG:@CH:1+"
	      "@CABCTRL:@MODUL:@CHAN:2+"
	      ) line)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tbl|expand-M:L (line)
  (list
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-take")
	      ":::PIPE"
	      "@FLD:@Stand:@Sensor:take"
	      ) line)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; кодировка места сборки
; "@СБОРКА:@ШКАФ:@БЛОК:17"
; итак, я разделил пока что на 4 уровня указания места подключения провода


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(setq loops (db|formatdata (excel>lst)))
(setq #$Lnks nil)



;		LOOPS -> LINKS


;  add "MARK"s "ADDR1" "ADDR2"
(setq #$Lnks
(mapcar
  '(lambda (line / lt)	;(setq line (nth 1 (cdr loops)))
     (setq lt (tbl|gpar (car loops) line "LOOP_TYPE"))
     (cond
       ((= "M:L" lt) (tbl|expand-M:L line));'("tbl|expand-columns=null"))
       ((= "M:2W" lt) (tbl|expand-M:2W line))
       ((= "M:4W" lt) (tbl|expand-M:4W line))
       ((= "M:MARK" lt) (tbl|expand-M:MARK line))
       )
     )
  (cdr loops)
  ))

(setq #$Lnks (apply 'append #$Lnks))
(setq #$Lnks (vl-remove "tbl|expand-columns=null" #$Lnks))
(setq #$Lnks (cons (concat (list "MARK" "ADDR1" "ADDR2") (car loops)) #$Lnks))


;         просмотр
;(lst>excel #$Lnks)
;;;;;;;;;;;;;;;;;;



;		LINKS -> CONTACTs

;размножаем колонки ADDR1 и ADDR2 на по строчке на каждую
(setq #$Contacts (tbl|expand-columns #$Lnks "ADDRESS=ADDR1,ADDR2"))


;         просмотр
;(lst>excel #$Contacts)
;;;;;;;;;;;;;;;;;;



(setq #$Contacts (tbl|expand-tree-split-column #$Contacts "ADDRESS"))

; NOW GO TO ADO










;;;
;;;
;;;
;;;;         
;;;(lst>excel #$Contacts)
;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;; 			тут можно добавить клеммники - 
;;;
;;;
;;;;;   добавляем стенды
;;;(setq c1 #$Contacts)
;;;
;;;(setq tbl-to-add-stand (tbl|filter (tbl|filter c1 "ADDRESS2=@Stand") "F_PID=PT"))
;;;;(lst>excel tbl-to-add-stand)
;;;(setq c1 (cdr c1))
;;;(mapcar
;;;  '(lambda (line / head ldat lsnd)	;(setq line (nth 0 (cdr tbl-to-add-stand)))
;;;     (setq head (car tbl-to-add-stand))
;;;     (setq ldat (tbl|spar head line "ADDRESS1" (strcat "Датчик " (tbl|gpar head line "LOOP_KKSID"))))
;;;     (setq ldat (tbl|spar head ldat "ADDRESS2" ""))
;;;     (setq ldat (tbl|spar head ldat "ADDRESS3" ""))
;;;
;;;     (setq lsnd (tbl|spar head line "ADDRESS1" (strcat "Стенд UE-СД#")))
;;;     (setq lsnd (tbl|spar head lsnd "ADDRESS2" ""))
;;;     (setq lsnd (tbl|spar head lsnd "ADDRESS3" ""))
;;;     (setq lsnd (tbl|spar head lsnd "ADDRESS4" "#"))
;;;
;;;     (setq c1 (vl-remove line c1))
;;;     (setq c1 (concat (list ldat lsnd) c1))
;;;     )
;;;  (cdr tbl-to-add-stand)
;;;  ) (princ)
;;;(setq c1 (cons (car #$Contacts) c1))
;;;
;;;(lst>excel c1)
;;;
;;;(lst>excel c2)
;;;
;;;;;   добавляем клеммник в шкафу блоков питания и также туда вставтяем транзит (это трабл:( )
;;;(setq c2 (cdr c1))
;;;(setq tbl-to-add-CAB1clamp (tbl|filter (tbl|filter c1 "ADDRESS2=@Stand") "F_PID=PT"))
;;;
;;;
;;;
;;;
;;;





;;  а вот тут пришла мыслъ - будем распределять в автокаде
;;  делаем авто-блок с аттрибутами из шапки, пишем функцию excel>autoblocks

;(lst>excel #$Contacts)


;(excel>autoblocks #$Contacts)

;;  заполняем (распределяем данные) по средством функций bfbatt






















; now go to ADO working




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;













;;;;;;(setq tbl (db|formatdata (excel>lst)))
;;;;;;(setq vcftag "interface")
;;;;;;"220,DO=Открыть,Закрыть,Отмена;220,DI=Ход на открытие,Ход на закрытие,Не открыто,Не закрыто"
;;;;;;(vcfstr>data "220DO=Открыть,Закрыть,Отмена;220DI=Ход на открытие,Ход на закрытие,Не открыто,Не закрыто")
;;;;;;(vcfstr>data "220,DO=Открыть,Закрыть,Отмена;220,DI=Ход на открытие,Ход на закрытие,Не открыто,Не закрыто")
;;;;;;   принцип: все что после равно - элементы размножения 1 строчки
;;;;;;   	       все что до равно - общие параметры группы сигналов
;;;;;;   то есть в данном случае
;;;;;;   "220,DO=Открыть,Закрыть,Отмена;220,DI=Ход на открытие,Ход на закрытие,Не открыто,Не закрыто"
;;;;;;   1 позииция задвижки размножается на 7 сигналов
;;;;;;   из которых 3 с параметрами 220 и DO и 4 с параметрами 220 и DI
;;;
;;;в общем, не вижу смысла писать эту функци.ю , т.к. неправильное распределение, не логичная кдировка структуры
;;;
;;;(defun tbl|expand-of-vcfcol (tbl vcftag / $head res)
;;;  (setq typecolname "TMP_TYPE")
;;;  (setq $head (car tbl))
;;;   
;;;  (setq
;;;    res
;;;     (mapcar
;;;       '(lambda (line / vcf)	;(setq line (nth 0 (cdr tbl)))
;;;
;;;	  (setq vcf (vcfstr>data (tbl|gpar $head line vcftag)))
;;;
;;;	  
;;;	  (vcfstr>data (tbl|gpar $head line vcftag))
;;;	  )
;;;       (cdr tbl)
;;;       )
;;;    )
;;;
;;;
;;;  
;;;  res
;;;  );defun
















;;;
;;;
;;;;;  в екселе есьт перечень арматуры
;;;;;  делаем из него перечень сигналов (размножаем строчки екселя)
;;;
;;;(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))
;;;(load (strcat #lisppath "DataBase\\dblib.lsp"))
;;;(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
;;;(load (strcat #lisppath "Strings\\kd-sortstrings.LSP"))
;;;
;;;
;;;(setq db:data (cons "table" (vl-remove-if '(lambda (x) (apply '= (cons "" x))) (db|formatdata (excel>lst)))))
;;;
;;;(length (cdr db:data))
;;;
;;;(setq sdata (cons "table" (vl-remove-if '(lambda (x) (apply '= (cons "" x))) (db|formatdata (excel>lst)))))
;;;
;;;(setq signals
;;;   '(
;;;     ("1" "Не открыто" "Не закрыто" "Ход на открытие" "Ход на закрытие" "Открыть" "Закрыть" "Отмена")
;;;     ("2" "Не открыто" "Не закрыто" "Ход на открытие" "Ход на закрытие" "Открыть" "Закрыть" "Отмена")
;;;     ("3" "Не открыто" "Не закрыто" "Больше" "Меньше" )
;;;     )
;;;  )
;;;
;;;
;;;
;;;(length
;;;  (setq res
;;;(apply 'append
;;;(mapcar
;;;  '(lambda (x)
;;;     ;(setq x (cadr db:data))
;;;     (mapcar
;;;       '(lambda (s)
;;;	  (append
;;;	    (list
;;;	      (nth 0 x)
;;;	      (nth 1 x)
;;;	      )
;;;	    (assoc s (cdr sdata))
;;;	    )
;;;	  
;;;	  )
;;;       (cdr (assoc (last x) signals))
;;;       )
;;;     )
;;;  (cdr db:data)
;;;  )
;;;       )
;;;	)
;;;)
;;;
;;;(lst>excel res)
;;;
;;;
;;;
;;;;;;  2
;;;
;;;(setq armlst (vl-remove-if '(lambda (x) (apply '= (cons "" x))) (db|formatdata (excel>lst))))
;;;
;;;; заполняем вручную из чертежей - эл.схем приводов
;;;
;;;(setq signals:head '("sign_type" "event" "mark1" "mark1"))
;;;(setq
;;;  signals
;;;   '(
;;;     (	;603
;;;      ("2" "3" "4")
;;;      ("24DO"		"Больше" "9" "19")
;;;      ("24DO"		"Меньше" "7" "17")
;;;      ("24DI"		"Не открыто" "8" "19")
;;;      ("24DI"		"Не закрыто" "8" "17")
;;;      ("420AI+"		"Положение" "18" "16")
;;;      )
;;;     (
;;;      ("5" "6" "7" "8")
;;;      ("220DO"		"Открыть" "A11" "A12")
;;;      ("220DO"		"Закрыть" "A19" "A20")
;;;      ("220DO"		"Стоп" "A1" "A16")
;;;      ("220DI"		"Не открыто" "A11" "N")
;;;      ("220DI"		"Не закрыто" "A19" "N")
;;;      ("220DI"		"Ход на открытие" "A15" "N")
;;;      ("220DI"		"Ход на закрытие" "A23" "N")
;;;      ("220DI"		"Перегрузка" "A9" "N")
;;;      )
;;;     (	;602
;;;      ("9")
;;;      ("220DO"		"Открыть" "A11" "A12")
;;;      ("220DO"		"Закрыть" "18" "16")
;;;      ("220DO"		"Блокировка открытия" "A12" "A4")
;;;      ("220DI"		"Не открыто" "A2" "N")
;;;      ("220DI"		"Не закрыто" "A3" "N")
;;;      ("220DI"		"Исправность цепей закрытия" "A9" "N")
;;;      ("220DI"		"Авария" "A10" "N")
;;;      )
;;;
;;;     ( ;601
;;;      ("10")
;;;      ("220DO"		"Открыть" "A11" "A12")
;;;      ("220DO"		"Закрыть" "A24" "A20")
;;;      ("220DO"		"Стоп" "A1" "A16")
;;;      ("220DI"		"Не открыто" "A8" "N")
;;;      ("220DI"		"Не закрыто" "A19" "N")
;;;      ("220DI"		"Ход на открытие" "A15" "N")
;;;      ("220DI"		"Ход на закрытие" "A23" "N")
;;;      ("220DI"		"Перегрузка" "A9" "N")
;;;      )
;;;     )
;;;   )
;;;
;;;;;   монтаж привода
;;;(setq lst (vl-sort (mapcar '(lambda (x) (norus (kd-get-textstring x))) (ss->lsto* (ssget))) '<))
;;;(norus (antisep lst ","))
;;;(length lst)
;;;
;;;;;   подклбючение сборки
;;;
;;;(setq lst (vl-sort (mapcar '(lambda (x) (norus (kd-get-textstring x))) (ss->lsto* (ssget))) '<))
;;;(norus (antisep lst ","))
;;;(length lst)
;;;
;;;
;;;
;;;
;;;(setq result
;;;(mapcar
;;;  '(lambda (ar)	;(setq ar (nth 2 armlst))
;;;     (mapcar
;;;       '(lambda (s)
;;;	  (append ar s)
;;;	  )
;;;       (cdr (assoc (nth 2 ar) signals))
;;;       )
;;;     )
;;;  armlst)
;;;      )
;;;(apply 'append result)
;;;(lst>excel (apply 'append result))
;;;
;;;
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(db|getdata)
;;;db:table
;;;(db|gpar "эл" (cadr db:data))
;;;
;;;
;;;(setq
;;;  cabdata
;;;   '(
;;;     (
;;;      "2"
;;;      ("#УКП" "#РТЗО" 4 "380" "marks=A2,B2,C2,PE")
;;;      ("#УКП" "#РТЗО" 5 "220" "marks=10,13,14,17,19")
;;;      ("#РТЗО" "#CTRL" 5 "220" "marks=7,8,9,17,19")
;;;      ("#УКП" "#CTRL" 2 "420" "marks=16,18")
;;;      )
;;;
;;;     (
;;;      "3"
;;;      ("#УКП" "#РТЗО" 4 "380" "marks=A2,B2,C2,PE")
;;;      ("#УКП" "#РТЗО" 5 "220" "marks=10,13,14,17,19")
;;;      ("#РТЗО" "#CTRL" 5 "220" "marks=7,8,9,17,19")
;;;      ("#УКП" "#CTRL" 2 "420" "marks=16,18")
;;;      )
;;;
;;;     (
;;;      "4"
;;;      ("#УКП" "#РТЗО" 4 "380" "marks=A2,B2,C2,PE")
;;;      ("#УКП" "#РТЗО" 5 "220" "marks=10,13,14,17,19")
;;;      ("#РТЗО" "#CTRL" 5 "220" "marks=7,8,9,17,19")
;;;      ("#УКП" "#CTRL" 2 "420" "marks=16,18")
;;;      )
;;;
;;;
;;;     
;;;     )
;;;  )
;;;






















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;   30   expanding loops to $Elements and $Links

;;;
;;;(setq tbl (db|formatdata (excel>lst)))
;;;
;;;
;;;(setq #$Elts nil #$Lnks nil)
;;;;(setq #$Lnks '(("MARK")))
;;;;(setq #$Elts '(("EL_TYPE")))
;;;
;;;
;;;(mapcar
;;;  '(lambda (line / loop_type )	;(setq line (nth 1 (cdr tbl)))
;;;     (setq loop_type (tbl|gpar (car tbl) line "LOOP_TYPE"))
;;;     (cond
;;;       ((= "M:L" loop_type)
;;;	(tbl|add-M:L #$Elts #$Lnks (cons (car tbl) line))
;;;	)
;;;       )
;;;     )
;;;  (cdr tbl)
;;;  )
;;;
;;;
;;;
;;;(defun tbl|add-M:L (elts-tbl-sym lnks-tbl-sym
;;;		    owner1tbl
;;;		    /
;;;		    )
;;;  (set elts-tbl-sym
;;;    (cons
;;;      (list
;;;	("EL_TYPE" "SE1")
;;;	("CONTACTS" ("CFM1"))
;;;	)
;;;      (eval elts-tbl-sym)))
;;;    
;;;  (set lnks-tbl-sym
;;;    (cons
;;;      (list
;;;	("MARK" "FM1")
;;;	("CONTACTS" ("F1"))
;;;	)
;;;      (eval elts-tbl-sym)))
;;;  
;;;   
;;;  );defun


































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;		15_07_08
; есть перечень ЗРА
; отбимраем только проектные задвижки и регуляторы без резервов

(tbl|getdata 'ZRA)

;	виды электрических схем арматуры
(setq schemas 
       (origlist(mapcar
	 '(lambda (x / cutlast)
	    (defun cutlast (y) (reverse (cdr (reverse y))))
	    (antisep (cutlast (sepstr x "|")) "|")
	    )
	 ;(origlist (cdr (assoc "ELSCH" (db|transmat ZRA))))
	 (origlist (cdr (assoc "Э3_CODE" (db|transmat ZRA))))
	 ))
      )
(length schemas)
'("R|380|МЭО|0|5413|--|OI"
  "V|380|UNI|3|5401|--|--"
  "V|380|UNI|3|5403|--|--"
  "V|380|UNIПК|3|5403|--|--"
  "V|380|ГИЮМ|3|5401|--|--"
  "V|380|МЭО|3|5403R|--|OI"
  "V|380|ЭПН|3|5403R|--|OI"
 )


'("R|380|ЦА2|0|RT412.37|--"
  "S|220|ИПК|0|ПИПК|PT"
  "V|220|ЭПЗ100|0|LK609|--"
  "V|380|AUMA|6|AT751.37|DODC"
  "V|380|RAIN|0|AT751|--"
  "V|380|UNI|6|AT752.37|--"
  "V|380|БКВШ|6|AT752.37|--"
  "V|380|ВКО|6|AT752.37|--"
  "V|380|ГЗ|6|AT751.37|--"
  "V|380|ГИЮМ|6|AT752.37|--"
  "V|380|МЗО125|6|AO753.37|--"
  "V|380|МЗО125|6|AO753.37|DODC"
  "V|380|МЗО160|6|AO754.37|--"
  "V|380|МЗО250|6|AO754.37|--"
  "V|380|ТОМПРИНГ|6|AT752.37|--"
 )
;	теперь по каждой схеме формируем схему кабельных связей (с марками)
;	определяемся с "местами" подключений

; сборка - главный распределительный пункт - указывается в перечне первым

;;;(setq lst '())
;;;(while (setq name (kd:dclget '("место")))
;;;  (setq lst (cons (cons (car name) (g:getmarks)) lst))
;;;  )

"Сборка"
; cables.lsp
;	указываем марки в эл.сххеме задвижки, которые выведены на клеммник (внешние)
(cons "Сборка" (g:getmarks))

("Сборка" "A20" "A24" "A19" "A10" "A15" "A12" "A11" "N" "A16" "PE" "C2" "B2" "A2" "A1")

(cons "УКП" (g:getmarks))
("УКП" "A12" "A20" "A24" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")

(cons "220DI" (g:getmarks))
("220DI" "A23" "A19" "A11" "A15" "N") 

(cons "DONO" (g:getmarks))
("DONO" "A20" "A19" "A12" "A11" "A16" "A10") 

(cons
  "V|380|UNI|3|5403|--|--"
  (list
    (cons "Сборка" (g:getmarks))
    (cons "УКП" (g:getmarks))
    (cons "220DI" (g:getmarks))
    (cons "DONO" (g:getmarks)))
  )

(cons "Сборка" (g:getmarks))
(cons "УКП" (g:getmarks))
(cons "24DI" (g:getmarks))
(cons "DONO" (g:getmarks))
(cons "420AI" (g:getmarks))



;	теперь формируем в кучу по схеме

(setq schema 
'("V|380|ГИЮМ|3|5401|--|--"
  ("Сборка" "A20" "A24" "A19" "A10" "A15" "A12" "A11" "N" "A16" "PE" "C2" "B2" "A2" "A1")
  ("УКП" "A12" "A20" "A24" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10") 
  ))
(lst>excel (compose schema))

(setq schema 
'("V|380|UNI|3|5401|--|--"
  ("Сборка" "A20" "A24" "A19" "A10" "A15" "A12" "A11" "N" "A16" "PE" "C2" "B2" "A2" "A1")
  ("УКП" "A12" "A20" "A24" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10") 
  ))

(setq schema 
'("V|380|UNI|3|5403|--|--"
  ("Сборка" "A23" "A20"	"A19" "A15" "A12" "A11"	"A16" "A10" "N"	"A1" "C2" "B2" "A2" "PE")
  ("УКП" "A20" "A12" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10")
 ))
(setq schema 
'("V|380|UNIПК|3|5403|--|--"
  ("Сборка" "A23" "A20"	"A19" "A15" "A12" "A11"	"A16" "A10" "N"	"A1" "C2" "B2" "A2" "PE")
  ("УКП" "A20" "A12" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10")
  ))
(setq schema 
'("V|380|ЭПН|3|5403R|--|OI"
  ("Сборка" "A23" "A20"	"A19" "A15" "A12" "A11"	"A16" "A10" "N"	"A1" "C2" "B2" "A2" "PE")
  ("УКП" "A20" "A12" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE" "13" "18")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10")
  ("420AI" "13" "18")
  ))
(setq schema 
'("V|380|МЭО|3|5403R|--|OI"
  ("Сборка" "A23" "A20"	"A19" "A15" "A12" "A11"	"A16" "A10" "N"	"A1" "C2" "B2" "A2" "PE")
  ("УКП" "A20" "A12" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE" "13" "14" "16" "18")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10")
  ("420AI" "13" "14" "16" "18")
  ))

(setq schema 
'("V|380|МЭО|0|5413|--|OI"
  ("Сборка" "19" "17" "8" "10" "9" "7" "C2" "B2" "A2" "PE") 
  ("УКП" "13" "14" "16" "18" "C2" "B2" "A2" "PE" "10" "19" "17") 
  ("24DI" "19" "17" "8")
  ("DONO" "19" "17" "9" "7")
  ("420AI" "13" "14" "16" "18")
  ))

(lst>excel (compose schema))



(defun compose (schema / gk data maincab cables result)
  (defun gk (obs / marks)
    (if (null (atom (car obs)))
    (cond
      ((= (length obs) 2)
       (mapcar '(lambda (x) (if (member x (car obs)) (setq marks (cons x marks)))) (cdr (cadr obs)))
	(if marks (list (concat (list (car (car obs)) (car (cadr obs))) (vl-sort marks '<))))
	)
      ((> (length obs) 2)
       (append
	 (apply 'append (mapcar '(lambda (c) (gk (list (car obs) c))) (cdr obs)))
	 (gk (cdr obs))
	 )
       )
      ))
    );defun
  
  (setq data (cdr schema))
  (setq maincab (car data) data (cdr data))
  (setq cables nil)

  (setq result
  (mapcar
    '(lambda (cab / res) ;(setq cab (nth 2 data))
       (mapcar
	 '(lambda (m)
	    (if (member m maincab)
	      (setq res (cons m res))
	      )
	    
	    )
	 (cdr cab)
	 )
       (if res (setq cables (cons (concat (list (car maincab) (car cab)) (vl-sort res '<)) cables)))
       (vl-remove-if '(lambda (x) (member x res)) cab)
       )
    data))
  (setq result (vl-remove-if '(lambda (x) (= 1 (length x))) result))
  (append cables (gk result))
  );defun









































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;		16_03_017
; есть перечень ЗРА
; отбимраем только проектные задвижки и регуляторы без резервов

(tbl|getdata 'ZRA)

;	виды электрических схем арматуры
(setq schemas 
       (origlist(mapcar
	 '(lambda (x / cutlast)
	    (defun cutlast (y) (reverse (cdr (reverse y))))
	    (antisep (cutlast (sepstr x "|")) "|")
	    )
	 (origlist (cdr (assoc "Э3_CODE" (db|transmat ZRA))))
	 ))
      )


'("R|380|ЦА2|0|RT412.37|--"
  "S|220|ИПК|0|ПИПК|PT"
  "V|220|ЭПЗ100|0|LK609|--"
  "V|380|AUMA|6|AT751.37|DODC"
  "V|380|RAIN|0|AT751|--"
  "V|380|UNI|6|AT752.37|--"
  "V|380|БКВШ|6|AT752.37|--"
  "V|380|ВКО|6|AT752.37|--"
  "V|380|ГЗ|6|AT751.37|--"
  "V|380|ГИЮМ|6|AT752.37|--"
  "V|380|МЗО125|6|AO753.37|--"
  "V|380|МЗО125|6|AO753.37|DODC"
  "V|380|МЗО160|6|AO754.37|--"
  "V|380|МЗО250|6|AO754.37|--"
  "V|380|ТОМПРИНГ|6|AT752.37|--"
 )

;	теперь по каждой схеме формируем сигналы и хвосты


(lst>excel (compose schema))



(defun compose (schema / gk data maincab cables result)
  (defun gk (obs / marks)
    (if (null (atom (car obs)))
    (cond
      ((= (length obs) 2)
       (mapcar '(lambda (x) (if (member x (car obs)) (setq marks (cons x marks)))) (cdr (cadr obs)))
	(if marks (list (concat (list (car (car obs)) (car (cadr obs))) (vl-sort marks '<))))
	)
      ((> (length obs) 2)
       (append
	 (apply 'append (mapcar '(lambda (c) (gk (list (car obs) c))) (cdr obs)))
	 (gk (cdr obs))
	 )
       )
      ))
    );defun
  
  (setq data (cdr schema))
  (setq maincab (car data) data (cdr data))
  (setq cables nil)

  (setq result
  (mapcar
    '(lambda (cab / res) ;(setq cab (nth 2 data))
       (mapcar
	 '(lambda (m)
	    (if (member m maincab)
	      (setq res (cons m res))
	      )
	    
	    )
	 (cdr cab)
	 )
       (if res (setq cables (cons (concat (list (car maincab) (car cab)) (vl-sort res '<)) cables)))
       (vl-remove-if '(lambda (x) (member x res)) cab)
       )
    data))
  (setq result (vl-remove-if '(lambda (x) (= 1 (length x))) result))
  (append cables (gk result))
  );defun









































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;