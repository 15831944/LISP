;;; ������� ���������
;;; 13_05_20
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PPPPPSSS  ����� ������� � �����������

;;;; dPTL - APR
;;;    13_05_16

;(load (strcat #lisppath "DATA-Tables\\get-closer-from-.LSP"))
(load (strcat #lisppath "Excel\\tbl-to-excel.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\spclib.lsp"))
(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
(load (strcat #lisppath "DATA-Tables\\ziplist.LSP"))

;(load (strcat #lisppath "DRAWING\\specification\\_3 �������\\APLISENS\\gen-zakaz-APR-2000ALW.LSP"))
(load (strcat #lisppath "DRAWING\\specification\\_2 ��������\\APLISENS\\APR-2000ALW-presetted.LSP"))
(load (strcat #lisppath "MATH\\m-kpa.LSP"))






;;  1-� ����
;(setq xls-data (excel>tbl)) (setq xls-head (car xls-data) data (spc|mm->m (xls|formatdata (cdr xls-data))))
; �����������






;; 2-� ����
(setq xls-head (car (excel>lst)))
;(setq data (DB|FORMATDATA (excel>lst)))
(setq data (db|formatdata (excel>lst)))


(setq datazipped
  (ziplist
    (mapcar
     '(lambda (xlsline)
	(list
	  (xlsgpar "meas_name" xlsline)
	  xlsline
	  )
	)
     data)
    )
  )
;)




;(setq pardata (car datazipped))
;(gen-paragraf pardata)
(defun gen-paragraf (pardata / parname xlslinesdPTL)
  (setq xlslinesdPTL (cdr pardata))
  (setq parname (strcat (car pardata) " " (rtos* (atof* (xlsgpar "nom_val" (car xlslinesdPTL)))) " " (xlsgpar "units" (car xlslinesdPTL))))
  (append
    (list
      (list "" parname)
      (list "")
      )
    (cond
      ((= "APR-2000ALW" (xlsgpar "��������" (car xlslinesdPTL)))
       (gen-zakaz-APR2000ALW xlslinesdPTL)		;;;; ����� ������ ��������
       )
      )
    )

  );defun









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;      ���    ��������    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;   ��������� ������ ����� ������������   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
  #spclist9stringsparamlist
   '(
     (("object" "MTEXT")("dpt" '( 0.8 -3 0))("attch" 1)("width" 18.4))  ;��� ��������
     ;(("object" "TEXT") ("dpt" '( 10 -4 0))) ;��� �����������
     (("object" "MTEXT")("dpt" '( 22 -3 0))("attch" 1)("width" 126))
     (("object" "MTEXT")("dpt" '( 152 -3 0))("attch" 1)("width" 56))
     (("object" "TEXT")("dpt" '( 227.5 -4 0)))
     (("object" "MTEXT")("dpt" '( 247 -3 0))("attch" 2)("width" 41))
     (("object" "TEXT")("dpt" '( 300 -4 0)))
     (("object" "TEXT")("dpt" '( 320 -4 0)))
     (("object" "TEXT")("dpt" '( 342.5 -4 0)))
     (("object" "MTEXT")("dpt" '( 357 -3 0))("attch" 1)("width" 36))
     )
  );spctblparamlist
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;(add-grapha (getpoint) (nth 3 (gen-paragraf pardata)))
;(add-grapha (getpoint) (nth 4 parstr))
;(setq list9strings (nth 3 (gen-paragraf pardata)))
;(setq pt (getpoint))
(defun add-grapha (pt list9strings / txtobj maxheight cpt)
  (setq cpt pt)
  (setq maxheight '())
  ;(setq p (nth 4 #spclist9stringsparamlist))
  (mapcar '(lambda (x p)
	     ;(setq x (cadr list9strings))
	     ;(setq p (cadr #spclist9stringsparamlist))
   (if x
     (cond
       ((= "MTEXT" (cadr (assoc "object" p)))
	(progn
	  (setq txtobj (vla-AddMtext #modspace (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))) (cadr (assoc "width" p)) x))
	  (vla-put-AttachmentPoint txtobj (cadr (assoc "attch" p)))
	  (vla-put-LineSpacingStyle txtobj acLineSpacingStyleExactly)
	  (vla-put-Height txtobj 2.5)
	  (vla-put-LineSpacingDistance txtobj 8)
	  (setq maxheight (append maxheight (list (mtxt:getnumberoflines txtobj))))
	  );progn
	)
       ((= "TEXT" (cadr (assoc "object" p)))
	(progn
	  (setq txtobj (vla-Addtext #modspace x (vlax-3d-point '(0 0 0)) 2.5))
	  (vla-put-Alignment txtobj 10)
	  (vla-put-TextAlignmentPoint txtobj (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" p))))))
	  );progn
	);1
       )
     )
    )
	  list9strings			;x
	  #spclist9stringsparamlist	;p
	  )
  ; � ������ ����� ������� ��������� �����
  (mapcar '- cpt (list 0 (* 8 (eval (append '(max) maxheight))) 0))
  ;(mapcar '- cpt (list 0 (* 8 (1+ (eval (append '(max) maxheight)))) 0))
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq pt (getpoint))



;(addparagraph (getpoint) (gen-paragraf (nth 8 datazipped2)))
;;;(defun addparagraph (pt parstr / cpt)
;;;  (setq cpt pt)
;;;  (mapcar '(lambda (grafa / nl)
;;;	     (setq cpt (add-grapha cpt grafa))
;;;	     )
;;;	  parstr)
;;;  ;(mapcar '- cpt (list 0 8 0))   ;;; - ������� �  addgrafa
;;;  cpt
;;;  )



;#list_cpt
(defun addparagraph3 (pt parstr / cpt)
  (setq cpt pt)
  (mapcar
    '(lambda (grafa / nl)
	     (setq cpt (add-grapha cpt grafa))
	     ;������� ���������� ��� ���������� �� �����
	     (if (>= (- (cadr #list_cpt) (cadr cpt)) 192 )
	       (progn
		 (setq cpt (mapcar '+ cpt '(0 -120 0))
		       #list_cpt cpt)
		 (vla-addline #modspace
		   (vlax-3d-point cpt)
		   (vlax-3d-point (mapcar '+ cpt '(-100 0 0)))
		   )
		 )
	       )
	     )
    parstr
    )
  cpt
  )


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





;(setq listforgendat datazipped)
(defun addpodrazdel3 (datazipped / cpt )
  (setq cpt (getpoint)
	#list_cpt cpt)
  ;(setq pardata (nth 4 listforgendat))
  (mapcar '(lambda (pardata /)
	     ;(setq pardata (car datazipped))
	     (setq cpt (addparagraph3 cpt (gen-paragraf pardata)))
	     )
	  datazipped)
  );defun
;(addparagraph (getpoint) (gen-paragraf pardata))







  (addpodrazdel3 datazipped)








;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . ""))))
;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . " "))))