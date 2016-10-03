;		15_06_23





;;;
;;;(defun c:rev ( / catchit lst)
;;;  (if (not (setq lst (ssget "_I" '((0 . "LINE")))))
;;;    (setq lst (vl-catch-all-apply 'ssget (list '((0 . "LINE")))))
;;;    )
;;;  (cond
;;;    ((= 'VL-CATCH-ALL-APPLY-ERROR (type lst)) (VL-CATCH-ALL-ERROR-MESSAGE lst))
;;;    ((null lst) (princ))
;;;    ((= 'PICKSET (type lst))
;;;     (setq lst (ss->lsto* lst))
;;;     (mapcar 'reverseline lst)
;;;     )
;;;    );cond
;;;  );defun
;;;





(defun c:ktz-pick (/
		   ss
		   en-prop
		   ent
		   entg
		   str-init		; строка для initget
		   str-kword		; строка для getkword
		   pp			; point pare
		   npp			; номер pp
		   npp-list		; список номеров точечных пар
		   flag
		   assoc-list		; список проверяемых точечных пар
					; для выбора блоков
		   bl-name		; effective name блока
		   ss1	     i
		   			; для выбора по длине
		   dlina


		  
		   )

  ;(ktz-load)
  ;(vl-load-com)

  (setq	assoc-list
	 '(
	   (0 . "ObjectType")
	   (1 . "Contents")
	   (360 . "Contents2")
	   (2 . "BlockName")
	   (6 . "LineType")
	   ;(7 . "шрифт")
	   (8 . "Layer")
	   (10 . "Length")
	   (11 . "Y=Y")
	   (40 . "Height/Radius")
	   (41 . "WidthFactor")
	   (48 . "Scale")
	   (50 . "Rotation")
	   (62 . "Color")
	   (66 . "HasAttributes")
	   (71 . "Mtext-Justify")
	   (72 . "text-Justify")
	   (370 . "LineWeight-х100")

	   )
	);setq



 

  (if (not (setq ss (ssget "_I")))
    (setq ss (vl-catch-all-apply 'ssget))
    )

  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type ss)) (VL-CATCH-ALL-ERROR-MESSAGE ss))
    ((null ss) (princ))
    ((and
       (= 'PICKSET (type ss))
       (= 'LIST (type (setq en-prop (vl-catch-all-apply 'entsel (list "\nSelect Object for filter option...")))))
       )
     (setq en-prop (car en-prop))
     (setq entg (entget en-prop))
     (if (null (assoc 62 entg))
       (setq entg (cons '(62 . 256) entg))
       )
     (setq str-init "")
     (setq npp-list "")
     (setq str-kword "")
     (foreach pp entg
       (if (assoc (car pp) assoc-list)
	 (setq str-init  (strcat str-init " " (cdr (assoc (car pp) assoc-list)))
	       str-kword (strcat str-kword "/" (cdr (assoc (car pp) assoc-list)))
	       npp-list  (strcat npp-list " " (itoa (car pp)))
	       )
	 )
       )
     (setq str-kword (vl-string-left-trim "/" str-kword))
     (setq str-kword (strcat "Какое свойство аттрибута изменить?  : ["
			     str-kword
			     "] <ObjectType>"
			     ))
     (initget 1 (strcat str-init " _" npp-list))
     (setq flag (atoi (getkword str-kword)))


     (cond
       ((= flag 2)
	(setq ss (ssget "_P" '((0 . "INSERT"))))
	(setq bl-name (vla-get-EffectiveName (vlax-ename->vla-object en-prop)))
	(setq i 0 ss1 (ssadd))
	(repeat (sslength ss)
	  (if (= bl-name (vla-get-EffectiveName (vlax-ename->vla-object (setq ent (ssname ss i)))))
	    (setq ss1 (ssadd ent ss1))
	    )
	  (setq i (1+ i))
	  )
	(sssetfirst nil ss1)
	)


       ((= flag 3)
	(setq 	ss	(ssget "_P" '((0 . "*TEXT")))
		bl-name (getstring "\nвведите ключевые символы: \n")
		i	0
		ss1	(ssadd)
		) ;_ конец setq

       (repeat (sslength ss)
	 (if
	   (wcmatch (cdr (assoc 1 (entget (setq ent (ssname ss i))))) bl-name)
	   (setq ss1 (ssadd ent ss1))
	   );if
	 (setq i (1+ i))
	 );repeat
       (sssetfirst nil ss1)
       )
    
     
    ((= flag 10)
     (progn
       (setq ss (ssget "_P" '((0 . "LINE"))))
       (defun dlin (en
		    /
		    p10
		    p11)
	 (setq p10 (cdr (assoc 10 (entget en))))
	 (setq p11 (cdr (assoc 11 (entget en))))
	 (sqrt (+ (expt (- (car p11) (car p10)) 2)
		  (expt (- (cadr p11) (cadr p10)) 2) ))
	 );defun
       (setq dlina	(dlin en-prop)
	     i		0
	     ss1	(ssadd)
	     ) ;_ конец setq

       (repeat (sslength ss)
	 (if (=	dlina (dlin (ssname ss i)))
	   (setq ss1 (ssadd (ssname ss i) ss1))
	   );if
	 (setq i (1+ i))
	 );repeat
       (sssetfirst nil ss1)
     ));progn
    (T   (sssetfirst nil (ssget "_P" (list (assoc flag entg)))))
    );cond

     )
    );cond ss
  );defun










;;;
;;;(defun c:ktz-pick (/
;;;		   ss
;;;		   en-prop
;;;		   ent
;;;		   entg
;;;		   str-init		; строка для initget
;;;		   str-kword		; строка для getkword
;;;		   pp			; point pare
;;;		   npp			; номер pp
;;;		   npp-list		; список номеров точечных пар
;;;		   flag
;;;		   assoc-list		; список проверяемых точечных пар
;;;					; для выбора блоков
;;;		   bl-name		; effective name блока
;;;		   ss1	     i
;;;		   			; для выбора по длине
;;;		   dlina
;;;
;;;
;;;		   filterNames
;;;		   )
;;;
;;;  ;(ktz-load)
;;;  ;(vl-load-com)
;;;
;;;  (setq	assoc-list
;;;	 '(
;;;	   (0 . "ObjectType")
;;;	   (1 . "Contents")
;;;	   (360 . "Contents2")
;;;	   (2 . "BlockName")
;;;	   (6 . "LineType")
;;;	   ;(7 . "шрифт")
;;;	   (8 . "Layer")
;;;	   (10 . "Length")
;;;	   (11 . "Y=Y")
;;;	   (40 . "Height/Radius")
;;;	   (41 . "WidthFactor")
;;;	   (48 . "Scale")
;;;	   (50 . "Rotation")
;;;	   (62 . "Color")
;;;	   (66 . "HasAttributes")
;;;	   (71 . "Mtext-Justify")
;;;	   (72 . "text-Justify")
;;;	   (370 . "LineWeight-х100")
;;;
;;;	   )
;;;	);setq
;;;
;;;
;;;  (setq filterNames
;;;	 '("ObjectType"
;;;	   	   "Contents"
;;;	   "Contents2"
;;;	   "BlockName"
;;;	 "LineType"
;;;
;;;"Layer"
;;;"Length"
;;;	  "Y=Y"
;;;	 "Height/Radius"
;;;	 "WidthFactor"
;;; "Scale"
;;;"Rotation"
;;;	    "Color"
;;;	 "HasAttributes"
;;;	 "Mtext-Justify"
;;; "text-Justify"
;;; "LineWeight-х100"
;;;	   )
;;;	 )
;;;
;;;
;;; 
;;;
;;;  (if (not (setq ss (ssget "_I")))
;;;    (setq ss (vl-catch-all-apply 'ssget))
;;;    )
;;;
;;;  (cond
;;;    ((= 'VL-CATCH-ALL-APPLY-ERROR (type ss)) (VL-CATCH-ALL-ERROR-MESSAGE ss))
;;;    ((null ss) (princ))
;;;    ((and
;;;       (= 'PICKSET (type ss))
;;;       (= 'LIST (type (setq en-prop (vl-catch-all-apply 'entsel (list "\nSelect Object for filter option...")))))
;;;       )
;;;     (setq en-prop (car en-prop))
;;;     (setq entg (entget en-prop))
;;;     (if (null (assoc 62 entg))
;;;       (setq entg (cons '(62 . 256) entg))
;;;       )
;;;     (setq str-init "")
;;;     (setq npp-list "")
;;;     (setq str-kword "")
;;;     (foreach pp entg
;;;       (if (assoc (car pp) assoc-list)
;;;	 (setq str-init  (strcat str-init " " (cdr (assoc (car pp) assoc-list)))
;;;	       str-kword (strcat str-kword "/" (cdr (assoc (car pp) assoc-list)))
;;;	       npp-list  (strcat npp-list " " (itoa (car pp)))
;;;	       )
;;;	 )
;;;       )
;;;     (setq str-kword (vl-string-left-trim "/" str-kword))
;;;     (setq str-kword (strcat "Какое свойство аттрибута изменить?  : ["
;;;			     str-kword
;;;			     "] <ObjectType>"
;;;			     ))
;;;     (initget 1 (strcat str-init " _" npp-list))
;;;     (setq flag (atoi (getkword str-kword)))
;;;
;;;
;;;     (cond
;;;       ((= flag 2)
;;;	(setq ss (ssget "_P" '((0 . "INSERT"))))
;;;	(setq bl-name (vla-get-EffectiveName (vlax-ename->vla-object en-prop)))
;;;	(setq i 0 ss1 (ssadd))
;;;	(repeat (sslength ss)
;;;	  (if (= bl-name (vla-get-EffectiveName (vlax-ename->vla-object (setq ent (ssname ss i)))))
;;;	    (setq ss1 (ssadd ent ss1))
;;;	    )
;;;	  (setq i (1+ i))
;;;	  )
;;;	(sssetfirst nil ss1)
;;;	)
;;;
;;;
;;;       ((= flag 3)
;;;	(setq 	ss	(ssget "_P" '((0 . "*TEXT")))
;;;		bl-name (getstring "\nвведите ключевые символы: \n")
;;;		i	0
;;;		ss1	(ssadd)
;;;		) ;_ конец setq
;;;
;;;       (repeat (sslength ss)
;;;	 (if
;;;	   (wcmatch (cdr (assoc 1 (entget (setq ent (ssname ss i))))) bl-name)
;;;	   (setq ss1 (ssadd ent ss1))
;;;	   );if
;;;	 (setq i (1+ i))
;;;	 );repeat
;;;       (sssetfirst nil ss1)
;;;       )
;;;    
;;;     
;;;    ((= flag 10)
;;;     (progn
;;;       (setq ss (ssget "_P" '((0 . "LINE"))))
;;;       (defun dlin (en
;;;		    /
;;;		    p10
;;;		    p11)
;;;	 (setq p10 (cdr (assoc 10 (entget en))))
;;;	 (setq p11 (cdr (assoc 11 (entget en))))
;;;	 (sqrt (+ (expt (- (car p11) (car p10)) 2)
;;;		  (expt (- (cadr p11) (cadr p10)) 2) ))
;;;	 );defun
;;;       (setq dlina	(dlin en-prop)
;;;	     i		0
;;;	     ss1	(ssadd)
;;;	     ) ;_ конец setq
;;;
;;;       (repeat (sslength ss)
;;;	 (if (=	dlina (dlin (ssname ss i)))
;;;	   (setq ss1 (ssadd (ssname ss i) ss1))
;;;	   );if
;;;	 (setq i (1+ i))
;;;	 );repeat
;;;       (sssetfirst nil ss1)
;;;     ));progn
;;;    (T   (sssetfirst nil (ssget "_P" (list (assoc flag entg)))))
;;;    );cond
;;;
;;;     )
;;;    );cond ss
;;;  );defun
;;;



















