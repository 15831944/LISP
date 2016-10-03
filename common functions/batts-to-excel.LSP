;;; 13_12_13
;;; имеем кабельный журнал в модели сделанный блоками cbl_lst-kks
;;; с его стандартным набором аттрибутов

;(setq obj (vlax-ename->vla-object (car (entsel))))
;(setq atts (getbattswcmatch obj "*"))
;(length atts)
;attributes name list
;(setq anl (mapcar '(lambda (x) (vla-get-tagstring x)) atts))
;'("NUMBER" "TYPE" "CORES" "CATEGORY" "LOCCAB" "LOCFLD" "SIGNALNAME" "VOLTAGE" "SECTION" "MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10" "MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20" "MARK21" "MARK22" "MARK23" "MARK24" "MARK25" "MARK26" "MARK27" "MARK28" "MARK29" "MARK30" "LENGTH" "CBL_CNCT_ID" "CBL_FLD_ID" "NOTE")

;(setq db:head anl)


(defun kd:batts>excel ( / ss cabobjlist db:head)
  (setq ss (ssget '((0 . "INSERT"))))
  (setq cabobjlist (mapcar '(lambda (x) (vlax-ename->vla-object (cadr x))) (vl-remove-if-not '(lambda(x) (member (car x) '(1 2 3) )) (ssnamex ss))))
  (setq db:head (mapcar '(lambda (x) (vla-get-tagstring x)) (getbattswcmatch (car cabobjlist) "*")))
  (lst>excel (append (list db:head) (mapcar '(lambda(x) (mapcar '(lambda (an) (vla-get-TextString (getbatt x an))) db:head)) cabobjlist)))
  )
