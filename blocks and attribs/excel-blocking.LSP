	
(setq #blks>linkingOption nil)

(defun c:blks>excel ( / lst head data)
  (princ "\n_______\n")
  (princ (strcat "#blks>linkingOption variable is          >> "
		 (any-to-string #blks>linkingOption) " <<\n"
		 "\n    1     is for     Handle"
		 "\n    2     is for     FieldString"
		 "\n 0, nil or other is for TextString"
		 ))
  (princ "\n_______\n")
  (if
    (or
      (setq lst (ssget "_I" '((0 . "INSERT"))))
      (and (setq lst (ssget* '((0 . "INSERT")))) (= 'PICKSET (type lst)))
      )
    (progn
      (princ "\n\nPlease do not change a handle column\n")
      (setq lst (ss->lsto lst))
      (setq data (mapcar '(lambda (x) (blref-to-data x #blks>excel:isFielding)) lst))
      (setq head (origlist (mapcar 'car (apply 'append data))))      

      (setq res
	     (mapcar
	       '(lambda (bobj)	;(setq bobj (nth 3 lst))	(setq bobj (nth 2 data))
		  (mapcar
		    '(lambda (par / a)
		       (if (setq a (assoc par bobj)) (cadr a)"")
		       )
		    head
		    )
		  )
	       data
	       )
	    )
      (lst>excel (cons head res))
      )
    )
  );defun







(defun c:excel>blks ( / lst head data reprt htn htns bname)
  (setq #excel>blks:reprt nil)
  (if (and
	(setq lst (db|formatdata (excel>lst)))
	(setq data (cdr lst) head (car lst))
	(setq htns (vl-remove-if-not '(lambda (x) (= "[BN]=" (substr x 1 5))) head))
	)
    (progn
      (mapcar
	'(lambda (htn)
      
      (setq bname (cadr (sepstr htn "=")))
      (mapcar
	'(lambda (line / h bobj)	;(setq line (nth 0 data))
	   (setq h (nth (vl-position htn head) line))
	   (if (/= "" h)
	     (progn
	       (setq bobj (vl-catch-all-apply 'vla-HandleToObject (list #actdoc h)))
	       (cond
	     ((= (type bobj) 'VLA-OBJECT)
	      (mapcar
		'(lambda (tag / att aval val)	;(setq tag "PROP1")
		   (if (setq att (getbatt bobj tag))
		     (progn
		       (setq aval (kd-get-textstring att))
		       (setq val (nth (vl-position tag head) line))
		       (vla-put-TextString att val)
		       (if (/= aval val) (setq #excel>blks:reprt (cons (list h (strcat "TAG '" tag "' changed from '" aval "' to '" val "'")) #excel>blks:reprt)))
		       )
		     )
		   )
		(vl-remove htn head)
		)
	      
	      )
	     
	     ((= (type bobj) 'VL-CATCH-ALL-APPLY-ERROR) (setq #excel>blks:reprt (cons (list h (VL-CATCH-ALL-ERROR-MESSAGE bobj)) #excel>blks:reprt)))
	     );cond
	       )
	     )
	   )
	data
	)
	   )
      htns
      )
      )
    (alert "в выделенном диапазоне в Excel не найден столбец с handle'ами")
    )
  (princ "\n\n inspect #excel>blks:reprt to see report")
  (princ)
  );defun






; проверяем соответствие файла ексель -  все ли его записи есть в чертеже

(defun c:excel<>blocks ( / lst data head htns)
  (setq #excel<>blks:reprt nil)
  (if (and
	(setq lst (db|formatdata (excel>lst)))
	(setq data (cdr lst) head (car lst))
	(setq htns (vl-remove-if-not '(lambda (x) (= "[BN]=" (substr x 1 5))) head))
	)
    (progn
      (mapcar
	'(lambda (htn / bname)	;(setq htn (car htns))
	   (setq bname (cadr (sepstr htn "=")))
	   (mapcar
	     '(lambda (line / hand bobj)	;(setq line (nth 0 data))
		(setq hand (nth (vl-position htn head) line))
		(if (/= "" hand)
		  (progn
		    (setq bobj (vl-catch-all-apply 'vla-HandleToObject (list #actdoc hand)))
		    (cond
		      ((= (type bobj) 'VLA-OBJECT)
		       (mapcar
			 '(lambda (tag / att dwgval xlsval)	;(setq tag (nth 3 (vl-remove htn head)))
			    (if (setq att (getbatt bobj tag))
			      (progn
				(setq dwgval (kd-get-textstring att))
				(setq xlsval (nth (vl-position tag head) line))
				
				(if (/= dwgval xlsval)
				  (setq #excel<>blks:reprt
					 (cons
					   (list
					     bname
					     hand
					     tag
					     dwgval
					     xlsval
					     )
					   #excel<>blks:reprt
					   )
					)
				  )
				)
			      )
			    )
			 (vl-remove htn head)
			 )
		       )
		      ((= (type bobj) 'VL-CATCH-ALL-APPLY-ERROR)
		       (setq #excel<>blks:reprt
			      (cons
				(list
				  bname
				  hand "" "" ""
				  (VL-CATCH-ALL-ERROR-MESSAGE bobj)
				  )
				#excel<>blks:reprt
				)
			     )
		       )
		      );cond
		    )
		  )
		)
	     data
	     )
	   )
	htns
	)
      (if #excel<>blks:reprt (setq #excel<>blks:reprt (cons '("EffectiveName" "Handle" "TAG" "DWGVAL" "XLSVAL" "ERROR") #excel<>blks:reprt)))
      )
    )
  (if #excel<>blks:reprt (lst>excel #excel<>blks:reprt) (alert "synchronized"))
  (princ)
  );defun



(defun c:exc|highlight ( / excSelection hands lst)
  (setq excSelection (excel>lst))
  (if (listp excSelection)
    (setq hands (vl-remove-if '(lambda (x) (or
					     (null x)
					     (= x "")
					     (wcmatch x "* *,*`.*,*|*,*\\*,*/*,*;*,*\"*,*=*,*+*,*-*,*`**")
					     ;(wcmatch x "* *,*`,*,*`.*,*|*,*\\*,*/*,*;*,*\"*,*=*,*+*,*-*,*`**")
					     )) (apply 'append (excel>lst))))
    (setq hands (list excSelection))
    )
  (setq hands
  (apply 'append
  (mapcar
    '(lambda (x)	;(setq x (car hands))
       (if (wcmatch x "*`,*")
	 (sepstr x ",")
	 (list x)
	 )
       )
    hands))
	)
  (setq lst (vl-remove 'nil (mapcar
	 '(lambda (h / catch)
	    (setq catch (vl-catch-all-apply 'vla-HandleToObject (list #actdoc h)))
	    (cond
	      ((= 'VL-CATCH-ALL-APPLY-ERROR (type catch)) nil)
	      ((= 'VLA-OBJECT (type catch)) catch)
	      (T nil)
	      ))hands)))
  (sssetfirst nil (lst-to-ss lst))
  );defun







;(setq tbl #$Contacts)
;(setq tbl '(("ADDRESS1" "ADDRESS2" "ADDRESS3" "ADDRESS4" "MARK" "LOOP_TYPE" "F_PID" "LOOP_KKSID" "LOOP_NAME" "PROTOTYPE" "PSU" "S_TYPE" "Dtr" "V_MIN" "V_NOM" "V_MAX" "UNITS" "T" "P" "F" "A_LL" "A_L" "A_H" "A_HH" "S_LL" "S_L" "S_H" "S_HH" "scale" "PARAM" "ENVIR" "PIPELOC" "F_FLD" "F_CAB" "place_sensor" "OUT") ("@FLD" "@Stand" "@Sensor" "1" "UE003-1" "M:2W" "PT" "UE003" "Давление на напоре насоса № 1 кислотной промывки котлов" "APС-2000ALW" "UG1.1" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №1" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "1-" "UE003-1" "M:2W" "PT" "UE003" "Давление на напоре насоса № 1 кислотной промывки котлов" "APС-2000ALW" "UG1.1" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №1" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "2" "UE003-2" "M:2W" "PT" "UE003" "Давление на напоре насоса № 1 кислотной промывки котлов" "APС-2000ALW" "UG1.1" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №1" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "2-" "UE003-2" "M:2W" "PT" "UE003" "Давление на напоре насоса № 1 кислотной промывки котлов" "APС-2000ALW" "UG1.1" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №1" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "1+" "UE003-3" "M:2W" "PT" "UE003" "Давление на напоре насоса № 1 кислотной промывки котлов" "APС-2000ALW" "UG1.1" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №1" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "2+" "UE003-3" "M:2W" "PT" "UE003" "Давление на напоре насоса № 1 кислотной промывки котлов" "APС-2000ALW" "UG1.1" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №1" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "1" "UE004-1" "M:2W" "PT" "UE004" "Давление на напоре насоса № 2 кислотной промывки котлов" "APС-2000ALW" "UG1.2" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №2" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "1-" "UE004-1" "M:2W" "PT" "UE004" "Давление на напоре насоса № 2 кислотной промывки котлов" "APС-2000ALW" "UG1.2" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №2" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "2" "UE004-2" "M:2W" "PT" "UE004" "Давление на напоре насоса № 2 кислотной промывки котлов" "APС-2000ALW" "UG1.2" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №2" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "2-" "UE004-2" "M:2W" "PT" "UE004" "Давление на напоре насоса № 2 кислотной промывки котлов" "APС-2000ALW" "UG1.2" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №2" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "1+" "UE004-3" "M:2W" "PT" "UE004" "Давление на напоре насоса № 2 кислотной промывки котлов" "APС-2000ALW" "UG1.2" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №2" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "2+" "UE004-3" "M:2W" "PT" "UE004" "Давление на напоре насоса № 2 кислотной промывки котлов" "APС-2000ALW" "UG1.2" "420AI" "" "0" "0,6" "" "МПа" "30" "" "" "" "" "" "" "" "" "" "" "" "Давление" "Кислая вода" "Напор насоса №2" "PIT" "I" "UE-СД1" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "1L" "UE007-1" "M:4W" "LT" "UE007" "Уровень в баке-усреднителе сбора стоков кислотной промывки котлов" "VEGAPULS 62" "UG2.1" "420AI" "" "0" "" "8,2" "м" "100" "" "" "" "0,53" "8,2" "" "" "0,53" "8,2" "" "" "Уровень" "Кислая вода" "Бак-усреднитель" "LIT" "SLAHL" "По месту" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "1+" "UE007-1" "M:4W" "LT" "UE007" "Уровень в баке-усреднителе сбора стоков кислотной промывки котлов" "VEGAPULS 62" "UG2.1" "420AI" "" "0" "" "8,2" "м" "100" "" "" "" "0,53" "8,2" "" "" "0,53" "8,2" "" "" "Уровень" "Кислая вода" "Бак-усреднитель" "LIT" "SLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "2N" "UE007-2" "M:4W" "LT" "UE007" "Уровень в баке-усреднителе сбора стоков кислотной промывки котлов" "VEGAPULS 62" "UG2.1" "420AI" "" "0" "" "8,2" "м" "100" "" "" "" "0,53" "8,2" "" "" "0,53" "8,2" "" "" "Уровень" "Кислая вода" "Бак-усреднитель" "LIT" "SLAHL" "По месту" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "2-" "UE007-2" "M:4W" "LT" "UE007" "Уровень в баке-усреднителе сбора стоков кислотной промывки котлов" "VEGAPULS 62" "UG2.1" "420AI" "" "0" "" "8,2" "м" "100" "" "" "" "0,53" "8,2" "" "" "0,53" "8,2" "" "" "Уровень" "Кислая вода" "Бак-усреднитель" "LIT" "SLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "3+" "UE007-3" "M:4W" "LT" "UE007" "Уровень в баке-усреднителе сбора стоков кислотной промывки котлов" "VEGAPULS 62" "UG2.1" "420AI" "" "0" "" "8,2" "м" "100" "" "" "" "0,53" "8,2" "" "" "0,53" "8,2" "" "" "Уровень" "Кислая вода" "Бак-усреднитель" "LIT" "SLAHL" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "2+" "UE007-3" "M:4W" "LT" "UE007" "Уровень в баке-усреднителе сбора стоков кислотной промывки котлов" "VEGAPULS 62" "UG2.1" "420AI" "" "0" "" "8,2" "м" "100" "" "" "" "0,53" "8,2" "" "" "0,53" "8,2" "" "" "Уровень" "Кислая вода" "Бак-усреднитель" "LIT" "SLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "4-" "UE007-4" "M:4W" "LT" "UE007" "Уровень в баке-усреднителе сбора стоков кислотной промывки котлов" "VEGAPULS 62" "UG2.1" "420AI" "" "0" "" "8,2" "м" "100" "" "" "" "0,53" "8,2" "" "" "0,53" "8,2" "" "" "Уровень" "Кислая вода" "Бак-усреднитель" "LIT" "SLAHL" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "1-" "UE007-4" "M:4W" "LT" "UE007" "Уровень в баке-усреднителе сбора стоков кислотной промывки котлов" "VEGAPULS 62" "UG2.1" "420AI" "" "0" "" "8,2" "м" "100" "" "" "" "0,53" "8,2" "" "" "0,53" "8,2" "" "" "Уровень" "Кислая вода" "Бак-усреднитель" "LIT" "SLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "1L" "UE008-1" "M:4W" "LT" "UE008" "Уровень в баке-нейтрализаторе кислотной промывки котлов" "VEGAPULS 65" "UG2.2" "420AI" "" "0" "" "7,1" "м" "30" "" "" "" "0,5" "7,1" "" "" "0,5" "7,1" "" "" "Уровень" "Кислая вода" "Бак-нейтрализатор" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "1+" "UE008-1" "M:4W" "LT" "UE008" "Уровень в баке-нейтрализаторе кислотной промывки котлов" "VEGAPULS 65" "UG2.2" "420AI" "" "0" "" "7,1" "м" "30" "" "" "" "0,5" "7,1" "" "" "0,5" "7,1" "" "" "Уровень" "Кислая вода" "Бак-нейтрализатор" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "2N" "UE008-2" "M:4W" "LT" "UE008" "Уровень в баке-нейтрализаторе кислотной промывки котлов" "VEGAPULS 65" "UG2.2" "420AI" "" "0" "" "7,1" "м" "30" "" "" "" "0,5" "7,1" "" "" "0,5" "7,1" "" "" "Уровень" "Кислая вода" "Бак-нейтрализатор" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "2-" "UE008-2" "M:4W" "LT" "UE008" "Уровень в баке-нейтрализаторе кислотной промывки котлов" "VEGAPULS 65" "UG2.2" "420AI" "" "0" "" "7,1" "м" "30" "" "" "" "0,5" "7,1" "" "" "0,5" "7,1" "" "" "Уровень" "Кислая вода" "Бак-нейтрализатор" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "3+" "UE008-3" "M:4W" "LT" "UE008" "Уровень в баке-нейтрализаторе кислотной промывки котлов" "VEGAPULS 65" "UG2.2" "420AI" "" "0" "" "7,1" "м" "30" "" "" "" "0,5" "7,1" "" "" "0,5" "7,1" "" "" "Уровень" "Кислая вода" "Бак-нейтрализатор" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "2+" "UE008-3" "M:4W" "LT" "UE008" "Уровень в баке-нейтрализаторе кислотной промывки котлов" "VEGAPULS 65" "UG2.2" "420AI" "" "0" "" "7,1" "м" "30" "" "" "" "0,5" "7,1" "" "" "0,5" "7,1" "" "" "Уровень" "Кислая вода" "Бак-нейтрализатор" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "4-" "UE008-4" "M:4W" "LT" "UE008" "Уровень в баке-нейтрализаторе кислотной промывки котлов" "VEGAPULS 65" "UG2.2" "420AI" "" "0" "" "7,1" "м" "30" "" "" "" "0,5" "7,1" "" "" "0,5" "7,1" "" "" "Уровень" "Кислая вода" "Бак-нейтрализатор" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "1-" "UE008-4" "M:4W" "LT" "UE008" "Уровень в баке-нейтрализаторе кислотной промывки котлов" "VEGAPULS 65" "UG2.2" "420AI" "" "0" "" "7,1" "м" "30" "" "" "" "0,5" "7,1" "" "" "0,5" "7,1" "" "" "Уровень" "Кислая вода" "Бак-нейтрализатор" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "1L" "UE009-1" "M:4W" "LT" "UE009" "Уровень в баке-отстойнике нейтрализованных стоков" "VEGAPULS 62" "UG2.3" "420AI" "" "0" "" "11,0" "м" "30" "" "" "" "" "11,0" "" "" "" "11,0" "" "" "Уровень" "Кислая вода" "Бак-отстойник" "LIT" "AH" "По месту" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "1+" "UE009-1" "M:4W" "LT" "UE009" "Уровень в баке-отстойнике нейтрализованных стоков" "VEGAPULS 62" "UG2.3" "420AI" "" "0" "" "11,0" "м" "30" "" "" "" "" "11,0" "" "" "" "11,0" "" "" "Уровень" "Кислая вода" "Бак-отстойник" "LIT" "AH" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "2N" "UE009-2" "M:4W" "LT" "UE009" "Уровень в баке-отстойнике нейтрализованных стоков" "VEGAPULS 62" "UG2.3" "420AI" "" "0" "" "11,0" "м" "30" "" "" "" "" "11,0" "" "" "" "11,0" "" "" "Уровень" "Кислая вода" "Бак-отстойник" "LIT" "AH" "По месту" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "2-" "UE009-2" "M:4W" "LT" "UE009" "Уровень в баке-отстойнике нейтрализованных стоков" "VEGAPULS 62" "UG2.3" "420AI" "" "0" "" "11,0" "м" "30" "" "" "" "" "11,0" "" "" "" "11,0" "" "" "Уровень" "Кислая вода" "Бак-отстойник" "LIT" "AH" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "3+" "UE009-3" "M:4W" "LT" "UE009" "Уровень в баке-отстойнике нейтрализованных стоков" "VEGAPULS 62" "UG2.3" "420AI" "" "0" "" "11,0" "м" "30" "" "" "" "" "11,0" "" "" "" "11,0" "" "" "Уровень" "Кислая вода" "Бак-отстойник" "LIT" "AH" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "2+" "UE009-3" "M:4W" "LT" "UE009" "Уровень в баке-отстойнике нейтрализованных стоков" "VEGAPULS 62" "UG2.3" "420AI" "" "0" "" "11,0" "м" "30" "" "" "" "" "11,0" "" "" "" "11,0" "" "" "Уровень" "Кислая вода" "Бак-отстойник" "LIT" "AH" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "4-" "UE009-4" "M:4W" "LT" "UE009" "Уровень в баке-отстойнике нейтрализованных стоков" "VEGAPULS 62" "UG2.3" "420AI" "" "0" "" "11,0" "м" "30" "" "" "" "" "11,0" "" "" "" "11,0" "" "" "Уровень" "Кислая вода" "Бак-отстойник" "LIT" "AH" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "1-" "UE009-4" "M:4W" "LT" "UE009" "Уровень в баке-отстойнике нейтрализованных стоков" "VEGAPULS 62" "UG2.3" "420AI" "" "0" "" "11,0" "м" "30" "" "" "" "" "11,0" "" "" "" "11,0" "" "" "Уровень" "Кислая вода" "Бак-отстойник" "LIT" "AH" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "1L" "UE010-1" "M:4W" "LT" "UE010" "Уровень в дренажном приямке" "VEGASON 62" "UG2.4" "420AI" "" "0" "" "1" "м" "30" "" "" "" "0,15" "0,85" "" "" "0,15" "0,85" "" "" "Уровень" "Кислая вода" "Дренажный приямок" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "1+" "UE010-1" "M:4W" "LT" "UE010" "Уровень в дренажном приямке" "VEGASON 62" "UG2.4" "420AI" "" "0" "" "1" "м" "30" "" "" "" "0,15" "0,85" "" "" "0,15" "0,85" "" "" "Уровень" "Кислая вода" "Дренажный приямок" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "2N" "UE010-2" "M:4W" "LT" "UE010" "Уровень в дренажном приямке" "VEGASON 62" "UG2.4" "420AI" "" "0" "" "1" "м" "30" "" "" "" "0,15" "0,85" "" "" "0,15" "0,85" "" "" "Уровень" "Кислая вода" "Дренажный приямок" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@CABPSU" "@UG" "@CH" "2-" "UE010-2" "M:4W" "LT" "UE010" "Уровень в дренажном приямке" "VEGASON 62" "UG2.4" "420AI" "" "0" "" "1" "м" "30" "" "" "" "0,15" "0,85" "" "" "0,15" "0,85" "" "" "Уровень" "Кислая вода" "Дренажный приямок" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "3+" "UE010-3" "M:4W" "LT" "UE010" "Уровень в дренажном приямке" "VEGASON 62" "UG2.4" "420AI" "" "0" "" "1" "м" "30" "" "" "" "0,15" "0,85" "" "" "0,15" "0,85" "" "" "Уровень" "Кислая вода" "Дренажный приямок" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "2+" "UE010-3" "M:4W" "LT" "UE010" "Уровень в дренажном приямке" "VEGASON 62" "UG2.4" "420AI" "" "0" "" "1" "м" "30" "" "" "" "0,15" "0,85" "" "" "0,15" "0,85" "" "" "Уровень" "Кислая вода" "Дренажный приямок" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "@Stand" "@Sensor" "4-" "UE010-4" "M:4W" "LT" "UE010" "Уровень в дренажном приямке" "VEGASON 62" "UG2.4" "420AI" "" "0" "" "1" "м" "30" "" "" "" "0,15" "0,85" "" "" "0,15" "0,85" "" "" "Уровень" "Кислая вода" "Дренажный приямок" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "1-" "UE010-4" "M:4W" "LT" "UE010" "Уровень в дренажном приямке" "VEGASON 62" "UG2.4" "420AI" "" "0" "" "1" "м" "30" "" "" "" "0,15" "0,85" "" "" "0,15" "0,85" "" "" "Уровень" "Кислая вода" "Дренажный приямок" "LIT" "SHLAHL" "По месту" "Шкаф контроллера №1") ("@FLD" "" "@Sensor" "SCT" "UE011.1-0" "M:MARK" "QIT" "UE011.1" "pH в линии рециркуляции нейтрализованных стоков" "МАРК-902МП" "" "420AI" "" "1,5" "" "10" "pH" "30" "0,6" "" "" "" "" "" "" "" "" "" "" "pH" "Кислая вода" "Линия рециркуляции" "QIT" "I" "По месту" "Шкаф контроллера №1") ("@CABMARK" "@P" "CHA" "SCT" "UE011.1-0" "M:MARK" "QIT" "UE011.1" "pH в линии рециркуляции нейтрализованных стоков" "МАРК-902МП" "" "420AI" "" "1,5" "" "10" "pH" "30" "0,6" "" "" "" "" "" "" "" "" "" "" "pH" "Кислая вода" "Линия рециркуляции" "QIT" "I" "По месту" "Шкаф контроллера №1") ("@CABMARK" "@P" "XS" "5+" "UE011.1-1" "M:MARK" "QIT" "UE011.1" "pH в линии рециркуляции нейтрализованных стоков" "МАРК-902МП" "" "420AI" "" "1,5" "" "10" "pH" "30" "0,6" "" "" "" "" "" "" "" "" "" "" "pH" "Кислая вода" "Линия рециркуляции" "QIT" "I" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "2+" "UE011.1-1" "M:MARK" "QIT" "UE011.1" "pH в линии рециркуляции нейтрализованных стоков" "МАРК-902МП" "" "420AI" "" "1,5" "" "10" "pH" "30" "0,6" "" "" "" "" "" "" "" "" "" "" "pH" "Кислая вода" "Линия рециркуляции" "QIT" "I" "По месту" "Шкаф контроллера №1") ("@CABMARK" "@P" "XS" "6-" "UE011.1-2" "M:MARK" "QIT" "UE011.1" "pH в линии рециркуляции нейтрализованных стоков" "МАРК-902МП" "" "420AI" "" "1,5" "" "10" "pH" "30" "0,6" "" "" "" "" "" "" "" "" "" "" "pH" "Кислая вода" "Линия рециркуляции" "QIT" "I" "По месту" "Шкаф контроллера №1") ("@CABCTRL" "@MODUL" "@CHAN" "1-" "UE011.1-2" "M:MARK" "QIT" "UE011.1" "pH в линии рециркуляции нейтрализованных стоков" "МАРК-902МП" "" "420AI" "" "1,5" "" "10" "pH" "30" "0,6" "" "" "" "" "" "" "" "" "" "" "pH" "Кислая вода" "Линия рециркуляции" "QIT" "I" "По месту" "Шкаф контроллера №1")))


(defun excel>autoblocks (tbl / blk blkname pt)
  (setq blk (vla-Add (vla-get-blocks #actdoc) (vlax-3d-point '(0 0 0)) "*U"))
  (setq blkname (vla-get-name blk))
  (setq pt '(0 0 0))
  (mapcar
    '(lambda (tag / att)
       (setq att (vla-AddAttribute blk 0.2 (+ acAttributeModeLockPosition acAttributeModePreset) "" (vlax-3d-point (setq pt (mapcar '+ pt '(0 -0.5 0)))) tag "$$"))
       (vlax-put-property att "color" acbyblock)
       ) (car tbl))
  (setq pt (getpoint))
  (mapcar
    '(lambda (line / bobj)
       (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (setq pt (mapcar '+ pt '(5 0 0)))) blkname 1 1 1 0))
       (mapcar '(lambda (tag) (vla-put-TextString (getbatt bobj tag) (tbl|gpar (car tbl) line tag))) (car tbl))
       )
    (cdr tbl))
  );defun

;(excel>autoblocks tbl)








;;;(defun c:exc|del ()
;;;  
;;;  (setq #excel (vlax-get-object "Excel.Application"))
;;;  (setq #actsht (vlax-get-Property #excel "ActiveSheet"))
;;;  (setq #usedRange (vlax-get-Property #actsht "UsedRange"))
;;;  (setq #usedRows (vlax-get-Property #usedRange "Rows"))
;;;  (setq #usedCols (vlax-get-Property #usedRange "Columns"))
;;;
;;;  (setq range (vlax-get-property ash "Range" (strcat "A" (itoa (setq nl (1+ nl))))))
;;;
;;;  (setq rng (vlax-get-property #actsht "Range" (strcat "A1")))
;;;  (setq head (list rng))
;;;    (repeat (vla-get-count #usedCols)
;;;    (setq head (cons (setq rng (vlax-get-property rng "Next")) head))
;;;    )
;;;  (setq head (reverse head))
;;;
;;;
;;;  ;(setq rng (vlax-get-property rng "Previous"))
;;;  
;;;;;;  (mapcar
;;;;;;    '(lambda (x)
;;;;;;       (vlax-variant-value (vlax-get-property x "Text"))
;;;;;;       )
;;;;;;    head)
;;;
;;;  
;;;  
;;;    (setq usedRowsQuantity (vlax-get-Property #usedRows "Count"))
;;;    (setq #areas (vlax-get-Property #selection "Areas"))
;;;    (setq return
;;;	   (mapcar
;;;	     '(lambda (area)
;;;		(if (> (vlax-get-property area "Count")  usedRowsQuantity)
;;;		  (progn
;;;		    (mapcar
;;;		      '(lambda (col / cells i column)
;;;			 (setq cells (vlax-get-property col "Cells"))
;;;			 (setq i 0) (setq column '())
;;;			 (while (< (setq i (1+ i)) (1+ usedRowsQuantity)) (setq column (cons (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property cells "Item" i)) "Value2")) column)))
;;;			 (reverse column)
;;;			 )
;;;		      (cont>list (vlax-get-property area "Columns"))
;;;		      )
;;;		    )
;;;		  )
;;;		)
;;;	     (vl-remove-if '(lambda (area) (< (vlax-get-property area "Count") 2)) (cont>list #areas))
;;;	     ))
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;  
;;;  
;;;  
;;;  (setq #selection (vlax-get-Property #excel "Selection"))
;;;  (if (setq isSelectionFramed (< (vlax-get-Property #selection "Count") (expt 2 20)))
;;;    (setq result (xls|getDataFramed #selection))
;;;    (setq result (xls|getDataNotFramed #excel))
;;;    )
;;;  (vlax-release-object #selection)
;;;  (vlax-release-object #excel)
;;;  result
;;;
;;;  (setq bobj (vlax-ename->vla-object (car (entsel))))
;;;
;;;
;;;
;;;
;;;  
;;;  )