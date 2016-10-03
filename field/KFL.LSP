;;  14_06_23   новый field links


(load (strcat #lisppath "XDictionaries\\XDictlib.LSP"))
(setq #dicts (vla-get-Dictionaries #actdoc))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;    организаци€ словар€

(defun kfl|init ( / )
  (setq kfl:dictname "KD_FIELD_LINKS")
  (setq #FL (vla-add #dicts kfl:dictname))
  (setq kfl:mask "KFL_REC_")
  (setq xr:mask (vla-AddXRecord #FL "IDMASK"))
  (XD|XR|setdata xr:mask (list kfl:mask))
  (setq xr:interface (vla-AddXRecord #FL "INTERFACE"))
  (XD|XR|setdata xr:interface (list "KFL_SOURCE" "KFL_TARGET"))
  );defun
(kfl|init)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(XD|getnames #FL)



(defun KFL|objsetxrec (obj XRdata / oexd $oFLXR)
  ;(= :vlax-true (vla-get-HasExtensionDictionary obj))
  (setq oexd (vla-GetExtensionDictionary obj))
  (if (member kfl:dictname (XD|getnames oexd))
    (setq $oFLXR (vla-item oexd kfl:dictname))
    (setq $oFLXR (vla-AddXRecord oexd kfl:dictname))
    )
  (XD|XR|setdata $oFLXR XRdata)
  );defun
  

;(setq obj (vlax-ename->vla-object (car (entsel))))
(defun KFL|objgetkfldata (obj  / oexd xr)
  (cond
    ((and
       (= :vlax-true (vla-get-HasExtensionDictionary obj))
       (setq oexd (vla-GetExtensionDictionary obj))
       (member kfl:dictname (XD|getnames oexd))
       )
     (setq xr (vla-item oexd kfl:dictname))
     (XD|XR|getdata xr)
     )
    )
  );defun

;(setq hand (KFL|objgetkfldata (vlax-ename->vla-object (car (entsel)))))
;(setq hand (car hand))
;(XD|XR|getdata (vla-HandleToObject #actdoc hand))




(defun c:pf ()
  (vla-startundomark #actdoc)
  ;(acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (kfl|PasteAsField)
  ;(acet-error-restore)
  (vla-endundomark #actdoc)
  );defun


(defun c:pfap ()
  (vla-startundomark #actdoc)
  ;(acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (kfl|PasteField-as-pref)
  ;(acet-error-restore)
  (vla-endundomark #actdoc)
  );defun
(defun c:pfas ()
  (vla-startundomark #actdoc)
  ;(acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (kfl|PasteField-as-suff)
  ;(acet-error-restore)
  (vla-endundomark #actdoc)
  );defun









(defun c:pt ()
  (vla-startundomark #actdoc)
  ;(acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (kfl|PasteAsText)
  ;(acet-error-restore)
  (vla-endundomark #actdoc)
  );defun

(defun c:ptg ()
  (vla-startundomark #actdoc)
  (kfl|PasteAsText-groops)
  (vla-endundomark #actdoc)
  );defun



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(kfl:isfiedlable (vlax-ename->vla-object (car (nentsel))))
(defun kfl:isfieldable (obj) (if (member (vla-get-objectname obj) '("AcDbText" "AcDbMText" "AcDbAttribute" "AcDbAttributeDefinition" "AcDbMLeader")) T nil))
(defun kfl:IDtoFC (id) (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa id) ">%).TextString>%"))
(defun kfl:objToFc (obj) (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-objectID obj)) ">%).TextString>%"))
(defun kfl:HANDtoFC (hand) (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID (vla-HandleToObject #actdoc hand))) ">%).TextString>%"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kfl|PasteField-as-suff ( / srcobj destobj xrhand str)
  (if
    (and
      (= 'LIST (type (setq srcobj (vl-catch-all-apply 'nentsel (list "\n ”кажите источник данных ... :")))))
      ;(setq srcobj (nentsel "\n ”кажите источник данных ... :"))
      (setq srcobj (vlax-ename->vla-object (car srcobj)))
      (kfl:isfieldable srcobj)
      )
    (progn
      (while (setq destobj (nentsel))
	(setq destobj (vlax-ename->vla-object (car destobj)))
	(if (kfl:isfieldable destobj)
	  (progn
	    ;(setq xrhand (XD|XR|add #FL (list (vla-get-Handle srcobj) (vla-get-Handle destobj))))
	    ;(KFL|objsetxrec destobj (list (car xrhand) "KFL_TARGET"))
	    ;(KFL|objsetxrec srcobj (list (car xrhand) "KFL_SOURCE"))
	    (setq str (kd-get-textstring destobj))
	    (vla-put-textstring destobj
	      (strcat
		str
		"-"
		(kfl:IDtoFC (vla-get-objectid srcobj))
		)
	      )
	    (vla-update destobj)
	    (if (= "AcDbAttribute" (vla-get-objectname destobj)) (vl-cmdf "_updatefield" (vlax-vla-object->ename (vla-ObjectIDToObject #actdoc (vla-get-OwnerID destobj))) ""))
	    )
	  )
	)
      )
    );if src
  );defun

(defun kfl|PasteField-as-pref ( / srcobj destobj xrhand str)
  (if
    (and
      (= 'LIST (type (setq srcobj (vl-catch-all-apply 'nentsel (list "\n ”кажите источник данных ... :")))))
      ;(setq srcobj (nentsel "\n ”кажите источник данных ... :"))
      (setq srcobj (vlax-ename->vla-object (car srcobj)))
      (kfl:isfieldable srcobj)
      )
    (progn
      (while (setq destobj (nentsel))
	(setq destobj (vlax-ename->vla-object (car destobj)))
	(if (kfl:isfieldable destobj)
	  (progn
	    ;(setq xrhand (XD|XR|add #FL (list (vla-get-Handle srcobj) (vla-get-Handle destobj))))
	    ;(KFL|objsetxrec destobj (list (car xrhand) "KFL_TARGET"))
	    ;(KFL|objsetxrec srcobj (list (car xrhand) "KFL_SOURCE"))
	    (setq str (kd-get-textstring destobj))
	    (vla-put-textstring destobj
	      (strcat
		;"{\\W0.8;\\T0.85;"
		(kfl:IDtoFC (vla-get-objectid srcobj))
		(if (wcmatch str "*-*") "" "-")
		str
		;"}"
		)
	      )
	    ;(vla-put-ScaleFactor destobj 0.8)
	    (vla-update destobj)
	    (if (= "AcDbAttribute" (vla-get-objectname destobj)) (vl-cmdf "_updatefield" (vlax-vla-object->ename (vla-ObjectIDToObject #actdoc (vla-get-OwnerID destobj))) ""))
	    )
	  )
	)
      )
    );if src
  );defun

(defun kfl|PasteAsField ( / srcobj destobj xrhand)
  (if
    (and
      (= 'LIST (type (setq srcobj (vl-catch-all-apply 'nentsel (list "\n ”кажите источник данных ... :")))))
      ;(setq srcobj (nentsel "\n ”кажите источник данных ... :"))
      (setq srcobj (vlax-ename->vla-object (car srcobj)))
      (kfl:isfieldable srcobj)
      )
    (progn
      (while (setq destobj (nentsel))
	(setq destobj (vlax-ename->vla-object (car destobj)))
	(if (kfl:isfieldable destobj)
	  (progn
	    (setq xrhand (XD|XR|add #FL (list (vla-get-Handle srcobj) (vla-get-Handle destobj))))
	    (KFL|objsetxrec destobj (list (car xrhand) "KFL_TARGET"))
	    (KFL|objsetxrec srcobj (list (car xrhand) "KFL_SOURCE"))
	    (vla-put-textstring destobj (kfl:IDtoFC (vla-get-objectid srcobj)))
	    (vla-update destobj)
	    (if (= "AcDbAttribute" (vla-get-objectname destobj)) (vl-cmdf "_updatefield" (vlax-vla-object->ename (vla-ObjectIDToObject #actdoc (vla-get-OwnerID destobj))) ""))
	    )
	  )
	)
      )
    );if src
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;    отличие - ввод префикс суффикс
(defun g:kd:paste-field* (pref suff / srcobj destobj)
  (if 
    (and
      (= 'LIST (type (setq srcobj (vl-catch-all-apply 'nentsel (list "\n ”кажите источник данных ... :")))))
      ;(setq srcobj (nentsel "\n ”кажите источник данных ... :"))
      (setq srcobj (vlax-ename->vla-object (car srcobj)))
      (kfl:isfieldable srcobj)
      )
    (progn
      (while (setq destobj (nentsel))
	(setq destobj (vlax-ename->vla-object (car destobj)))
	(if (kfl:isfieldable destobj)
	  (progn
	    (vla-put-textstring destobj (strcat pref (kfl:IDtoFC (vla-get-objectid srcobj)) suff))
	    (vla-update destobj)
	    (if (= "AcDbAttribute" (vla-get-objectname destobj)) (vl-cmdf "_updatefield" (vlax-vla-object->ename (vla-ObjectIDToObject #actdoc (vla-get-OwnerID destobj))) ""))
	    )
	  )
	)
      )
    );if src
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kfl|PasteAsText ( / srcobj destobj str blockattnames)
  (setq blockattnames '("ќ“ћ"))
  
  (if
    (and
      (= 'LIST (type (setq srcobj (vl-catch-all-apply 'nentsel (list "\n ”кажите источник данных ... :")))))
      ;(setq srcobj (nentsel "\n ”кажите источник данных ... :"))
      (setq srcobj (vlax-ename->vla-object (car srcobj)))
      (kfl:isfieldable srcobj)
      )
    (progn
      (cond
	(
	 (and
	   (= "AcDbMLeader" (vla-get-ObjectName srcobj))
	   (= acBlockContent (vla-get-ContentType srcobj))
	   (= 6 (vla-get-ContentBlockType srcobj))
	   )
	 (setq str (vla-GetBlockAttributeValue srcobj
	   (vla-get-ObjectID
	     (car (vl-remove-if-not '(lambda (obj) (and (= "AcDbAttributeDefinition" (vla-get-objectname obj)) (member (vla-get-TagString obj) blockattnames))) (cont>list (vla-Item (vla-get-Blocks #actdoc) (vla-get-ContentBlockName srcobj))))))))
	 )
	(T (setq str (vla-get-TextString srcobj)))
	)
      
      (while (setq destobj (nentsel str))
	(setq destobj (vlax-ename->vla-object (car destobj)))
	(if (kfl:isfieldable destobj)
	  (progn
	    (cond
	      (
	       (and
		 (= "AcDbMLeader" (vla-get-ObjectName destobj))
		 (= acBlockContent (vla-get-ContentType destobj))
		 (= 6 (vla-get-ContentBlockType destobj))
		 )
	       (vla-SetBlockAttributeValue destobj
		 (vla-get-ObjectID
		   (car (vl-remove-if-not '(lambda (obj) (and (= "AcDbAttributeDefinition" (vla-get-objectname obj)) (member (vla-get-TagString obj) blockattnames))) (cont>list (vla-Item (vla-get-Blocks #actdoc) (vla-get-ContentBlockName destobj))))))
		 str)
	       )
	      (T (vla-put-TextString destobj str))
	      )
	    ;(vl-cmdf "_updatefield" (vlax-vla-object->ename destobj) "")
	    )
	  )
	)
      )
    );if src
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kfl|PasteAsText-groops ( / es srclst str)
  (setq srclst '())
  (while (setq es (nentsel* (apply 'strcat (mapcar '(lambda (x) (strcat x "\n")) (reverse srclst)))))
    (setq srclst (cons (kd-get-textstring (vlax-ename->vla-object (car es))) srclst))
    )

  (while
    (and
      srclst
      (setq es (nentsel* (apply 'strcat (mapcar '(lambda (x) (strcat x "\n")) (reverse srclst)))))
      (= 'LIST (type es))
      )
    (vla-put-TextString (vlax-ename->vla-object (car es)) (setq str (last srclst)))
    (setq srclst (vl-remove str srclst))
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;  (kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) #kflsrcID)


;;;
;;;(do
;;;  (setq xr (vla-item (vla-getextensiondictionary (vlax-ename->vla-object (car (nentsel)))) 0))
;;;    (vla-GetXRecordData xr 'a 'b)
;;;  (vlax-safearray->list a)
;;;  (mapcar 'vlax-variant-value (vlax-safearray->list b))
;;;  )

;(kfl-update (vlax-ename->vla-object (car (nentsel))))
;(kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) #kflsrcID)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(kfl:updatefromxrec (vlax-ename->vla-object (car (nentsel))))
;(setq obj (vlax-ename->vla-object (car (nentsel))))
(defun kfl:updatefromxrec (obj / hand)
  (if (setq hand (kfl-get-xrecdata obj #kflsrcID))
    (progn
      (vla-put-textstring obj (kfl:HANDtoFC hand))
      (princ "\nUpdated")
      )
    (progn (princ "\n NO filled links DATA in xrec") (princ) (exit))
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) #kflsrcID)
;;;
;;;(vla-objectidtoobject #actdoc
;;;  (kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) #kflsrcID)
;;;  )




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; указваем текст, и прога копирует филдкод в буффер обмена чтобы потом вставить
(defun g:genfctoclip ( / obj str)
  (setq obj (vlax-ename->vla-object (car (nentsel))))
  (setq str (kfl:IDtoFC (vla-get-ObjectID obj)))
  (vl-cmdf "_copyclip" str "")
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; copy field
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:cf ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (g:kd:copy-fieldcode)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun

;(kd:getfieldcode (vlax-ename->vla-object (car (nentsel))))

(defun g:kd:copy-fieldcode ( / srcobj destobj fc)
  (if (setq srcobj (nentsel "\n ”кажите источник данных ... :"))
    (setq srcobj (vlax-ename->vla-object (car srcobj)))
    )
  (if (kfl:isfieldable srcobj)
    (progn
      (if
	(vlax-method-applicable-p srcobj "FieldCode")
	(setq fc (vla-fieldcode srcobj))
	(setq fc (kd:getfieldcode srcobj))
	)
      ;(setq str (strcat "%<\\AcObjProp Object(%<\\_ObjId " ID ">%).TextString>%"))
      (while (setq destobj (nentsel))
	(setq destobj (vlax-ename->vla-object (car destobj)))
	(if (kfl:isfieldable destobj)
	  (progn
	    ;(kfl-put-xrecdata srcobj #kflsrcID ID)
	    ;;; тут надо написать функцию ADD т.е. добавить в словарь источника еще один приемник
	    ;;; + добавить в приемник - источник
	    (vla-put-textstring destobj fc)
	    (vla-update destobj)
	    (if (= "AcDbAttribute" (vla-get-objectname destobj)) (vl-cmdf "_updatefield" (vlax-vla-object->ename (vla-ObjectIDToObject #actdoc (vla-get-OwnerID destobj))) ""))
	    )
	  )
	)
      )
    (exit)
    );if src
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












(load (strcat #lisppath "field\\disel-lib.lsp"))

(defun c:frep ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (g:kfl:fieldreplace)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun


(defun g:kfl:fieldreplace (/ srcobj destobj str lobjstruct fcstruct item)
  (if (setq srcobj (nentsel "\n ”кажите источник данных ... :"))
    (setq srcobj (vlax-ename->vla-object (car srcobj)))
    )
  (if (kfl:isfieldable srcobj)
    (progn
      (while (setq destobj (nentsel))
	(setq destobj (vlax-ename->vla-object (car destobj)))
	(if (kfl:isfieldable destobj)
	  (progn
	    (if (vlax-method-applicable-p destobj 'fieldcode)
	      (setq str (vla-fieldcode destobj))
	      (setq str (kd:getfieldcode destobj))
	      )
	    ;(setq str (sepstr str "%"))
	    ;(setq str (subst (strcat "<\\_ObjId " (itoa (vla-get-ObjectID srcobj)) ">") (cadr str) str))

	    (setq lobjstruct (disel:structstring str))
	    (setq fcstruct (disel>list (cadr lobjstruct)))
	    (setq item (assoc "_ObjId" (vl-remove-if-not 'listp fcstruct)))
	    (vla-put-TextString destobj

	      ;(strcat "%<" (antisep str "%") ">%")
	      (strcat
		(car lobjstruct)
		(disel:struct>string
		  (subst (list "_ObjId" (itoa (vla-get-ObjectID srcobj))) item fcstruct)
		  )
		(caddr lobjstruct)
		)
	      )

	    
	    (vla-update destobj)
	    (if (= "AcDbAttribute" (vla-get-objectname destobj)) (vl-cmdf "_updatefield" (vlax-vla-object->ename (vla-ObjectIDToObject #actdoc (vla-get-OwnerID destobj))) ""))

	    
	    )
	  )
	)
      )
    )
  );defun




(defun ss:kfl:fieldreplace (/ srcobj destlst)
  (if (setq srcobj (nentsel "\n ”кажите источник данных ... :"))
    (setq srcobj (vlax-ename->vla-object (car srcobj)))
    )
  (if (kfl:isfieldable srcobj)
    (progn
      (setq destlst (ss->lsto* (ssget '((0 . "*TEXT")))))

      (mapcar
	'(lambda (destobj / str lobjstruct fcstruct item)
	   (if (kfl:isfieldable destobj)
	     (progn
	       (if (vlax-method-applicable-p destobj 'fieldcode)
		 (setq str (vla-fieldcode destobj))
		 (setq str (kd:getfieldcode destobj))
		 )
	       (setq lobjstruct (disel:structstring str))
	       (setq fcstruct (disel>list (cadr lobjstruct)))
	       (setq item (assoc "_ObjId" (vl-remove-if-not 'listp fcstruct)))
	       (vla-put-TextString destobj
		 (strcat
		   (car lobjstruct)
		   (disel:struct>string
		     (subst (list "_ObjId" (itoa (vla-get-ObjectID srcobj))) item fcstruct)
		     )
		   (caddr lobjstruct)
		   )
		 )
	       (vla-update destobj)
	       )
	     )
	   )
	destlst)
      
      )
    )
  );defun




















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:gdf ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (g:kd:get-destination-fields)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  )

(defun g:kd:get-destination-fields ( / hand)
  (setq hand (kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) #kfldestID))
  (setq hand (vla-handletoobject #actdoc hand))
  (command "_zoom" "_o" (vlax-vla-object->ename hand) "" "")
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:gsf ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (g:kd:get-src-field)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  )
(defun g:kd:get-src-field ( / hand err)
  (setq hand (kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) #kflsrcID))
  (setq err (vl-catch-all-apply 'vla-handletoobject (list #actdoc hand)))
  (if (= (type err) 'VLA-OBJECT)
    (command "_zoom" "_o" (vlax-vla-object->ename err) "")
    (princ (strcat (vl-catch-all-error-message err)
	     "\n" "ќбъект с handle \"" hand "\" был удален из файла"))
    )
  (princ)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





(defun c:repwf ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (g:kd:replace-with-field)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun





(defun g:kd:replace-with-field ( / srcobj destobj)
  (if (setq srcobj (nentsel "\n ”кажите источник данных ... :"))
    (setq srcobj (vlax-ename->vla-object (car srcobj))))
  (if (kfl:isfieldable srcobj)
    (progn
      (while (setq destobj (nentsel))
	(setq destobj (vlax-ename->vla-object (car destobj)))
	(if (kfl:isfieldable destobj)
	  (progn
	    (if
	      (vl-string-search (vla-get-TextString srcobj) (vla-get-TextString destobj))
	      (progn
		;(kfl-put-xrecdata srcobj #kfldestID (itoa (vla-get-objectid destobj)))
		;(kfl-put-xrecdata srcobj #kfldestID (vla-get-Handle destobj))
		;;; а вот в srcobj - надо add
		;(kfl-put-xrecdata destobj #kflsrcID (vla-get-Handle srcobj))
		;;; тут надо написать функцию ADD .... не тут а в файле где kfl-put-xrecdata написана
		;;; added - ненадо пока не сделално составное поле

		(vla-put-TextString
		  destobj
		  (vl-string-subst
		    (kfl:IDtoFC (vla-get-objectid srcobj))
		    (vla-get-TextString srcobj)
		    (vla-get-TextString destobj)
		    )
		  )
		(vla-update destobj)
		(if (= "AcDbAttribute" (vla-get-objectname destobj)) (vl-cmdf "_updatefield" (vlax-vla-object->ename (vla-ObjectIDToObject #actdoc (vla-get-OwnerID destobj))) "")
		  )
		)
	      )
	    )
	  )
	)
      )
    (exit)
    );if src
  )

;"_updatefield"


;(setq destobj (vlax-ename->vla-object (car (nentsel))))









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  V 2

