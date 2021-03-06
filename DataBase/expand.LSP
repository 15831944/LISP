;;;  14_12_30  EXPAND Table




;	����� ������� (� ������� - �����������) ����������� �����

(setq prjData (excel>lst))

(setq res (apply 'append (mapcar '(lambda (line) (list line line line)) prjData)))
(lst>excel res)


(setq prjData (excel>lst))

(lst>excel
  (mapcar
    '(lambda (line)
       (list
	 (car line)
	 (antisep (cdr line) ", ")
	 )
       )
    (ziplist prjData)
    )
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; �������������� ������� - ������� �������� - � ������� �����������
; �.�. ���������� ������� ����� ���� 2 ���������� �������
; ������ - ���� ������� �������� � ������:
; "cabinet" "clamp" "relay" ["cl1" "cl2" "mark1" "mark2"]
; ��� �� ��� � ������� ���� ������������� � ������� � ������� ����������� �����
; � ������ "cabinet" "clamp" "relay" "cl" "mark"

;(setq tbl (db|formatdata (excel>lst)))
;(setq vcf:rule "clam=cl1,cl2,cl3;mark=mark1,mark2,mark3")
;(setq vcf:rule "EVENT=EVENT1,EVENT2,EVENT3,EVENT4,EVENT5,EVENT6,EVENT7,EVENT8,EVENT9;M=M1,M2,M3,M4,M5,M6,M7,M8,M9")
;(setq tbl (db|formatdata (excel>lst)))
;(setq vcf:rule "CL=CL1,CL2,CL3,CL4;CL_DESC=CL1_DESC,CL2_DESC,CL3_DESC,CL4_DESC;M=M1,M2,M3,M4")
;(lst>excel (tbl|expand-columns tbl vcf:rule))
;(lst>excel (tbl|expand-columns (db|formatdata (excel>lst)) "MARK=MARK1,MARK2,MARK3,MARK4,MARK5,MARK6,MARK7,MARK8,MARK9,MARK10,MARK11,MARK12"))
;(lst>excel (tbl|expand-columns (db|formatdata (excel>lst)) "POZSIGN=POZSIGN1,POZSIGN2,POZSIGN3,POZSIGN4,POZSIGN5,POZSIGN6"))
(defun tbl|expand-columns (tbl vcf:rule / $head exp:ruledata res)
  (setq $head (car tbl))
  (setq exp:ruledata (db|transmat (vcfstr>data vcf:rule)))
  ;(("clam" "mark") ("cl1" "mark1") ("cl2" "mark2"))

  (setq
    res
     (mapcar
       '(lambda (line)
	  (mapcar
	    '(lambda (oldtags / otvals)
	       (mapcar
		 '(lambda (tag)
		    (setq otvals (cons (tbl|gpar $head line tag) otvals))
		    )
		 (reverse oldtags)
		 )
	       (cond
		 (
		  (or
		    (apply '= (cons "" otvals))
		    (apply '= (cons nil otvals))
		    )
		  '("tbl|expand-columns=null")
		  )
		 (T (concat otvals line))
		 )
	       )
	    (cdr exp:ruledata)
	    )
	  )
       (cdr tbl)
       )
    )
  (setq res (apply 'append res))
  (setq res (vl-remove '("tbl|expand-columns=null") res))
  (setq res (cons (concat (car exp:ruledata) $head) res))
  (tbl|delcolumns res (apply 'append (cdr exp:ruledata)))
  );defun
;(setq data (db|formatdata (excel>lst)))
;(setq ans (tbl|expand-columns data "mark=mark1,mark2,mark3;clamm=cl1,cl2,cl3"))
;(setq ans (tbl|expand-columns data "M=M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,M13,M14"))
;(setq ans (tbl|expand-columns data "M=MARK1,MARK2,MARK3,MARK4,MARK5,MARK6,MARK7,MARK8,MARK9,MARK10"))
;(setq ans (tbl|expand-columns data "���=�1,�2,�3,�4"))
;(lst>excel ans)
;
;(setq tbl (db|formatdata (excel>lst)))
;(setq vcf:rule "EVENT=EVENT1,EVENT2,EVENT3,EVENT4,EVENT5,EVENT6,EVENT7,EVENT8,EVENT9;M=M1,M2,M3,M4,M5,M6,M7,M8,M9")
;(lst>excel (tbl|expand-columns tbl vcf:rule))
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;









;;   �������������� ������� ����������� � �������� �������� (expand ��������)
(setq tbl (excel>lst))
;(setq res (tbl|zipsorted tbl "KKS"))
(setq data (cdr tbl) db:head (car tbl))
(setq res (db|mapzip* (cons "table" data) '("T1" "T2" "T1" "MOD_NUM" "SOCKET" "KKS"))) (princ)



(setq ans
(mapcar
  '(lambda (sig / val)	;(setq sig (nth 1 res))
     (setq val (nth 1 sig))
     (setq val (cons (db|gpar "CL" (nth 2 sig)) val))
     (setq val (cons (db|gpar "CL" (nth 3 sig)) val))
     (setq val (cons (db|gpar "CL" (nth 4 sig)) val))

     (setq val (cons (db|gpar "M" (nth 2 sig)) val))
     (setq val (cons (db|gpar "M" (nth 3 sig)) val))
     (setq val (cons (db|gpar "M" (nth 4 sig)) val))

     (setq val (cons (db|gpar "DESC" (nth 2 sig)) val))
     (setq val (cons (db|gpar "DESC" (nth 3 sig)) val))
     (setq val (cons (db|gpar "DESC" (nth 4 sig)) val))     
     )
  (cdr res)
  ))
(setq newhead db:head)
(setq newhead (cons "CL2" newhead))
(setq newhead (cons "CL3" newhead))
(setq newhead (cons "CL4" newhead))
(setq newhead (cons "M2" newhead))
(setq newhead (cons "M3" newhead))
(setq newhead (cons "M4" newhead))
(setq newhead (cons "CL2_DESC" newhead))
(setq newhead (cons "CL3_DESC" newhead))
(setq newhead (cons "CL4_DESC" newhead))

(lst>excel (cons newhead ans))




(setq lst (mapcar 'car (excel>lst)))
(DEORIGLIST lst)
(lst>excel (mapcarx sepstr "\n" lst))
(lst>excel (mapcarx sepstr "," lst))



(lst>excel (mapcarx sepstr " " (mapcar 'car (excel>lst))))
(lst>excel (mapcarx sepstr "�" (mapcar 'car (excel>lst))))








(setq res (list-odd tbl 2))

(setq res (list-odd
   
	    
	    (append
	      (cdr tbl)
	      (list (car tbl)))

	    2))

(lst>excel res)







(setq blks (vl-remove-if-not '(lambda (x) (= "act_mnt_cbl-outer" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT"))))))

(setq cabs (vl-remove-if-not '(lambda (b) (wcmatch (kd-get-textstring (getbatt b "LOCFLD")) "*CAB*,*CDB*,*CGB*,*���*"))blks))
(length cabs)

(sssetfirst nil (lst-to-ss cabs))




(setq #clbase (tbl|blrefs>table (vl-remove-if-not '(lambda (x) (= "act_mnt_cbl-outer" (vla-get-EffectiveName x))) (ss->lsto* (ssget '((0 . "INSERT")))))))
(length #clbase)





























































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ����� � 1 ������� ������� ������� �������� ����� �������, ������� ���������� ������
; ��� ������� ��������
;(setq tbl (db|formatdata (excel>lst)))
;(setq tag "POZ")
(defun tbl|expand-split-column (tbl tag / $head res tmpcolname)
  (setq tmpcolname "TMP")
  (setq $head (car tbl))
  (setq
    res
     (mapcar
       '(lambda (line / tagvals)	;(setq line (nth 1 (cdr tbl)))
	  (setq tagvals (sepstr (tbl|gpar $head line tag) ","))
	  (mapcar '(lambda (tv) (cons tv line)) tagvals)
	  )
       (cdr tbl)
       )
    )
  (setq res (apply 'append res))
  (setq res (cons (cons tmpcolname $head) res))
  (setq res (tbl|delcolumn res tag))
  );defun
;(setq data (db|formatdata (excel>lst)))
;(setq ans (tbl|expand-split-column data "row"))
;(lst>excel ans)
;(lst>excel (tbl|expand-split-column (db|formatdata (excel>lst)) "POZ"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ����� � 1 ������� ������� ������� �������� ����� ":" ������� ���������� ���� ������� �� ���������� - ������
; ��� ������� ��������
; ������ : [ADDRESS] "@CABPSU:@UG:@CH:1+"
; ��������� ������� �� [UNIT]:[ITEM]:[CLAMP]:[CLAM]

;(setq tbl #$Lnks)
;(setq tag "ADDRESS")
;(setq delimiter ":")


(defun tbl|expand-tree-split-column (tbl tag delimiter / i newtagslist $head res)
  ;;;  ������
  (setq i (1+ (apply 'max (mapcar '(lambda (x) (length (sepstr x delimiter))) (cdr (assoc tag (db|transmat tbl)))))))
  (setq newtagslist nil)
  (while (> (setq i (1- i)) 0) (setq newtagslist (cons (strcat tag (itoa i)) newtagslist)))
  ;;;;;;;;;;;

  (setq $head (car tbl))
  (setq
    res
     (mapcar
       '(lambda (line / tagvals)	;(setq line (nth 1 (cdr tbl)))
	  (setq tagvals (sepstr (tbl|gpar $head line tag) delimiter))
	  (repeat (- (length newtagslist) (length tagvals))
	    (setq tagvals (cons "" tagvals))
	    )
	  (concat tagvals line)
	  )
       (cdr tbl)
       )
    )
  
  (setq res (cons (concat newtagslist $head) res))
  (setq res (tbl|delcolumn res tag))
  );defun



;(setq data (db|formatdata (excel>lst)))
;(setq ans (tbl|expand-tree-split-column data "POZSIGN" ", "))
;(lst>excel ans)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ������������ ������ �������

;	1 DETLEV=40 - loops - ������� ���������
;	2 DETLEV=60 - links - ������������� ����� (�������)
;	3 DETLEV=80 - connections - ����������� - ������ ����������� ������� ����� ������� � ������ ������


;  loops -> links



;	TAGS = [MARK ADDR1 ADDR2]
;	LOCATION = [SUBSYST:EQUIP:CLAMP:CLAM]
;	LOCATION = [UNIT:ITEM:TERM:PIN]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tbl|expand-M:MARK (line)
  (list
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-0")
	      "@FLD::@Sensor:SCT"		; "=LOOP_KKSID:X:SCT"
	      "@CABMARK:@P:CHA:SCT"		; "+CAB_KKSID:=P:CHA"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-1")
	      "@CABMARK:@P:XS:5+"		; "+CAB_KKSID:=P:5+"
	      "@CABCTRL:@MODUL:@CHAN:2+"	; "+CAB_KKSID:#MOD:#CLAM"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-2")
	      "@CABMARK:@P:XS:6-"		; "+CAB_KKSID:=.P:6-"
	      "@CABCTRL:@MODUL:@CHAN:1-"	; "+CAB_KKSID:#MOD:#CLAM"
	      ) line)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tbl|expand-M:4W (line)
  (list
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-take")
	      ":::PIPE"
	      "@FLD:@Stand:@Sensor:take"
	      ) line)    
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-1")
	      "@FLD:@Stand:@Sensor:1L"
	      "@CABPSU:@UG:@CH:1+"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-2")
	      "@FLD:@Stand:@Sensor:2N"
	      "@CABPSU:@UG:@CH:2-"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-3")
	      "@FLD:@Stand:@Sensor:3+"
	      "@CABCTRL:@MODUL:@CHAN:2+"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-4")
	      "@FLD:@Stand:@Sensor:4-"
	      "@CABCTRL:@MODUL:@CHAN:1-"
	      ) line)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tbl|expand-M:2W (line)
  (list
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-take")
	      ":::PIPE"
	      "@FLD:@Stand:@Sensor:take"
	      ) line)       
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-1")
	      "@FLD:@Stand:@Sensor:1"
	      "@CABCTRL:@MODUL:@CHAN:1-"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-2")
	      "@FLD:@Stand:@Sensor:2"
	      "@CABPSU:@UG:@CH:2-"
	      ) line)
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-3")
	      "@CABPSU:@UG:@CH:1+"
	      "@CABCTRL:@MODUL:@CHAN:2+"
	      ) line)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tbl|expand-M:L (line)
  (list
    (concat (list
	      (strcat (tbl|gpar (car loops) line "LOOP_KKSID") "-take")
	      ":::PIPE"
	      "@FLD:@Stand:@Sensor:take"
	      ) line)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ��������� ����� ������
; "@������:@����:@����:17"
; ����, � �������� ���� ��� �� 4 ������ �������� ����� ����������� �������


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(setq loops (db|formatdata (excel>lst)))
(setq #$Lnks nil)



;		LOOPS -> LINKS


;  add "MARK"s "ADDR1" "ADDR2"
(setq #$Lnks
(mapcar
  '(lambda (line / lt)	;(setq line (nth 1 (cdr loops)))
     (setq lt (tbl|gpar (car loops) line "LOOP_TYPE"))
     (cond
       ((= "M:L" lt) (tbl|expand-M:L line));'("tbl|expand-columns=null"))
       ((= "M:2W" lt) (tbl|expand-M:2W line))
       ((= "M:4W" lt) (tbl|expand-M:4W line))
       ((= "M:MARK" lt) (tbl|expand-M:MARK line))
       )
     )
  (cdr loops)
  ))

(setq #$Lnks (apply 'append #$Lnks))
(setq #$Lnks (vl-remove "tbl|expand-columns=null" #$Lnks))
(setq #$Lnks (cons (concat (list "MARK" "ADDR1" "ADDR2") (car loops)) #$Lnks))


;         ��������
;(lst>excel #$Lnks)
;;;;;;;;;;;;;;;;;;



;		LINKS -> CONTACTs

;���������� ������� ADDR1 � ADDR2 �� �� ������� �� ������
(setq #$Contacts (tbl|expand-columns #$Lnks "ADDRESS=ADDR1,ADDR2"))


;         ��������
;(lst>excel #$Contacts)
;;;;;;;;;;;;;;;;;;



(setq #$Contacts (tbl|expand-tree-split-column #$Contacts "ADDRESS"))

; NOW GO TO ADO










;;;
;;;
;;;
;;;;         
;;;(lst>excel #$Contacts)
;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;; 			��� ����� �������� ��������� - 
;;;
;;;
;;;;;   ��������� ������
;;;(setq c1 #$Contacts)
;;;
;;;(setq tbl-to-add-stand (tbl|filter (tbl|filter c1 "ADDRESS2=@Stand") "F_PID=PT"))
;;;;(lst>excel tbl-to-add-stand)
;;;(setq c1 (cdr c1))
;;;(mapcar
;;;  '(lambda (line / head ldat lsnd)	;(setq line (nth 0 (cdr tbl-to-add-stand)))
;;;     (setq head (car tbl-to-add-stand))
;;;     (setq ldat (tbl|spar head line "ADDRESS1" (strcat "������ " (tbl|gpar head line "LOOP_KKSID"))))
;;;     (setq ldat (tbl|spar head ldat "ADDRESS2" ""))
;;;     (setq ldat (tbl|spar head ldat "ADDRESS3" ""))
;;;
;;;     (setq lsnd (tbl|spar head line "ADDRESS1" (strcat "����� UE-��#")))
;;;     (setq lsnd (tbl|spar head lsnd "ADDRESS2" ""))
;;;     (setq lsnd (tbl|spar head lsnd "ADDRESS3" ""))
;;;     (setq lsnd (tbl|spar head lsnd "ADDRESS4" "#"))
;;;
;;;     (setq c1 (vl-remove line c1))
;;;     (setq c1 (concat (list ldat lsnd) c1))
;;;     )
;;;  (cdr tbl-to-add-stand)
;;;  ) (princ)
;;;(setq c1 (cons (car #$Contacts) c1))
;;;
;;;(lst>excel c1)
;;;
;;;(lst>excel c2)
;;;
;;;;;   ��������� �������� � ����� ������ ������� � ����� ���� ��������� ������� (��� �����:( )
;;;(setq c2 (cdr c1))
;;;(setq tbl-to-add-CAB1clamp (tbl|filter (tbl|filter c1 "ADDRESS2=@Stand") "F_PID=PT"))
;;;
;;;
;;;
;;;
;;;





;;  � ��� ��� ������ ����� - ����� ������������ � ��������
;;  ������ ����-���� � ����������� �� �����, ����� ������� excel>autoblocks

;(lst>excel #$Contacts)


;(excel>autoblocks #$Contacts)

;;  ��������� (������������ ������) �� ��������� ������� bfbatt






















; now go to ADO working




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;













;;;;;;(setq tbl (db|formatdata (excel>lst)))
;;;;;;(setq vcftag "interface")
;;;;;;"220,DO=�������,�������,������;220,DI=��� �� ��������,��� �� ��������,�� �������,�� �������"
;;;;;;(vcfstr>data "220DO=�������,�������,������;220DI=��� �� ��������,��� �� ��������,�� �������,�� �������")
;;;;;;(vcfstr>data "220,DO=�������,�������,������;220,DI=��� �� ��������,��� �� ��������,�� �������,�� �������")
;;;;;;   �������: ��� ��� ����� ����� - �������� ����������� 1 �������
;;;;;;   	       ��� ��� �� ����� - ����� ��������� ������ ��������
;;;;;;   �� ���� � ������ ������
;;;;;;   "220,DO=�������,�������,������;220,DI=��� �� ��������,��� �� ��������,�� �������,�� �������"
;;;;;;   1 �������� �������� ������������ �� 7 ��������
;;;;;;   �� ������� 3 � ����������� 220 � DO � 4 � ����������� 220 � DI
;;;
;;;� �����, �� ���� ������ ������ ��� ������.� , �.�. ������������ �������������, �� �������� �������� ���������
;;;
;;;(defun tbl|expand-of-vcfcol (tbl vcftag / $head res)
;;;  (setq typecolname "TMP_TYPE")
;;;  (setq $head (car tbl))
;;;   
;;;  (setq
;;;    res
;;;     (mapcar
;;;       '(lambda (line / vcf)	;(setq line (nth 0 (cdr tbl)))
;;;
;;;	  (setq vcf (vcfstr>data (tbl|gpar $head line vcftag)))
;;;
;;;	  
;;;	  (vcfstr>data (tbl|gpar $head line vcftag))
;;;	  )
;;;       (cdr tbl)
;;;       )
;;;    )
;;;
;;;
;;;  
;;;  res
;;;  );defun
















;;;
;;;
;;;;;  � ������ ���� �������� ��������
;;;;;  ������ �� ���� �������� �������� (���������� ������� ������)
;;;
;;;(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))
;;;(load (strcat #lisppath "DataBase\\dblib.lsp"))
;;;(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))
;;;(load (strcat #lisppath "Strings\\kd-sortstrings.LSP"))
;;;
;;;
;;;(setq db:data (cons "table" (vl-remove-if '(lambda (x) (apply '= (cons "" x))) (db|formatdata (excel>lst)))))
;;;
;;;(length (cdr db:data))
;;;
;;;(setq sdata (cons "table" (vl-remove-if '(lambda (x) (apply '= (cons "" x))) (db|formatdata (excel>lst)))))
;;;
;;;(setq signals
;;;   '(
;;;     ("1" "�� �������" "�� �������" "��� �� ��������" "��� �� ��������" "�������" "�������" "������")
;;;     ("2" "�� �������" "�� �������" "��� �� ��������" "��� �� ��������" "�������" "�������" "������")
;;;     ("3" "�� �������" "�� �������" "������" "������" )
;;;     )
;;;  )
;;;
;;;
;;;
;;;(length
;;;  (setq res
;;;(apply 'append
;;;(mapcar
;;;  '(lambda (x)
;;;     ;(setq x (cadr db:data))
;;;     (mapcar
;;;       '(lambda (s)
;;;	  (append
;;;	    (list
;;;	      (nth 0 x)
;;;	      (nth 1 x)
;;;	      )
;;;	    (assoc s (cdr sdata))
;;;	    )
;;;	  
;;;	  )
;;;       (cdr (assoc (last x) signals))
;;;       )
;;;     )
;;;  (cdr db:data)
;;;  )
;;;       )
;;;	)
;;;)
;;;
;;;(lst>excel res)
;;;
;;;
;;;
;;;;;;  2
;;;
;;;(setq armlst (vl-remove-if '(lambda (x) (apply '= (cons "" x))) (db|formatdata (excel>lst))))
;;;
;;;; ��������� ������� �� �������� - ��.���� ��������
;;;
;;;(setq signals:head '("sign_type" "event" "mark1" "mark1"))
;;;(setq
;;;  signals
;;;   '(
;;;     (	;603
;;;      ("2" "3" "4")
;;;      ("24DO"		"������" "9" "19")
;;;      ("24DO"		"������" "7" "17")
;;;      ("24DI"		"�� �������" "8" "19")
;;;      ("24DI"		"�� �������" "8" "17")
;;;      ("420AI+"		"���������" "18" "16")
;;;      )
;;;     (
;;;      ("5" "6" "7" "8")
;;;      ("220DO"		"�������" "A11" "A12")
;;;      ("220DO"		"�������" "A19" "A20")
;;;      ("220DO"		"����" "A1" "A16")
;;;      ("220DI"		"�� �������" "A11" "N")
;;;      ("220DI"		"�� �������" "A19" "N")
;;;      ("220DI"		"��� �� ��������" "A15" "N")
;;;      ("220DI"		"��� �� ��������" "A23" "N")
;;;      ("220DI"		"����������" "A9" "N")
;;;      )
;;;     (	;602
;;;      ("9")
;;;      ("220DO"		"�������" "A11" "A12")
;;;      ("220DO"		"�������" "18" "16")
;;;      ("220DO"		"���������� ��������" "A12" "A4")
;;;      ("220DI"		"�� �������" "A2" "N")
;;;      ("220DI"		"�� �������" "A3" "N")
;;;      ("220DI"		"����������� ����� ��������" "A9" "N")
;;;      ("220DI"		"������" "A10" "N")
;;;      )
;;;
;;;     ( ;601
;;;      ("10")
;;;      ("220DO"		"�������" "A11" "A12")
;;;      ("220DO"		"�������" "A24" "A20")
;;;      ("220DO"		"����" "A1" "A16")
;;;      ("220DI"		"�� �������" "A8" "N")
;;;      ("220DI"		"�� �������" "A19" "N")
;;;      ("220DI"		"��� �� ��������" "A15" "N")
;;;      ("220DI"		"��� �� ��������" "A23" "N")
;;;      ("220DI"		"����������" "A9" "N")
;;;      )
;;;     )
;;;   )
;;;
;;;;;   ������ �������
;;;(setq lst (vl-sort (mapcar '(lambda (x) (norus (kd-get-textstring x))) (ss->lsto* (ssget))) '<))
;;;(norus (antisep lst ","))
;;;(length lst)
;;;
;;;;;   ������������ ������
;;;
;;;(setq lst (vl-sort (mapcar '(lambda (x) (norus (kd-get-textstring x))) (ss->lsto* (ssget))) '<))
;;;(norus (antisep lst ","))
;;;(length lst)
;;;
;;;
;;;
;;;
;;;(setq result
;;;(mapcar
;;;  '(lambda (ar)	;(setq ar (nth 2 armlst))
;;;     (mapcar
;;;       '(lambda (s)
;;;	  (append ar s)
;;;	  )
;;;       (cdr (assoc (nth 2 ar) signals))
;;;       )
;;;     )
;;;  armlst)
;;;      )
;;;(apply 'append result)
;;;(lst>excel (apply 'append result))
;;;
;;;
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(db|getdata)
;;;db:table
;;;(db|gpar "��" (cadr db:data))
;;;
;;;
;;;(setq
;;;  cabdata
;;;   '(
;;;     (
;;;      "2"
;;;      ("#���" "#����" 4 "380" "marks=A2,B2,C2,PE")
;;;      ("#���" "#����" 5 "220" "marks=10,13,14,17,19")
;;;      ("#����" "#CTRL" 5 "220" "marks=7,8,9,17,19")
;;;      ("#���" "#CTRL" 2 "420" "marks=16,18")
;;;      )
;;;
;;;     (
;;;      "3"
;;;      ("#���" "#����" 4 "380" "marks=A2,B2,C2,PE")
;;;      ("#���" "#����" 5 "220" "marks=10,13,14,17,19")
;;;      ("#����" "#CTRL" 5 "220" "marks=7,8,9,17,19")
;;;      ("#���" "#CTRL" 2 "420" "marks=16,18")
;;;      )
;;;
;;;     (
;;;      "4"
;;;      ("#���" "#����" 4 "380" "marks=A2,B2,C2,PE")
;;;      ("#���" "#����" 5 "220" "marks=10,13,14,17,19")
;;;      ("#����" "#CTRL" 5 "220" "marks=7,8,9,17,19")
;;;      ("#���" "#CTRL" 2 "420" "marks=16,18")
;;;      )
;;;
;;;
;;;     
;;;     )
;;;  )
;;;






















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;   30   expanding loops to $Elements and $Links

;;;
;;;(setq tbl (db|formatdata (excel>lst)))
;;;
;;;
;;;(setq #$Elts nil #$Lnks nil)
;;;;(setq #$Lnks '(("MARK")))
;;;;(setq #$Elts '(("EL_TYPE")))
;;;
;;;
;;;(mapcar
;;;  '(lambda (line / loop_type )	;(setq line (nth 1 (cdr tbl)))
;;;     (setq loop_type (tbl|gpar (car tbl) line "LOOP_TYPE"))
;;;     (cond
;;;       ((= "M:L" loop_type)
;;;	(tbl|add-M:L #$Elts #$Lnks (cons (car tbl) line))
;;;	)
;;;       )
;;;     )
;;;  (cdr tbl)
;;;  )
;;;
;;;
;;;
;;;(defun tbl|add-M:L (elts-tbl-sym lnks-tbl-sym
;;;		    owner1tbl
;;;		    /
;;;		    )
;;;  (set elts-tbl-sym
;;;    (cons
;;;      (list
;;;	("EL_TYPE" "SE1")
;;;	("CONTACTS" ("CFM1"))
;;;	)
;;;      (eval elts-tbl-sym)))
;;;    
;;;  (set lnks-tbl-sym
;;;    (cons
;;;      (list
;;;	("MARK" "FM1")
;;;	("CONTACTS" ("F1"))
;;;	)
;;;      (eval elts-tbl-sym)))
;;;  
;;;   
;;;  );defun


































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;		15_07_08
; ���� �������� ���
; ��������� ������ ��������� �������� � ���������� ��� ��������

(tbl|getdata 'ZRA)

;	���� ������������� ���� ��������
(setq schemas 
       (origlist(mapcar
	 '(lambda (x / cutlast)
	    (defun cutlast (y) (reverse (cdr (reverse y))))
	    (antisep (cutlast (sepstr x "|")) "|")
	    )
	 ;(origlist (cdr (assoc "ELSCH" (db|transmat ZRA))))
	 (origlist (cdr (assoc "�3_CODE" (db|transmat ZRA))))
	 ))
      )
(length schemas)
'("R|380|���|0|5413|--|OI"
  "V|380|UNI|3|5401|--|--"
  "V|380|UNI|3|5403|--|--"
  "V|380|UNI��|3|5403|--|--"
  "V|380|����|3|5401|--|--"
  "V|380|���|3|5403R|--|OI"
  "V|380|���|3|5403R|--|OI"
 )


'("R|380|��2|0|RT412.37|--"
  "S|220|���|0|����|PT"
  "V|220|���100|0|LK609|--"
  "V|380|AUMA|6|AT751.37|DODC"
  "V|380|RAIN|0|AT751|--"
  "V|380|UNI|6|AT752.37|--"
  "V|380|����|6|AT752.37|--"
  "V|380|���|6|AT752.37|--"
  "V|380|��|6|AT751.37|--"
  "V|380|����|6|AT752.37|--"
  "V|380|���125|6|AO753.37|--"
  "V|380|���125|6|AO753.37|DODC"
  "V|380|���160|6|AO754.37|--"
  "V|380|���250|6|AO754.37|--"
  "V|380|��������|6|AT752.37|--"
 )
;	������ �� ������ ����� ��������� ����� ��������� ������ (� �������)
;	������������ � "�������" �����������

; ������ - ������� ����������������� ����� - ����������� � ������� ������

;;;(setq lst '())
;;;(while (setq name (kd:dclget '("�����")))
;;;  (setq lst (cons (cons (car name) (g:getmarks)) lst))
;;;  )

"������"
; cables.lsp
;	��������� ����� � ��.������ ��������, ������� �������� �� �������� (�������)
(cons "������" (g:getmarks))

("������" "A20" "A24" "A19" "A10" "A15" "A12" "A11" "N" "A16" "PE" "C2" "B2" "A2" "A1")

(cons "���" (g:getmarks))
("���" "A12" "A20" "A24" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")

(cons "220DI" (g:getmarks))
("220DI" "A23" "A19" "A11" "A15" "N") 

(cons "DONO" (g:getmarks))
("DONO" "A20" "A19" "A12" "A11" "A16" "A10") 

(cons
  "V|380|UNI|3|5403|--|--"
  (list
    (cons "������" (g:getmarks))
    (cons "���" (g:getmarks))
    (cons "220DI" (g:getmarks))
    (cons "DONO" (g:getmarks)))
  )

(cons "������" (g:getmarks))
(cons "���" (g:getmarks))
(cons "24DI" (g:getmarks))
(cons "DONO" (g:getmarks))
(cons "420AI" (g:getmarks))



;	������ ��������� � ���� �� �����

(setq schema 
'("V|380|����|3|5401|--|--"
  ("������" "A20" "A24" "A19" "A10" "A15" "A12" "A11" "N" "A16" "PE" "C2" "B2" "A2" "A1")
  ("���" "A12" "A20" "A24" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10") 
  ))
(lst>excel (compose schema))

(setq schema 
'("V|380|UNI|3|5401|--|--"
  ("������" "A20" "A24" "A19" "A10" "A15" "A12" "A11" "N" "A16" "PE" "C2" "B2" "A2" "A1")
  ("���" "A12" "A20" "A24" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10") 
  ))

(setq schema 
'("V|380|UNI|3|5403|--|--"
  ("������" "A23" "A20"	"A19" "A15" "A12" "A11"	"A16" "A10" "N"	"A1" "C2" "B2" "A2" "PE")
  ("���" "A20" "A12" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10")
 ))
(setq schema 
'("V|380|UNI��|3|5403|--|--"
  ("������" "A23" "A20"	"A19" "A15" "A12" "A11"	"A16" "A10" "N"	"A1" "C2" "B2" "A2" "PE")
  ("���" "A20" "A12" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10")
  ))
(setq schema 
'("V|380|���|3|5403R|--|OI"
  ("������" "A23" "A20"	"A19" "A15" "A12" "A11"	"A16" "A10" "N"	"A1" "C2" "B2" "A2" "PE")
  ("���" "A20" "A12" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE" "13" "18")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10")
  ("420AI" "13" "18")
  ))
(setq schema 
'("V|380|���|3|5403R|--|OI"
  ("������" "A23" "A20"	"A19" "A15" "A12" "A11"	"A16" "A10" "N"	"A1" "C2" "B2" "A2" "PE")
  ("���" "A20" "A12" "A19" "A11" "A10" "A1" "C2" "B2" "A2" "PE" "13" "14" "16" "18")
  ("220DI" "A23" "A19" "A11" "A15" "N")
  ("DONO" "A20" "A19" "A12" "A11" "A16" "A10")
  ("420AI" "13" "14" "16" "18")
  ))

(setq schema 
'("V|380|���|0|5413|--|OI"
  ("������" "19" "17" "8" "10" "9" "7" "C2" "B2" "A2" "PE") 
  ("���" "13" "14" "16" "18" "C2" "B2" "A2" "PE" "10" "19" "17") 
  ("24DI" "19" "17" "8")
  ("DONO" "19" "17" "9" "7")
  ("420AI" "13" "14" "16" "18")
  ))

(lst>excel (compose schema))



(defun compose (schema / gk data maincab cables result)
  (defun gk (obs / marks)
    (if (null (atom (car obs)))
    (cond
      ((= (length obs) 2)
       (mapcar '(lambda (x) (if (member x (car obs)) (setq marks (cons x marks)))) (cdr (cadr obs)))
	(if marks (list (concat (list (car (car obs)) (car (cadr obs))) (vl-sort marks '<))))
	)
      ((> (length obs) 2)
       (append
	 (apply 'append (mapcar '(lambda (c) (gk (list (car obs) c))) (cdr obs)))
	 (gk (cdr obs))
	 )
       )
      ))
    );defun
  
  (setq data (cdr schema))
  (setq maincab (car data) data (cdr data))
  (setq cables nil)

  (setq result
  (mapcar
    '(lambda (cab / res) ;(setq cab (nth 2 data))
       (mapcar
	 '(lambda (m)
	    (if (member m maincab)
	      (setq res (cons m res))
	      )
	    
	    )
	 (cdr cab)
	 )
       (if res (setq cables (cons (concat (list (car maincab) (car cab)) (vl-sort res '<)) cables)))
       (vl-remove-if '(lambda (x) (member x res)) cab)
       )
    data))
  (setq result (vl-remove-if '(lambda (x) (= 1 (length x))) result))
  (append cables (gk result))
  );defun









































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;		16_03_017
; ���� �������� ���
; ��������� ������ ��������� �������� � ���������� ��� ��������

(tbl|getdata 'ZRA)

;	���� ������������� ���� ��������
(setq schemas 
       (origlist(mapcar
	 '(lambda (x / cutlast)
	    (defun cutlast (y) (reverse (cdr (reverse y))))
	    (antisep (cutlast (sepstr x "|")) "|")
	    )
	 (origlist (cdr (assoc "�3_CODE" (db|transmat ZRA))))
	 ))
      )


'("R|380|��2|0|RT412.37|--"
  "S|220|���|0|����|PT"
  "V|220|���100|0|LK609|--"
  "V|380|AUMA|6|AT751.37|DODC"
  "V|380|RAIN|0|AT751|--"
  "V|380|UNI|6|AT752.37|--"
  "V|380|����|6|AT752.37|--"
  "V|380|���|6|AT752.37|--"
  "V|380|��|6|AT751.37|--"
  "V|380|����|6|AT752.37|--"
  "V|380|���125|6|AO753.37|--"
  "V|380|���125|6|AO753.37|DODC"
  "V|380|���160|6|AO754.37|--"
  "V|380|���250|6|AO754.37|--"
  "V|380|��������|6|AT752.37|--"
 )

;	������ �� ������ ����� ��������� ������� � ������


(lst>excel (compose schema))



(defun compose (schema / gk data maincab cables result)
  (defun gk (obs / marks)
    (if (null (atom (car obs)))
    (cond
      ((= (length obs) 2)
       (mapcar '(lambda (x) (if (member x (car obs)) (setq marks (cons x marks)))) (cdr (cadr obs)))
	(if marks (list (concat (list (car (car obs)) (car (cadr obs))) (vl-sort marks '<))))
	)
      ((> (length obs) 2)
       (append
	 (apply 'append (mapcar '(lambda (c) (gk (list (car obs) c))) (cdr obs)))
	 (gk (cdr obs))
	 )
       )
      ))
    );defun
  
  (setq data (cdr schema))
  (setq maincab (car data) data (cdr data))
  (setq cables nil)

  (setq result
  (mapcar
    '(lambda (cab / res) ;(setq cab (nth 2 data))
       (mapcar
	 '(lambda (m)
	    (if (member m maincab)
	      (setq res (cons m res))
	      )
	    
	    )
	 (cdr cab)
	 )
       (if res (setq cables (cons (concat (list (car maincab) (car cab)) (vl-sort res '<)) cables)))
       (vl-remove-if '(lambda (x) (member x res)) cab)
       )
    data))
  (setq result (vl-remove-if '(lambda (x) (= 1 (length x))) result))
  (append cables (gk result))
  );defun









































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;