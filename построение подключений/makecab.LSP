;;; изменена 10_08_11
;;; запуск программы с коммандной строки :
;;; (getclamps)
;;; (makecab)
;;; getclamps создает базу проекта вида списка ((<марка связи> <имя блока клеммки>) ...)
;;; принимает набор ряда зажимов (фильтрует по слою "клеммы")
;;; из этого набора потом будут выбираться блоки "клеммы" при подключении кабеля
;;; makecab - указывается (например из чертежей трасс) марки сигналов одного кабеля
;;; они подсвечиваются зеоеным и на рядах зажимов появляются "выводы жил данного кабеля"
;;; -kakt00z-™  ©

(defun getclamps (
	    /
	    doc
	    ss
	    ;SignalList
	    tmpbname
	    tmpattname
	    attstr
	    i
	    )
  (load "D:\\LISP WORKING\\Блоки Аттрибуты Тексты\\getbatt.LSP")

  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init
    (list (list "cmdecho" 0
               "expert" nil
        );list
        T
  );list
 );acet-error-init
  

  
  (setq ss (ssget '((0 . "INSERT")(8 . "клеммы")))
	i 0
	SignalList '())
  
  (repeat (sslength ss)
    (setq tmpbname (ssname ss i)
	  SignalList (append SignalList (list
					  (list
					    ;(cdr (assoc 1 (entget (getbatt* tmpbname "МАРКА_СВЯЗИ"))))
					    (cdr (assoc 1 (entget (getbatt* tmpbname "MARK"))))
					    tmpbname
					  )
					  ))
	  i (1+ i))
    );repeat
  
  ;(sssetfirst nil ss)
  Signallist
  

  (acet-error-restore)
  (vla-endundomark doc)
  );defun


(defun makecab (
		/
		doc
		ss
		i
		;sl
		cblc	;current block connecting
		tmp
		errmess

		c
		entg
		ent
		)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init
    (list (list "cmdecho" 0
               "expert" nil
        );list
        T
  );list
 );acet-error-init
  
  (setq ss (ssget '((0 . "*TEXT")))
	i 0
	sl '()
	tmp nil
	errmess "")



  (repeat (sslength ss)
    (setq sl (append sl (list (cdr (assoc 1 (entget (ssname ss i))))))
	  i (1+ i))
    )


  (foreach item sl
    (if (setq tmp (assoc item SignalList))
      (if (= (car (reverse (vl-string->list item))) 49)
	(drawzhila (cadr tmp) 3.5)
	(drawzhila (cadr tmp) 2.5)
	);if
	
      (setq errmess (strcat errmess (car tmp) "\n"))
      );if
    );foreach
  (if (/= "" errmess)
    (princ (strcat " *******   не найдены ******  \n" errmess))
    )

  (setq i 0)
  (repeat (sslength ss)
    (setq ent	(ssname ss i)
	  c	(assoc 62 (entget ent))
	  entg	(entget ent)
	  )


    (if (not c)
      ;then
      (setq entg (append entg '((62 . 3))))
      ;else
      (setq entg (subst '(62 . 3)
			 (assoc 62 entg)
			 entg
			)
	    )
      );if
    (entmod entg)
    (entupd ent)
    (setq i (1+ i))
    );repeaе
  
  
  (acet-error-restore)
  (vla-endundomark doc)
 
  )


(defun drawzhila (bl y+
		  /
		  sal
		  mirrored
		  
		  ptb
		  pt10
		  pt11
		  step
		  )

  (setq step 9)



  
  (setq sal (vlax-safearray->list
		   (vlax-variant-value
		     (vla-getDynamicBlockProperties
		       (vlax-ename->vla-object bl)))))
  (foreach item sal
    (if (= (vla-get-PropertyName item) "Отраженное состояние")
      (setq mirrored (vlax-variant-value (vla-get-Value item)))
      );if
    )
  (if (null mirrored)
    (progn
      (alert "не найден дин. параметр блока блока")
      (setq mirrored T)
      )
    )

  (setq ptb (cdr (assoc 10 (entget bl))))
  (if (= mirrored 1)
    (setq pt10 (list (- (car ptb) 42) (+ (cadr ptb) y+))
	  pt11 (list (- (car ptb) (+ 42 (* step 3))) (+ (cadr ptb) y+))
	  )
    (setq pt10 (list (+ (car ptb) 42) (+ (cadr ptb) y+) )
	  pt11 (list (+ (car ptb) (+ 42 (* step 3))) (+ (cadr ptb) y+) )
	  )
    
    );if

  (entmakex (append '((0 . "LINE")
		      (62 . 3)
		      ;(370 . 60)
		      (8 . "0"))
		    (list
		      (cons 10 pt10)
		      (cons 11 pt11)
		      )
		    )
	    );etmakex
  );defun
  

