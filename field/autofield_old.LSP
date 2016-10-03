

(defun c:autofield ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (autofield)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun







(defun autofield ( / lst)
  (setq lst (ssget* '(( 0 . "iNSERT"))))
  (cond
    ((= 'PICKSET (type lst))
     (setq lst (ss->lsto* lst))
     (mapcar
       '(lambda (blk)	;(setq blk (nth 0 lst))
	  (cond
	    ((member (vla-get-EffectiveName blk) '("format-spec" "format" "RU_format" "RU_format-spec" "RU_format-content"))
	     (formats-put-field blk)
	     )
	    ((member (vla-get-EffectiveName blk) '("cbl_cnct" "act_cbl_mnt-local" "pwr_cbl" "cbl_fld" "act_mnt_cbl-outer")) 
	     (cables-put-field blk)
	     )
	    ((member (vla-get-EffectiveName blk) '("PE_PID_instrument"))
	     (val-units-put-field blk)
	     )
	    ((member (vla-get-EffectiveName blk) '("REV_RU_head"))
	     (revision-put-prjData blk)
	     )
	    ;(setq blk (vlax-ename->vla-object (car (entsel))))
	    ((and
	       (getbatt blk "SIGN")
	       (getbatt blk "CODE")
	       (or
		 (getbatt blk "POZ")
		 (getbatt blk "KKS")
		 (getbatt blk "ID")
		 )
	       )
	     (pnl-transmitter-put-field blk)
	     )
	    (T (princ "\n unknown block, please append it to autofield.lsp\n"))
	    )
	  )
       lst)
     )
    (T (princ))
    )
  (princ)
  );defun

(defun pnl-transmitter-put-field (blk / att_SIGN att_CODE att_POZ)
  (setq att_SIGN (getbatt blk "SIGN"))
  (setq att_CODE (getbatt blk "CODE"))
  
  (cond
    ((setq att_POZ (getbatt blk "POZ")))
    ((setq att_POZ (getbatt blk "KKS")))
    ((setq att_POZ (getbatt blk "ID")))
    (T (exit))
    );cond
  
  (vla-put-Textstring att_SIGN
    (strcat
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att_CODE))
      ">%).TextString>%"
      "("
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att_POZ))
      ">%).TextString>%"
      ")"
      ))
  );defun


(defun formats-put-field (blk / att)
  ;(setq formatSize-DynPropNumber 31)
  ;(setq formatSize-DynPropNumber 15)
  ;(setq blk (vlax-ename->vla-object (car (entsel))))
  ;(vl-position "Size" (mapcar 'vla-get-PropertyName (vlax-safearray->list (vlax-variant-value (vla-GetDynamicBlockProperties blk)))))
  (cond
    ((wcmatch (vla-get-EffectiveName blk) "*spec*")
     (setq formatSize-DynPropNumber 15)
     )
    (T (setq formatSize-DynPropNumber 31))
    )
  (setq att (getbatt blk "FORMATNAME"))
  (vla-put-Textstring att (strcat
			    "%<\\AcObjProp Object(%<\\_ObjId "
			    (itoa (vla-get-ObjectID blk))
			    ">%).Parameter("
			    (itoa formatSize-DynPropNumber)
			    ").lookupString>%"))
  (formats-linkDate blk)
  (vl-cmdf "_updatefield" (vlax-vla-object->ename att) "")
  )


;(setq releasedate 29)
(defun formats-linkDate (f / dateatts)
  ;(setq f (vlax-ename->vla-object (car (entsel))))
  (setq dateatts (getbattswcmatch f "DATE#"))
  (mapcar
    '(lambda (da / n)	;(setq da (nth 2 dateatts))
       (setq n (car (reverse (sepstr* (vla-get-tagstring da)))))
       (if (= "" (vla-get-TextString (getbatt f (strcat "POST" n))) (vla-get-TextString (getbatt f (strcat "NAME" n))))
	 (vla-put-TextString da "")
	 (progn
	   (vla-put-TextString da "")
	   (vla-put-TextString da "%<\\AcVar Date \\f \"dd.MM.yy\">%")
	   ;(vla-put-TextString da (strcat (itoa releasedate) "." "%<\\AcVar Date \\f \"MM.yy\">%"))
	   ;(vla-put-TextString da "10.14")
	   )
	 )
       )
    dateatts
    )
  );defun










(defun cables-put-field (blk / att att1 att2 att3)
  (setq att (getbatt blk "SIGN"))
  (setq att1 (getbatt blk "TYPE"))
  (setq att2 (getbatt blk "CORES"))
  (setq att3 (getbatt blk "SECTION"))
  (vla-put-Textstring att
    (strcat
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att1))
      ">%).TextString>%"
      "  "
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att2))
      ">%).TextString>%"
      "x"
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att3))
      ">%).TextString>%"      
      )
    )
  ;(vl-cmdf "_updatefield" (vlax-vla-object->ename att) "")
  )




;(setq blk (vlax-ename->vla-object (car (entsel))))
(defun val-units-put-field (blk / att att1 att2)
  (setq att2 (getbatt blk "UNITS"))
  (setq att1 (getbatt blk "VAL"))
  (setq att (vlax-ename->vla-object (car (entsel))))
  
  (vla-put-Textstring att
    (strcat
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att1))
      ">%).TextString>%"
      " "
      "%<\\AcObjProp Object(%<\\_ObjId "
      (itoa (vla-get-ObjectID att2))
      ">%).TextString>%"
      )
    )
  (vl-cmdf "_updatefield" (vlax-vla-object->ename att) "")
  );defun


(defun revision-put-prjData (blk / pn pc custprops)
  ;(setq blk (vlax-ename->vla-object (car (entsel))))
  ;(setq pn (getbatt blk "PROJECT_NUMBER"))
  (setq pc (getbatt blk "PROJECT_CONTRACTNAME"))
  (setq custprops (sui:getcustomprops))
  ((lambda (prn) (vla-put-TextString (getbatt blk prn) (strcat "%<\\AcVar CustomDP." prn ">%"))) "PROJECT_NUMBER")
  (vla-put-TextString pc
    (strcat
      (antisep
	(mapcar
	  '(lambda (prn) (cadr (assoc prn custprops)))
	  '("PROJECT_CONTRACTNAME1" "PROJECT_CONTRACTNAME2" "PROJECT_CONTRACTNAME3")
	  ) " ")
      "\\P"
      (antisep
	(mapcar
	  '(lambda (prn) (cadr (assoc prn custprops)))
	  '("PROJECT_NAME1" "PROJECT_NAME2" "PROJECT_NAME3")
	  ) " ")
      )
    )
  );defun