;;;  13_08_20
;;; КЖ из excel в автокад


(setq data (excel>lst))
(setq data (mapcarx any-to-string nil data))
(setq
  data
   (mapcar
     '(lambda (line)
	(mapcar '(lambda (wrd / ans)
		   ;(setq wrd (nth 3 (nth 9 datas)))
		   (setq ans wrd)
		   (while
		     (VL-STRING-SEARCH "kd:nl" ans)
		     (setq ans (VL-STRING-subst "\n" "kd:nl" ans))
		     )
		   ans
		   )
		line))
     data))


(mapcar
  '(lambda (x s)
     (vla-put-TextString (getbatt x "SIGNALNAME") (nth 0 s))
     (vla-put-TextString (getbatt x "NUMBER") (nth 1 s))
     (vla-put-TextString (getbatt x "CATEGORY") (nth 2 s))
     (vla-put-TextString (getbatt x "LOCFLD") (nth 3 s))
     (vla-put-TextString (getbatt x "LOCCAB") (nth 4 s))
     (vla-put-TextString (getbatt x "TYPE") (nth 5 s))
     (vla-put-TextString (getbatt x "CORES") (nth 6 s))
     (vla-put-TextString (getbatt x "SECTION") (nth 7 s))
     )
  (ss->lsto (ssget))
  ;data
  (cdr data)
  )

(mapcar
  '(lambda (x)
     (vla-put-TextString (getbatt x "SIGNALNAME") "")
     (vla-put-TextString (getbatt x "NUMBER") "")
     (vla-put-TextString (getbatt x "CATEGORY") "")
     (vla-put-TextString (getbatt x "LOCFLD") "")
     (vla-put-TextString (getbatt x "LOCCAB") "")
     (vla-put-TextString (getbatt x "TYPE") "")
     (vla-put-TextString (getbatt x "CORES") "")
     (vla-put-TextString (getbatt x "SECTION") "")
     (vla-put-TextString (getbatt x "LENGTH") "")
     (vla-put-TextString (getbatt x "NOTE") "")
     (vla-put-TextString (getbatt x "CBL_CNCT_HAND") "")
     (vla-put-TextString (getbatt x "CBL_FLD_HAND") "")
     (vla-put-TextString (getbatt x "VOLTAGE") "")
     )
  (ss->lsto* (ssget))
  )


