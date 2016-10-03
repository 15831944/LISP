(regapp "tstapp")
(setq e (entget (car (entsel))))



(setq listing "(alert \"\n that's my programm\")")
      

(setq edata (list (list -3 (list "tstapp" (cons 1000 listing)))))




(setq e2 (append e edata))
(entmod e2)






(setq line (cdr (cadr (cadr (assoc -3 (entget (car (entsel)) '("tstapp")))))))


(eval
  (read
    (cdr (cadr (cadr (assoc -3 (entget (car (entsel)) '("tstapp"))))))
    ))


(setq a '(setq f "35"))

(VL-PRINC-TO-STRING a)