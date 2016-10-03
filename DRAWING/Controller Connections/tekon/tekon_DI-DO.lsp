;;; 15_03_17



структура

	ШКАФ : 06CAB01
		МОДУЛЬ : [24] A1-24 DI32 {T1 T2}
			CABLE
				SIGNAL





;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
;(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))



(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))
(load (strcat #lisppath "DataBase\\dblib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
(load (strcat #lisppath "Strings\\kd-sortstrings.LSP"))

(defun db|cabinetsort (lst)
  (defun clampformat (str / r c) (setq c (sepstr str (cond ((wcmatch str "*XT*") "XT") ((wcmatch str "*K*") "K"))) r (atoi (car c)) c (atoi (cadr c))) (+ (* 1000 r) c))
  (if (null db:head) (exit))
   (vl-sort
     lst
     '(lambda (a b / clampA clampB)
	(setq clampA (db|gpar "clamp" a) clampB (db|gpar "clamp" b))
	(and
	  (<= (atoi (vl-string-translate "АБ" "12" (cadr (sepstr (db|gpar "cabinet" a) ".")))) (atoi (vl-string-translate "АБ" "12" (cadr (sepstr (db|gpar "cabinet" b) ".")))))
	  (<= (clampformat (db|gpar "clamp" a)) (clampformat (db|gpar "clamp" b)))
	  (< (atoi (vl-string-subst "" "KL" (db|gpar "relay" a)))
	     (atoi (vl-string-subst "" "KL" (db|gpar "relay" b))))
	  )))
  );defun







;(setq #smezhniki nil)
(setq #smezhniki "tekon")

;;;(defun db|mapzip (lst parstr / head tail)
;;;  ;(setq lst db:data)
;;;  (if (atom (cadadr lst))
;;;    (append (list (car lst)) (ziplist (mapcar '(lambda (xlsline) (list (db|gpar parstr xlsline) xlsline ))(cdr lst))))
;;;    (append (list (car lst)) (mapcar '(lambda (x) (db|mapzip x parstr)) (cdr lst)))
;;;    )
;;;  )



;;;  в excel сортируем : sign_type - N кабеля - KKS - mark1 - mark2
;;;  это если подключения не давали



(db|getdata 'db:head 'db:data)


(length (cdr db:data))


(setq db:head (car (excel>lst)))

(setq db:data (cons "table" (db|formatdata (excel>lst))))










;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;модуль



(setq cabinets (db|mapzip db:data "CABINET"))
(length cabinets)



(setq #blk:cbl:name "act_mnt_cbl-outer")
(setq #cables-to-consolidate nil)
(length #cables-to-consolidate)




(setq cabinet (db|filter (cdr db:data) "CABINET=06CAB01"))
(setq cabinet (db|filter (cdr db:data) "CABINET=06CDB01"))
(setq cabinet (db|filter (cdr db:data) "CABINET=06CGB01"))


(setq moduls (db|mapzip* (cons "table" cabinet) '("T1" "T2")))
(length moduls)


(setq pt (getpoint))


(mapcar
  '(lambda (m / endpt)
     (setq endpt (gr|add-modul pt m))
     (setq pt (mapcar '+ pt '(302 0 0)))
     )
  (cdr moduls)
  )







;(gr|add-modul (getpoint) modul)

(defun gr|add-modul (cpt modul / bobj T1 T2 modtype)
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ cpt '(0 0 0))) "MODUL_HEAD" 1 1 1 0))
  (setq cpt (mapcar '+ cpt '(0 -10 0)))
  (setq T1 (db|gpar "T1" (tr|extract modul)))
  (setq T2 (db|gpar "T2" (tr|extract modul)))
  (setq modtype (db|gpar "MOD_TYPE" (tr|extract modul)))
  (vla-put-TextString (getbatt bobj "T1+T2+MOD_TYPE") (strcat "[" (if (= 1 (strlen T2)) (strcat "0" T2) T2)"] " T1 "-" T2 " " modtype))
  (vla-put-TextString (getbatt bobj "CL_TYPE") (db|gpar "CL_TYPE" (tr|extract modul)))
  (mapcar
    '(lambda (cabline / res)	;(setq cabline (nth 1 (cdr (db|zipsorted (cons (car modul) (vl-sort (cdr modul) '(lambda (a b) (< (atoi (db|gpar "MOD_NUM" a)) (atoi (db|gpar "MOD_NUM" b)))))) "CBL_KKSID"))))
       (setq cpt (gr|add-cable cpt cabline))
       )
    (cdr (db|zipsorted (cons (car modul) (vl-sort (cdr modul) '(lambda (a b) (< (atoi (db|gpar "MOD_NUM" a)) (atoi (db|gpar "MOD_NUM" b)))))) "CBL_KKSID"))
    )
  cpt
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;










;(setq cpt (getpoint))
;(setq db cabline)
(defun gr|add-cable (cpt db /
		     bobj ctype tmp sect marksincable modmarks connectedcores i stype thiscable iscableelsewere bridges cabstartX cablevel bridgestep
		     clams
		     clpt cspt
		     )

  (setq clpt cpt)
  (setq clams (mapcar
		'(lambda (sig / ans)	;(setq sig (nth 0 (cdr db)))

		   (cond
		     ((= "TCB04" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-TCB04 clpt sig)))
		     ((= "TCB08HD2" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-TCB08HD2 clpt sig)))
		     ((= "TCC2AI16" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-TCC2AI16 clpt sig)))
		     ((= "TCC4PW" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-TCC4PW clpt sig)))
		     ((= "TCC4LT" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-TCC4LT clpt sig)))
		     
		     ((= "TCC8L" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-TCC8L clpt sig)))
		     ((= "TCC8-220AC2" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-TCC8-220AC2 clpt sig)))
		     ((= "TCC8-220DCI2" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-TCC8-220DCI2 clpt sig)))
		     
		     ((= "WAGO 280-519 (DI48-24М)" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-WAGO-280-519 clpt sig)))
		     ((= "WAGO 280-833 (DI16-220)" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-WAGO-280-833 clpt sig)))
		     ((= "WAGO 280-549 (DO24r)" (db|gpar "CL_TYPE" (tr|extract db))) (setq ans (gr|add-signal-WAGO-280-549 clpt sig)))
     
		     )
		   ;(setq sig (car (excel>lst))) (gr|add-signal-WAGO-280-833 (getpoint) sig)

		   
		   ;(setq ans (apply (read (strcat "gr|add-signal-" (db|gpar "CL_TYPE" (tr|extract db)))) (list clpt sig)))
		   (setq clpt (mapcar '+ clpt (list 0 (* (length ans) -5) 0)))
		   ans
		   )
		(cdr db)
		)
	)



  (setq bridgestep 1.5)
  (setq cabstartX 85)		; длина блока кабель

  ; если кабель встречается в базе еще где-нить, кроме этого клеммника
  ; помечаем желтый флаг, и добавляем в список для контроля, если еще не в нем
  (setq thiscable (assoc (car db) (cdr (db|mapzip db:data "CBL_KKSID"))))
  (setq iscableelsewere nil)
  (if (/= (length thiscable) (length db))
    (progn
      (setq iscableelsewere T)
      (if
	(null (member (car db) #cables-to-consolidate))
	(setq #cables-to-consolidate (cons (car db) #cables-to-consolidate))
	))
    )

  ; если кабель не пустой, отрисовываем соединения и вставляем блок
  (if (/= "" (car db))
    (progn

      ; то что на модуле, полностью все марки в пределах данного кабеля
;;;      (setq modmarks (apply 'append (mapcar '(lambda (s / kks)
;;;					    (setq kks (db|gpar "KKS" s))
;;;					    (mapcar '(lambda (x) (strcat kks "-" x)) (vl-remove "" (list (db|gpar "M1" s) (db|gpar "M2" s) (db|gpar "M3" s)(db|gpar "M4" s))))
;;;					    ) (cdr db))))
      (setq modmarks (apply 'append clams))
      (setq marksincable (vl-remove "" (origlist modmarks)))	;;  то что в жилах кабеля, без повторений
      ;(setq i 0) (mapcar '(lambda (x) (vla-put-TextString (getbatt bobj (strcat "MARK" (itoa (setq i (1+ i))))) x)) marksincable)

      (setq connectedcores '())
      (setq cstpt (mapcar '+ cpt '(0 -2.5 0)))

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
      (setq connectedcores (vl-remove "" connectedcores))

      ;планка
      (if (vl-remove "" (origlist modmarks))
	(vla-addline #modspace
	  (vlax-3D-point (mapcar '+ cpt (list (- cablevel) -2.5 0)))
	  (vlax-3D-point (mapcar '+ cpt (list (- cablevel) (- (+ 2.5 (* 5 (vl-position (last
											 (vl-remove "" (origlist modmarks))
											 ) modmarks))))
					      0)))
	  )
	)

      ;блок
      (setq	bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ cpt (list (- cabstartX) -5 0))) #blk:cbl:name 1 1 1 0))
      (vla-put-Value (getbdyn bobj "Distance1") (vlax-make-variant (- cabstartX cablevel) 5))
      ;(vla-put-Value (getbdyn bobj "shldDist") (vlax-make-variant (- cabstartX 20 ) 5))
      (vla-put-TextString (getbatt bobj "NUMBER") (car db))
      (vla-put-TextString (getbatt bobj "TYPE") (setq ctype (db|gpar "CBL_TYPE" (tr|extract db))))
      (vla-put-TextString (getbatt bobj "CORES") (db|gpar "CBL_CORES" (tr|extract db)))
      (if (null (wcmatch (setq sect (db|gpar "CBL_SECTION" (tr|extract db))) "*[`.`,]*")) (setq sect (strcat sect ",0")))
      (vla-put-TextString (getbatt bobj "SECTION") sect)
      (if iscableelsewere (vlax-put-property bobj "color" acYellow))
      ; заполняем аттрибуты
      (vla-put-TextString (getbatt bobj "LOCFLD") (strcat (db|gpar "EQ" (tr|extract db)) " " (db|gpar "EQ_DESC" (tr|extract db))))
      (vla-put-TextString (getbatt bobj "LOCCAB") (strcat "Шкаф контроллеров " (db|gpar "CABINET" (tr|extract db)) ", [" (db|gpar "T2" (tr|extract db)) "]"))
      (vla-put-Textstring (getbatt bobj "SIGN") (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (getbatt bobj "TYPE"))) ">%).TextString>%" "  " "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (getbatt bobj "CORES"))) ">%).TextString>%" "x" "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (getbatt bobj "SECTION"))) ">%).TextString>%"))
      ;;;  заполняем аттрибуты марок кабеля
      (setq i 0) (mapcar '(lambda (x) (vla-put-TextString (getbatt bobj (strcat "MARK" (itoa (setq i (1+ i))))) x)) (vl-remove "" (origlist modmarks)))
      )
    ) ; if is cable (если есть подключения)
  clpt
  );defun



;(gr|add-cable (getpoint) cabline)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





















;;;gr|add-signal-TCC2AI16
;;;gr|add-signal-TCC4PW
;;;gr|add-signal-TCC4LT
;;;gr|add-signal-TCC8L
;;;gr|add-signal-TCC8-220AC2
;;;gr|add-signal-TCB04
;;;gr|add-signal-TCB08HD2
;;;gr|add-signal-TCC8-220DCI2
;;;gr|add-signal-WAGO-280-519
;;;gr|add-signal-WAGO-280-833
;;;gr|add-signal-WAGO-280-549



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-TCC2AI16 (pt db / bobj m1 m2 m3 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "TCC2AI16" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (if (/= "" (setq m3 (db|gpar "M3" db))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 (strcat (db|gpar "KKS" db) "-" m3))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL1" db) " " (db|gpar "CL1_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL2" db) " " (db|gpar "CL2_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN3") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL3" db) " " (db|gpar "CL3_DESC" db)))
  (list m1 m2 m3)
  );defun
