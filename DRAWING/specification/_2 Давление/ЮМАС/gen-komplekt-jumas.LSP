; 13_05_16
; ����
; ����� ���������������� �������� �. �����
; ��100


; ��������� ������ - ����� ��������� ������������
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;; ���������� ����� ��� ���������� �������� (������)
(setq
  #jumasMP|catranges
   '(
     (1 0 60 "���")
     (2 0 40 "���")
     (3 0 25 "���")
     (4 0 16 "���")
     (5 0 10 "���")
     (6 0 6 "���")
     (7 0 4 "���")
     (8 0 2.5 "���")
     (9 0 1.6 "���")
     (10 0 1.0 "���")
     (11 0 0.6 "���")
     (12 0 0.4 "���")
     (13 0 250 "���")
     (14 0 160 "���")
     (15 0 100 "���")
     (16 0 60 "���")
     )
  )

(setq #jumasMP|calcranges
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
   #jumasMP|catranges)
      )


;(setq xlsline (cadr (cdr (nth 14 datazipped))))
;(setq xlsline (car (excel>lst)))
(defun jumasMP|getrange (xlsline / lst valsafe valmin valnom valmax units tmp)
  (setq valmin (atof* (xlsgpar "min_val" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  ;13_05_28 ��������� ���� ... ������ ��� �� ������
  ;(setq valsafe (max (* 1.38 valnom) (* 1.38 valmax)))
  (setq valsafe (max (* 1.38 valnom) (* 1.1 valmax)))
  
  (setq units (xlsgpar "units" xlsline))
  (setq lst (vl-remove-if '(lambda (rang) (or(< valmin (nth 1 rang))(> valsafe (nth 2 rang)))) #jumasMP|calcranges))
  (setq lst (vl-remove-if-not '(lambda (x) (= units (nth 3 x))) lst))
  (setq tmp (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) lst))
  ;(assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges)
  ;������� � ����� "������������� ��������"
  (append
    (setq tmp (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #jumasMP|catranges))
    (list (nth 1 tmp) (/ (fix (* 10 valsafe)) 10.0)))
  );defun
;(#jumasMP|getrange xlsline)













;(setq xlslines (cdr proto))
;(setq xlslines (cdr (cadr (cadr (nth 16 datazipped2)))))
(defun gen-zakaz-jumas
       (xlslines /
	xlsline
	pozitions
	range
	mesto
	diamkorp
	klass
	kol
	paragraf
	)

  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  ;"LAB32CP001, LAB32CP002" 


  (setq xlsline (car xlslines))
  (setq range (jumasMP|getrange (car xlslines)))
  (setq diamkorp 100)	;������� �������
  (setq klass 1.5)
  (setq kol (length xlslines))
  (setq mesto (xlsgpar "place_sensor" xlsline))
  ;;;; ��� APC-2000ALW
	;; �� ���������
  	;; ���� �������������� �����
  	;; ������� ��������� - ��
  	;; VM-1 - �� �����
  	;; ��. �� �����������, �� ������� t - VM-1/������
  	;; �� ����� ������ �� �������������� � ����� ������
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ��������    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  
  (setq
    paragraf
     (list
       (list
	 ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	 pozitions
	 (strcat
	"�������� ������������ � ���������� �������� ��� ������:" "\n"
	"�������� ��������� " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range)", " 
	"����� �������� " (rtos* klass) "\n"
	mesto
	)
      (strcat
	"��" (itoa diamkorp) "� (" (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) ") "(nth 3 range)"-" (rtos* klass) "\n"
	"�� �� 37388602.002-96"
	)
      ""
      (strcat "���� \"����� ���������������� ��������\"" " " "�. �����")
      "��."
      (itoa kol)
      ""
      "������"
      );grafa
    )
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraf
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;










;;;;; ���������� ����� ��� ���������� �������� (������)
(setq
  #jumasMVP|catranges
   '(
     (1 -100 60 "��� ���")
     (2 -100 150 "��� ���")
     (3 -100 300 "��� ���")
     (4 -100 500 "��� ���")
     (5 -0.1 0.9 "��� ���")
     (6 -0.1 1.5 "��� ���")
     (7 -0.1 2.4 "��� ���")
     )
  )

(setq #jumasMVP|calcranges
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
   #jumasMVP|catranges)
      )

;(setq xlsline (cadr (cdr (nth 14 datazipped))))
;(setq xlsline (car (excel>tbl)))
(defun jumasMVP|getrange (xlsline / lst valsafe valmin valnom valmax units tmp)
  (setq valmin (atof* (xlsgpar "min_val" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "max_val" xlsline)))
  ;13_05_28 ��������� ���� ...
  (setq valsafe (max (* 1.38 valnom) (* 1.38 valmax)))
  (setq units (xlsgpar "units" xlsline))
  (setq lst (vl-remove-if '(lambda (rang) (or(< valmin (nth 1 rang))(> valsafe (nth 2 rang))))#jumasMVP|calcranges))
  (setq lst (vl-remove-if-not '(lambda (x) (= units (nth 3 x))) lst))
  (setq tmp (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) lst))
  ;(assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges)
  ;������� � ����� "������������� ��������"
  (append
    (setq tmp (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #jumasMVP|catranges))
    (list (nth 1 tmp) (/ (fix (* 10 valsafe)) 10.0)))
  );defun
;(jumasMVP|getrange xlsline)





;(setq xlslines (cdr proto))
;(setq xlslines (cdr (cadr (cadr (nth 16 datazipped2)))))
(defun gen-zakaz-jumas-MVP
       (xlslines /
	xlsline
	pozitions
	range
	mesto
	diamkorp
	klass
	kol
	paragraf
	)

  (setq pozitions (VL-STRING-RIGHT-TRIM ", " (eval (append (list 'strcat) (mapcar '(lambda (line)(strcat(xlsgpar "KKS" line) ", "))xlslines)))))
  ;"LAB32CP001, LAB32CP002" 
  (setq xlsline (car xlslines))
  (setq range (jumasMVP|getrange (car xlslines)))
  (setq diamkorp 100)	;������� �������
  (setq klass 1.5)
  (setq kol (length xlslines))
  (setq mesto (xlsgpar "place_sensor" xlsline))
  
  (setq
    paragraf
     (list
       (list
	 ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	 pozitions
	 (strcat
	"�������������� ������������ � ���������� �������� ��� ������:" "\n"
	"�������� ��������� " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range)", " 
	"����� �������� " (rtos* klass) "\n"
	mesto
	)
      (strcat
	"���" (itoa diamkorp) "� (" (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) ") "(nth 3 range)"-" (rtos* klass) "\n"
	"�� �� 37388602.002-96"
	)
      ""
      (strcat "���� \"����� ���������������� ��������\"" " " "�. �����")
      "��."
      (itoa kol)
      ""
      "������"
      );grafa
    )
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraf
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;(setq xlslines (cdr proto))
;(setq xlslines (cdr (cadr (cadr (nth 22 datazipped2)))))
(defun gen-zakaz-jumas-EKM
       (xlslines /
	xlsline
	pozitions
	range
	mesto
	diamkorp
	klass
	kol
	paragraf
	)
  
  (setq pozitions (spc|gsfxl3 '("KKS") '(", ") xlslines))


  (setq xlsline (car xlslines))
  (setq range (jumasMP|getrange (car xlslines)))
  (setq diamkorp 100)	;������� �������
  (setq klass 1.5)
  (setq kol (length xlslines))
  (setq mesto (xlsgpar "place_sensor" xlsline))
  ;;;; ��� APC-2000ALW
	;; �� ���������
  	;; ���� �������������� �����
  	;; ������� ��������� - ��
  	;; VM-1 - �� �����
  	;; ��. �� �����������, �� ������� t - VM-1/������
  	;; �� ����� ������ �� �������������� � ����� ������
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ��������    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  
  (setq
    paragraf
     (list
       (list
	 ;(strcat "{\\W0.8;\\T0.9;" pozitions "}" )
	 pozitions
	 (strcat
	   "�������� ������������ ��������������� � ���������� ��������," "\n"
	   "��� ������, �� �����������������:" "\n"
	   
	"�������� ��������� " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range)", " 
	"����� �������� " (rtos* klass) ", ������� ����� ����������" "\n"
	mesto
	)
      (strcat
	"���" (itoa diamkorp) "�� ("
	(rtos* (nth 1 range))
	"..."
	(rtos* (nth 2 range))
	") "
	(nth 3 range)
	"-"
	(rtos* klass)
	"\n"
	"�� �� 37388602.002-96"
	)
      ""
      (strcat "���� \"����� ���������������� ��������\"" " " "�. �����")
      "��."
      (itoa kol)
      ""
      "������"
      );grafa
    )
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraf
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       