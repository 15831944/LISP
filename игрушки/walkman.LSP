(defun c:man ()
  (getint "\nсолько метров пройти?")
  
  )

;;; возвращает список (голова туловище)
(defun drawman (
		x
		height
		/
		entg
		height				;рост
		headrad
		headpt
		neckpt
		tazpt
		a1pt
		a2pt
		p1pt
		p2pt
		step/2

		enlist
		)



  (setq headrad		(/ height 10)
	step/2		(/ height 4)
	headpt		(list x height)
	neckpt		(list x (- height headrad))
	tazpt		(list x (* height  0.4))
	p1pt		(list (- x step/2) 0)
	p2pt		(list (+ x step/2) 0)
	a1pt		(list (- x step/2) (* 0.7 height))
	a2pt		(list (+ x step/2) (* 0.7 height))
	)

  ;;; ============================голова==================================
  (setq entg '((0 . "Circle")))
  (setq entg (append entg
		     (list (cons 10 headpt))		;точка вставки
		     (list (cons 40 headrad))		;радиус головы
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))
  ;;; ===========================туловище=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 neckpt))		;точка вставки
		     (list (cons 11 tazpt))	;радиус головы
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))


  ;;; ===========================рука1=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 neckpt))		;точка вставки
		     (list (cons 11 a1pt))		;радиус головы
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))

  ;;; ===========================рука2=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 neckpt))		;точка вставки
		     (list (cons 11 a2pt))		;радиус головы
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))

  ;;; ==========================нога 1=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 tazpt))		;точка вставки
		     (list (cons 11 p1pt))		;радиус головы
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))

  ;;; ==========================нога 2=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 tazpt))		;точка вставки
		     (list (cons 11 p2pt))		;радиус головы
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))
  enlist
)


;;;;;; преобразует объект в зависимости от х
(defun move (
	     ent
	     x
	     )
  
  (cond
    ;1
    ((eq (0 . "CIRCLE") (assoc 0 (entget ent)))
     (movecirc ent x))
    ;2
    ((eq (0 . "LINE") (assoc 0 (entget ent)))
     (move))
    
    )
)