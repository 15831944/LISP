; 13_10_31
; MARK
; ��� "����" �.������ ��������
; MARK-602
; ��������� ������ - ����� ��������� ������������




;(defun gen-zakaz-MARK (paragdata / dblines montazhBP sensors)

;(setq paragdata (nth 5 datazipped))
(setq dblines (cdr paragdata))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun genstrparvalforname (dbline / pnom pmin pmax)
  ;(setq dbline (car dblines))
  (setq pnom (db|gpar "nom_val" dbline)
	pmin (db|gpar "min_val" dbline)
	pmax (db|gpar "max_val" dbline))
  (cond
    ((/= pnom "") pnom)
    ((and (/= pmin pmax "" )) (strcat pmin "-" pmax))
    ((/= "" pmax) (strcat "<" pmax))
    ((/= "" pmin) (strcat ">" pmin))
    (T (princ "\n �� ������� ��������") (exit))
    );cond
  );defun
;(genstrparvalforname (cadr paragdata))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(MARK|gen-paragraph-name dblines)
(defun MARK|gen-paragraph-name (dblines)
  (strcat "{\\W0.9;\\T0.95;" (vl-string-right-trim "\n"  (apply 'strcat  (mapcar
	'(lambda (dbline / p)
	   (strcat
	     (db|gpar "meas_name" dbline) " "
	     (genstrparvalforname dbline) "\\~"
	     (db|gpar "units" dbline) "\n"
	     ))
	dblines))) "}" )
    );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gendiapforSvEvg (dbline / SvEvg pmin pnom pmax)
  (setq SvEvg '(10 200 1000 5000))
  (setq pnom (db|gpar "nom_val" dbline)
	pmin (db|gpar "min_val" dbline)
	pmax (db|gpar "max_val" dbline))
  (get-closer-from-row (max (* (atof* pmin) 2.0) (* (atof* pnom) 1.6)(* (atof* pmax) 1.2)) SvEvg)
  );defun
(defun gendiapfordat (dbline / catalog pmin pnom pmax)
  (setq catalog '( 2000 20000 ))
  (setq pnom (db|gpar "nom_val" dbline)
	pmin (db|gpar "min_val" dbline)
	pmax (db|gpar "max_val" dbline))
  (get-closer-from-row (max (* (atof* pmin) 2.0) (* (atof* pnom) 1.6)(* (atof* pmax) 1.2)) catalog)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq
  sensors
   (mapcar
     '(lambda (dbline)
	(list (null (vl-string-search "��" (db|gpar "��������" dbline)))
	      (gendiapfordat dbline))
	) dblines)
  );setq

