(defun getbatt (
		 bobj
		 tag
		 /
		 al
		 )
  (if
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (< 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al))
      )
    (car (vl-remove-if-not '(lambda (x) (= tag (vla-get-tagstring x))) al))
    )
  );defun

;(getbatt (vlax-ename->vla-object (car (entsel))) "CHAN3")

;;; �������� ss ����� 1
;;;=======================================================================================
(defun ss-odd (
	       /
	       lst
	       ss
	       i
	       )
  (setq lst (ss->list (ssget))	
	i 0
	ss (ssadd))
  (repeat (/ (length lst) 2)
    (setq ss (ssadd (nth i lst) ss))
    (setq i (+ i 2))
    )
  (sssetfirst nil ss)
  )
;;;=======================================================================================




;;; ���������� ������� ������
(defun cols-to-array (nkol
		      /
		      main
		      i
		      )
  (setq main '()
	i 1)
  (repeat nkol
    (alert (strcat "��������� ������� N " (itoa i)))
    (setq main (append main (list (mapcar '(lambda (x) (cdr (assoc 1 (entget x)))) (ss->list (ssget))))))
    (princ (strcat "\n !!!!!!!!!!!!!!!!!!!!!!!!!     ������� " (itoa (length (reverse (car main)))) " ��������   !!!!!!!!!!!!!!!\n"))
    (setq i (1+ i))
    )
  (matrix-trans main)
  );defun
;;; �� �� ������ � ���������
(defun objs-to-array (nkol
		      /
		      main
		      )
  (setq main '())
  (repeat nkol
    (alert "��������� ������� ��������")
    (setq main (append main (list  (mapcar 'vlax-ename->vla-object (ss->list (ssget))))))
    (princ "\n !!!!!!!!!!!!!!!!!!!!!!!!!     ��������� �����           !!!!!!!!!!!!!!!\n")
    )
  (matrix-trans main)
  );defun

;;; ���������� ������ ������� �� �������� � ������������� ������ - �������
(defun matrix-trans (lst
		     /
		     i
		     lsto
		     )
  (setq lsto '()
	i 0)
  (repeat (length (car lst))
    (setq lsto (append lsto (list (mapcar '(lambda (x) (nth i x)) lst))))
    (setq i (1+ i))
    );repeat
  lsto
  );defun
;;; ���� ������ ((1 �) (1 �) (1 �) (2 �) (2 �) (3 �))
;;; ����� ������ ���������
;;; ((1 � � �) (2 � �) (3 �))
;bpfill
(load (strcat #lisppath "DATA-Tables/ziplist.lsp"))


;entsel 1 ����� (����� ������) -> ssget ������ � ������� �� ��� ��� ���� ������
(defun associng (
		 /
		 obj
		 ss
		 lst
		 )
  (while (setq obj (entsel "\nSelect assoc object..."))
    (setq obj (vlax-ename->vla-object (car obj)))
    (setq ss (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "*TEXT"))))))
    (setq lst (append lst (list (append (list obj) ss))))
    )
  lst
  );defun


(setq lst (associng))
(mapcar 'vla-get-TextString lst)

(defun mapcarx (func
		arg
		lst
		/
		)
  (if (= 'list (type lst))
    (mapcar '(lambda (x) (mapcarx func arg x)) lst)
    (if arg
      (func lst arg)
      (func lst)
      )
    );if
  );defun
(mapcarx vla-get-TextString nil lst)

;;;
;;;
;;;(defun map (func arg lst)
;;;  (mapcar
;;;    '(lambda (x)
;;;       (mapcar
;;;	 '(lambda (y)
;;;	    (if arg
;;;	      (func y arg)
;;;	      (func y)
;;;	      )
;;;	    )
;;;	 x
;;;	 )
;;;       )
;;;    lst
;;;    )
;;;  );defun
;;;
;;;(setq cab (map vla-get-TextString  nil (associng)))
;;;    
;;;
;;;









;;;(setq bpfill (cols-to-array 2))
;;;(setq bpfill (ziplist bpfill))
;;;(setq bpfill '(("UG18" "����� 3N-�� � 1" "����� 3N-�� � 17" "����� 3N-�� � 17") ("UG20" "����� 3N-�� � 1" "����� 3N-�� � 20" "����� 3N-�� � 20") ("UG35" "����� 3N-�� � 1" "����� 3N-�� � 25") ("UG1" "����� 3N-�� � 3" "����� 3N-�� � 3") ("UG2" "����� 3N-�� � 4" "����� 3N-�� � 4") ("UG30" "����� 3N-�� � 5" "����� 3N-�� � 8" "����� 3N-�� � 10" "����� 3N-�� � 22") ("UG36" "����� 3N-�� � 5" "����� 3N-�� � 8" "����� 3N-�� � 25") ("UG37" "����� 3N-�� � 5" "����� 3N-�� � 8" "����� 3N-�� � 25") ("UG38" "����� 3N-�� � 5" "����� 3N-�� � 8" "����� 3N-�� � 25") ("UG3" "����� 3N-�� � 6" "����� 3N-�� � 6" "����� 3N-�� � 6") ("UG4" "����� 3N-�� � 7" "����� 3N-�� � 7" "����� 3N-�� � 7") ("UG5" "����� 3N-�� � 8" "����� 3N-�� � 9" "����� 3N-�� � 10") ("UG24" "����� 3N-�� � 8" "����� 3N-�� � 22" "����� 3N-�� � 22") ("UG6" "����� 3N-�� � 10" "����� 3N-�� � 10" "����� 3N-�� � 10") ("UG8" "����� 3N-�� � 10" "����� 3N-�� � 10" "����� 3N-�� � 10") ("UG7" "����� 3N-�� � 11" "����� 3N-�� � 11" "����� 3N-�� � 11") ("UG9" "����� 3N-�� � 11" "����� 3N-�� � 11" "����� 3N-�� � 11") ("UG12" "����� 3N-�� � 12" "����� 3N-�� � 12" "����� 3N-�� � 12") ("UG13" "����� 3N-�� � 12" "����� 3N-�� � 12" "����� 3N-�� � 12") ("UG15" "����� 3N-�� � 13" "����� 3N-�� � 14") ("UG22" "����� 3N-�� � 13" "����� 3N-�� � 14") ("UG31" "����� 3N-�� � 13" "����� 3N-�� � 14" "����� 3N-�� � 23" "����� 3N-�� � 24") ("UG32" "����� 3N-�� � 13" "����� 3N-�� � 13" "����� 3N-�� � 14") ("UG11" "����� 3N-�� � 14" "����� 3N-�� � 14" "����� 3N-�� � 16" "����� 3N-�� � 16") ("UG14" "����� 3N-�� � 14" "����� 3N-�� � 15") ("UG21" "����� 3N-�� � 15" "����� 3N-�� � 15") ("UG34" "����� 3N-�� � 15" "����� 3N-�� � 15") ("UG10" "����� 3N-�� � 16" "����� 3N-�� � 16" "����� 3N-�� � 16" "����� 3N-�� � 16") ("UG16" "����� 3N-�� � 16" "����� 3N-�� � 16") ("UG17" "����� 3N-�� � 16" "����� 3N-�� � 16" "����� 3N-�� � 16" "����� 3N-�� � 16") ("UG19" "����� 3N-�� � 18" "����� 3N-�� � 19") ("UG29" "����� 3N-�� � 18" "����� 3N-�� � 19") ("UG33" "����� 3N-�� � 20" "����� 3N-�� � 20") ("UG23" "����� 3N-�� � 21" "����� 3N-�� � 21" "����� 3N-�� � 21" "����� 3N-�� � 21")))
;;;(setq bpfill (vl-sort bpfill '(lambda (a b) (< (car a) (car b)))))






;;;(setq ovtabledata (cols-to-array 2))
;;;(setq data (cols-to-array 5))	;; poz, ename, rname
;;;
;;;;;; ������ � ������ �������
;;;(setq langdata (cols-to-array 5))	;; poz, ename, rname
;;;
;;;;;; ������ � ������� �������, �� �������������� � ������ ���������
;;;(setq clampdata (cols-to-array 2))	;; nkl, poz
;;;
;;;;;;(setq lst '((1 2 3)("A" "B" "C")))
;;;;;; ��������� ������ ����� ������� �� ���� ������� (������ ������������ ���� ������)
;;;(setq main '())
;;;(foreach line clampdata
;;;  (setq main (append main (list
;;;			    (append line (cdr (assoc (cadr line) langdata)))
;;;			    )))
;;;  )
;;;
;;;;;; ��������� �� ������� �������� �����
;;;(setq main
;;;       (vl-sort main '(lambda (a b)
;;;			(< (car a)
;;;			   (car b))))
;;;      )
;;;
;;;
;;;
;;;
;;;;(setq bl (vlax-ename->vla-object (car (entsel))))
;;;
;;;;;; �������� ������ �������� ����� �� ����
;;;(defun get-att (block
;;;		tag
;;;		/
;;;		aol
;;;		)
;;;  (setq aol (vlax-safearray->list (vlax-variant-value (vla-getAttributes block))))
;;;  (nth
;;;    (vl-position tag (mapcar 'vla-get-TagString aol))
;;;    aol)
;;;  );defun
;;;
;;;;;;(vlax-dump-Object
;;;;;;(get-att
;;;;;;  (vlax-ename->vla-object (car (entsel)))
;;;;;;  "NKL"
;;;;;;  ))
;;;
;;;
;;;
;;;
;;; ��������� ����� ������
;; �� �� ���� ���? :(
;;;(defun fill (
;;;	     /
;;;	     blks
;;;	     i
;;;	     )
;;;  (setq blks (mapcar 'vlax-ename->vla-object (ss->list (ssget)))
;;;	i 0)
;;;  (foreach bl blks
;;;    (vla-put-TextString (get-att bl "NKL") (nth 0 (nth i main)))
;;;    (vla-put-TextString (get-att bl "POZ") (nth 1 (nth i main)))
;;;    (vla-put-TextString (get-att bl "ENAME") (nth 2 (nth i main)))
;;;    (vla-put-TextString (get-att bl "RNAME") (nth 3 (nth i main)))
;;;    (setq i (1+ i))
;;;    )
;;;  );defun





;;;(setq cabdata (cols-to-array 4))
;;;
;;;
;;;;;; ���������� �������
;;;'(("cab58type" "1X01" "1X02" "dest63")
;;;  ("cab59type" "1X03" "1X04" "dest62")
;;;  ("cab60type" "1X05" "1X06" "dest61")
;;;  ("cab61type" "1X07" "1X08" "dest60")
;;;  )
;;;;;; � ������
;;;'(("cab58type" ("1X01" "1X02" "dest63"))
;;;  ("cab59type" ("1X03" "1X04" "dest62"))
;;;  ("cab60type" ("1X05" "1X06" "dest61"))
;;;  ("cab61type" ("1X07" "1X08" "dest60"))
;;;  )
;;;;;; ��� ����� ����� (compress-matrix lst 2 4)
;;;(defun compress-matrix (lst
;;;			strt
;;;			end
;;;			/
;;;			out
;;;			)
;;;  (setq out '())
;;;  (foreach line lst
;;;    
;;;
;;;
;;;
;;;
;;;
;;;
;;;    (setq i 0)
;;;    (repeat)
;;;    )
;;;  );defun
;;;
;;;
;;;
;;;("cab58type" "1X01" "1X02" "dest63")
;;;("cab58type" ("1X01" "1X02" "dest63"))
;;;
;;;(setq lst '("cab58type" "1X01" "1X02" "dest63"))
;;;
;;;(defun cline (line a b
;;;	      /
;;;	      out
;;;	      )
;;;  (setq out '())
;;;  );defun




;;;(setq ao (vlax-ename->vla-object (car (nentsel))))
;;;
;;;(vlax-dump-object (vlax-ename->vla-object (car (nentsel))))
;;;


;   LineSpacingDistance = 4.16667
;   LineSpacingFactor = 1.0
;   LineSpacingStyle = 1
;   LineSpacingDistance = 2.0
;   LineSpacingFactor = 0.48
;   LineSpacingStyle = 2


;;;(setq ss (ssget))
;;;(setq i 0)
;;;
;;;(repeat (sslength ss)
;;;    (setq o (get-att (vlax-ename->vla-object (ssname ss i)) "ENAME"))
;;;    (vla-put-LineSpacingFactor o 0.6)
;;;    (setq o (get-att (vlax-ename->vla-object (ssname ss i)) "RNAME"))
;;;    (vla-put-LineSpacingFactor o 0.6)
;;;    (setq i (1+ i))
;;;    )






;;;(setq langdata (cols-to-array 3))	;; poz, eaddr, raddr
;;;(setq kabdata (cols-to-array 3))	;; poz, num, type
;;;(setq kl-poz (cols-to-array 2))		;; nkl, poz
;;;
;;;
;;;(setq main '())				;nkl, num, type, eaddr, raddr
;;;(foreach line kl-poz
;;;  (setq main (append main (list
;;;                              (list
;;;                              (car line)
;;;                              (cadr (assoc (cadr line) kabdata))
;;;                              (caddr (assoc (cadr line) kabdata))
;;;                              (cadr (assoc (cadr line) langdata))
;;;                              (caddr (assoc (cadr line) langdata))
;;;                              )
;;;                              )))
;;;    )

;;; ��������� �� ������� �������� �����
;;;(setq main
;;;       (vl-sort main '(lambda (a b)
;;;			(< (car a)
;;;			   (car b))))
;;;      )
;;;



;;;    main   -    nkl, num, type, eaddr, raddr
;;;(defun fillcab(
;;;	     /
;;;	     blks
;;;	     i
;;;	     )
;;;  (setq blks (mapcar 'vlax-ename->vla-object (ss->list (ssget)))
;;;	i 0)
;;;  (foreach bl blks
;;;    (vla-put-TextString (get-att bl "NUM") (nth 1 (nth i main)))
;;;    (vla-put-TextString (get-att bl "TYPE") (nth 2 (nth i main)))
;;;    (vla-put-TextString (get-att bl "EADDR") (nth 3 (nth i main)))
;;;    (vla-put-TextString (get-att bl "RADDR") (nth 4 (nth i main)))
;;;    (setq i (1+ i))
;;;    )
;;;  );defun



;;; ������� ��������� ������� ������ ��������
(defun mtxtsetwidth (/)
  (setq ss (ssget '((0 . "MTEXT"))))
  (setq lomt (ss->list* ss))
  (setq lomt (mapcar 'vlax-ename->vla-object lomt))

  (foreach to lomt
    (setq txt (vla-get-TextString to))
    (setq txt (strcat "{\\W0.8;\\T0.9;" txt "}"))
    (vla-put-TextString to txt)
    (vla-put-LineSpacingFactor to 0.7)
  )
)
;;;****************************************************************************************************************
; ���� ���� ������ ���� (("����� �������" "������ �������" ...)...)
; �� ����� ������ � ����� ��� �� �������� �� ������� �� �����
;;;(setq chs (cols-to-array 2))	;; newpoz, oldpoz
;;;(defun fill-fsel(
;;;                 /
;;;                 blks
;;;                 att
;;;                 )
;;;  (setq blks (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT"))))))
;;;    (foreach bl blks
;;;        (setq att (get-att bl "�������"))
;;;        (vla-put-TextString att (cadr (assoc (vla-get-TextString att) chs)))
;;;        )
;;;  );defun

;;;****************************************************************************************************************
; �� �� ����� � ��������
;;;(defun fill-tsel(
;;;                 /
;;;                 txts
;;;		 tag
;;;                 at
;;;                 )
;;;  (setq txts (mapcar 'vlax-ename->vla-object (ss->list (ssget))))
;;;    (foreach txt txts
;;;      (setq tag (vla-get-TextString txt))
;;;      (if (setq at (assoc tag bpfill))
;;;	(vla-put-TextString txt (cadr at))
;;;	)
;;;      )
;;;  );defun

;;;(assoc (vla-get-TextString (vlax-ename->vla-object (car (entsel)))) bpfill)
;;;
;;;(ziplist (cols-to-array 2))















;11_06_04
;;;(setq data '(("UG1" "3NP169" "������" "3NP175" "3NP176") ("UG2" "3NP181" "3NP205" "������" "������") ("UG3" "3NP193" "3NP194" "3NP195" "������") ("UG4" "3NP196" "3NP197" "3NP198" "������") ("UG5" "3NP213" "3NP214" "3NP233" "������") ("UG6" "3NP221" "3NP222" "3NP223" "������") ("UG7" "3NP224" "3NP225" "3NP226" "������") ("UG8" "3NP234" "3NP235" "3NP236" "������") ("UG9" "3NP237" "3NP238" "3NP239" "������") ("UG10" "3NP246" "3NP247" "3NP248" "3NP249") ("UG11" "3NP250" "3NP251" "3NP268" "3NP269") ("UG12" "3NP258" "3NP259" "3NP260" "������") ("UG13" "3NP261" "3NP262" "3NP263" "������") ("UG14" "3NP264" "3NP265" "������" "������") ("UG15" "3NP270" "3NP271" "������" "������") ("UG16" "3NP272" "3NP273" "������" "������") ("UG17" "3NP274" "3NP275" "3NP276" "3NP277") ("UG18" "3NP278" "3NP318" "3NP170" "������") ("UG19" "3NF280" "3NF281" "������" "������") ("UG20" "3NF282" "3NF283" "3NF279" "������") ("UG21" "3NF293" "3NF294" "������" "������") ("UG22" "3NF295" "3NF296" "������" "������") ("UG23" "3NF284" "3NF285" "3NF286" "3NF287") ("UG24" "3NF288" "3NF289" "3NF290" "������") ("UG25" "������" "3NF201.4" "3NF201.5" "������") ("UG26" "3NF208.4" "3NP209.4" "3NF210.4" "3NP215.4") ("UG27" "3NF211.4" "3NP212.4" "3NF236.4" "3NF237.4") ("UG28" "3NF216.4" "3NF217.4" "3NF236.6" "3NF237.6") ("UG29" "3NF213.4" "3NF214.4" "������" "������") ("UG30" "3NF218.4" "3NF219.4" "������" "������") ("UG31" "3NF201.6" "3NF201.8" "������" "������") ("UG32" "3NP216" "3NP183" "3NL300" "������") ("UG33" "3NP217" "3NP184" "3NL301" "������") ("UG34" "3NP218" "3NP185" "3NL302" "������")))


;(vlax-dump-Object (cadr




; ���� ����� ������_������-604 � �����������
; ID, CHAN1, CHAN2, CHAN3, CHAN4
; � ������ DATA ���� (("UG1" "poz1" "poz2" "poz3" "������")...)
; ���������
(put-data-into-blocks (cols-to-array 5))
(defun put-data-into-blocks (data
			     /
			     sl
			     i
			     obj
			     attl
			     taglist
			     localdata
			     j
			     )
  (setq i 0)
  (setq sl (ss->list* (ssget '((0 . "INSERT")))))
  (foreach bl sl
    (setq obj (vlax-ename->vla-object (nth i sl)))
    ;(setq obj (vlax-ename->vla-object (car (entsel))))
    ;(setq attl (vlax-safearray->list (vlax-variant-value (vla-GetAttributes obj))))
    (setq localdata (cdr (assoc (vla-get-TextString (get-att obj "ID")) data)))
    (if localdata
      (progn
	(setq attl (list
		     (get-att obj "CHAN1")
		     (get-att obj "CHAN2")
		     (get-att obj "CHAN3")
		     (get-att obj "CHAN4")
		     ))
	(mapcar 'vla-put-TextString attl localdata)
	)
	);if
    (setq i (1+ i))
    )
);defun



;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;; ����� ��� ... ������������ ������ ������� � ����� ��� ���
;;; ����� �������� �� ������ ������� � ���������� ��� � ��������
;;; ����� �������
(defun get-and-put (
		    /
		    ss1
		    i
		    obj
		    lst1
		    )
  (setq ss1 (ssget '((0 . "INSERT"))))
  (setq i 0
	lst1 '())
  (repeat (sslength ss1)
    (setq obj (vlax-ename->vla-object (ssname ss1 i)))
    (if (= "��_������-604" (vla-get-EffectiveName obj))
      (setq lst1 (append lst1 (list obj)))
      )
    (setq i (1+ i))
    );repeat
  (setq	lst1 (vl-sort lst1 '(lambda (a b)
				(> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq	lst1 (vl-sort lst1 '(lambda (a b)
				(> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq lst1 (mapcar '(lambda (x)
			(vla-get-TextString (get-att x "ID"))
			)lst1))


  (setq ss2 (ssget '((0 . "INSERT"))))
  (setq i 0
	lst2 '())
  (repeat (sslength ss2)
    (setq obj (vlax-ename->vla-object (ssname ss2 i)))
    (if (= "��_��������" (vla-get-EffectiveName obj))
      (setq lst2 (append lst2 (list obj)))
      )
    (setq i (1+ i))
    );repeat
  (setq	lst2 (vl-sort lst2 '(lambda (a b)
				(> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq	lst2 (vl-sort lst2 '(lambda (a b)
				(> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq lst2 (mapcar '(lambda (x)
			(get-att x "�������")
			)lst2))
  (mapcar 'vla-put-TextString lst2 lst1)
  );defun
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************

;;; � ������� � ����
(defun get-and-put (
		    /
		    ss1
		    i
		    obj
		    lst1
		    )
  (setq ss1 (ssget '((0 . "*TEXT"))))
  (setq i 0
	lst1 '())
  (repeat (sslength ss1)
    (setq obj (vlax-ename->vla-object (ssname ss1 i)))
    (setq lst1 (append lst1 (list obj)))
    (setq i (1+ i))
    );repeat
  (setq	lst1 (vl-sort lst1 '(lambda (a b)
				(> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq	lst1 (vl-sort lst1 '(lambda (a b)
				(> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq lst1 (mapcar '(lambda (x)
			(vla-get-TextString x)
			)lst1))


  (setq ss2 (ssget '((0 . "INSERT"))))
  (setq i 0
	lst2 '())
  (repeat (sslength ss2)
    (setq obj (vlax-ename->vla-object (ssname ss2 i)))
    (if (= "������_������-604" (vla-get-EffectiveName obj))
      (setq lst2 (append lst2 (list obj)))
      )
    (setq i (1+ i))
    );repeat
  (setq	lst2 (vl-sort lst2 '(lambda (a b)
				(> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq	lst2 (vl-sort lst2 '(lambda (a b)
				(> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq lst2 (mapcar '(lambda (x)
			(get-att x "ID")
			)lst2))
  (mapcar 'vla-put-TextString lst2 lst1)
  );defun




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���� ������ �������� - ������������� �� ������� �������
;(setq chlst (ziplist (cols-to-array 2)))\

; ���� ���� 4-���������� - �� ��������� ���������

;;;(setq chlstformontazhmetran
;;;(mapcar '(lambda (x)
;;;	   (if (< (length x) 5)
;;;	     (while (< (length x) 5)
;;;	       (setq x (append x (list "������")))
;;;	       )
;;;	      x
;;;	     )
;;;	   ) chlst)
;;;      )