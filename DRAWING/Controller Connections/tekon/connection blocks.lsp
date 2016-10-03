
'(

("AI00" ("L+" "L-" "I+" "I-"))
("AI00Z" ("L+" "L-" "I+" "I+" "I-" "I-"))
("AI20" ("L+" "I+"))
("AI20Z" ("L+" "L+" "I+" "I+"))
("AI40" ("L+" "M" "I+" "I-"))
("AI02" ("TU+" "TU-"))
("AI02Z" ("TU+" "TU-" "TU+" "TU-"))
("AI05" ("RU+" "RI+" "RI-"))
("AI06" ("RU+" "RI+" "RU-" "RI-"))



("DI00" ("L+" "NO"))
("DI01" ("L+" "NC"))
("DI40" ("A#" "N"))
("DI41" ("A#" "N"))
("DI50" ("103" "102"))

("DO30" ("A1" "A3"))
("DO40" ("101" "103"))
("DO40Z" ("101" "101a" "103" "103a"))

("DO30Z" ("A1" "A1a" "A3" "A3a"))

)




(setq xls (mapcar 'car (excel>lst)))
(setq acc (mapcar 'car (excel>lst)))
(setq ans (db|diff xls acc))

(setq lst nil)
(setq lst (cadr ans))
(length lst)


(setq lst (vl-remove-if '(lambda (x) (wcmatch x "*##AP###*")) lst)) (length lst)
(setq lst (vl-remove-if '(lambda (x) (wcmatch x "*##AN###*")) lst)) (length lst)
(setq lst (vl-remove-if '(lambda (x) (wcmatch x "*##AA###*")) lst)) (length lst)
(setq lst (vl-remove-if '(lambda (x) (wcmatch x "*##GS###*")) lst)) (length lst)
(setq lst (vl-remove-if '(lambda (x) (wcmatch x "резерв")) lst)) (length lst)
(setq lst (vl-remove-if '(lambda (x) (wcmatch x "*BJB##XM*")) lst)) (length lst)
(setq lst (vl-remove-if '(lambda (x) (wcmatch x "*BRU##XM*")) lst)) (length lst)





(lst>excel (mapcarx sepstr "-" (mapcar 'car (excel>lst))))

(setq srcdata (db|formatdata (excel>lst))) (setq srcdata* srcdata)
(length srcdata)
(setq lst (mapcar 'car (excel>lst)))
(length lst)
(setq ans (mapcar '(lambda (x) (assoc x srcdata)) lst))
(length (vl-remove nil ans))
(db|diff srcdata (vl-remove nil ans))
(lst>excel ans)





(setq lst (mapcar 'car (excel>lst)))

(and (setq ssg (ssget* '((0 . "INSERT")))) (= 'PICKSET (type ssg)))
(setq ssg (ss->lsto* ssg))
(setq ssg (vl-remove-if-not '(lambda (o) (= "i" (vla-get-EffectiveName o))) ssg))


(setq ssgf (vl-remove-if-not '(lambda (o) (member (kd-get-textstring (getbatt o "LOOP_KKS")) lst)) ssg))
(sssetfirst nil (lst-to-ss ssgf))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(setq lst (excel>lst)) (length lst)



;==========================================================================================
;==========================================================================================
;==========================================================================================
;;;   виброконтроль
(setq blks (vl-remove-if-not '(lambda (x) (= "cbl_fld" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))
(lst>excel (tbl|blrefs>table blks))


(setq sigIDbase (excel>lst))
(setq  sigIDbase
(mapcar
  '(lambda (lx / tmp kks sig)	;(setq lx (nth 4 sigIDbase))

     (setq tmp
     (mapcar
       '(lambda (str / kks mark sig)	;(setq str (nth 1 lx))
	  (setq kks (substr str 1 (vl-string-search "-" str)))
	  (setq mark (substr str (+ 2 (vl-string-search "-" str))))
	  (if (vl-string-search "_" kks)
	    (progn
	      (setq kks (sepstr kks "_"))
	      (setq sig (cadr kks) kks (car kks))
	      )
	    (setq sig "")
	    )
	  (list kks sig mark)
	  )
       lx
      ))
     (list (car (car tmp)) (cadr (car tmp))  (caddr (car tmp)) (caddr (cadr tmp)))
     )
  sigIDbase
  )
       )
(lst>excel sigIDbase)
;==========================================================================================



;;	KKS 	TAIL	M1 M2	CBL_KKSID	EQ	EQ_DESC	TYPE	CORES	SECTION
(setq dwgdata (excel>lst))	(length dwgdata)


;;	KKS	TAIL	M1 M2 M3 M4
(setq controller-sorted-list (excel>lst))



(setq connected '())

(setq
  ans
   (mapcar
     '(lambda (x / kks tail marks tmp)	;(setq x (nth 704 controller-sorted-list))
	(setq kks (car x) tail (cadr x) marks (vl-remove "" (cdr (cdr x))))
	(setq tmp
	       (vl-remove-if-not
		 '(lambda (d)	;(setq d (nth 200 dwgdata))
		    (and
		      (= kks (car d))
		      (= tail (cadr d))
		      (apply '= (cons nil (db|diff marks (cond ((= 2 (length marks)) (list (nth 2 d) (nth 3 d))) ((= 3 (length marks)) (list (nth 2 d) (nth 3 d) (nth 4 d))) ((= 4 (length marks)) (list (nth 2 d) (nth 3 d) (nth 4 d) (nth 5 d))) ))))
		      )
		    )
		 dwgdata
		 )
	       )
	(if (and tmp (= 1 (length tmp))) (setq connected (cons (setq tmp (car tmp)) connected)))
	tmp
	)
     controller-sorted-list
     )
  )

(length (cadr (db|diff connected dwgdata)))
(lst>excel (cadr (db|diff connected dwgdata)))



(lst>excel ans)
(setq ans nil)





;==========================================================================================
;==========================================================================================
;==========================================================================================
;;;   ДУ


;;	KKS 	TAIL	M1 	CBL_KKSID	EQ	EQ_DESC	TYPE	CORES	SECTION
(setq dwgdata (excel>lst))	(length dwgdata)


;;	KKS	TAIL	M1 M2 M3 M4
(setq controller-sorted-list (excel>lst))


(setq connected '())

(setq
  ans
   (mapcar
     '(lambda (x / kks tail marks tmp)
	;(setq x (nth 301 controller-sorted-list))
	;(setq x (assoc "06MAJ20AA001" controller-sorted-list))
	(setq kks (car x) tail (cadr x) marks (vl-remove "" (cdr (cdr x))))
	(setq tmp
	       (vl-remove-if-not
		 '(lambda (d)	;(setq d (nth 184 dwgdata))
		    (and
		      (= kks (car d))
		      (member (nth 2 d) marks)
		      )
		    )
		 dwgdata
		 )
	       )

	
	(if (and tmp (= 2 (length tmp)))
	  (progn
	    (setq connected (cons (cadr tmp) (cons (car tmp) connected)))
	  
	(list
	  (nth 0 (car tmp))
	  (nth 1 (car tmp))
	  (nth 2 (car tmp))
	  (nth 2 (cadr tmp))
	  ""
	  (nth 3 (car tmp))
	  (nth 4 (car tmp))
	  (nth 5 (car tmp))
	  (nth 6 (car tmp))
	  (nth 7 (car tmp))
	  (nth 8 (car tmp))
	  
	  
	  )
	    )
	  '("")
	  )
	)
     controller-sorted-list
     )
  )

(length (cadr (db|diff connected dwgdata)))
(lst>excel (cadr (db|diff connected dwgdata)))

(lst>excel ans)
(setq ans nil)

(nth 99 ans)


