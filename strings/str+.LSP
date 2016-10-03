;13_01_29
;(setq str "002")
(load (strcat #lisppath "strings\\editmark.lsp"))


(defun str+ (str / dlt s)
  (setq s (itoa (1+ (atoi str))))
  (setq dlt (- (strlen str) (strlen s)))
  (repeat dlt
    (setq s (strcat "0" s))
    )
  s
  )
;тут надо багфикс
(defun str- (str / dlt s)
  (setq s (itoa (1- (atoi str))))
  (setq dlt (- (strlen str) (strlen s)))
  (repeat dlt
    (setq s (strcat "0" s))
    )
  s
  )



(defun mark+ (str / tmp)
  ;(if (null str-separate) (load (strcat #lisppath "strings\\editmark.lsp")))
  (eval
    (append
      '(strcat)
      (subst
	(str+ (car (reverse (setq tmp (str-separate str)))))
	(car (reverse tmp))
	tmp
	)
      ))
  );defun



(defun mark- (str / tmp)
  ;(if (null str-separate) (load (strcat #lisppath "strings\\editmark.lsp")))
  (eval
    (append
      '(strcat)
      (subst
	(str- (car (reverse (setq tmp (str-separate str)))))
	(car (reverse tmp))
	tmp
	)
      ))
  );defun
