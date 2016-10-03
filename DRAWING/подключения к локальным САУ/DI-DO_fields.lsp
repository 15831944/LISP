; 14_07_29


(setq
  blkname:signal "cnct_signal-XP.dwg"
  blkname:clamp "cnct_subsystem_clamp.dwg"
  blkname:modul "cnct_subsystem.dwg"
  blkname:system "cnct_subsystem-name.dwg"
  blkname:cable "cbl_cnct"
  )



(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))
(load (strcat #lisppath "DataBase\\dblib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
(load (strcat #lisppath "Strings\\kd-sortstrings.LSP"))


(tbl|getdata 'tbl|data) (setq tbl|data (vl-remove-if '(lambda (line) (apply '= (cons "" line))) tbl|data))
(setq db:data (cons "table" (cdr tbl|data)) db:head (car tbl|data))

;     (setq db:data (cons "table" (db|formatdata (excel>lst))))

(tbl|getdata 'sysnames) (setq sysnames (vl-remove-if '(lambda (line) (apply '= (cons "" line))) sysnames))




(setq #dwg|signalbase '())
(setq #pt (getpoint) $pt #pt)













(defun akvasoft|cabinetsort (lst)
;;;  (defun clampformat (str / r c)
;;;    (setq c (sepstr str (cond ((wcmatch str "*XT*") "XT") ((wcmatch str "*K*") "K")))
;;;	  r (atoi (car c))
;;;	  c (atoi (cadr c))
;;;	  )
;;;    
;;;    (+ (* 1000 r) c)
;;;    )
  
  (if (null db:head) (exit))
   (vl-sort
     lst
     '(lambda (a b / clampA clampB)
	;(setq clampA (db|gpar "clamp" a) clampB (db|gpar "clamp" b))
	;(and
	;  (<= (atoi (vl-string-translate "АБ" "12" (cadr (sepstr (db|gpar "cabinet" a) ".")))) (atoi (vl-string-translate "АБ" "12" (cadr (sepstr (db|gpar "cabinet" b) ".")))))
	;  (<= (clampformat (db|gpar "clamp" a)) (clampformat (db|gpar "clamp" b)))
	;  (< (atoi (vl-string-subst "" "KL" (db|gpar "relay" a)))
	;     (atoi (vl-string-subst "" "KL" (db|gpar "relay" b))))
	;  )

	(< (atoi (db|gpar "cl1" a))
	   (atoi (db|gpar "cl1" b)))
	)
     )
  );defun
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







;(setq par "mark1")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun akvasoft|XLgen (par db / kks pval)
  (setq pval (db|gpar par db))
  (cond
    ((wcmatch par "*mark*")
     (setq kks (reverse (sepstr* (db|gpar "KKS" db))))
     (strcat (antisep (reverse (cddr kks)) "") " " (strcat (cadr kks) (car kks) pval))
     )
    ((wcmatch par "*place_field*")
     (cond
       ((= (db|gpar "place_field" (tr|extract db)) "$САУ") (strcat "САУ ХВО " (db|gpar "field_name" (tr|extract db))))
       ((= (db|gpar "place_field" (tr|extract db)) "$PLC") (strcat "Контроллер " (db|gpar "field_name" (tr|extract db))))
       ((= (db|gpar "place_field" (tr|extract db)) "$JBOX") (strcat "Коробка соединительная " (db|gpar "field_name" (tr|extract db))))
       ((= (db|gpar "place_field" (tr|extract db)) "$SENS") (strcat "Датчик " (db|gpar "field_name" (tr|extract db))))
       
       (T (db|gpar "place_field" (tr|extract db)))
       )
     )
    (T pval)
    );cond
  );defun




;(setq db (nth 3 db:data))
(defun gr|add-signal-XP (db / bobj str) ;$pt
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ $pt '(0 0 0))) (strcat #lisppath "!blocking\\connections\\" blkname:signal) 1 1 1 0))
  (vla-put-TextString (getbatt bobj "EVENT") (db|gpar "event" db))
  (vla-put-TextString (getbatt bobj "mark1") (akvasoft|XLgen "mark1" db))
  (vla-put-TextString (getbatt bobj "mark2") (akvasoft|XLgen "mark2" db))
  (vla-put-TextString (getbatt bobj "CL1") (db|gpar "cl1" db))
  (vla-put-TextString (getbatt bobj "CL2") (db|gpar "cl2" db))
  (setq #dwg|signalbase (cons bobj #dwg|signalbase))
  (setq $pt (mapcar '+ $pt '(0 -10 0)))
  bobj
  );defun

;(setq db (nth 1 (db|mapzip db:data "equipment")))
(defun gr|add-signals (db / height txtname txtnamewidth kks blks cnums)	;$pt
  (setq txtnamewidth 55)
  (setq height (* 10 (1- (length db))))
  (setq kks (sepstr* (db|gpar "KKS" (cadr db))))
  (setq txtname (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) txtnamewidth (strcat (nth 0 kks) (nth 1 kks) (nth 2 kks) (nth 3 kks) (nth 4 kks) "\n" (db|gpar "equipment" (cadr db)))))
  (vla-put-AttachmentPoint txtname 5)
  (vla-put-LineSpacingStyle txtname acLineSpacingStyleExactly)
  (vla-put-Height txtname 2.5)
  (vla-put-LineSpacingDistance txtname 3)
  (vla-addline #modspace (vlax-3D-point (mapcar '+ $pt (list -85 0 0))) (vlax-3D-point (mapcar '+ $pt (list -160 0 0))))
  (vla-addline #modspace (vlax-3D-point (mapcar '+ $pt (list -160 0 0))) (vlax-3D-point (mapcar '+ $pt (list -160 (- height) 0))))
  (vla-addline #modspace (vlax-3D-point (mapcar '+ $pt (list -160 (- height) 0))) (vlax-3D-point (mapcar '+ $pt (list -85 (- height) 0))))
  (vla-put-InsertionPoint txtname (vlax-3d-point (mapcar '+ $pt (list -122.5 (- (/ height 2))))))
  (setq blks (mapcar 'gr|add-signal-XP (cdr db)))
  (setq cnums (apply 'append (mapcar '(lambda (b) (list (vla-get-TextString (getbatt b "cl1")) (vla-get-TextString (getbatt b "cl2")))) blks)))
  (if (/= (length cnums) (length (origlist cnums)))
    (mapcar '(lambda (b) (vlax-put-property c "color" acYellow)) blks)
    )
  $pt
  );defun
;(gr|add-signals db)




;(setq db (nth 1 (db|mapzip db:data "clamp")))
(defun gr|add-clamp (db / bobj)
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ $pt '(0 0 0))) (strcat #lisppath "!blocking\\connections\\" blkname:clamp) 1 1 1 0))
  (vla-addline #modspace (vlax-3D-point (mapcar '+ $pt (list -160 0 0))) (vlax-3D-point (mapcar '+ $pt (list -160 -10 0))))
  (vla-put-TextString (getbatt bobj "CLAMP") (car db))
  (setq $pt (mapcar '+ $pt '(0 -10 0)))
  ;(mapcar 'gr|add-signals (cdr (db|mapzip db "equipment")))
  (mapcar 'gr|add-signals
	  (mapcar '(lambda (x) (list (db|gpar "equipment" (list x)) x)) (cdr db))
	  )
  );defun
;(gr|add-clamp db)




;(setq db (nth 1 (db|mapzip db:data "cabinet")))
(defun gr|add-cabinet (db / bobj)
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ $pt '(0 0 0))) (strcat #lisppath "!blocking\\connections\\" blkname:modul) 1 1 1 0))
  (vla-put-TextString (getbatt bobj "CABINET") (car db))
  (vla-put-TextString (getbatt bobj "NAME") "")
  (setq $pt (mapcar '+ $pt '(0 -15 0)))
  (mapcar 'gr|add-clamp (cdr (db|mapzip db "clamp")))
  (setq $pt (mapcar '+ $pt '(0 -15 0)))
  );defun




;(setq db (nth 1 (db|mapzip db:data "system")))
(defun gr|add-subsystem (db / bobj str)
  (setq str (cadr (assoc (car db) sysnames)))
  (setq str (vl-string-subst "Насосная станция " "НС " str))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ $pt '(0 0 0))) (strcat #lisppath "!blocking\\connections\\" blkname:system) 1 1 1 0))
  (vla-put-TextString (getbatt bobj "NAME") (strcat (car db) "\n" str))
  (mapcar 'gr|add-cabinet (cdr (db|mapzip db "cabinet")))
  (setq $pt (mapcar '+ $pt '(0 -30 0)))
  );defun





;(setq db (nth 1 (db|mapzip db:data "cbl_KKS")))
(defun gr|add-cable (db / bobj marks s-blks conncolor plankcolor bridgestep cabstartX inspts nepodradsigsY i)	;#dwg|signalbase
  (setq bridgestep 1.5)
  (setq cabstartX 100)
  (setq db:marks (apply 'append (mapcar '(lambda (s) (list (akvasoft|XLgen "mark1" s) (akvasoft|XLgen "mark2" s))) (cdr db))))
  (setq s-blks (vl-remove-if-not '(lambda (blk) (or (member (vla-get-TextString (getbatt blk "mark1")) db:marks) (member (vla-get-TextString (getbatt blk "mark2")) db:marks))) #dwg|signalbase))
  (if (/= (length db:marks) (* 2 (length s-blks))) (exit))
  ;(sssetfirst nil (lst-to-ss s-blks))
  (setq inspts (mapcar '(lambda (b) (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))s-blks))
  (setq nepodradsigsY (vl-remove-if '(lambda (b) (or (> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))) (apply 'max (mapcar 'cadr inspts)) ) (< (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))) (apply 'min (mapcar 'cadr inspts))))) #dwg|signalbase))

  ;проверка на наличие перемычек
  (cond
    ((null (equal '("") (origlist (cdr (assoc "jumpers" (db|transmat (cons db:head (cdr db))))))))
     (setq conncolor acYellow))
    (T (setq conncolor acByLayer))
    )
  ;проверка на сигналы идущие не подряд в клеммнике
  (cond
    ((/= (length nepodradsigsY) (length s-blks))
     (setq plankcolor acRed))
    (T (setq plankcolor acByLayer))
    )
  
  (mapcar
    '(lambda (bip / lin)
       (setq lin (vla-addline #modspace (vlax-3D-point (mapcar '+ bip (list 0 -2.5 0))) (vlax-3D-point (mapcar '+ bip (list (* 2 bridgestep) -2.5 0))))) (vlax-put-property lin "color" conncolor)
       (setq lin (vla-addline #modspace (vlax-3D-point (mapcar '+ bip (list 0 -7.5 0))) (vlax-3D-point (mapcar '+ bip (list (* 2 bridgestep) -7.5 0))))) (vlax-put-property lin "color" conncolor)
       )
    inspts
    )


  (setq lin (vla-addline #modspace
	      (vlax-3D-point (list (+ (car (car inspts)) (* 2 bridgestep))(- (apply 'max (mapcar 'cadr inspts)) 2.5)0))
	      (vlax-3D-point (list (+ (car (car inspts)) (* 2 bridgestep))(- (apply 'min (mapcar 'cadr inspts)) 7.5)0))
	      ))
  (vlax-put-property lin "color" plankcolor)
  (vlax-put-property lin "LineWeight" 40)


  ;блок
  (setq	bobj (vla-InsertBlock #modspace (vlax-3D-point (list (+ (car (car inspts)) (* 2 bridgestep) cabstartX) (- (apply 'max (mapcar 'cadr inspts)) 5) 0)) blkname:cable 1 1 1 0))
  (vla-put-Value (getbdyn bobj "cableSide") (vlax-make-variant 1 vlax-vbInteger))
  (vla-put-Value (getbdyn bobj "cabDist") (vlax-make-variant (- cabstartX 30) 5))
  (vla-put-Value (getbdyn bobj "shldDist") (vlax-make-variant (- (- cabstartX 30) 10 ) 5))
  (vla-put-TextString (getbatt bobj "NUMBER") (car db))
  (vla-put-TextString (getbatt bobj "TYPE") (setq ctype (db|gpar "cab_type" (tr|extract db))))
  (vla-put-TextString (getbatt bobj "CORES") (db|gpar "cores" (tr|extract db)))
  (if (null (wcmatch (setq sect (db|gpar "section" (tr|extract db))) "*[`.`,]*")) (setq sect (strcat sect ",0")))
  (vla-put-TextString (getbatt bobj "SECTION") sect)
  (vla-put-TextString (getbatt bobj "LOCFLD") (akvasoft|XLgen "place_field" (tr|extract db)))
  (vla-put-TextString (getbatt bobj "LOCCAB") (strcat (cadr (assoc (db|gpar "system" (tr|extract db)) sysnames)) ", " (db|gpar "cabinet" (tr|extract db)) ", " (db|gpar "clamp" (tr|extract db))))
  (vla-put-Textstring (getbatt bobj "SIGN") (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (getbatt bobj "TYPE"))) ">%).TextString>%" "  " "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (getbatt bobj "CORES"))) ">%).TextString>%" "x" "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (getbatt bobj "SECTION"))) ">%).TextString>%"))
  (if
    (member ctype '("ВВГнг-LS"))
    (vla-put-Value (getbdyn bobj "Shielding") "БезЭкрана")
    (vla-put-Value (getbdyn bobj "Shielding") "Экран")
    )
  (setq i 0) (mapcar '(lambda (x) (vla-put-TextString (getbatt bobj (strcat "MARK" (itoa (setq i (1+ i))))) x)) (origlist db:marks))
  );defun








(setq db:head (car (excel>lst)))




(setq db:data (cons "table" (akvasoft|cabinetsort (db|formatdata (excel>lst)))))





(setq #dwg|signalbase '())
(setq #pt (getpoint) $pt #pt)
(gr|add-subsystem (nth 1 (db|mapzip db:data "system")))
(mapcar 'gr|add-cable (cdr (db|mapzip db:data "cbl_KKS")))



























(defun gr|add-cable (db / bobj ctype tmp sect marksincable modmarks connectedcores i stype thiscable iscableelsewere bridges cabstartX cablevel bridgestep)
  (setq bridgestep 1.5)
  (setq cabstartX 100)		; длина блока кабель

  ; если кабель встречается в базе еще где-нить, кроме этого клеммника
  ; помечаем желтый флаг, и добавляем в список для контроля, если еще не в нем
  (setq thiscable (assoc (car db) (cdr (db|mapzip db:data "cbl_KKS"))))
  (if (/= (length thiscable) (length db)) (progn (setq iscableelsewere T) (if (null (member (car db) #cables-to-consolidate)) (setq #cables-to-consolidate (cons (car db) #cables-to-consolidate)))))


  (setq stype (db|gpar "sign_type" (tr|extract db)))
  

  

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
	   ((= stype "ТСП") (list (db|genmarkforcad "mark1" s) (db|genmarkforcad "mark2" s) (db|genmarkforcad "mark3" s)))
	   ((= stype "ТСП4") (list (db|genmarkforcad "mark1" s) (db|genmarkforcad "mark2" s) (db|genmarkforcad "mark3" s) (db|genmarkforcad "mark4" s)))
	   (T (list (db|genmarkforcad "mark1" s) (db|genmarkforcad "mark2" s)))
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
	 ;пкркмычка
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
     (vla-addline #modspace
       (vlax-3D-point (mapcar '+ pt (list (- cablevel) -2.5 0)))
       (vlax-3D-point (mapcar '+ pt (list
				   (- cablevel)
				   (- (+ 2.5 (* 5 (vl-position (last
								 ;(origlist modmarks)
								 (vl-remove "" (origlist modmarks))
								 ) modmarks))))
				   0)))
    )
     )
  ;блок
  (setq	bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt (list (- cabstartX) -5 0))) (strcat #lisppath "!blocking\\cablelist\\cbl_cnct.dwg") 1 1 1 0))
  (vla-put-Value (getbdyn bobj "cabDist") (vlax-make-variant (- (- cabstartX 30) cablevel) 5))
  (vla-put-Value (getbdyn bobj "shldDist") (vlax-make-variant (- (- cabstartX 30) 20 ) 5))
  (vla-put-TextString (getbatt bobj "NUMBER") (car db))
  (vla-put-TextString (getbatt bobj "TYPE") (setq ctype (db|gpar "cab_type" (tr|extract db))))
  (vla-put-TextString (getbatt bobj "CORES") (db|gpar "cores" (tr|extract db)))
  (if (null (wcmatch (setq sect (db|gpar "section" (tr|extract db))) "*[`.`,]*")) (setq sect (strcat sect ",0")))
  (vla-put-TextString (getbatt bobj "SECTION") sect)
  (if iscableelsewere (vlax-put-property bobj "color" 2))
  ; заполняем аттрибуты
  (vla-put-TextString (getbatt bobj "LOCFLD")
    (cond
      ; если составное и подразумевает склеивание других параметров
      ((= (db|gpar "place_field" (tr|extract db)) "#Сборка")	(strcat "Сборка задвижек " (db|gpar "field_name" (tr|extract db))))
      ((= (db|gpar "place_field" (tr|extract db)) "#Стенд")	(strcat "Стенд датчиков " (db|gpar "field_name" (tr|extract db))))
      ((= (db|gpar "place_field" (tr|extract db)) "#БЭЗ")	(strcat "БЭЗ поз. " (db|gpar "KKS" (tr|extract db))))
      ((= (db|gpar "place_field" (tr|extract db)) "#КСпривода")	(strcat "КС привода поз. " (db|gpar "KKS" (tr|extract db))))
      ((= (db|gpar "place_field" (tr|extract db)) "#Датчик")	(strcat "Датчик поз. " (db|gpar "KKS" (tr|extract db))))
      ((= (db|gpar "place_field" (tr|extract db)) "#КС")	(strcat "Коробка соединительная " (db|gpar "field_name" (tr|extract db))))
      ; если уже заполненная графа
      (T (db|gpar "place_field" (tr|extract db)))
      )
    )
  (vla-put-TextString (getbatt bobj "LOCCAB") (strcat "Шкаф контроллеров " (db|gpar "cabinet" (tr|extract db)) ", " (db|gpar "clamp" (tr|extract db))))
  (vla-put-Textstring (getbatt bobj "SIGN") (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (getbatt bobj "TYPE"))) ">%).TextString>%" "  " "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (getbatt bobj "CORES"))) ">%).TextString>%" "x" "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (getbatt bobj "SECTION"))) ">%).TextString>%"))
  (if
    (or
      (member ctype '("КВВГЭнг" "КВВГЭ" "КВВГЭнг-LS"))
      (wcmatch sect "*Э*")
      )
      (vla-put-Value (getbdyn bobj "Shielding") "Экран")
    (vla-put-Value (getbdyn bobj "Shielding") "БезЭкрана"))
  ;;;  заполняем аттрибуты марок кабеля
  (setq i 0) (mapcar '(lambda (x) (vla-put-TextString (getbatt bobj (strcat "MARK" (itoa (setq i (1+ i))))) x)) (origlist modmarks))
  )
    ) ; if is cable (если есть подключения)

  (cond
    ((member stype '("420AI" "420AI+" "420AO"))
     (mapcar 'gr|add-signalAI (cdr db))
     )
    ((member stype '("ТСП"))
     (mapcar 'gr|add-signalTSP (cdr db))
     )
    ((member stype '("220DI" "220DIСК" "220DO" "220DOСК" "24DI" "24DI-" "DINO" "DINC" "24DIСК" "24DO" "24DOСК" "DO"))
     (mapcar 'gr|add-valve (cdr (db|mapzip db "KKS")))
     )
    (T (princ (strcat "\n gr|add-cable: неизвестный тип сигнала - \"" stype "\"")))
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(gr|add-valve db)
;(setq pt (getpoint))
;(setq db (nth 1 (nth 2 lst2)))
;(setq db (nth 1 (nth 4 (nth 8 (nth 1 lst4)))))



;(setq db (assoc "LFC52AA001" (cdr (db|mapzip db:data "KKS"))))
;(setq pt (getpoint)) (gr|add-valve db)

(defun gr|add-valve (db / height txtkks txtname lo)
  (setq height (* 10 (1- (length db))))
  
  (setq txtkks (vla-Addtext #modspace (car db) (vlax-3d-point '(0 0 0)) 2.5))
  (vla-put-Alignment txtkks 10)
  (vla-put-Rotation txtkks 1.5708)


 
  (if (> (* 2.3 (strlen (car db))) (* 10 (1- (length db))))
    (vla-put-ScaleFactor txtkks 0.8)
    )
      
  (setq txtname (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) 45 (db|gpar "equipment" (cadr db))))
  (vla-put-AttachmentPoint txtname 5)
  (vla-put-LineSpacingStyle txtname acLineSpacingStyleExactly)
  (vla-put-Height txtname 2.5)
  (vla-put-LineSpacingDistance txtname 3.5)
  
  (if (= #smezhniki "belov")
    (progn
      (vla-addline #modspace (vlax-3D-point (mapcar '+ pt (list 96 0 0))) (vlax-3D-point (mapcar '+ pt (list 160 0 0))))
      (vla-addline #modspace (vlax-3D-point (mapcar '+ pt (list 96 (- height) 0))) (vlax-3D-point (mapcar '+ pt (list 160 (- height) 0))))
      (setq lo (vla-addline #modspace (vlax-3D-point (mapcar '+ pt (list 160 0 0))) (vlax-3D-point (mapcar '+ pt (list 160 (- height) 0)))))
      (vla-put-lineweight lo 60)
      (setq lo (vla-addline #modspace (vlax-3D-point (mapcar '+ pt (list 106 0 0))) (vlax-3D-point (mapcar '+ pt (list 106 (- height) 0)))))
      (vla-put-lineweight lo 60)
      (vla-put-TextAlignmentPoint txtkks (vlax-3d-point (mapcar '+ pt (list 101 (- (/ height 2))))))
      (vla-put-InsertionPoint txtname (vlax-3d-point (mapcar '+ pt (list 133 (- (/ height 2))))))
      )
    
    (progn
      (vla-addline #modspace (vlax-3D-point (mapcar '+ pt (list 100 0 0))) (vlax-3D-point (mapcar '+ pt (list 160 0 0))))
      (vla-addline #modspace (vlax-3D-point (mapcar '+ pt (list 100 (- height) 0))) (vlax-3D-point (mapcar '+ pt (list 160 (- height) 0))))
      (vla-addline #modspace (vlax-3D-point (mapcar '+ pt (list 160 0 0))) (vlax-3D-point (mapcar '+ pt (list 160 (- height) 0))))
      (vla-addline #modspace (vlax-3D-point (mapcar '+ pt (list 108 0 0))) (vlax-3D-point (mapcar '+ pt (list 108 (- height) 0))))
      (vla-put-TextAlignmentPoint txtkks (vlax-3d-point (mapcar '+ pt (list 104 (- (/ height 2))))))
      (vla-put-InsertionPoint txtname (vlax-3d-point (mapcar '+ pt (list 134 (- (/ height 2))))))
      )
    );if
    
  (mapcar 'gr|add-signalDI (cdr db))
  );defun
;(gr|add-valve db)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;











;(setq db '("ШВО.5А" "K7" "KL1" "11" "14" "220DO" "A12" "A11" "BJH50-2502" "2LAB51AA001" "Открыть" "Клапан запорный № 1 на основной  линии узла питания котла" "КВВГнг" "14" "1,5" "#Сборка" "BJH50, Ш2" ""))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signalDI (db / bobj str)
  (if (= #smezhniki "belov")   ;belov
    (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) (strcat #lisppath "!blocking\\controller\\belov_controller_D.dwg") 1 1 1 0))   ;belov
    (cond
      ((member (db|gpar "sign_type" db) '("220DI" "220DIСК" "24DI" "24DIСК" "24DI-" "DINC" "DINO"))	(setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) (strcat #lisppath "!blocking\\controller\\controller_DI.dwg") 1 1 1 0)))
      ((member (db|gpar "sign_type" db) '("220DOСК" "24DOСК" "24DO" "220DO" "DO")) 		(setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) (strcat #lisppath "!blocking\\controller\\controller_DO.dwg") 1 1 1 0)))
      )
    )   ;belov
  
  ;(vla-put-TextString (getbatt bobj "RELAY") (db|gpar "relay" db))
  
  (vla-put-TextString (getbatt bobj "КОМАНДА") (db|gpar "event" db))
  (vla-put-TextString (getbatt bobj "mark1") (db|genmarkforcad "mark1" db))
  (vla-put-TextString (getbatt bobj "mark2") (db|genmarkforcad "mark2" db))
  (if (= #smezhniki "belov")   ;belov
    (progn   ;belov
      (vla-put-TextString (getbatt bobj "CL1") (db|gpar "cl1" db))   ;belov
      (vla-put-TextString (getbatt bobj "CL2") (db|gpar "cl2" db))   ;belov
      )   ;belov
    )   ;belov
  (setq pt (mapcar '+ pt '(0 -10 0)))
  );defun
;(gr|add-signalDI db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signalAI (db / bobj)
  (if (= #smezhniki "belov")
    (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) (strcat #lisppath "!blocking\\controller\\belov_controller_AI420.dwg") 1 1 1 0))
    (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) (strcat #lisppath "!blocking\\controller\\controller_AI420.dwg") 1 1 1 0))
    )
  ;("CLAM2" "CLAM1" "MARK2" "MARK1" "KKS" "MEAS_NAME") 
  (vla-put-TextString (getbatt bobj "meas_name") (db|gpar "meas_name" db))
  (vla-put-TextString (getbatt bobj "KKS") (db|gpar "KKS" db))
  (vla-put-TextString (getbatt bobj "cl1") (db|gpar "cl1" db))
  (vla-put-TextString (getbatt bobj "cl2") (db|gpar "cl2" db))
  (vla-put-TextString (getbatt bobj "mark1") (db|genmarkforcad "mark1" db))
  (vla-put-TextString (getbatt bobj "mark2") (db|genmarkforcad "mark2" db))
  (setq pt (mapcar '+ pt '(0 -10 0)))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signalTSP (db / bobj)
  (if (= #smezhniki "belov")
    (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) (strcat #lisppath "!blocking\\controller\\belov_controller_TSP.dwg") 1 1 1 0))
    (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) (strcat #lisppath "!blocking\\controller\\controller_TSP.dwg") 1 1 1 0))
    )
  ;("CLAM2" "CLAM1" "MARK2" "MARK1" "KKS" "MEAS_NAME") 
  (vla-put-TextString (getbatt bobj "meas_name") (db|gpar "meas_name" db))
  (vla-put-TextString (getbatt bobj "KKS") (db|gpar "KKS" db))
  (vla-put-TextString (getbatt bobj "cl1") (db|gpar "cl1" db))
  (vla-put-TextString (getbatt bobj "cl2") (db|gpar "cl2" db))
  (vla-put-TextString (getbatt bobj "cl3") (db|gpar "cl3" db))
  (vla-put-TextString (getbatt bobj "mark1") (db|genmarkforcad "mark1" db))
  (vla-put-TextString (getbatt bobj "mark2") (db|genmarkforcad "mark2" db))
  (vla-put-TextString (getbatt bobj "mark3") (db|genmarkforcad "mark3" db))
  (setq pt (mapcar '+ pt '(0 -15 0)))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun db|genmarkforcad (mark db / str)
    ;(setq markparamname "mark1")
    ;(setq mark (db|gpar markparamname db))
    ;(setq mark "76")
  (setq str (db|gpar mark db))
  (setq str
	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (cond
      ( (and
	  (member str '("1" "2" "3" "4"       "16" "18"))
	  (db|gpar "KKS" db)
	  )
       (strcat (db|gpar "KKS" db) "-" str))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ( (and
	  (member str '("-1" "-2" "-3" "-4"  "-16" "-18"))
	  (db|gpar "KKS" db)
	  )
       (strcat (db|gpar "KKS" db) str))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ( (and
	  (member str '("16-" "16+" "18-" "18+"))
	  (db|gpar "KKS" db)
	  )
       (strcat (db|gpar "KKS" db) "-" (strcut str 0 -1)))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;для марок электрических схем задвижек
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ( (and
	   (or
	     (wcmatch str "A*")
	     (wcmatch str "N*")
	     (wcmatch str "*c")
	     )
	   (db|gpar "KKS" db)
	   )
       (strcat (db|gpar "KKS" db) "-" str))
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ( (and
	   (> (atoi str) 0)
	   (< (atoi str) 100)
	   (/= "" (db|gpar "KKS" db))
	   )
       (strcat (db|gpar "KKS" db) "-" str))
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(defun gr|add-bridge (pt / obj)
;;;  (vla-addline #modspace (vlax-3D-point (mapcar '+ pt '(0 -7.5 0))) (vlax-3D-point (mapcar '+ pt '(-1.5 -6.5 0))))
;;;  (vla-addline #modspace (vlax-3D-point (mapcar '+ pt '(-1.5 -6.5 0))) (vlax-3D-point (mapcar '+ pt '(-1.5 1.5 0))))
;;;  (vla-addline #modspace (vlax-3D-point (mapcar '+ pt '(-1.5 1.5 0))) (vlax-3D-point (mapcar '+ pt '(0 2.5 0))))
;;;  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












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
(defun getcableline (obj / sset result pt)
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
  (if (/= (vla-get-TextString (getbatt objlink "NUMBER")) (vla-get-TextString (getbatt objmain "NUMBER")))
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
  (if (null (apply '= (mapcar '(lambda (x) (vla-get-TextString (getbatt x "NUMBER"))) (cons objmain links)))) (progn (princ (strcat "\nРазные номера кабелей")) (exit)))
  
  (setq marksinmain (mapcar 'vla-get-TextString (vl-remove-if    '(lambda (att) (= "" (vla-get-TextString att))) (getbattswcmatch objmain "MARK*"))))
  (setq markstoadd (vl-remove-if '(lambda (att) (or (= "" (vla-get-TextString att)) (member (vla-get-TextString att) marksinmain))) (apply 'append (mapcar '(lambda (x) (getbattswcmatch x "MARK*")) links))))
  (setq enptymarks (vl-remove-if-not '(lambda (att) (= "" (vla-get-TextString att))) (getbattswcmatch objmain "MARK*")))
  (if (> (length enptymarks) (length markstoadd)) (mapcar '(lambda (ato mrk) (vla-put-TextString ato (vla-get-TextString mrk)) (vla-put-TextString mrk "")) enptymarks markstoadd))
  (mapcar
    '(lambda (x / cpt arpt ar txto)
       (setq mainaddrstr (cons (last (sepstr (vla-get-TextString (getbatt x "LOCCAB")) " ")) mainaddrstr))
       (setq cpt (blk|getendpoint x))
       (setq arpt (mapcar '+ cpt '(-25 0 0)))
       (vla-addline #modspace (vlax-3d-point cpt) (vlax-3d-point arpt))
       (vla-InsertBlock #modspace (vlax-3d-point arpt) (strcat #lisppath "!blocking\\arrow.dwg") 1 1 1 Pi)
       (setq txto (vla-Addtext #modspace (strcat "В кабель " (vla-get-TextString (getbatt objmain "NUMBER")) ", см. "(last (sepstr (vla-get-TextString (getbatt objmain "LOCCAB")) " "))) (vlax-3d-point '(0 0 0))2.5))
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
  (setq cnum (vla-get-TextString (getbatt obj "NUMBER")))
  (setq lst (vl-remove-if-not '(lambda (x) (if (= (type (vl-catch-all-apply 'vla-ObjectIDToObject (list #actdoc (vla-get-ObjectID x)))) 'VLA-OBJECT)
					     (= cnum (vla-get-TextString (getbatt x "NUMBER")))
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
(mapcar '(lambda (x) (vla-get-TextString (getbatt x "NUMBER"))) lst)
(length (origlist (mapcar '(lambda (x) (norus (vla-get-TextString (getbatt x "NUMBER")))) lst)))




;; проверка на повторение НОМЕРОВ кабелей - origlist
(setq lst (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))
(setq lst (vl-remove-if-not '(lambda (x) (= "cbl_lst" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))
(length lst)

(setq lst (mapcar '(lambda (x) (vla-get-TextString (getbatt x "NUMBER"))) lst))
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
     (setq destatt (getbatt cab "LOCFLD"))
     (setq l (length (VL-STRING->LIST (vla-get-TextString destatt))))
     (cond
       ((diap l 50 56) (vla-put-ScaleFactor destatt 0.9))
       ((diap l 56 65)       (vla-put-ScaleFactor destatt 0.8))
       (T (princ))
       )
     )
  lst
  )