;;; ===========================================================================================
;; ������������� ������-���� �� �������� ����� �������, ��. ���������� ������
;;; ���� ����� ������� � �������1 � ����� ������� � �������2
;;; ����� ������ ������ ���� (("������1" "������ 2" ... "������ nkol")("������1" "������ 2" ... "������ nkol") ...)
;;;
;;;
;;; ���������� ���������� ������ ������� �������������� ���� ������ �� *�������
;;; ===========================================================================================



;888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
;   ��� 2-� ������� ���� ���� ������� ss->tbl  �  mapcarx
;888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
;;; 12_10_22
(defun dwgtxt->txtarr (nkol / lst)
  (repeat nkol
    (setq lst (append lst
      (list (mapcar '(lambda (x) (cdr (assoc 1 (entget x))))(ss->list (ssget '((0 . "*TEXT")))))
	    )))
    );repeat
  (apply 'mapcar (append '(list) lst))
  );defun
;;; ===========================================================================================
;;; 12_10_22
(defun dwgtxt->objarr (nkol / lst)
  (repeat nkol
    (setq lst (append lst
      (list (ss->lsto (ssget)))))
    );repeat
  (apply 'mapcar (append '(list) lst))
  );defun
;;; ===========================================================================================
(setq data (dwgtxt->txtarr 2))
(setq objs (dwgtxt->objarr 2))
;888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
;888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888




;;  SIGNALNAME
(mapcar '(lambda (bp / poz) ; block pair
	   (vla-put-textstring (getbatt (cadr bp) "SIGNALNAME")
	     (strcat
	       (cadr (assoc (setq poz (vla-get-textstring (getbatt (car bp) "ID"))) data))
	       " ����. ��. "
	       poz
	       )
	     )
	   )
	objs)


;;   LOCFLD
(setq objs (dwgtxt->objarr 2))
(mapcar '(lambda (bp) ; block pair
	   (vla-put-textstring (getbatt (cadr bp) "LOCFLD")
	     (strcat
	       "����� �������������� "
	       (vla-get-textstring (getbatt (car bp) "ID"))
	       )
	     )
	   )
	objs)


;;   TYPE  �������
(mapcar '(lambda (x)
	   (vla-put-textstring (getbatt x "TYPE")
	     "�����-LS"
	     )
	   ) (ss->lsto* (ssget)))
;;   TYPE  220
(mapcar '(lambda (x)
	   (vla-put-textstring (getbatt x "TYPE")
	     "�������-LS"
	     )
	   ) (ss->lsto* (ssget)))
;;   TYPE  ������� ������ 0.9
(mapcar '(lambda (x)
	   (vla-put-ScaleFactor (getbatt x "TYPE")
	     0.9
	     )
	   ) (ss->lsto* (ssget)))

;;   LENGTH
(mapcar '(lambda (x)
	   (vla-put-textstring (getbatt x "LENGTH")
	     ""
	     )
	   ) (ss->lsto* (ssget)))



;;   CORES
(mapcar '(lambda (x)
	   (vla-put-textstring (getbatt x "CORES")
	     "14"
	     )
	   ) (ss->lsto* (ssget)))



;;   LOCCAB

(setq data (dwgtxt->txtarr 2))
(setq objs (dwgtxt->objarr 2))

(mapcar '(lambda (bp / poz) ; block pair
	   (vla-put-textstring (getbatt (cadr bp) "LOCCAB")
	     (strcat
	       "������ ��������,\n����"
	       (cadr (assoc (vla-get-textstring (getbatt (car bp) "ID")) data))
	       )
	     )
	   )
	objs)




(setq objs (dwgtxt->objarr 2))

(mapcar '(lambda (bp / poz) ; block pair
	   (vla-put-textstring (getbatt (cadr bp) "LOCFLD")
	     (strcat
	       "������ ��������,\n����"
	       (cadr (assoc (vla-get-textstring (getbatt (car bp) "ID")) data))
	       )
	     )
	   )
	objs)






(defun ssfillatts (tag str)
(mapcar '(lambda (x)
	   (vla-put-textstring (getbatt x tag)
	     str
	     )
	   ) (ss->lsto* (ssget)))
  );defun

(ssfillatts "LOCCAB" "����������")





(ss:swapattscontent "LOCCAB" "LOCFLD")

(defun ss:swapattscontent (a b / ss)
  (setq ss (ss->lsto* (ssget '((0 . "INSERT")))))
  (mapcar '(lambda (x) (swapattscontent x a b)) ss)
  )


;;;swap atts
(defun swapattscontent (blo a b / tmp)
  (setq tmp (vla-get-TextString (getbatt blo b)))
  (vla-put-TextString (getbatt blo b) (vla-get-TextString (getbatt blo a)))
  (vla-put-TextString (getbatt blo a) tmp)
  )


(setq data (dwgtxt->txtarr 1))
(setq objs (dwgtxt->objarr 1))

(mapcar '(lambda (a b)
	   (vla-put-TextString (getbatt (car a) "LENGTH") (car b))
	   ) objs data)




;;;; ������� ����� ����� �� ������� � ��
(eval (append '(+)
	      (mapcar '(lambda (x)
			 (atoi (vla-get-TextString (getbatt x "LENGTH")))
			 )
		      (ss->lsto* (ssget))
		      )
	      ))