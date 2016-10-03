;;  есть файл ворда - кабельный журнал
;;  где сцеплена строка с одним кабелем
;; то есть по сути - 1 кабель записан в 3 строки


(setq data (db|formatdata (excel>lst)))




(setq cycling 3)
(setq i (/ (length data) cycling))
(setq res nil)

(while (> i 0)
  (setq res (cons
	      (append
		(nth (- (* i cycling) 3) data)
		(nth (- (* i cycling) 2) data)
		(nth (- (* i cycling) 1) data)
		)
	      res)
	i (1- i))
  )


(lst>excel res)













(setq res
(mapcar
  '(lambda (x / ct ctype) ;(setq x (nth 70 data))
     (setq ct (nth 1 x))
     (setq ct (sepstr ct " "))
     (setq ctype (car ct) ct (cadr ct))
     (setq ct (car (sepstr ct "+")))
     (setq ct (sepstr ct "x"))
     (concat (list ctype (car ct) (cadr ct)) x)
     
     )
  data))

