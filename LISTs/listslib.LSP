
(defun concat (lst1 lst2)
  (
   (lambda (frec) (frec (reverse lst1) lst2))
    (lambda (lst1 lst2)
      (if lst1
	(frec (cdr lst1) (cons (car lst1) lst2))
	lst2)
      )
    )
  );defun


(defun spclst (lst / fn ans)
  (setq ans nil)
  (defun fn (lst / pp)
    (if lst
      (progn
	(if (setq pp (assoc (car lst) ans))
	  (setq ans (subst (list (car pp) (1+ (cadr pp))) pp ans))
	  (setq ans (cons (list (car lst) 1) ans))
	  )
	(fn (cdr lst))
	)
      )
    )
  (fn lst)
  ans
  );defun




;;;(setq a1 (rtos (getvar "CDATE") 2 16))
;;;(repeat 200000 (enc lst))
;;;(setq a2 (rtos (getvar "CDATE") 2 16))
;;;(- (atoi (cadr (sepstr a2 "."))) (atoi (cadr (sepstr a1 "."))))
;;;
;;;
;;;(setq a1 (rtos (getvar "CDATE") 2 16))
;;;(repeat 200000 (enc2 lst))
;;;(setq a2 (rtos (getvar "CDATE") 2 16))
;;;(- (atoi (cadr (sepstr a2 "."))) (atoi (cadr (sepstr a1 "."))))






;;;(compare2lsts
;;;  '("A1" "A8" "A5" "A7" "A6" "A4")
;;;  '("A1" "A4" "A5" "A6" "A7" "A8")
;;;  )
;;;T
(defun compare2lsts (tmdb tmdw)
    (cond
      ((or (null tmdb) (null tmdw)) T)
      ((member (car tmdb) tmdw) (compare2lsts (cdr tmdb) (remove-first (car tmdb) tmdw)))
      (T nil)
      )
    );defun








;; 14_03_04
;;  выделяет из спсика подсписок ограниченный указанными элементами

;;;'((-1 . <Entity name: 7ee79518>)
;;;  (0 . "BLOCK_RECORD")
;;;  (5 . "16BB")
;;;  (102 . "{ACAD_XDICTIONARY")
;;;  (360 . <Entity name: 7ee79520>)
;;;  (102 . "}")
;;;  (330 . <Entity name: 7ee75c08>)
;;;  (100 . "AcDbSymbolTableRecord")
;;;  (100 . "AcDbBlockTableRecord")
;;;  (2 . "*U17")
;;;  (360 . <Entity name: 7ee79530>)
;;;  (340 . <Entity name: 0>)
;;;  (102 . "{BLKREFS")
;;;  (331 . <Entity name: 7ee5e3b8>)
;;;  (331 . <Entity name: 7eea1300>)
;;;  (331 . <Entity name: 7eea1468>)
;;;  (102 . "}")
;;;  (70 . 0)
;;;  (280 . 1)
;;;  (281 . 1)
;;; )
;;;
;;;'((102 . "{BLKREFS")
;;;  (331 . <Entity name: 7ee5e3b8>)
;;;  (331 . <Entity name: 7eea1300>)
;;;  (331 . <Entity name: 7eea1468>)
;;;  (102 . "}")
;;; )

(defun cutlist (eng start end / eng1 tail ans cpp)
  (if (null end)
    (member start eng)
    (progn
      (setq eng1 (member start eng))
      (setq tail (member end eng1))
      (defun fnc (a b) (if (and (= (length b) 1) (= (car b) (car a))) a (fnc (cdr a) (cdr b))))
      (reverse (fnc (reverse eng1) (reverse tail)))
      )
    )
  )
;(cutlist '("a" "b" "x" "c" "d" "y" "e" "f" "x" "g" "y") "x" "y")
;(cutlist '("a" "b" "x" "c" "d" "y" "e" "f" "x" "g" "y") "x" nil)
;(cutlist '("a" "b" "x" "c" "d" "y" "e" "f" "x" "g" "y") nil "y")


(defun entgetsub (ent sub / pp n)
  (setq pp (vl-remove-if-not '(lambda (x)(and (= 'STR (type (cdr x)))(wcmatch (cdr x) (strcat "*" sub "*"))))lst))
  (if (= 1 (length pp)) (setq n (caar pp)))
  (cutlist lst (assoc n lst) (assoc (1+ n) lst))
  );defun
;(entgetsub (car (entsel)) "LEADER{")



;;;  бросил недоделано
;;  start - номер первого элемента
;;  end - номер последнего элемента списка

(defun sublist (lst start end / len ans)
  (setq len (length lst))
  (cond
    ((or (null lst) (null start) (null start) (< start 0) (< end 0) (< end start)(> start len) (> end len)) "#err#")
    ((and (= 0 start) (= end (1- len))) lst)
    ((> start 0) (sublist (cdr lst) (1- start) (1- end)))
    ((< end (1- len)) (sublist (reverse (cdr (reverse lst))) start end))
    )
  );defun


;(sublist '(1 2 3 4 5 6 7 8 9 0) 1 1)



(defun remove-first (x lst)
  (if (= x (car lst))
    (cdr lst)
    (cons (car lst) (remove-first x (cdr lst)))
    )
  )


(defun vl-removes (items lst)
  (if (cdr items)
    (vl-removes (cdr items) (vl-remove (car items) lst))
    (vl-remove (car items) lst)
    )
  )
;(vl-removes '(3 5 7 9) '(1 2 3 4 5 6 7 8 9 9 9))


