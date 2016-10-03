;(load (strcat #lisppath "common functions\\getbdyn.lsp"))


(defun klength (/	
		ss
		i
		ent
		efname
		dlin
		kl-sts25
		kl-sts25mt
		kl-sts25pe
		kl-sts4pe
		kl-st4hesi
		kl-st4hedi
		ubed
		fbs
		otvet
		unknown
		)
  (setq ss (ssget '((0 . "INSERT")))
	i		0
	dlin		0
	avtomat		0
	kl-sts25	0
	kl-sts25mt	0
	kl-sts25pe	0
	kl-sts4pe	0
	kl-st4hesi	0
	kl-st4hedi	0
	ubed		0
	fbs		0
	unknown		'()
	)
  (repeat (sslength ss)
    (cond
      ((member
	 (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))
	 '("wiring_автомат-клеммник")
	 )
       (setq dlin (+ dlin 18) avtomat (1+ avtomat))
       )
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ((member
	 (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))
	 '("монтаж_STS-2.5" "wiring_STS-2.5")
	 )
       (setq dlin (+ dlin 5.2) kl-sts25 (1+ kl-sts25))
       )

      ((member
	 (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))
	 '("монтаж_STS-2.5-MT" "wiring_STS-2.5-MT")
	 )
       (setq dlin (+ dlin 5.2) kl-sts25mt (1+ kl-sts25mt))
       )

      
      
      ((member
	 (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))
	 '("монтаж_STS-4-PE" "wiring_STS-4-PE")
	 )
       (setq dlin (+ dlin 6.2) kl-sts4pe (1+ kl-sts4pe))
       )
      ((member
	 (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))
	 '("wiring_STS-2.5-PE")
	 )
       (setq dlin (+ dlin 5.2) kl-sts4pe (1+ kl-sts4pe))
       )


      
      ((member
	 (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))
	 '("монтаж_ST4-HESI" "wiring_ST-4-HESI")
	 )
       (setq dlin (+ dlin 6.2) kl-st4hesi (1+ kl-st4hesi))
       )
      ((member
	 (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))
	 '("монтаж_ST4-HEDI" "wiring_ST-4-HEDI")
	 )
       (setq dlin (+ dlin 6.2) kl-st4hedi (1+ kl-st4hedi))
       )
      ((member
	 (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))
	 '("монтаж_UBE-D" "wiring_UBE-D")
	 )
       (setq dlin (+ dlin 20) ubed (1+ ubed))
       )
      

      ((member
	 (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))
	 '("монтаж_FBS-X-5")
	 )
       (setq fbs (1+ fbs))
       )
      ( T (setq unknown (append unknown (list (vla-get-Effectivename (vlax-ename->vla-object (ssname ss i)))))))
      );cond
    
    (setq i (1+ i))
    );repeat
(princ
(strcat
  "\n******************************************"
  "\n****** В данном клеммнике найдено : ******"
  "\n******   Автоматов C60N: " (itoa avtomat) "               ******"
  "\n******************************************"
  "\n******   STS-2.5    : " (itoa kl-sts25) "               ******"
  "\n******   STS-2.5-МТ : " (itoa kl-sts25mt) "               ******"
  "\n******   STS-2.5-PE : " (itoa kl-sts25pe) "               ******"
  "\n******   STS-4-PE   : " (itoa kl-sts4pe) "               ******"
  "\n******   STS-4-HESI : " (itoa kl-st4hesi) "               ******"
  "\n******   STS-4-HEDI : " (itoa kl-st4hedi) "               ******"
  "\n------------------------------------------"
  "\n******  всего клемм : " (itoa (+ kl-sts25 kl-sts25mt kl-sts4pe kl-st4hesi kl-st4hedi)) "                ******"
  "\n------------------------------------------"
  "\n******   UBE-D      : " (itoa ubed) "                ******"
  "\n******   FBS-X-5    : " (itoa fbs) "                ******"
  "\n------------------------------------------"
  "\n****** Длина клеммника : " (rtos dlin) " мм   ******"
  "\n******************************************"
  ))

  (princ "\n")
  (princ (compress-list unknown))
  (princ)
  );defun












