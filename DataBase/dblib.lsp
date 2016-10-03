;;;;   13_10_31
;(load (strcat #lisppath "DataBase\\dblib.lsp"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;((a b c) (1 2 3) (x y z)) ====>>> ((a 1 x) (b 2 y) (c 3 z))
(defun db|transmat (lst) (apply 'mapcar (cons 'list lst)))




(defun inverse (lst / tmp len)
  (setq len (apply 'max (mapcar 'length lst)))
  (setq tmp (mapcar '(lambda (line / r)
       (setq r (reverse line))
       (repeat (- len (length line)) (setq r (cons "" r)))
       (reverse r)) lst))
  (apply 'mapcar (cons 'list tmp))
  );defun




; (db|transmat '((a b c) (1 2 3) (x y z)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))





;;;   R U L E S
;(setq db:head (car (excel>lst)))
;(setq db:data (cons "table" (db|formatdata (excel>lst))))


;(setq db:head nil db:data nil)
;(db|getdata 'db:head 'db:data)

(defun db|getdata ( headsym datasym / table)
  (setq table (excel>lst))
  (set headsym (car table))
  (princ "head : \t ") (princ headsym) (princ "\n")
  (princ (eval headsym)) (princ "\n")
  (set datasym (cons "table" (db|formatdata (cdr table))))
  (princ "data : \t ") (princ datasym) (princ "\n")
  (princ (eval datasym)) (princ "\n")
  (princ "\n")
  (princ)
  )




(defun tbl|getdata (tablesym / table)
  (set tablesym (db|formatdata (excel>lst)))
  (princ "head : \t ") (princ (car (eval tablesym))) (princ "\n")
  (princ "contains : \t ") (princ (1- (length (eval tablesym)))) (princ "\n")
  )


;;	Block Reference Table = BRT

;(setq blreflst (ss->lsto* (ssget)))
(defun tbl|blrefs>table (blreflst / blrefs head data)
  (setq blrefs (mapcar '(lambda (x) (blref-to-data x #blks>linkingOption)) blreflst))
  ; проверка на совпадение аттрибутов и их очередность
  (if
    (and
      (apply 'and (mapcar '= (db|transmat (mapcar '(lambda (x) (mapcar 'car x)) blrefs))))
      (setq head (mapcar 'car (car blrefs)))
      (setq data (mapcar '(lambda (line) (mapcar 'cadr line)) blrefs))
      )
    (cons head data)
    (exit)
    )
  );defun



;(kd:getfieldcode (vlax-ename->vla-object (car (nentsel))))
;(setq obj (vlax-ename->vla-object (car (entsel))))
(defun blref-to-data (obj linkingOption)
  (if (= "AcDbBlockReference" (vla-get-ObjectName obj))
    (cons
      (list (strcat "[BN]=" (vla-get-EffectiveName obj))
	(vla-get-Handle obj))
      (mapcar
	'(lambda (att / destatt str)
	   (list (vla-get-TagString att)

		 (cond
		   
		   ((null linkingOption) (kd-get-TextString att))
		   ((= 0 linkingOption) (kd-get-TextString att))
		   ((= 1 linkingOption) (strcat "HNDL=" (vla-get-handle att)))
		   ((= 2 linkingOption) (kd:getfieldcode att))
		   (T (kd-get-TextString att))
		   )
		 )
	   )
	(getbattswcmatch obj "*")
	)
      )
    )
  );defun






;(setq tbl newcabls)
;(setq tag "handle")
(defun tbl|delcolumn (tbl tag / tmp col)
  (setq tmp (db|transmat tbl))
  (if (setq col (assoc tag tmp))
    (setq tmp (vl-remove col tmp))
    )
  (db|transmat tmp)
  );defun

(defun tbl|delcolumns (tbl tags)
  (if tags (tbl|delcolumns (tbl|delcolumn tbl (car tags)) (cdr tags)) tbl)
  );defun

