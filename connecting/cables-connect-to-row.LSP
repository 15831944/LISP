;14_01_29

;; 1 �� ������� ��������� ������ � ����� cbl_cnct (�� ��� �� ������������ �� ����)
;; - ��� ����� ������, ���, ���������, ����� � ��� �� !!! ����� ���
;; 2 �������� ���� ���� ���������� � 
;; 3 �������� ����� ��� ������ ������ ����� ���������� ������ ��� ��������� ����������� ������


;(load (strcat #lisppath "connecting\\klength.LSP"))
;(clamp-content)

(setq ss (ssget '((0 . "INSERT"))))
(setq clambase
    (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x)
       '(
	 "wiring_STS-2.5"
	 "wiring_STS-2.5-PE"
	 "wiring_STS-2.5-MT"
	 "wiring_STS-2.5-TG"
	 "wiring_ST-4-HESI"
	 "wiring_ST-4-HEDI"
	 
	 "������_STS-2.5"
	 "������_ST4-HEDI"
	 "������_ST4-HESI"
	 )
   ))
  (ss->lsto* ss)
  ))




(setq cab (vlax-ename->vla-object (car (entsel))))
(setq marks (vl-remove-if '(lambda (x) (= "" x)) (mapcar 'vla-get-TextString (getbattswcmatch cab "*MARK*"))))
;;; ������� �������� �� ���������
(setq cabmarkbase
       (vl-remove-if-not
	 '(lambda (x)
	    (member
	      (vla-get-TextString (getbatt x "MARK"))
	      marks)
	    )
	 clambase
	 )
       )

(length cabmarkbase)
(sssetfirst nil (lst-to-ss cabmarkbase))












; ���������� �������� �� ���������


;;;(setq ss (ssget '((0 . "INSERT"))))
;;;(setq cabbase
;;;    (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x)
;;;       '(
;;;	 "cbl_cnct"
;;;	 )
;;;   ))
;;;  (ss->lsto* ss)
;;;  ))
;;;
;;;(mapcar
;;;  '(lambda (c / cm cores)
;;;     (setq cm (vl-remove-if '(lambda (x) (= "" x)) (mapcar 'vla-get-TextString (getbattswcmatch c "*MARK*"))))
;;;     (setq cores (atoi (vla-get-TextString (getbatt c "CORES"))))
;;;     (if
;;;       (< cores (length cm))
;;;       (princ (strcat (vla-get-TextString (getbatt c "NUMBER"))))
;;;       )
;;;     )
;;;  cabbase)
;;;
