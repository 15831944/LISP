;;; изменена 10_05_28
;;; прога для перетаскивания объекта с базовой точкой,
;;; такой как у другого объекта с указанной точкой
;;; использована при разработке щита БП №4 Береза
;;; -kakt00z-™  ©



(defun c:movetolike (
		   /
		   e
		   se
		   spt
		   bpt
		   )
  (setq e (car (entsel "\nУкажите объект для перетаскивания... : ")))
  (setq se (car (entsel "\nУкажите объект для примера базовой точки... : ")))
  (setq spt (getpoint "\nукажите примерную базовую точку... : "))
  (setq bpt (vec-sum
	      (cdr (assoc 10 (entget e)))
	      (vec-dif
		spt
		(cdr (assoc 10 (entget se)))
		)
	      ))

  (command "_move" e "" bpt)
  )