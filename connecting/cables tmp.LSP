

;;;; cab - ������ (("3N-641" "3N�150-6" "3N�150-5" "3N�150-4" "3N�149-6" "3N�149-5" "3N�149-4") ("3N-642" "3N�152-6" "3N�152-5" "3N�152-4" "3N�151-6" "3N�151-5" "3N�151-4") ("3N-643" "3N�158-6" "3N�157-6" "3N�156-6" "3N�155-6" "3N�154-6" "3N�153-6" "3N�158-5" "3N�158-4" "3N�157-5" "3N�157-4" "3N�156-5" "3N�156-4" "3N�155-5" "3N�155-4" "3N�154-5" "3N�154-4" "3N�153-5" "3N�153-4") ("3N-644" "3N�164-6" "3N�164-5" "3N�164-4" "3N�163-6" "3N�163-5" "3N�163-4" "3N�162-6" "3N�162-5" "3N�162-4" "3N�161-6" "3N�161-5" "3N�161-4" "3N�160-6" "3N�160-5" "3N�160-4" "3N�159-6" "3N�159-5" "3N�159-4"))
;;; ��������� ����� ������ - ����� ����� ����� � ���
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



;;;; � ������������


(defun qwer (lst
	     /
	     )
  
  );defun 


(setq c1 (nth 0 cab))
(setq number (car c1)
      marks (cdr c1))

(setq clamp (mapcar 'vlax-ename->vla-object (ss->list*(ssget '((0 . "INSERT")(8 . "������"))))))

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