;(setq pt (getpoint)) (gr|add-signal-TCC2AI16 db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-TCC4PW  (pt db / bobj m1 m2 m3 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "TCC4PW" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (if (/= "" (setq m3 (db|gpar "M3" db))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 (strcat (db|gpar "KKS" db) "-" m3))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL1" db) (db|gpar "CL1_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL2" db) (db|gpar "CL2_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN3") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL3" db) (db|gpar "CL3_DESC" db)))
  (list m1 m2 m3)
  );defun
;(setq pt (getpoint)) (gr|add-signal-TCC4PW db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-TCC4LT  (pt db / bobj m1 m2 m3 m4 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  ;(setq db (nth 156 db:data))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "TCC4LT" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (if (/= "" (setq m3 (db|gpar "M3" db))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 (strcat (db|gpar "KKS" db) "-" m3))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 "")))
  (if (/= "" (setq m4 (db|gpar "M4" db))) (vla-put-TextString (getbatt bobj "MARK4") (setq m4 (strcat (db|gpar "KKS" db) "-" m4))) (vla-put-TextString (getbatt bobj "MARK4") (setq m4 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL1" db) " " (db|gpar "CL1_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL2" db) " " (db|gpar "CL2_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN3") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL3" db) " " (db|gpar "CL3_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN4") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL4" db) " " (db|gpar "CL4_DESC" db)))
  (list m1 m2 m3 m4)
  );defun
;(setq pt (getpoint)) (gr|add-signal-TCC4LT db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-TCC8L (pt db / bobj m1 m2 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "TCC8L" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL1" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL2" db) " " (db|gpar "CL2_DESC" db)))
  (list m1 m2)
  );defun
