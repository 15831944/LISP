;; 13_12_13
;;;;  1 собираем кабели из трасс
;;;;  2 собираем кабели из заданий заводу и подключений
;;;;  3 сравниваем их на соответствие
;;;;  4 выкидываем в модель генерируемый кабельный журнал


;;;   1
(setq ss (ssget '((0 . "INSERT"))))
(setq trassa (mapcar '(lambda (x) (vlax-ename->vla-object (cadr x))) (vl-remove-if-not '(lambda(x) (member (car x) '(1 2 3) )) (ssnamex ss))))
(length trassa)

;;;   2
(setq ss (ssget '((0 . "INSERT"))))
(setq zz (mapcar '(lambda (x) (vlax-ename->vla-object (cadr x))) (vl-remove-if-not '(lambda(x) (member (car x) '(1 2 3) )) (ssnamex ss))))
(length zz)


;;;   3
(mapcar
  '(lambda (trc / cc)	;(setq trc (cadr trassa))
     (setq cc (vl-remove-if-not
		'(lambda (zzc)
		   (=
		     (vla-get-TextString (getbatt trc "NUMBER"))
		     (vla-get-TextString (getbatt zzc "NUMBER"))
		     )
		   )
		zz)
	   )
     (and
       (= 1 (length cc))
       (setq cc (car cc))
       (= (vla-get-TextString (getbatt trc "NUMBER"))
	  (vla-get-TextString (getbatt cc "NUMBER")))
       (= (vla-get-TextString (getbatt trc "LOCFLD"))
	  (vla-get-TextString (getbatt cc "LOCCAB")))
       (= (vla-get-TextString (getbatt trc "LOCCAB"))
	  (vla-get-TextString (getbatt cc "LOCFLD")))
       (= (vla-get-TextString (getbatt trc "SIGNALNAME"))
	  (vla-get-TextString (getbatt cc "SIGNALNAME")))
       (= (vla-get-TextString (getbatt trc "SIGN"))
	  (vla-get-TextString (getbatt cc "SIGN")))
       )
     )
  trassa)
;(T T T T T T T T T T T T)  - значит что все параметры совпадают





;;;   4
(setq trassa (vl-sort trassa '(lambda (a b) (<
	(vla-get-TextString (getbatt a "NUMBER"))
	(vla-get-TextString (getbatt b "NUMBER"))
	))))



(setq bpt (getpoint))
(setq dpt '(0 -12 0))

(mapcar
  '(lambda (trc / bobj)
     (setq bobj (vla-InsertBlock #modspace (vlax-3d-point (setq bpt (mapcar '+ bpt dpt))) (strcat #lisppath "!blocking\\cablelist\\cbl_lst-комплектно.dwg") 1 1 1 0))
     (vla-put-TextString (getbatt bobj "NUMBER")
       (vla-get-TextString (getbatt trc "NUMBER")))
     (vla-put-TextString (getbatt bobj "LOCFLD")
       (vla-get-TextString (getbatt trc "LOCFLD")))
     (vla-put-TextString (getbatt bobj "LOCCAB")
       (vla-get-TextString (getbatt trc "LOCCAB")))
     (vla-put-TextString (getbatt bobj "SIGNALNAME")
       (vla-get-TextString (getbatt trc "SIGNALNAME")))
     (vla-put-TextString (getbatt bobj "TYPE")
       (strcat "Комплектно с прибором,\n" (vla-get-TextString (getbatt trc "SIGN"))))
;;;     (mapcar
;;;       '(lambda (an)
;;;	  (vla-put-TextString (getbatt bobj an) (vla-get-TextString (getbatt trc an)))
;;;	  )
;;;       '("NUMBER" "LOCFLD" "LOCCAB" "SIGNALNAME" "SIGN"))
     )
  trassa)
	
