;;;  14_10_31 04:14
;;; КЖ из excel в автокад




;;    см. d:\_LISP\!blocking\ excelblocking.LSP
;;;;    OLD!
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
  (ss->lsto (ssget)) data
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
     ;(vla-put-TextString (getbatt x "SIGNALNAME") "###")
     ;(vla-put-TextString (getbatt x "NUMBER") "###")
     ;(vla-put-TextString (getbatt x "CATEGORY") "###")
     ;(vla-put-TextString (getbatt x "LOCFLD") "###")
     ;(vla-put-TextString (getbatt x "LOCCAB") "###")
     ;(vla-put-TextString (getbatt x "TYPE") "###")
     ;(vla-put-TextString (getbatt x "CORES") "###")
     ;(vla-put-TextString (getbatt x "SECTION") "###")
     (vla-put-TextString (getbatt x "LENGTH") "###")
     (vla-put-TextString (getbatt x "NOTE") "###")
     )
  (ss->lsto* (ssget))
  )



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





(mapcar
  '(lambda (x)
     (vla-put-TextString (getbatt x "LENGTH") "")
     (vla-put-TextString (getbatt x "NOTE") "")
     )
  (ss->lsto* (ssget '((0 . "INSERT"))))
  ) 


	
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









;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXX         подсчет длинн кабелей для 2-го листа кабельного журнала      XXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

;;;;  подсчет длинн кабелей для 2-го листа кабельного журнала

(setq cabs (ss->lsto* (ssget "_I")))


(setq atts '("TYPE" "CORES" "SECTION" "LENGTH"))
;(setq atts '("SIGN" "LENGTH"))



(setq lst
(mapcar
  '(lambda (cab)
     (mapcar
       '(lambda (att)
	  (vla-get-TextString (getbatt cab att))
	  )
       atts)
     )
  cabs)
)


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
  lst)


(setq ans '())
(mapcar
  '(lambda (x / cn tmp)	;(setq x (nth 14 lst))
     (setq cn (car x))
     (cond
       ((setq tmp (assoc cn ans))
	(setq ans (subst (append tmp (list (cadr x))) tmp ans))
	)
       (T (setq ans (cons x ans)))
       )
     )
  lst
  )


