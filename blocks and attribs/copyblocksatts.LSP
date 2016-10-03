;;; version 12_10_25

(defun c:cba ()
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (ss:kd:copyblocksatts)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun



(setq #cba*:attlist '("PROJECT_NUMBER" "PROJECT_CONTRACTNAME" "PROJECT_NAME" "DRAWING_NAME" "DRAWING_NUMBER" "DRAWING_SHEETQUANTITY") )
;(setq #cba*:attlist '("KKS" "NAME" "POZ" "CONNECTION" "MARK1" "MARK2" "MARK3" "MARK4"))
;(setq #cba*:attlist '("KKS" "NAME" "POZ" "CONNECTION" "MARK1" "MARK2" "MARK3"))

(defun c:cba* ()
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (ss:kd:copyblocksatts*)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun







(defun ss:kd:copyblocksatts ( / srclst destlst ;|err|;  )
  (if (= 1 (sslength (setq srclst (ssget '((0 . "INSERT")))))) (setq srclst (ss->lsto* srclst)) (setq srclst (ss->lsto srclst)))
  (if (= 1 (sslength (setq destlst (ssget '((0 . "INSERT")))))) (setq destlst (ss->lsto* destlst)) (setq destlst (ss->lsto destlst)))
  ;(setq err (vl-catch-all-apply 'mapcar (list kd:copyatts srclst destlst)))
  (mapcar 'kd:copyatts srclst destlst)
  )
(defun ss:kd:copyblocksatts* ( / srclst destlst ;|err|;  )
  (if (= 1 (sslength (setq srclst (ssget '((0 . "INSERT")))))) (setq srclst (ss->lsto* srclst)) (setq srclst (ss->lsto srclst)))
  (if (= 1 (sslength (setq destlst (ssget '((0 . "INSERT")))))) (setq destlst (ss->lsto* destlst)) (setq destlst (ss->lsto destlst)))
  ;(setq err (vl-catch-all-apply 'mapcar (list kd:copyatts srclst destlst)))
  (mapcar 'kd:copyatts* srclst destlst)
  )


(defun g:kd:copyblockatts ( / srcobj destobj ;|err|; )
  (setq srcobj (vlax-ename->vla-object (car (entsel))))
  (setq destobj (vlax-ename->vla-object (car (entsel))))
  (setq err (vl-catch-all-apply 'kd:copyatts (list srcobj destobj)))
  ;(kd:copyatts (list srcobj destobj))
  ;(VL-CATCH-ALL-ERROR-MESSAGE err)
  )


;(setq srcobj (vlax-ename->vla-object (car (entsel))))
;(setq destobj (vlax-ename->vla-object (car (entsel))))
;(setq srcatt (vlax-ename->vla-object (car (nentsel))))

(defun kd:copyatts (srcobj destobj / atts1 atts2)
    (if (and (= (vla-get-ObjectName srcobj) "AcDbBlockReference")
	     (= (vla-get-ObjectName destobj) "AcDbBlockReference"))
      
      (mapcar '(lambda (srcatt / destatt str al)
		 (setq str
			;(str:antimtext (vla-get-TextString srcatt))
		       (str|remove-multi-lines (vla-get-TextString srcatt))
		       )
		 (setq al (vl-remove-if-not '(lambda (x) (member (vla-get-tagstring x) (list (vla-get-TagString srcatt) (strcase (vla-get-TagString srcatt))))) (vlax-safearray->list (vlax-variant-value (vla-getattributes destobj)))))
		 (if al
		   (vla-put-TextString (car al) str)
		   (princ (strcat "\n==========Не найден аттрибут " (vla-get-TagString srcatt)))
		   )
		 )
	  (getbattswcmatch srcobj "*"))
      ;(mapcar '(lambda (x y) (vla-put-textstring x (vla-get-TextString y))) atts2 atts1)
      );if
  );defun




(defun kd:copyatts* (srcobj destobj / atts1 atts2)
  (if (and (= (vla-get-ObjectName srcobj) "AcDbBlockReference")
	   (= (vla-get-ObjectName destobj) "AcDbBlockReference"))
    (mapcar
      '(lambda (tag / str)
	 (setq str (kd-get-TextString (getbatt srcobj tag)))
	 (vla-put-TextString (getbatt destobj tag) str)
	 )
      #cba*:attlist
      )
    );if
  );defun









;; загружено в ktz-load
;;;(defun str:antimtext (str / nstr)
;;;  (setq str (vl-string-subst " " "\\P" str))
;;;  (setq str (vl-string-subst " " "\n" str))
;;;  (setq str (vl-string-trim " " str))
;;;  (while (/= str nstr)
;;;    (setq nstr str)
;;;    (setq str (vl-string-subst " " "  " nstr))
;;;    )
;;;  str
;;;  );defun










(defun ss:kd:copyblocksattswcm ( / srclst destlst
			  ;err
			  )
  (setq srclst (ss->lsto (ssget '((0 . "INSERT")))))
  (setq destlst (ss->lsto (ssget '((0 . "INSERT")))))
  ;(setq err (vl-catch-all-apply 'mapcar (list kd:copyatts srclst destlst)))
  (mapcar 'kd:copyattswcm srclst destlst)
  )



(defun kd:copyattswcm (srcobj destobj / atts1 atts2)
    (if (and (= (vla-get-ObjectName srcobj) "AcDbBlockReference")
	     (= (vla-get-ObjectName destobj) "AcDbBlockReference"))
      (mapcar '(lambda (x / att str)
		 (setq str (vla-get-TextString x))
		 (if (setq att (getbatt destobj (vla-get-TagString x)))
		   (vla-put-TextString att str)
		   )
		 )
	      ;(getbattswcmatch srcobj "*SIGNALNAME*")
	      (getbattswcmatch srcobj "*ФАМИЛИЯ*")
	      )
      ;(mapcar '(lambda (x y) (vla-put-textstring x (vla-get-TextString y))) atts2 atts1)
      );if
  );defun


;(kd:copyattswcm (vlax-ename->vla-object (car (entsel))) (vlax-ename->vla-object (car (entsel))))

;(vla-put-ScaleFactor (car (getbattswcmatch (vlax-ename->vla-object (car (entsel))) "*ФАМИЛИЯ_ГИП*"))0.9)
