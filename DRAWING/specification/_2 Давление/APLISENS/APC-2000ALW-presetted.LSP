







!!!!   ������� ������ ������ � ��� �������� ������� � ��������




; 13_05_16
; �������������� 13_11_05 - ��� �����������
; APLISENS
; ��� ����������
; APC-2000ALW


; ��������� ������ - ����� ��������� ������������

;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(apc|get-scale 4.5)

(setq #apc|catranges
       '(
	 ;0 1  2   3     5	; �� ��������
	 (1 0 100 "���" 120)
	 (2 0 30 "���" 45)
	 (3 0 16 "���" 30)
	 (4 0 7 "���" 14)
	 (5 0 2.5 "���" 5)
	 (6 0 0.7 "���" 1.4)
	 (7 -100 600 "���" 1400)
	 (8 -100 150 "���" 400)
	 (9 0 200 "���" 400)
	 (10 0 100 "���" 200)
	 (11 -50 50 "���" 200)
	 
	 (12 0 25 "���" 100)
	 (13 -10 10 "���" 100)
	 (14 -1.5 7 "���" 50)
	 
	 (15 0 130 "����" 200)
	 (16 0 700 "����" 1400)
	 (17 0 2.5 "����" 5)
	 (18 0 7 "����" 14)
	)
      )





;������� ����� � ������������ �������������� �������� , ������� ��������� ��� � �����������
(defun ap�|calcranges (ranges)
   (mapcar
     '(lambda (x)
	(cond
	  ((= "���" (nth 3 x))
	   (list (nth 0 x) (/ (nth 1 x) 1000.0) (/ (nth 2 x) 1000.0) "���")
	   )
	  ((= "����" (nth 3 x))
	   (list (nth 0 x) (- (/ (nth 1 x) 1000.0) 0.1) (- (/ (nth 2 x) 1000.0) 0.1) "���")
	   )
	  ((= "��� ���" (nth 3 x))
	   (list (nth 0 x) (- (/ (nth 1 x) 1000.0) 0.1) (- (/ (nth 2 x) 1000.0) 0.1) "���")
	   )
	  ((= "����" (nth 3 x))
	   (list (nth 0 x) (- (nth 1 x) 0.1) (- (nth 2 x) 0.1) "���")
	   )
	  ((= "��� ���" (nth 3 x))
	   (list (nth 0 x) (- (nth 1 x) 0.1) (- (nth 2 x) 0.1) "���")
	   )
	  (T x)
	  )
	)
     ranges
     )
  )





;(setq xlsline (car (cdr (nth 13 datazipped))))
;(setq xlsline (car (db|formatdata (excel>lst))))


