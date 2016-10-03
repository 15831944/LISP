
;==================================================================================================================================
;==================================================================================================================================
;; копируем таблицу из ворд в ексель

(excel|unmerge)

; бегло оцениваем и исправляем кратность строк
(setq lst (db|formatdata (excel>lst)))

(setq k 3)
(setq i 0)
(setq data '())

(setq head '("NUMBER" "NAME" "CBL_KKSID" "SIGN" "VOLTAGE" "1EQ1" "1EQ2" "1EQ3" "1X" "1Y" "1Z" "2EQ1" "2EQ2" "2EQ3" "2X" "2Y" "2Z" "LENGTH" "TRACE" "DESC"))


(repeat (/ (length lst) k)
  (setq data (cons

  (list
    ""
    ""
    (vl-string-subst "-" " " (nth 2 (nth i lst)))
    (nth 2 (nth (+ 1 i) lst))
    (nth 2 (nth (+ 2 i) lst))

    (nth 3 (nth i lst))
    (nth 3 (nth (+ 1 i) lst))
    (nth 3 (nth (+ 2 i) lst))

    (nth 4 (nth i lst))
    (nth 5 (nth i lst))
    (nth 6 (nth i lst))

    (nth 7 (nth i lst))
    (nth 7 (nth (+ 1 i) lst))
    (nth 7 (nth (+ 2 i) lst))

    (nth 8 (nth i lst))
    (nth 9 (nth i lst))
    (nth 10 (nth i lst))

    (nth 11 (nth i lst))
    (nth 12 (nth i lst))
    (nth 13 (nth i lst))
    )
  data))
  (setq i (+ i k))
  )


(setq tbl (cons head (reverse data)))

(lst>excel tbl)
;==================================================================================================================================
;==================================================================================================================================




;==================================================================================================================================
;==================================================================================================================================
; бегло оцениваем и исправляем кратность строк
(excel|unmerge)
; бегло оцениваем и исправляем кратность строк
(setq lst (db|formatdata (excel>lst)))

(setq k 2)
(setq i 0)
(setq data '())

;		0	1	2	   3	   4	
(setq head '("NUMBER" "NAME" "CBL_KKSID" "SIGN" "VOLTAGE" "1EQ1" "1EQ2" "1EQ3" "1X" "1Y" "1Z" "2EQ1" "2EQ2" "2EQ3" "2X" "2Y" "2Z" "LENGTH" "TRACE" "DESC"))

(repeat (/ (length lst) k)
  (setq data (cons

  (list
    ""
    ""
    ""
    (nth 1 (nth i lst))
    "0"

    (vl-string-trim " " (nth 3 (nth i lst)))
    (vl-string-trim " " (nth 3 (nth (+ 1 i) lst)))
    ""

    "" "" ""

    (vl-string-trim " " (nth 4 (nth i lst)))
    (vl-string-trim " " (nth 4 (nth (+ 1 i) lst)))
    ""

    "" "" ""

    "" "" ""
    )
  data))
  (setq i (+ i k))
  )

(setq tbl (cons head (reverse data)))
(lst>excel tbl)
;==================================================================================================================================
;==================================================================================================================================







(setq ss (ss->lsto* (ssget '((0 . "*TEXT")))))



(defun c:fx ()
(mapcar
  '(lambda (x / str)	;(setq x (nth 13 ss))
     (setq str (kd-get-textstring x))
     (vla-put-TextString x (rtos* (atof* str)))
     )
  (ss->lsto* (ssget '((0 . "*TEXT")))))
  )





(kd-get-textstring  (vlax-ename->vla-object (car (entsel))))








(db|getdata 'db:head 'db:data)
(length db:data)	



(setq result
       (mapcar
	 '(lambda (line)	;(setq line (nth 3 db:data))
	    (list
	      "" ""

	      (strcat
		(db|gpar "NUMBER" line) "\n"
		(db|gpar "TYPE" line) " " (db|gpar "CORES" line) "x" (db|gpar "SECTION" line)
		)

	      (strcat
		(db|gpar "1EQ1" line) "\n"
		(db|gpar "1EQ2" line) "\n"
		(db|gpar "1EQ3" line)	
		)

	      (db|gpar "1X" line)
	      (db|gpar "1Y" line)
	      (db|gpar "1Z" line)

	      (strcat
		(db|gpar "2EQ1" line) "\n"
		(db|gpar "2EQ2" line) "\n"
		(db|gpar "2EQ3" line)	
		)	      
	      
	      (db|gpar "2X" line)
	      (db|gpar "2Y" line)
	      (db|gpar "2Z" line)
	      
	      (db|gpar "LENGTH" line)
	      
	      )
	    
	    )
	 (cdr db:data)
	 )
       
      )


(lst>excel result)







;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;;;XXXXX         подсчет длинн кабелей для 2-го листа кабельного журнала      XXXXXXXXXXX
;;;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

;;;;  подсчет длинн кабелей для 2-го листа кабельного журнала



(setq cabs (cdr db:data))
(setq atts '("TYPE" "CORES" "SECTION" "LENGTH"))




(setq lst
(mapcar
  '(lambda (cab)
     (mapcar
       '(lambda (att)
	  ;(vla-get-TextString (getbatt cab att))
	  (db|gpar att cab)
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



















(setq res
(mapcar
  '(lambda (line / ty co se) ;(setq line (nth 13 (excel>lst)))
     (setq ty (sepstr (cadr line) " "))
     (setq co (sepstr (cadr ty) "х"))
     (setq se (cadr co))
     (setq co (car co))
     (setq ty (car ty))
     (list ty co se)
     
     )
  (excel>lst))
      )

(lst>excel res)