(setq montazhBP (vl-remove 'nil (mapcar '(lambda (x) (db|gpar "place_cpu" x) ) (cdr paragdata))))
(if (and (apply '= montazhBP)
	 (null (member (car montazhBP) '("�� �����" "�� �����" "��-�����" "��_�����"))))
  (setq montazhBP "���") (setq montazhBP "�����")
  )



(setq namerecord (append
     (list "")
     (cond
       ((vl-string-search "409" (db|gpar "��������" (cadr paragdata)))
	(list "���������� ������������� ��������� � ����� �������� ���������\n� ���������:" "����-409" (if (= "�����" montazhBP)"/1") "\n�� 4215-037-39232169-2004"))
       ((vl-string-search "602" (db|gpar "��������" (cadr paragdata)))
	(list "������������-������� � ����� �������� ���������\n� ���������:" "����-602" (if (null (caar sensors))"��") (if (= "�����" montazhBP)"/1") "\n�� 4215-025-39232169-2006"))
       ((vl-string-search "902" (db|gpar "��������" (cadr paragdata)))
	(list "pH-���� � ����� �������� ���������\n� ���������:" "����-902" (if (null (caar sensors))"��") (if (= "�����" montazhBP)"/1") "\n�� 4215-024-39232169-2006"))
       ((vl-string-search "1002" (db|gpar "��������" (cadr paragdata)))
	(list "���������� ������ � ����� �������� ���������\n� ���������:" "����-1002" (if (= "�����" montazhBP)"/1") "\n�� 4215-028-39232169-2010"))
       );cond
     (list "" "��� \"����\"\n�.������ ��������" "�����." "1" "" "������")
     )
  );setq





(setq
  BPrecord
   (list
     (car paragdata)
     (strcat
      "���� ������������������ " (cond ((= montazhBP "���") "��������") ((= montazhBP "�����") "����������")) " ����������/t/t/t 1\\~��.\n"
      "�������� ���������:\n"
      (strcat "����� A: " (strcat "0..." (itoa (gendiapforSvEvg (cadr paragdata))) " " (db|gpar "units" (cadr paragdata)) "\n"))
      (strcat "����� B: " (if (caddr paragdata) (strcat "0..." (itoa (gendiapforSvEvg (caddr paragdata))) " " (db|gpar "units" (caddr paragdata)) "\n") "������"))
      "�������� ������: 4...20\\~��. �������\\~~220\\~�\n"
      (db|gpar "place_cpu" (cadr paragdata))
      )
     (strcat "��\n"
      (cond
	((and (vl-string-search "409" (db|gpar "��������" (cadr paragdata)))                     )
	 "BP37.01.000")
	((and (vl-string-search "602" (db|gpar "��������" (cadr paragdata))) (= montazhBP "���") )
	 "BP30.01.000")
	((and (vl-string-search "602" (db|gpar "��������" (cadr paragdata))) (= montazhBP "�����"))
	 "BP42.01.000")
	((and (vl-string-search "902" (db|gpar "��������" (cadr paragdata))) (= montazhBP "���"))
	 "BP31.01.000")
	((and (vl-string-search "1002" (db|gpar "��������" (cadr paragdata))) (= montazhBP "���"))
	 "BP49.01.000")
	)
	     )
     )
  );setq 




(setq
  GPrecord
   (if (null (vl-string-search "��" (db|gpar "��������" (cadr paragdata))))
     (list
       (strcat "{\\W0.95;\\T0.9;" (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (dbline) (strcat (db|gpar "KKS" dbline) "QR01, "))(cdr paragdata))))"}")
       (strcat "����������� \t\t\t\t\t\t\t\t\t" (itoa (length (cdr paragdata))) "\\~��.\n"
	       (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (dbline) (strcat (db|gpar "place_sensor" dbline) ", "))(cdr paragdata))))
	       )
       (cond
	 ((and (vl-string-search "409" (db|gpar "��������" (cadr paragdata))))
	  "��-409\nBP37.04.100")
	 ((and (vl-string-search "602" (db|gpar "��������" (cadr paragdata))))
	  "��-602\nBP30.08.000")
	 ((and (vl-string-search "902" (db|gpar "��������" (cadr paragdata))))
	  "��-902\nBP31.04.000")
	 ((and (vl-string-search "1002" (db|gpar "��������" (cadr paragdata))))
	  "��-1002\nBP49.02.000")
	 )
       )
     );if
  );setq




