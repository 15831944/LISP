; набор прог для обработки тупонарисованных чертежей спецификации (например)
(load "d:/LISP WORKING/common functions/format-identification-gost.lsp")
(defun c:ktz-frame-move (/
			 lstkoluch
			 en
			 

			 datalist
			 data1

			 bpt
			 ang
			 pstpt
			 dY dX
			 dVect
			 pt1 pt2
			 ss
			 i
			 scale
			 )
  (setq lstkoluch (get-kol-uch))
  (setq datalist '()
	data1 '())
  (setq scale (/ (cdr (assoc 40 (entget (car lstkoluch)))) 2.5))

  
  (foreach en lstkoluch
    (setq data1 (cons
		  (get-list-number en)
		  (get-formatpts<-rightformatline (get-rightformatline<-koluch en))
		  ))
    (setq datalist (append datalist (list data1)))
    );foreach

;;;************************************************************
  (setq	datalist (vl-sort datalist
			  '(lambda (a b)
			     (<	(car a)
				(car b)
			     )
			   )
		 )
  )
;;;************************************************************

(setq bpt (getpoint "\n укажите точку размещения фреймов и направление их построения")
      ang (getorient bpt))
  ;(setq dY 300)
  ;(setq dX 425)

  (foreach data1 datalist
    (setq pt1 (cadr data1))
    (setq pt2 (caddr data1))
    (setq pstpt (vec-sum bpt ))
    
    ;(setq pstpt (vec-sum bpt (list 0 (* dy (car data1)) 0)))
    ;(setq pstpt (vec-sum bpt (list (* dX (car data1)) 0 0)))

    (setq dVect (vec-dif pstpt (append pt1 '(0))))
    (vl-cmdf "_.zoom" pt1 pt2)
    (setq ss (ssget "_C" pt1 pt2))
    (setq i 0)
    (repeat (sslength ss)
      (setq en (ssname ss i))
      (move-ent en dVect)
      (setq i (1+ i))
      );repeat
    );foreach


  );defun






(defun get-list-number (en
			/
			e1
			vect
			pt1
			pt2
			)
  (setq vect '(172.46 7.24 0))
  (setq pt1 (vec-sum (cdr (assoc 10 (entget en))) vect))
  (setq pt2 (vec-sum pt1 '(-6 -6 0)))
  (vl-cmdf "_.zoom" pt1 pt2)
  (setq e1 (ssname (ssget "_C" pt1 pt2 '((0 . "TEXT"))) 0))
  (atoi (cdr (assoc 1 (entget e1))))
  );defun




(defun move-ent	(e
		 vect
		 /
		 
		 eng
		 vmove
		 )
  (setq eng	(entget e))

  (if (/= "SEQEND"
	  (cdr (assoc 0 eng))
	  )
    (progn
    (setq eng (move-pt eng 10 vect))
    (if (assoc 11 eng)
      (setq eng (move-pt eng 11 vect))
      )
    (entmod eng)
    (entupd e)

    (if
      (or
	(= "ATTRIB" (cdr (assoc 0 eng)))
	(and
	  (= "INSERT" (cdr (assoc 0 eng)))
	  (= 1 (cdr (assoc 66 eng)))
	  );and
	);or
      ;then
      (move-ent (list (entnext e) vect))
      );if
    );progn
    );if not seqend
  ) ;defun




(defun move-pt (enget
		pp
		vectmove
		/
		newpt
		)
  (setq newpt (vec-sum vectmove (cdr (assoc pp eng))))
  (subst (cons pp newpt)
	 (assoc pp enget)
	 enget
	 )
  );defun