(defun tbl|selectfrom (tbl par)
  (cond
    ((null par) (exit))
    ((and (= 'STR (type par)) (vl-string-search "," par 0))
     (tbl|selectfrom tbl (sepstr par ",")))
    ((and (= 'STR (type par)) (null  (vl-string-search "," par 0)))
     (tbl|selectfrom tbl (list par)))
    (T (db|transmat (vl-remove-if-not '(lambda (col) (member (car col) par)) (db|transmat tbl)))
     )
    )
  );defun
;(lst>excel (tbl|selectfrom tbl "PARAM,UNITS"))







;(db|glines "KKS=11HAC20CQ002")
;(setq fltr "KKS=11HAC20CQ002")
;# line db:data
(defun db|glines (fltr / p v)
  (setq p (sepstr fltr "=") v (cadr p) p (car p))
  (vl-remove-if-not '(lambda (line) (= (db|gpar p line) v)) (cdr db:data))
  );defun


; когда общая db:head в двух базах
;(db|glines "KKS=11HAC20CQ002")
;(setq fltr "KKS=11HAC20CQ002")
(defun db|filter (database fltr / p v)
  (setq p (sepstr fltr "=") v (cadr p) p (car p))
  (vl-remove-if-not '(lambda (line) (= (db|gpar p line) v)) database)
  );defun






; table = (head data1 data2 ... datan)
; fltr = "NUMBER=BJH40-2002"
;

;(setq str "POTENCIAL=A10;LOCATION=[MTR]")
;(setq table db)
(defun tbl|filter (table str / fr head data ans)
  (setq fr (vcfstr>data str))
  (if
    (and
      (setq head (car table) data (cdr table))
      (apply 'and (mapcar '(lambda (p) (member (car p) head)) fr))
      (setq ans (vl-remove-if-not '(lambda (line) (apply 'and (mapcar '(lambda (p) (= (tbl|gpar head line (car p)) (cadr p))) fr))) data))
      )
    (cons head ans)
    (db|transmat (mapcar '(lambda (h) (list h "*none*")) head))
    )
  );defun


	;		OLD
;;;; table = (head data1 data2 ... datan)
;;;; fltr = "NUMBER=BJH40-2002"
;;;(defun tbl|subfilter (table fltr / par val head data ans)
;;;  (if
;;;    (and
;;;      (setq par (sepstr fltr "=") val (cadr par) par (car par))
;;;      (setq head (car table) data (cdr table))
;;;      (member par head)
;;;      (setq ans (vl-remove-if-not '(lambda (line) (= val (tbl|gpar head line par))) data))
;;;      )
;;;    (cons head ans)
;;;    nil
;;;    )
;;;  );defun







;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;; выбор ближайшего значения из ряда
;(get-closer-from-row 31 '( 10 20 30 40 50 60 70 80 90))
(defun get-closer-from-row (val row / condidatelist tmp)
  ;(setq val 31 row '( 10 20 30 40 50 60 70 80 90))
  (if (and val row
	   (setq condidatelist (mapcar '(lambda (x) (abs (- val x))) row))
	   ;(setq tmp (eval (append '(min) condidatelist)))
	   (setq tmp (apply 'min condidatelist))
	   (setq tmp (nth (vl-position tmp condidatelist) row))
	)
    tmp
    )
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;; выбор по таблице вида:
;;; 	(	(x1	x2	x3 ...)
;;; 	(y1	(#	#	#  ...))
;;; 	(y2	(#	#	#  ...))
;;; 	(y3	(#	#	#  ...))
;;; 	...
;;;	)
(defun get-closer-from-table (x y lst)
  (nth
    (vl-position (get-closer-from-row x (car lst)) (car lst))
    (cadr
      (assoc
	(get-closer-from-row y (mapcar 'car (cdr lst)))
	(cdr lst)))
    )
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fill block attributes
;; заполнение аттрибутов блоков из файла екселя -> db:data
;(setq translator '("ID=ГП" "POZ=KKS" "PROP1=параметр" "PROP2=units"))
(defun db|fbatts (blk translator dataline)
  (mapcar
    '(lambda (par / tag xlp)
       (setq tag (sepstr par "=") xlp (cadr tag) tag (car tag))
       (vla-put-TextString (getbatt blk tag) (db|gpar xlp dataline))
       )
    translator
    )
  )
;;;;;;;; 			USING
;;;(db|getdata)
;;;(mapcar
;;;  '(lambda (x y)
;;;     (db|fbatts x '("ID=ГП" "POZ=KKS" "PROP1=параметр" "PROP2=units") y)
;;;     )
;;;  (ss->lsto* (ssget))
;;;  (cdr db:data)
;;;  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;(setq db:head (car (excel>lst)))
;(setq db:data (append '("table") (excel>lst)))
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;(setq str "interfacedata")
;(setq line (nth 11 db:data))
;;;  db:head - шапка таблицы db:data
;;;  line - строка из таблицы db:data
;;;  str - параметр из шапки

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun db|gpar (tag line / n res sep)	; # - db:head
  (if (null db:head) (exit))
  (if
    (or
      (setq n (vl-position tag db:head))
      (setq n (vl-position (strcase tag nil) db:head))
      (setq n (vl-position (strcase tag T) db:head))
      )
    (if line
      (setq res (nth n line))
      (progn (strcat "\n данные line пусты") (setq res nil))
      )
    (progn (princ (strcat "\n Не находится параметр " tag " в db:head")) (exit))
    )
  res
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun tbl|gpar (head line tag)
  (cond
    ((or (null head) (null line)(null tag)) nil)
    ((= (car head) tag) (car line))
    (T (tbl|gpar (cdr head) (cdr line) tag))
    )
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;(setq tag "cabinet")
;(setq val 6)
;line
(defun db|spar (line tag val / cl)	; # - db:head
  (if (null db:head) (exit))
  (setq cl (mapcar 'list db:head line))
  (setq cl (subst (list tag val) (assoc tag cl)cl))
  (mapcar 'cadr cl)
  );defun
;(db|spar line "clamp" 13)
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;(setq vallist '(("элсх" 2.0) ("KKS" "2HS-500") ("equipment" "Направляющий аппарат дымососа") ("монтсх" 2.0) ("place_field" "#Сборка") ("field_name" "BJH60, Ш3")))
(defun db|spars (line vallist / cl)	; # - db:head
  (if (null db:head) (exit))
  (setq cl (mapcar 'list db:head line))
  (mapcar '(lambda (pv) (setq cl (subst pv (assoc (car pv) cl) cl) )) vallist)
  (mapcar 'cadr cl)
  );defun
;(db|spars line vallist)
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


	; ХЗ не правильно
;;;(defun tbl|spar (head line vallist / cl)
;;;  ;(setq head  '("handle" "EFNAME" "NUMBER" "TYPE" "CORES" "CATEGORY" "LOCCAB" "LOCFLD" "SIGNALNAME" "VOLTAGE" "SECTION" "MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10" "MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20" "LENGTH" "CBL_FLD_HAND" "CBL_LST_HAND" "SIGN"))
;;;  ;(setq line '("AC01A" "cbl_cnct" "BJH40-2029" "КВВГнг" "7" "#CATEGORY#" "Шкаф контроллеров ШК20.2Б, 1K5" "Сборка РТЗО-88М. \"BJH40\"  Ш-4. Блок № 4. X4" "#SIGNALNAME#" "0,66" "1,5" "2.2-A7" "2.2-N" "2.2-A14" "2.2-A3" "2.2-A10" "2.2-A8" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "#LENGTH#" "#CBL_FLD_HAND#" "#CBL_LST_HAND#" "КВВГнг  7x1,5"))
;;;  ;(setq tag "EFNAME")
;;;  ;(setq val 6)
;;;  
;;;  (setq cl (mapcar 'list head line))
;;;  (mapcar '(lambda (pv) (setq cl (subst pv (assoc (car pv) cl) cl) )) vallist)
;;;  (mapcar 'cadr cl)
;;;  (setq cl (subst (list tag val) (assoc tag cl)cl))
;;;  (mapcar 'cadr cl)
;;;  );defun









;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun tbl|zip (tbl par / pvals)	;(setq tbl data)	(setq par "LOCSUB")
  (setq pvals (origlist (cdr (assoc par (db|transmat tbl)))))
  (mapcar
    '(lambda (v)	;(setq v (nth 12 pvals))
       (cons v (tbl|filter tbl (strcat par "=" v)))
       )
    pvals
    )
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;то же самое тлько с 1 шапкой, структурированной
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;(tbl|getdata 'tbl)
;;    ХРЕНЬ
;;;(defun tree|zip (tbl par / head body tmp res)	;(setq par "cabinet")
;;;  (setq body (cdr tbl) head (car tbl))
;;;  (if (atom (cadadr body))
;;;    (progn
;;;      (setq res nil)
;;;      (mapcar
;;;	'(lambda (line / val tmp)	;(setq line (nth 13 body))
;;;	   (setq val (nth (vl-position par head) line))
;;;	   (if (setq tmp (assoc val res))
;;;	     (progn
;;;	       (setq res (vl-remove tmp res))
;;;	       (setq tmp (reverse (cons (vl-remove val line) (reverse tmp))))
;;;	       (setq res (cons tmp res))
;;;	       )
;;;	     (setq res (cons (list val (vl-remove val line)) res))
;;;	     )
;;;	   )
;;;	body
;;;	)
;;;      (cons (list par (vl-remove par head)) res)
;;;      )
;;;    )
;;;  );defun

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(defun tbl|zip* (tbl pnl / lst pnlnums -pnlnums i variants)
  ;(setq tbl tbl|cables)	(setq pnl '("TYPE" "CORES" "SECTION"))
  (setq pnlnums (mapcar '(lambda (p) (vl-position p (car tbl))) pnl))

  (setq i -1)
  (while (< (setq i (1+ i)) (length (car tbl)))
    (if (null (member i pnlnums))
      (setq -pnlnums (cons i -pnlnums))
      )
    )
  
	
  (setq lst
	 (mapcar
	   '(lambda (line)	;(setq line (nth 13 (cdr tbl)))
	      (cons
		(antisep (mapcar '(lambda (n) (nth n line)) pnlnums) "|")
		line)
	      )
	   (cdr tbl)))

  ;(lst>excel lst)
  (setq variants (origlist (mapcar 'car lst)))

  (setq lst
  (mapcar
    '(lambda (v)
       (vl-remove-if-not
	 '(lambda (line)
	    (= v (car line))
	    )
	 lst
	 )
       )
    variants)
	)

  
  (setq
    lst
     (mapcar
       '(lambda (v / h)	;(setq v (nth 3 lst))
	  (setq h (cdr (car v)))
	  (setq h (mapcar '(lambda (a) (nth a h)) pnlnums))

	  (cons h
	  
	  (mapcar '(lambda (line)
		     (mapcar
		       '(lambda (-p)
			  (nth -p (cdr line))
		       )
		       -pnlnums
		       )
		     ) v))
	  )
       lst)
    )
  
  
  );defun




;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;  консолидирует таблицу db:data=("table" () ... () ) по указанному параметру str,  рекурсивная
(defun db|mapzip (lst parstr / head tail flag result)
  (if (null db:head)
    (if (listp (car lst))
      (setq db:head (car lst) flag T)
      (exit)
      )
    )
  ;(setq lst db:data)
  (if (atom (cadadr lst))
    (setq result (cons (car lst) (ziplist (mapcar '(lambda (xlsline) (list (db|gpar parstr xlsline) xlsline )) (cdr lst)))))
    (setq result (cons (car lst) (mapcar '(lambda (x) (db|mapzip x parstr)) (cdr lst))))
    )
  (if flag (setq db:head nil))
  result
  );defun
;;;(defun tbl|mapzip (tbl parstr / lst db:head)
;;;  (setq db:head (car tbl) lst (cdr tbl))
;;;  (cons db:head (db|mapzip lst parstr))
;;;  )
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun db|mapzip* (lst pnl / head tail) ;;;  pnl - parameter name list
  (if (null db:head) (exit))
  ;(setq lst db:data)
  (if (atom (cadadr lst))
    ;;;cons
    (append (list (car lst)) (ziplist
			       (mapcar
				 '(lambda (xlsline)
				    (list
				      (apply 'strcat (mapcar '(lambda (p) (db|gpar p xlsline)) pnl))
				      xlsline)
				    )
				 (cdr lst))))
    (append (list (car lst)) (mapcar '(lambda (x) (db|mapzip* x pnl)) (cdr lst)))
    )
  )
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX




;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun db|vcf>lst (par dataline)
  (if (null db:head) (exit))
  ;(cons par (vcfstr>data (db|gpar par dataline)))
  (append (list par) (vcfstr>data (db|gpar par dataline)))
  )
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX




;ХХХХХХХ преобразует упорядоченный список
;( 1 1 1   2 2   1 1   3 3   4   5   6   45   4 4   2 2 )
;((1 1 1) (2 2) (1 1) (3 3) (4) (5) (6) (45) (4 4) (2 2))
;;; использовал для организации кабелей в клеммнике с резервами -
;;; надо чтобы последователдьность реле не менялась и консолидировадись кабели

(defun db|zipsorted (db parstr / res)
  (if (null db:head) (exit))
  (foreach item (cdr db)
    (if (= (db|gpar parstr (car (last res))) (db|gpar parstr item))
      (setq res (subst (append (last res) (list item)) (last res) res))
      (setq res (append res (list (list item))))
      )
    )
  (cons (car db) (mapcar '(lambda (x) (cons (db|gpar parstr (car x)) x)) res))
  );defun

;(db|zipsorted db "cbl_KKS")




;  Объединяет подряд идущие одинаковые по определенному параметру записи
;  используется например для объединения записи кабелей при подключении к рядам зажимов
;(setq val (tbl|zipsorted tbl "cbl_KKS"))

(defun tbl|zipsorted (tbl parstr / head res)
  ;(setq res nil)
  (setq head (car tbl))
  (mapcar
    '(lambda (line)	;(setq line (nth 3 tbl))
       (if
	 (= (tbl|gpar head (car (car res)) parstr) (tbl|gpar head line parstr))
	 (setq res (subst (reverse (cons line (reverse (car res)))) (car res) res))
	 (setq res (cons (list line) res))
	 )
       )
    (cdr tbl)
    )
  (cons head (reverse (mapcar '(lambda (x) (cons (tbl|gpar head (car x) parstr) x)) res)))
  );defun






;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;ХХХХХХХ преобразует список выда  ((1 a) (2 f) (1 b) (2 t) ...)
;ХХХХХХХ вот в такой              ((1 (a b ...))(2 (f t..))...)
; т.е. объединяет по определенному параметру и создает список уровнем выше на 1
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun ziplist (lst / outlist tmp)
  (foreach p lst
    (setq tmp (assoc (car p) outlist))
    (if	tmp
      (setq outlist (subst (append tmp (cdr p)) tmp outlist))
      (setq outlist (append outlist (list p))))
    )
  outlist
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;      объединяет однотипный список по n-ному параметру
(defun zip (lst n / res)
  (mapcar
    '(lambda (x / tmp)
       (if (setq tmp (assoc (car x) res))
	 (setq res (subst (append tmp (cdr x)) tmp res))
	 (setq res (append res (list x)))
	 )
       )
    (mapcar '(lambda (x) (list (nth n x) x)) lst)
    )
  res
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(defun analize (lst / bill len)
  (setq bill '())
  (setq len (length lst))
  (mapcar
    '(lambda (item / pp)	;(setq item (nth 1 lst))
       (if (setq pp (assoc item bill))
	 (setq bill (subst
		      (list item (1+ (cadr pp)) (/ (+ 1.0 (cadr pp)) len))
		      pp bill))
	 (setq bill (cons (list item 1 (/ 1.0 len)) bill))
	 )
       )
    lst)
  bill
  );defun



;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;ХХХХХХХ Удаляет повторяющиеся элементы из одноуровнего списка
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;(setq lst '("1" "2" "1" "3" "4"))

(defun origlist (lst / ans)
  (mapcar
    '(lambda (x)
       (if (null (member x ans))
	 (setq ans (cons x ans))
	 )
       )
    lst)
  (reverse ans)
  );defun

(defun dwgru|origlist (w)
  (if w (cons (car w) (origlist (vl-remove (car w) w)))
    )
  );defun




(defun origlist* (lst / ans)
  (mapcar
    '(lambda (x)
       (cond
	 ((null (assoc x ans))
	  (setq ans (cons (list x 1) ans))
	  )
	 (T
	  (setq ans (subst (list (car (assoc x ans)) (1+ (cadr (assoc x ans)))) (assoc x ans) ans))
	  )
	 )
       )
    lst)
  (reverse ans)
  );defun


(defun dwgru|origlist* (w)
  ((lambda (tail)
     (if w (cons (cons (car w) (- (length w) (length tail))) (dwgru|origlist* tail)))
     )
    (vl-remove (car w) w)
    )
  );defun


;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(defun deoriglist (lst)
  (origlist
    (vl-remove 'nil
      (mapcar '(lambda (x) (if (member x  (cdr (member x lst))) x)) lst)
      )
    )
  );defun
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  

;(setq lst (list (car new) (car base)))
;(setq lst '(("a" "b" "c")("e" "f" "c" "a")))
(defun ANDlists (lst / ans)
  (mapcar
    '(lambda (item)
       (if (apply 'and (mapcar '(lambda (l) (member item l)) (cdr lst)))
	 (setq ans (cons item ans))
	 )
       )
    (car lst)
    )
  (reverse ans)
  );defun

(defun ORLists (lst)
  (origlist (apply 'append lst))
  );defun

;(defun XORLists (lst)
;  );defun




(defun db|diff (lst1 lst2 / l1 l2)
  (setq l1 nil l2 nil)
  (mapcar '(lambda (x) (if (null (member x lst2)) (setq l1 (cons x l1)))) lst1)
  (mapcar '(lambda (x) (if (null (member x lst1)) (setq l2 (cons x l2)))) lst2)
  (list l1 l2)
  )


;(setq rev2:table (tbl|blrefs>table (ss->lsto* (ssget))))
(defun tbl|sort (table tag / head data tagpoz)
  (setq head (car table))
  (setq data (vl-sort (cdr table) '(lambda (line1 line2) (< (tbl|gpar head line1 tag) (tbl|gpar head line2 tag)))))
  (cons head data)
  );defun



;;;;;;    вариант с "объектом" таблица:
;;;(= 2 (length anyTable))
;;;;  interface
;;;(setq anyTable (list (cons "tblHead" db:head) db:data))
;;;
;;;cbnt20:data