

;;;; cab - список (("3N-641" "3NТ150-6" "3NТ150-5" "3NТ150-4" "3NТ149-6" "3NТ149-5" "3NТ149-4") ("3N-642" "3NТ152-6" "3NТ152-5" "3NТ152-4" "3NТ151-6" "3NТ151-5" "3NТ151-4") ("3N-643" "3NТ158-6" "3NТ157-6" "3NТ156-6" "3NТ155-6" "3NТ154-6" "3NТ153-6" "3NТ158-5" "3NТ158-4" "3NТ157-5" "3NТ157-4" "3NТ156-5" "3NТ156-4" "3NТ155-5" "3NТ155-4" "3NТ154-5" "3NТ154-4" "3NТ153-5" "3NТ153-4") ("3N-644" "3NТ164-6" "3NТ164-5" "3NТ164-4" "3NТ163-6" "3NТ163-5" "3NТ163-4" "3NТ162-6" "3NТ162-5" "3NТ162-4" "3NТ161-6" "3NТ161-5" "3NТ161-4" "3NТ160-6" "3NТ160-5" "3NТ160-4" "3NТ159-6" "3NТ159-5" "3NТ159-4"))
;;; указываем номер кабеля - затем марки жилок в нем
(defun associng (
		 /
		 obj
		 ss
		 lst
		 )
  (while (setq obj (entsel "\nSelect assoc object..."))
    (setq obj (vlax-ename->vla-object (car obj)))
    (setq ss (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "*TEXT"))))))
    (setq lst (append lst (list (append (list obj) ss))))
    )
  lst
  );defun


(defun map (func arg lst)
  (mapcar
    '(lambda (x)
       (mapcar
	 '(lambda (y)
	    (if arg
	      (func y arg)
	      (func y)
	      )
	    )
	 x
	 )
       )
    lst
    )
  );defun

(setq cab (map vla-get-TextString  nil (associng)))



;;;; в соответствии


(defun qwer (lst
	     /
	     )
  
  );defun 


(setq c1 (nth 0 cab))
(setq number (car c1)
      marks (cdr c1))

(setq clamp (mapcar 'vlax-ename->vla-object (ss->list*(ssget '((0 . "INSERT")(8 . "клеммы"))))))

(foreach cl clamp
  (setq mark (vla-get-TextString (getbatt cl "MARK")))
  (if (member mark marks)
    (connectwireto cl)
    )
  )


(defun connectwireto (obj
		      /\
		      )
  
  );defun