;(defun iseven )






; gcd ; НОД
; ~ дополнение целого числа до -1
; (~ -2) для битных логических вычислений

; rem


;(command "_audit" "_Y")




;	из списка '("A" "B" "C" "D")
;	нужно сделать список '(("A" "B") ("A" "C") ("A" "D") ("B" "C") ("B" "D") ("C" "D"))
;	по сути выдать перечень сторон + диагоналей многоугольника

;(setq tmp '("A" "B" "C" "D" "E"))

(defun ways (members)
  (if members
    (append
      (mapcar
	'(lambda (x)
	   (list (car members) x)
	   )
	(cdr members))
      (ways (cdr members))
      )
    )
  );defun
