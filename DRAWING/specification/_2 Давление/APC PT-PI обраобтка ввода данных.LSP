;;; ������� ���������
;;; 13_04_30
;;; 14_01_08

;;;;;  �������

; � excel ������������ �������� ����� ��������� ���
; 1-� ������ ��������� (�� ������ ������ �������)
; 		�������� ������� - ��������� (13_04_30 - �������������� ���������)
; ________________________________________________________________________________________

;'("func" "KKS" "mes_name" "Diam_tr" "sign_type" "nom_val" "units" "��������" "max_val" "T" "P" "F" "scale")


;;;; �� ���� ��� �� ������� ����� ������ �������� �� ����� excel ������ ������� �� ������
;;;; ������� � ���������� � ����� ������
;;;
;;;(setq #excel (vlax-get-object "Excel.Application"))
;;;(setq wkbs (vlax-get-property #excel "Workbooks"))
;;;(setq wb (vlax-get-property wkbs "Item" 1))
;;;(setq ash (vlax-get-property wb "ActiveSheet"))
;;;(setq range (vlax-get-property ash "UsedRange"))
;;;
;;;(car (vlax-safearray->list (vlax-variant-value (vlax-get-property range "Value2"))))
;;;
;;;(setq region (vlax-get-property range "CurrentRegion"))
;;;
;;;(do range)
;;;
;;;
;;;(vlax-get-property ash "Evaluate")


;;;; ���� ��� ����� �� ����� ������, ���� ������� � ����

;; ctrl+C � excel'�
;; ������� � �����
;; ����������
;; ��������� ��������������
;; ���������� ������ ������






;;;; �������� PT PI
;;;    13_05_16
;;;    13_11_05

;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\spclib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
;(load (strcat #lisppath "DATA-Tables\\ziplist.LSP"))

;(load (strcat #lisppath "MATH\\math-fix.LSP"))
(load (strcat #lisppath "DataBase\\dblib.LSP"))
(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))


(load (strcat #lisppath "DRAWING\\specification\\_2 ��������\\����\\gen-komplekt-jumas.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\_2 ��������\\gen-zakaz-zavod-P.LSP"))

;(load (strcat #lisppath "DRAWING\\specification\\_2 ��������\\APLISENS\\gen-komplekt-APC-2000ALW.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\_2 ��������\\APLISENS\\APC-2000ALW-presetted.LSP"))


;(setq xls-head (mapcar 'vla-get-textstring (ss->lsto (ssget))))
;(setq xls-head (mapcar 'vla-get-textstring (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "*TEXT"))) "x"))))
;(setq xls-data (mapcarx vla-get-textstring nil (ss->tbl (ssget))))
;(length xls-data)


;;;(formatstrings-for-encount)
;;;(getxlsdata)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; �������� ����� �� nil
;;;(setq data (mapcar '(lambda (line) (mapcar '(lambda (x)
;;;					      (if (= "#" x)
;;;						nil
;;;						x
;;;						)
;;;					      ) line))xls-data))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;



;;; �������� ��������������� ��
;;; 1 func
;;; 2 �����
;;; 3 KKS


;;  1-� ����
;(setq xls-data (excel>tbl)) (setq xls-head (car xls-data) data (xls|formatdata (cdr xls-data)))
; �����������
;(setq xls-data (excel>tbl))
;(setq data (xls|formatdata xls-data))



;; 2-� ����
(setq xls-head (car (excel>lst)))
;(setq data (DB|FORMATDATA (excel>lst)))
(setq data (db|formatdata (excel>lst)))




(setq datazipped
  (ziplist (mapcar '(lambda (xlsline) (list (xlsgpar "meas_name" xlsline) xlsline)) data))
  )

;(setq db:head xls-head)
;(db|mapzip (append '("table") data) "meas_name")


(setq datazipped2
       (mapcar
	 ;(setq name (nth 8 datazipped))
	 '(lambda (name)
	    (list
	      (car name)
	      (ziplist
		(mapcar
		  '(lambda (dat)
		     (list
		       (xlsgpar "��������" dat)
		       dat
		     )
		   )
		  (cdr name)
		)
	      )
	    )
	  )
	 datazipped
       )
)

;(cdr (db|mapzip (db|mapzip (append '("table") data) "meas_name") "��������"))




;(setq paragdata (nth 22 datazipped2))
;;;'("�������� �� ������ ������������ ������ �2"
;;;  (("AP�-2000ALW" xlsline xlsline)
;;;   ("�����" xlsline)
;;;   ("��100�" xlsline))
;;; )
(defun gen-paragraf (paragdata / grafaname tail)
  (setq tail (cadr paragdata))
  ;(setq grafaname (strcat (car paragdata) " " (rtos* (atof* (xlsgpar "nom_val" (cadar tail)))) "\\~"(xlsgpar "units" (cadar tail))))
  ;(spc|gsfxl "meas_name" "," (mapcar 'cadr (cadr paragdata)))
  ;(spc|gsfxl2 "meas_name" (mapcar 'cadr (cadr paragdata)))		2014_02_28
  (setq
    grafaname
     (spc|gsfxl3
       '("meas_name" "nom_val" "units")
       '(", " "\\~" "\n")
       (mapcar 'cadr (cadr paragdata))
       ))
     
  (append
    (list
      (list "" grafaname)
      (list "")
      )
  (apply
    'append
    (mapcar
      ;(setq proto (cadr tail))
      '(lambda (proto)
	 (cond
	   ((= "AP�-2000ALW" (car proto))
	    (gen-zakaz-APC2000ALW (cdr proto))		;;;; ����� ������ ��������
	    )
	   ((= "���" (car proto))
	    (gen-zakaz-jumas-EKM (cdr proto))		;;;; ����� ������ ��������
	    )
	   ((= "��100�" (car proto))
	    (gen-zakaz-jumas (cdr proto))		;;;; ����� ������ ��������
	    )
	   ((= "���100�" (car proto))
	    (gen-zakaz-jumas-MVP (cdr proto))		;;;; ����� ������ ��������
	    )
	   
	   ((= "�����" (car proto))
	    (gen-zakaz-zavod-P (cdr proto))		;;;; ����� ������ ��������
	    )
	   )
	 )
      tail
      )
    )
  )
  );defun






;;;
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;      ���    ��������    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;   ��������� ������ ����� ������������   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(setq
;;;  #spclist9stringsparamlist
;;;   '(
;;;     (("object" "MTEXT")("dpt" '( 0.8 -3 0))("attch" 1)("width" 18.4))  ;��� ��������
;;;     ;(("object" "TEXT") ("dpt" '( 10 -4 0))) ;��� �����������
;;;     (("object" "MTEXT")("dpt" '( 22 -3 0))("attch" 1)("width" 126))
;;;     (("object" "MTEXT")("dpt" '( 152 -3 0))("attch" 1)("width" 56))
;;;     (("object" "TEXT")("dpt" '( 227.5 -4 0)))
;;;     (("object" "MTEXT")("dpt" '( 247 -3 0))("attch" 2)("width" 41))
;;;     (("object" "TEXT")("dpt" '( 300 -4 0)))
;;;     (("object" "TEXT")("dpt" '( 320 -4 0)))
;;;     (("object" "TEXT")("dpt" '( 342.5 -4 0)))
;;;     (("object" "MTEXT")("dpt" '( 357 -3 0))("attch" 1)("width" 36))
;;;     )
;;;  );spctblparamlist
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;
;;;
;;;
;;;
;;;;(add-grapha (getpoint) (nth 3 (gen-paragraf pardata)))
;;;;(add-grapha (getpoint) (nth 4 parstr))
;;;;(setq list9strings (nth 3 (gen-paragraf pardata)))
;;;;(setq pt (getpoint))
;;;(defun add-grapha (pt list9strings / txtobj maxheight cpt)
;;;  (setq cpt pt)
;;;  (setq maxheight '())
;;;  ;(setq p (nth 4 #spclist9stringsparamlist))
;;;  (mapcar '(lambda (x p)
;;;	     ;(setq x (cadr list9strings))
;;;	     ;(setq p (cadr #spclist9stringsparamlist))
;;;     (cond
;;;       ((= "MTEXT" (cadr (assoc "object" p)))
;;;	(progn
;;;	  (setq txtobj (vla-AddMtext #modspace (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))) (cadr (assoc "width" p)) x))
;;;	  (vla-put-AttachmentPoint txtobj (cadr (assoc "attch" p)))
;;;	  (vla-put-LineSpacingStyle txtobj acLineSpacingStyleExactly)
;;;	  (vla-put-Height txtobj 2.5)
;;;	  (vla-put-LineSpacingDistance txtobj 8)
;;;	  (setq maxheight (append maxheight (list (mtxt:getnumberoflines txtobj))))
;;;	  );progn
;;;	)
;;;       ((= "TEXT" (cadr (assoc "object" p)))
;;;	(progn
;;;	  (setq txtobj (vla-Addtext #modspace x (vlax-3d-point '(0 0 0)) 2.5))
;;;	  (vla-put-Alignment txtobj 10)
;;;	  (vla-put-TextAlignmentPoint txtobj (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))))
;;;	  );progn
;;;	);1
;;;       )
;;;	     )
;;;	  list9strings			;x
;;;	  #spclist9stringsparamlist	;p
;;;	  )
;;;  ; � ������ ����� ������� ��������� �����
;;;  (mapcar '- cpt (list 0 (* 8 (1+ (apply 'max maxheight))) 0))
;;;  );defun
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;(setq pt (getpoint))
;;;
;;;
;;;
;;;;(addparagraph (getpoint) (gen-paragraf (nth 8 datazipped2)))
;;;;;;(defun addparagraph (pt parstr / cpt)
;;;;;;  (setq cpt pt)
;;;;;;  (mapcar '(lambda (grafa / nl)
;;;;;;	     (setq cpt (add-grapha cpt grafa))
;;;;;;	     )
;;;;;;	  parstr)
;;;;;;  ;(mapcar '- cpt (list 0 8 0))   ;;; - ������� �  addgrafa
;;;;;;  cpt
;;;;;;  )
;;;


;#list_cpt
;(setq parstr paragdata)
(defun addparagraph3 (pt parstr / cpt)
  (setq cpt pt)
  (mapcar
    '(lambda (grafa / nl)
       ;(setq cpt (add-grapha cpt grafa))
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
  ;cpt
  ;14_02_27
  (mapcar '+ cpt '(0 -8 0))
  );defun


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;   ���������� �������  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;(defun addpodrazdel2 (listforgendat / cpt list_cpt)
;;;  (setq cpt (getpoint)
;;;	list_cpt cpt)
;;;
;;;  ;(setq pardata (nth 0 listforgendat))
;;;  (mapcar '(lambda (pardata /)
;;;	     (setq cpt (addparagraph cpt (gen-paragraf pardata)))
;;;	     ;������� ���������� ��� ���������� �� �����
;;;	     (if (>= (- (cadr list_cpt) (cadr cpt)) 192)
;;;	       (progn
;;;		 (setq cpt (mapcar '+ cpt '(0 -120 0))
;;;		       list_cpt cpt)
;;;		 (vla-addline #modspace
;;;		   (vlax-3d-point cpt)
;;;		   (vlax-3d-point (mapcar '+ cpt '(-100 0 0)))
;;;		   )
;;;		 )
;;;	       )
;;;	     )
;;;	  listforgendat)
;;;  );defun





(defun addpodrazdel3 (listforgendat / cpt )
  (setq cpt (getpoint)
	#list_cpt cpt)
  ;(setq pardata (nth 0 listforgendat))
  (mapcar '(lambda (pardata /)
	     (setq cpt (addparagraph3 cpt (gen-paragraf pardata)))
	     )
	  listforgendat)
  );defun
;(addparagraph (getpoint) (gen-paragraf pardata))







(addpodrazdel3 datazipped2)

;;;
;;;
;;;
;;;(defun phis|m->kpa (m)
;;;  (* 9.8 m)
;;;  )
;;;(phis|m->kpa 255)
;;;
;;;



;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . ""))))
;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . " "))))