(setq out
(mapcar
  '(lambda (typ)
     ;(setq typ (nth 6 ans))
     (list (car typ) (apply '+ (mapcar 'atoi (cdr typ))))
     )
  ans)
)
;;;;  убираем строки с "пустыми" кабелями
(setq out (vl-remove-if-not '(lambda (x) (wcmatch (car x) "*ВВГ*")) out))
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














;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(setq dssinserts (ssget '((0 . "INSERT"))))
(setq cabs (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) '("act_mnt_cbl-outer" ) )) (ss->lsto* dssinserts)))
(length cabs)



(setq nums (mapcar '(lambda (x) (vla-get-TextString (getbatt x "NUMBER"))) cabs))

(setq sovp (deoriglist nums))




(sssetfirst nil (lst-to-ss
		  (vl-remove-if-not
		    '(lambda (x)
		       (member (vla-get-TextString (getbatt x "NUMBER")) sovp)
		       )
		    cabs
		    )
		  ))


;"d:\\Dropbox\\исходные (1)\\98-13-ТИ_ТГ6 project\\!_BASE\\6КЖ ДУ.xlsx"
;(setq lst (excel>lst))
;(setq lst (mapcar 'car lst))
;(setq lst (mapcar '(lambda (x) (sepstr x "\n")) lst))
;(setq lst (mapcar 'car lst))

;(db|diff lst nums)










(setq dssinserts (ssget '((0 . "INSERT"))))
(setq cabs (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) '("act_mnt_cbl-outer" ) )) (ss->lsto* dssinserts)))
(length cabs)

(setq cabs (vl-sort cabs '(lambda (a b) (< (vla-get-TextString (getbatt a "NUMBER")) (vla-get-TextString (getbatt b "NUMBER"))))))





(defun genname (plc1 / eq1)
  (cond
    ((wcmatch plc1 "##@@@##@@###") (setq eq1 (strcat "УКП монт. ед. " plc1)))
    ((wcmatch plc1 "##@@@##-##") (setq eq1 (strcat "Сборка задвижек " plc1)))
    ((wcmatch plc1 "##@@@##")
     (cond
       ((= "06CAB01" plc1) (setq eq1 (strcat "Шкаф ПТК " plc1)))
	  ((= "06CGB01" plc1) (setq eq1 (strcat "Шкаф ПТК " plc1)))
	  ((= "06CDB01" plc1) (setq eq1 (strcat "Шкаф ПТК " plc1)))
	  ((= "06CFC01" plc1) (setq eq1 (strcat "Шкаф вибрации " plc1)))
	  ((= "06CHM01" plc1) (setq eq1 (strcat "Шкаф электромагнитных клапанов " plc1)))
	  ((= "06BRU01" plc1) (setq eq1 (strcat "Шкаф питания " plc1)))
	  ((= "06CWA01" plc1) (setq eq1 (strcat "Пультовая секция " plc1)))
	  ((= "06CWC01" plc1) (setq eq1 (strcat "Аварийный пульт управления " plc1)))
	  ((wcmatch plc1 "06BJB##") (setq eq1 (strcat "Сборка задвижек " plc1)))
	  )
	)
    ((= "КРУ 6кВ") (setq eq1 (strcat "КРУ 6кВ" plc1)))
       (T (exit))
       )
  eq1
  );defun


(defun random (/ digits)
  (setq digits (substr (rtos (rem (getvar 'date) 1) 2 16) 13))
  (atof (strcat "0." (substr digits 6) (substr digits 1 5)))
); end defun





;"d:\\Dropbox\\исходные (1)\\98-13-ТИ_ТГ6 project\\!_BASE\\6КЖ ДУ.xlsx"
(setq lst (excel>lst))
(setq cables
(mapcar
  '(lambda (x / num typ c s v)	;(setq x (nth 13 lst))
     (setq typ (sepstr (car x) "\n"))
     (setq num (car typ))
     (setq v (caddr typ))
     (setq c (sepstr (cadr typ) " "))
     (setq typ (car c))
     (setq c (sepstr (cadr c) "x"))
     (setq s (cadr c))
     (setq c (car c))
     (list num typ c s v (cadr x) (nth 5 x) (nth 9 x) (nth 11 x))
     )
  lst))
(lst>excel cables)
;длины срандомились такие
;(setq cab-length-list '(("00LAA10AA801-2500" "103") ("00LAA10AA801-2501" "40") ("00LAA10AA801-7000" "124") ("00LAA10AA801-7001" "124") ("00LAB05AA001-2500" "86") ("00LAB05AA001-2501" "86") ("00LAB06AA001-2500" "96") ("00LAB06AA001-2501" "96") ("00LAB07AA001-2500" "104") ("00LAB07AA001-2501" "104") ("00LAB07AA002-2500" "104") ("00LAB07AA002-2501" "116") ("00LAB07AA003-2500" "116") ("00LAB07AA003-2501" "125") ("00LAB07AA003-2502" "40") ("00LAB07AA003-2503" "10") ("00LAB07AA004-2500" "92") ("00LAB07AA004-2501" "92") ("00LAB07AA005-2500" "88") ("00LAB07AA005-2501" "88") ("00LAB08AA001-2500" "105") ("00LAB08AA001-2501" "105") ("00LAB08AA002-2500" "105") ("00LAB08AA002-2501" "121") ("00LAB08AA003-2500" "121") ("00LAB08AA003-2501" "94") ("00LAB08AA004-2500" "94") ("00LAB08AA004-2501" "128") ("00LAB09AA001-2500" "128") ("00LAB09AA001-2501" "128") ("00LAB09AA002-2500" "101") ("00LAB09AA002-2501" "101") ("00LAB09AA003-2500" "111") ("00LAB09AA003-2501" "111") ("00LAB09AA004-2500" "111") ("00LAB09AA004-2501" "114") ("00LAB10AA001-2500" "114") ("00LAB10AA001-2501" "124") ("00LAB10AA002-2500" "124") ("00LAB10AA002-2501" "124") ("00LAB10AA004-2500" "85") ("00LAB10AA004-2501" "85") ("00LAB11AA801-2500" "107") ("00LAB11AA801-2501" "20") ("00LAB11AA801-7000" "107") ("00LAB11AA801-7001" "103") ("00LAB12AA801-2500" "103") ("00LAB12AA801-2501" "30") ("00LAB12AA801-7000" "115") ("00LAB12AA801-7001" "87") ("00LBA12AA001-2500" "87") ("00LBA12AA001-2501" "87") ("00LBA12AA801-2500" "91") ("00LBA12AA801-2501" "10") ("00LBA12AA801-7000" "99") ("00LBA12AA801-7001" "99") ("00LBF12AA001-2500" "104") ("00LBF12AA001-2501" "104") ("00LBG01AA001-2500" "104") ("00LBG01AA001-2501" "121") ("00LBG10AA801-2500" "121") ("00LBG10AA801-2501" "0") ("00LBG10AA801-7000" "87") ("00LBG10AA801-7001" "121") ("00LBG10AA802-2500" "121") ("00LBG10AA802-2501" "20") ("00LBG10AA802-7000" "100") ("00LBG10AA802-7001" "117") ("00LCM30AA801-2500" "117") ("00LCM30AA801-2501" "30") ("00LCM30AA801-7000" "127") ("00LCM30AA801-7001" "127") ("00NDA08AA011-2500" "125") ("00NDA08AA011-2501" "125") ("00NDA08AA012-2500" "85") ("00NDA08AA012-2501" "85") ("00NDA08AA013-2500" "85") ("00NDA08AA013-2501" "106") ("00NDA10AA001-2500" "106") ("00NDA10AA001-2501" "105") ("00NDA10AA002-2500" "105") ("00NDA10AA002-2501" "119") ("00NDA10AA003-2500" "119") ("00NDA10AA003-2501" "119") ("00NDA10AA004-2500" "93") ("00NDA10AA004-2501" "93") ("00NDA11AA001-2500" "102") ("00NDA11AA001-2501" "102") ("00NDA11AA002-2500" "99") ("00NDA11AA002-2501" "99") ("00NDA11AA003-2500" "99") ("00NDA11AA003-2501" "110") ("00NDA12AA001-2500" "110") ("00NDA12AA001-2501" "120") ("00NDA12AA002-2500" "120") ("00NDA12AA002-2501" "120") ("00NDA12AA011-2500" "87") ("00NDA12AA011-2501" "87") ("00NDA12AA012-2500" "90") ("00NDA12AA012-2501" "90") ("00NDA12AA013-2500" "95") ("00NDA12AA013-2501" "95") ("00NDA13AA001-2500" "95") ("00NDA13AA001-2501" "116") ("00NDA13AA002-2500" "116") ("00NDA13AA002-2501" "120") ("00NDA14AA001-2500" "120") ("00NDA14AA001-2501" "120") ("00NDA14AA002-2500" "129") ("00NDA14AA002-2501" "129") ("00NDA14AA003-2500" "96") ("00NDA14AA003-2501" "96") ("00NDA15AA001-2500" "100") ("00NDA15AA001-2501" "100") ("00NDA15AA002-2500" "100") ("00NDA15AA002-2501" "122") ("00NDB04AA001-2500" "122") ("00NDB04AA001-2501" "121") ("00NDB08AA001-2500" "121") ("00NDB08AA001-2501" "86") ("00NDB08AA801-2500" "86") ("00NDB08AA801-2501" "0") ("00NDB08AA801-7000" "102") ("00NDB08AA801-7001" "102") ("00NDB12AA001-2500" "100") ("00NDB12AA001-2501" "100") ("00NDB12AA801-2500" "100") ("00NDB12AA801-2501" "30") ("00NDB12AA801-7000" "110") ("00NDB12AA801-7001" "126") ("00NDB21AP001-2501" "40") ("00NDB22AP001-2501" "40") ("00NDB23AP001-2501" "0") ("06CHM01-2501" "0") ("06CHM01-2502" "10") ("06CHM01-2503" "10") ("06CHM01-2504" "20") ("06CHM01-2505" "20") ("06CHM01-2506" "20") ("06CHM01-2507" "30") ("06CHM01-2508" "30") ("06CHM01-2509" "20") ("06CHM01-2510" "20") ("06CHM01-2511" "20") ("06CHM01-7000" "0") ("06CWC01-2501" "0") ("06CWC01-2502" "10") ("06CWC01-2503" "10") ("06CWC01-2504" "10") ("06CWC01-2505" "30") ("06CWC01-2506" "30") ("06CWC01-2507" "40") ("06CWC01-2508" "40") ("06CWC01-2509" "40") ("06CWC01-2510" "40") ("06CWC01-2511" "40") ("06CWC01-2512" "10") ("06CWC01-2513" "10") ("06CWC01-2514" "10") ("06CWC01-7001" "10") ("06CWC01-7002" "20") ("06CWC01-7003" "20") ("06CWC01-7004" "20") ("06LAB10AA001-2500" "121") ("06LAB10AA001-2501" "121") ("06LAB10AA001-2502" "40") ("06LAB10AA001-2503" "40") ("06LBA10AA001-2500" "97") ("06LBA10AA001-2501" "97") ("06LBA10AA001-2502" "10") ("06LBA10AA002-2500" "89") ("06LBA10AA002-2501" "89") ("06LBA10AA002-2502" "20") ("06LBA10AA002-2503" "20") ("06LBA10AA002-2504" "40") ("06LBA10AA002-2505" "40") ("06LBA11AA001-2500" "122") ("06LBA11AA001-2501" "100") ("06LBA11AA001-2502" "20") ("06LBA12AA001-2500" "85") ("06LBA12AA001-2501" "85") ("06LBA12AA001-2502" "0") ("06LBA12AA001-2503" "20") ("06LBA12AA801-2500" "111") ("06LBA12AA801-2501" "111") ("06LBA12AA801-2502" "50") ("06LBA12AA801-7000" "111") ("06LBA13AA001-2500" "128") ("06LBA13AA001-2501" "128") ("06LBA13AA002-2500" "128") ("06LBA13AA002-2501" "124") ("06LBG11AA801-2500" "124") ("06LBG11AA801-2501" "10") ("06LBG11AA801-7000" "91") ("06LBG11AA801-7001" "91") ("06LBG20AA001-2500" "107") ("06LBG20AA001-2501" "107") ("06LBG21AA001-2500" "117") ("06LBG21AA001-2501" "117") ("06LBG22AA001-2500" "115") ("06LBG22AA001-2501" "115") ("06LBG23AA001-2500" "115") ("06LBG23AA001-2501" "87") ("06LBQ10AA031-2500" "0") ("06LBQ20AA031-2500" "10") ("06LBQ30AA031-2500" "10") ("06LBQ50AA001-2500" "95") ("06LBQ50AA001-2501" "95") ("06LBQ50AA001-2502" "10") ("06LBQ50AA001-2503" "20") ("06LBQ50AA002-2500" "107") ("06LBQ50AA002-2501" "107") ("06LBQ50AA002-2502" "30") ("06LBQ50AA002-2503" "30") ("06LBQ50AA003-2500" "88") ("06LBQ50AA003-2501" "88") ("06LBQ60AA001-2500" "86") ("06LBQ60AA001-2501" "86") ("06LBQ60AA001-2502" "0") ("06LBQ60AA001-2503" "10") ("06LBQ60AA002-2500" "96") ("06LBQ60AA002-2501" "112") ("06LBQ60AA002-2502" "30") ("06LBQ60AA002-2503" "30") ("06LBQ70AA001-2500" "122") ("06LBQ70AA001-2501" "122") ("06LBQ70AA001-2502" "40") ("06LBQ70AA001-2503" "40") ("06LBS20AA001-2500" "92") ("06LBS20AA001-2501" "92") ("06LBS21AA001-2500" "92") ("06LBS21AA001-2501" "102") ("06LBS21AA001-2502" "20") ("06LBS21AA001-2503" "30") ("06LBS22AA001-2500" "118") ("06LBS22AA001-2501" "118") ("06LBS22AA001-2502" "40") ("06LBS22AA001-2503" "40") ("06LBS30AA001-2500" "97") ("06LBS30AA001-2501" "97") ("06LBS40AA001-2500" "98") ("06LBS40AA001-2501" "98") ("06LBS40AA031-2500" "10") ("06LBS50AA031-2500" "20") ("06LBW10AA001-2500" "108") ("06LBW10AA001-2501" "106") ("06LBW10AA801-2500" "106") ("06LBW10AA801-2501" "20") ("06LBW10AA801-7000" "128") ("06LBW10AA801-7001" "128") ("06LCA10AA801-2500" "106") ("06LCA10AA801-2501" "20") ("06LCA10AA801-7000" "104") ("06LCA10AA801-7001" "104") ("06LCA10AA802-2500" "104") ("06LCA10AA802-2501" "20") ("06LCA10AA802-7000" "107") ("06LCA10AA802-7001" "112") ("06LCA11AA001-2500" "112") ("06LCA11AA001-2501" "118") ("06LCA12AA001-2500" "118") ("06LCA12AA001-2501" "118") ("06LCA21AA001-2500" "88") ("06LCA21AA001-2501" "88") ("06LCA21AA001-2502" "10") ("06LCA22AA001-2500" "91") ("06LCA22AA001-2501" "91") ("06LCA22AA001-2502" "20") ("06LCA30AA001-2500" "108") ("06LCA30AA001-2501" "118") ("06LCA31AA001-2500" "118") ("06LCA31AA001-2501" "121") ("06LCA32AA001-2500" "121") ("06LCA32AA001-2501" "121") ("06LCH50AA001-2500" "88") ("06LCH50AA001-2501" "88") ("06LCH50AA801-2500" "97") ("06LCH50AA801-2501" "10") ("06LCH50AA801-7000" "97") ("06LCH50AA801-7001" "114") ("06LCH51AA001-2500" "114") ("06LCH51AA001-2501" "105") ("06LCH60AA001-2500" "105") ("06LCH60AA001-2501" "105") ("06LCH60AA002-2500" "127") ("06LCH60AA002-2501" "127") ("06LCH60AA801-2500" "93") ("06LCH60AA801-2501" "10") ("06LCH60AA801-7000" "93") ("06LCH60AA801-7001" "103") ("06LCH70AA801-2500" "103") ("06LCH70AA801-2501" "20") ("06LCH70AA801-7000" "101") ("06LCH70AA801-7001" "123") ("06LCJ20AA001-2500" "123") ("06LCJ20AA001-2501" "123") ("06LCJ30AA001-2500" "128") ("06LCJ30AA001-2501" "128") ("06LCJ30AA801-2500" "95") ("06LCJ30AA801-2501" "10") ("06LCJ30AA801-7000" "95") ("06LCJ30AA801-7001" "91") ("06LCJ30AP001-2501" "10") ("06LCJ31AA801-2500" "107") ("06LCJ31AA801-2501" "20") ("06LCJ31AA801-7000" "107") ("06LCJ31AA801-7001" "129") ("06LCJ40AA001-2500" "129") ("06LCJ40AA001-2501" "120") ("06LCJ40AA801-2500" "120") ("06LCJ40AA801-2501" "0") ("06LCJ40AA801-7000" "87") ("06LCJ40AA801-7001" "104") ("06LCM11AA001-2500" "104") ("06LCM11AA001-2501" "104") ("06LCM12AA001-2500" "113") ("06LCM12AA001-2501" "113") ("06LCN10AA001-2500" "117") ("06LCN10AA001-2501" "117") ("06LCN10AA002-2500" "117") ("06LCN10AA002-2501" "121") ("06LCN11AA001-2500" "121") ("06LCN11AA001-2501" "93") ("06LCN11AA801-2500" "93") ("06LCN11AA801-2501" "20") ("06LCN11AA801-7000" "109") ("06LCN11AA801-7001" "109") ("06LCN11AP001-2501" "20") ("06LCN12AA001-2500" "101") ("06LCN12AA001-2501" "122") ("06LCN12AA801-2500" "122") ("06LCN12AA801-2501" "40") ("06LCN12AA801-7000" "89") ("06LCN12AA801-7001" "89") ("06LCN20AA001-2500" "99") ("06LCN20AA001-2501" "99") ("06LCN21AA801-2500" "99") ("06LCN21AA801-2501" "10") ("06LCN21AA801-7000" "97") ("06LCN21AA801-7001" "107") ("06LCN21AP001-2501" "20") ("06LCN22AA801-2500" "107") ("06LCN22AA801-2501" "40") ("06LCN22AA801-7000" "128") ("06LCN22AA801-7001" "127") ("06LDA10AA001-2500" "127") ("06LDA10AA001-2501" "86") ("06MAA10AA031-2500" "0") ("06MAA10AA801-2500" "86") ("06MAA10AA801-2501" "20") ("06MAA10AA801-7000" "103") ("06MAA10AA801-7001" "120") ("06MAA10AA801-7002" "120") ("06MAA10AA801-7003" "30") ("06MAC10AA801-2500" "116") ("06MAC10AA801-2501" "30") ("06MAC10AA801-7000" "110") ("06MAC10AA801-7001" "110") ("06MAC10AA801-7002" "92") ("06MAC10AA801-7003" "10") ("06MAC10AP001-2502" "20") ("06MAJ20AA001-2500" "109") ("06MAJ20AA001-2501" "112") ("06MAJ20AA001-2502" "30") ("06MAJ20AA001-2503" "30") ("06MAJ20AA001-2504" "30") ("06MAJ20AA002-2500" "117") ("06MAJ20AA002-2501" "88") ("06MAJ21AA001-2500" "88") ("06MAJ21AA001-2501" "88") ("06MAJ22AA001-2500" "100") ("06MAJ22AA001-2501" "100") ("06MAJ23AA001-2500" "96") ("06MAJ23AA001-2501" "96") ("06MAM10AA001-2500" "96") ("06MAM10AA001-2501" "118") ("06MAM11AA001-2500" "118") ("06MAM11AA001-2501" "123") ("06MAV11AP001-2501" "40") ("06MAV11AP001-2502" "10") ("06MAV12AP001-2501" "10") ("06MAV12AP001-2502" "10") ("06MAV13AP001-2501" "10") ("06MAV13AP001-2502" "10") ("06MKW11AP001-2502" "20") ("06MKW12AP001-2502" "20") ("06MKW13AP001-2502" "20") ("06NDA11AA001-2500" "124") ("06NDA11AA001-2501" "124") ("06NDA11AA002-2500" "122") ("06NDA11AA002-2501" "122") ("06NDA11AA003-2500" "103") ("06NDA11AA003-2501" "103") ("06NDA11AA004-2500" "103") ("06NDA11AA004-2501" "98") ("06NDA11AA005-2500" "98") ("06NDA11AA005-2501" "108") ("06NDA11AA006-2500" "108") ("06NDA11AA006-2501" "111") ("06NDA12AA001-2500" "111") ("06NDA12AA001-2501" "111") ("06NDA12AA002-2500" "128") ("06NDA12AA002-2501" "128") ("06NDA12AA003-2500" "88") ("06NDA12AA003-2501" "88") ("06NDA12AA801-2500" "88") ("06NDA12AA801-2501" "20") ("06NDA12AA801-7000" "104") ("06NDA12AA801-7001" "108") ("06NDA21AA001-2500" "108") ("06NDA21AA001-2501" "108") ("06NDA21AA002-2500" "117") ("06NDA21AA002-2501" "117") ("06NDA22AA001-2500" "124") ("06NDA22AA001-2501" "124") ("06NDA22AA002-2500" "94") ("06NDA22AA002-2501" "94") ("06NDA23AA001-2500" "94") ("06NDA23AA001-2501" "92") ("06NDA23AA002-2500" "92") ("06NDA23AA002-2501" "114") ("06PAB10AA001-2500" "114") ("06PAB10AA001-2501" "118") ("06PAB11AA001-2500" "118") ("06PAB11AA001-2501" "118") ("06PAB11AA002-2500" "85") ("06PAB11AA002-2501" "85") ("06PAB12AA001-2500" "93") ("06PAB12AA001-2501" "93") ("06PAB12AA002-2500" "93") ("06PAB12AA002-2501" "98") ("06PAB20AA001-2500" "98") ("06PAB20AA001-2501" "119") ("06PAB21AA001-2500" "119") ("06PAB21AA001-2501" "119") ("06PAB22AA001-2500" "124") ("06PAB22AA001-2501" "124") ("06PAB31AA001-2500" "127") ("06PAB31AA001-2501" "127") ("06PAB31AA002-2500" "94") ("06PAB31AA002-2501" "94") ("06PAB31AA003-2500" "104") ("06PAB31AA003-2501" "104") ("06PAB32AA001-2500" "104") ("06PAB32AA001-2501" "107") ("06PAB32AA002-2500" "107") ("06PAB32AA002-2501" "124") ("06PAB32AA003-2500" "124") ("06PAB32AA003-2501" "117") ("06PAH11AA001-2500" "117") ("06PAH11AA001-2501" "117") ("06PAH12AA001-2500" "95") ("06PAH12AA001-2501" "95") ("06PCM11AA001-2500" "91") ("06PCM11AA001-2501" "91") ("06PCM11AA002-2500" "113") ("06PCM11AA002-2501" "113") ("06PCM11AA003-2500" "125") ("06PCM11AA003-2501" "125") ("06PCM11AA004-2500" "125") ("06PCM11AA004-2501" "89") ("06PCM11AA005-2500" "89") ("06PCM11AA005-2501" "88") ("06PCM12AA001-2500" "88") ("06PCM12AA001-2501" "88") ("06PCM12AA002-2500" "109") ("06PCM12AA002-2501" "109") ("06PCM12AA003-2500" "114") ("06PCM12AA003-2501" "114") ("06PCM12AA004-2500" "114") ("06PCM12AA004-2501" "89") ("06PCM12AA005-2500" "89") ("06PCM12AA005-2501" "127") ("06PCM13AA001-2500" "127") ("06PCM13AA001-2501" "93") ("06PCM20AA001-2500" "93") ("06PCM20AA001-2501" "93") ("06PCM20AA002-2500" "110") ("06PCM20AA002-2501" "110") ("06SCH10AA001-2500" "115") ("06SCH10AA001-2501" "115"))) 







;;;  вариант для ворда
;;;   из кабелей когда берем из монт. схем приводов (не из подключений сборок)
(setq resu
(mapcar
  '(lambda (cab / plc1 plc2 eq1 eq2 l) ;(setq cab (nth 13 res))	(setq cab (vlax-ename->vla-object (car (entsel))))
     ;(sssetfirst nil (ssadd (vlax-vla-object->ename cab)))
     (setq plc1 (vla-get-TextString (getbatt cab "LOCFLD")))
     (setq plc2 (vla-get-TextString (getbatt cab "LOCCAB")))
     (setq eq1 (genname plc1))
     (setq eq2 (genname plc2))
;     ;  первый раз были рандомные длины - см выше - забираем старые из ексель-базы
;     (cond
;       ((or (wcmatch eq1 "УКП*") (wcmatch eq2 "УКП*"))
;	(setq l (fix (+ 80 (* 50 (random)))))
;	)
;       (T
;	(setq l (* 10 (fix (/ (* 50 (random)) 10))))
;	)
;       );cond

     ;;;;;
     (setq l (atoi (cadr (assoc (kd-get-textstring (getbatt cab "NUMBER")) cab-length-list))))
     ;;;;;


     (list
       "" ""
       (strcat
	 (vla-get-TextString (getbatt cab "NUMBER")) "\n"
	 (vla-get-TextString (getbatt cab "TYPE")) " " (vla-get-TextString (getbatt cab "CORES")) "x" (vla-get-TextString (getbatt cab "SECTION")) "\n"
	 "0,66"
	 )
       (if (wcmatch eq1 "УКП*") eq1 (strcat "Главный корпус. БЩУ. " eq1))
       "" "" ""
       (if (wcmatch eq2 "УКП*") eq2 (strcat "Главный корпус. БЩУ. " eq2))
       "" "" ""
       (itoa l)
       ""
       "К"
       )
     )
  cabs
  )
      )

(lst>excel resu)





















;;;(tbl|getdata 'zbase)
;;;(setq dssinserts (ssget '((0 . "INSERT"))))
;;;(setq cabstest (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) '("act_mnt_cbl-outer" ) )) (ss->lsto* dssinserts)))
;;;(length cabstest)
;;;
;;;(setq errs '())
;;;(mapcar
;;;  '(lambda (cab / n zkks lc)
;;;     (setq n (kd-get-textstring (getbatt cab "NUMBER")))
;;;     (setq lc (vla-get-TextString (getbatt cab "LOCCAB")))
;;;     (setq zkks (car (sepstr n "-")))
;;;     (if (/= (antisep (cdr (cadr (tbl|filter zbase (strcat "KKS=" zkks)))) "-") lc)
;;;       (setq errs (cons cab errs))
;;;       )
;;;     )
;;;  cabstest)
;;;
;;;(length errs)
;;;(sssetfirst nil (lst-to-ss errs))

















(setq dssinserts (ssget '((0 . "INSERT"))))
(setq cabs (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) '("act_mnt_cbl-outer" ) )) (ss->lsto* dssinserts)))
(setq cabs (vl-sort cabs '(lambda (a b) (< (vla-get-TextString (getbatt a "NUMBER")) (vla-get-TextString (getbatt b "NUMBER"))))))
(length cabs)

;длины срандомились такие
(setq cab-length-list '(("00LAA10AA801-2500" "103") ("00LAA10AA801-2501" "40") ("00LAA10AA801-7000" "124") ("00LAA10AA801-7001" "124") ("00LAB05AA001-2500" "86") ("00LAB05AA001-2501" "86") ("00LAB06AA001-2500" "96") ("00LAB06AA001-2501" "96") ("00LAB07AA001-2500" "104") ("00LAB07AA001-2501" "104") ("00LAB07AA002-2500" "104") ("00LAB07AA002-2501" "116") ("00LAB07AA003-2500" "116") ("00LAB07AA003-2501" "125") ("00LAB07AA003-2502" "40") ("00LAB07AA003-2503" "10") ("00LAB07AA004-2500" "92") ("00LAB07AA004-2501" "92") ("00LAB07AA005-2500" "88") ("00LAB07AA005-2501" "88") ("00LAB08AA001-2500" "105") ("00LAB08AA001-2501" "105") ("00LAB08AA002-2500" "105") ("00LAB08AA002-2501" "121") ("00LAB08AA003-2500" "121") ("00LAB08AA003-2501" "94") ("00LAB08AA004-2500" "94") ("00LAB08AA004-2501" "128") ("00LAB09AA001-2500" "128") ("00LAB09AA001-2501" "128") ("00LAB09AA002-2500" "101") ("00LAB09AA002-2501" "101") ("00LAB09AA003-2500" "111") ("00LAB09AA003-2501" "111") ("00LAB09AA004-2500" "111") ("00LAB09AA004-2501" "114") ("00LAB10AA001-2500" "114") ("00LAB10AA001-2501" "124") ("00LAB10AA002-2500" "124") ("00LAB10AA002-2501" "124") ("00LAB10AA004-2500" "85") ("00LAB10AA004-2501" "85") ("00LAB11AA801-2500" "107") ("00LAB11AA801-2501" "20") ("00LAB11AA801-7000" "107") ("00LAB11AA801-7001" "103") ("00LAB12AA801-2500" "103") ("00LAB12AA801-2501" "30") ("00LAB12AA801-7000" "115") ("00LAB12AA801-7001" "87") ("00LBA12AA001-2500" "87") ("00LBA12AA001-2501" "87") ("00LBA12AA801-2500" "91") ("00LBA12AA801-2501" "10") ("00LBA12AA801-7000" "99") ("00LBA12AA801-7001" "99") ("00LBF12AA001-2500" "104") ("00LBF12AA001-2501" "104") ("00LBG01AA001-2500" "104") ("00LBG01AA001-2501" "121") ("00LBG10AA801-2500" "121") ("00LBG10AA801-2501" "0") ("00LBG10AA801-7000" "87") ("00LBG10AA801-7001" "121") ("00LBG10AA802-2500" "121") ("00LBG10AA802-2501" "20") ("00LBG10AA802-7000" "100") ("00LBG10AA802-7001" "117") ("00LCM30AA801-2500" "117") ("00LCM30AA801-2501" "30") ("00LCM30AA801-7000" "127") ("00LCM30AA801-7001" "127") ("00NDA08AA011-2500" "125") ("00NDA08AA011-2501" "125") ("00NDA08AA012-2500" "85") ("00NDA08AA012-2501" "85") ("00NDA08AA013-2500" "85") ("00NDA08AA013-2501" "106") ("00NDA10AA001-2500" "106") ("00NDA10AA001-2501" "105") ("00NDA10AA002-2500" "105") ("00NDA10AA002-2501" "119") ("00NDA10AA003-2500" "119") ("00NDA10AA003-2501" "119") ("00NDA10AA004-2500" "93") ("00NDA10AA004-2501" "93") ("00NDA11AA001-2500" "102") ("00NDA11AA001-2501" "102") ("00NDA11AA002-2500" "99") ("00NDA11AA002-2501" "99") ("00NDA11AA003-2500" "99") ("00NDA11AA003-2501" "110") ("00NDA12AA001-2500" "110") ("00NDA12AA001-2501" "120") ("00NDA12AA002-2500" "120") ("00NDA12AA002-2501" "120") ("00NDA12AA011-2500" "87") ("00NDA12AA011-2501" "87") ("00NDA12AA012-2500" "90") ("00NDA12AA012-2501" "90") ("00NDA12AA013-2500" "95") ("00NDA12AA013-2501" "95") ("00NDA13AA001-2500" "95") ("00NDA13AA001-2501" "116") ("00NDA13AA002-2500" "116") ("00NDA13AA002-2501" "120") ("00NDA14AA001-2500" "120") ("00NDA14AA001-2501" "120") ("00NDA14AA002-2500" "129") ("00NDA14AA002-2501" "129") ("00NDA14AA003-2500" "96") ("00NDA14AA003-2501" "96") ("00NDA15AA001-2500" "100") ("00NDA15AA001-2501" "100") ("00NDA15AA002-2500" "100") ("00NDA15AA002-2501" "122") ("00NDB04AA001-2500" "122") ("00NDB04AA001-2501" "121") ("00NDB08AA001-2500" "121") ("00NDB08AA001-2501" "86") ("00NDB08AA801-2500" "86") ("00NDB08AA801-2501" "0") ("00NDB08AA801-7000" "102") ("00NDB08AA801-7001" "102") ("00NDB12AA001-2500" "100") ("00NDB12AA001-2501" "100") ("00NDB12AA801-2500" "100") ("00NDB12AA801-2501" "30") ("00NDB12AA801-7000" "110") ("00NDB12AA801-7001" "126") ("00NDB21AP001-2501" "40") ("00NDB22AP001-2501" "40") ("00NDB23AP001-2501" "0") ("06CHM01-2501" "0") ("06CHM01-2502" "10") ("06CHM01-2503" "10") ("06CHM01-2504" "20") ("06CHM01-2505" "20") ("06CHM01-2506" "20") ("06CHM01-2507" "30") ("06CHM01-2508" "30") ("06CHM01-2509" "20") ("06CHM01-2510" "20") ("06CHM01-2511" "20") ("06CHM01-7000" "0") ("06CWC01-2501" "0") ("06CWC01-2502" "10") ("06CWC01-2503" "10") ("06CWC01-2504" "10") ("06CWC01-2505" "30") ("06CWC01-2506" "30") ("06CWC01-2507" "40") ("06CWC01-2508" "40") ("06CWC01-2509" "40") ("06CWC01-2510" "40") ("06CWC01-2511" "40") ("06CWC01-2512" "10") ("06CWC01-2513" "10") ("06CWC01-2514" "10") ("06CWC01-7001" "10") ("06CWC01-7002" "20") ("06CWC01-7003" "20") ("06CWC01-7004" "20") ("06LAB10AA001-2500" "121") ("06LAB10AA001-2501" "121") ("06LAB10AA001-2502" "40") ("06LAB10AA001-2503" "40") ("06LBA10AA001-2500" "97") ("06LBA10AA001-2501" "97") ("06LBA10AA001-2502" "10") ("06LBA10AA002-2500" "89") ("06LBA10AA002-2501" "89") ("06LBA10AA002-2502" "20") ("06LBA10AA002-2503" "20") ("06LBA10AA002-2504" "40") ("06LBA10AA002-2505" "40") ("06LBA11AA001-2500" "122") ("06LBA11AA001-2501" "100") ("06LBA11AA001-2502" "20") ("06LBA12AA001-2500" "85") ("06LBA12AA001-2501" "85") ("06LBA12AA001-2502" "0") ("06LBA12AA001-2503" "20") ("06LBA12AA801-2500" "111") ("06LBA12AA801-2501" "111") ("06LBA12AA801-2502" "50") ("06LBA12AA801-7000" "111") ("06LBA13AA001-2500" "128") ("06LBA13AA001-2501" "128") ("06LBA13AA002-2500" "128") ("06LBA13AA002-2501" "124") ("06LBG11AA801-2500" "124") ("06LBG11AA801-2501" "10") ("06LBG11AA801-7000" "91") ("06LBG11AA801-7001" "91") ("06LBG20AA001-2500" "107") ("06LBG20AA001-2501" "107") ("06LBG21AA001-2500" "117") ("06LBG21AA001-2501" "117") ("06LBG22AA001-2500" "115") ("06LBG22AA001-2501" "115") ("06LBG23AA001-2500" "115") ("06LBG23AA001-2501" "87") ("06LBQ10AA031-2500" "0") ("06LBQ20AA031-2500" "10") ("06LBQ30AA031-2500" "10") ("06LBQ50AA001-2500" "95") ("06LBQ50AA001-2501" "95") ("06LBQ50AA001-2502" "10") ("06LBQ50AA001-2503" "20") ("06LBQ50AA002-2500" "107") ("06LBQ50AA002-2501" "107") ("06LBQ50AA002-2502" "30") ("06LBQ50AA002-2503" "30") ("06LBQ50AA003-2500" "88") ("06LBQ50AA003-2501" "88") ("06LBQ60AA001-2500" "86") ("06LBQ60AA001-2501" "86") ("06LBQ60AA001-2502" "0") ("06LBQ60AA001-2503" "10") ("06LBQ60AA002-2500" "96") ("06LBQ60AA002-2501" "112") ("06LBQ60AA002-2502" "30") ("06LBQ60AA002-2503" "30") ("06LBQ70AA001-2500" "122") ("06LBQ70AA001-2501" "122") ("06LBQ70AA001-2502" "40") ("06LBQ70AA001-2503" "40") ("06LBS20AA001-2500" "92") ("06LBS20AA001-2501" "92") ("06LBS21AA001-2500" "92") ("06LBS21AA001-2501" "102") ("06LBS21AA001-2502" "20") ("06LBS21AA001-2503" "30") ("06LBS22AA001-2500" "118") ("06LBS22AA001-2501" "118") ("06LBS22AA001-2502" "40") ("06LBS22AA001-2503" "40") ("06LBS30AA001-2500" "97") ("06LBS30AA001-2501" "97") ("06LBS40AA001-2500" "98") ("06LBS40AA001-2501" "98") ("06LBS40AA031-2500" "10") ("06LBS50AA031-2500" "20") ("06LBW10AA001-2500" "108") ("06LBW10AA001-2501" "106") ("06LBW10AA801-2500" "106") ("06LBW10AA801-2501" "20") ("06LBW10AA801-7000" "128") ("06LBW10AA801-7001" "128") ("06LCA10AA801-2500" "106") ("06LCA10AA801-2501" "20") ("06LCA10AA801-7000" "104") ("06LCA10AA801-7001" "104") ("06LCA10AA802-2500" "104") ("06LCA10AA802-2501" "20") ("06LCA10AA802-7000" "107") ("06LCA10AA802-7001" "112") ("06LCA11AA001-2500" "112") ("06LCA11AA001-2501" "118") ("06LCA12AA001-2500" "118") ("06LCA12AA001-2501" "118") ("06LCA21AA001-2500" "88") ("06LCA21AA001-2501" "88") ("06LCA21AA001-2502" "10") ("06LCA22AA001-2500" "91") ("06LCA22AA001-2501" "91") ("06LCA22AA001-2502" "20") ("06LCA30AA001-2500" "108") ("06LCA30AA001-2501" "118") ("06LCA31AA001-2500" "118") ("06LCA31AA001-2501" "121") ("06LCA32AA001-2500" "121") ("06LCA32AA001-2501" "121") ("06LCH50AA001-2500" "88") ("06LCH50AA001-2501" "88") ("06LCH50AA801-2500" "97") ("06LCH50AA801-2501" "10") ("06LCH50AA801-7000" "97") ("06LCH50AA801-7001" "114") ("06LCH51AA001-2500" "114") ("06LCH51AA001-2501" "105") ("06LCH60AA001-2500" "105") ("06LCH60AA001-2501" "105") ("06LCH60AA002-2500" "127") ("06LCH60AA002-2501" "127") ("06LCH60AA801-2500" "93") ("06LCH60AA801-2501" "10") ("06LCH60AA801-7000" "93") ("06LCH60AA801-7001" "103") ("06LCH70AA801-2500" "103") ("06LCH70AA801-2501" "20") ("06LCH70AA801-7000" "101") ("06LCH70AA801-7001" "123") ("06LCJ20AA001-2500" "123") ("06LCJ20AA001-2501" "123") ("06LCJ30AA001-2500" "128") ("06LCJ30AA001-2501" "128") ("06LCJ30AA801-2500" "95") ("06LCJ30AA801-2501" "10") ("06LCJ30AA801-7000" "95") ("06LCJ30AA801-7001" "91") ("06LCJ30AP001-2501" "10") ("06LCJ31AA801-2500" "107") ("06LCJ31AA801-2501" "20") ("06LCJ31AA801-7000" "107") ("06LCJ31AA801-7001" "129") ("06LCJ40AA001-2500" "129") ("06LCJ40AA001-2501" "120") ("06LCJ40AA801-2500" "120") ("06LCJ40AA801-2501" "0") ("06LCJ40AA801-7000" "87") ("06LCJ40AA801-7001" "104") ("06LCM11AA001-2500" "104") ("06LCM11AA001-2501" "104") ("06LCM12AA001-2500" "113") ("06LCM12AA001-2501" "113") ("06LCN10AA001-2500" "117") ("06LCN10AA001-2501" "117") ("06LCN10AA002-2500" "117") ("06LCN10AA002-2501" "121") ("06LCN11AA001-2500" "121") ("06LCN11AA001-2501" "93") ("06LCN11AA801-2500" "93") ("06LCN11AA801-2501" "20") ("06LCN11AA801-7000" "109") ("06LCN11AA801-7001" "109") ("06LCN11AP001-2501" "20") ("06LCN12AA001-2500" "101") ("06LCN12AA001-2501" "122") ("06LCN12AA801-2500" "122") ("06LCN12AA801-2501" "40") ("06LCN12AA801-7000" "89") ("06LCN12AA801-7001" "89") ("06LCN20AA001-2500" "99") ("06LCN20AA001-2501" "99") ("06LCN21AA801-2500" "99") ("06LCN21AA801-2501" "10") ("06LCN21AA801-7000" "97") ("06LCN21AA801-7001" "107") ("06LCN21AP001-2501" "20") ("06LCN22AA801-2500" "107") ("06LCN22AA801-2501" "40") ("06LCN22AA801-7000" "128") ("06LCN22AA801-7001" "127") ("06LDA10AA001-2500" "127") ("06LDA10AA001-2501" "86") ("06MAA10AA031-2500" "0") ("06MAA10AA801-2500" "86") ("06MAA10AA801-2501" "20") ("06MAA10AA801-7000" "103") ("06MAA10AA801-7001" "120") ("06MAA10AA801-7002" "120") ("06MAA10AA801-7003" "30") ("06MAC10AA801-2500" "116") ("06MAC10AA801-2501" "30") ("06MAC10AA801-7000" "110") ("06MAC10AA801-7001" "110") ("06MAC10AA801-7002" "92") ("06MAC10AA801-7003" "10") ("06MAC10AP001-2502" "20") ("06MAJ20AA001-2500" "109") ("06MAJ20AA001-2501" "112") ("06MAJ20AA001-2502" "30") ("06MAJ20AA001-2503" "30") ("06MAJ20AA001-2504" "30") ("06MAJ20AA002-2500" "117") ("06MAJ20AA002-2501" "88") ("06MAJ21AA001-2500" "88") ("06MAJ21AA001-2501" "88") ("06MAJ22AA001-2500" "100") ("06MAJ22AA001-2501" "100") ("06MAJ23AA001-2500" "96") ("06MAJ23AA001-2501" "96") ("06MAM10AA001-2500" "96") ("06MAM10AA001-2501" "118") ("06MAM11AA001-2500" "118") ("06MAM11AA001-2501" "123") ("06MAV11AP001-2501" "40") ("06MAV11AP001-2502" "10") ("06MAV12AP001-2501" "10") ("06MAV12AP001-2502" "10") ("06MAV13AP001-2501" "10") ("06MAV13AP001-2502" "10") ("06MKW11AP001-2502" "20") ("06MKW12AP001-2502" "20") ("06MKW13AP001-2502" "20") ("06NDA11AA001-2500" "124") ("06NDA11AA001-2501" "124") ("06NDA11AA002-2500" "122") ("06NDA11AA002-2501" "122") ("06NDA11AA003-2500" "103") ("06NDA11AA003-2501" "103") ("06NDA11AA004-2500" "103") ("06NDA11AA004-2501" "98") ("06NDA11AA005-2500" "98") ("06NDA11AA005-2501" "108") ("06NDA11AA006-2500" "108") ("06NDA11AA006-2501" "111") ("06NDA12AA001-2500" "111") ("06NDA12AA001-2501" "111") ("06NDA12AA002-2500" "128") ("06NDA12AA002-2501" "128") ("06NDA12AA003-2500" "88") ("06NDA12AA003-2501" "88") ("06NDA12AA801-2500" "88") ("06NDA12AA801-2501" "20") ("06NDA12AA801-7000" "104") ("06NDA12AA801-7001" "108") ("06NDA21AA001-2500" "108") ("06NDA21AA001-2501" "108") ("06NDA21AA002-2500" "117") ("06NDA21AA002-2501" "117") ("06NDA22AA001-2500" "124") ("06NDA22AA001-2501" "124") ("06NDA22AA002-2500" "94") ("06NDA22AA002-2501" "94") ("06NDA23AA001-2500" "94") ("06NDA23AA001-2501" "92") ("06NDA23AA002-2500" "92") ("06NDA23AA002-2501" "114") ("06PAB10AA001-2500" "114") ("06PAB10AA001-2501" "118") ("06PAB11AA001-2500" "118") ("06PAB11AA001-2501" "118") ("06PAB11AA002-2500" "85") ("06PAB11AA002-2501" "85") ("06PAB12AA001-2500" "93") ("06PAB12AA001-2501" "93") ("06PAB12AA002-2500" "93") ("06PAB12AA002-2501" "98") ("06PAB20AA001-2500" "98") ("06PAB20AA001-2501" "119") ("06PAB21AA001-2500" "119") ("06PAB21AA001-2501" "119") ("06PAB22AA001-2500" "124") ("06PAB22AA001-2501" "124") ("06PAB31AA001-2500" "127") ("06PAB31AA001-2501" "127") ("06PAB31AA002-2500" "94") ("06PAB31AA002-2501" "94") ("06PAB31AA003-2500" "104") ("06PAB31AA003-2501" "104") ("06PAB32AA001-2500" "104") ("06PAB32AA001-2501" "107") ("06PAB32AA002-2500" "107") ("06PAB32AA002-2501" "124") ("06PAB32AA003-2500" "124") ("06PAB32AA003-2501" "117") ("06PAH11AA001-2500" "117") ("06PAH11AA001-2501" "117") ("06PAH12AA001-2500" "95") ("06PAH12AA001-2501" "95") ("06PCM11AA001-2500" "91") ("06PCM11AA001-2501" "91") ("06PCM11AA002-2500" "113") ("06PCM11AA002-2501" "113") ("06PCM11AA003-2500" "125") ("06PCM11AA003-2501" "125") ("06PCM11AA004-2500" "125") ("06PCM11AA004-2501" "89") ("06PCM11AA005-2500" "89") ("06PCM11AA005-2501" "88") ("06PCM12AA001-2500" "88") ("06PCM12AA001-2501" "88") ("06PCM12AA002-2500" "109") ("06PCM12AA002-2501" "109") ("06PCM12AA003-2500" "114") ("06PCM12AA003-2501" "114") ("06PCM12AA004-2500" "114") ("06PCM12AA004-2501" "89") ("06PCM12AA005-2500" "89") ("06PCM12AA005-2501" "127") ("06PCM13AA001-2500" "127") ("06PCM13AA001-2501" "93") ("06PCM20AA001-2500" "93") ("06PCM20AA001-2501" "93") ("06PCM20AA002-2500" "110") ("06PCM20AA002-2501" "110") ("06SCH10AA001-2500" "115") ("06SCH10AA001-2501" "115"))) 




;"LOOP_KKSID"
;"NUMBER"
;"NAME"
"CBL_KKSID"
"SIGN"
"VOLTAGE"
"1EQ1" "1EQ2" "1EQ3" "1X" "1Y" "1Z"
"2EQ1" "2EQ2" "2EQ3" "2X" "2Y" "2Z"
"LENGTH" "TYPE" "CORES" "SECTION"




(defun gen-locations (cab / cblkks plccab plcfld 1eq1 2eq1 )
  (setq cblkks (kd-get-textstring (getbatt cab "NUMBER")))
  (setq plcfld (vla-get-TextString (getbatt cab "LOCFLD"))
	plccab (vla-get-TextString (getbatt cab "LOCCAB")))
  (if (member plccab '("УКП электропривода" "УКП"))
    (setq plccab (vla-get-TextString (getbatt cab "LOCFLD"))
	  plcfld (vla-get-TextString (getbatt cab "LOCCAB")))
    )

  (cond
    ((member plcfld '("УКП электропривода" "УКП"))
     (setq 1eq1 (car (sepstr cblkks "-")))
     (setq 1eq2 "УКП электропривода")
     (setq 1eq3 "")
     )
    (T (exit))
    )
  (cond
    ((wcmatch plccab "##@@@##-##")
     (setq 2eq1 plccab)
     (setq 2eq2 "Главный корпус.\nРелейный отсек БЩУ.")
     (setq 2eq3 "Сборка задвижек")
     )
    (T (exit))
    )
  (list cblkks 1eq1 1eq2 1eq3 2eq1 2eq2 2eq3)
  );defun









;;;  вариант для блоков
(setq resu
(mapcar
  '(lambda (cab / cblkks plcfld plccab tmp eq1 eq2 l)
     ;(setq cab (nth 13 cabs))
     ;(setq cab (vlax-ename->vla-object (car (entsel))))
     ;(sssetfirst nil (ssadd (vlax-vla-object->ename cab)))

     (setq tmp (gen-locations cab))

     
     (setq cblkks (kd-get-textstring (getbatt cab "NUMBER")))
     (setq plcfld (vla-get-TextString (getbatt cab "LOCFLD")))
     (if (= plcfld "УКП электропривода")
       (setq )
       )
     (setq plccab (vla-get-TextString (getbatt cab "LOCCAB")))
     (setq eq1 (genname plc1))
     (setq eq2 (genname plc2))


     ;;;;;
     (setq l (atoi (cadr (assoc (kd-get-textstring (getbatt cab "NUMBER")) cab-length-list))))
     ;;;;;


     (list
       "" ""
       (strcat
	 (vla-get-TextString (getbatt cab "NUMBER")) "\n"
	 (vla-get-TextString (getbatt cab "TYPE")) " " (vla-get-TextString (getbatt cab "CORES")) "x" (vla-get-TextString (getbatt cab "SECTION")) "\n"
	 "0,66"
	 )
       (if (wcmatch eq1 "УКП*") eq1 (strcat "Главный корпус. БЩУ. " eq1))
       "" "" ""
       (if (wcmatch eq2 "УКП*") eq2 (strcat "Главный корпус. БЩУ. " eq2))
       "" "" ""
       (itoa l)
       ""
       "К"
       )
     )
  cabs
  )
      )














(setq lst

(mapcar
  '(lambda (cab / plc1 plc2 eq1 eq2 l) ;(setq cab (nth 13 res))	(setq cab (vlax-ename->vla-object (car (entsel))))
     (setq plc1 (vla-get-TextString (getbatt cab "LOCFLD")))
     (setq plc2 (vla-get-TextString (getbatt cab "LOCCAB")))
     (setq eq1 (genname plc1))
     (setq eq2 (genname plc2))
     (cond
       ((or (wcmatch eq1 "УКП*") (wcmatch eq2 "УКП*"))
	(setq l (fix (+ 80 (* 50 (random)))))
	)
       (T
	(setq l (* 10 (fix (/ (* 50 (random)) 10))))
	)
       );cond

     (list
       (vla-get-TextString (getbatt cab "TYPE"))
       (vla-get-TextString (getbatt cab "CORES"))
       (vla-get-TextString (getbatt cab "SECTION"))
       (itoa l)
       )
     )
  cabs
  )
      )









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
  lst)




(setq ans '())
(mapcar
  '(lambda (c / cn tmp)
     ;(setq c (nth 12 lst))
     (setq cn (nth 1 c))
     (cond
       ((setq tmp (assoc cn ans))
	(setq ans (subst (append tmp (list (nth 9 c))) tmp ans))
	)
       (T (setq ans (append ans (list (list cn (nth 9 c))))))
       )
     )
  lst)


(setq out
(mapcar
  '(lambda (typ)
     ;(setq typ (nth 6 ans))
     (list (car typ) (apply '+ (mapcar 'atoi (cdr typ))))
     )
  ans)
)
;;;;  убираем строки с "пустыми" кабелями
(setq out (vl-remove-if-not '(lambda (x) (wcmatch (car x) "*КВВГ*")) out))
(setq out (vl-sort out '(lambda (a b) (< (car a) (car b)))))
(setq out (append out (list (list "Итого:" (apply '+ (mapcar 'cadr out))))))









