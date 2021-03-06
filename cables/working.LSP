





(setq lst (mapcar 'car (excel>lst)))

(setq i 0)

(setq res 
(mapcar
  '(lambda (x)	;(setq x (nth 13 lst))
     (if (= (rem (atoi x) 20) 1) (setq i (1+ i)))
     (list x (any-to-string i))
     )
  lst
  )
      )

(lst>excel res)




(mapcar
'(lambda (obj / str)
  (setq str (kd-get-TextString obj))
  (vla-put-TextString obj (strcat "{\\T0.9;" str "}" ))
   ;(vla-put-TextString obj (strcat "{\\W0.;\\T0.9;" str "}" ))
  )
(ss->lsto* (ssget '((0 . "MTEXT"))))
)
  















(setq prjData (mapcar 'car (excel>lst)))

(setq res (mapcar '(lambda (x) (list (protvino:LC2D-select x))) prjData))
(lst>excel res)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq prjData (excel>lst))
(setq frame (excel>lst))


(setq res (mapcarx (lambda (x) (cadr (assoc x frame))) nil prjData))
(lst>excel res)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq prjData (mapcar 'car (excel>lst)))
(setq frame (mapcarx any-to-string nil (excel>lst)))
(setq res (mapcar '(lambda (x) (assoc x frame)) prjData))
(lst>excel res)



(lst>excel (inverse (db|diff prjData (mapcar 'car frame))))




(db|diff prjData (mapcar 'car frame))



(setq prjData (mapcar 'car (excel>lst)))
(setq frame (excel>lst))

(setq res (mapcar '(lambda (x)
		     (cons x
		       (vl-sort
			 (mapcar 'cadr
			   (vl-remove-if-not
			     '(lambda (z)
				(= x (car z))
				)
			     frame
			     ))
			 '<
			 ))
		     ) prjData))
(lst>excel res)

















;;	������������� �� ��������

;;  ������ ���-���� (�� ������) - �������� ������ � ���������� �����


(setq BRefs (ss->lsto (ssget)))
(setq prjData (excel>lst))

(setq #frame '("N1" "#-A803" "PE"))
(setq #frame (kd:sortmarks '("N1" "#-A803" "PE")))
(setq numpref "3NX-")
(setq startnum 1101 dnum 1 i (- dnum))
(length prjData) (= (length prjData) (length cbls))




(mapcar
  '(lambda (cableOBJ cableID / atts)	;(setq poz "3NX-358")
     (vla-put-textstring (getbatt cableOBJ "NUMBER") (strcat numpref (itoa (+ startnum (setq i (+ i dnum))))))
     (cbl:putmarks cableOBJ (ApplyIDToFrame cableID #frame))
     )
  BRefs
  prjData
  )


(lst>excel (list (apply 'append (excel>lst))))











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun ss:getBRefs (bnames / lst)
  (if (null (setq lst (ssget "_I" (list '(0 . "INSERT") (cons 2 (antisep (cons "`*U*" bnames) ","))))))
    (setq lst (ssget (list '(0 . "INSERT") (cons 2 (antisep (cons "`*U*" bnames) ","))))))
  (setq lst (ss->lsto* lst))
  (setq lst (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) bnames)) lst))
  lst
  );defun






									���������
(setq bnames '("A$C39170C4A" "A$C06683336" "A$C1FA92C9F" "A$C282A16B2" "A$C28EA3905"))

(setq signalData nil)

(defun c:asd ()
(progn
(setq lst (mapcar 'blref-to-data (ss:getBRefs bnames)))
(setq data (cons
(cons
  (cadr (assoc "�3_CODE" (car (vl-remove-if-not '(lambda (line) (= "[BN]=A$C282A16B2" (car (car line)))) lst))))
  (mapcar
    '(lambda (line)
       (cadr (assoc "DESCRIPTION" line))
       )
    (vl-remove-if '(lambda (line) (= "[BN]=A$C282A16B2" (car (car line)))) lst)
    )
  )
data))
))



(lst>excel signalData)



(setq prjBase (excel>lst))

(setq res
(mapcar
  '(lambda (motor)	;(setq motor (nth 13 prjBase))
     (mapcar
       '(lambda (sig)
	  (cons sig motor)
	  )
       (cdr (assoc (car motor) signalData))
       )
     )
  prjBase
  ))


(lst>excel (apply 'append res))








(setq #frame (origlist (excel>lst)))
(setq prjData (mapcar 'car (excel>lst)))

(setq res (mapcar '(lambda (p) (assoc p #frame)) prjData))


(setq res
       (mapcar
	 '(lambda (kks)	;(setq kks (nth 13 prjData))
	    (list kks (antisep
	    (mapcar 'cadr 
	    (vl-remove-if-not
	      '(lambda (line)
		 (= (car line) kks)
		 )
	      #frame
	      )) ", "))
	    )
	 prjData
	 )
      )




(setq res (apply 'append
       (mapcar
	 '(lambda (kks)	;(setq kks (nth 13 prjData))
	    (vl-remove-if-not
	      '(lambda (line)
		 (= (car line) kks)
		 )
	      #frame
	      )
	    )
	 prjData
	 ))
      )
(lst>excel res)




(lst>excel (mapcar '(lambda (line) (list (antisep line ""))) (excel>lst)))




(setq a (excel>lst))
(lst>excel a)



(lst>excel (vl-remove-if '(lambda (line) (apply '= line)) (excel>lst)))



(deoriglist (mapcar 'car (excel>lst)))
'("10LBF10AA110" "10LBF30AA110"	"11LBE10AA110" "11LBE10AA140"
  "12LBE10AA110" "12LBE10AA140"	"10LBE10AA010" "10LBE10BB010"
  "11LBE10AA130" "12LBE10AA130"	""
 )




(antisep (mapcar 'car (excel>lst)) ",")

(lst>excel (mapcar 'sepstr* (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr x ":")) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr x "-")) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr x "|")) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr x "/")) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr x " ")) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (list (vl-string-trim " " x))) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr x "x")) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (sepstr* x)) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (list (norus x))) (mapcar 'car (excel>lst))))
(lst>excel (mapcar '(lambda (x) (list (noeng x))) (mapcar 'car (excel>lst))))


(lst>excel (inverse (excel>lst)))



(lst>excel (mapcar
	     '(lambda (x)	;(setq x (excel>lst))
		
		(wcmatch x "*##@@@##@@###*")
		(sepstr* x)

		
		)
	     (mapcar 'car (excel>lst))))





(setq lst (mapcar 'car (excel>lst)))
(deoriglist lst)
(length (origlist lst))
(length lst)

(lst>excel (mapcar 'list (origlist lst)))





;																				$
;																				$
;	����� ���������� ��. ����� � ������� ����� ����������� � ����������� ���� ��� ������ ����� � ������� �� "�3_CODE"					$
;																				$
;																				$

;	������ ����� ��������� �� �3_CODE
;	������� ������ �� ctrl+shift+V
;	����� ���������������
(setq lst (ss->lsto* (ssget '(( 0 . "INSERT")))))

(mapcar
  '(lambda (item / blk tmp)	;(setq item (nth 1 lst))

     (setq blk (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName item)))
     (setq tmp (car (vl-remove-if-not '(lambda (x / name) (and
		   (= "AcDbBlockReference" (vla-get-Objectname x))
		   (= "mnt_�����-X02" (vla-get-EffectiveName x))
		   )) (cont>list blk)))
	   )
     (vla-put-name blk (vla-get-TextString (getbatt tmp "�3_CODE")))
     )
  lst)






;	�� ������������� ������ ��������
;	����������� �3_CODE � ����� ������� ������������


(defun c:asd ( / lst srcbref elCode compareBref)
  (setq lst (ss:getBRefs '("EL_SCHM-DRW" "EL_TBLassign-line" "mnt_�����-X02")))
  (setq srcbref (vl-remove-if-not '(lambda (b) (= "EL_SCHM-DRW" (vla-get-EffectiveName b))) lst))
  (setq compareBref (vl-remove-if-not '(lambda (b) (= "mnt_�����-X02" (vla-get-EffectiveName b))) lst))
  (if (and
	lst
	srcbref
	(= 1 (length srcbref))
	(setq srcbref (car srcbref))
	compareBref
	(= 1 (length compareBref))
	(setq compareBref (car compareBref))
	(setq lst (vl-remove srcbref lst))
	(setq lst (vl-remove compareBref lst))
	(= (kd-get-textstring (getbatt srcbref "�3_CODE")) (kd-get-textstring (getbatt compareBref "�3_CODE")))
	)
    (progn
      (setq elCode (cnct:genFieldString (getbatt srcbref "�3_CODE")))
      (mapcar
	'(lambda (att) (vla-put-TextString att elCode))
	(mapcar '(lambda (b) (getbatt b "�3_CODE")) lst)
	)
      )
    (alert "error")
    )
  (princ)
  );defun





;	�� ������������� ������ �������� (�� ���������� ���� ����������� � ������)
;	����������� LOOP_ID � MDC_ID � �������

(defun c:asd ( / lst srcbref LOOP_ID MDC_ID)
  (setq lst (ss:getBRefs '("mnt_�����-X02" "cbl_cnct")))
  (setq srcbref (vl-remove-if-not '(lambda (b) (= "mnt_�����-X02" (vla-get-EffectiveName b))) lst))
  (if (and
	lst
	srcbref
	(= 1 (length srcbref))
	(setq srcbref (car srcbref))
	(setq lst (vl-remove srcbref lst))
	)
    (progn
      (setq LOOP_ID (cnct:genFieldString (getbatt srcbref "LOOP_ID")))
      (setq MDC_ID (cnct:genFieldString (getbatt srcbref "MDC_ID")))
      (mapcar
	'(lambda (att) (vla-put-TextString att LOOP_ID))
	(mapcar '(lambda (b) (getbatt b "LOOP_ID")) lst)
	)
      (mapcar
	'(lambda (att) (vla-put-TextString att MDC_ID))
	(mapcar '(lambda (b) (getbatt b "LOCATION")) lst)
	)
      )
    (alert "error")
    )
  (princ)
  )








;										;
;										;
;	V1		��� ���� � ����� � ������ ��������������			;
;										;
;										;



(setq prjBase (excel>lst))
(setq bpt (getpoint))
(setq cpt bpt)
(setq dx 500)
(setq df -200)
(setq dc -500)
(setq cCAB "")



;	line
;		MDC_ID		MDCU_NUMBER	DIR	LOOP_ID	�3_CODE

(mapcar
  '(lambda (line / CABINET	BLOCK_NUMBER	SIDE	POZ	�3_CODE	;(setq line (car prjBase))
	    txt)
     (setq CABINET (nth 0 line) BLOCK_NUMBER (nth 1 line) SIDE (nth 2 line) POZ (nth 3 line) �3_CODE (nth 4 line))
     (if (= cCab CABINET)
       (princ)
       (setq cpt (mapcar '+ (list 0 dc 0) cpt) cCab CABINET)
       )
     (vla-InsertBlock #modspace
       (vlax-3d-point (if (= "R" SIDE) (mapcar '+ (list dx 0 0) cpt) cpt))
       �3_CODE 1 1 1 0)
     (vla-AddText #modspace POZ
       (vlax-3d-point (if (= "R" SIDE)
			(mapcar '+ (list (+ 20 dx) -80 0) cpt)
			(mapcar '+ (list    20  -80 0) cpt)
			))
       2.5)
     (if (= "R" SIDE) (setq cpt (mapcar '+ (list 0 df 0) cpt)))
     (princ)
     )
  prjBase
  )





;;;;;		16_03_11

"d:\_AutoCAD\1791 ���������\1791-10\��\��� �� 16_03_05.xlsx"

;										;
;										;
;	V2		��� ����� � ������������� �������������� � 3 �������	;
;										;
;										;


;	line
;		MDC_ID		MDCU_NUMBER	LOOP_ID		�3_CODE
(setq prjBase (excel>lst))



(setq Vdx 	'(230 0 0))
(setq Vdy 	'(0 -302 0))
(setq Vdycab 	'(0 -500 0))
(setq VdTXT	'(-190 20 0))

(setq bpt (getpoint))
(setq cpt bpt)
(setq cCAB "")
;	line
;		MDC_ID		MDCU_NUMBER	LOOP_ID		�3_CODE




(mapcar
  '(lambda (line / CABINET	BLOCK_NUMBER	POZ	�3_CODE	;(setq line (car prjBase))
	    txt
	    b tmp lst
	    )
     (setq CABINET (nth 0 line) BLOCK_NUMBER (nth 1 line) POZ (nth 2 line) �3_CODE (nth 3 line))
     (if (= cCab CABINET) (princ) (setq cpt (mapcar '+ Vdycab cpt) cCab CABINET))
     (if (/= "" �3_CODE)
       (progn
	 (setq b (vla-InsertBlock #modspace (vlax-3d-point (cond ((wcmatch BLOCK_NUMBER "*A*") cpt) ((wcmatch BLOCK_NUMBER "*B*") (mapcar '+ cpt Vdx)) ((wcmatch BLOCK_NUMBER "*C*") (mapcar '+ cpt Vdx Vdx)))) �3_CODE 1 1 1 0))
	 (setq lst (variantextraction (vla-explode b)))
	 (vla-delete b)
	 (setq tmp (car (vl-remove-if-not '(lambda (x / name) (and (= "AcDbBlockReference" (vla-get-Objectname x)) (= "mnt_�����-X02" (vla-get-EffectiveName x)))) lst)))
	 (vla-put-textstring (getbatt tmp "MDC_ID") (strcat CABINET ":" BLOCK_NUMBER))
	 (vla-put-textstring (getbatt tmp "LOOP_ID") POZ)
	 )
       )
     (if (wcmatch BLOCK_NUMBER "*C*")
       (progn
	 (setq b (AddDrw (mapcar '+ cpt '(575 -310 0))))
	 ;(setq b (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ cpt '(575 -310 0)) ) "RU_format" 1 1 1 0))
	 (setq tmp (car (sepstr* BLOCK_NUMBER)))
	 (vla-put-TextString (getbatt b "DRAWING_NAME1") (strcat "���� " CABINET " ������ �������� ��."))
	 (vla-put-TextString (getbatt b "DRAWING_NAME2") (strcat "����� ����������� �������"))
	 (vla-put-TextString (getbatt b "DRAWING_NAME3") (strcat "� ����� ������� ������ " tmp "A, " tmp "B, " tmp "C"))

	 (vla-put-TextString (getbatt b "POST1") "������.")
	 (vla-put-TextString (getbatt b "POST2") "��. ������.")
	 (vla-put-TextString (getbatt b "POST3") "")
	 (vla-put-TextString (getbatt b "POST4") "")
	 (vla-put-TextString (getbatt b "POST5") "�. �����.")
	 (vla-put-TextString (getbatt b "POST6") "")
	 (vla-put-TextString (getbatt b "NAME1") "�����������")
	 (vla-put-TextString (getbatt b "NAME2") "����������")
	 (vla-put-TextString (getbatt b "NAME3") "")
	 (vla-put-TextString (getbatt b "NAME4") "")
	 (vla-put-TextString (getbatt b "NAME5") "��������")
	 (vla-put-TextString (getbatt b "NAME6") "")
	 
	 (setq cpt (mapcar '+ Vdy cpt))
	 )
       )
     (princ)
     )
  prjBase
  )



;;;(mapcar
;;;  '(lambda (line / CABINET	BLOCK_NUMBER	POZ	�3_CODE	;(setq line (car prjBase))
;;;	    txt)
;;;     (setq CABINET (nth 0 line) BLOCK_NUMBER (nth 1 line) POZ (nth 2 line) �3_CODE (nth 3 line))
;;;     (if (= cCab CABINET) (princ) (setq cpt (mapcar '+ Vdycab cpt) cCab CABINET))
;;;     (if (/= "" �3_CODE)
;;;       (progn
;;;     (vla-InsertBlock #modspace
;;;       (vlax-3d-point
;;;	 (cond
;;;	   ((wcmatch BLOCK_NUMBER "*A*")
;;;	    cpt)
;;;	   ((wcmatch BLOCK_NUMBER "*B*")
;;;	    (mapcar '+ cpt Vdx))
;;;	   ((wcmatch BLOCK_NUMBER "*C*")
;;;	    (mapcar '+ cpt Vdx Vdx))
;;;	   )
;;;	 )
;;;       �3_CODE 1 1 1 0)
;;;     
;;;     (vla-AddText #modspace POZ
;;;       (vlax-3d-point
;;;	 (cond
;;;	   ((wcmatch BLOCK_NUMBER "*A*")
;;;	    (mapcar '+ VdTXT cpt ))
;;;	   ((wcmatch BLOCK_NUMBER "*B*")
;;;	    (mapcar '+ VdTXT cpt Vdx))
;;;	   ((wcmatch BLOCK_NUMBER "*C*")
;;;	    (mapcar '+ VdTXT cpt Vdx Vdx))
;;;	   )
;;;	 )
;;;       2.5)
;;;     )
;;;       )
;;;     
;;;     (if (wcmatch BLOCK_NUMBER "*C*") (setq cpt (mapcar '+ Vdy cpt)))
;;;     (princ)
;;;     )
;;;  prjBase
;;;  )









;;;
;;;;;		��������� �� ���� - ������ � ����� mnt_�����-X02
;;;
;;;;;		��������� �������� ������� LOCCAB, ������� ���� ����� ���������
;;;;;	!!!	�� ���������� ���������� �������� ������� ���� �� ������ �� ���������� ���� ������
;;;
;;;(defun c:asd ( / lst srcbref address)
;;;  (setq lst (ss:getBRefs '("cbl_cnct" "mnt_�����-X02")))
;;;  (setq srcbref (vl-remove-if-not '(lambda (b) (= "mnt_�����-X02" (vla-get-EffectiveName b))) lst))
;;;  (if (and
;;;	lst
;;;	srcbref
;;;	(= 1 (length srcbref))
;;;	(setq srcbref (car srcbref))
;;;	(setq lst (vl-remove srcbref lst))
;;;	)
;;;    (progn
;;;      (setq address (strcat (kd-get-textstring (getbatt srcbref "MDC_ID")) ":" (kd-get-textstring (getbatt srcbref "MDCU_NUMBER"))))
;;;      (mapcar '(lambda (att) (vla-put-TextString att address))
;;;	(mapcar '(lambda (b) (getbatt b "LOCCAB")) lst)
;;;	)
;;;      )
;;;    (exit)
;;;    )
;;;  (princ)
;;;  );defun
;;;
;;;
;;;;;		��� ��������� �������
;;;
;;;(defun c:asd ( / lst srcbref address)
;;;  (setq lst (ss:getBRefs '("cbl_cnct" "mnt_�����-X02")))
;;;  (setq srcbref (vl-remove-if-not '(lambda (b) (= "mnt_�����-X02" (vla-get-EffectiveName b))) lst))
;;;  (if (and
;;;	lst
;;;	srcbref
;;;	(= 1 (length srcbref))
;;;	(setq srcbref (car srcbref))
;;;	(setq lst (vl-remove srcbref lst))
;;;	(setq lst (vl-remove-if-not '(lambda (b)
;;;				       (and
;;;					 (= "com_unplotted" (vla-get-layer b))
;;;					 (= "[MTR]" (kd-get-textstring (getbatt b "LOCCAB")))
;;;					 )
;;;				       ) lst))
;;;	)
;;;    (progn
;;;      (setq address (strcat (kd-get-textstring (getbatt srcbref "LOOP_ID")) "-" "XT1"))
;;;      (mapcar '(lambda (att) (vla-put-TextString att address))
;;;	(mapcar '(lambda (b) (getbatt b "LOCCAB")) lst)
;;;	)
;;;      )
;;;    (exit)
;;;    )
;;;  (princ)
;;;  )





;;		��������� ����� � ������ CBL:PULLMARKS

;;		��� ��������� �������
(defun c:asd ( / lst srcbref kks)
  (setq lst (ss:getBRefs '("cbl_cnct" "mnt_�����-X02")))
  (setq srcbref (vl-remove-if-not '(lambda (b) (= "mnt_�����-X02" (vla-get-EffectiveName b))) lst))
  (if (and
	lst
	srcbref
	(= 1 (length srcbref))
	(setq srcbref (car srcbref))
	(setq lst (vl-remove srcbref lst))
	(setq lst (vl-remove-if-not '(lambda (b)
				       (and
					 (= "com_unplotted" (vla-get-layer b))
					 )
				       ) lst))
	)
    (progn
      (setq kks (kd-get-textstring (getbatt srcbref "LOOP_ID")))
      (mapcar
	'(lambda (atts)
	   (mapcar
	     '(lambda (att)
		(vla-put-TextString att
		  (strcat kks "-" (kd-get-textstring att))
		  )
		)
	     (vl-remove-if '(lambda (att) (= "" (kd-get-textstring att))) atts)
	     )
	   )
	(mapcar '(lambda (b) (getbattswcmatch b "MARK#,MARK##")) lst)
	)
      )
    (exit)
    )
  (princ)
  );defun


;;		��� ��������� ������� ��� ����� mnt_�����-X02

(defun c:asd ( / lst srcbref kks)
  (setq lst (ss:getBRefs '("cbl_cnct")))

  (if (and
	lst
	(setq lst (vl-remove-if-not '(lambda (b)
				       (and
					 (= "com_unplotted" (vla-get-layer b))
					 )
				       ) lst))
	)
    (progn
      (mapcar
	'(lambda (cbl / kks)
	   (setq kks (kd-get-textstring (getbatt cbl "LOCCAB")))
	   ;(setq kks "���� �������������� 11HAC10AA001-XT1")
	   (setq kks (vl-remove-if-not '(lambda (s) (wcmatch s "*@@@##@@###*")) (sepstr kks " ")))
	   (if (= 1 (length kks))(setq kks (car kks)))
	   (setq kks (vl-remove-if-not '(lambda (s) (wcmatch s "*@@@##@@###*")) (sepstr kks "-")))
	   (if (= 1 (length kks))(setq kks (car kks)))
	   (mapcar
	     '(lambda (att)
		(vla-put-TextString att (strcat kks "-" (kd-get-textstring att)))
		)
	     (vl-remove-if '(lambda (att) (= "" (kd-get-textstring att))) (getbattswcmatch cbl "MARK#,MARK##"))
	     )
	   )
	lst)
      )
    (exit)
    )
  (princ)
  );defun








;;;;		�������� ������

;; 	MTR-PLC - ��������� ������ - �� ���� ������

(setq allcables (ss:getBRefs '("cbl_cnct")))
(length allcables)



(setq lst (vl-remove-if-not '(lambda (b) (and (= "com_unplotted" (vla-get-layer b)))) lst))
(length lst)
(setq lst (vl-sort lst '(lambda (a b)
			  (>
			    (cadr (variantextraction (vla-get-insertionpoint a)))
			    (cadr (variantextraction (vla-get-insertionpoint b)))
			    )
			  )))
(vla-get-handle (car lst))
(vla-get-handle (last lst))





;;;;;		end of 16_03_11
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






(load (strcat #lisppath "common functions\\pe-select.LSP"))

;	������������ ������ � ��������� �����, ������� �� ��� �������������

(setq containerBRefName "RU_format")
(setq containerAttName "DRAWING_NUMBER")
(setq containerAddress (strcat containerBRefName ":" containerAttName))
(setq targetBrefName "mnt_�����-X02")
(setq targetAttName "�3_CODE")
(setq targetAddress (strcat targetBrefName ":" targetAttName))
(setq prefix "�. ")
(setq suffix "")


(setq obj (vlax-ename->vla-object (car (entsel))))

(do obj)




(setq lst (ss:getBRefs (list containerBRefName)))

(mapcar 'processContainer lst)


(defun processContainer (obj / a b result)
  (vla-GetBoundingBox obj 'a 'b)
  (setq a (variantextraction a))
  (setq b (variantextraction b))
  (setq result (pe-select a b acSelectionSetCrossing '((0 . "INSERT"))))
  (setq result (vl-remove-if-not '(lambda (b) (= targetBrefName (vla-get-EffectiveName b))) result))
  ;(length result)
  (mapcar
    '(lambda (item)
       (vla-put-TextString
	 (getbatt item targetAttName)
	 (strcat prefix (vla-get-TextString (getbatt obj containerAttName)) suffix)
	 )
       )
    result
    )
  (princ)
  );defun








;;;;;		end of 16_04_27
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;	������ ��������� ������ �� ����


;	line
;		MDC_ID		MDCU_NUMBER	LOOP_ID		�3_CODE
(tbl|getdata 'prjBase)




(setq Vdy 	'(0 -12 0))
(setq Vdycab 	'(0 -500 0))
(setq VdTXT	'(-190 20 0))

(setq bpt (getpoint))
(setq cpt bpt)
(setq cCAB "")
;	line
;		MDC_ID		MDCU_NUMBER	LOOP_ID		�3_CODE




(mapcar
  '(lambda (line / CABINET	BLOCK_NUMBER	POZ	�3_CODE	;(setq line (car prjBase))
	    txt
	    b tmp lst
	    )
     (setq CABINET (nth 0 line) BLOCK_NUMBER (nth 1 line) POZ (nth 2 line) �3_CODE (nth 3 line))
     (if (= cCab CABINET) (princ) (setq cpt (mapcar '+ Vdycab cpt) cCab CABINET))
     (if (/= "" �3_CODE)
       (progn
	 (setq b (vla-InsertBlock #modspace (vlax-3d-point (cond ((wcmatch BLOCK_NUMBER "*A*") cpt) ((wcmatch BLOCK_NUMBER "*B*") (mapcar '+ cpt Vdx)) ((wcmatch BLOCK_NUMBER "*C*") (mapcar '+ cpt Vdx Vdx)))) �3_CODE 1 1 1 0))
	 (setq lst (variantextraction (vla-explode b)))
	 (vla-delete b)
	 (setq tmp (car (vl-remove-if-not '(lambda (x / name) (and (= "AcDbBlockReference" (vla-get-Objectname x)) (= "mnt_�����-X02" (vla-get-EffectiveName x)))) lst)))
	 (vla-put-textstring (getbatt tmp "MDC_ID") (strcat CABINET ":" BLOCK_NUMBER))
	 (vla-put-textstring (getbatt tmp "LOOP_ID") POZ)
	 )
       )
     (if (wcmatch BLOCK_NUMBER "*C*")
       (progn
	 (setq b (AddDrw (mapcar '+ cpt '(575 -310 0))))
	 ;(setq b (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ cpt '(575 -310 0)) ) "RU_format" 1 1 1 0))
	 (setq tmp (car (sepstr* BLOCK_NUMBER)))
	 (vla-put-TextString (getbatt b "DRAWING_NAME1") (strcat "���� " CABINET " ������ �������� ��."))
	 (vla-put-TextString (getbatt b "DRAWING_NAME2") (strcat "����� ����������� �������"))
	 (vla-put-TextString (getbatt b "DRAWING_NAME3") (strcat "� ����� ������� ������ " tmp "A, " tmp "B, " tmp "C"))

	 (vla-put-TextString (getbatt b "POST1") "������.")
	 (vla-put-TextString (getbatt b "POST2") "��. ������.")
	 (vla-put-TextString (getbatt b "POST3") "")
	 (vla-put-TextString (getbatt b "POST4") "")
	 (vla-put-TextString (getbatt b "POST5") "�. �����.")
	 (vla-put-TextString (getbatt b "POST6") "")
	 (vla-put-TextString (getbatt b "NAME1") "�����������")
	 (vla-put-TextString (getbatt b "NAME2") "����������")
	 (vla-put-TextString (getbatt b "NAME3") "")
	 (vla-put-TextString (getbatt b "NAME4") "")
	 (vla-put-TextString (getbatt b "NAME5") "��������")
	 (vla-put-TextString (getbatt b "NAME6") "")
	 
	 (setq cpt (mapcar '+ Vdy cpt))
	 )
       )
     (princ)
     )
  prjBase
  )

