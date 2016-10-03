;;; прога для копирования одной линии текстов в другую

;(load "d:\\LISP WORKING\\common functions\\ss-to-lst.LSP")

;;;;;  12_11_27
(defun c:tlfc ( /
	       ss1
	       ss2
	       srcl
	       destl
	       srcatttag
	       destatttag	       
	       )
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		)T))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (princ "\n Select source array...   :")
;;;  (if (and (not (setq ss1 (ssget "_I" '((0 . "*TEXT,INSERT")))))
;;;	  (null (setq ss1 (ssget '((0 . "*TEXT,INSERT"))))))
;;;    (exit))
;;;  (setq ss1 (ss->list ss1))
;;;  (setq srcl (mapcar 'vlax-ename->vla-object ss1))
;;;  (if (= "AcDbBlockReference" (vla-get-ObjectName (car srcl)))
;;;    (setq srcatttag
;;;	(kd:dcl:pick-from-list
;;;	  (mapcar 'vla-get-TagString (vlax-safearray->list(vlax-variant-value
;;;		(vla-GetAttributes (car srcl))
;;;		))))
;;;	  srcl (mapcar '(lambda (x) (getbatt x srcatttag)) srcl)
;;;	  )
;;;    );if
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq srcl (get-ssofstrobj))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (princ "\n Now select destination array...   :")
;;;  (if (and (not (setq ss2 (ssget "_I" '((0 . "*TEXT,INSERT")))))
;;;	  (null (setq ss2 (ssget '((0 . "*TEXT,INSERT"))))))
;;;    (exit))
;;;  (setq ss2 (ss->list ss2))
;;;  (setq destl (mapcar 'vlax-ename->vla-object ss2))
;;;  (if (= "AcDbBlockReference" (vla-get-ObjectName (car destl)))
;;;    (setq destatttag
;;;	(kd:dcl:pick-from-list
;;;	  (mapcar 'vla-get-TagString (vlax-safearray->list(vlax-variant-value
;;;		(vla-GetAttributes (car destl))
;;;		))))
;;;	  destl (mapcar '(lambda (x) (getbatt x destatttag)) destl)
;;;	  )
;;;    );if
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq destl (get-ssofstrobj))
  (mapcar '(lambda (s d)
      (vla-put-TextString d (vla-get-TextString s))
	     ) srcl destl)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (acet-error-restore)
  (vla-endundomark #actdoc)
  )












;;;;;  13_01_25
(defun c:tlfcf ( /
	       ss1
	       ss2
	       srcl
	       destl
	       srcatttag
	       destatttag	       
	       )
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		)T))
  (princ "\n Select source array...   :")
  (setq srcl (get-ssofstrobj))
  (princ "\n Now select destination array...   :")
  (setq destl (get-ssofstrobj))
  (mapcar '(lambda (s d)
      (vla-put-TextString d
	(strcat
	  "%<\\AcObjProp Object(%<\\_ObjId "
	  (itoa (vla-get-objectID s))
	  ">%).TextString>%"
	  )
	)) srcl destl)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  )











;;;;old
(defun c:tlfcold ( / ss1 ss2)
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		)T))
  (princ "\n Select source array...   :")
  (if (and (not (setq ss1 (ssget "_I" '((0 . "*TEXT,INSERT")))))
	  (null (setq ss1 (ssget '((0 . "*TEXT,INSERT"))))))
    (exit))
  (setq ss1 (ss->list ss1))
  (princ "\n Now select destination array...   :")
  (if (and (not (setq ss2 (ssget "_I" '((0 . "*TEXT,INSERT")))))
	  (null (setq ss2 (ssget '((0 . "*TEXT,INSERT"))))))
    (exit))
  (setq ss2 (ss->list ss2))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;(CopyTextLine ss1 ss2)
  (txtlinefillcopy ss1 ss2)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun















;;; 12_11_27
(defun txtlinefillcopy (ss1 ss2
			/
			srcl destl
			srcatttag destatttag
			)
  (setq srcl (mapcar 'vlax-ename->vla-object ss1))
  (setq destl (mapcar 'vlax-ename->vla-object ss2))
  (if (= "AcDbBlockReference" (vla-get-ObjectName (car srcl)))
    (setq srcatttag
	(kd:dcl:pick-from-list
	  (mapcar 'vla-get-TagString (vlax-safearray->list(vlax-variant-value
		(vla-GetAttributes (car srcl))
		))))
	  srcl (mapcar '(lambda (x) (getbatt x srcatttag)) srcl)
	  )
    );if
  (if (= "AcDbBlockReference" (vla-get-ObjectName (car destl)))
;;;    (setq destatttag
;;;	(kd:dcl:pick-from-list
;;;	  (mapcar 'vla-get-TagString (vlax-safearray->list(vlax-variant-value
;;;		(vla-GetAttributes (car destl))
;;;		))))
;;;	  destl (mapcar '(lambda (x) (getbatt x destatttag)) destl)
;;;	  )
    (setq destatttag (getstring "\nВедите tag аттрибута")
	  destl (mapcar '(lambda (x) (getbatt x destatttag)) destl))
    );if
  (mapcar '(lambda (s d)
	     (vla-put-TextString d (vla-get-TextString s))
	     ) srcl destl)
  );defun


;;; 13_01_25
(defun txtlinefillcopyfield (ss1 ss2
			/
			srcl destl
			srcatttag destatttag
			)
  (setq srcl (mapcar 'vlax-ename->vla-object ss1))
  (setq destl (mapcar 'vlax-ename->vla-object ss2))
  (if (= "AcDbBlockReference" (vla-get-ObjectName (car srcl)))
    (setq srcatttag
	(kd:dcl:pick-from-list
	  (mapcar 'vla-get-TagString (vlax-safearray->list(vlax-variant-value
		(vla-GetAttributes (car srcl))
		))))
	  srcl (mapcar '(lambda (x) (getbatt x srcatttag)) srcl)
	  )
    );if
  (if (= "AcDbBlockReference" (vla-get-ObjectName (car destl)))
;;;    (setq destatttag
;;;	(kd:dcl:pick-from-list
;;;	  (mapcar 'vla-get-TagString (vlax-safearray->list(vlax-variant-value
;;;		(vla-GetAttributes (car destl))
;;;		))))
;;;	  destl (mapcar '(lambda (x) (getbatt x destatttag)) destl)
;;;	  )
    (setq destatttag (getstring "\nВедите tag аттрибута")
	  destl (mapcar '(lambda (x) (getbatt x destatttag)) destl))
    );if
  
    
  (mapcar '(lambda (s d)
      (vla-put-TextString d
	(strcat
	  "%<\\AcObjProp Object(%<\\_ObjId "
	  (itoa (vla-get-objectID d))
	  ">%).TextString>%"
	  )
	)) srcl destl)
  );defun

















(defun CopyTextLine (source-list
                     edit-list
                     /
		ent
		eng
		i
		ID
		txt
		n-att1
		n-att2
		)
    (setq i 0)

    (setq
      n-att1	0
      n-att2	0
      kratnost    	1
      ) ;_ setq

  (if (= "INSERT" (cdr (assoc 0 (entget (car source-list)))))
    (setq n-att1 (getint "\nУкажите поядковый номер аттрибута исходников....:"))
    )

  (if (= "INSERT" (cdr (assoc 0 (entget (car edit-list)))))
    (setq n-att2 (getint "\nУкажите поядковый номер аттрибута приемников....:"))
    )
  


;;;============================================================
;;; условие проверки соответствия двух наборов по количеству элементов
;;;============================================================  

  (if (= (length source-list) (* (length edit-list) kratnost))
 ;then


;;;============================================================
;;; повторяем проход по наименьшему списку
;;;============================================================  

    (repeat (length edit-list)
      
;;; если надо без поля
      (setq ID (nth i source-list))
      (repeat n-att1 (setq ID (entnext ID)))
      (setq txt (cdr (assoc 1 (entget ID))))

;;;============================================================
;;; если надо извлекать текст из первого аттрибута блока
 ;(setq txt (cdr (assoc 1 (entget (entnext (car (nth i source-list)))))))

;;;============================================================
;;; если надо извлекать текст из второго аттрибута блока
 ;(setq txt (cdr (assoc 1 (entget (entnext (entnext (car (nth i source-list))))))))

;;;если надо брать данные просто из текста то:
;;;      (setq txt (cdr (assoc 1 (entget (nth i source-list)))))


;;; если надо поле с кратностью
;;;============================================================
;;;
;;;      (setq ID (nth i source-list))
;;;      (repeat n-att1 (setq ID (entnext ID)))
;;;    ;(setq ID (vla-get-objectid (vlax-ename->vla-object (car (nth (* i kratnost) source-list)))))
;;;      (setq ID (vla-get-objectid (vlax-ename->vla-object ID)))
;;;    (setq txt (strcat
;;;		"к "
;;;		"%<\\AcObjProp Object(%<\\_ObjId "
;;;		(itoa ID)
;;;		">%).TextString>%"
;;;		;"\\~-\\~"		;неразрывный пробел
;;;		))
;;;    (setq ID (cdr (assoc 1 (entget (car (nth (+ (* i kratnost) 1) source-list))))))
;;;    (setq txt (strcat
;;;		txt
;;;		ID
;;;		))
;;;============================================================


;;;    (setq ID (vla-get-objectid (vlax-ename->vla-object (car (nth (+ (* i kratnost) 2) source-list)))))
;;;    (setq txt (strcat
;;;		txt
;;;		"%<\\AcObjProp Object(%<\\_ObjId "
;;;		(itoa ID)
;;;		">%).TextString>%"
;;;		))
;;;============================================================
    
;;;============================================================

        

;;; если надо поле с кратностью
;;;============================================================
;;;    (setq ID (vla-get-objectid (vlax-ename->vla-object (nth i source-list))))
;;;    (setq txt (strcat
;;;		"%<\\AcObjProp Object(%<\\_ObjId "
;;;		(itoa ID)
;;;		">%).TextString>%"
;;;		))
;;;============================================================        
        

;;;  если надо дополнять
;;;============================================================
;;;        (setq txt (strcat
;;;                      (cdr (assoc 1 (entget (nth i edit-list))))
;;;                      txt
;;;                      ""
;;;                      ))
;;;============================================================   


 
      (setq ent (nth i edit-list))
      (repeat n-att2
	(setq ent (entnext ent))
	) ;_ repeat
      (setq eng (entget ent))
      (setq eng (subst (cons 1 txt) (assoc 1 eng) eng))
      (entmod eng)
      (entupd ent)
      (vl-cmdf "_updatefield" ent "")

      (setq i (1+ i))
      ) ;repeat
 ;else
    (princ "\n несовпадает количество элементов")
    ) ;if



  ) ;defun
