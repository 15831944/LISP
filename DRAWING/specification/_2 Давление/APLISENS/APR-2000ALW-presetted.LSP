; 13_05_20
; APLISENS
; ��� ����������
; APR-2000ALW


; ��������� ������ - ����� ��������� ������������
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;; ���������� ����� ��� ���������� �������� (������) ; ���
(setq #apr|catranges
   '((1 0 1.6 "���" 25)
     (2 0 250 "���" 25)
     (3 0 100 "���" 25)
     (4 0 25 "���" 25)
     (5 -10 10 "���" 25)
     (6 -0.5 7 "���" 4)
     (7 -2.5 2.5 "���" 4)
     )
      )

;������� ����� � ������������ �������������� �������� , ������� ��������� ��� � �����������
(defun apr|calcranges (ranges)
   (mapcar
     '(lambda (x)
	(cond
	  ((= "���" (nth 3 x)) (list (nth 0 x) (/ (nth 1 x) 1000.0) (/ (nth 2 x) 1000.0) "���"))
	  (T x)
	  )
	)
     ranges
     )
  )
;(apr|calcranges #apr|catranges)




;(setq #apr|calcranges
; (mapcar '(lambda (x) (if (= "���" (nth 3 x)) (list (nth 0 x) (fix (* 1000 (nth 1 x))) (fix (* 1000 (nth 2 x))) "���") x)) #apr|catranges))
   




;(setq xlsline (car (DB|FORMATDATA (excel>lst))))

(defun apr|getrange (xlsline
		     /
		     units
		     valmin uniVmin
		     valnom uniVnom
		     valmax uniVmax
		     catdiaps uniVdiap
		     ans
		     tmp
		     )
  (setq units (xlsgpar "units" xlsline))
  (setq valmin (atof* (xlsgpar "val_p_l" xlsline)))
  (setq valnom (atof* (xlsgpar "nom_val" xlsline)))
  (setq valmax (atof* (xlsgpar "val_p_u" xlsline)))
  (cond
    ((= "���" units)
     (setq uniVmin valmin)
     (setq uniVnom valnom)
     (setq uniVmax valmax)
     )
    ((= "���" units)
     (setq uniVmin (/ valmin 1000.0))
     (setq uniVnom (/ valnom 1000.0))
     (setq uniVmax (/ valmax 1000.0))
     )
    )
  ;(setq val (max (* 1.3 valnom) (* 1.1 valmax)))
  
  (setq
    ans
     (vl-remove-if
       '(lambda (rang)
	  (or
	    (< uniVmin (nth 1 rang))
	    (> uniVmax (nth 2 rang))
	    )
	  )
       (apr|calcranges #apr|catranges)
       )
    )


  (setq catdiaps (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) ans))
  (setq tmp (apply 'min catdiaps))
  ;(assoc (car (nth (vl-position tmp catdiaps) ans)) #apr|catranges)
  ;������� � ����� "������������� ��������"
  (concat
    (assoc (car (nth (vl-position tmp catdiaps) ans)) #apr|catranges)
    (list (fix valmin) (fix valnom))
    )
  );defun




(setq #elemer|sosudur
   '(
     ("��-6,3-2-" 6.3)
     ("��-6,3-4-" 6.3)
     ("��-25-2-" 25)
     ("��-40-" 40)
     ))


(defun gen-zakaz-sosudur (xlslines / kol lst CP tmp mater)
  (setq kol (length xlslines))
  (if (= "dPTF" (xlsgpar "func" (car xlslines))) (setq kol (* 2 kol)))
  (setq mater "�")
  (setq CP (atof* (xlsgpar "P" (car xlslines))))
  (setq lst (vl-remove-if '(lambda (rang) (> CP (nth 1 rang))) #elemer|sosudur))
  (setq tmp (mapcar '(lambda (x) (nth 1 x)) lst))
  (setq tmp (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #elemer|sosudur))
  (list "" "����� �������������" (strcat (car tmp) mater) "" "��� \"������\"\n�. ������" "��." (rtos* kol) "" "������")
  );defun




;(setq xlslines (cdr pardata))


(defun gen-zakaz-APR2000ALW  (xlslines / 
	xlsline pozitions range
	shtucer mesto kol ispolnenie
	;sreda
	kodventil nippel kreplenie
	paragraph
	)

  
  (setq pozitions (spc|gsfxl "KKS" ", " xlslines))
  (setq range (apr|getrange (car xlslines)))

  (setq kol (length xlslines))
  ;(setq mesto "����� ��������")
  (setq mesto (xlsgpar "place_sensor" (car xlslines)))
  (setq ispolnenie "�����������")

  ;; �� ���������
  ;; ���� �������������� �����
  ;; ������� ��������� - ��
  ;; VM-3 - �� �����
  ;; ��. �� �����������, �� ������� t - VM-1/������
  ;; �� ����� ������ �� ������������� � ����� ������




  
  ;;  ��� ����������� �����
  ;(setq sreda (xlsgpar "�����" xlsline))

  ;(setq shtucer "�")
  ;(setq kodventil "VM-3/������")
  ;(setq nippel "2")
  ;(setq kreplenie "C-2")



    ;;;  ����������� ���������
  (setq shtucer "P")
  ;(setq kodventil "M0")
  ;(setq nippel "SO")
  ;(setq kreplenie "AL")

  

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;     ��������    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  
  (setq paragraph
   (list
    (list
      ;(strcat "{\\W0.9;\\T0.9;" pozitions "}" )
      pozitions
      (strcat
	"��������������� ������������� �������� ��������:" "\n"
	"�������� �������� " (rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) ", "
	"������������� �������� " (rtos* (nth 5 range)) "..." (rtos* (nth 6 range)) " " (nth 3 range) "\n"
	"���������� " ispolnenie ", �������� ������ 4...20 ��, HART" "\n"
	;"����� �������� 0,1 %,"
	"������������� " shtucer ", "
	(cond
	  ((and kodventil nippel (not (= "" kodventil nippel)))
	   (strcat
	     "� ���������:" "\n"
	     "���������� ����, " kodventil ", "
	     "�������� �������� " nippel ", "
	     )
	   )
	  (T "")
	)
	(if (and kreplenie (not (= "" kreplenie))) (strcat "��������� " kreplenie) "")
	"\n"
	mesto
	)
      (strcat "{\\W0.9;"
	"APR-2000ALW/"
	(if (= ispolnenie "�����������") "" (strcat ispolnenie "/"))
	(rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) "/"
	(rtos* (nth 5 range)) "..." (rtos* (nth 6 range)) " " (nth 3 range) "/" "\n"
	"/" shtucer
	      (if (and kodventil (not (= "" kodventil))) (strcat "/" kodventil) "")
	      (if (and nippel (not (= "" nippel))) (strcat "/" nippel) "")
	      (if (and kreplenie (not (= "" kreplenie))) (strcat "/" kreplenie) "")
	      "\n"
	"�� �� 390171150.001-2004"
	"}")
      ""
      (strcat "��� \"����������\"" "\n" "�. �������")
      "��."
      (itoa kol)
      ""
      "������"
      );grafa
    (list "")
    ;(gen-zakaz-sosudur xlslines)
    ;(list "")
    );paragraph
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraph
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

