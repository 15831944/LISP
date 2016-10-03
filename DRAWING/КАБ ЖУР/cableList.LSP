;;;  13_08_20
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
;;;XXXXX         подсчет длины трассы на плане				      XXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


(/ (apply '+ (mapcar 'vla-get-length (ss->lsto* (ssget "_I")))) 1000)













;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXX         подсчет длинн кабелей для 2-го листа кабельного журнала      XXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

;;;;  подсчет длинн кабелей для 2-го листа кабельного журнала





;;;   из блоков

;(setq cabs (ss->lsto* (ssget "_I")))
;(setq cabs (ss:getBRefs '("cbl_lst2")))
(setq cabs (ss:getBRefs '("CL_line")))
;(setq atts '("TYPE" "CORES" "SECTION" "LENGTH"))
(setq atts '("CBL_TYPE" "CBL_CQ" "CBL_CS" "LENGTH"))
(setq lst (mapcar '(lambda (cab) (mapcar '(lambda (att) (vla-get-TextString (getbatt cab att))) atts)) cabs))
(setq lst (vl-remove-if '(lambda (line) (apply '= (cons "" line))) lst))
(setq tbl|cables (cons atts lst))


(setq tbl|cables|summand (mapcar
	    '(lambda (v) (append (car v) (list (apply '+ (mapcar '(lambda (str) (atoi str)) (apply 'append (cdr v)))))))
	    ;(tbl|zip* tbl|cables '("TYPE" "CORES" "SECTION"))
	    (tbl|zip* tbl|cables '("CBL_TYPE" "CBL_CQ" "CBL_CS"))
	    ))


(setq out (mapcar '(lambda (line) (list (strcat (nth 0 line) " " (nth 1 line) "x" (nth 2 line)) (last line))) tbl|cables|summand))
(setq out (vl-sort out '(lambda (a b) (< (car a) (car b)))))
(setq out (append out (list (list "Итого:" (apply '+ (mapcar 'cadr out))))))

















;;;   из excell
(setq data (db|transmat (excel>lst)))
;(setq lst (list (assoc "TYPE" data) (assoc "CORES" data) (assoc "SECTION" data) (assoc "LENGTH" data) ))
(setq lst (list (assoc "CBL_TYPE" data) (assoc "CBL_CQ" data) (assoc "CBL_CS" data) (assoc "LENGTH" data)))
(setq lst (cdr (db|transmat lst)))
(setq lst (vl-remove-if '(lambda (line) (apply '= (cons "" line))) lst))


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
     (princ)
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
;;;; 	- СС запретил добавлять 10%
;(load (strcat #lisppath "MATH\\math-fix.LSP"))
;(setq outsp (vl-remove-if '(lambda (x) (wcmatch (car x) "*Итого:*")) out))
;(setq outsp (mapcar '(lambda (x) (list (car x) (* 10 (math-fix (* (cadr x) 0.11))))) outsp))
;(add-table outsp #tbl-geom-paramlist)







;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXX   трубы для электропроводок 10%  от НАТУРАЛЬНОЙ длины   XXXXXXXXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


(setq
  #cable_diams
   '(
     ("ВВГнг(А)-LS" "5""4,0" 15.3)
     
     ("КВВГнг(А)-LS" "4""1,0" 8.0)
     ("КВВГнг(А)-LS" "4" "2,5" 10.2)
     ("КВВГЭнг(А)-LS" "4" "1,0" 9.5)
     ("КВВГЭнг(А)-LS" "7" "1,0" 10.8)
     ("КВВГЭнг(А)-LS" "14" "1,0" 13.9)
     ("КВВГЭнг(А)-LS" "19" "1,0" 15.2)

     ("МКЭШВнг(А)-LS" "1x2" "1,0" 10.1)
     ("МКЭШВнг(А)-LS" "2x2" "1,0" 13.0)
     ("МКЭШВнг(А)-LS" "5x2" "1,0" 15.7)
     ;("МКЭШВнг(А)-LS 8x2x1,0" 18.0)
     )
   )

;(("22x2" 0) ("33x2" 0))


(mapcar
  '(lambda(line)
     
     )
  tbl|cables|summand
  )



out




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














;		16_01_14
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;   из excell
;	TYPE CORES SECTION LENGTH [...trace...]
(setq data (excel>lst))
(setq data (inverse data))



;	трубы для электропроводки - 10% от длины кабеля + зависит от диаметра
не буду ща щистаьть
напилю только диаметры

(setq
  #cable_diams
   '(
     ("КВВГнг(А)-LS 4x1,0" 8.0)
     ("КВВГнг(А)-LS 4x2,5" 10.2)
     ("КВВГЭнг(А)-LS 4x1,0" 9.5)
     ("КВВГЭнг(А)-LS 7x1,0" 10.8)
     ("КВВГЭнг(А)-LS 14x1,0" 13.9)
     ("КВВГЭнг(А)-LS 19x1,0" 15.2)

     ("МКЭШВнг(А)-LS 1x2x1,0" 10.1)
     ("МКЭШВнг(А)-LS 2x2x1,0" 13.0)
     ("МКЭШВнг(А)-LS 5x2x1,0" 15.7)
     ;("МКЭШВнг(А)-LS 8x2x1,0" 18.0)
     )
   )















;;  подсчет бирок (в данном случае - все бирки - контрольные - треугольные)

(setq bir_rez 1.2)	;	резерв бирок на стены и шкафы (В ШТУКАХ)

(setq birs 
(mapcar
  '(lambda (line / d)	;(setq line (nth 249 data))
     (setq d (cdr (cdr (cdr line))))
     (setq d (vl-remove '"" d))
     (if d
       (+ 2 bir_rez (* 2 (1- (length (cdr d)))))
       )
     )
  (cdr data)
  ))

(apply '+ (vl-remove 'nil birs))






(setq lst (list (assoc "TYPE" data) (assoc "CORES" data) (assoc "SECTION" data) (assoc "LENGTH" data) ))
(setq lst (list (assoc "CBL_TYPE" data) (assoc "CBL_CQ" data) (assoc "CBL_CS" data) (assoc "LENGTH" data)))

(setq lst (cdr (db|transmat lst)))







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
     (princ)
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











