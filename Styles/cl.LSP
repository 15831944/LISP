(vl-load-com)
(setq #actdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
;;; version 12_11_19
(load (strcat #lisppath "strings\\strcut.lsp"))



;;;(princ "(sssetfirst nil (ssget '((0 . \"*TEXT\")(1 . \"*`?*\"))))")
;;;  (setq txto (vla-AddMText #modspace (vlax-3D-Point '(0 0 0)) 0 ""))
;;;  (vlax-put-property txto "TextString"
;;;    (strcat
;;;    "\n" "(sssetfirst nil (ssget \"_X\" '((0 . \"MULTILEADER\"))))"
;;;    "\n" "(sssetfirst nil (ssget \"_X\" '((0 . \"MTEXT\"))))"
;;;    "\n" "(sssetfirst nil (ssget \"_X\" '((0 . \"*TEXT\") (1 . \"*`?*\"))))"
;;;    "\n" "(sssetfirst nil (ssget \"_X\" '((0 . \"*TEXT\") (1 . \"*`#*\"))))"
;;;    "\n" "(sssetfirst nil (ssget \"_X\" '((0 . \"*TEXT\") (1 . \"*%%С*\"))))"
;;;    "\n" "(sssetfirst nil (ssget \"_X\" '((0 . \"*TEXT\") (1 . \"\"))))"
;;;    "\n" "(sssetfirst nil (ssget \"_X\" '((0 . \"*TEXT\") (1 . \" \"))))"
;;;    )
;;;    )




;-----------------------------------------------------------------------------------------
;             MAUN FUNCTION
;-----------------------------------------------------------------------------------------
(defun c:cl ( / txto ) ;; #actdoc)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0) T))
  (vla-sendcommand #actdoc "_spexplodeall ")
  (vla-sendcommand #actdoc "(cl:explode-proxy) ")
  (vla-sendcommand #actdoc "(cl:delete-fields) ")
  (vla-sendcommand #actdoc "(cl:cleanup) ")
  (acet-error-restore)
  (vla-endundomark #actdoc)
  ;(vl-cmdf "_zoom" "o" (vlax-vla-object->ename txto))
  );defun c:clean


(defun ss->lsto* (ss / lsto)
  (setq lsto (reverse (ssnamex ss)))
  (while (listp (cadar lsto))
    (setq lsto (cdr lsto)))
  (mapcar '(lambda (x) (vlax-ename->vla-object (cadr x))) lsto)
  );defun

(defun cl:sepstr (strline delimiter / strhead strtail poz)
  (if (setq poz (vl-string-search delimiter strline))
    (progn (setq strhead (substr strline 1 poz) strtail (substr strline (+ poz 1 (strlen delimiter))))
      (append (list strhead) (sepstr strtail delimiter)))
    (list strline)
    );if
  );defun

(defun cl:modent (ent pp / head eng)
  (setq head (car pp))
  (setq eng (entget ent))
  (setq eng (subst pp (assoc head eng) eng))
  (entmod eng)
  (entupd ent)
  );defun


(defun antisep (lst del)
  (vl-string-right-trim del (apply 'strcat (mapcar '(lambda (x) (strcat x del)) lst)))
  );defun
(defun getlttsts (lt)	;; get linetype text styles
  (mapcar
    '(lambda (a) (vlax-ename->vla-object (cdr a)))
    (vl-remove-if-not '(lambda (x) (= 340 (car x))) (entget (vlax-vla-object->ename lt)))
    )
  );defun
(defun isltspds (lt)
  (apply 'or (mapcar '(lambda (ts) ;(setq ts (car (getlttsts lt)))
	(null (or (member (strcase (vla-get-name ts)) (mapcar 'strcase #allowedtextstyles)) (= "" (vla-get-name ts)))))
	(getlttsts lt)
	))
    );defun




  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun exportlinetype (lto fpath / fo ltlist ltname ltdesc ltdef wval def)
    (defun get74 (wlist / ass74 rval)
      (setq ass74 (cdr (assoc 74 wlist)))
      (cond
	((= ass74 0) (return nil nil nil nil))
	((= ass74 1) (return (cdr (assoc 2 (entget (cdr (assoc 340 wlist))))) nil "A" nil))
	((= ass74 2) (return (cdr (assoc 2 (entget (cdr (assoc 340 wlist))))) (cdr (assoc 9 wlist)) "R" nil))
	((= ass74 3) (return (cdr (assoc 2 (entget (cdr (assoc 340 wlist))))) (cdr (assoc 9 wlist)) "A" nil))
	((= ass74 4) (return (cdr (assoc 3 (entget (cdr (assoc 340 wlist))))) nil "R" (cdr (assoc 75 wlist))))
	((= ass74 5) (return (cdr (assoc 3 (entget (cdr (assoc 340 wlist))))) nil "A" (cdr (assoc 75 wlist))))
	(T (return nil nil nil nil))
	)
      rval
      );defun
    (defun return (shx text rot shp / ttext test)
      (setq test (cdr (assoc 50 wlist)))
      (if (and test rot) (setq rot (strcat rot "=" (angtos test))))
      (setq test (cdr (assoc 46 wlist)))
      (if (and test rot) (setq rot (strcat rot ",S=" (rtos test 2 8))))
      (setq test (cdr (assoc 44 wlist)))
      (if (and test rot) (setq rot (strcat rot ",X=" (rtos test 2 8))))
      (setq test (cdr (assoc 45 wlist)))
      (if (and test rot) (setq rot (strcat rot ",Y=" (rtos test 2 8))))
      (if text (setq ttext (strcat ",[\"" text "\"," shx "," rot "]")))
      (if (and (not text) shp) (setq ttext (strcat ",[" (getname shp shx) "," shx "," rot "]")))
      (setq rval ttext)
      );defun
    (defun getname (shape shapefile / sfn lownum charcount shpcount zerocount this name char1)
      (if (setq sfn (open (findfile shapefile) "r"))
	(progn
	  (repeat 23 (read-char sfn))
	  (setq lownum (read-char sfn)) (read-char sfn)
	  (setq charcount (- shape lownum)) 
	  (setq hignum (read-char sfn)) (read-char sfn)
	  (setq shpcount (read-char sfn)) (read-char sfn)
	  (repeat (* shpcount 4) (read-char sfn))
	  (setq zerocount 0)
	  (while (< zerocount (* charcount 2))
	    (setq this (read-char sfn))
	    (if (= this 0) (setq zerocount (1+ zerocount))))
	  (setq char1 (read-char sfn))
	  (setq name "")
	  (while (/= 0 char1)
	    (setq name (strcat name (chr char1)))
	    (setq char1 (read-char sfn))
	    )
	  (close sfn)
	  name
	  )
	)
      );defun

    (setq ltlist (entget (vlax-vla-object->ename lto)))
    (setq fo (open fpath "w"))
    (setq ltname (strcat "*" (strcase (cdr (assoc 2 ltlist)))))
    (setq ltdesc (cdr (assoc 3 ltlist)))
    (setq ltdef "A" wval nil)
    (setq ltlist (member (assoc 49 ltlist) ltlist))
    (while (assoc 49 ltlist)
      (setq def (cdr (assoc 49 ltlist)))
      (setq def (strcat "," (rtos def 2 8)))
      (setq ltdef (strcat ltdef def))
      (setq ltlist (cdr (member (assoc 49 ltlist) ltlist)))
      (setq wval (get74 ltlist))
      (if wval (setq ltdef (strcat ltdef wval)))
      );while
    (if (/= ltdef "A")
      (progn
	(write-line (strcat ltname "," ltdesc) fo)
	(write-line ltdef fo)
	)
      )
    (close fo)
    );defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun cl:getTextString (obj / o str)
  (setq o (if (= 'ENAME (type obj)) (vlax-ename->vla-object obj) obj))
  (setq str (cond
       ((= 'VLA-OBJECT (type obj)) (vlax-vla-object->ename obj))
       ((= 'ENAME (type obj)) obj)))
  (cond
    ((= "MULTILEADER" (cdr (assoc 0 (entget str)))) (setq str (list (assoc 304 (entget str)))))
    (T (setq str (vl-remove-if-not '(lambda (x) (member (car x) '(3 1))) (entget str))))
    )
  (if (and (= "AcDbAttribute" (vla-get-ObjectName o))
	   (= :vlax-true (vla-get-MTextAttribute o)))
    (setq str (cdr str))
    )
  (cond
    ((and (= 1 (length str)) (null (assoc 3 str))) (cdar str))
    ((and (= 2 (length str)) (null (assoc 3 str))) (cdadr str))
    ((and (= 2 (length str)) (assoc 3 str)) (apply 'strcat (mapcar 'cdr str)))
    ((and (= 3 (length str)) (assoc 3 str)) (apply 'strcat (mapcar 'cdr str)))
    ((and (< 3 (length str)) (assoc 3 str)) (apply 'strcat (mapcar 'cdr str)))
    )
  );defun






;-----------------------------------------------------------------------------------------
;             разбивание proxy
;-----------------------------------------------------------------------------------------
(defun cl:explode-proxy ( / ss)
  (setq ss (ssget "_X" '((0 . "ACAD_PROXY_ENTITY"))))
  (sssetfirst nil ss)
  (vla-sendcommand #actdoc "_explode")
  (vla-sendcommand #actdoc " ")
  ;(setq lst (ss->lsto* (ssget "_X" '((0 . "ACAD_PROXY_ENTITY")))))
  );defun
;(cl:explode-proxy)

;-----------------------------------------------------------------------------------------
;             удаление полей
;-----------------------------------------------------------------------------------------
(defun cl:delete-fields (/ objlist)
  (setq objlist (ss->lsto* (ssget "_X" '((-4 . "<OR")(0 . "*TEXT")(0 . "ATTDEF")(0 . "INSERT")(0 . "MULTILEADER")(-4 . "OR>")))))
  (setq objlist (vl-remove-if '(lambda (x) (and (= "AcDbBlockReference" (vla-get-ObjectName x)) (= :vlax-false (vla-get-HasAttributes x)))) objlist))
  (mapcar 'delete-field objlist)
  );defun
(defun cl:delete-field (obj / str)
  (if (= "AcDbBlockReference" (vla-get-ObjectName obj))
    (mapcar 'delete-field (vlax-safearray->list (vlax-variant-value (vla-GetAttributes obj))))
    (progn
      (setq str (kd-get-TextString obj))
      (vla-put-textstring obj "#clean-delete-fields#tempstring#")
      (vlax-put-property obj "TextString" str)
      )
    );if
  );defun

(defun cl:putmtxtwf (obj wf)
  (vla-put-textstring obj (strcat "{\\W" (rtos wf) ";" (kd-get-TextString obj) "}" ))
  );defun




(defun loaddimstyle ( / dstyles ds)
  ;(setq $drw (vla-add (vla-get-Documents #cad) "d:\\_LISP\\OUTGO\\bnp-styles.dwt"))
  (setq	tmpblkstyles (vla-InsertBlock #modspace (vlax-3d-point '(0 0 0))
		       "d:\\_LISP\\OUTGO\\bnp-styles.dwt"
		       1 1 1 0))
  (vla-delete tmpblkstyles)
  )
       

;-----------------------------------------------------------------------------------------
;             разбивание блоков и полиилиний, учистка мусора
;-----------------------------------------------------------------------------------------
(defun cl:cleanup (
		   /
		   lstate
		   layers
		   lst textstyles ts:standard
		   lintypestoclone
		   )
  ;;********************************************************************************************
  (defun procblock (blk / )
    (vlax-for obj blk (proclinetype obj))
    (vlax-for obj blk
      (cond
	;((= "AcDbBlockReference" (vla-get-ObjectName obj))
	; (procblock obj))
	((= "AcDbAttributeDefinition" (vla-get-ObjectName obj))
	 (proctext obj))
	((= "AcDbText" (vla-get-ObjectName obj))
	 (proctext obj))
	((= "AcDbMText" (vla-get-ObjectName obj))
	 (procMtext obj))
	((or
	   (= "AcDbRotatedDimension" (vla-get-ObjectName obj))
	   (= "AcDbDiametricDimension" (vla-get-ObjectName obj))
	   (= "AcDbLeader" (vla-get-ObjectName obj))
	   )
	 (procDim obj))
	(T (princ))
	
	);cond
      )
    );defun
  ;;********************************************************************************************
  (defun proclinetype (obj)
    (if (member (vla-get-Linetype obj) (mapcar 'vla-get-name lintypestoclone))
      (vla-put-Linetype obj (strcat (vla-get-Linetype obj) "-clone"))
      )
    );defun
  ;;********************************************************************************************
  (defun procDim (obj)
    (if (null (member (vla-get-StyleName obj) #allowedDimStyles))
      (vla-put-StyleName obj dsname)
      )
    );defun
  ;;********************************************************************************************
  (defun proctext (obj)
    ;(vla-put-ScaleFactor obj 0.765)
    (vla-put-ScaleFactor obj 0.8)
    (vla-put-stylename obj tsname)
    (vla-put-ObliqueAngle obj 0)
    );defun
  ;;********************************************************************************************
  (defun procMtext (obj)
    (cl:putmtxtwf obj 0.8)
    (vla-put-stylename obj tsname)
    );defun
  ;;********************************************************************************************



  
  
  

  ;;------------------------------------------------------------------------------------------------
  ;;------------------------------------- MAIN STREAM ----------------------------------------------
  ;;------------------------------------------------------------------------------------------------
  (setq layers (vla-get-Layers #actdoc))
  (vla-put-ActiveLayer #actdoc (vla-item layers "0"))

  ;; saving layer states
  (setq lstate '())
  (vlax-for l layers
    (setq lstate (cons (list (vla-get-name l) (vla-get-Freeze l) (vla-get-Lock l) (vla-get-LayerOn l)) lstate))
    (if (/= (vla-get-name l) "0")
      (progn (vla-put-Freeze l :vlax-false) (vla-put-Lock l :vlax-false) (vla-put-LayerOn l :vlax-true))
      )
    )
  ;;; 1 dimstyles
  (setq #allowedDimStyles '("Standard" "Standard VR"))
  (setq dsname "Standard")
  (setq dimstyles (vla-get-DimStyles #actdoc))
  (if (null (member dsname (mapcar 'vla-get-name (kd-container->list dimstyles))))
    (loaddimstyle)
    )
  (setq ds:standard (vla-item dimstyles dsname))
    
    
  (vla-put-ActiveDimStyle #actdoc ds:standard)

  (setq #allowedtextstyles '("STANDARD" "st_ТМО"))
  ;(setq tsname "STANDARD")
  (setq tsname "BNP")
  (setq textstyles (vla-get-TextStyles #actdoc))
  (setq ts:standard (vla-item textstyles tsname))
  (vla-put-ActiveTextStyle #actdoc ts:standard)



  
  (setq linetypes (vla-get-Linetypes #actdoc))
  (setq lintypestoclone (vl-remove-if-not 'isltspds (kd-container->list linetypes)))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; generating clones of spds-textstyle-dependened linetypes
  (mapcar
    '(lambda (lt / ltname fsrc fdest hfsrc hfdest line tmp)
       (setq ltname (vla-get-name lt))
       (setq fsrc "D:\\tst.lin")
       (exportlinetype lt fsrc)
       (setq fdest "D:\\tst1.lin")
       (setq hfdest (open fdest "w"))
       (setq hfsrc (open fsrc "r"))
       (while (setq line (read-line hfsrc))
	 (cond
	   ((wcmatch line "`**")
	    (setq tmp (sepstr line ","))
	    (setq line (antisep (list (setq ltname (strcat (car tmp) "-clone")) (cadr tmp)) ","))
	    )
	   (T
	    (mapcar
	      '(lambda (ltn)
		 (setq line (antisep (subst (vla-get-name ts:standard) ltn (sepstr line ",")) ","))
		 )
	      (mapcar 'vla-get-name (getlttsts lt))
	      )
	    )
	   )
	 (write-line line hfdest)
	 )
       (close hfdest)
       (close hfsrc)
       ;загрузить созданный клон типа линии
       (vla-load linetypes ltname fdest)
       )
    lintypestoclone
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  

  (vlax-for ablock (vla-get-blocks #actdoc)
    (procblock ablock)
    )


  ;(do textstyles)

;;;  (vlax-for ts textstyles
;;;    (if (null (member (strcase (vla-get-name ts)) (mapcar 'strcase #allowedtextstyles) ))
;;;      (vla-delete ts)
;;;      )
;;;    )

  ;;; чистка размерных стилей
  ;(vlax-for ds dimstyles (if (/= (vla-get-name ds:standard) (vla-get-name ds)) (vla-delete ds)))


  
  (vla-purgeall #actdoc)
  (vla-purgeall #actdoc)
  (vla-purgeall #actdoc)
  (vla-purgeall #actdoc)
  ;audit

  (vlax-for l layers 
    (if (/= (vla-get-name l) "0")
      (mapcar
	'(lambda (fun arg)
	   (eval (list fun 'l arg))
	   )
	'(vla-put-Freeze vla-put-Lock vla-put-LayerOn)
	(cdr (assoc (vla-get-name l) lstate))
	)
      )
    )
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;(entget
;;;(cdr (assoc 344
;;;(entget (vlax-vla-object->ename (vla-item dimstyles "SPDS")))
;;;       ))
;;;)
	







;;;
;;;
;;;
;;;
;;;  (setq dicts (vla-get-dictionaries #actdoc))
;;;  (mapcar
;;;    '(lambda (x)
;;;       (if
;;;	 (vlax-property-available-p x "name")
;;;	 (princ (strcat "\n" (vla-get-name x)))
;;;	 )
;;;       )
;;;    (kd-container->list dicts)
;;;    )
;;;
;;;  
;;;  (do (setq mcs (vla-item dicts "MCS_STREAM_DICT")))
;;;  (vla-Delete mcs)
;;;
;;;  (do (vla-item mcs 0))
;;;
;;;  (setq xr (vla-item mcs 0))
;;;
;;;  (defun kd:getxrecdata (xrec / sa1 sa2)
;;;  (vla-getXrecordData xrec 'sa1 'sa2)
;;;  (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
;;;  );defun
;;;
;;;  (vlax-safearray->list (last (kd:getxrecdata xr)))
;;;
;;;  (vla-delete (vla-item mcs 0))
;;;  (vla-delete (vla-item mcs 1))
;;;  (vla-delete (vla-item mcs 2))
;;;
;;;
;;;  