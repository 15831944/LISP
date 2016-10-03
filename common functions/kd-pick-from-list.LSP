;13_03_13

;(setq strlst '("NUMBER" "TYPE" "CORES" "CATEGORY" "LOCCAB" "LOCFLD" "SIGNALNAME" "VOLTAGE" "SECTION" "MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10" "MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20" "MARK21" "MARK22" "MARK23" "MARK24" "MARK25" "MARK26" "MARK27" "MARK28" "MARK29" "MARK30" "LENGTH" "CBL_FLD_ID" "CBL_LST_ID" "SIGN"))
;(setq strlst '("NUM_BER" "TYPE" "CORE_S" "CATEGORY" "LOCCAB" "LOCFLD"))
;(kw:pick-from-list '("NUMBER" "TYPE" "CORES" "CATEGORY" "LOCCAB" "LOCFLD" "SIGNALNAME" "VOLTAGE" "SECTION" "MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10" "MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20" "MARK21" "MARK22" "MARK23" ))
;(kw:pick-from-list '("NUM_BER" "TYPE" "CORES" "CATEGORY" "LOCCAB" "LOCFLD"))


;;; pick from list

(defun kw:pick-from-list (strlst / antisep lst init kword sel)
  (defun antisep (lst del) (vl-string-right-trim del (apply 'strcat (mapcar '(lambda (x) (strcat x del)) lst))))
  (setq lst (mapcar '(lambda (x) (vl-string-translate "_" "-" (strcase x))) strlst))
  (setq init (antisep lst " "))
  (setq init (strcat init " ALL"))
  (setq kword (antisep lst "/"))
  (setq kword (strcat kword "/ALL"))
  (initget (strcat init " _" init))
  (setq sel (vl-catch-all-apply (function (lambda () (initget (strcat init " _" init)) (getkword (strcat "Select an item [" kword "] :"))))))
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type sel)) nil)
    ((null sel) "ALL")
    (T (nth (vl-position sel lst) strlst))
    )
  
  );defun



;(kw:pick-from-list '("NUM_BER" "TYPE" "CORES" "CATEGORY" "LOCCAB" "LOCFLD"))

	 