;(setq ans (clamp-content))
(defun clamp-content (
		      /
		      ss
		      i
		      lst
		      )
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		) T))
  ;;;===========================================================================================
  (setq ss (ssget '((0 . "INSERT"))))
  (setq lst (mapcar '(lambda (x) (vla-get-EffectiveName (vlax-ename->vla-object x)))
		    (ss->list* ss))
	lst (compress-list lst))
  ;;;===========================================================================================
  (acet-error-restore)
  (vla-endundomark #actdoc)
  lst
  );defun







;;;(setq l '("a" "a" "a" "a" "n" "j" "ufi" "od" "oeo" "odi" "idd" "osd" "idfsid" "idso" "iodso" "sdod" "oi" "dsoid"))
;(compress-list '("a" "a" "a" "a" "n" "a" "j" "ufi" "od" "oeo" "odi" "idd" "osd" "idfsid" "idso" "iodso" "sdod" "oi" "dsoid"))
;(ziplist '(("a" "a" "a" "a" "n" "j" "ufi" "od" "oeo" "odi" "idd" "osd" "idfsid" "idso" "iodso" "sdod" "oi" "dsoid")))
(defun compress-list (lst / clst)
  (setq clst '())
  (foreach item lst
    (if (assoc item clst)
      (setq clst (subst
		   (list item (1+ (cadr (assoc item clst))))
		   (assoc item clst)
		   clst))
      (setq clst (append clst (list (list item 1))))
      )
    );foreach
  clst
  );defun


;	5	10	15	20	45 	95
;	0	1	2	3	4	5
;nlist (2	3	4	5	10	20	)
		


(defun fbs ( / fbslist pl)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))

  (setq fbslist
	 (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) '("монтаж_FBS-X-5")))
	   (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
	   ))
  (setq pl (mapcar '(lambda (x) (vlax-variant-value (vla-get-Value (getbdyn x "Расстояние"))))fbslist))
  (setq pl (vl-sort (compress-list pl) '(lambda (a b) (< (car a) (car b)))))
  ;;;===========================================================================================
  (acet-error-restore)
  (vla-endundomark #actdoc)
  (mapcar '(lambda (x) (list (strcat "FBS-"(rtos (1+ (/ (car x) 5))) "-5") (cadr x))) pl)
  );defun



;;;*****************************************************************************
;;;*****************************************************************************
;;;   Подсчет проводов в схеме
;;;*****************************************************************************
;;;*****************************************************************************
(defun provoda ( / prlist pl)
  (if (null #actdoc) (setq #actdoc (vla-get-activedocument (vlax-get-acad-object))))
  (vla-startundomark #actdoc)
  ;(acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  ;;;===========================================================================================
  (setq prlist (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) '("wiring_провод" "wiring_wire"))) (ss->lsto* (ssget '((0 . "INSERT"))))))
  (setq pl (mapcar '(lambda (x) (vla-get-TextString (getbatt x "WR_TYPE") )) prlist))
  (setq pl (vl-sort (compress-list pl) '(lambda (a b) (< (car a) (car b)))))
  ;;;===========================================================================================
  ;(acet-error-restore)
  (vla-endundomark #actdoc)
  ;(mapcar '(lambda (x) (list (1+ (/ (car x) 5)) (cadr x))) pl)
  (princ "\n ---- В штуках ----")
  pl
  );defun
;;;*****************************************************************************
;;;*****************************************************************************
;;;*****************************************************************************








;;;;;;   нумерация клеммников - фильтр по клеммам

(defun c:selclams ( / ss clambase)
(setq ss (ssget '((0 . "INSERT"))))
(setq clambase
    (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x)
       '(
	 "wiring_STS-2.5"
	 "wiring_STS-2.5-PE"
	 "wiring_STS-2.5-MT"
	 "wiring_STS-2.5-TG"
	 "wiring_ST-4-HESI"
	 "wiring_ST-4-HEDI"
	 
	 "монтаж_STS-2.5"
	 "монтаж_ST4-HEDI"
	 "монтаж_ST4-HESI"
	 )
   ))
  (ss->lsto* ss)
  ))


(sssetfirst nil (lst-to-ss clambase))
  )
