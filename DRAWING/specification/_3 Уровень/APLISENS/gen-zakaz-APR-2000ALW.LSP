; 13_05_20
; APLISENS
; ��� ����������
; APR-2000ALW


; ��������� ������ - ����� ��������� ������������
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;; ���������� ����� ��� ���������� �������� (������) ; ���
(setq #apr|catranges
   '((1 0 1.6 "���")
     (2 0 250 "���")
     (3 0 100 "���")
     (4 0 25 "���")
     (5 -10 10 "���")
     (6 -0.5 7 "���")
     (7 -2.5 2.5 "���")))
(setq #apr|calcranges
 (mapcar '(lambda (x) (if (= "���" (nth 3 x)) (list (nth 0 x) (fix (* 1000 (nth 1 x))) (fix (* 1000 (nth 2 x))) "���") x)) #apr|catranges))
   





(defun apr|getrange (xlsline / lst val valmin valnom valmax tmp)
  (setq valmin (phis|m->kpa (atof* (xlsgpar "min_val" xlsline))))
  (setq valnom (phis|m->kpa (atof* (xlsgpar "nom_val" xlsline))))
  (setq valmax (phis|m->kpa (atof* (xlsgpar "max_val" xlsline))))
  (setq val (max (* 1.3 valnom) (* 1.1 valmax)))
  (setq lst (vl-remove-if '(lambda (rang) (or (< valmin (nth 1 rang)) (> val (nth 2 rang))))#apr|calcranges))
  (setq tmp (mapcar '(lambda (x) (- (nth 2 x) (nth 1 x))) lst))
  ;(assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges)
  ;������� � ����� "������������� ��������"
  (append (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #apr|catranges) (list (fix valmin) (fix val)))
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
  (setq shtucer "�")
  (setq kol (length xlslines))
  (setq mesto "����� ��������")
  (setq ispolnenie "�����������")

  ;; �� ���������
  ;; ���� �������������� �����
  ;; ������� ��������� - ��
  ;; VM-3 - �� �����
  ;; ��. �� �����������, �� ������� t - VM-1/������
  ;; �� ����� ������ �� ������������� � ����� ������

  ;(setq sreda (xlsgpar "�����" xlsline))
  (setq kodventil "VM-3/������")
  (setq nippel "2")
  (setq kreplenie "C-2")


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
	"������������� �������� " (rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " " (nth 3 range) "\n"
	"���������� " ispolnenie ", �������� ������ 4...20 ��, HART" "\n"
	;"����� �������� 0,1 %,"
	"������������� " shtucer ", � ���������:" "\n"
	"���������� ����, "
	"�������� �������� " nippel ", "
	"��������� " kreplenie "\n"
	mesto
	)
      (strcat "{\\W0.9;"
	"APR-2000ALW/"
	(if (= ispolnenie "�����������") "" (strcat ispolnenie "/"))
	(rtos* (nth 1 range)) "..." (rtos* (nth 2 range)) " " (nth 3 range) "/"
	(rtos* (nth 4 range)) "..." (rtos* (nth 5 range)) " " (nth 3 range) "/" "\n"
	"/" shtucer "/" kodventil "/" nippel "/" kreplenie "\n"
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
    (gen-zakaz-sosudur xlslines)
    (list "")
    );paragraph
	);setq

;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  
  paragraph
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

