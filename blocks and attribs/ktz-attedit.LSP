;;; �������� 10_04_06
;;; ����� ��� ��������� �������������� ������� ��������� �����
;;; ������������ ��� ���������� ���� �� �4 ������
;;; -kakt00z-�  �
;;; �������: �������, �������, ������� ������, ������ ������









(defun c:kd:attedit ( /
		     lst
		     tags tag
		     list-of-properties
		     property
		     value
		     )

  (setq
    list-of-properties
     '(
       "Alignment"		; = 12
       "Backward"		; = 0
       "Height"			; = 250.0
       "Invisible"		; = 0
       "Layer"			; = "com_formats"
       "Linetype"		; = "ByLayer"
       "LinetypeScale"		; = 1.0
       "Lineweight"		; = -3
       "MTextAttribute"		; = 0
       "MTextAttributeContent"	; = ""
       "MTextBoundaryWidth"	; = 0.0
       "MTextDrawingDirection"	; = 5
       "ObliqueAngle"		; = 0.0
       "Rotation"		; = 0.0
       "ScaleFactor"		; = 1.0
       "StyleName"		; = "BNP"
       ;"TextGenerationFlag"	; = 0
       "TextString"		; = "�����������"
       "Thickness"		; = 0.0
       "UpsideDown"		; = 0
       "Visible"		; = -1
       "Color"
       )
    )

  (setq lst (ss:getBRefs nil))
  (setq tags (origlist (apply 'append (mapcar '(lambda (bref) (mapcar 'vla-get-tagstring (getbattswcmatch bref "*"))) lst))))
  (setq tag (kd:dcl:pick-from-list tags))
  (setq lst (vl-remove 'nil (mapcar '(lambda (bref) (getbatt bref tag)) lst)))
  (setq property (kw:pick-from-list list-of-properties))

  (cond
    ((= "Layer" property)
     (setq value (kd:dcl:pick-from-list (mapcar 'vla-get-name (cont>list (vla-get-layers #actdoc)))))
     )
    (T (setq value (atof* (car (kd:dclget (list property))))))
    )

  
  
  (mapcar
    '(lambda (att)	;(setq att (car lst))
       (vlax-put-property att property value)
       ) lst)
  (princ)
  );defun



  



(defun c:MR ( / lnames obj lname)
  (setq lname "com_rev3")
  (if (null (member lname (setq lnames (mapcar 'vla-get-name (cont>list (vla-get-layers #actdoc))))))
    (setq lname (kd:dcl:pick-from-list lnames))
    )
  
  (while (setq obj (nentsel))
    (setq obj (vlax-ename->vla-object (car obj)))
    (vlax-put-property obj "layer" lname)
    (vlax-put-property obj "color" 256)
    (vlax-put-property obj "Lineweight" -1)
    )
  );defun


(defun c:MRREMOVE ( / obj lname)
  (setq lname "0")
  (while (setq obj (nentsel))
    (setq obj (vlax-ename->vla-object (car obj)))
    (vlax-put-property obj "layer" lname)
    (vlax-put-property obj "color" 255)
    (vlax-put-property obj "Lineweight" -2)
    )
  );defun














;;; 			VLA-GET-ATTRIBUTES












(defun c:ktz-attedit (
		  /
		  i
		  j
		  ss
		  attlist
		  str-init
		  str2-init
		  str-kword
		  att-cur-name
		  n-att
		  ent
		  pp
		  eng
		  prop

		  pt
		  ptnew
		  pt1
		  pt2
		  dpt

		  atteng
		  cmd
		  tmp
		  )


    (setq	assoc-list
	 '(
	   "����������"
	   "�����-��������"
	   "��������-���������"
	   "�����"
	   "����"
	   "�������"
	   "������-������"
	   "�������-������"
	   "�������"
	   "�������-������"
	   "����"
	   "��������-������"
	   "�������-�����-�100"
	   "���-�����"
	   "������-������"
	   )
	);setq
 
  (setq
    i		1
    attlist	'()
    str-init	""
    str2-init	""
    str-kword	""
    att-cur-name nil
    );setq
    
	

 (if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
   (setq ss (ssget '((0 . "INSERT"))))
   );if

  (setq ent (entnext (ssname ss 0)))
  ;;;**************************************
      (while
      (/= (cdr (assoc 0 (entget ent))) "SEQEND")
       (setq att-cur-name (cdr (assoc 2 (entget ent))))
       (setq str-init (strcase (strcat str-init (vl-string-subst "-" "_" att-cur-name) " ") t))
       (setq str-kword (strcase (strcat str-kword (vl-string-subst "-" "_" att-cur-name) "/") t))
       (setq str2-init (strcat str2-init (itoa i) " "))
       ;(setq attlist (append attlist (list (cons i att-cur-name))))
       (setq ent (entnext ent))
       (setq i (1+ i))
    );while
  
  (setq str-init (strcat str-init "���"))
  (setq str-kword (strcat str-kword "���"))
  (setq str2-init (strcat str2-init "999"))
  
  (setq str-kword (vl-string-right-trim "/" str-kword))
  (initget (strcat str-init " _" str2-init))
  (setq n-att (atoi (getkword (strcat "\n ������� �������� \n[" str-kword "] :"))))


  (setq
    str-init	""
    str2-init	""
    str-kword	""
    )


  

(setq ent (ssname ss 0))
(repeat n-att (setq ent (entnext ent)))
(setq i 0)


  (foreach pp assoc-list
    (setq
	str-init  (strcat str-init " " pp)
	str-kword (strcat str-kword pp "/")
	);setq 
    );foreach
  (setq str-kword (vl-string-right-trim "/" str-kword))
  (setq str-init (vl-string-left-trim " " str-init))
  (initget str-init)
  (setq prop (getkword (strcat "������� �������� [" str-kword "] :")))


  (cond
    ;�������
    ((= prop "�������")
     (progn
       (setq pt2 (getpoint (setq pt1 (getpoint "\n�� �����")) "\n� �����"))
       (setq dpt (mapcar '- pt1 pt2))
       ;(setq dpt (vec-dif pt1 pt2))
       (setq cmd '(progn
		   (setq pt (cdr (assoc 11 atteng)))
		   (setq ptnew (mapcar '- pt dpt))
		   (setq atteng (subst (cons 11 ptnew) (assoc 11 atteng) atteng)))
	     );cmd
       );progn
     )
    ;������ ������
    ((= prop "������-������")
     (progn
       (setq tmp (getreal "������� ����� ������ ������ : "))
       (setq cmd '(setq atteng (subst (cons 40 tmp) (assoc 40 atteng) atteng)))
       );progn
     )
    ;�������-������
    ((= prop "�������-������")
     (progn
       (setq tmp (getreal "������� ����� ������� ������ : "))
       (setq cmd '(setq atteng (subst (cons 41 tmp) (assoc 41 atteng) atteng)))
       );progn
     )
    ;������-������
    ((= prop "������-������")
     (progn
       (setq tmp (getreal "������� ������ ������ [-1.4...1.4] : "))
       (setq cmd '(setq atteng (subst (cons 51 tmp) (assoc 51 atteng) atteng)))
       );progn
     )
    
    ;�������-������
    ((= prop "�������-������")
     (progn
       (setq tmp (/ (* (getreal "������� ���� �������� � ��������: ") Pi) 180))
       (setq cmd '(setq atteng (subst (cons 50 tmp) (assoc 50 atteng) atteng)))
       );progn
     )
    ;����
    ((= prop "����")
     (progn
         (setq
	   str-init	""
	   str2-init	'()
	   str-kword	""
	   i	1
	   )
       (setq pt (tblnext "layer" T))
       (while pt
	 (setq str-init (strcat str-init (vl-string-subst "-" "_" (strcase (cdr (assoc 2 pt)) T)) " "))
	 (setq str2-init (append str2-init (list (cons i (cdr (assoc  2 pt))))))
	 (setq str-kword (strcat str-kword (vl-string-subst "-" "_" (strcase (cdr (assoc 2 pt)) T)) "/"))
	 (setq pt (tblnext "layer" nil))
	 (setq i (1+ i))
       	 );while
       (setq str-kword (vl-string-right-trim "/" str-kword))
       (setq str-init (vl-string-left-trim " " str-init))
       (setq i 1
	     cmd "")
       (repeat (length str2-init)
	 (setq cmd (strcat cmd " " (itoa i)))
	 (setq i (1+ i))
	 )
       (initget 1 (strcat str-init " _" cmd))
       (setq tmp (getkword (strcat "������� ���� [" str-kword "] :")))
       (setq cmd '(setq atteng (subst (cons 8 (cdr (assoc (atoi tmp) str2-init)))
				(assoc 8 atteng)
				atteng)))
       );progn
     )
    ;����    
    ((= prop "����")
     (progn
       (setq tmp (getint "������� ����� ���� : "))
       (if tmp
	 (setq cmd '(setq atteng (subst (cons 62 tmp) (assoc 62 atteng) atteng)))
	 (setq cmd '(setq atteng (vl-remove (assoc 62 atteng) atteng)))
	 )
       (princ tmp)
       );progn
     )
    
    ((= prop "�������-�����-�100")
     (progn
       (setq tmp (fix (* (getreal "������� ����� ������� : ") 100)))
       (if tmp
	 (setq cmd '(if (assoc 370 atteng)
		     (setq atteng (subst (cons 370 tmp) (assoc 370 atteng) atteng))
		     (setq atteng (append atteng (list (cons 370 tmp))))
		     )
	       )
	 (setq cmd '(setq atteng (vl-remove (assoc 370 atteng) atteng)))
	 )
       (princ tmp)
       );progn
     )



    ((= prop "��������-������")
     (progn
       (setq tmp (getint "������� ����� ��������(6-UL;14-BR) : "))
       (setq cmd '(progn
		   ;(setq atteng (entget (car (nentsel))))
		   (setq atteng (vlax-ename->vla-object (cdr (assoc -1 atteng))))
		   (vla-put-Alignment atteng tmp)
		   (setq atteng (entget (vlax-vla-object->ename atteng)))
		   ))
       );progn
     )

    


    (T (alert "\n�������� �� ������� � ���������"))
    
    );cond

  (setq i 0)
  (repeat (sslength ss)
    (setq ent (ssname ss i))
    (repeat n-att (setq ent (entnext ent)))
    (setq atteng (entget ent))
    (eval cmd)
    (entmod atteng)
    (entupd ent)
    (setq i (1+ i))
    );repeat
  (princ)
  );defun








;;;		�������������� ��������� � �������� �����
;;;(mapcar
;;;  '(lambda (x / att)	;(setq x (vlax-ename->vla-object (car (entsel))))
;;;     (setq att
;;;     (vl-remove-if-not
;;;       '(lambda (o)
;;;	  (and
;;;	    (= "AcDbAttributeDefinition" (vla-get-objectname o))
;;;	    (= "LEV" (vla-get-TagString o))
;;;	    )
;;;	  )
;;;       (cont>list (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName x)))
;;;       ))
;;;     (cond
;;;       ((= 1 (length att))
;;;	(setq att (car att))
;;;	(vla-put-TextString att "###")
;;;	(vla-put-PromptString att "LevelMark")
;;;	)
;;;       )
;;;     )
;;;  (ss->lsto* (ssget))
;;;  )




;;;(defun c:asd ( / bnames propertyName propertyValue)
;;;
;;;(setq bnames '("RU_format"))
;;;(setq propertyName "ScaleFactor")
;;;(setq propertyValue 0.9)
;;;
;;;
;;;(setq lst (SS:GETBREFS bnames))
;;;(length lst)
;;;(setq tags (kd:dcl:pick-from-list (mapcar 'vla-get-tagstring (getbattswcmatch (car lst) "*"))))
;;;(mapcar
;;;  '(lambda (b)
;;;     (mapcar
;;;       '(lambda (tag)
;;;	  (apply
;;;	    (read (strcat "vla-put-" propertyName))
;;;	    (list
;;;	      (getbatt b tag) propertyValue)
;;;	    )
;;;	  )
;;;       tags)
;;;     )
;;;  lst)
;;;  );defun