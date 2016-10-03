;;отбор по маске
;;P137-2




(defun c:asd ()
  (sssetfirst nil (ssget '((1 . "*##@@@##@@###*"))))
  )



(sssetfirst nil (ssget '((1 . "*##@@@## ####*"))))



(sssetfirst nil (ssget '((1 . "терминал"))))


(sssetfirst nil (ssget '((1 . "*###-#"))))

(sssetfirst nil (ssget '((1 . "*###-#*"))))

(sssetfirst nil (ssget '((1 . "3N-###"))))


(sssetfirst nil (ssget '((0 . "*TEXT")(1 . "peзepв-#"))))



(sssetfirst nil (ssget '((1 . "*Метран*"))))




(sssetfirst nil (ssget '((1 . "*  *"))))
(sssetfirst nil (ssget '((1 . "*выходных*"))))

(sssetfirst nil (ssget '((1 . "UA*"))))



(sssetfirst nil (ssget '((1 . "*Sheet #*"))))
(sssetfirst nil (ssget '((1 . "*CRE03*"))))
(sssetfirst nil (ssget '((1 . "*73*"))))


(sssetfirst nil (ssget '((1 . "*3DTBA2*"))))
CRE03R1M

(sssetfirst nil (ssget '((1 . "*CRE03R*"))))
(sssetfirst nil (ssget '((1 . "*`#*"))))

(sssetfirst nil (ssget '((1 . "*^*"))))

(sssetfirst nil (ssget '((1 . "*7306*"))))


(sssetfirst nil (ssget '((1 . "*7003*"))))



(sssetfirst nil (ssget '((1 . "*BJJ*"))))


(defun pickstring (/ ss obj str)
  (setq str (car (kd:dcledtlst '(""))))
  (setq ss (ssget '((0 . "*TEXT,INSERT,MULTILEADER"))))
  (setq ss (ss->list* ss))
  (vl-remove-if-not '(lambda (x)
	(wcmatch str (vla-get-textstring
		       (if (= "INSERT" (cdr (assoc 0 (entget x))))
			 ;если блок
			 
			 ;если не блок
			 (vlax-ename->vla-object x)
			 )
		       ))
		       )ss)
  
  )



(vl-remove-if-not
  '(lambda (x) (= (vla-get-tagstring att)(vla-get-tagstring x)))
  objlstl)













(setq ss (ssget "_X" '((0 . "MTEXT"))))


(setq lst (ss->lsto* ss))




(vla-get-TextString (vlax-ename->vla-object (car (entsel))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq cabstrmask "##@@@##")
(setq senskksstrmask "##@@@##@@###")
(setq markksstrmask "##@@@##@@##")



(defun iscabinetmask (str)
  (wcmatch
    str
    (strcat
      "##@@@##" " *" ","
      "* " "##@@@##" " *" ","
      "* " "##@@@##"
      ))
  );defun

(defun issensinetmask (str)
  (wcmatch
    str
    (strcat
      "##@@@##@@###" " *" ","
      "* " "##@@@##@@###" " *" ","
      "* " "##@@@##@@###"
      ))
  );defun


(defun ismarkmask (str)
  (wcmatch
    str
    (strcat
      "##@@@##@@###" " *" ","
      "* " "##@@@##@@###" " *" ","
      "* " "##@@@##@@###"
      ))
  );defun





(wcmatch
  (vla-get-TextString (vlax-ename->vla-object (car (entsel))))
  "*##@@@##@@##*"
  )


(isstrcontmask
  (vla-get-TextString (vlax-ename->vla-object (car (entsel))))
  cabstrmask
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








(setq ss (ssget '((0 . "*TEXT"))))
(setq lst (ss->lsto* ss))
(length lst)
(sssetfirst nil (lst-to-ss lst))

(setq ans
(vl-remove-if-not
  '(lambda (s)
     (wcmatch
       (vla-get-textstring s)
       "*##@@@##*"
       )
     )
  lst
  )
      )
(length ans)
(sssetfirst nil (lst-to-ss ans))


(setq ans
(vl-remove-if
  '(lambda (s)
     (wcmatch
       (vla-get-textstring s)
       "*06@@@##*"
       )
     )
  ans
  )
      )

(length ans)


(sssetfirst nil (lst-to-ss ans))














(progn
  (if (null (setq ss (ssget "_I" '((0 . "*TEXT"))))) (setq ss (ssget '((0 . "*TEXT")))) )
  (setq lst (ss->lsto* ss))
  (setq ans (vl-remove-if-not '(lambda (s) (wcmatch (vla-get-textstring s) "*##@@@##@@###*" )) lst))
  (length ans)
  (sssetfirst nil (lst-to-ss ans))
  )


(progn
  (if (null (setq ss (ssget "_I" '((0 . "*TEXT"))))) (setq ss (ssget '((0 . "*TEXT")))) )
  (setq lst (ss->lsto* ss))
  (setq ans (vl-remove-if-not '(lambda (s) (wcmatch (vla-get-textstring s) "*КВВГЭн*" )) lst))
  (length ans)
  (sssetfirst nil (lst-to-ss ans))
  )



(progn
  (if (null (setq ss (ssget "_I" '((0 . "*TEXT"))))) (setq ss (ssget '((0 . "*TEXT")))) )
  (setq lst (ss->lsto* ss))
  (setq ans (vl-remove-if-not '(lambda (s) (wcmatch (vla-get-textstring s) "*К6-656*" )) lst))
  (length ans)
  (sssetfirst nil (lst-to-ss ans))
  )


(progn
  (if (null (setq ss (ssget "_I" '((0 . "*TEXT"))))) (setq ss (ssget '((0 . "*TEXT")))) )
  (setq lst (ss->lsto* ss))
  (setq ans (vl-remove-if-not '(lambda (s) (wcmatch (vla-get-textstring s) "*@6-*" )) lst))
  (length ans)
  (sssetfirst nil (lst-to-ss ans))
  )



(mapcar
  '(lambda (txt / str strl nstr)	;(setq txt (vlax-ename->vla-object (car (entsel))))
     (setq str (kd-get-textstring txt))
     (setq strl (sepstr* str))
     (if (= "08" (car strl))
       (vla-put-TextString txt
	 (antisep (cons "06" (cdr strl)) "")
	 )
       )

     
     )
  lst)






(setq ss (ssget '((0 . "*TEXT"))))
(setq lst (ss->lsto* ss))
(length lst)
(setq pozlist '("М6-К2" "М6-К4" "М6-А1" "М6-А26"))

(setq ans
(vl-remove-if-not
  '(lambda (s)
     (wcmatch
       (vla-get-textstring s)
       (strcat
	 (antisep pozlist ",") ","
	 "*" (antisep pozlist "*,*") "*"
	 )
       )
     )
  lst
  )
      )
(length ans)
(sssetfirst nil (lst-to-ss ans))









(setq lst (vl-remove-if-not '(lambda (x) (= (vla-get-EffectiveName x) "PID_instrument" )) (ss->lsto* (ssget "_X" '((0 . "INSERT"))))))
(length lst)
(setq ans (vl-remove-if-not '(lambda (x) (wcmatch (kd-get-textstring (getbatt x "POZ")) "*CF*")) lst))
(length ans)
(sssetfirst nil (lst-to-ss ans))
































(defun c:asd ( / obj str l)
  (if (setq obj (nentsel))
    (progn
      (setq obj (vlax-ename->vla-object (car obj)))
      (setq str (kd-get-textstring obj))
      (setq l (sepstr* str))
      (setq str (antisep (if (= "11" (car l)) (cons "12" (cdr l)) l) ""))
      (vla-put-textstring obj str)
      )
    )
  );defun





(setq pattern "*11@@@##*")
(setq pattern "*11HAC20AA001*")
(setq pattern "*11LBA10AA001*")
(setq pattern "*11LBA10AA002*")

(setq pattern "*11HAH30AA001*")


(setq pattern "*КУ `№ 1*")



(defun c:hl ( / ss lst f:check)
  (defun f:check (obj)
    (cond
      ((member (vla-get-ObjectName obj) '("AcDbText" "AcDbMText" "AcDbMLeader""AcDbAttribute"))
       (wcmatch (vla-get-textstring obj) pattern)
       )
      ((member (vla-get-ObjectName obj) '("AcDbAttributeDefinition"))
       (wcmatch (vla-get-tagstring obj) pattern)
       )
      ((and
	 (member (vla-get-ObjectName obj) '("AcDbBlockReference"))
	 (= :vlax-true (vla-get-HasAttributes obj))
	 )
       (apply 'or (mapcar 'f:check (getbattswcmatch obj "*")))
       )
      )
    )
  (if (not (setq ss (ssget "_I")))
    (setq ss (ssget "_X" '((0 . "*TEXT,ATTDEF,INSERT,MULTILEADER"))))
    )
  (setq lst (ss->lsto* ss))
  (setq lst (vl-remove-if-not '(lambda (o) (f:check o)) lst))
  (sssetfirst nil (lst-to-ss lst))
  );defun






