(setq fpathin "d:\\_AutoCAD\\1744 Лунинец\\1744-1-АТМ4 - котел КЖ\\белТЭИ\\tmp\\дискретные сигналыANSI.txt")




(setq handin (open fpathin "r"))

(setq line nil lstin nil)
(while (setq line (read-line handin))
  (setq line (vl-string-trim " " line))

  (cond
    ((= "" line) (setq head "get"))
    ((= "get" head) (setq head line))
    (T (setq lstin (cons (list head line) lstin)))
    );cond
  )

(close handin)
;(close handout)



(setq data
(mapcar
  '(lambda (line / tmp1 del tmp2) ;(setq line (nth 13 lstin))
     (setq tmp1 (sepstr (car line) " "))
     (cond
       ((wcmatch (cadr line) "*DO*")(setq del " DO "))
       ((wcmatch (cadr line) "*DI*")(setq del " DI "))
       )
     
     (setq tmp2 (sepstr (cadr line) del))
     (list
       (vl-string-trim " " del)
       (car tmp1)
       (antisep  (cdr tmp1) " ")
       (car tmp2)
       (cadr tmp2)
       )
     )
  lstin))

(lst>excel data)




