

;;; start - количество ненужных букв сдева (которые нужно удалить из строк)
;;; end - количество ненужных букв справа (с минусом)


(defun strcut (txt start end /
	       s
	       strl
               ns
               i
               )
    (setq strl (vl-string->list txt)
          ns ""
	  s (1+ start)
          i s)
    (if (<= end 0)
        (setq end (+ (length strl) end))
        )
    (repeat (1+ (- end s))
        (if (and
                (<= i end)
                )
            (setq ns (strcat ns (chr (nth (1- i) strl))))
            )
        (setq i (1+ i))
        )
    ns
    );defun




(defun ss:strcut ( /
		  ss i txt e eng)
    (setq ss (ssget)
          i 0)
    (repeat (sslength ss)
      (setq e (ssname ss i)
	    eng (entget e))
      (setq txt (strcut (cdr (assoc 1 eng)) 0 -))
      (setq eng (subst (cons 1 txt) (assoc 1 eng) eng))
      (entmod eng)
      (entupd e)
      (setq i (1+ i))
      );repeat
  );defun


;;; проверим на длинну слова

;;;(setq ss (ss->lsto* (ssget '((0 . "*TEXT")))))
;;;
;;;(mapcar '(lambda (x)
;;;	   (strlen (vla-get-textstring x))
;;;	   ) ss)


(defun c:ss:strcut ( / ss vget s e)
  (if (null (setq ss (ssget "_I" '((0 . "*TEXT")))))
    (setq ss (ssget '((0 . "*TEXT"))))
    )
  (setq vget (kd:dclget '("обрезать слева" "обрезать справа")))
  (setq s (atoi (car vget)))
  (setq e (- (abs (atoi (cadr vget)))))

  (setq ss (ss->lsto* ss))

  (mapcar
    '(lambda (obj)
       (vla-put-TextString obj (strcut (vla-get-TextString obj) s e))
       )
    ss)
  
  
  )