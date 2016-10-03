;;;  14_12_19
;;;  �������� ���������� �� ����� ���.xls
;;;  � ������� �������������� �������� �� ������ FM_tbl



(setq db (db|formatdata (excel>lst)))
(setq brefs (mapcar 'vlax-ename->vla-object (ss->sortedlst (ssget '((0 . "INSERT"))) "x")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ��� �������� ������� - ������, ������� � �.�.
(setq dbLT (tbl|filter db (strcat "FUNC=TIR")))
;(length dbLT)
(= (length brefs) (length (cdr dbLT)))


(mapcar
  '(lambda (line bref)
     (vla-put-TextString (getbatt bref "$KKS") (tbl|gpar (car db) line "POZ"))
     ;(vla-put-TextString (getbatt bref "$PROTOTYPE") (tbl|gpar (car db) line "PROTOTYPE"))
     (vla-put-TextString (getbatt bref "$PIDPLCE") (tbl|gpar (car db) line "NAME"))
     (vla-put-TextString (getbatt bref "$F_ASU") "���, �����������")
     
     )
  (cdr dbLT)
  brefs
  )


(mapcar
  '(lambda (line bref)
     (vla-put-TextString (getbatt bref "SIGNALNAME")
       (strcat
	 (tbl|gpar (car db) line "NAME")
	 "\\P���. "
	 (tbl|gpar (car db) line "POZ")
	 )
       )
     )
  (cdr dbLT)
  brefs
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ��� ������� ������� - ��������


(setq dbP (cons (car db) (vl-remove-if '(lambda (line) (null (member (tbl|gpar (car db) line "F_KIP") '("PT" "PI")))) (cdr db))))

;(length dbLT)
(= (length brefs) (length (cdr dbP)))

(mapcar
  '(lambda (line bref)
     (vla-put-TextString (getbatt bref "$KKS") (tbl|gpar (car db) line "KKS"))
     (vla-put-TextString (getbatt bref "$PROTOTYPE") (tbl|gpar (car db) line "PROTOTYPE"))
     (vla-put-TextString (getbatt bref "$PIDPLCE") (tbl|gpar (car db) line "meas_name"))
     (vla-put-TextString (getbatt bref "$F_ASU") "���/���")
     ;;;   ����� ���������
     )
  (cdr dbP)
  brefs
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;









      