(mapcar
  '(lambda (x)
     (vla-put-TextString (getbatt x "SIGNALNAME") "###")
     (vla-put-TextString (getbatt x "NUMBER") "###")
     (vla-put-TextString (getbatt x "CATEGORY") "###")
     (vla-put-TextString (getbatt x "LOCFLD") "###")
     (vla-put-TextString (getbatt x "LOCCAB") "###")
     (vla-put-TextString (getbatt x "TYPE") "###")
     (vla-put-TextString (getbatt x "CORES") "###")
     (vla-put-TextString (getbatt x "SECTION") "###")
     (vla-put-TextString (getbatt x "LENGTH") "###")
     (vla-put-TextString (getbatt x "NOTE") "###")
     )
  (ss->lsto* (ssget))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(mapcar
  '(lambda (x)
     (vla-put-TextString (getbatt x "LOCFLD")
       (VL-STRING-SUBST
	 "{\\W0.9;\\T0.9;Шкаф управления гидроцилиндрами}"
	 "Шкаф управления гидроцилиндрами"
	 (vla-get-TextString (getbatt x "LOCFLD"))
	 )
       )

     (vla-put-TextString (getbatt x "LOCCAB")
       (VL-STRING-SUBST
	 "{\\W0.9;\\T0.9;Шкаф управления гидроцилиндрами}"
	 "Шкаф управления гидроцилиндрами"
	 (vla-get-TextString (getbatt x "LOCCAB"))
	 )
       )
     )
  (ss->lsto* (ssget))
  ) (vla-Activate #actdoc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;		Lineweight
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(vla-get-Lineweight (vlax-ename->vla-object (car (nentsel))))

(setq lst (ss->lsto* (ssget)))

(mapcar
  '(lambda (b / atts)
     (setq atts (getbattswcmatch b "*"))
     ;(setq atts (vl-remove-if-not '(lambda (x) (= (vla-get-TagString x) "LOCCAB")) atts))
     (mapcarx vla-put-Lineweight -3 atts)	;ByBlock
     (mapcarx vla-put-Lineweight -1 atts)	;ByLayer
     
     )
  lst)

;(vla-put-Lineweight  (vlax-ename->vla-object (car (nentsel))) -1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(mapcar
  '(lambda (x)
     (vla-put-TextString (getbatt x "LENGTH") "")
     (vla-put-TextString (getbatt x "NOTE") "")
     )
  (ss->lsto* (ssget '((0 . "INSERT"))))
  ) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; для замены типа блока кабеля (например "cbl_lst-kks" на "cbl_lst")
;(mapcar 'vla-get-tagstring (getbattswcmatch (pickobj) "*"))

(setq lst '("NUMBER" "TYPE" "CORES" "CATEGORY" "LOCCAB" "LOCFLD" "SIGNALNAME" "VOLTAGE" "SECTION" "MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10" "MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20" "MARK21" "MARK22" "MARK23" "MARK24" "MARK25" "MARK26" "MARK27" "MARK28" "MARK29" "MARK30" "LENGTH" "CBL_CNCT_ID" "CBL_FLD_ID" "NOTE") )

(setq src (ss->lsto (ssget)))
(setq dst (ss->lsto (ssget)))

(mapcar
  '(lambda (s d)
     (mapcar
       '(lambda (a)
	  (vla-put-TextString
	    (getbatt d a)
	    (vla-get-TextString
	      (getbatt s a)))
	  )
       lst)
     )
  src dst)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







(setq cabs (ss->lsto* (ssget "_I")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; для отметки * в типах кабелей
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(mapcar
  '(lambda (x)	;(setq x (nth 32 cabs))
     (if
       (wcmatch (vla-get-TextString (getbatt x "NUMBER")) "*-4*,*-5*")
       (vla-put-TextString (getbatt x "CATEGORY") "*")
       )
     )
  cabs)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; то были игрушики




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))
(load (strcat #lisppath "DataBase\\dblib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
(load (strcat #lisppath "Strings\\kd-sortstrings.LSP"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(db|getdata 'db:head 'db:data)
(length (cdr db:data))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq db:head (car (excel>lst)))
(setq db:data (cons "table" (db|formatdata (excel>lst))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun go ( / startpt pt)
  (setq startpt (getpoint) pt startpt)
  (mapcar
    '(lambda (line / cobj)	;(setq line (nth 2 (cdr db:data)))
       (setq cobj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(0 0 0))) ;|*(strcat #lisppath "!blocking\\cablelist\\cbl_lst.dwg") *|; "cbl_lst" 1 1 1 0))
       
       (vla-put-TextString (getbatt cobj "SIGNALNAME") (db|gpar "meas_name" line))
       (vla-put-TextString (getbatt cobj "NUMBER") (db|gpar "cbl_KKS" line))
       (vla-put-TextString (getbatt cobj "CATEGORY") (db|gpar "typks" line))
       (vla-put-TextString (getbatt cobj "LOCFLD") (db|gpar "place_sensor" line))
       (vla-put-TextString (getbatt cobj "LOCCAB") (db|gpar "place_cpu" line))
       (vla-put-TextString (getbatt cobj "TYPE") (db|gpar "cab_type" line))
       (vla-put-TextString (getbatt cobj "CORES") (db|gpar "cores_cab" line))
       (vla-put-TextString (getbatt cobj "SECTION") (db|gpar "section" line))
       (vla-put-TextString (getbatt cobj "LENGTH") (db|gpar "LENGTH" line))
       (vla-put-TextString (getbatt cobj "NOTE") (db|gpar "NOTE" line))
       (vla-put-TextString (getbatt cobj "VOLTAGE") "")
       (setq pt (polar pt  (angtof "270") 12))
       )
    (cdr db:data)
    )
  );defun







;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXX         подсчет длинн кабелей для 2-го листа кабельного журнала      XXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



(setq cabs (vl-remove-if-not '(lambda (x) (= "cbl_lst2" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT")))))) (length cabs)


(setq data (tbl|blrefs>table cabs))
(setq data (tbl|delcolumns data '("[BN]=cbl_lst2" "NUMBER" "CATEGORY" "POZSIGN" "LOCCAB" "LOCFLD" "SIGNALNAME" "VOLTAGE" "MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10" "MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20" "CBL_CNCT_HAND" "CBL_FLD_HAND" "NOTE")))
(setq data (cdr data))	(length data)
(setq data (vl-remove-if '(lambda (x) (apply '= (cons "" x))) data)) (length data)


;(setq data (vl-remove-if-not '(lambda (x) (wcmatch (car x) "*КВВГ*")) data)) (length data)


(setq ans '())
(mapcar
  '(lambda (c / cn tmp)
     ;(setq c (nth 12 lst))
     (setq cn (strcat (nth 0 c) " " (nth 1 c) "x" (nth 2 c)))
     (cond
       ((setq tmp (assoc cn ans))
	(setq ans (subst (append tmp (list (nth 3 c))) tmp ans))
	)
       (T (setq ans (append ans (list (list cn (nth 3 c))))))
       )
     )
  data)


(setq out
(mapcar
  '(lambda (typ)
     ;(setq typ (nth 6 ans))
     (list (car typ) (apply '+ (mapcar 'atoi (cdr typ))))
     )
  ans)
)
;;;;  убираем строки с "пустыми" кабелями
;(setq out (vl-remove-if-not '(lambda (x) (wcmatch (car x) "*КВВГ*")) out))
(setq out (vl-sort out '(lambda (a b) (< (car a) (car b)))))


(setq out (append out (list (list "Итого:" (apply '+ (mapcar 'cadr out))))))










;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXX     добавление текста в таблицу     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;   параметры вывода графы спецификации   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq #tbl-geom-paramlist
   '(
     ;(("object" "MTEXT")("dpt" '( 0.8 -3 0))("attch" 1)("width" 18.4))  ;для давления
     (("object" "TEXT")("dpt" '( 2 -4 0))("attch" 9))
     (("object" "TEXT")("dpt" '( 70 -4 0))("attch" 10))
     )
  );spctblparamlist
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun add-table (data geom-params / bpt)
(defun add-dataline (pt data / txtobj mql cpt)
  (setq cpt pt)
  (setq mql '())	; Max Quantity of textLines
  (mapcar
    '(lambda (x p)
     (cond
       ((= "MTEXT" (cadr (assoc "object" p)))
	(progn
	  (setq txtobj (vla-AddMtext #modspace (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))) (cadr (assoc "width" p)) x))
	  (vla-put-AttachmentPoint txtobj (cadr (assoc "attch" p)))
	  (vla-put-LineSpacingStyle txtobj acLineSpacingStyleExactly)
	  (vla-put-Height txtobj 2.5)
	  (vla-put-LineSpacingDistance txtobj 8)
	  (setq mql (append mql (list (mtxt:getnumberoflines txtobj))))
	  );progn
	)
       ((= "TEXT" (cadr (assoc "object" p)))
	(progn
	  (setq txtobj (vla-Addtext #modspace x (vlax-3d-point '(0 0 0)) 2.5))
	  (vla-put-Alignment txtobj (cadr (assoc "attch" p)))
	  (vla-put-TextAlignmentPoint txtobj (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))))
	  (setq mql (append mql (list 1)))
	  );progn
	);1
       )
       )
    data geom-params
    )
  ; и выдает точку вставки следующей графы
  (mapcar '- cpt (list 0 (* 8 (eval (append '(max) mql))) 0))
  );defun
;(add-dataline (getpoint) (car out))
(setq bpt (getpoint))
(mapcar '(lambda (dl) (setq bpt (add-dataline bpt dl))) data)   ; dl - data line
  );defun


;(apply '+ (mapcar '(lambda (x) (atoi (vla-get-TextString x))) (ss->lsto* (ssget '((0 . "*TEXT"))))))

(add-table out #tbl-geom-paramlist)













;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXX     для спецификации +10%     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;; для спецификации +10%

(load (strcat #lisppath "MATH\\math-fix.LSP"))
(setq outsp (vl-remove-if '(lambda (x) (wcmatch (car x) "*Итого:*")) out))
(setq outsp (mapcar '(lambda (x) (list (car x) (* 10 (math-fix (* (cadr x) 0.11))))) outsp))
(add-table outsp #tbl-geom-paramlist)







;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXX   трубы для электропроводок 10%  от НАТУРАЛЬНОЙ длины   XXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;; для спецификации +10%
out



(setq atts '("TYPE" "CORES" "SECTION" "LENGTH"))
(setq lst (mapcar '(lambda (cab) (mapcar '(lambda (att) (vla-get-TextString (getbatt cab att))) atts)) cabs))





(setq outtr (vl-remove-if '(lambda (x) (= "" (antisep x "")) ) lst))

;(("22x2" 0) ("33x2" 0))

(setq ans '())
(mapcar
  '(lambda (x / tmp)
     (if (> (car x) 7)
       (if (setq tmp (assoc "33x2" ans))
	 (setq ans (subst (append tmp (list (cadr x))) tmp ans))
	 (setq ans (append ans (list (list "33x2" (cadr x)))))
	 )
       (if (setq tmp (assoc "22x2" ans))
	 (setq ans (subst (append tmp (list (cadr x))) tmp ans))
	 (setq ans (append ans (list (list "22x2" (cadr x)))))
	 )
       )
     )
 (mapcar
  '(lambda (c)
     (list (atoi (car c)) (apply '+ (mapcar '(lambda (x) (atoi (last x))) (cdr c))))
     )
  (zip outtr 1)
  )
)



(mapcar
  '(lambda (x)
     (list (car x) (* 0.1 (apply '+ (cdr x))))
     )
  ans)