;(setq pt (getpoint)) (gr|add-signal-TCC8L db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-TCC8-220AC2  (pt db / bobj m1 m2 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "TCC8-220AC2" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL1" db) " " (db|gpar "CL1_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL2" db) " " (db|gpar "CL2_DESC" db)))
  (list m1 m2)
  );defun
;(setq pt (getpoint)) (gr|add-signal-TCC8-220AC2 db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-TCB04  (pt db / bobj m1 m2 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "TCB04" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL1" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL2" db) " " (db|gpar "CL2_DESC" db)))
  (list m1 m2)
  );defun
;(setq pt (getpoint)) (gr|add-signal-TCB04 db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-TCB08HD2  (pt db / bobj m1 m2 m3 m4 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "TCB08HD2" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (if (/= "" (setq m3 (db|gpar "M3" db))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 (strcat (db|gpar "KKS" db) "-" m3))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 "")))
  (if (/= "" (setq m4 (db|gpar "M4" db))) (vla-put-TextString (getbatt bobj "MARK4") (setq m4 (strcat (db|gpar "KKS" db) "-" m4))) (vla-put-TextString (getbatt bobj "MARK4") (setq m4 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL1" db) ))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL2" db)))
  (vla-put-TextString (getbatt bobj "PIN3") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL3" db)))
  (vla-put-TextString (getbatt bobj "PIN4") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL4" db)))
  (list m1 m2 m3 m4)
  );defun
;(setq pt (getpoint)) (gr|add-signal-TCB08HD2 db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-TCC8-220DCI2  (pt db / bobj m1 m2 m3 m4 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "TCC8-220DCI2" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (if (/= "" (setq m3 (db|gpar "M3" db))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 (strcat (db|gpar "KKS" db) "-" m3))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 "")))
  (if (/= "" (setq m4 (db|gpar "M4" db))) (vla-put-TextString (getbatt bobj "MARK4") (setq m4 (strcat (db|gpar "KKS" db) "-" m4))) (vla-put-TextString (getbatt bobj "MARK4") (setq m4 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL1" db) " " (db|gpar "CL1_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL2" db) " " (db|gpar "CL2_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN3") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL3" db) " " (db|gpar "CL3_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN4") (strcat (db|gpar "SOCKET" db) ":" (db|gpar "CL4" db) " " (db|gpar "CL4_DESC" db)))
  (list m1 m2 m3 m4)
  );defun
;(setq pt (getpoint)) (gr|add-signal-TCC8-220DCI2 db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-WAGO-280-519 (pt db / bobj m1 m2 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "WAGO-280-519" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "CL1" db) (db|gpar "CL1_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "CL2" db)))
  (list m1 m2)
  );defun
;(setq pt (getpoint)) (gr|add-signal-WAGO-280-519 db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-WAGO-280-833 (pt db / bobj m1 m2 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "WAGO-280-833" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "CL1" db) (db|gpar "CL1_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "CL2" db) (db|gpar "CL2_DESC" db)))
  (list m1 m2)
  );defun
;(setq pt (getpoint)) (gr|add-signal-WAGO-280-833 db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gr|add-signal-WAGO-280-549 (pt db / bobj m1 m2 m3 m4 kks tail name ndesc)
  ;(setq db (nth 7 (cons "table" (db|formatdata (excel>lst)))))
  (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) "WAGO-280-549" 1 1 1 0))
  (setq name (db|gpar "NAME" db)) (setq ndesc (db|gpar "NAME_DESC" db))
  (if (/= "" ndesc) (vla-put-TextString (getbatt bobj "NAME") (strcat name "\n" ndesc)) (vla-put-TextString (getbatt bobj "NAME")  name))
  (setq kks (db|gpar "KKS" db)) (setq tail (db|gpar "KKS_TAIL" db))
  (if (/= "" tail) (vla-put-TextString (getbatt bobj "KKS") (strcat kks "_" tail)) (vla-put-TextString (getbatt bobj "KKS")  kks))
  (vla-put-TextString (getbatt bobj "POZ") (db|gpar "POZ" db))
  (vla-put-TextString (getbatt bobj "CONNECTION") (db|gpar "CONNECTION" db))
  (vla-put-TextString (getbatt bobj "MOD_NUM") (db|gpar "MOD_NUM" db))
  (if (/= "" (setq m1 (db|gpar "M1" db))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 (strcat (db|gpar "KKS" db) "-" m1))) (vla-put-TextString (getbatt bobj "MARK1") (setq m1 "")))
  (if (/= "" (setq m2 (db|gpar "M2" db))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 (strcat (db|gpar "KKS" db) "-" m2))) (vla-put-TextString (getbatt bobj "MARK2") (setq m2 "")))
  (if (/= "" (setq m3 (db|gpar "M3" db))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 (strcat (db|gpar "KKS" db) "-" m3))) (vla-put-TextString (getbatt bobj "MARK3") (setq m3 "")))
  (if (/= "" (setq m4 (db|gpar "M4" db))) (vla-put-TextString (getbatt bobj "MARK4") (setq m4 (strcat (db|gpar "KKS" db) "-" m4))) (vla-put-TextString (getbatt bobj "MARK4") (setq m4 "")))
  (vla-put-TextString (getbatt bobj "PIN1") (strcat (db|gpar "CL1" db) (db|gpar "CL1_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN2") (strcat (db|gpar "CL2" db) (db|gpar "CL2_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN3") (strcat (db|gpar "CL3" db) (db|gpar "CL3_DESC" db)))
  (vla-put-TextString (getbatt bobj "PIN4") (strcat (db|gpar "CL4" db) (db|gpar "CL4_DESC" db)))
  (list m1 m2 m3 m4)
  );defun
;(setq pt (getpoint)) (gr|add-signal-WAGO-280-549 db)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(defun gr|add-bridge (pt / obj)
;;;  (vla-addline #modspace (vlax-3D-point (mapcar '+ pt '(0 -7.5 0))) (vlax-3D-point (mapcar '+ pt '(-1.5 -6.5 0))))
;;;  (vla-addline #modspace (vlax-3D-point (mapcar '+ pt '(-1.5 -6.5 0))) (vlax-3D-point (mapcar '+ pt '(-1.5 1.5 0))))
;;;  (vla-addline #modspace (vlax-3D-point (mapcar '+ pt '(-1.5 1.5 0))) (vlax-3D-point (mapcar '+ pt '(0 2.5 0))))
;;;  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












;;;;     проверка
;;;;	1 последовательноть расположения реле 1-16
;;;;	2 создаем базу кабелей в модели
;;;;	3 проходимся в ручную объединяя повторяющиеся кабели























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun blk|getendpoint (obj)
    (mapcar
      (cond
	((= 0 (vlax-variant-value (vla-get-Value (getbdyn obj "Dir")))) '+)
	((= 1 (vlax-variant-value (vla-get-Value (getbdyn obj "Dir")))) '-)
	)
      (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj)))
      (list (vlax-variant-value (vla-get-Value (getbdyn obj "Distance1"))) 0 0)
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
(defun conscables2 ( / es links objmain markstoadd enptymarks marksinmain mainaddrstr planka mpt txto c askstring)
  (setq askstring "link")
  (while (setq es (entsel askstring))
    (setq links (cons (vlax-ename->vla-object (car es)) links))
    )
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

























(setq cablelist (vl-remove-if-not '(lambda (x) (= #blk:cbl:name (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT")))))) (length cablelist)


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


;;  рисует перемычку
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
(setq lst (vl-remove-if-not '(lambda (x) (= #blk:cbl:name (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))
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



(setq lst (vl-remove-if-not '(lambda (x) (= #blk:cbl:name (vla-get-EffectiveName x))) (ss->lsto* (ssget "_I" '((0 . "INSERT"))))))
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







(setq lst (vl-remove-if-not '(lambda (x)
			       (member (vla-get-EffectiveName x)
				       '(
					 "TCB04"
					 "TCB08HD2"
					 
					 "TCC2AI16"
					 "TCC4PW"
					 "TCC4LT"
					 "TCC8L"
					 "TCC8-220AC2"

					 "TCC8-220DCI2"
					 "WAGO-280-519"
					 "WAGO-280-833"
					 "WAGO-280-549"
					 ))
			       )
	    (ss->lsto* (ssget '((0 . "INSERT"))))))
;(length (VL-STRING->LIST (vla-get-TextString (getbatt (vlax-ename->vla-object (car (entsel))) "LOCFLD"))))
(length lst)

(mapcar
  '(lambda (cab / destatt l)	;(setq cab (nth 13 lst))
     (setq destatt (getbatt cab "CONNECTION"))
     (setq l (strlen (kd-get-TextString destatt)))
     (cond
       ((diap l 5 6) (vla-put-ScaleFactor destatt 0.9))
       ((diap l 7 10)       (vla-put-ScaleFactor destatt 0.6))
       (T (princ))
       )
     )
  lst
  )