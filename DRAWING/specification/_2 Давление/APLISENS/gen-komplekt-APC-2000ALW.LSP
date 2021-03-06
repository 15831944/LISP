; 13_05_16
; �������������� 13_11_05 - ��� �����������
; APLISENS
; ��� ����������
; APC-2000ALW


; ��������� ������ - ����� ��������� ������������

;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;; ���� �� ������, ������� �����������
;;; �� ����� ����� ������������� �������� ��������� �������
;; �� ����������� ���� ����������

(setq #MP|scale '(0.06 0.1 0.16 0.2 0.25 0.4 0.6 0.7 1.0 1.6 2.5 4.0 6.0 10.0 16.0 25.0 40.0 60.0)) ;���

;(apc|get-scale 4.5)

(setq #apc|catranges
       '(
	 ;0 1  2   3      4    5
	 (1 0 100 "���")
	 (2 0 30 "���")
	 (3 0 16 "���")
	 (4 0 7 "���")
	 (5 0 2.5 "���")
	 (6 0 0.7 "���")
	 (7 -100 600 "���")
	 (8 -100 150 "���")
	 (9 0 200 "���")
	 (10 0 100 "���")
	 (11 -50 50 "���")
	 (12 0 25 "���")
	 (13 -10 10 "���")
	 (14 -1.5 7 "���")
	 (15 0 130 "��� ���")
	 (16 0 700 "��� ���")
	 (17 0 2.5 "��� ���")
	 (18 0 7 "��� ���")
	)
      )

;������� ����� � ������������, ������� ��������� ��� � �����������
(setq #ap�|calcranges
 (mapcar
   '(lambda (x)
      (if (member (nth 3 x) '("���" "��� ���"))
	(list
	  (nth 0 x)
	  (/ (nth 1 x) 1000.0)
	  (/ (nth 2 x) 1000.0)
	  (cond
	    ((= (nth 3 x) "���") "���")
	    ((= (nth 3 x) "��� ���") "��� ���")
	    )
	  )
	x)
      )
   #apc|catranges)
      )
   


;(setq xlsline (car (cdr (nth 13 datazipped))))
;(setq xlsline (car (excel>tbl)))
(defun ap�|getrange (xlsline / lst valsafe valmin valnom valmax units tmp scval)
  (setq valmin (atof* (xlsgpar "min_val" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  ;(setq valsafe (max (* 1.5 valnom) (* 1.2 valmax)))
  ;13_05_28 ��������� ���� ...
  (setq valsafe (max (* 1.1 valnom) (* 1.1 valmax)))
  (setq units (xlsgpar "units" xlsline))
  ;;; �� �������, ��? (��)
  (setq scval (apply 'min (vl-remove-if  '(lambda (x) (<= (- x (if (member units '("���" "��� ���")) valnom (/ valnom 1000.0)))0)) #MP|scale)))
  
  (setq lst (vl-remove-if '(lambda (rang) (or(< valmin (nth 1 rang))(> valsafe (nth 2 rang))))#ap�|calcranges))
  (setq lst (vl-remove-if-not '(lambda (x) (= units (nth 3 x))) lst))
  (setq tmp (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) lst))
  ;(assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges)
  ;������� � ����� "������������� ��������"
  (append
    (setq tmp (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apc|catranges))
;;;    (if (> valnom 2)
;;;      ;;;;; �� ��� ���� �� "����������" ���� ��
;;;      (list (nth 1 tmp) (if (member (nth 3 tmp) '("���" "��� ���"))
;;;			  (math-fix (* 1.1 valsafe))
;;;			  (* 1000 (math-fix (* 1.1 valsafe)))
;;;			  ))
;;;
;;;      
;;;      (list (nth 1 tmp) (if (member (nth 3 tmp) '("���" "��� ���"))
;;;			  (/ (math-fix (* 10 (* 1.1 valsafe))) 10.0)
;;;			  (* 1000 (/ (math-fix (* 10 (* 1.1 valsafe))) 10.0))
;;;			  ))
      ;; ������ ��������� ����� ����������
    (list
      (nth 1 tmp)
      (if (member (nth 3 tmp) '("���" "��� ���")) scval (* 1000 scval))
      )
    )
  );defun
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

  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines))))
  ;"LAB32CP001, LAB32CP002" 


  (setq xlsline (car xlslines))
  (setq range (ap�|getrange (car xlslines)))
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

  
  (setq shtucer "�")
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
	   "������������� �������� " (rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " "(nth 3 range) "\n"
	   "���������� " ispolnenie ", �������� ������ 4...20 ��, HART" "\n"
	   (if kodventil (strcat "������� " kodventil) "")
	   (if nippel (strcat "������� " nippel ", ") "")
	   (if kreplenie (strcat "��������� " kreplenie) "")
	   "\n"
	   mesto
	   )
	 (strcat
	   "{\\W0.9;" "APC-2000ALW/"
	   (if (= ispolnenie "�����������") "" (strcat ispolnenie "/"))
	   (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) "/"
	   (rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " " (nth 3 range) "/" "\n"
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

