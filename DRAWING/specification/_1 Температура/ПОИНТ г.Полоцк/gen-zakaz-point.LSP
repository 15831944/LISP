; 13_08_28
; 13_11_05
; ��-�-� �� (������, "�����")
; ��-�-� �� (������, "�����")
; 13_12_27
; ��-� �� (������, "�����")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq #point|cheholtype "�����������")
;(setq #point|cheholtype "������")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; �����������
; ��
; �������� ������� E
(setq #point:headtype "�")

;;;; ������������ ����� ��� ������ - �������������� �������������� ���������, �� ����. �����
;;;;  ��� ���.111 ��� ���.112
;;;; �� �������� 25 ��� (�� ���� ������� 16 / 18)
;;;; � ��������� ���������� - � ����� ������� ��������� ������




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(defun getlbobysh (xlsline / Dn OT)
;;;  (setq OT (xlsgpar "sampling_device" xlsline))
;;;  (setq Dn (atof* (xlsgpar "Diam_tr" xlsline)))
;;;  ;�������������� ��� �������
;;;  (cond ((< Dn 150) 40) ((>= Dn 150) 80))
;;;  );defun
;;;;(getlbobysh xlsline)

;(setq xlsline (car xlslines))
;(setq xlsline (car (DB|FORMATDATA(excel>lst))))
;     1!!!!!!!!!!!!   �� �������� ����� ������� ���� �������� �� �������� �����
(defun point|*get*Lbobysh (xlsline / Dn OT)
  ; �������������� ��� ������� - ��� ���� ���������� ���� 40 ��� 80 �� - � ����������� �� ��������
  ; ���� ������� ��-���� �� �� ����� 01 ��� 108.530.01 �� ����� 80
  (setq OT (xlsgpar "sampling_device" xlsline))
  (cond
    ((and OT (/= OT "") (= OT "01 ��� 108.530.01")) 80)
    ((or (null OT) (= OT "")) (setq Dn (atof* (xlsgpar "Diam_tr" xlsline)))(cond ((< Dn 150) 40) ((>= Dn 150) 80)))
    (T (princ "\n�� ��������� ��� �������") (exit))
    )
  );defun
;(point|*get*Lbobysh xlsline)






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlsline (nth 14 data))
(defun point-TP|*get*Trange (xlsline / valsafe valnom valmax scval #point-TP|catrangesT)
  (setq #point-TP|catrangesT '(600 700 800 900))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  (setq valsafe (max (* 1.2 valnom) (* 1.2 valmax)))
  (setq scval (apply 'min (vl-remove-if '(lambda (x) (<= (- x valsafe) 0)) #point-TP|catrangesT)))
  (list 0 scval)
  );defun
;(point-TP|*get*Trange xlsline)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlsline (nth 14 data))
(defun point-TS|*get*Trange (xlsline / valsafe valnom valmax scval #point-TS|catrangesT)
  (setq #point-TS|catrangesT '(50 80 100 150 180 200 250 300 400 500))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  (setq valsafe (max (* 1.2 valnom) (* 1.2 valmax)))
  (setq scval (apply 'min (vl-remove-if '(lambda (x) (<= (- x valsafe) 0)) #point-TS|catrangesT)))
  (list 0 scval)
  );defun
;(point-TS|*get*Trange xlsline)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlsline (cadr (car datazipped)))
(defun point-TP|*get*Lmont (xlsline / Dn Lb Lmin Lmax #point-TP|catrangesLmch  Lsafe) 
  (setq #point-TP|catrangesLmch '(120 160 200 250 320 400 500 630 800 1000 1600 2000 2500 3150))
  (setq Lb (point|*get*Lbobysh xlsline))		;����� �������
  (setq Dn (atof* (xlsgpar "Diam_tr" xlsline)))
  (setq Lsafe (+ (* 0.35 Dn) Lb))
  (apply 'min (vl-remove-if '(lambda (x) (<= (- x Lsafe) 0)) #point-TP|catrangesLmch))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(point-TP|*get*Lmont xlsline)
(defun point-TS|*get*Lmont (xlsline / Dn Lb Lmin Lmax #point-TS|catrangesLmch  Lsafe) 
  (setq #point-TS|catrangesLmch '(80 100 120 160 200 250 320 400 500 630 800 1000 1250 1600 2000 2500 3150))
  (setq Lb (point|*get*Lbobysh xlsline))		;����� �������
  (setq Dn (atof* (xlsgpar "Diam_tr" xlsline)))
  ;(setq Lsafe (+ (* 0.37 Dn) Lb))
  (setq Lsafe (+ (* 0.35 Dn) Lb))
  (apply 'min (vl-remove-if '(lambda (x) (<= (- x Lsafe) 0)) #point-TS|catrangesLmch))
  );defun
;(point-TS|*get*Lmont xlsline)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point|*get*Lnar (xlsline / Tmax)
  (setq Tmax (* 1.1 (cadr (point-TS|*get*Trange xlsline))))
  (cond
    ((diap Tmax -100 399) 50)
    ((diap Tmax 0    799) 120)
    ((diap Tmax 800 1000) 160)
    ((> Tmax        1000) 200)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  (defun point|get-diam-mch ( / tmp)
;;;    (setq tmp (* L_mch 1.1))
;;;    (cond
;;;      ;((diap tmp 0 320) 6)
;;;      ((diap tmp 0 1000) 8)
;;;      (T 10)
;;;      )
;;;    );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlslines xlslinesTT)
(defun point-TP|gen-zakaz-dat (xlslines /
			       Dschup Dmont
			       kol range
			       Lmont Lnar
			       spytype
			       pozitions
			       )
  (setq spytype "�")	;;;; ��� ���� �� ��������
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  (setq Dschup 8)
  (setq Dmont 10)
  (setq kol (length xlslines))
  (setq range (point-TP|*get*Trange (car xlslines)))
  (setq Lmont (point-TP|*get*Lmont (car xlslines)))
  (setq Lnar (point|*get*Lnar (car xlslines)))

  (list
    (list
      ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
      pozitions
      (strcat
	"��������������� ������������������ ��������������� ���������:" "\n"
	"����� �������� 0,5 %, �������� ��������� (" (rtos* (car range)) "...+" (rtos* (cadr range)) ") �C," "\n"
	"����� ��������� ����� " (rtos* Lmont) " ��, ������� ��������� ����� " (rtos* Dmont) " ��," "\n"
	"��� ��������� - ��������� ������, ����� �������� ����� " (rtos* Lnar) " ��," "\n"
	"������������� M20x1,5, ���������� ������� 24 �, IP65"
	)
      (strcat
	"��-�-� (4-20)��-(�0,5)-" spytype "-�-" "\n"
	"-(" (rtos* (car range)) "..." (rtos* (cadr range)) ")-" (rtos* Lmont) "/" (rtos* Dmont)
	(cond
	  ((= "�����������" #point|cheholtype) "-(60/8)")
	  ((= "������" #point|cheholtype) "")
	  (T "")
	  )
	"-\n"
	"-��." (rtos* Lnar) ".�20�1,5-" #point:headtype "\n"
	"�� �� 390184271.012-2008"
	)
      ""
      (strcat "��� \"�����\"" " " "�. ������")
      "��." (rtos* kol) "" "������"
      )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point-TS|gen-zakaz-dat (xlslines /
			       Dschup Dmont
			       kol range
			       Lmont Lnar
			       pozitions
			       )
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  ; � ����������� ������ ������ ��������� ��� ���
  ; spytype - ��� ��������� , � ��-� � ������ �� �������
  (setq Dschup 8)
  (setq Dmont 10)
  (setq kol (length xlslines))
  (setq range (point-TS|*get*Trange (car xlslines)))
  (setq Lmont (point-TS|*get*Lmont (car xlslines)))
  (setq Lnar (point|*get*Lnar (car xlslines)))

  (list
    (list
      (strcat "{\\W0.8;\\T0.9;" pozitions "}" )
      (strcat
	"�������������������� ������������� ��������������� ���������:" "\n"
	"����� �������� 0,5 %, �������� ��������� (" (rtos* (car range)) "...+" (rtos* (cadr range)) ") �C," "\n"
	"����� ��������� ����� " (rtos* Lmont) " ��, ������� ��������� ����� " (rtos* Dmont) " ��," "\n"
	"��� ��������� - ��������� ������, ����� �������� ����� " (rtos* Lnar) " ��," "\n"
	"������������� M20x1,5, ���������� ������� 24 �, IP65"
	)
      (strcat
	"��-�-� (4-20)��-(�0,5)-�-" "\n"
	"-(" (rtos* (car range)) "..." (rtos* (cadr range)) ")-" (rtos* Lmont) "/" (rtos* Dmont)
	(cond
	  ((= "�����������" #point|cheholtype) "-(60/8)")
	  ((= "������" #point|cheholtype) "")
	  (T "")
	  )
	"-\n"
	"-��." (rtos* Lnar) ".�20�1,5-" #point:headtype "\n"
	"�� �� 03 10 1826 08"
	)
      ""
      (strcat "��� \"�����\"" " " "�. ������")
      "��." (rtos* kol) "" "������"
      )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point-TSB|gen-zakaz-dat (xlslines /
				NSH
				shemasoed
				shemasoedtxt
				klass
			       Dschup Dmont
			       kol range
			       Lmont Lnar
			       pozitions
			       )
  (setq klass "B")
  (setq shemasoed "x3")
  (setq shemasoedtxt (cond
	   ((= shemasoed "x2") "������������� ����� ����������")
	   ((= shemasoed "x3") "������������� ����� ����������")
	   ((= shemasoed "x4") "���������������� ����� ����������")))
  
  (setq NSH "Pt100")
  (setq range '(0 250))
  
  
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  ; � ����������� ������ ������ ��������� ��� ���
  ; spytype - ��� ��������� , � ��-� � ������ �� �������
  (setq Dschup 8)
  (setq Dmont 10)
  (setq kol (length xlslines))
  
  
  (setq Lmont (point-TS|*get*Lmont (car xlslines)))
  (setq Lnar (point|*get*Lnar (car xlslines)))

  (list
    (list
      (strcat "{\\W0.8;\\T0.9;" pozitions "}" )
      (strcat
	"�������������������� �������������. ��� \"" NSH "\", ����� ������� " klass "\n"
	 shemasoedtxt ", " "�������� ��������� (" (rtos* (car range)) "...+" (rtos* (cadr range)) ") �C," "\n"
	"����� ��������� ����� " (rtos* Lmont) " ��, ������� ��������� ����� " (rtos* Dmont) " ��," "\n"
	"��� ��������� - ��������� ������, ����� �������� ����� " (rtos* Lnar) " ��," "\n"
	"������������� M20x1,5, � ����������� �������� ��������, IP65"
	)
      (strcat
	"��-�-" NSH "-" klass "-" shemasoed "-�-" "\n"
	"-(" (rtos* (car range)) "..." (rtos* (cadr range)) ")-" (rtos* Lmont) "/" (rtos* Dmont)
	(cond
	  ((= "�����������" #point|cheholtype) "-(60/8)")
	  ((= "������" #point|cheholtype) "")
	  (T "")
	  )
	"-\n"
	"-��." (rtos* Lnar) ".�20�1,5-" #point:headtype "\n"
	"�� �� 03 10 1826 08"
	)
      ""
      (strcat "��� \"�����\"" " " "�. ������")
      "��." (rtos* kol) "" "������"
      )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point|gen-zakaz-gilza (xlslines / kol Dnar Lmont)
  ;;;; ������������� - ���.111
  (cond
    ((= "�����������" #point|cheholtype) (setq gtype "���.111"))
    ((= "������" #point|cheholtype) (setq gtype "���.112"))
    (T (setq gtype "���.112"))
    )
  
  (setq kol (length xlslines))
  (cond
    ((= gtype "���.111") (setq Dnar 16))
    ((= gtype "���.112") (setq Dnar 18))
    (T (exit))
    )

  (cond
    ((= "��-�-�" (xlsgpar "��������" (car xlslines)))
     (setq Lmont (point-TS|*get*Lmont (car xlslines))))
    ((= "��-�" (xlsgpar "��������" (car xlslines)))
     (setq Lmont (point-TS|*get*Lmont (car xlslines))))
    ((= "��-�-�" (xlsgpar "��������" (car xlslines)))
     (setq Lmont (point-TP|*get*Lmont (car xlslines))))
    ((= "��-�" (xlsgpar "��������" (car xlslines)))
     (setq Lmont (point-TP|*get*Lmont (car xlslines))))
    )
 
  (list
    (list
      ""
      (strcat
	"������ �������������� ��������� "
	(cond
	  ((member gtype '("���.111" "���.112"
			   ;"���.121" "���.131"
			   )) "�������������")
	  (T "�������")
	  ) ":\n"
	"������� ������� " (rtos* Dnar) " ��, ����� ��������� ����� " (rtos* Lmont) " ��," "\n"
	"������������� M20x1,5, �������� �������� 25\\~���, ��������\\~12�18�10�;"
	)
      (strcat gtype "-M20x1,5-" (rtos* Dnar) "-"(rtos* Lmont)"-25")
      ""
      (strcat "��� \"�����\"" " " "�. ������")
      "��." (rtos* kol) "" "������"
      )
    )
  );defun
;(point|gen-zakaz-gilza xlslinesTT)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point|gen-zakaz-bobyshka (xlslines / tmpr sreda sd kol Dnar Lbob TM-uzel-par TM-uzel-voda rezba)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq TM-uzel-par "1744-1-��20")
  (setq TM-uzel-voda "1744-1-��20")
  (setq rezba "�20�1,5")
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq kol (length xlslines))
  (setq Lbob (point|*get*Lbobysh (car xlslines)))
  (setq tmpr (atof* (xlsgpar "nom_val" (car xlslines))))
  (setq sreda (cond ((>= tmpr 200) "���") ((< tmpr 200) "����")))
  (setq sd (xlsgpar "sampling_device" (car xlslines)))
  (cond
    (
     (= sd "01 ��� 108.530.01")
     (list
       (list
	 ""
	 (strcat "�������: L=" (rtos* Lbob) " ��, ������������� " rezba)
	 sd "" "" "��." (rtos* kol) ""
	 (strcat
	   "{\\W0.9;\\T0.9;"
	   "����� �� ������������ "
	   (cond
	     ((= sreda "���") TM-uzel-par)
	     ((= sreda "����") TM-uzel-voda)
	     )
	   "}"
	   )
	 )
       )
     )

    
    ((= sd "")
     (setq Lbob (point|*get*Lbobysh (car xlslines)))
     (list
       (list
	 ""
	 (strcat "�������: L=" (rtos* Lbob) " ��, ������������� " rezba ", ��.20")
	 (strcat "1/28-" (rtos* Lbob) "-" rezba)
	 "" "��� \"�����\" �. ������"  "��." (rtos* kol) "" "������"
	 )
       )
     )
    );cond ��� ����� �������
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point|gen-zakaz-rasshiritel (xlslines / Dn kol typ)
  (setq Dn (atof* (xlsgpar "Diam_tr" (car xlslines))))
  (if (< Dn 40)
    (progn
      (setq kol (length xlslines))
      (setq typ (get-closer-from-row Dn '(25 32 38)))
      (list
	(list
	  "" "����������� ������ � ��������, ��� ��������� ��������, 12�18�10�"
	  (strcat "57x" (rtos* typ) "-M20x1,5-�") "" "��� \"�����\" �. ������" "��." (rtos* kol) "" ""
	  )
	)
      )
    );if
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1
(defun point-TP|*gen*zakaz (xlslines)
  (append
    (point-TP|gen-zakaz-dat xlslines)		;;;; (("" "" ""))
    (point|gen-zakaz-gilza xlslines)
    (point|gen-zakaz-bobyshka xlslines)
    (point|gen-zakaz-rasshiritel xlslines)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point-TS|*gen*zakaz (xlslines)
  (append
    (point-TS|gen-zakaz-dat xlslines)		;;;; (("" "" ""))
    (point|gen-zakaz-gilza xlslines)
    (point|gen-zakaz-bobyshka xlslines)
    (point|gen-zakaz-rasshiritel xlslines)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point-TSB|*gen*zakaz (xlslines)
  (append
    (point-TSB|gen-zakaz-dat xlslines)		;;;; (("" "" ""))
    (point|gen-zakaz-gilza xlslines)
    (point|gen-zakaz-bobyshka xlslines)
    (point|gen-zakaz-rasshiritel xlslines)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (gen-zakaz-point-TS xlslinesTT)




