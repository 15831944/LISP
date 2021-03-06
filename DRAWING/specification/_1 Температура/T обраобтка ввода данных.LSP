;;; ������� ���������
;;; 13_04_30

;;;    13_05_29
;;;    13_11_05
;;;    14_12_10






;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\spclib.lsp"))
(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))
(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
;(load (strcat #lisppath "DATA-Tables\\ziplist.LSP"))
(load (strcat #lisppath "DataBase\\dblib.LSP"))


;; ������� 13_08_28
(load (strcat #lisppath "DRAWING\\specification\\������� ��������.LSP")) ; ���45-4.02-129-2009 = list

(load (strcat #lisppath "DRAWING\\specification\\_1 �����������\\����� �.������\\gen-zakaz-point.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\_1 �����������\\������\\gen-complekt-metran226.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\_1 �����������\\WIKA\\gen-zakaz-wika.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\_1 �����������\\������������\\gen-zakaz-������������.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\_1 �����������\\gen-zakaz-zavod-T.LSP"))



;;;(load (strcat #lisppath "common functions/lst-strlst.LSP"))
;;;(load (strcat #lisppath "common functions/tbl-to-txtfile.LSP"))
;;;(tbl->txtfile xls-data)
;(setq xls-head (mapcar 'vla-get-textstring (ss->lsto (ssget))))
;(setq xls-head (mapcar 'vla-get-textstring (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "*TEXT"))) "x"))))
;(setq xls-data (mapcarx vla-get-textstring nil (ss->tbl (ssget '((0 . "*TEXT"))))))
;(length xls-data)
;(getxlsdata)




;;; �������� ��������������� ��
;;; 1 func
;;; 2 �����
;;; 3 KKS

;;  1-� ����
; (setq xls-data (excel>lst)) (setq xls-head (car xls-data) data (xls|formatdata (cdr xls-data)))







;; 2-� ����
(setq xls-head (car (excel>lst)))
;(setq data (DB|FORMATDATA (excel>lst)))
(setq data (db|formatdata (excel>lst)))



;(setq xlsline (nth 0 data))

;;; ��������� � ������ ������ ���������� ��� ��� ����������� ������ ������ �������
;;; ������ �� ���������� ���������
;;; � ����� ������������� (����������) ������� ������



; ���������� �� ���������� : �����, ��������� �����, ���., max
(setq datazipped
  (ziplist
    (mapcar
     '(lambda (xlsline / mv)
	(list
	  (strcat
	    (xlsgpar "��������" xlsline)
	    (xlsgpar "Lmch" xlsline)
	    ;(if (setq mv (xlsgpar "sampling_device" xlsline)) mv "nil")
	    (xlsgpar "nom_val" xlsline)
	    ;(if (setq mv (xlsgpar "max_val" xlsline)) mv "nil")
	    (if (setq mv (xlsgpar "val_p_u" xlsline)) mv "nil")
	    (xlsgpar "material" xlsline)
	    )
	  xlsline
	  )
	)
     data)
    )
 )
;(length datazipped)
























;(setq pardata (nth 2 datazipped))
(defun gen-paragraf (pardata /  xlslinesTT parname tail)
  (setq xlslinesTT (cdr pardata))
  (setq parname (VL-STRING-right-TRIM ",\n" (apply 'strcat (mapcar '(lambda (xlsline) (strcat (xlsgpar "meas_name" xlsline) " " (xlsgpar "nom_val" xlsline) "\\~" (xlsgpar "units" xlsline) ",\n")) xlslinesTT))))
  (append
    (list
      (list "" parname)
      (list "")      
      )
    (cond
      ((= "��-�-�" (xlsgpar "��������" (car xlslinesTT)))
       (point-TP|*gen*zakaz xlslinesTT)
       )
      ((= "��-�-�" (xlsgpar "��������" (car xlslinesTT)))
       (point-TS|*gen*zakaz xlslinesTT)
       )
      ((= "��-�" (xlsgpar "��������" (car xlslinesTT)))
       (point-TSB|*gen*zakaz xlslinesTT)
       )
      ((= "������������" (xlsgpar "��������" (car xlslinesTT)))
       (EP|gen-zakaz xlslinesTT)
       )
      ((= "������-226" (xlsgpar "��������" (car xlslinesTT)))
       (gen-zakaz-metran226 xlslinesTT)
       )
      ((= "�����" (xlsgpar "��������" (car xlslinesTT)))
       (gen-zakaz-zavod-T xlslinesTT)
       )
      ((= "wika" (xlsgpar "��������" (car xlslinesTT)))
       (wika|*gen*zakaz xlslinesTT)
       )
      );cond
    
    ;(list (list ""))
    
    );append
  );defun





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq pt (getpoint))


(defun addparagraph (pt parstr / cpt)
  (setq cpt pt)
  (mapcar '(lambda (grafa / nl)
	     (setq cpt (spc|addgrapha cpt grafa))
	     )
	  parstr)
  (mapcar '- cpt (list 0 8 0))
  )

;(addparagraph (getpoint) parstr)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;#list_cpt
;(setq parstr paragdata)
;(setq parstr (gen-paragraf pardata))
(defun addparagraph3 (pt parstr / cpt)
  (setq cpt pt)
  (mapcar
    '(lambda (grafa / nl)
	     (setq cpt (spc|addgrapha cpt grafa))
	     ;������� ���������� ��� ���������� �� �����
	     (if (>= (- (cadr #list_cpt) (cadr cpt)) 192 )
	       (progn
		 (setq cpt (mapcar '+ cpt '(0 -120 0))
		       #list_cpt cpt)
		 (vla-addline #modspace
		   (vlax-3d-point cpt)
		   (vlax-3d-point (mapcar '+ cpt '(-100 0 0)))
		   )
		 ;(vla-Addtext #modspace (xlsgpar "�����" (cadr (car (cadr parstr)))) (vlax-3d-point (mapcar '+ cpt '(-200 0 0))) 2.5)
		 )
	       )
	     )
    parstr
    )
  cpt
  );defun






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;   ���������� �������  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun addpodrazdel2 (listforgendat / cpt list_cpt)
  (setq cpt (getpoint)
	list_cpt cpt)

  ;(setq pardata (nth 0 listforgendat))
  (mapcar '(lambda (pardata /)
	     (setq cpt (addparagraph cpt (gen-paragraf pardata)))
	     ;������� ���������� ��� ���������� �� �����
	     (if (>= (- (cadr list_cpt) (cadr cpt)) 192)
	       (progn
		 (setq cpt (mapcar '+ cpt '(0 -120 0))
		       list_cpt cpt)
		 (vla-addline #modspace
		   (vlax-3d-point cpt)
		   (vlax-3d-point (mapcar '+ cpt '(-100 0 0)))
		   )
		 )
	       )
	     )
	  listforgendat)

  )
;(addparagraph (getpoint) (gen-paragraf pardata))




;(setq listforgendat datazipped)
(defun addpodrazdel3 (listforgendat / cpt )
  (setq cpt (getpoint)
	#list_cpt cpt)
  ;(setq pardata (nth 0 listforgendat))
  (mapcar
    '(lambda (pardata /)
       (setq cpt (addparagraph3 cpt (gen-paragraf pardata)))
       )
    listforgendat)
  );defun
;(addparagraph (getpoint) (gen-paragraf pardata))









(addpodrazdel3 datazipped)
(addpodrazdel2 datazipped)

;14_02_27 ����������� addpodrazdel2 � �� ������� (����, ... ��������� ��� ����� �������� �����)






;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . ""))))
;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . " "))))