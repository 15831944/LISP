;; 14_06_23
;;   ��� ��������� / �������� ���� excel



(load (strcat #lisppath "DataBase\\dblib.lsp"))
(load (strcat #lisppath "strings\\stringlib.lsp"))
(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))


;;;  ������������ �������
(lst>excel (mapcarx sepstr "-" (mapcar 'car (excel>lst))))


;;; 16x Hand to 10
(load (strcat #lisppath "MATH\\hex-dec.lsp"))
(lst>excel
(mapcar
  '(lambda (x)	;(setq x (nth 13 (excel>lst)))
     (list (HEX>DEC (car x)))
     )
  (excel>lst)
  ))





;;;   ����� ������� ��������������

(setq srcdata (db|formatdata (excel>lst)))
(setq lst (mapcar 'car (excel>lst)))
(setq ans (mapcar '(lambda (x) (assoc x srcdata)) lst))
(lst>excel ans)

(setq sigid
       (mapcar
	 '(lambda (x / kks tail marks)	;(setq x (nth 13 srcdata))
	    (setq kks (car x))
	    (setq tail (cadr x))
	    (setq marks (cdr (cdr x)))
	    (setq marks (vl-remove "" marks))
	    (list (strcat kks "_" tail "-[" (antisep marks ",") "]"))
	    )
	 srcdata)
      )








;;;  �� dwg �� ��������
(setq l1 (ss->lsto (ssget)))
(setq l2 (ss->lsto (ssget)))
(setq l3 (ss->lsto (ssget)))
(setq l4 (ss->lsto (ssget)))
(setq ans (mapcar '(lambda (a b c d) (list
	      (kd-get-textstring d)
	      (kd-get-textstring a)
	      (kd-get-textstring b)
	      (kd-get-textstring c)
	      )) l1 l2 l3 l4))
(lst>excel ans)





; �������� :
; ���� ����� ����� (����� �������������) ���� - ������������ ������� � ������������
; � ���� ����� ������ ���� - ��������� ������
; ��� ��� ���� � ���� �� ��������� ������ ��� �������, ������� ���� � ����������
; ������ ���� - ������ ���������� "� ���� ������������"
; ������ ���� ��������� ���� ������� - ���5� 1XT3


; 1  ��������� ���� �����������, ��������� ��� ������
(db|getdata 'db:head 'db:data)
; 1.1 ��������� ������ � ������ ������� �������

(setq src:head '("cbl_KKS" "cabinet" "clamp" "cab_type" "cores"))
(setq src:data
   (mapcar
     '(lambda (line)
	(mapcar
	  '(lambda (p)
	     (db|gpar p line)
	     )
	  src:head
	  )
	)
     (cdr db:data)
     )
  )
(setq src:table (cons src:head src:data))
;  1.2 ��������� ���� �����������

;  2 ��������� ���� �� - �����������
;  2.1  �������� � ����� ��� ��������� � ������ - �� ������� ����� ����� (������� ���������� �� ���������)


(setq excdata (db|formatdata (excel>lst)))
(setq cl:data (cdr excdata) cl:head (car excdata))


;  ������������ ������


(setq db:head cl:head db:data cl:data)
(setq cabtypeerrors '())
(setq newdata
(mapcar		; �� ���� �������� �����
  '(lambda (cab / cnum src ccab csigs)	;(setq cab (nth 1 cl:data))
     
     ;;  ���� ������ ��������� - ������� �� �����, �� ������������ + �������� �������, ����� - �������� ��� ����
     (if (setq cnum (db|gpar "cbl_KKS" cab))
       (progn
	 (setq src (cadr (tbl|filter src:table (strcat "cbl_KKS=" cnum))))
	 ;;  �������� �� ���������� ���� ������
	 (if src (if (or
		       (/= (nth (vl-position "cab_type" (car src:table)) src) (db|gpar "cab_type" cab))
		       (/= (nth (vl-position "cores" (car src:table)) src) (db|gpar "cores_cab" cab))
		       )
		   (setq cabtypeerrors (cons cnum cabtypeerrors))))
	 ;;;;
	 ;;  ���� ������ �������������, �� ������������, ����� - �������� ��� ����
	 (if (= "���� �����������" (db|gpar "place_cpu" cab))
	   (db|spar cab "place_cpu" (strcat "���� �����������kd:nl" (nth (vl-position "cabinet" (car src:table)) src) ;| (nth (vl-position "clamp" (car src:table)) src) |; ))
	   cab
	   )
	 )
       cab
       )
     )
  cl:data
  )
)



;;;  ������� ������ � ����� ����
(lst>excel newdata)
;;;   �������� �� ������ ����� � ������
;;;   ��� ����� ����� � ����� ������� ������ - ����� ��������� ��������������








;;;;;;;;;;       V2  ��������� �� ����� ����������� ������



(setq blreflst (ss->lsto* (ssget '(( 0 . "INSERT")))))

(setq src:table (tbl|blrefs>table blreflst))

(setq excdata (excel>lst))
(setq db:data (cdr excdata) db:head (car excdata))




(setq
  newdata
   (mapcar		; �� ���� �������� �����
     '(lambda (cab / cnum src ccab csigs)	;(setq cab (nth 1 db:data))
	;;  ���� ������ ��������� - ������� �� �����, �� ������������ + �������� �������, ����� - �������� ��� ����
	(if (setq cnum (db|gpar "cbl_KKS" cab))
	  (progn
	    (setq src (tbl|filter src:table (strcat "NUMBER=" cnum)))
	    ;;  �������� �� ���������� ���� ������
	    (if (cadr src)
	      (if
		(or
		  (/= (tbl|gpar (car src) (cadr src) "TYPE") (db|gpar "cab_type" cab))
		  (/= (tbl|gpar (car src) (cadr src) "CORES") (db|gpar "cores_cab" cab))
		  )
		(setq cabtypeerrors (cons cnum cabtypeerrors))))
	    ;;; TODO
	    
       (append cab (list
		     (tbl|gpar (car src) (cadr src) "LENGTH")
		     (tbl|gpar (car src) (cadr src) "NOTE")
		     ))
	    )
	  cab
       )
     )
  db:data
  )
)





;;;  ������� ������ � ����� ����
cabtypeerrors
(lst>excel newdata)
;;;   �������� �� ������ ����� � ������
;;;   ��� ����� ����� � ����� ������� ������ - ����� ��������� ��������������









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;   		����� ��������� ����� excel

;  2.1  �������� � ����� ��� ��������� � ������ - �� ������� ����� ����� (������� ���������� �� ���������)


(setq TG8 (db|formatdata0 (excel>lst)))

(setq newdata (db|formatdata0 (excel>lst)))



(setq added nil notadded nil)

(setq
  ans
   (mapcar
     '(lambda (line / ass)
	(if (setq ass (assoc (car line) newdata))
	  (progn
	    (setq added (cons ass added))
	    (append line ass)
	    )
	  (progn
	    (setq notadded (cons ass notadded))
	    line
	    )
	  )
	)
     TG8
     )
  )


(length TG8)
(length added)

(lst>excel ans)





(setq ans
(mapcar
  '(lambda (line / st)	;(setq line (nth 240 (cdr excdata)))
     (if
       (and
	 (setq st (tbl|gpar (car excdata) line "old_POZ"))
	 (/= st "")
	 (assoc st TG8)
	 )
       (progn
	 (setq added (cons st added))
	 (append line (assoc st TG8))
	 )
       (progn
	 (setq notadded (cons st notadded))
	 line
	 )
       )
     )
  (cdr excdata)
  )
      )



(length TG8)
(length added)

(vl-remove-if '(lambda (line) (member (car line) added) ) TG8)

(lst>excel ans)








; ������������� �������
(setq newdata (db|transmat excdata))

(setq
  newdata
   (mapcar
     '(lambda (col)
	; �� ������ ������
	;(mapcar '(lambda (cell) (str:antimtext (vl-string-trim " " cell))) col)
	)
     newdata
     )
  )




(setq
  newdata
   (mapcar
     '(lambda (col)
	(cond
	  ((member (car col) '("� ������������" "KKS_signal"))
	   (cons (car col) (mapcar '(lambda (cell) (norus cell))  (cdr col)))
	   )
	  ((member (car col) '("temp"))
	   (cons (car col) (mapcar '(lambda (cell) (norus cell))  (cdr col)))
	   )
	  (T
	   col
	   )
	  );cond
	)
     newdata
     )
  )


(setq
  newdata
   (db|transmat newdata)
  )



;;;  ������� ������ � ����� ����
(lst>excel newdata)
;;;   �������� �� ������ ����� � ������
;;;   ��� ����� ����� � ����� ������� ������ - ����� ��������� ��������������




(setq data (excel>lst))
(setq newdata (mapcarx norus nil data))
(lst>excel newdata)









;;;;;;;;		���������� ������ ����� ����� ������������ ���
;;;;;;;;		������� �����-������������ (������� ���������� ���������)


(setq exdata (db|formatdata (excel>lst)))
(length exdata)

(setq newdata '())
(setq cursystem "")
(setq condition '(strcat (nth 0 line) (nth 0 line)))


(foreach line exdata
  (if (/= cursystem (eval condition))
    (setq cursystem (eval condition)
	  newdata (cons '("") newdata)
	  )
    )
  (setq newdata (cons line newdata))
  )
(lst>excel (reverse newdata))


;;;	V2



(setq src (db|formatdata (excel>lst)))
(setq cursystem "")
(setq ans nil)


(foreach line src	;(setq line (nth 3 src))
  (setq clsys (cadr (sepstr* (nth 0 line))))
  (if (= cursystem clsys)
    (setq ans (cons line ans))
    (setq ans (cons line (cons '("") ans))
	  cursystem clsys)
    )
  )

(lst>excel (reverse ans))











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(db|getdata 'db:head 'db:data)

(setq base (db|formatdata0 (excel>lst)))
(setq db:data (cons "table" (cdr base)) db:head (car base))
;(setq TG8 (db|formatdata0 (excel>lst)))






(setq ans
       (mapcar
  '(lambda (line / N 8I Iotsfoto Irasch PKZM BOE RTZOp sufx)	;(setq line (nth 30 db:data))
     ;(db|gpar "st_POZ" line)
     (setq N (db|gpar "N" line))
     (setq 8I (atof* (db|gpar "8I���" line)))
     (setq Iotsfoto (atof* (db|gpar "I���" line)))

     (cond
       ((wcmatch N "*W") (setq N (/ (atof* (car (sepstr* N))) 1000)))
       (T (setq N (atof* N)))
       )
     (setq Irasch (#act|getIots N))
    
     (if (/= Irasch 0)
       (progn
	 (setq PKZM (car (vl-remove-if '(lambda (x) (< (car x) Irasch)) #PKZM:scale)))
	 (setq RTZOp (car (vl-remove-if '(lambda (x) (< (car x) Irasch)) #eir:rtzo:zakazI)))

	 (setq BOE
		(cond
		  ((= "valve" (db|gpar "type" line))
		   (if (> (car RTZOp) 26)
		     (progn (setq sufx "�") "5402")
		     (progn (setq sufx "�") "5401�")
		     ))
		  (T (setq sufx "�") "5413")
		  )
	       )
	 (append line (list (rtos* Irasch) (rtos* (car PKZM)) BOE (strcat (cadr RTZOp) "74" sufx)))
	 )
       line
       )
     )
  (cdr db:data)
  )
      )


(lst>excel ans)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq data (db|formatdata0 (excel>lst)))

(setq
  ans
   (mapcar
     '(lambda (line / x)	;(setq line (nth 14 data))
	(if (= "" (car line))
	  line
	  (progn
	    (setq x (atof* (car line)))
	    (append line (list
	    (strcat (cadr (assoc x #eir:rtzo:zakazI)) "74" 
	      (cond
		((= "5401�"(cadr line)) "�")
		((= "5413"(cadr line)) "�")
		((= "5402"(cadr line)) "�")
		(T "")
		)
	      )
	    ))
	    )
	  )
	)
     data
     )
   )

(lst>excel ans)






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq data (db|formatdata0 (excel>lst)))

(setq
  ans
   (mapcar
     '(lambda (line / x PKZM)	;(setq line (nth 14 data))
	(if (= "" (car line))
	  line
	  (progn
	    (setq x (atof* (car line)))
	    (setq PKZM (car (vl-remove-if '(lambda (rang) (> x (car rang))) #PKZM:scale)))
	    
	    (append
	      line
	      (list
		;��-140/##
		(rtos* (car (vl-remove-if '(lambda (c) (< c x)) #RT140:scale)))
		;��12
		(strcat "��12-" (cadr (car (vl-remove-if '(lambda (rang) (< (car rang) x)) #PM12:scale))))
		;PKZM
		(strcat "PKZM" (nth 1 PKZM) "-" (nth 2 PKZM) " 3�, I�.�.=" (nth 3 PKZM))
		)
	      )
	    )
	  )
	)
     data
     )
   )

(lst>excel ans)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(tbl|getdata 'base)



(setq lst (ss->lsto* (ssget "_I")))
(length lst)

(setq blks
(vl-remove-if
  '(lambda (x)
     (= "" (kd-get-textstring (getbatt x "$OLD_POZ")))
     )
  lst
  )
)


(setq dwgpozs (mapcar '(lambda (x) (kd-get-textstring (getbatt x "$OLD_POZ"))) blks))
(length dwgpozs)
(length (origlist dwgpozs))
(length (deoriglist dwgpozs))



(setq present nil absent nil many nil)

(mapcar
  '(lambda (x / poz res)
     (setq poz (kd-get-textstring (getbatt x "$OLD_POZ")))
     (setq res (tbl|filter base (strcat "st_POZ=" poz)))
     (cond
       ((= 2 (length res)) (setq present (cons poz present)))
       ((null res) (setq absent (cons poz absent)))
       (T (setq many (cons poz many)))
       )
     )
  blks
  )

(length present)



(setq added nil notadded nil)

(setq
  ans
   (mapcar
     '(lambda (line / ass)
	(if (setq ass (assoc (car line) newdata))
	  (progn
	    (setq added (cons ass added))
	    (append line ass)
	    )
	  (progn
	    (setq notadded (cons ass notadded))
	    line
	    )
	  )
	)
     TG8
     )
  )


(length TG8)
(length added)

(lst>excel ans)






;;;;		����������� 1 �������
(setq lst (mapcar 'car (excel>lst)))
(setq res (mapcar '(lambda (x) (norus (vl-string-subst "" " " x ))) lst))
(lst>excel (mapcar 'list res))





(setq prjData (mapcar 'car (excel>lst)))

(setq res (mapcar '(lambda (x)	;(setq x (nth 22 prjData))
		     (antisep
		       (mapcar
			 '(lambda (str / l)	;(setq str (nth 2 (sepstr x ", ")))
			    (setq l (sepstr* str))
			    (antisep (if (= "11" (car l)) (cons "12" (cdr l)) l) "")
			    )
			 (sepstr x ",\P")
			 )
		       ",\P"
		       )
		     ) prjData))
(lst>excel (mapcar 'list res))








(setq prjData (excel>lst))

(setq res
       (mapcar
	 '(lambda (line)
	    (mapcar '(lambda (x)	;(setq x (nth 22 prjData))
		       (antisep
			 (mapcar
			   '(lambda (str / l)	;(setq str (nth 2 (sepstr x ", ")))
			      (setq l (sepstr* str))
			      (antisep (if (= "11" (car l)) (cons "12" (cdr l)) l) "")
			      )
			   (sepstr x ", ")
			   )
			 ", "
			 )
		       ) line)
	    )
	 prjData
	 )
      )
(lst>excel  res)








(setq source (db|formatdata (excel>lst)))
(setq res (apply 'append
(mapcar
  '(lambda (line / head tail)	;(setq line (nth 26 source))
     (setq tail (cdr (cdr line)))
     (setq head (cadr line))
     (while (/= head (setq head (vl-string-subst "" " " head))))

     (mapcar
       '(lambda (item) (cons (car line) (cons item tail)))
       (apply 'append (mapcar '(lambda (g) (sepstr g "/")) (vl-remove '"" (sepstr head "\n"))))
       )
     )
  source)))

(lst>excel res)








(setq source (vl-remove '"" (origlist (mapcar 'car (excel>lst)))))




(setq #excel (vlax-get-object "Excel.Application"))
(setq #selection (vlax-get-Property #excel "Selection"))


(setq #range (vlax-get-property #selection "Range" (strcat "A" (itoa 1))))
(setq val (variantextraction (vlax-get-property #range "Value2")))
(if (member val source)
  (vlax-put-property (vlax-get-property #range "Font") "Background" 3)
  )


(while (setq #range (vlax-get-property #range "Next"))
  (setq val (variantextraction (vlax-get-property #range "Value2")))
(if (member val source)
  (vlax-put-property (vlax-get-property #range "Font") "Background" 3)
  )
  
  )


(setq nl 0)

(foreach line lst
    (setq #range (vlax-get-property #selection "Range" (strcat "A" (itoa (setq nl (1+ nl))))))
    (foreach str line
      (vlax-put-property #range "Value2" str)
      (setq #range (vlax-get-property #range "Next"))
      )
    )




  (mapcar
    (function (lambda (x) (if (not (vlax-object-released-p x)) (vlax-release-object x))))
    (list #range #selection #excel)); ����������� � �������� �������
  (setq	#range nil #selection nil #excel nil)














(setq #excel (vlax-get-object "Excel.Application"))
(setq #selection (vlax-get-Property #excel "Selection"))