(defun ap�|getrange (xlsline
		     /
		     units
		     catdiaps uniVdiap
		     valmin uniVmin
		     valnom uniVnom
		     valmax uniVmax
		     ans
		     
		     tmp
		     nomerdiap
		     scval
		     )\
  ;;  ��������� ��������� ���������
  (setq units (xlsgpar "units" xlsline))
  (setq valmin (atof* (xlsgpar "val_p_l" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "val_p_u" xlsline)))
  ;  ��������� �� � ������������� �����������
  (cond
    ((= "���" units)
     (setq uniVmin valmin)
     (setq uniVnom valnom)
     (setq uniVmax valmax)
     )
    
    ((member units '("����" "��� ���"))
     (setq uniVmin (- valmin 0.1))
     (setq uniVnom (- valnom 0.1))
     (setq uniVmax (- valmax 0.1))
     )
    
    ((= "���" units)
     (setq uniVmin (/ valmin 1000.0))
     (setq uniVnom (/ valnom 1000.0))
     (setq uniVmax (/ valmax 1000.0))
     )
    ((member units '("����" "��� ���"))
     (setq uniVmin (/ (- valmin 100) 1000.0))
     (setq uniVnom (/ (- valnom 100) 1000.0))
     (setq uniVmax (/ (- valmax 100) 1000.0))
     )
    )
  ;;  ����������� ��������� ���������
  (setq uniVdiap (abs (- uniVmin uniVmax)))
  ;;  � ����������� �� ������� (������������� ��� ����������) �������� ��������� ������� �� ������������� ����������
  (setq
    ans
     (vl-remove-if
       '(lambda (rang)
	  (or
	    (< uniVmin (nth 1 rang))
	    (> uniVmax (nth 2 rang))
	    )
	  )
       (cond
	 ((member units '("����" "��� ���" "����" "��� ���"))
	  (ap�|calcranges (vl-remove-if '(lambda (line) (< (nth 0 line)  15))#apc|catranges))
	  )
	 (T
	  (ap�|calcranges (vl-remove-if '(lambda (line) (>= (nth 0 line)  15))#apc|catranges))
	  )
	 )
       )
    )

  
  ;;  ����  ����������� ��������
  (setq catdiaps (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) ans))
  (cond
    ((member units '("����" "��� ���" "����" "��� ���"))
     (setq tmp (apply 'min (vl-remove-if '(lambda (d) (> (* uniVdiap 1.35) d)) catdiap)))
     )
    (T (setq tmp (apply 'min catdiaps))
     )
    )
  (if (null tmp) (setq tmp (apply 'min catdiaps)))

  ;; �� ������ �������� ������ ������� ��������
  (setq nomerdiap (car (nth (vl-position tmp catdiaps) ans)))
  (append
    (setq tmp (assoc nomerdiap #apc|catranges))
    (list
      (nth 1 tmp)
      (if (member (nth 3 tmp) '("���" "����" "��� ���")) uniVnom (* 1000 uniVnom))
      )
    )
  );defun

;(setq xlsline (car (db|formatdata (excel>lst))))
;(ap�|getrange xlsline)









;;;;; ���������� ����� ��� ���������� �������� (������)
;;;(setq
;;;  #apc|scalelist
;;;   '(
;;;     (0 100)
;;;     (0 30)
;;;     (0 16)
;;;     (0 7)
;;;     (0 2.5)
;;;     (0 0.7)
;;;     (-0.1 0.6)
;;;     (-0.1 0.15)
;;;     (0 0.2)
;;;     (0 0.1)
;;;     (-0.05 0.05)
;;;     (0 0.025)
;;;     (-0.01 0.01)
;;;     )
;;;  )
;;;
;;;
;;;(defun apc|get-scale (nval / lst mval)
;;;  ;(setq nval 4.3)
;;;  ;(* nval 1.5)
;;;  (setq lst
;;;  (vl-remove-if-not
;;;    '(lambda (di)
;;;       ;(< (* nval 1.5) (cadr di))
;;;       (< nval (cadr di))
;;;       ) #apc|scalelist)
;;;	)
;;;  (setq mval (apply 'min (mapcar 'cadr lst)))
;;;  (car
;;;    (vl-remove-if-not
;;;      '(lambda (di)
;;;	 (= mval (cadr di))
;;;	 ) #apc|scalelist)
;;;    )
;;;  )
;;;








;(setq xlslines (cdr proto))
;(setq xlslines (cdr (car (cadr (nth 15 datazipped2)))))
(defun gen-zakaz-APC2000ALW
       (xlslines /
	xlsline
	pozitions

	;CP_
	;CPmin_
	;CPmax_
	;osn-diapazon
	range
	
	mesto
	shtucer
	ispolnenie
	sreda
	kodventil
	nippel
	kreplenie
	kol
	grafa
	)

  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", ")) xlslines))))
  ;"LAB32CP001, LAB32CP002" 


  (setq xlsline (car xlslines))
  (setq range (ap�|getrange (car xlslines)))

  (cond
    ((= (nth 3 range) "����") (setq range (subst "��� ���" "����" range)))
    ((= (nth 3 range) "����") (setq range (subst "��� ���" "����" range)))
    )

  
  ;(setq range (ap�|getrange xlsline))
;;;  (setq CP_ (xlsgpar "nom_val" xlsline)
;;;	CPmin_ (xlsgpar "min_val" xlsline)
;;;	CPmax_ (xlsgpar "max_val" xlsline)
;;;	)
    
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;  ����� ���������� ��������� �������  ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; CP_ ���
;;;  (if (and
;;;	(setq CP_ (xlsgpar "nom_val" xlsline))
;;;	(isnumericstring CP_)
;;;	(setq CP_ (atof* CP_))
;;;	)
;;;    (setq CPmax_ (max (* 1.6 CP_) (* 1.2 (atof* CPmax_))))
;;;    (progn (alert "\n �� ������� ��������") (exit))
;;;    )

  
  ;(setq osn-diapazon (apc|get-scale CPmax_))

  
  
  (setq kol (length xlslines))
  (setq mesto (xlsgpar "place_sensor" xlsline))
  
  ;(setq ispolnenie "SN")
  (setq ispolnenie "�����������")


  ;(setq sreda (xlsgpar "�����" xlsline))



  
  ;; �� ���������
  ;; ���� �������������� �����
  ;; ������� ��������� - �� - ��� �� 160 �
  ;; VM-1 - �� 230 �
  ;; VM-1/������ - �� ����� - �� 500 �
  ;; ��. �� �����������, �� ������� t - VM-1/������
  ;; �� ����� ������ �� �������������� � ����� ������ - ��� � �������


  ;(setq kodventil "VM-1/������")
  ;;; �� ������� ���� ���������� �� - �� 160 � - �� �� ������ ��������� VM-1

  ;;;  ����������� ���������
  (setq shtucer "�")
  (setq kodventil "M0")
  (setq nippel "SO")
  (setq kreplenie "AL")
  
  ; � ���-� �� ������ ��������� VM-1
  ; � � ���� �� � ������� � ������� ���������� � ����� ������������ ����������� - ������ ��� ��������� ���
  ; �������� ������ ���������
  ;(setq kodventil nil)
  ;(setq nippel nil)
  ;(setq kreplenie "AL")

 

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ��������    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq
    grafa
     (list
       (list
	 ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	 pozitions
	 (strcat
	   "��������������� �������� ������������� (����������������):" "\n"
	   "�������� �������� " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range)", "
	   "������������� �������� " (rtos* (nth 5 range)) "..." (rtos* (nth 6 range)) " "(nth 3 range) "\n"
	   "���������� " ispolnenie ", �������� ������ 4...20 ��, HART" "\n"
	   (if kodventil (strcat "������� " kodventil ", ") "")
	   (if nippel (strcat "������� " nippel ", ") "")
	   (if kreplenie (strcat "��������� " kreplenie) "")
	   "\n"
	   mesto
	   )
	 (strcat
	   "{\\W0.9;" "APC-2000ALW/"
	   (if (= ispolnenie "�����������") "" (strcat ispolnenie "/"))
	   (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) "/"
	   (rtos* (nth 5 range)) "..." (rtos* (nth 6 range)) " " (nth 3 range) "/" "\n"
	   "/" shtucer
	   (if kodventil (strcat "/" kodventil) "")
	   (if nippel (strcat "/" nippel) "")
	   (if kreplenie (strcat "/" kreplenie) "")
	   "\n"
	   "�� �� 390171150.001-2004" "}"
	   )
	 ""
	 (strcat "��� \"����������\"" "\n" "�. �������") "��." (itoa kol) "" "������"
	 );grafa
       )
    );setq
  grafa
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

