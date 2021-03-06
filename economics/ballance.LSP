;14_05_06
(vl-load-com)
(setq #cad (vlax-get-acad-object)
      #actdoc (vla-get-activedocument #cad)
      #modspace (vla-get-modelspace #actdoc))
(setq
  #blockarrowpaths
   (list
     (list "podolinsky" (strcat #lisppath "!blocking\\arrow.dwg"))
     (list (getenv "USERNAME") "\\\\srv-energo\\acad\\\\!_��������\\Blocks\\arrow.dwg")
     )
  )
(setq comp (getenv "USERNAME"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;		����������
;1. ������ ����� ������
;2. ������ �������� ���� :
;	�����������->AutoLISP->�������� LISP
;3. ������ ���������� [����] ����
;4. ������ ���������� ������ ����� � �������������, ����� ��� ��� ��������
;5. ������� ���� : [� ��������� LISP]
;	������ (Tools) - ��������� ����� � �������� (Load text in editor)
;6. ��������� �������� ������� ����� � �������, � ������� ��� ������� ������
;6.1 ��� ������ ������� ����� ������������ �� ���� ����� - ��� ������ ������� 10 ������
;7. ����� ��������� ��������� �������� , ��� �������
;8. ����� ������������� ������� � ������� �������� �����, �������� ��������� �������� (��. ��. 5,6)
;8.1 ���������� ������� ��������� ������ ������������� ����� � ����������, �������� ����� ������� �� ����� ��� � 
;	- ��� ���� ����������� �������� 2 ������ �� ��������� ����� �������������� �����




;	�������� ������ : ���� 2 ������ - 1 � �����������, 2 - � ��������
;	���� ������ -���� ������ ��� (������ ��� ��������) - ��
;	� ��������������� ���������� ���� : %BLRdeposit ��� %USDdeposit ������ 0
;	������������� ����� �������� ��������� ���������� %bel - ����� ����� ������ �������� �������� � ���. ������

;	���� � ��������� ���� �������� transaction = 60 000 = �������������� ����������� �������



;;   ����� ������������� �������
(setq totalcapital 340000000.0) ; ��� ���

;;  ���� �� ����� �������� �� ������ � ������
;(setq %bel 0.9)
;(setq %bel (/ (* (- (/ totalcapital 10000) 10000) 10000) totalcapital) )
(setq %bel 0.01)


;���� ����� �� 14_04_20
(setq startBLR/USD 9980.0)
(setq rostBLR/USD 3.5)		; ������� ������� ����� ������� - ���. ���. � ����
;�������� �� %bel � ��� ����
(setq startBLRcapital (* totalcapital %bel))
;�������� �� %bel � USD ���� �� �����
(setq startUSDcapital (/ (* totalcapital (- 1 %bel)) startBLR/USD))


;;  �������� �� ���������
(setq %BLRdeposit 38.0)	; % �������
(setq %USDdeposit 5.5)	; % �������


;;  ��������� ������	[<���> 	<������-����> 	<���������-����>]
(setq Xrange '(		1 	1 		90)) ; day	= 3 ������
;; PS ��� ��� �� ���� ������� �������� ���� ������ ����, �� �������� - ��� = 1 ����
















;(setq square 93.8)
;(setq cost/M 10826794)
;(setq totalcost)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun calculate (Xrange
		  /
		  date
		  $cBLR/USD
		  $cUSDcap $cBLRcap
		  $cBLRcap/USD
		  $summUSD
		  transaction
		  res
		  )
  (setq $cUSDcap startUSDcapital)
  (setq $cBLRcap startBLRcapital)
  (setq $cBLR/USD startBLR/USD)
  (setq date (cadr Xrange))
  ; ���� ��������� ����
  (while (<= date (caddr Xrange))
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; ����������� �������;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (cond
      ((= 25 date)
       (setq transaction 60000000)
       (setq $cUSDcap (- $cUSDcap (/ transaction $cBLR/USD)))
       (setq $cBLRcap (+ $cBLRcap transaction))
       (setq $cBLRcap (- $cBLRcap transaction))
       (setq transaction nil)
       )
      ((= 55 date)
       (setq transaction 60000000)
       (setq $cUSDcap (- $cUSDcap (/ transaction $cBLR/USD)))
       (setq $cBLRcap (+ $cBLRcap transaction))
       (setq $cBLRcap (- $cBLRcap transaction))
       (setq transaction nil)
       )
      ((= 85 date)
       (setq transaction 60000000)
       (setq $cUSDcap (- $cUSDcap (/ transaction $cBLR/USD)))
       (setq $cBLRcap (+ $cBLRcap transaction))
       (setq $cBLRcap (- $cBLRcap transaction))
       (setq transaction nil)
       )
      )

    ;; ������� ����� � ����
    (setq $cBLR/USD (+ $cBLR/USD rostBLR/USD))
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;		���������� ��������� �� % � �����
    (setq $cUSDcap (+ $cUSDcap (/ (/ (* $cUSDcap %USDdeposit) 100) 365)))
    (setq $cBLRcap (+ $cBLRcap (/ (/ (* $cBLRcap %BLRdeposit) 100) 365)))
    (setq $cBLRcap/USD (/ $cBLRcap $cBLR/USD))
    (setq $summUSD (+ $cUSDcap $cBLRcap/USD))
    (setq res (append res (list (list
				  (cons "date"  date)
				  (cons "$cBLR/USD"  $cBLR/USD)
				  (cons "$cBLRcap"  $cBLRcap)
				  (cons "$cUSDcap"  $cUSDcap)
				  (cons "$cBLRcap/USD" $cBLRcap/USD)
				  (cons "$summUSD" $summUSD)
				  ))))
    
    (setq date (+ date (car Xrange)))
    )
  ;;  ������ :  [���� ������ ������� ��������]
  res
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun drawbase (/ Xmax Xmin Ymax Ymin obj layer)
  (setq layer (vla-add (vla-get-Layers #actdoc) "Axes"))
  (setq Xmax (* 1.4 (apply 'max (cons 1 (mapcar 'car #baserange)))))
  (setq Xmin (* 1.4 (apply 'min (cons -1 (mapcar 'car #baserange)))))
  (setq Ymax (* 1.4 (apply 'max (cons 1 (mapcar 'cadr #baserange)))))
  (setq Ymin (* 1.4 (apply 'min (cons -1 (mapcar 'cadr #baserange)))))
  
  (setq obj (vla-addline #modspace
    (vlax-3d-point (mapcar '+ #ptbase (list Xmin 0 0)))
    (vlax-3d-point (mapcar '+ #ptbase (list Xmax 0 0)))
    )) (vlax-put-property obj "color" 250)
  (setq obj (vla-InsertBlock #modspace
    (vlax-3d-point (mapcar '+ #ptbase (list Xmax 0 0)))
	      (cadr (assoc comp #blockarrowpaths))
	      1 1 1 0)) (vlax-put-property obj "color" 250)
  (setq obj (vla-addline #modspace
    (vlax-3d-point (mapcar '+ #ptbase (list 0 Ymin 0)))
    (vlax-3d-point (mapcar '+ #ptbase (list 0 Ymax 0)))
    )) (vlax-put-property obj "color" 250)
  (setq obj (vla-InsertBlock #modspace
    (vlax-3d-point (mapcar '+ #ptbase (list 0 Ymax 0)))
	      (cadr (assoc comp #blockarrowpaths))
	      1 1 1 (* pi 0.5))) (vlax-put-property obj "color" 250)
  (setq #baserange nil)
  (vla-addtext #modspace (strcat "BLR: " (rtos startBLRcapital)) (vlax-3d-point #ptbase) 1.0)
  (vla-addtext #modspace (strcat "USD: " (rtos startUSDcapital)) (vlax-3d-point (mapcar '+ '(0 -2 0) #ptbase)) 1.0)
  );defun

(defun drawgraph (2Ddatarange color message / obj ptdata fitPoints startTan endTan osm pts i)
  (setq osm (getvar "OSMODE")) (setvar "OSMODE" 0)
  ;(setq 2Ddatarange '((1 10 )(2 15)(3 20)))
  (setq startTan (vlax-3d-point 0 0 0) endTan (vlax-3d-point 0 0 0))
  (setq ptdata (apply 'append (mapcar '(lambda (p) (mapcar '+ #ptbase (append p '(0.0)))) 2Ddatarange)))
  ;(setq fitPoints (vlax-make-safearray vlax-vbDouble (cons 0  (1- (length ptdata)))))
  ;(vlax-safearray-fill fitPoints ptdata)
  ;(setq obj (vla-AddSpline #modspace fitPoints startTan endTan))
  ;(vlax-put-property obj "color" color)
  (setq pts (mapcar '(lambda (p) (mapcar '+ #ptbase p)) 2Ddatarange) i 1)
  (repeat (1- (length pts))
    (setq obj (vla-addline #modspace (vlax-3d-point (nth (1- i) pts)) (vlax-3d-point (nth i pts))))
    (setq i (1+ i))
    (vlax-put-property obj "color" color)
    )
  (setq obj (vla-addtext #modspace message (vlax-3d-point (mapcar '+ '(5 0 0) (reverse (list (nth 0 (reverse ptdata)) (nth 1 (reverse ptdata)) (nth 2 (reverse ptdata)))))) 1))
  (vlax-put-property obj "color" color)
  (setq obj (vla-addtext #modspace (rtos (cadr (last 2Ddatarange)) 2 1) (vlax-3d-point (mapcar '+ #ptbase (last 2Ddatarange)))1.0))
  (vlax-put-property obj "color" color)
  (setq obj (vla-addtext #modspace (rtos (cadr (car 2Ddatarange)) 2 2) (vlax-3d-point (mapcar '+ #ptbase (car 2Ddatarange)))1.0))
  (vlax-put-property obj "color" color)
  (setvar "OSMODE" osm)
  );defun

(defun scale (2Ddatarange sc / res)
  (setq res (mapcar '(lambda (x) (list (car x) (* (cadr x) sc))) 2Ddatarange))
  (setq #baserange (append #baserange res))
  res
  )



(setq #ptbase (getpoint))
(setq $data (calculate Xrange))
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$cBLR/USD" x)))) $data) 0.001) 256 "currency [���/$]")
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$cBLRcap" x)))) $data) 0.000001) 133 "blr [���]")
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$cBLRcap/USD" x)))) $data) 0.001) 4 "blrcap/USD [���]")
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$cUSDcap" x)))) $data) 0.001) 71 "USD [���]")
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$summUSD" x)))) $data) 0.001) 3 "��������� ������� � ��������� �� USD [���]")
(drawbase) 







(defun  graph%bel (/ %belrange %bel startBLRcapital startUSDcapital $$data)
  (setq $$data nil)
  (setq %belrange '(0.05 0 1))
  (setq %bel (cadr %belrange))
  (while (<= %bel (caddr %belrange))
    (setq startBLRcapital (* totalcapital %bel))
    (setq startUSDcapital (/ (* totalcapital (- 1 %bel)) startBLR/USD))
    (setq $$data (append $$data (list (list (cons "%bel" %bel) (assoc "$summUSD" (last (calculate Xrange)))))))
    (setq %bel (+ %bel (car %belrange)))
    )
  (setq #ptbase (getpoint))
  (drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "%bel" x)) (cdr (assoc "$summUSD" x)))) $$data) 0.001) 3 "��������� ������� � ��������� �� USD [���]")
  (drawbase) 
  );defun