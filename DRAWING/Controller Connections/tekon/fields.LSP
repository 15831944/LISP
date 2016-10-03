;;




;;;		1	ИЗ ТРАСС
;	02_98-13-ТИ-ИОС.АТХ.С4-ТО_Схемы соединения внешних проводок

(if
  (or
    (setq lst (ssget "_I" '((0 . "INSERT"))))
    (and (setq lst (ssget* '((0 . "INSERT")))) (= 'PICKSET (type lst)))
    )
  (progn

    (setq lst (ss->list* lst))

    (setq
      lst
       (vl-sort
	 (vl-sort lst '(lambda (a b) (< (cadr (assoc 10 (entget a))) (cadr (assoc 10 (entget b))))))
	 '(lambda (a b) (< (caddr (assoc 10 (entget a))) (caddr (assoc 10 (entget b))))))
      )

    (setq data (mapcar '(lambda (x) (blref-to-data (vlax-ename->vla-object x))) lst))
    (setq head (origlist (mapcar 'car (apply 'append data))))
    (setq res (mapcar '(lambda (bobj) (mapcar '(lambda (par / a) (if (setq a (assoc par bobj)) (cadr a)"")) head)) data))


    (setq head (cdr head))
    (setq res
    (mapcar
      '(lambda (line / tmp)	;(setq line (nth 13 res))
	 (setq tmp (sepstr (nth 3 line) " "))
	 (setq tmp (cons (car tmp)
			 (cond	
			   ((wcmatch (cadr tmp) "*x*")
			    (sepstr (cadr tmp) "x"))
			   ((wcmatch (cadr tmp) "*х*")
			    (sepstr (cadr tmp) "х")
			    )
			   (T (exit))
			   )
			 ))
	 (list
	   (vl-string-subst "" " " (nth 1 line))
	   (vl-string-subst "-" " " (nth 2 line))
	   (car tmp)
	   (vl-string-subst "" " " (nth 4 line))
	   (vl-string-subst "" " " (nth 5 line))
	   (vl-string-subst "" " " (nth 6 line))

	   (vl-string-subst "" " " (nth 7 line))
	   (vl-string-subst "" " " (nth 8 line))
	   (vl-string-subst "" " " (nth 9 line))
	   (cadr tmp)
	   (caddr tmp)
	   )
	 )
      res))
    (setq head (reverse (cons "SECTION" (cons "CORES" (reverse head)))))
    
    (setq tbl (cons head res))
    
    )
  )



(lst>excel tbl)













(deoriglist dwgdata)
(deoriglist basedata)

(setq basedata (mapcar 'car (excel>lst)))
(setq dwgdata (mapcar 'car (cdr tbl)))
(length basedata)
(length dwgdata)

(db|diff basedata dwgdata)




;;============================================================
;;============================================================
(setq xlsdata (mapcar 'car (excel>lst)))
(deoriglist xlsdata)

(setq accdata (mapcar 'car (excel>lst)))
(deoriglist accdata)

(length xlsdata)
(length accdata)

(db|diff xlsdata accdata)
;;============================================================
;;============================================================








;;;		2	ИЗ ТРАСС
;	02_98-13-ТИ-ИОС.АТХ.СБ.02-ТО_Схемы управления ЭМК

"401" "402" "DI" "Контроль питания"