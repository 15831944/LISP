; 13_05_07
; ��� ������-226
; ���. 2 (��)
;  (setq diam_schup 10)
;  (setq diam_mch 10)
;(setq sens-kod 02)

; ��������� ������ - ����� ��������� ������������

;;;;;;;;;;;;;            !!!!!!!!!!!!!!!!            13_11_11    ���� �������������


;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;��������� ������ paramlist:
;;;   0		  1	2	3		4	5		6
;;; D_tru	nom_val max 	��������	P	�������		kol
;;;("57"	"20"	"#"	"������-226"	"0,6"	"#"		"3")
;;;("57"	"250"	"#"	"������-226"	"4,3"	"��"		"2") 


;(setq paramlist (append (caddr datalineforparagraph) (list (itoa (length (cadr datalineforparagraph))))))

(defun gen-zakaz-metran226 (xlslines / paramlist 
			   CP_ CT_nom CT_max D_truby
			   bobyshka-OT L_bobysh
			   sens-kod			;��� ���������� ������������
			   klass-dopuska		;����� �������
			   shema			;����� �����������
			   T_diap			;�������� �����������
			   L_mch
			   L_nch
			   subparagraph
			   kol
			    pozitions
			   )
  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  (setq
    paramlist
     (list
       (xlsgpar "Diam_tr" (car xlslines))
       (xlsgpar "nom_val" (car xlslines))
       (xlsgpar "max_val" (car xlslines))
       (xlsgpar "��������" (car xlslines))
       (xlsgpar "P" (car xlslines))
       (xlsgpar "sampling_device" (car xlslines))
       (rtos* (length xlslines))
       )
     )

  

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;  ����� ���������� ��������� �������  ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; CP_ ���
  (if (and
	(setq CP_ (nth 4 paramlist))
	(isnumericstring CP_)
	)
    (setq CP_ (atof* CP_))
    (setq CP_ 0.1)
    )


  (setq CT_nom (atof* (nth 1 paramlist)))
  (setq CT_max (atof (nth 2 paramlist)))
  ;(setq CT_ (max (* 1.6 (atof* (nth 1 paramlist))) (* 1.2 (atof (nth 2 paramlist)))))
  (setq D_truby (atoi (nth 0 paramlist)))
  (setq kol (nth 6 paramlist))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;; ������� �������
  ;(load (strcat #lisppath "specification\\������� ��������.LSP")) ; ���45-4.02-129-2009 = list
  ;(setq dL_izo (get-closer-from-table CT_ D_truby #���45-4.02-129-2009))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;     �� �������� ����� ��������� ��� ������ ������������
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     �������     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq bobyshka-OT (or (> CP_ 2.6) (= "��" (nth 5 paramlist))))
  ; ������� ������ 2010-01
  (defun metran226|get-L_bobysh (/)
    (cond
      ((< D_truby 150) 40)
      ((>= D_truby 150) 60)
      )
    );defun
  (setq L_bobysh (if bobyshka-OT
		   80
		   (metran226|get-L_bobysh)))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ������      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




  (defun metran226|get-sens-kod (/ lst)
    "02"
    )
  (setq sens-kod (metran226|get-sens-kod))

  (setq shema 4)


  (defun metran226|get-diap ( / tmp lst)
    (setq lst '((-70 500)(-30 350)(-50 200)(-30 200)))
    (setq tmp (* CT_nom 1.6))
;;;    (mapcar
;;;      '(lambda (x)
;;;	 (diap 20 (car x) (cadr x))
;;;	 )
;;;      lst)
    "-70...500"
    )
  (setq T_diap (metran226|get-diap))
  
  

  (defun metran226|get-klass (/ lst)
    ;(setq lst '((-70 500)(-30 350)(-50 200)(-30 200)))
    "B"
    )
  (setq klass-dopuska (metran226|get-klass))


    

  (defun metran226|get-L_mont (/ lst condidatelist Lmch_min Lmch_max)
    (setq lst '(60 80 100 120 160 200 250 320 400 500 630 800 1000 1250 1600 2000))
    (setq Lmch_min (+ (/ D_truby 3.0) L_bobysh))
    (setq Lmch_max (+ (/ D_truby 1.8) L_bobysh))
    (setq condidatelist (vl-remove-if '(lambda (x)
					 (or (< x Lmch_min)
					     (> x Lmch_max))) lst))
    (if condidatelist
      (eval (append '(min) condidatelist))
      (eval (append '(min) lst))	;��������� ���� ���� �������� ���������� � ������ 57 �� 400 ��������
;;;      (if (< D_truby (- (car lst)  L_bobysh))
;;;	(alert "������� ������ ����� � �������� �������\n��� ����� ����� ��������� �����")
;;;	(car lst)
;;;	)
      )
  );defun
  (setq L_mch (metran226|get-L_mont))

  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq L_nch 120)




  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ��������    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  (append
    (list
    (list
      ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
      pozitions
      (strcat
	"�������������������� ������������� ����������:" "\n"
	"��� \"Pt100\", ����� ������� "klass-dopuska", �������� ��������� " T_diap "\\~%%dC," "\n"
	"����� ��������� ����� " (itoa L_mch) " ��," "\n"
	"��� ��������� - ��������� ������, M20x1,5, ������� ������ IP65" "\n"
	"� ���������:"
	)
      
      (strcat
	"��� ������-226-" sens-kod "-" (itoa L_mch) "-" klass-dopuska "-"(itoa shema)"-1-" "\n"
	"-�10-(" T_diap ")%%dC-�1.1-��" "\n"
	"�� 4211-03-12580824-2002"
	)
      ""
      (strcat "�� \"������\"\n�. ���������")
      "��."
      kol
      ""
      "������"
      )
   
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (list
      ""
      (strcat
	     "������ �������� �������:" "\n"
	     "����� ��������� ����� " (itoa L_mch) " ��, ������������� M20x1,5," "\n"
	     "�������� �������� 25 ���, �������� 12�18�10�"
	     )
      (strcat
	"2001-02-M20x1,5-M20x1,5-�10-"(itoa L_mch) "\n"
	"�� 3742-002-07503230-2007"
	)
      ""
      (strcat "�� \"������\"\n�. ���������")
      "��."
      kol
      ""
      "������"
      );list
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    )
  (point|gen-zakaz-bobyshka xlslines)
  )
    

  
  );defun