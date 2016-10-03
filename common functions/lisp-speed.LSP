



(setq a1 (rtos (getvar "CDATE") 2 8))


(setq a2 (rtos (getvar "CDATE") 2 8))


(- (atoi (cadr (sepstr a2 "."))) (atoi (cadr (sepstr a1 "."))))





(setq a1 (rtos (getvar "CDATE") 2 16))
(repeat 200000 (enc lst))
(setq a2 (rtos (getvar "CDATE") 2 16))
(- (atoi (cadr (sepstr a2 "."))) (atoi (cadr (sepstr a1 "."))))


(setq a1 (rtos (getvar "CDATE") 2 16))
(repeat 200000 (enc2 lst))
(setq a2 (rtos (getvar "CDATE") 2 16))
(- (atoi (cadr (sepstr a2 "."))) (atoi (cadr (sepstr a1 "."))))