
;	(mapcar 'vla-get-TagString (getbattswcmatch (vlax-ename->vla-object (car (entsel))) "*"))
;("NUMBER" "TYPE" "CORES" "CATEGORY" "LOCCAB" "LOCFLD" "SIGNALNAME" "VOLTAGE" "SECTION" "MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10" "MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20" "LENGTH" "CBL_FLD_ID" "CBL_LST_ID" "SIGN") 
(setq $compare:atts
       '("NUMBER" "TYPE" "CORES"
	 ;"LOCCAB" "LOCFLD"
	   "VOLTAGE" "SECTION"
	   ;"SIGNALNAME" "CATEGORY"
	   ;"MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10"
	   ;"MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20"
	   ;"LENGTH"
	   ;"SIGN"
	   )
      )

(defun comparecabs (c1 c2 attfltr / res)
  (vl-remove-if
    '(lambda (an)
       (= (vla-get-TextString (getbatt c1 an)) (vla-get-TextString (getbatt c2 an)))
       )
    attfltr
    )
  );defun




(setq oldcabls (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))
(length oldcabls)







(setq newcabls (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))
(length newcabls)

(setq oldcabsD '())
(setq newcabsD '())
(setq result nil)


(mapcar
  '(lambda (x / cn resnum compans)	;(setq x (nth 12 oldcabls))
     (setq cn (vla-get-TextString (getbatt x "NUMBER")))
     (setq resnum (vl-remove-if-not '(lambda (y) (= cn (vla-get-TextString (getbatt y "NUMBER")))) newcabls))
     (cond
       (
	(and
	  (= 1 (length resnum))
	  (null (setq compans (comparecabs x (car resnum) $compare:atts)))
	  )
	(princ)
	)
       
       (T (setq result (cons (list compans x) result)))
       )
       
     )
  oldcabls
  )

;;    это было долго...



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;  !!!    tbl|blrefs>table



(setq #oldcabls (tbl|blrefs>table (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT")))))))
(length #oldcabls)

(setq #newcabls (tbl|blrefs>table (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT")))))))
(length #newcabls)





(setq oldcabls (tbl|delcolumns oldcabls '("handle" "EFNAME" "CATEGORY" "VOLTAGE" "MARK20" "SIGNALNAME" "CBL_FLD_HAND" "CBL_LST_HAND" "CBL_FLD_ID" "CBL_LST_ID" "SIGN" "LENGTH")))
(setq newcabls (tbl|delcolumns newcabls '("handle" "EFNAME" "CATEGORY" "VOLTAGE" "MARK20" "SIGNALNAME" "CBL_FLD_HAND" "CBL_LST_HAND" "CBL_FLD_ID" "CBL_LST_ID" "SIGN" "LENGTH")))

(= (car oldcabls) (car newcabls))



(if (> (length oldcabls) (length newcabls)) (setq longbase oldcabls shortbase newcabls) (setq longbase newcabls shortbase oldcabls))


(setq res nil)
(mapcar
  '(lambda (line / tmp)	;(setq line (nth 13 longbase))
     (if
       (and
	 (setq tmp (member line shortbase))
	 (null (member line (cdr tmp)))
	 )
       (princ)
       (setq res (cons line res))
       )
     )
  longbase
  )
;		res








(defun sel (n / flto fltn)
(setq num (car (nth n res)))

(sssetfirst nil
(lst-to-ss
(mapcar
  '(lambda (h)
     (vla-HandleToObject #actdoc h)
     )
  (vl-remove 'nil
    (list
      (if (setq flto (tbl|filter #oldcabls (strcat "NUMBER=" num))) (tbl|gpar (car flto) (cadr flto) "handle"))
      (if (setq fltn (tbl|filter #newcabls (strcat "NUMBER=" num))) (tbl|gpar (car fltn) (cadr fltn) "handle"))
      ))
  )
))
  );defun


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load (strcat #lisppath "DataBase\\dblib.lsp"))


(setq #newcabls (tbl|blrefs>table (vl-remove-if-not '(lambda (x) (= "cbl_cnct" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT")))))))
(length #newcabls)

(setq #clbase (tbl|blrefs>table (vl-remove-if-not '(lambda (x) (= "cbl_lst-kks" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT")))))))
(length #clbase)




(mapcar
  '(lambda (x / cn fltr)		;(setq x (nth 87 #clbase))
     (setq cn (tbl|gpar (car #clbase) x "NUMBER"))
     ;(sssetfirst nil (lst-to-ss (list (vla-HandleToObject #actdoc (car x)))))
     ;(sssetfirst nil (lst-to-ss (list (vla-HandleToObject #actdoc (car (cadr (tbl|filter #newcabls (strcat "NUMBER=" cn))))))))
     (setq fltr (tbl|filter #newcabls (strcat "NUMBER=" cn)))
     ;(tbl|gpar (car fltr) (cadr fltr) "LOCCAB")
     ;(tbl|gpar (car #clbase) x "LOCCAB")
     ;(tbl|spar (car #clbase) x "LOCCAB" (tbl|gpar (car fltr) (cadr fltr) "LOCCAB"))

     (vla-put-TextString 
       (getbatt (vla-HandleToObject #actdoc (tbl|gpar (car #clbase) x "handle")) "LOCCAB")
       (vl-string-subst "\nШК" " ШК" (tbl|gpar (car fltr) (cadr fltr) "LOCCAB"))
       )

;;;     (vla-put-TextString 
;;;       (getbatt (vla-HandleToObject #actdoc (tbl|gpar (car #clbase) x "handle")) "LOCFLD")
;;;       (vl-string-subst "\nШ-" " Ш-" (tbl|gpar (car fltr) (cadr fltr) "LOCFLD"))
;;;       )
     
     )
  (cdr #clbase)
  )


