;13_01_29

(defun extract-from-block (blk taglist)
  (mapcar '(lambda (name)
	     (vla-get-TextString (getbatt blk name))
	     )
	  taglist)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq asslst-mont
(mapcar 'list
(mapcar '(lambda (x)
	   (vla-get-TextString x)
	   )
	(ss->lsto (ssget)))


(mapcar '(lambda (x)
	   (vla-get-TextString (getbatt x "POZ"))
	   ;(extract-from-block x '("POZ"))
	   )
	(ss->lsto (ssget)))
	))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;ss->tbl
(setq asslst-el
(mapcar 'list
(mapcar '(lambda (x)
	   (vla-get-TextString x)
	   )
	(ss->lsto (ssget)))


(mapcar '(lambda (x)
	   (vla-get-TextString x)
	   )
	(ss->lsto (ssget)))
	))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq data
       (mapcar '(lambda (x)
		  (list
		    (vla-get-TextString (getbatt x "CODE"))
		    (vla-get-TextString (getbatt x "ID"))
		    )
		  )
	       (ss->lsto (ssget))
       )
      )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    1
(if (not (setq sss (ssget "_I" '((0 . "INSERT")))))
  (setq sss (ssget '((0 . "INSERT"))))
  )
(setq sss (vl-remove-if-not '(lambda (x) (= "ÎÂ_òàáëè÷êà" (vla-get-EffectiveName x))) (ss->lsto* sss)))
(length sss)

(setq nom-poz
       (mapcar '(lambda (x)
		  (list
		    (vla-get-TextString (getbatt x "ÍÎÌÅÐ"))
		    (vla-get-TextString (getbatt x "ÏÎÇÈÖÈß"))
		    )
		  )
	       sss
       )
      )

;    2
;(setq lst (mapcarx vla-get-TextString nil (ss->tbl (ssget))))
(setq lst (mapcarx vlax-vla-object->ename nil (ss->tbl (ssget))))
(setq poz-naz
       (mapcar '(lambda (l)
	   (mapcar '(lambda (x)
		      (cdr (assoc 1 (entget x)))
		      ) l)
	   ) lst)
      )
;    3
(setq nom-naz
       (mapcar '(lambda (x)
		  (list
		    (car x)
		    (cadr (assoc (cadr x) poz-naz))
		    )
		  ) nom-poz)
       )
(setq nom-naz (vl-sort nom-naz '(lambda (a b)(< (atoi (car a)) (atoi (car b))))))

;	4
(setq nom-naz
       (mapcar '(lambda (x)
		  (list
		    (vla-get-TextString (getbatt x "ÍÎÌÅÐ"))
		    (strcat "- 24 Â ïîç. "
		      (vla-get-TextString (getbatt x "ÏÎÇÈÖÈß"))
		      )
		    )
		  )
	       (ss->lsto (ssget))
       )
      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq x (vlax-ename->vla-object (car (entsel))))
;self-changing
(mapcar '(lambda (x)
	   (vla-put-textstring x
	     (cadr (assoc (vla-get-textstring x) data))
	     )
	   )
  (ss->lsto (ssget))
  )






(setq x (vlax-ename->vla-object (car (ENTSEL))))

(mapcar
  '(lambda (x)
     (vla-put-TextString (getbatt x "ID")
       (cadr
	 (assoc
	   (cadr
	     (assoc
	       (vla-get-TextString (getbatt x "CODE"))
	       asslst-mont)
	     )
	   (mapcar 'reverse asslst-el)
	   )
	 )
       )
     )
  (ss->lsto* (ssget)))




(mapcar
  '(lambda (x)
     (vla-put-TextString (getbatt x "POZ")
       (cadr
	 (assoc
	   (vla-get-TextString (getbatt x "CODE"))
	   data
	   )
	 )
       )
     )
  (ss->lsto* (ssget))
  );mapcar























(defun swapatts ()
(mapcar '(lambda (x / tmp)
	   (setq tmp (vla-get-TextString (getbatt x "LOCFLD")))
	   (vla-put-TextString (getbatt x "LOCFLD")
	     (vla-get-TextString (getbatt x "LOCCAB"))
	     )
	   (vla-put-TextString (getbatt x "LOCCAB") tmp)
	   )
	(ss->lsto (ssget))
	)
  )
	

 