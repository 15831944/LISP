;(load (strcat #lisppath "blocks and attribs\\blref-to-data.LSP"))
(load (strcat #lisppath "DataBase\\dblib.lsp"))

(lst>excel (mapcar 'sepstr* (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr x ":")) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr x "|")) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr x "/")) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr* x)) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (list (norus x))) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (list (noeng x))) (mapcar 'car (excel>lst))))





(setq NEPDI_PROJECT_TURBINE_LIST (vl-remove '"" (origlist (mapcar 'car (excel>lst)))))
(deoriglist NEPDI_PROJECT_TURBINE_LIST)
(length NEPDI_PROJECT_TURBINE_LIST)
57


(setq NEPDI_PROJECT_LIST (vl-remove-if '(lambda (line) (apply '= (cons "" line))) (excel>lst))) (length NEPDI_PROJECT_LIST)
(setq NEPDI_PROJECT_LIST (vl-remove '"" (mapcar 'car (excel>lst)))) (length NEPDI_PROJECT_LIST)
(length (origlist NEPDI_PROJECT_LIST))
(deoriglist NEPDI_PROJECT_LIST)
179

(setq NEPDI_PROJECT_TO_ATM22 (vl-remove '"" (mapcar 'car (excel>lst))))
(length NEPDI_PROJECT_TO_ATM22)
(length (origlist NEPDI_PROJECT_TO_ATM22))
38


















(setq INERAVT_CTRL_KKS_ZRA_LST (vl-remove '"" (origlist (mapcar 'car (excel>lst)))))
(length INERAVT_CTRL_KKS_ZRA_LST)
238

(setq ATM24_RELEASED_LST (vl-remove '"" (origlist (mapcar 'car (excel>lst)))))
(length ATM24_RELEASED_LST)
201

(length (andLIsts (list INERAVT_CTRL_KKS_ZRA_LST ATM24_RELEASED_LST)))
(lst>excel (inverse (db|diff INERAVT_CTRL_KKS_ZRA_LST ATM24_RELEASED_LST)))



;;;  îò èíòåðàâòîìàòèêè íå âûïóùåííûå â ÀÒÌ24
(setq not_relesed_BY_LIST_INERAVT (car (db|diff INERAVT_CTRL_KKS_ZRA_LST ATM24_RELEASED_LST))) (length not_relesed_BY_LIST_INERAVT)	;35

; çàìåíåíà íà äðóãèå 4 øòóêè
(setq not_relesed_BY_LIST_INERAVT (vl-remove "10LCN90AA110" not_relesed_BY_LIST_INERAVT)) (length not_relesed_BY_LIST_INERAVT)	;34
;	ÎÒ-øíèêè ñêàçàëè ëèøíÿÿ 11LBA10AA406
(setq not_relesed_BY_LIST_INERAVT (vl-remove "11LBA10AA406" not_relesed_BY_LIST_INERAVT)) (length not_relesed_BY_LIST_INERAVT)	;33

;	êîòîðûå ÿ çíàþ
(setq ATM22_known (vl-remove '"" (origlist (mapcar 'car (excel>lst))))) (length ATM22_known)	;33
(lst>excel (inverse (db|diff not_relesed_BY_LIST_INERAVT ATM22_known)))	;ok

ATM22_known = not_relesed_BY_LIST_INERAVT




