(defun c:ktz-data-add (
		       /
		       ss
		       i
		       ktz-data
		       ent
		       entg

		       )

  (regapp "ktz-app")


  (setq ktz-data (list (list -3 (list "ktz-app"
				      (cons 1000 "-kakt00z-�  �")
				      (cons 1003 "��")
				      (cons 1070 666 )
				      ))
		   )
	 );setq


  (if (not (setq ss (ssget "_P")))
    (setq ss (ssget "_A"))
    )

  (setq i 0)
  (repeat (sslength ss)
    (setq entg (entget (ssname ss i)))
    (setq entg (append entg ktz-data))
    (entmod entg)
    (setq i (1+ i))
    );repeat

  
  );defun


;(cdadr (assoc -3 (entget (car (entsel)) '("ktz-app"))))
;(cdadr (assoc -3 (entget (car (entsel)) '("app1"))))







(setq wire-number 0)

(defun c:make-w (
		 /
		 e
		 data
		 eng
		 app-name

		 ;p1
		 ;p2
		 )
  
  (setq app-name "wire-app"
	e (car (entsel "\n ������� ������"))
	eng (entget e)
	wire-number (1+ wire-number)
	)

;;;  (setq p1 (car (entsel "\n p1"))
;;;	p2 (car (entsel "\n p1")))

  (regapp app-name)

  (setq data (list (list -3 (list app-name
				  (cons 1000 "������")			;
				  ;(cons 1002 "{")
				  ;(cons 300 "���")
				  ;(cons 301 "��-1")			; ��� �������
				  ;(cons 300 "�������")
				  ;(cons 301 "1,5")			; ������� �������
				  ;(cons 1002 "}")
				  ;(cons 1003 "�������")		; ��� �������
				  
				  ;(cons 1011 (cdr (assoc 10 eng)))	; ������ �����
				  ;(cons 1021 (cdr (assoc 11 eng)))	; ������ �����
				  (cons 1060 wire-number)		; ���������� ����� ������� � �������
				  ;(cons 1070 666 )
				  ))
		   )
	 );setq


;;;  (setq eng (subst (cons 8 "�������")
;;;		   (assoc 8 eng)
;;;		   eng
;;;		   ))

    (setq eng (append eng data))
    (entmod eng)
  (entupd e)

  
  );defun


(defun getadata (;app-name
		 /
		 str
		 )
  (setq str (getstring))
  (cdadr (assoc -3 (entget (car (entsel)) (list str))))
  )


;(cdadr (assoc -3 (entget (car (entsel)) '("wire-app"))))