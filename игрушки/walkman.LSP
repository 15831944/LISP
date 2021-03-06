(defun c:man ()
  (getint "\n������ ������ ������?")
  
  )

;;; ���������� ������ (������ ��������)
(defun drawman (
		x
		height
		/
		entg
		height				;����
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

  ;;; ============================������==================================
  (setq entg '((0 . "Circle")))
  (setq entg (append entg
		     (list (cons 10 headpt))		;����� �������
		     (list (cons 40 headrad))		;������ ������
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))
  ;;; ===========================��������=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 neckpt))		;����� �������
		     (list (cons 11 tazpt))	;������ ������
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))


  ;;; ===========================����1=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 neckpt))		;����� �������
		     (list (cons 11 a1pt))		;������ ������
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))

  ;;; ===========================����2=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 neckpt))		;����� �������
		     (list (cons 11 a2pt))		;������ ������
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))

  ;;; ==========================���� 1=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 tazpt))		;����� �������
		     (list (cons 11 p1pt))		;������ ������
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))

  ;;; ==========================���� 2=================================
  (setq entg '((0 . "LINE")))
  (setq entg (append entg
		     (list (cons 10 tazpt))		;����� �������
		     (list (cons 11 p2pt))		;������ ������
		     )
	)
  (setq enlist (append enlist (list (entmakex entg))))
  enlist
)


;;;;;; ����������� ������ � ����������� �� �
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