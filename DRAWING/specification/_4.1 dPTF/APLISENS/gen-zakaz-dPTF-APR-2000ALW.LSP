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
(setq #apr|calcranges (mapcar '(lambda (x) (if (= "���" (nth 3 x)) (list (nth 0 x) (fix (* 1000 (nth 1 x))) (fix (* 1000 (nth 2 x))) "���") x)) #apr|catranges))
   

;(aprdPTF|getrange xlsline)
(defun aprdPTF|getrange (xlsline / lst val scale tmp)
  (setq scale (atof* (xlsgpar "scale" xlsline)))
  (setq
    lst
     (vl-remove-if
       '(lambda (rang)  
	  (> (* 1.2 scale) (nth 2 rang))
	  )
       #apr|calcranges)
    )
  (setq
    tmp
     (mapcar
       '(lambda (x)
	  (nth 2 x)
	  )
       lst)
    )
  (append
    (assoc
      (car (nth (vl-position (apply 'min tmp) tmp) lst))
      #apr|catranges
      )
    
    (list 0 (fix scale))
    )
  );defun




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   13_05_06 - �������� ��������� ����� ��������� ��������
(if (null pointmnt|gen-zakaz-sosudur) (load (strcat #lisppath "DRAWING\\specification\\_9 ������\\pointmnt.LSP")))
(if (null gen-zakaz-diafragma) (load (strcat #lisppath "DRAWING\\specification\\_9 ������\\gen-zakaz-diafragma.lsp")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlslines (cdr pardata))
(defun gen-zakaz-dPTF-APR2000ALW  (xlslines / 
	xlsline pozitions range
	shtucer mesto kol ispolnenie
	;sreda
	kodventil nippel kreplenie
	paragraph
	)
  (setq
    paragraph
     (append
       (mapcar 'gen-1-dPTF-APR xlslines)
       (list
	 (list "")
	 ;(gen-zakaz-sosudur xlslines)
	 (pointmnt|gen-zakaz-sosudur xlslines)
	 (list "")
	 (gen-zakaz-diafragma xlslines)
	 (list "")
	 )
       );paragraph
    );setq
;;;  (if rashiritel
;;;    (addrashiritel)
;;;    )
  paragraph
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq xlsline (cadr xlslines))
(defun gen-1-dPTF-APR
       (xlsline
	/
	range
	)
  (setq range (aprdPTF|getrange xlsline))
  (setq shtucer "�")
  (setq kol 1)
  (setq mesto (xlsgpar "place_sensor" xlsline))
  (setq ispolnenie "�����������")
  (setq kodventil "VM-5/������")
  (setq nippel "2")
  (setq kreplenie "C-2")
  
  (list
      ;(strcat "{\\W0.9;\\T0.9;" (xlsgpar "KKS" xlsline) "}" )
      (xlsgpar "KKS" xlsline)
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
      )         
  );defun