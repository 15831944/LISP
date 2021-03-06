;	16_05_23

;;; ����� ��������� ������� � ������ ����� �� �����
;;; �� �������� ������� move-ent � move-pt
;;; �� ������� vl-cmdf "_zoom"
;;; ������������ �������� ��� 109

;;; 11_03_16
(load (strcat #lisppath "common functions/format-identification-gost.lsp"))
(load (strcat #lisppath "common functions/pe-select.LSP"))





;;; 13_05_15
;; `		������� ��� ������ format (���� - ������ ��� ������)
(defun c:ftsar ( / )
  (vla-startundomark #actdoc)
  (formats-arrange)
  (acet-error-restore)
  (vla-endundomark #actdoc)  
  );defun




(defun formats-arrange ( / offset lst bpt ang)
  (setq offset 5)
  (princ "\n Select items to arrange ....   \n")
  (setq lst (ss:getbrefs '("RU_format-spec")))
  (setq lst (vl-sort lst '(lambda (a b) (< (atoi (vla-get-TextString (getbatt a #DrwNumberTag))) (atoi (vla-get-TextString (getbatt b #DrwNumberTag)))))))
  (setq
	bpt (getpoint "\n������� ����� ������ ���������...")
	ang (getangle bpt "\n������� ���������� ����� ���������� � �����...")) ;(getorient bpt)
  
  (mapcar
    ;(setq frmt (car lst))
    '(lambda (frmt / frlst ptsrc tmp)
       (setq frlst (pe-select-inBound-bref frmt))
       ;(length frlst)
       (vla-GetBoundingBox frmt 'cblpt 'curpt)
       (setq cblpt (variantextraction cblpt))
       (setq curpt (variantextraction curpt))
       (cond
	 ((= ang (* (/ Pi 2) 0))
	  (setq bpt (polar bpt ang (+ offset (abs (- (car curpt) (car cblpt))))))
	  )
	 ((= ang (* (/ Pi 2) 1))
	  (setq bpt (polar bpt ang (+ offset (abs (- (cadr curpt) (cadr cblpt))))))
	  )
	 ((= ang (* (/ Pi 2) 2))
	  (setq bpt (polar bpt ang (+ offset (abs (- (car curpt) (car cblpt))))))
	  )
	 ((= ang (* (/ Pi 2) 3))
	  (setq bpt (polar bpt ang (+ offset (abs (- (cadr curpt) (cadr cblpt))))))
	  )
	 )
       (mapcar '(lambda (x) (vla-move x (vlax-3d-point cblpt) (vlax-3d-point bpt))) frlst)
       )
    lst)
  ;(vl-cmdf "_.zoom" "_e")
  );defun














(defun c:ftsar_old ()

  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0)
	  T))
  ;(vl-cmdf "_zoom" "all")
  (formats-arrange_old (get-kol-uch))
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun

;(setq lstkoluch (get-kol-uch))

;(get-formatpts<-rightformatline (get-rightformatline<-koluch (car (entsel))))
;(setq scale 1)
(defun formats-arrange_old (lstkoluch / lst  bpt p1 p2 drwwdth drwhght pa1 pa2  frlst delta)
  (setq delta 15)
  (setq scale (/ (cdr (assoc 40 (entget (car lstkoluch)))) 2.5))


;;;  (setq lst (mapcar '(lambda (x)
;;;		       (list
;;;			 (atof (get-lnumber x))
;;;			 (get-formatpts<-rightformatline (get-rightformatline<-koluch x))
;;;			 )
;;;		       ) lstkoluch))
 
  
  (setq lst (mapcar '(lambda (x / l)
		       (progn
			 (setq l (get-formatpts<-rightformatline (get-rightformatline<-koluch x)))
		       (list
			 (abs (- (cadr (cadr l)) (cadr (car l))))
			 l
			 )
		       )
		       ) lstkoluch))


  
  (setq lst (vl-sort lst '(lambda (a b) (< (car a) (car b)))))
  (setq bpt (getpoint))

  ;(setq drw (car lst))
  (foreach drw lst
    ;'(1 ((5 5 0)(10 10 0)))
    (setq p1 (car (cadr drw)))
    (setq p2 (cadr (cadr drw)))
    (setq drwhght (abs (- (cadr p1) (cadr p2))))	; ��� ������������� ����������
    ;(setq drwwdth (abs (- (car p2) (car p1))))		; ��� ��������������� ����������
    (setq pa1 (vlax-3d-point p1))
    (setq pa2 (vlax-3d-point bpt))
    (vl-cmdf "_.zoom" p1 p2)
    (setq frlst (ss->lsto* (ssget "_C" p1 p2)))
    (mapcar '(lambda (x)
	       (vla-move x pa1 pa2)
	       ) frlst)
    
    (setq bpt (list (car bpt) (- (cadr bpt) drwhght delta)))	; ��� ������������� ����������
    ;(setq bpt (list (+ (car bpt) drwwdth delta) (cadr bpt)))	; ��� ��������������� ����������
    )
  );defun