(setq NEPDI_PROJECT_LIST (vl-remove '"" (mapcar 'car (excel>lst)))) (length NEPDI_PROJECT_LIST)	;212
(setq NEPDI_PROJECT_LIST (remove-first "10LBE10AA414" NEPDI_PROJECT_LIST))		; only once
(setq NEPDI_PROJECT_LIST (remove-first '"10LBE10AA416" NEPDI_PROJECT_LIST))	; only once
(setq NEPDI_PROJECT_LIST (remove-first '"10LCN90AA110" NEPDI_PROJECT_LIST))
(setq NEPDI_PROJECT_LIST (remove-first '"11LBA10AA406" NEPDI_PROJECT_LIST))
(length NEPDI_PROJECT_LIST)	;208

(lst>excel (inverse (db|diff NEPDI_PROJECT_LIST ATM24_RELEASED_LST)))
;;;  îò NEPDI íå âûïóùåííûå â ÀÒÌ24
(setq not_relesed_BY_LIST_NEPDI (car (db|diff NEPDI_PROJECT_LIST ATM24_RELEASED_LST))) (length not_relesed_BY_LIST_NEPDI)	;33


(lst>excel (inverse (db|diff not_relesed_BY_LIST_NEPDI ATM22_known)))
(lst>excel (inverse (db|diff not_relesed_BY_LIST_NEPDI not_relesed_BY_LIST_INERAVT)))

(lst>excel (cons '("nr_by_NEPDI" "nr_by_INERAVT") (inverse (list not_relesed_BY_LIST_NEPDI not_relesed_BY_LIST_INERAVT))))

(setq not_relesed_BY_BOTH (vl-remove '"" (mapcar 'car (excel>lst)))) (length not_relesed_BY_BOTH)	; 37 + 3(MAX)

(lst>excel (inverse (db|diff not_relesed_BY_BOTH ATM22_known)))
10MAX82AA101
10MAX81AA101
10MAX72AA101
10MAV73AA704
10MAV73AA703
10MAV71AA702
10MAV71AA701









(member "10MAV71AA702" INERAVT_CTRL_KKS_ZRA_LST)









(length (origlist NEPDI_PROJECT_LIST))
(deoriglist NEPDI_PROJECT_LIST)
179















(andLIsts (list INERAVT_CTRL_KKS_ZRA_LST NEPDI_PROJECT_TURBINE_LIST))
(length (andLIsts (list INERAVT_CTRL_KKS_ZRA_LST NEPDI_PROJECT_LIST)))
(lst>excel (inverse (db|diff INERAVT_CTRL_KKS_ZRA_LST NEPDI_PROJECT_LIST)))
248-4 = 244





(setq BNP_OT_LST (vl-remove '"" (mapcar 'car (excel>lst)))) 	(length BNP_OT_LST)
(deoriglist BNP_OT_LST)
210

(setq BNP_OT_PIDs (vl-remove '"" (mapcar 'car (excel>lst))))
(deoriglist BNP_OT_PIDs)
(length BNP_OT_PIDs)
208




(lst>excel (inverse (db|diff BNP_OT_LST BNP_OT_PIDs)))





(setq JAR_PLANT_BUYLIST (vl-remove '"" (mapcar 'car (excel>lst))))	(deoriglist JAR_PLANT_BUYLIST)
"10LBE20AA120" x 2
(length JAR_PLANT_BUYLIST)
163 ñ ïîâòîðÿþùåéñÿ
162 ñ ÐÎÓ
161 áåç ÐÎÓ




(lst>excel (inverse (db|diff BNP_OT_PIDs JAR_PLANT_BUYLIST)))

(setq andLst (andLIsts (list BNP_OT_PIDs JAR_PLANT_BUYLIST)))





(setq pneumo (vl-remove '"" (mapcar 'car (excel>lst)))) (length pneumo)
(lst>excel (mapcar 'sepstr* pneumo))




(setq XQ (vl-remove '"" (excel>lst)))	(length XQ)
(deoriglist XQ)
39


(setq ZV (vl-remove '"" (excel>lst)))	(length ZV)
(deoriglist ZV)
19


(setq ZQ (vl-remove '"" (excel>lst)))	(length ZQ)
(deoriglist ZQ)
25

(andLIsts
  (list
    (mapcar 'car (cdr XQ))
    ;(mapcar 'car (cdr ZV))
    (mapcar 'car (cdr ZQ))
    )
  )

(lst>excel
  (inverse
(list
    (cons "XQ" (mapcar 'car (cdr XQ)))
    (cons "ZV" (mapcar 'car (cdr ZV)))
    (cons "ZQ" (mapcar 'car (cdr ZQ)))
    )))





(setq l3 (vl-remove '"" (mapcar 'car (excel>lst))))	(length l3)
(deoriglist l3)
(length (origlist l3))
25



(setq l1 (vl-remove '"" (mapcar 'car (excel>lst))))	(length l1)
(deoriglist l1)
35
(setq l2 (vl-remove '"" (mapcar 'car (excel>lst))))	(length l2)
(deoriglist l2)
39

(length (andLIsts (list l1 l2)))
26


(length (andLIsts (list l1 l3)))


(lst>excel (inverse (db|diff l1 l2)))



(setq andl1l2 (andLIsts (list l1 l2)))
(db|diff l1 andl1l2)

(lst>excel (mapcar 'list (car (db|diff l2 andl1l2))))

(setq BYIED_MISSED-IN-OT (car (db|diff l2 l1)))

(setq prjData BYIED_MISSED-IN-OT)













(defun paint (hand col) (vlax-put-property (vla-HandleToObject #actdoc hand) "color" col))



(setq blreflst (ss->lsto* (ssget)))



(setq rev0:table (tbl|blrefs>table (ss->lsto* (ssget))))
(setq rev1:table (tbl|blrefs>table (ss->lsto* (ssget))))







(setq $head (car rev1:table))
(setq rev1:table (tbl|sort rev1:table "NUMBER"))
(setq rev2:table (tbl|sort rev2:table "NUMBER"))






(setq res '())
;(setq r1 (nth 23 rev1:table) r2 (nth 25 rev2:table))
(mapcar
  '(lambda (r1 r2)
     (if (/= (tbl|gpar (car rev1:table) r1 "LENGTH") (tbl|gpar (car rev1:table) r2 "LENGTH"))
       (setq res (cons (list (tbl|gpar $head r1 "handle") (tbl|gpar $head r2 "handle")) res))
       )
       
     )
  rev1:table rev2:table
  )



(mapcarx paint acYellow (apply 'append res))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;   äîçàïîëíåíèå äàííûõ

(setq rev1:table (tbl|blrefs>table (ss->lsto* (ssget))))

(setq rev2:table (tbl|blrefs>table (ss->lsto* (ssget))))



(mapcar
  '(lambda (cab / num src obj)
     (setq num (tbl|gpar (car rev2:table) cab "NUMBER"))
     (if
       (and
	 (setq src (tbl|filter rev1:table (strcat "NUMBER=" num)))
	 (= 2 (length src))
	 (setq src (cadr src))
	 )
       (progn
	 (setq obj (vla-HandleToObject #actdoc (tbl|gpar (car rev2:table) cab "handle")))
	 (vla-put-TextString
	   (getbatt obj "LENGTH")
	   (tbl|gpar (car rev1:table) src "LENGTH")
	   )
	 )
       )
     )
  (cdr rev2:table)
  )




(mapcar
  '(lambda (cab / num src obj)
     (setq num (tbl|gpar (car rev2:table) cab "NUMBER"))
     (if
       (and
	 (setq src (tbl|filter rev1:table (strcat "NUMBER=" num)))
	 (= 2 (length src))
	 (setq src (cadr src))
	 )
       (progn
	 (setq obj (vla-HandleToObject #actdoc (tbl|gpar (car rev2:table) cab "handle")))
	 (vla-put-TextString
	   (getbatt obj "NOTE")
	   (tbl|gpar (car rev1:table) src "NOTE")
	   )
	 )
       )
     )
  (cdr rev2:table)
  )









(setq #base
       '(
  ("controller_cabinet" ("CABINET"))
  ("controller_clampAI" ("CLAMP" "NAME"))
  ("cbl_cnct" ("NUMBER" "TYPE" "CORES"  "LOCCAB" "LOCFLD" "SIGNALNAME"  "SECTION") )
  ("controller_AI420"  ("CL1" "CL2" "MARK1" "MARK2" "KKS" "MEAS_NAME"))
  ("controller_clampDI" ("CLAMP" "NAME"))
  ("controller_DI" ("RELAY" "MARK1" "MARK2" "ÊÎÌÀÍÄÀ"))
  ("controller_DO" ("RELAY" "MARK1" "MARK2" "ÊÎÌÀÍÄÀ"))
  ("format" ("ÍÎÌÅÐ_ËÈÑÒÀ" "×ÅÐÒÅÆ1" "×ÅÐÒÅÆ2" "×ÅÐÒÅÆ3"))
  ("format-spec" ("ÍÎÌÅÐ_ËÈÑÒÀ"))
  ))


(origlist (mapcar '(lambda (x) (vla-get-EffectiveName x)) (ss->lsto* (ssget '((0 . "INSERT"))))))


(setq #clbase
       '(
	 ("controller_AI420"  ("CL1" "CL2" "MARK1" "MARK2" "KKS" "MEAS_NAME"))
	 ("controller_clampDI" ("CLAMP" "NAME"))
	 ("controller_DI" ("RELAY" "MARK1" "MARK2" "ÊÎÌÀÍÄÀ"))
	 ("controller_DO" ("RELAY" "MARK1" "MARK2" "ÊÎÌÀÍÄÀ"))
	 ))


(setq oldss (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (mapcar 'car #clbase))) (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "INSERT"))) "-y"))))
(setq newss (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (mapcar 'car #clbase))) (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "INSERT"))) "-y"))))


(mapcar '(lambda (n) (vlax-put-property n "color" acYellow)) oldss)
(mapcar '(lambda (n) (vlax-put-property n "color" acYellow)) newss)


(mapcar
  '(lambda (o / tags filter)	;(setq o (vlax-ename->vla-object (car (entsel))))

     (setq tags (assoc (vla-get-EffectiveName o) #clbase))

     (setq filter
	    (vl-remove-if-not
	      '(lambda (n)
		 (and
		   (= (car tags) (vla-get-EffectiveName n))
		   (apply 'and
			  
		   
			 (mapcar
		     '(lambda (tag)
			(=
			  (vla-get-TextString (getbatt o tag))
			  (vla-get-TextString (getbatt n tag))
			  )
			)
		     (cadr tags)
		     )
			 )
		   )
		 )
	      newss
	      )
	   )
     (cond
       ((= 1 (length filter))
	(vlax-put-property (car filter) "color" acByLayer)
	(vlax-put-property o "color" acByLayer)
	)
       )
     )
  oldss
  )








(defun compare ( / oldss newss  base)
  (setq oldss (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "INSERT"))) "-y")))
  (setq newss (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "INSERT"))) "-y")))
  (if (= (length oldss) (length newss))
    (mapcar 'compareblocks oldss newss)
    (princ "\nÍÅ ÐÀÂÍÛÉ ÍÀÁÎÐ")
    )
  )


;(getbattswcmatch (vlax-ename->vla-object (car (entsel))) "*")

;(setq b1 (vlax-ename->vla-object (car (entsel))))
;(setq b2 (vlax-ename->vla-object (car (entsel))))


(defun compareblocks (b1 b2 / atts1 atts2 res)
  (cond
    ((and (setq atts1 (getbattswcmatch b1 "*")) (setq atts2 (getbattswcmatch b2 "*")))
     (if
     (apply
       'and
       (cons
	 (= (vla-get-EffectiveName b1) (vla-get-EffectiveName b2))
	 (mapcar
	   '(lambda (a1 a2)
	      (and
		(= (vla-get-TagString a1) (vla-get-TagString a2))
		(= (vla-get-TextString a1) (vla-get-TextString a2))
		)
	      )
	   atts1 atts2
	   )))
     T
     (vlax-put-property b2 "color" acRed)
     ))
    (T (= (vla-get-EffectiveName b1) (vla-get-EffectiveName b2)))
    )
  );defun

(compareblocks (vlax-ename->vla-object (car (entsel))) (vlax-ename->vla-object (car (entsel))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ssgetin (bname)
  (vl-remove-if-not '(lambda (x) (= bname (vla-get-EffectiveName x)))
    (ss->lsto* (ssget '((0 . "INSERT")))))
  );defun




(setq newcabs (ssgetin "cbl_cnct"))

(setq oldcabs (ssgetin "cbl_cnct"))




(defun comparecabs (c1 c2 / atts1 atts2 attnames res)
  (setq res nil)
  (setq attnames
	 '("NUMBER" "TYPE" "CORES" "LOCCAB" "LOCFLD"
	   "VOLTAGE" "SECTION"
	   ;"SIGNALNAME" "CATEGORY"
	   "MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10"
	   "MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20"
	   ;"LENGTH"
	   "SIGN"
	   )
	 )
  ;(setq c1 (vlax-ename->vla-object (car (entsel))))
  ;(setq c2 (vlax-ename->vla-object (car (entsel))))
  ;(mapcar 'vla-get-TagString (getbattswcmatch c1 "*"))
  (mapcar
    '(lambda (an)
       (if (/= (vla-get-TextString (getbatt c1 an)) (vla-get-TextString (getbatt c2 an)))
	 (setq res (cons an res))
	 )
       )
    attnames
    )
  (if res res T)
  );defun







(setq newcabs (ssgetin "cbl_cnct"))

(setq oldcabs (ssgetin "cbl_cnct"))




(mapcar
  '(lambda (oc / cn fb dif)
     ;(setq oc (vlax-ename->vla-object (car (entsel))))
     (setq cn (vla-get-TextString (getbatt oc "NUMBER")))
     (setq fb (vl-remove-if-not '(lambda (x) (= cn (vla-get-TextString (getbatt x "NUMBER")))) newcabs))
     (if (and (= 1 (length fb)) (= T (comparecabs oc (car fb))) )
       (paint (vla-get-Handle oc) 250)
       (paint (vla-get-Handle oc) acRed)
       )
       
     )
  oldcabs
  )
(mapcar
  '(lambda (oc / cn fb dif)
     ;(setq oc (vlax-ename->vla-object (car (entsel))))
     (setq cn (vla-get-TextString (getbatt oc "NUMBER")))
     (setq fb (vl-remove-if-not '(lambda (x) (= cn (vla-get-TextString (getbatt x "NUMBER")))) oldcabs))
     (if (and (= 1 (length fb)) (= T (comparecabs oc (car fb))) )
       (paint (vla-get-Handle oc) 250)
       (paint (vla-get-Handle oc) acRed)
       )
       
     )
  newcabs
  )






(setq nums (mapcar '(lambda (x) (vla-get-TextString (getbatt x "NUMBER"))) (ss->lsto* (ssget '((0 . "INSERT"))))))

(setq cabs (vl-remove-if-not '(lambda (x) (and (= "cbl_cnct" (vla-get-EffectiveName x)) (member (vla-get-TextString (getbatt x "NUMBER")) nums)) ) (ss->lsto* (ssget '((0 . "INSERT"))))))
(sssetfirst nil (lst-to-ss cabs))




;("controller_cabinet" "controller_clampAI" "cbl_cnct" "controller_AI420" "controller_clampDI" "controller_DI" "controller_DO") 



;(vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) '())) (ss->lsto* (ssget '((0 . "INSERT")))))




(setq #clbase
       '(
	 ("controller_AI420"  ("CL1" "CL2" "MARK1" "MARK2" "KKS" "MEAS_NAME"))
	 ("controller_clampDI" ("CLAMP" "NAME"))
	 ("controller_DI" ("RELAY" "MARK1" "MARK2" "ÊÎÌÀÍÄÀ"))
	 ("controller_DO" ("RELAY" "MARK1" "MARK2" "ÊÎÌÀÍÄÀ"))
	 ))



(setq newss (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (mapcar 'car #clbase))) (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "INSERT"))) "-y"))))

(setq oldss (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (mapcar 'car #clbase))) (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "INSERT"))) "-y"))))
(= (length oldss) (length newss))



(mapcar
  '(lambda (n o / ef) ;(setq n (nth 36 newss) o (nth 36 oldss))
     ;(setq o (vlax-ename->vla-object (car (entsel))))
     ;(setq n (vlax-ename->vla-object (car (entsel))))
     (if
     (and
       (setq ef (vla-get-EffectiveName n))
       (= (vla-get-EffectiveName n) (vla-get-EffectiveName o))
       (apply 'and (mapcar '(lambda (tag)
	    (= (vla-get-TextString (getbatt n tag)) (vla-get-TextString (getbatt o tag))))
	 (cadr (assoc ef #clbase))
	 ))
       )
     (progn (paint (vla-get-Handle n) 250) (paint (vla-get-Handle o) 250))
     (progn (paint (vla-get-Handle n) acRed) (paint (vla-get-Handle o) acRed))
     )
     )
  newss oldss)



(defun asd (/ n o ef)
  (setq o (vlax-ename->vla-object (car (entsel))))
  (setq n (vlax-ename->vla-object (car (entsel))))
  (setq ef (vla-get-EffectiveName n))
  (mapcar
    '(lambda (tag)
       (if (/= (vla-get-TextString (getbatt n tag)) (vla-get-TextString (getbatt o tag)))
	 (princ tag)
	 )
       )
    (cadr (assoc ef #clbase))
    )
  );defun





(tbl|getdata 'src)

(setq destassoc (mapcar 'car (excel>lst)))

(setq ans
(mapcar
  '(lambda (x)
     (assoc x src)
     )
  destassoc
  ))

(lst>excel ans)















(tbl|getdata 'released)




(setq PIDs (vl-remove '"" (mapcar 'car (excel>lst))))
(setq Done (vl-remove '"" (mapcar 'car (excel>lst))))

(lst>excel (inverse (db|diff PIDs Done)))
(lst>excel (mapcar 'list (ANDlists (list PIDs Done))))


(setq PIDsDone (ANDlists (list PIDs Done)))


;(setq objlst (vl-remove-if-not '(lambda (b) (member (kd-get-textstring (getbatt b "KKS")) PIDsDone)) (ss:getBRefs '("PID_eq_sign"))))
;(sssetfirst nil (lst-to-ss objlst))




(setq BNSandCRMandCNS (vl-remove '"" (mapcar 'car (excel>lst))))
(length BNSandCRMandCNS)
(setq PIDs (mapcar '(lambda (b) (vla-get-textstring (getbatt b "KKS"))) (ss:getBRefs '("PID_eq_sign"))))

(setq diff (db|diff BNSandCRMandCNS PIDs))
(length (car diff))

(ANDlists (list BNSandCRMandCNS PIDs))

(lst>excel (inverse diff))
















