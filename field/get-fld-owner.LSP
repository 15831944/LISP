;;; 15_10_26 новый gfowner

(if (null kd:getfieldcode) (load (strcat #lisppath "field\\getfieldcode.lsp")))

(defun c:gfowner ( / fc ids srcObjs objs mspsids ersedobjs)

  (setq fc (kd:getfieldcode (vlax-ename->vla-object (car (nentsel)))))

  (setq mspsids (list (vla-get-ObjectID #modspace)))
  (setq ids (mapcar '(lambda (x) (atoi (car (sepstr x ">%)")))) (cdr (sepstr fc "ObjId "))))
  (if (member 0 ids) (setq ersedobjs T ids (vl-remove 0 ids)))
  (setq srcObjs (mapcar '(lambda (x) (vla-ObjectIDToObject #actdoc x)) ids))
  (mapcar
    '(lambda (o / co)	;(setq o (car srcObjs))
       (setq co o)
       (while (null (member (vla-get-OwnerID co) mspsids))
	 (setq co (vla-ObjectIDToObject #actdoc (vla-get-OwnerID co)))
	 )
       (setq objs (cons co objs))
       )
    srcObjs)
  (if ersedobjs (alert "there was erased objects"))
  (sssetfirst nil (lst-to-ss (origlist objs)))
  );defun
       


(defun kd:getFieldOwners (fc / mspsids ids ersedobjs srcObjs objs)
  (setq mspsids (list (vla-get-ObjectID #modspace)))
  (setq ids (mapcar '(lambda (x) (atoi (car (sepstr x ">%)")))) (cdr (sepstr fc "ObjId "))))
  (if (member 0 ids) (setq ersedobjs T ids (vl-remove 0 ids)))
  (setq srcObjs (mapcar '(lambda (x) (vla-ObjectIDToObject #actdoc x)) ids))
  (mapcar
    '(lambda (o / co)	;(setq o (car srcObjs))
       (setq co o)
       (while (null (member (vla-get-OwnerID co) mspsids))
	 (setq co (vla-ObjectIDToObject #actdoc (vla-get-OwnerID co)))
	 )
       (setq objs (cons co objs))
       )
    srcObjs)
  )









;;;;;; изменена 10_04_15
;;;;;; подсвечивает объекты на которые ссылаются поля в тексте/аттрибуте
;;;;;; использована при разработке щита БП №4 Береза
;;;;;; -kakt00z-™  ©
;;;
;;;
;;;
;;;;;;(defun c:fo ()
;;;;;;  (vla-startundomark #actdoc)
;;;;;;  (acet-error-init (list (list "cmdecho" 0
;;;;;;			       "highlight" (getvar "highlight")
;;;;;;			       "limcheck" 0
;;;;;;			       "osmode" 0);list
;;;;;;			 T));acet-error-init
;;;;;;  
;;;;;;  (kd:get-field-owner)
;;;;;;  (acet-error-restore)
;;;;;;  (vla-endundomark #actdoc)
;;;;;;  
;;;;;;  );defun
;;;;;;
;;;;;;
;;;;;;(defun kd:get-field-owner ()
;;;;;;  
;;;;;;  )
;;;;;;
;;;;;;
;;;;;;(do (setq obj (vlax-ename->vla-object (car (entsel)))))
;;;;;;
;;;;;;(vla-fieldcode obj)
;;;;;;
;;;
;;;;;;******************************************************
;;;
;;;(defun c:gfowner (/ owlist s1 fld pp ss	e echo)
;;;  (setq	owlist '()
;;;	ss (ssadd)
;;;	echo (getvar "cmdecho")
;;;	) ;_ конец setq
;;;  (setvar "cmdecho" 0)
;;;  
;;;  (if (setq fld (nentsel "\nУкажите поле"))
;;;    (setq fld (entget (car fld)))
;;;    (exit)
;;;    )
;;;
;;;  (while (and (/= "FIELD" (cdr (assoc 0 fld)))
;;;	      (assoc 360 fld)
;;;	      ) ;and
;;;    (setq fld (entget (cdr (assoc 360 fld))))
;;;    ) ;while
;;; ;(setq fld (assoc 360 (entget (cdr (assoc 360 s1)))))
;;;
;;;  (if (assoc 360 fld)
;;;    (progn
;;; ;(setq fld (entget (cdr (assoc 360 (entget (cdr fld))))))
;;;      (while (setq pp (assoc 360 fld))
;;;	(setq owlist (append owlist (list pp)))
;;;	(setq fld (vl-remove pp fld))
;;;	) ;while
;;; ;owlist
;;; ;((360 . <Имя объекта: 7e29a558>) (360 . <Имя объекта: 7e29a560>) (360 . <Имя объекта: 7eb48028>)) 
;;;
;;;      (foreach x owlist
;;;	(setq e (cdr (assoc 331 (entget (cdr x)))))
;;;;;;	(princ "\n")
;;;;;;	(princ (cdr (assoc 0 (entget e))))
;;;;;;	(princ "\n")
;;;	(cond
;;;	  ((= "TEXT" (cdr (assoc 0 (entget e))))
;;;	   (setq ss (ssadd e ss))
;;;	   )
;;;	  ((= "ATTRIB" (cdr (assoc 0 (entget e))))
;;;	   (setq ss (ssadd (cdr (assoc 330 (entget e))) ss))
;;;	   )
;;;	  (T (princ "\n"))
;;;	  ) ;cond
;;;	) ;foreach
;;;      (sssetfirst nil ss)
;;;      (command "_zoom" "_o" ss "" "")
;;;      ) ;progn
;;;    (princ "\nВ объекте нет поля!")
;;;    ) ;if
;;;  (setvar "cmdecho" echo)
;;;  (princ)
;;;  ) ;defun




;;;(defun c:gfo ( / obj)
;;;  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
;;;  (vla-startundomark #actdoc)
;;;  (acet-error-init
;;;    (list (list "cmdecho" 0
;;;		"highlight" (getvar "highlight")
;;;		"limcheck" 0
;;;		"osmode" 0
;;;		) T) )
;;;  (if (setq obj (nentsel "\nУкажите поле"))
;;;    (kd:getfieldowner (vlax-ename->vla-object (car obj)))
;;;    (exit)
;;;    )
;;;  (acet-error-restore)
;;;  (vla-endundomark #actdoc)
;;;  );defun
;;;
;;;
;;;(defun kd:getfieldowner (obj / fld)
;;;  ;(setq obj (vlax-ename->vla-object (car (nentsel))))
;;;  (setq fld (vla-item
;;;	      (setq x  (vla-item
;;;			 (setq ex (vla-GetExtensionDictionary obj))
;;;			 "ACAD_FIELD"))
;;;	      0))
;;;
;;;  (cdr (assoc 331 (entget (cdr (assoc 360 (entget (vlax-vla-object->ename fld)))))))
;;;
;;;  
;;;  (do (vla-GetObject x "TEXT"))
;;;
;;;
;;;
;;;  
;;;  (vla-GetXData fld "ACFD_FIELD_VALUE" 'a 'b)
;;;  );defun



















;;;; обратная прога - находит объекты кот. ссылаются на указанный

;;;(defun c:gfdep (			;get field-dependend
;;;                /
;;;                doc
;;;                obj
;;;                )
;;;  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
;;;  (vla-startundomark doc)
;;;  
;;;  (acet-error-init
;;;    (list (list "cmdecho" 0
;;;		"highlight" (getvar "highlight")
;;;		"limcheck" 0
;;;		"osmode" 0
;;;		);list
;;;	  T
;;;	  );list
;;;    );acet-error-init
;;;
;;;
;;;
;;;
;;;
;;;
;;;  (acet-error-restore)
;;;  (vla-endundomark doc)
;;;  );defun




;;;
;;;
;;;(vlax-for
;;;(vlax-dump-object
;;;(setq ad (vla-get-Dictionaries doc))
;;;T)
;;;
;;;
;;;
;;;(mapcar '
;;;(cdr (cdr
;;;(member '(100 . "AcDbIdSet") 
;;;(entget (cdr (cadr (member '(3 . "ACAD_FIELDLIST") (entget (vlax-vla-object->ename ad))))))
;;;        )))
;;;
;;;        
;;;        
;;;    
;;;
;;;(vl-load-com)
;;;(vla-item doc 2)
;;;    
;;;(vlax-for for-item 
;;;   (vla-get-Dictionaries doc)
;;;  (vlax-dump-object for-item)        ; list object properties
;;;)
;;;








;;; возникла проблемма
;;; клемма :
;;; аттрибуты :

;;; НОМЕР_КЛЕММЫ
;;; МАРКА_СВЯЗИ
;;; NКлеммника
;;; К_ПРИБОРУ

;;; а было

;;; МАРКА_СВЯЗИ
;;; NКлеммника
;;; К_ПРИБОРУ
;;; НОМЕР_КЛЕММЫ

;;; в итоге сместились поля на хвосте и вместо Х1:67
;;; стало +24-Т5-2:U23:1

;;; решаем проблему
;;;
;;;(defun repare (
;;;	       e
;;;	       /
;;;;;;	       fld
;;;;;;	       ent
;;;	       eng
;;;;;;	       pp
;;;;;;	       owlist
;;;;;;	       owner
;;;;;;	       i
;;;;;;	       attlist
;;;;;;	       att
;;;	       txt
;;;	       att1
;;;	       nat1
;;;	       att2
;;;	       nat2
;;;	       razdelitel
;;;	       
;;;	       )
;;;
;;;
;;;;;; формат поля
;;;  (setq nat1 3
;;;	nat2 1
;;;	razdelitel ":")
;;;
;;;
;;;  
;;;  (setq owlist '()
;;;	pp nil
;;;	fld nil
;;;	attlist nil
;;;	att nil
;;;	i nil
;;;	)
;;;  
;;;  (setq fld (entget e))
;;;  (while (and (/= "FIELD" (cdr (assoc 0 fld)))
;;;	      (assoc 360 fld)
;;;	      ) ;and
;;;    (setq fld (entget (cdr (assoc 360 fld))))
;;;    ) ;while
;;;  (princ "\n")
;;;
;;;
;;;;;;      (while (setq pp (assoc 360 fld))
;;;;;;	(setq owlist (append owlist (list pp)))
;;;;;;	(setq fld (vl-remove pp fld))
;;;;;;	) ;while
;;;;;;  ;(setq owlist (mapcar 'cdr owlist))
;;;
;;;
;;;  ;(setq owner (cdr (assoc 330 (entget (cdr (assoc 331 (entget (cdr (nth 0 owlist)))))))))
;;;
;;;  (setq owner (cdr (assoc 330 (entget (cdr (assoc 331 (entget (cdr (assoc 360 fld)))))))))
;;;;;;  (setq i 1)
;;;;;;  (setq att (entnext owner))
;;;;;;  (while (/= "SEQEND" (cdr (assoc 0 (entget att))))
;;;;;;    (setq attlist (append attlist (list (cons i att))))
;;;;;;    (setq att (entnext att)
;;;;;;	  i (1+ i))
;;;;;;    );while
;;;;;;
;;;;;;  (setq txt (strcat
;;;;;;	      "\n"
;;;;;;	      "В указанном объекте "
;;;;;;	      (itoa (length owlist))
;;;;;;	      " поля(ей), \n ссылающиеся на блок в котором  "
;;;;;;	      (itoa (length attlist))
;;;;;;	      "аттрибутов \n"
;;;;;;	      ))
;;;;;;  (princ txt)
;;;;;;
;;;
;;;  (setq att1 (entnext owner))
;;;  (repeat (- nat1 1) (setq att1 (entnext att1)))
;;;  (setq att1 (vla-get-objectid (vlax-ename->vla-object att1)))
;;;    
;;;    
;;;  (setq att2 (entnext owner))
;;;  (repeat (- nat2 1) (setq att2 (entnext att2)))
;;;  (setq att2 (vla-get-objectid (vlax-ename->vla-object att2)))
;;;
;;;  (setq txt (strcat
;;;	      "%<\\AcObjProp Object(%<\\_ObjId "
;;;	      (itoa att1)
;;;	      ">%).TextString>%"
;;;	      razdelitel
;;;	      "%<\\AcObjProp Object(%<\\_ObjId "
;;;	      (itoa att2)
;;;	      ">%).TextString>%"
;;;	      ))
;;;  (setq eng (entget e))
;;;  (setq eng (subst (cons 1 txt) (assoc 1 eng) eng))
;;;  (entmod eng)
;;;  (entupd e)
;;;  (vl-cmdf "_updatefield" e "")
;;;  );defun
