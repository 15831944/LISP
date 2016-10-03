;;; изменена 10_06_01
;;; прога дл€ копировани€ одной линии текстов в другую
;;; использована при разработке проектов Ѕерезовской √–Ё—
;;; -kakt00z-Щ  ©



(vl-load-com)
(defun tmc ( kratnost
	      /
	      doc
	      lst1
	      lst2
	      ent
	      eng
	      i
	      ID
	      txt
	      fld
	      j
	      n-att2
	      	      )
  
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init

  
  (setq i 0
	j 0)
  
  (setq ID (ktz-get-and-sort-pare-ss))
  (setq lst1 (car ID)
	lst2 (cadr ID)
	ID	nil
	;kratnost 4
	n-att2	0)


  ;;;============================================================
  ;;; условие проверки соответстви€ двух наборов по количеству элементов
  ;;;============================================================  

  (if (= (length lst2) (* (length lst1) kratnost))
    ;then


  ;;;============================================================
  ;;; повтор€ем проход по наименьшему списку
  ;;;============================================================  
    
  (repeat (length lst1)

    ;;;============================================================
    ;;; если надо извлекать текст из первого аттрибута блока
    ;(setq txt (cdr (assoc 1 (entget (entnext (car (nth i lst1)))))))
    ;;;если надо просто текст то:
    ;(setq txt (cdr (assoc 1 (entget (car (nth i lst1))))))
    ;;; если надо поле

    
    ;;;============================================================

    
    (setq ID (vla-get-objectid (vlax-ename->vla-object (car (nth i lst1)))))
    (setq fld (strcat
		"%<\\AcObjProp Object(%<\\_ObjId "
		(itoa ID)
		">%).TextString>%"
		))
    ;;;============================================================
    (setq j 0)
    (repeat kratnost
      (setq ent (car (nth (+ (* i kratnost) j) lst2)))

      
      ;;;============================================================
      ;;; если надо в аттрибут блока
;;;      (repeat n-att2
;;;	(setq ent (entnext ent))
;;;	)
      ;;;============================================================

      (setq eng (entget ent))
      (setq txt (strcat fld (cdr (assoc 1 eng))))	;;; если делаем префикс
      (setq eng (subst (cons 1 txt) (assoc 1 eng) eng))
      (entmod eng)
      (entupd ent)
      (vl-cmdf "_updatefield" ent "")
      (setq j (1+ j))
      );repeat


    ;;;============================================================
    ;;; если надо в блок
    ;;;============================================================
;;;    (setq ent (car (nth i lst2)))
;;;    (setq j 1)
;;;    (if (= 1 (cdr (assoc 66 (entget ent))))
;;;      ;then
;;;      (progn
;;;	(setq eng (entget (entnext ent)))
;;;	(while (/= (cdr (assoc 0 eng)) "SEQEND")
;;;	  
;;;	  (setq eng (subst (cons 1 (strcat txt "-" (itoa j)))
;;;			   (assoc 1 eng)
;;;			   eng))
;;;	  (entmod eng)
;;;	  (entupd ent)
;;;	  (setq eng
;;;
;;;		 (entget (entnext (cdr (assoc -1 eng))))
;;;		j (1+ j))
;;;
;;;	  );while
;;;      );progn
;;;      ;else
;;;      (progn
;;;      (setq eng (entget ent))
;;;	(setq eng (subst (cons 1 txt) (assoc 1 eng) eng))
;;;	(entmod eng)
;;;	(entupd ent)
;;;	
;;;	)
;;;      );if
;;;    (vl-cmdf "_updatefield" ent "")

    	
    (setq i (1+ i))
    );repeat
  ;else
  (princ "\n несовпадает количество элементов")
);if

  (acet-error-restore)
  (vla-endundomark doc)

  );defun




