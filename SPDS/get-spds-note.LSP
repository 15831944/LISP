;(defun get-spds-note (
(defun c:gs (
		      /
		      txt
		      ss
		      i
		      )
  (setq txt (getstring T "Строка для поиска ... :"))
  (if txt
    (progn
      (setq ss (ssget "_X" (list (cons 300 txt))))
      (if ss
	(progn
	  (command "_zoom" "_o" ss "" "")
	  (sssetfirst nil ss)
	  )
	)
      )
    )    
  )

(setq d 426)
(setq s1 (* 0.25 3.14 d d))
(setq s (* 2 s1))

(setq d 630)
(setq s1 (* 0.25 3.14 d d))




;(member '(300 . "5МТ002") (entget (car (entsel))))


;;; для обработки заданий технологов
;;; с позиционными выностками сделанными в СПДС
(load (strcat #lisppath "common functions\\structlist.LSP"))

(setq lst (ss->list* (ssget '((301 . "Text style")))))


;;; база из таблицы ссылок
(setq poz:base (ss->tbl (ssget '((0 . "*TEXT")))))
(setq poz:base (mapcarx vla-get-textstring nil poz:base))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(mapcar '(lambda (x / tmp)
	   (if (setq tmp (assoc (cadr (assoc "Первая строка" (getspnotedata x))) poz:base))
	     (change-ent (cons 300 (cadr tmp)) x)
	     )
	   ) lst)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun getspnotedata (spnote / spnotedata)
  (setq spnotedata (cddr (member '(100 . "mcsDbObjectNotePosition") (entget spnote))))
  (setq spnotedata (structlist (mapcar 'cdr spnotedata) 2))
  )

(defun change-ent (pointpare ent / entg)
  (setq entg (entget ent))
  (setq	entg (subst pointpare (assoc (car pointpare) entg) entg))
  (entmod entg)
  (entupd ent)
  ) ;defun
