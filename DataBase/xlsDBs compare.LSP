




;	excel-excel

(setq lst1 (vl-remove '"" (mapcar '(lambda (x) (norus (car x))) (excel>lst))))
(setq lst1 (vl-remove '"" (origlist (mapcar '(lambda (x) (norus (car x))) (excel>lst)))))
(null (deoriglist lst1))
(setq lst2 (vl-remove '"" (mapcar '(lambda (x) (norus (car x))) (excel>lst))))
(setq lst2 (vl-remove '"" (origlist (mapcar '(lambda (x) (norus (car x))) (excel>lst)))))
(null (deoriglist lst2))


(length lst1)
(length lst2)


(setq ans (ANDlists (list lst1 lst2)))
(setq ans (db|diff lst1 lst2))
(lst>excel (mapcar 'list (cadr ans)))




(lst>excel (mapcar 'list (vl-remove '"" (origlist (mapcar '(lambda (x) (norus (car x))) (excel>lst))))))







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;	сортируем по первому столбцу (id)
;;	сортируем по столбцам 

(tbl|getdata 'lst1)	; EL
(tbl|getdata 'lst2)	; HV  (setq lst2 (cons '("KKS" "ACT_TYPE") lst2))


(setq res '())
(apply 'and
(mapcar
  '(lambda (lineA lineB)
     (if (not (equal lineA lineB))
       (setq res (cons (append lineA lineB) res))
       )
     )
  lst1
  lst2
  ))

(lst>excel res)






						!! Мегапрога
;;;    правая сцепка двух таблиц
;;;	первый (левый) столбец должен быть один и тот же и выполнять роль уникального идентификатора
;;;   справа результат lst1


(setq lst1 (tbl|blrefs>table (ss:getBrefs '("PID_eq_sign"))))
(setq lst2 (tbl|blrefs>table (ss:getBrefs '("PID_eq_sign"))))
(setq lst1 (tbl|delcolumn lst1 "[BN]=PID_eq_sign"))
(setq lst2 (tbl|delcolumn lst2 "[BN]=PID_eq_sign"))

OR FROM EXCEL

(tbl|getdata 'lst1)	; EL
(tbl|getdata 'lst2)	; HV  (setq lst2 (cons '("KKS" "ACT_TYPE") lst2))





(defun mklst (n / res) (repeat n (setq res (cons "" res))) res)

(setq l1 (cdr lst1))
(setq l2 (cdr lst2))
(setq common (origlist (concat (mapcar 'car l1) (mapcar 'car l2))))

(setq result
       (mapcar
	 '(lambda (x / ass1 ass2 res)
	    (setq ass1 (assoc x l1))
	    (if ass1 (setq l1 (vl-remove ass1 l1)))
	    (setq ass2 (assoc x l2))
	    (if ass2 (setq l2 (vl-remove ass2 l2)))
	    (cond
	      ((and ass1 ass2)
	       (append (reverse ass2) ass1)
	       )
	      ((and ass1 (null ass2))
	       (append (mklst (length (car lst2))) ass1)
	       )
	      ((and (null ass1) ass2)
	       (reverse ass2)
	       )
	      );cond
	    )
	 common)
      )



(length l1)
(length l2)



(lst>excel
  (append
    (list (concat (reverse (car lst2)) (car lst1)))
    result
    (list '("MISSED"))
    (mapcar
      '(lambda (x)
	 (append (mklst (length (car lst2))) x)
	 )
      l1
      )
    (list '("MISSED"))
    (if l2 l2 '(("")))
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;













(setq lst1 (vl-remove '"" (mapcar '(lambda (b) (vla-get-TextString (getbatt b "LOC_ID"))) (ss->lsto* (ssget "_I")))))
(length lst1) (length (deoriglist lst1))


(setq lst2 (vl-remove '"" (mapcar '(lambda (b) (vla-get-TextString (getbatt b "LOOP_ID"))) (ss->lsto* (ssget "_I")))))
(length lst2) (length (deoriglist lst2))



(setq aset (VL-REMOVE-IF-not '(lambda (b) (member (vla-get-TextString (getbatt b "LOOP_ID")) (deoriglist lst1))) (ss->lsto* (ssget "_I"))))
(sssetfirst nil (lst-to-ss aset))



(setq lst1 (vl-remove '"" (mapcar '(lambda (x) (norus (car x))) (excel>lst))))
(null (deoriglist lst1))

(setq lst2 (vl-remove '"" (mapcar '(lambda (x) (norus (car x))) (excel>lst))))
(null (deoriglist lst2))







(setq ans (ANDlists (list lst1 lst2)))
(lst>excel (mapcar 'list ans))


(setq ans (db|diff lst1 lst2))


(deoriglist lst1)
(deoriglist lst2)

(lst>excel (inverse ans))



(setq aset (VL-REMOVE-IF-not '(lambda (b) (member (vla-get-TextString (getbatt b "LOC_ID")) (car ans))) (ss->lsto* (ssget "_I"))))
(sssetfirst nil (lst-to-ss aset))






;;   ассоциирование из исходного - поиск в присоединяемый данных

(setq origin (mapcar 'car (excel>lst)))
(setq tbltopaste nil)
(setq data (excel>lst))
(setq notpasted data)

(mapcar
  '(lambda (kks / d)	;(setq kks (nth 13 origin))
     (cond
       ((= "" kks) (setq tbltopaste (cons '("") tbltopaste)))
       ((setq d (assoc kks notpasted))
	(setq tbltopaste (cons d tbltopaste))
	(setq notpasted (vl-remove d notpasted))
	)
       (T (setq tbltopaste (cons (list kks) tbltopaste)))
       )
     )
  origin)

(lst>excel (append (reverse tbltopaste) (list '("np")) notpasted))









(setq data (excel>lst))
(lst>excel (db|transmat data))






(setq lstJBOXs (excel>lst))
(setq lstJBOXs (mapcar '(lambda (line) (vl-remove '"" line)) lstJBOXs))

(setq lstKIP (mapcar 'reverse (excel>lst)))
(setq lstKIP (cdr (ziplist lstKIP)))

(db|diff
  (mapcar '(lambda (line) (vl-sort line '<))lstKIP)
  (mapcar '(lambda (line) (vl-sort line '<))lstJBOXs)
  )





(setq cblsZRA (mapcar 'car (excel>lst)))
(setq cblsZRA (vl-remove '"" cblsZRA))



(setq cblsKIP (mapcar 'car (excel>lst)))
(setq cblsKIP (vl-remove '"" cblsKIP))

(andlists (list cblsKIP cblsZRA))











(setq lstJBOXs (excel>lst))

(lst>excel (db|transmat lstJBOXs))






(setq boxdata (excel>lst))
(setq kipdata (mapcar 'car (excel>lst)))

(lst>excel
(mapcar
  '(lambda (p)
     (assoc p boxdata)
     )
  kipdata))






(setq boxdata (excel>lst))
(length boxdata)
(length (origlist boxdata))
(lst>excel (origlist boxdata))







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lst>excel (mapcar '(lambda (x) (list (norus (car x)))) (excel>lst)))
(lst>excel (mapcar '(lambda (x) (list (noeng (car x)))) (excel>lst)))

(lst>excel (mapcar '(lambda (x) (sepstr* (car x))) (excel>lst)))
(lst>excel (mapcar '(lambda (x) (sepstr (car x) ",")) (excel>lst)))

(lst>excel (DB|TRANSMAT (excel>lst)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(tbl|getdata 'new)	; EL
(tbl|getdata 'base)	; HV			(setq base (cons '("KKS" "ACT_TYPE") base))

(car new)
(car base)

(setq result (list (orlists (list (car base) (car new))) '("new than olds")))


(mapcar
  '(lambda (newline / kks lines-to-compare r)	;(setq newline (nth 4 new))
     (setq kks (tbl|gpar (car new) newline "KKS"))
     (setq lines-to-compare (cdr (tbl|filter base (strcat "KKS=" kks))))
     (setq
       r
	(mapcar
	  '(lambda (tag)
	     (cons
	       (tbl|gpar (car new) newline tag)
	       (mapcar
		 '(lambda (li)
		    (tbl|gpar (car base) li tag)
		    )
		 lines-to-compare
		 )
	       )
	     )
	  (car result)
	  )
       )
     (if lines-to-compare
       (setq result (append result (db|transmat r)))
       (setq result (append result (append (db|transmat r) '(("absent")))))
       )
     (setq result (append result '((""))))
     )
  (cdr new)
  )

(lst>excel result)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(lst>excel (mapcar 'list (vl-remove "" (origlist src))))



(setq src (mapcar '(lambda (x) (strcat "11" (norus (car x)))) (excel>lst)))


(setq src (mapcar '(lambda (x) (norus (car x))) (excel>lst)))
(setq lst2 (mapcar '(lambda (x) (norus (car x))) (excel>lst)))


(setq src (mapcar 'car (excel>lst)))
(vl-remove "" (origlist src))

(setq lst2 (mapcar 'car (excel>lst)))

(db|diff src lst2)



(setq ans '())
(mapcar
  '(lambda (s)
     (if (null (member s lst2))
       (setq ans (cons s ans))
       )
     )
  src)
(length src)
(length ans)







(setq lst1 (mapcar '(lambda (x) (norus (car x))) (excel>lst)))
(setq lst2  (excel>lst))


(mapcar
  '(lambda (x)
     (assoc x lst2)
     )
  lst1)









(setq lst1 (mapcar '(lambda (x) (norus (car x))) (excel>lst)))

(setq lstPID (mapcar '(lambda (x) (norus (car x))) (excel>lst)))


(setq ans (db|diff lst1 lstPID))

(deoriglist lst1)

(lst>excel (db|transmat ans))




(setq lstonplan (mapcar 'car (excel>lst)))
(length lstonplan)
(length (origlist lstonplan))
(setq lsttotaleq (mapcar 'car (excel>lst)))
(length lsttotaleq)
(length (origlist lsttotaleq))


(length (andlists (list lstonplan lsttotaleq)))


(lst>excel (mapcar 'list (cadr (db|diff lstonplan lsttotaleq))))
