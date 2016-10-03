

;*********************************************************************************
(defun kd:setXRECdata (xrec val / sa1 sa2)
  (if (listp val)
    (progn
      (setq sa1 (vlax-safearray-fill
		  (vlax-make-safearray vlax-vbInteger (cons 0  (1- (length val))))
		  (mapcar
		    '(lambda (x)
		       (cond
			 ((= (type x) 'STR) 301)
			 ((= (type x) 'INT) 451)
			 ((= (type x) 'REAL) 140))) val)))
      (setq sa2 (vlax-safearray-fill (vlax-make-safearray vlax-vbvariant (cons 0 (1- (length val)))) val))
      (vla-SetXRecordData xrec sa1 sa2))
    (princ "\nkd:setxrecdata : value must be a list"))
  );defun
;*********************************************************************************
;(kd:getxrecdata xr)
(defun kd:getXRECdata (xrec / sa1 sa2)
  (vla-getXrecordData xrec 'sa1 'sa2)
  (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
  );defun
;*********************************************************************************

;*********************************************************************************
(defun kd:putXdata (obj tag val / sa1 sa2)
  (setq sa1 (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 1)) (list 1001 1000)))
  (setq sa2 (vlax-safearray-fill (vlax-make-safearray vlax-vbvariant '(0 . 1)) (list tag val)))
  (vla-SetXData obj sa1 sa2)
  )
(defun kd:getXdata (obj tag / sa1 sa2)
  (vla-GetXData obj tag 'sa1 'sa2)
  (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
  )
;*********************************************************************************




(setq sch:cnct:dn "KDEL-CONNECTIONS")		;; dict name
;(DICTSEARCH (namedobjdict) "KD-connections")
;(DICTSEARCH (namedobjdict) "KDEL-CONNECTIONS")
;(setq dict (vlax-ename->vla-object (cdr (assoc -1 (DICTSEARCH (namedobjdict) sch:cnct:dn)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:adddata (sch:cnct:dn sch:cnct:data / datalst dict xr)
  (if (DICTSEARCH (namedobjdict) sch:cnct:dn) (setq dict (vla-item dicts sch:cnct:dn)) (setq dict (vla-add dicts sch:cnct:dn)))
  (setq datalst (mapcar 'vla-get-Handle sch:cnct:data))
  ;; 1 - Xrec
  (kd:setxrecdata (setq xr (vla-addxrecord dict (car datalst))) (cdr datalst))
  ;; 2 - Xdata
  (mapcar '(lambda (x) (kd:putXdata x sch:cnct:dn (vla-get-Handle xr))) sch:cnct:data)
  (sch:cnct:reply xr)
  xr
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:man:gendata ( / nodeobj lst item)
  (setq nodeobj (car (entsel "\nSelect a node.. : ")))
  (setq lst nil)
  (while (setq item (nentsel "\nSelect the NEXT attribute... : ")) (setq lst (append lst (list (car item)))))
  (mapcar 'vlax-ename->vla-object (append (list nodeobj) lst))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (sch:cnct:adddata    sch:cnct:dn     (sch:cnct:man:gendata))
; (sch:cnct:adddata "KDEL-CONNECTIONS" (sch:cnct:man:gendata))
; (vla-get-TextString (getbatt (vla-HandleToObject #actdoc (vla-get-name (vla-item dict 1))) "ID"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:xr>list (xr)
  (mapcar '(lambda (x) (vla-HandleToObject #actdoc x)) (append (list (vla-get-name xr)) (kd:getxrecdata xr)))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;old
;;;(defun sch:cnct:reply (xr)
;;;  (princ (apply 'strcat (append (list "\n\nпрконнектили - к " "Node " (vla-get-TextString (getbatt (vla-HandleToObject #actdoc (vla-get-name xr)) "ID")) " элементы " )
;;;    (mapcar '(lambda (x) (strcat (vla-get-TextString (getbatt (vla-ObjectIDToObject #actdoc (vla-get-OwnerID (vla-HandleToObject #actdoc x))) "CODE")) ":"
;;;       (vla-get-TextString (vla-HandleToObject #actdoc x)) ", ")) (kd:getxrecdata xr)) (list "...  "))))
;;;  );defun
(defun sch:cnct:reply (xr / lst)
  (setq lst (sch:cnct:xr>list xr))
  (princ (apply 'strcat (append (list "\n\nпрконнектили - к " "Node " (vla-get-TextString (getbatt (car lst) "ID")) " элементы " ) (mapcar '(lambda (x) (strcat (vla-get-TextString (getbatt (vla-ObjectIDToObject #actdoc (vla-get-OwnerID x)) "CODE")) ":" (vla-get-TextString x) ", ")) (cdr lst)) (list "...  "))))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:genadrstr (attobj / )  ;; generate address (SQ1:1) from #<VLA-OBJECT IAcadAttributeReference 176dbfd4>
  ;(setq attobj (nth 1 lst))
  (strcat (vla-get-TextString (getbatt (vla-ObjectIDToObject #actdoc (vla-get-OwnerID attobj)) "CODE")) ":" (vla-get-TextString attobj))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; вот это уже похоже на шедевр ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:getdata ( / sel xr lst choice)
  (if (setq nsel (nentsel))
    (setq sel (vlax-ename->vla-object (car nsel)))
    (exit)
    )
  (cond
    ((= (vla-get-ObjectName sel) "AcDbAttribute")
     (cond
       ((wcmatch (vla-get-TagString sel) "ID")  (setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata (vla-ObjectIDToObject #actdoc (vla-get-OwnerID sel)) sch:cnct:dn)))))
       ((wcmatch (vla-get-TagString sel) "PIN*")(setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata sel sch:cnct:dn)))))
       ((wcmatch (vla-get-TagString sel) "CODE")(setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata (progn (setq lst (getbattswcmatch (vla-ObjectIDToObject #actdoc (vla-get-OwnerID sel)) "*PIN*")) (setq choice (kd:dcl:pick-from-list (mapcar 'vla-get-TagString lst))) (car (vl-remove-if-not '(lambda (x) (= choice (vla-get-TagString x))) lst ))) sch:cnct:dn )))))
       ))
    (T
     (setq sel (vlax-ename->vla-object (caar (reverse nsel))))
     (cond
       ((= "node" (vla-get-EffectiveName sel))(setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata sel sch:cnct:dn)))))
       (T (setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata (progn (setq lst (getbattswcmatch sel "*PIN*")) (setq choice (kd:dcl:pick-from-list (mapcar 'vla-get-TagString lst))) (car (vl-remove-if-not '(lambda (x) (= choice (vla-get-TagString x))) lst ))) sch:cnct:dn)))))
       )
     )
    );cond
  ;(sch:cnct:xr>list xr)
  xr
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:fulldelete1connection ( / cnctdata xr)
  (setq cnctdata (sch:cnct:getdata))
  (vla-delete (vla-HandleToObject #actdoc (cadr (kd:getXdata (car cnctdata) sch:cnct:dn))))
  (mapcar '(lambda (x) (kd:putXdata x sch:cnct:dn nil)) cnctdata)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(sch:cnct:fulldelete1connection)
;(DICTSEARCH (namedobjdict) sch:cnct:dn)
;(do (vlax-ename->vla-object (cdr (assoc -1 (DICTSEARCH (namedobjdict) sch:cnct:dn)))))
;(sch:cnct:adddata    sch:cnct:dn     (sch:cnct:man:gendata))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:dcleditconnections (lst
				    /
				    xr
				    dclpath
				    dclans
				    dcl_id

				    )
  ;(setq dclans lst)
  (setq dclpath (strcat (getenv "temp") "\\sch_cnct_dcleditconnections.dcl"))
;;;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  (defun sch:cnct:dclgendclfile (lst / dclhand dclstrlist dcli)
    (setq dclstrlist (list
       "kd_sch_cnct_dcleditconnections : dialog"
       "{ label=\"kakt00z dcl sch:cnct edit connections\";"
       ":row {"
       		":text{label=\"Node\";}"
       		(strcat ":text{label=\"" (vla-get-TextString (getbatt (car lst) "ID")) "\";}")
       		"}"
       ))
    (setq dcli 1)
    (repeat (1- (length lst))
      (setq dclstrlist
       (append
	 dclstrlist
	 (list
	   ":row {"
	   	(strcat ":text{label=\"" "Connection" (itoa dcli) "\";width=15;}")
	   	(strcat ":text{label=\"" (sch:cnct:genadrstr (nth dcli lst)) "\";width=15;}")
		(strcat ":button{label=\"replace\";key=\"" "cnrepbtn" (itoa dcli) "\";width=20;action=\"(bntrepclicked " (itoa dcli) ")\";}")
	   	(strcat ":button{label=\"remove\";key=\"" "cnrembtn" (itoa dcli) "\";width=20;action=\"(bntremclicked " (itoa dcli) ")\";}")
	   	"}"
	   )
	 )
      )
    (setq dcli (1+ dcli))
    )

    (setq dclstrlist (append dclstrlist (list ":button{label=\"add Connection\";key=\"cnaddbtn\";width=20;action=\"(bntaddclicked)\"}" )))
    (setq dclstrlist (append dclstrlist (list ":spacer{width=3;}" "ok_button;" "}" )))
    (setq dclhand (open dclpath "w"))
    (mapcar '(lambda (x) (write-line x dclhand)) dclstrlist)
    (close dclhand)
    dclpath
    );defun sch:cnct:dclgendclfile
;;;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


  



  (setq dclans (sch:cnct:xr>list (sch:cnct:getdata)))
  ;(mapcar 'sch:cnct:genadrstr (cdr dclans))
  (sch:cnct:dclgendclfile dclans)



  
;;;  (defun sch:cnct:dclstartdialog ()
;;;    (if (or (< (setq dcl_id (load_dialog dclpath))0) (not (new_dialog "kd_sch_cnct_dcleditconnections" dcl_id))) (exit)
;;;      (progn (start_dialog) (action_tile "accept" "(progn (done_dialog) (unload_dialog dcl_id))")))
;;;    )

  (defun bntremclicked (n / remitem)
    (done_dialog 99)
    (unload_dialog dcl_id)
    (setq remitem (nth n dclans))
    ;(kd:putXdata remitem sch:cnct:dn nil)
    (setq dclans (vl-remove remitem dclans))
    ;(sch:cnct:adddata sch:cnct:dn dclans)
    )

  (defun bntaddclicked (n / additem xr)
    (done_dialog 99)
    (unload_dialog dcl_id)
    (if (setq additem (entsel))
      (setq additem (vlax-ename->vla-object (car additem)))
      (exit)
      )
    (setq dclans (append dclans (list additem)))
    (setq xr (sch:cnct:adddata (sch:cnct:dn dclans)))
    ;(kd:putXdata additem sch:cnct:dn (vla-get-Handle xr)))
  )


  (defun btnOKclocked ()
    (done_dialog 1)
    (unload_dialog dcl_id)
    )


  (defun sch:cnct:dclstartdialog ()
    (if (or
	  (< (setq dcl_id (load_dialog dclpath))0)
	  (not (new_dialog "kd_sch_cnct_dcleditconnections" dcl_id))
	  )
      (exit)
      (progn (action_tile "accept" "btnOKclocked") (start_dialog))
      )
    );defun
  

  (while (/= 1 (sch:cnct:dclstartdialog))
    (sch:cnct:dclgendclfile dclans)
    )
 



  (setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata (car lst) sch:cnct:dn))))
  
  );defun