(defun genDATrecord (dblines / quant)

  (if (apply 'equal sensors)

    (list
  (list
    (strcat "{\\W0.95;\\T0.9;" (VL-STRING-RIGHT-TRIM ", " (apply 'strcat (mapcar '(lambda (dbline) (strcat (db|gpar "KKS" dbline) "QP01, "))dblines)))"}")
    (strcat
      (cond
	((and (vl-string-search "409" (db|gpar "��������" (cadr paragdata))))
	 "������ �����������\t\t\t\t\t\t\t\t")
	((and (vl-string-search "602" (db|gpar "��������" (cadr paragdata))))
	 "������ ������������\t\t\t\t\t\t\t\t")
	((and (vl-string-search "902" (db|gpar "��������" (cadr paragdata))))
	 "���� ��������\t\t\t\t\t\t\t\t\t")
	((and (vl-string-search "1002" (db|gpar "��������" (cadr paragdata))))
	 "���� ���������\t\t\t\t\t\t\t\t\t")	
	);cond
      (itoa (length sensors)) "\\~��.\n"

      (cond
	((apply 'and (mapcar 'car sensors))
	 "�����������")
	(T "�� �����")
	)
      )
    
    
   );list
  )
    (list
      (mapcar
	'(lambda(dbline)

	   (mapcar '(lambda (dbline) (strcat (db|gpar "KKS" dbline) "QP01, "))dblines)





	   
	   )
	dblines)
      )

    );if




  




  
  









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     �  �     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq #MARK602|diaplist
   '(
     2000
     20000
     )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun SVTU|gendataRU (xlslinesF)
  (mapcar
    ;(setq xlsline (car xlslinesF))
    '(lambda (xlsline / DN)
       (setq DN (rtos* (cadr (assoc (atof* (xlsgpar "Diam_tr" xlsline)) (mapcar 'reverse #SVTU|Dy-DN)))))
       (list
	 (strcat (xlsgpar "KKS" xlsline) "QP01")
	 DN
	 (xlsgpar "place_sensor" xlsline)
	 ))xlslinesF)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq lstRU (SVTU|gendataRU xlslinesF))
(defun gen-grafaRU (lstRU / out)
  (if (and (= 2 (length lstRU)) (= (cadar lstRU) (cadadr lstRU)))
    (setq out (list (list
	   (strcat "{\\W0.8;\\T0.85;" (car (car lstRU)) ",\n" (car (cadr lstRU)) "}")
	   (strcat "������� ������������� DN " (cadr (car lstRU)) "						2\\~��." "\n" (caddr (car lstRU)))
	   (strcat "��-" (cadr (car lstRU)))
	   )))
    ;(setq x (car lstRU))
    (setq out (mapcar '(lambda (x)
        (list
	  (strcat "{\\W0.8;\\T0.85;" (car x) "}")
	  (strcat "������� ������������� DN " (cadr x) "							1\\~��." "\n" (caddr x))
	  (strcat "��-" (cadr x)))
			 )lstRU))
    );if
  ;(append lst(list "" "" "" "" "" "" "" "" ""))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    �������    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(SVTU|getDFdiap xlsline)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun SVTU|getDFdiap (xlsline / fmin fmax lst actfmin actfmax)
  (setq lst (assoc
	 (cadr (assoc (atof* (xlsgpar "Diam_tr" xlsline)) (mapcar 'reverse #SVTU|Dy-DN)))
	 #SVTU|RUlist))
    (setq fmin (nth 2 lst))
    (setq fmax (nth 4 lst))
    (setq actfmin (xlsgpar "min_val" xlsline))
    (setq actfmax (xlsgpar "max_val" xlsline))
    (if (or (null actfmin) (= "" actfmin) (= "#" actfmin)) (setq actfmin fmin) (setq actfmin (atof* actfmin)))
    (if (or (null actfmax) (= "" actfmax) (= "#" actfmax)) (setq actfmax fmax) (setq actfmax (atof* actfmax)))
    (if (and (>= actfmin fmin) (<= actfmax fmax)) (strcat (rtos* fmin) "..." (rtos* fmax) "\\~" (xlsgpar "units" xlsline))
      (progn (alert (strcat "\n�� SVTU ����� ���������\n �� �������� ������ �������� �������� �� ��������\n" "�������" (xlsgpar "KKS" xlsline)))
	(exit)))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(SVTU|expandFdats xlslinesF)
(defun SVTU|expandFdats (xlslinesF / explines)
  (setq explines '())
  ;(setq xlsline (car xlslinesF))
  ;(SVTU|genqdat xlsline)
  ;get quantity of Flow sensors
  (defun SVTU|genqdat (xlsline) ;(setq dN 80)
    (cond ((diap (cadr (assoc (atof* (xlsgpar "Diam_tr" xlsline)) (mapcar 'reverse #SVTU|Dy-DN))) 32 150) 2)
	  ((diap (cadr (assoc (atof* (xlsgpar "Diam_tr" xlsline)) (mapcar 'reverse #SVTU|Dy-DN))) 200 1000) 4))
    );defun
  (mapcar
    '(lambda (xlsline / qdat str i)
       (setq qdat (SVTU|genqdat xlsline))
       (setq i 64 str "")
       (repeat qdat
	 (setq  explines (append explines(list
		  (subst (strcat (xlsgpar "KKS" xlsline) (chr (setq i (1+ i)))) (xlsgpar "KKS" xlsline) xlsline))))
	 );repeat
       )xlslinesF)
  explines
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(SVTU|gendataFT xlslinesF)
(defun SVTU|gendataFT (xlslinesF)
  (ziplist (mapcar '(lambda (xlsline) (list (SVTU|getDFdiap xlsline) xlsline))
      (SVTU|expandFdats xlslinesF)))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;(gen-grafsdat xlslinesF)
(defun gen-grafsdat (lstFT)
  (mapcar
    					;(setq xlslines (cadr (mapcar 'cdr lst)))
    '(lambda (xlslines)
       (list
	 (strcat "{\\W0.95;\\T0.9;" (spc|gsfxl "KKS" ",\n" xlslines)"}")
	 (strcat
	   "������ ������� ��������������"
	   "						"
	   (rtos* (length xlslines))
	   "\\~��.\n"
	   "� �������������� �������������� �������\n"
	   "�������� ���������: " (SVTU|getDFdiap (car xlslines)) "\n" "�� �����"
	   )
	 "��"
	 )
       )
    (mapcar 'cdr lstFT))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;  (spc|gsfxl3
;;;    '("meas_name" "P" "T" "nom_val" "units")
;;;    (list " " (if (> 10 (atof* p)) "���, " "���, ")        )
;;;    xlslinesF)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq kompldata (nth 2 datazipped))
;(setq kompldata (nth 5 datazipped))
(defun gen-zakaz-SVTU
       (kompldata	;komlekt data
	/
	xlslines
	xlslinesF
	xlslinesT
	qkompl			;komplekt quantity
	pogresh			; ����������� - �1 ��� �2 - ���� �� ���� ������ ����. 3.1
	modif			; ����������� ������� ����. 3.1

	strnames
	strSVTUzakaz
	
	strVychkks
	outlist
	)

  ;(setq pogresh "(�1)")
  (setq pogresh "")
  (setq modif "3")
  (setq strVychkks (car kompldata))
  (setq xlslines (cdr kompldata))
  (setq qkompl 1)
  ;;; ��� ���������� �� ����� ��������� � �������� ��������� ������
    
  (setq xlslinesF (vl-remove-if-not '(lambda (x) (= "FT" (xlsgpar "func" x))) xlslines))
  (setq xlslinesT (vl-remove-if-not '(lambda (x) (= "TTF" (xlsgpar "func" x))) xlslines))



  (setq strSVTUzakaz
     (strcat
       "{\\W0.9;"
       "����10�"
       pogresh
       "-"
       modif
       "-"
       (vl-string-right-trim "/" (apply 'strcat
        (mapcar '(lambda (x) (strcat "��" (vl-string-left-trim "��-" (cadr x)) "/"))(SVTU|gendataRU xlslinesF))))
       "-"
       (vl-string-right-trim "/" (apply 'strcat
	 (mapcar '(lambda (xlsline / DN gpars)
		    (setq DN (DN->Dy (atof* (xlsgpar "Diam_tr" (car xlslines)))))
		    (setq gpars (assoc DN #SVTU|gilzvars))
		    (strcat (rtos* (nth 5 gpars)) "�" (rtos* (nth 4 gpars)) "�" "/")
		    )
		 (mapcar 'cdr (SVTU|gendataTSP xlslinesT)))
					))
       "-\n"
       "[������F]-[������T]-�/��1-220\n"
       "�� �� 191182855.001-2011"
       "}"
       ))






  
  
  (append
    (list
      (list "" (SVTU|gen-paragraph-name xlslinesF) "" "" "" "" "" "" "")
      (list "" "����������������" strSVTUzakaz "" "��� \"�������������\"\n�. �����" "�����." qkompl "" "������")
      (list "" "� ������ ��������� ������:" "" "" "" "" "" "" "")
      (list strVychkks (strcat "�����������									1\\~��.\n�������� ������ 4...20 ��, ������� ~220 �, 50 ��\n" (xlsgpar "place_cpu" (car xlslinesF))) (strcat "����-10�-" modif) "" "" "" "" "" "")
      (list "" "" "" "" "" "" "" "" "")
      )
    (gen-grafaRU (SVTU|gendataRU xlslinesF))
    (list (list "" "" "" "" "" "" "" "" ""))
    (gen-grafsdat (SVTU|gendataFT xlslinesF))
    (list (list "" "" "" "" "" "" "" "" ""))
    (gen-grafsTSP (SVTU|gendataTSP xlslinesT))
    (list (list "" "" "" "" "" "" "" "" ""))
    (gen-grafaothers)
    (list
      (list "" "" "" "" "" "" "" "" "")
      (list "" "" "" "" "" "" "" "" "")
      )
    )

;;;  (setq
;;;    outlist
;;;     (append
;;;    (list
;;;      (list "" "� ������ ��������� ������:" "" "" "" "" "" "" "")
;;;      (list strVychkks (strcat "�����������									1\\~��.\n�������� ������ 4...20 ��, ������� ~220 �, 50 ��\n" (xlsgpar "place_cpu" (car xlslinesF))) (strcat "����-10�-" modif) "" "" "" "" "" "")
;;;      (list "" "" "" "" "" "" "" "" "")
;;;      )
;;;    (gen-grafaRU (SVTU|gendataRU xlslinesF))
;;;    (list (list "" "" "" "" "" "" "" "" ""))
;;;    (gen-grafsdat (SVTU|gendataFT xlslinesF))
;;;    (list (list "" "" "" "" "" "" "" "" ""))
;;;    (gen-grafsTSP (SVTU|gendataTSP xlslinesT))
;;;    (list (list "" "" "" "" "" "" "" "" ""))
;;;    (gen-grafaothers)
;;;    (list
;;;      (list "" "" "" "" "" "" "" "" "")
;;;      (list "" "" "" "" "" "" "" "" "")
;;;      )
;;;    )
;;;     )
;;;  (append
;;;    (list
;;;      (list "" (SVTU|gen-paragraph-name xlslinesF) "" "" "" "" "" "" "")
;;;      (list "" "����������������" strSVTUzakaz "" "��� \"�������������\"\n�. �����" "�����." qkompl "" "������")
;;;      )
;;;    outlist
;;;    )
  );defun


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  ;)