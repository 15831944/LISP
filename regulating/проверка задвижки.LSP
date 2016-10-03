
;;;  состояние потецнциалво -   "L" / "N"
;;;  состояние реле         -   "pas" / "act"  (act - при наличии питания)
;;;  состояние мотора         -   "op" / "mid" / "cl"
;;;  состояние ключа         -   "doop" / "docl" / "dorelease"







(setq pots '("A1" "A10" "A11" "A12" "A14" "A15" "A19" "A20" "A22" "A23"))
(mapcar '(lambda (x) (eval (list 'setq (read x) "N"))) pots)

(mapcar '(lambda (x) (setpot x "N")) pots)


(setq rels '("KMC1" "KMT1" "KQ1"))
(mapcar '(lambda (x) (eval (list 'setq (read x) "pas"))) rels)

(mapcar '(lambda (x) (setstate x "pas")) rels)


(setq grA1 (ss->lsto* (ssget)))
(setq grA10 (ss->lsto* (ssget)))
(setq grA11 (ss->lsto* (ssget)))
(setq grA12 (ss->lsto* (ssget)))
(setq grA14 (ss->lsto* (ssget)))
(setq grA15 (ss->lsto* (ssget)))
(setq grA16 (ss->lsto* (ssget)))
(setq grA19 (ss->lsto* (ssget)))
(setq grA20 (ss->lsto* (ssget)))
(setq grA22 (ss->lsto* (ssget)))
(setq grA23 (ss->lsto* (ssget)))



(setq grKMC1 (ss->lsto* (ssget)))
(setq grKMT1 (ss->lsto* (ssget)))
(setq grKQ1 (ss->lsto* (ssget)))

(setq grM (ss->lsto* (ssget)))

(setq grSA (ss->lsto* (ssget)))

;(getval "A10")
;(setpot "A10" "L")

;(setstateM "M" "cl")
;(setstateM "M" "op")
;(setstateM "M" "mid")

;(setpot "A11" "L")
;(setpot "A11" "N")

;(setstate "KMC1" "act")
;(setstate "KMC1" "pas")


(setq listofitems '(
  "A1" "A10" "A11" "A12" "A14" "A15" "A19" "A20" "A22" "A23" "A16"
  "M" "SA" "KQ1" "KMC1" "KMT1"
		    ))








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun refresh ( / oldstate curstate)
  (setq curstate (mapcar 'getval listofitems))
  (while (null (equal oldstate curstate))
    (setq oldstate curstate)
    (mapcar 'recount listofitems)
    (setq curstate (mapcar 'getval listofitems))
    )
  (princ)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(defun recountl (lst) (mapcar 'recount lst))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq str "A11")
(defun recount (str)
  (cond
    
    ((= "A11" str)
     (cond
       ((member (getval "M") '("cl" "mid")) (setpot str (getval "A10")))
       ((member (getval "M") '("op")) (setpot str "N"))
       )
     )

    ((= "A19" str)
     (cond
       ((member (getval "M") '("op" "mid")) (setpot str (getval "A10")))
       ((member (getval "M") '("cl")) (setpot str "N"))
       )
     )

    
    ((= "A12" str)
     (setpot str
       (if (and (= "L" (getval "A11"))
	     (or (= "doop" (getval "SA"))
		 (= "act" (getval "KMC1"))))
	 "L" "N")
	     )
     )
;(setq str "A20")
    ((= "A20" str)
     (setpot str
       (if (and (= "L" (getval "A19"))
	     (or (= "docl" (getval "SA"))
		 (= "act" (getval "KMT1"))))
	 "L" "N")
	     )
     )



    (
     (= "A16" str)
     (if
       (or
	 (and (= "L" (getval "A12")) (= "docl" (getval "SA")))
	 (and (= "L" (getval "A20")) (= "doop" (getval "SA")))
	 )
       (setpot str "L") (setpot str "N")
       )
     )
    

    ((= "A14" str) (setpot str (if (and (= "L" (getval "A12")) (= "pas" (getval "KQ1"))) "L" "N")))
    ((= "A22" str) (setpot str (if (and (= "L" (getval "A20")) (= "pas" (getval "KQ1"))) "L" "N")))

    ((= "A15" str) (setpot str (if (and (= "L" (getval "A14")) (= "pas" (getval "KMT1"))) "L" "N")))
    ((= "A23" str) (setpot str (if (and (= "L" (getval "A22")) (= "pas" (getval "KMC1"))) "L" "N")))

    ((= "KMC1" str) (if (= "L" (getval "A15")) (setstate str "act") (setstate str "pas")))
    ((= "KMT1" str) (if (= "L" (getval "A23")) (setstate str "act") (setstate str "pas")))

    ((= "KQ1" str) (if (= "L" (getval "A16")) (setstate str "act") (setstate str "pas")))

    );cond
  (princ)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getval (str) (eval (read str)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;"doop" / "docl" / "dorelease"
(defun setstateSA (str state)
  (eval (list 'setq (read str) state))
  (gredrawSA str)
  ;(recountl '("A12" "A20" "A16" "A14" "A22" "A15" "A23" "KMC1" "KMT1"))
  (refresh)
  (princ)
  )


(defun setqstateSA (str state)
  (eval (list 'setq (read str) state))
  (gredrawSA str)
  (mapcar 'recount '("A12" "A20" "A16" "KQ1" "A14" "A22" "A15" "A23" "KMC1" "KMT1"))
  ;(mapcar 'recount '("A12" "A20" "A16" "KQ1" "A14" "A22" "A15" "A23" "KMC1" "KMT1"))
  (eval (list 'setq (read str) "dorelease"))
  (gredrawSA str)
  (refresh)
  (princ)
  )



;(setq strSA "SA")
(defun gredrawSA (strSA / state)
  (setq state (getval strSA))
  (cond
    ((= state "doop")
     (mapcar
       '(lambda (x)
	  (cond
	    ((= "1" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 10))
	    ((= "2" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 71))
	    ((= "5" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 10))
	    ((= "6" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 71))
	    )
	  )
       (eval (read (strcat "gr" strSA))))
     )
    ((= state "docl") (mapcar
       '(lambda (x)
	  (cond
	    ((= "1" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 71))
	    ((= "2" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 10))
	    ((= "5" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 71))
	    ((= "6" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 10))
	    )
	  )
       (eval (read (strcat "gr" strSA))))
     )
    ((= state "dorelease") (mapcar
       '(lambda (x)
	  (cond
	    ((= "1" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 71))
	    ((= "2" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 71))
	    ((= "5" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 71))
	    ((= "6" (vla-get-TextString (getbatt x "PIN1"))) (vlax-put-property x "color" 71))
	    )
	  )
       (eval (read (strcat "gr" strSA))))
     )
    )
  );defun




;(setstateM "M" "cl")
(defun setstateM (str state)
  (eval (list 'setq (read str) state))
  (gredrawM str)
  ;(recountl '("A11" "A19" "A12" "A20" "A16" "A14" "A22" "A15" "A23"))
  (refresh)
  (princ)
  )

;(setq strM "M")
(defun gredrawM (strM / state)
  (setq state (eval (read strM)))
  (mapcar
    '(lambda (x)
       (cond
	 ((= state "op")
	  (cond
	    ((= "1" (vla-get-TextString (getbatt x "PIN1")))
	     (vla-put-Value (getbdyn x "Видимость") "НО")
	     )
	    ((= "13" (vla-get-TextString (getbatt x "PIN1")))
	     (vla-put-Value (getbdyn x "Видимость") "НЗ")
	     )
	    )
	  ;(setpot "A11" "N") (setpot "A19" "L")
	  )
	 
	 ((= state "cl")
	  (cond
	    ((= "1" (vla-get-TextString (getbatt x "PIN1")))
	     (vla-put-Value (getbdyn x "Видимость") "НЗ")
	     )
	    ((= "13" (vla-get-TextString (getbatt x "PIN1")))
	     (vla-put-Value (getbdyn x "Видимость") "НО")
	     )
	    )
	  ;(setpot "A11" "L") (setpot "A19" "N"))
	  )
	 
	 ((= state "mid")
	  (cond
	    ((= "1" (vla-get-TextString (getbatt x "PIN1")))
	     (vla-put-Value (getbdyn x "Видимость") "НЗ")
	     )
	    ((= "13" (vla-get-TextString (getbatt x "PIN1")))
	     (vla-put-Value (getbdyn x "Видимость") "НЗ")
	     )
	    )
	  ;(setpot "A11" "L") (setpot "A19" "L"))
	  )
	 );cond
       );lambda
    (eval (read (strcat "gr" strM)))
    );mapcar
  );defun












;(getval "A19")
;(setpot "A10" "L")
;(setpot "A10" "N")
(defun setpot (str pot)
  (eval (list 'setq (read str) pot))
  (gredrawpot str)
  (princ)
  )

(defun gredrawpot (strpt / pot)
  (setq pot (eval (read strpt)) )
  (cond
    ((= "L" pot) (mapcar '(lambda (x) (vlax-put-property x "color" 10)) (eval (read (strcat "gr" strpt)))))
    ((= "N" pot) (mapcar '(lambda (x) (vlax-put-property x "color" 7)) (eval (read (strcat "gr" strpt)))))
    )
  );defun


;(setstate "KMC1" "act")
;(setstate "KMC1" "pas")
;(setq strrel "KMC1") (setq state "pas")
(defun setstate (str state)
  (eval (list 'setq (read str) state))
  (gredrawrel str)
  ;(cond
  ;  ((= str "KMC1")(recountl '("A12" "A14" "A15" "A23")))
  ;  ((= str "KMT1")(recountl '("A20" "A22" "A23" "A15")))
  ;  ((= str "KQ1")(recountl '("KMC1" "KMT1")))
  ;  )
  (princ)
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gredrawrel (strrel / state)
  (setq state (eval (read strrel)))
(mapcar
  '(lambda (x)
     ;(setq x (car (eval (read (strcat "gr" strrel)))))
     (cond
       ((= "31" (vla-get-TextString (getbatt x "PIN1")))
	(cond
	  ((= state "act") (vla-put-Value (getbdyn x "Видимость") "НО") (vlax-put-property x "color" 10))
	  ((= state "pas") (vla-put-Value (getbdyn x "Видимость") "НЗ") (vlax-put-property x "color" 4))
	  )
	) ;NC
       ((= "41" (vla-get-TextString (getbatt x "PIN1")))
	(cond
	  ((= state "act") (vla-put-Value (getbdyn x "Видимость") "НО") (vlax-put-property x "color" 10))
	  ((= state "pas") (vla-put-Value (getbdyn x "Видимость") "НЗ") (vlax-put-property x "color" 4))
	  )
	) ;NC
       ((= "61" (vla-get-TextString (getbatt x "PIN1")))
	(cond
	  ((= state "act") (vla-put-Value (getbdyn x "Видимость") "НО") (vlax-put-property x "color" 10))
	  ((= state "pas") (vla-put-Value (getbdyn x "Видимость") "НЗ") (vlax-put-property x "color" 4))
	  )
	) ;NC
       ((= "53" (vla-get-TextString (getbatt x "PIN1")))
	(cond
	  ((= state "act") (vla-put-Value (getbdyn x "Видимость") "НЗ") (vlax-put-property x "color" 10))
	  ((= state "pas") (vla-put-Value (getbdyn x "Видимость") "НО") (vlax-put-property x "color" 4))
	  )
	) ;NO
       ((= "83" (vla-get-TextString (getbatt x "PIN1")))
	(cond
	  ((= state "act") (vla-put-Value (getbdyn x "Видимость") "НЗ") (vlax-put-property x "color" 10))
	  ((= state "pas") (vla-put-Value (getbdyn x "Видимость") "НО") (vlax-put-property x "color" 4))
	  )
	) ;NO
       (T
	(cond
	  ((= state "act") (vlax-put-property x "color" 10))
	  ((= state "pas") (vlax-put-property x "color" 4))
	  )
	)
       )
     )
  (eval (read (strcat "gr" strrel))))
  );defun


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun run (/ es str)
  (while (setq es (entsel))
    (setq str (vla-get-TextString (vlax-ename->vla-object (car es))))
    (eval (read str))
    )
  )









