




(setq str "UA625")


(str->code str 2 3)
;(setq a 2 b 3)
(defun str->code (str a b
		  /
		  pref
		  num
		  )
  (if (= (strlen str) (+ a b))
    (progn
      (setq pref (strcut str 0 (- b))
	    num (atoi (strcut str a 0)))
      )
    (exit)
    )   
  (list pref num)
  );defun



(inc (vlax-ename->vla-object (car (entsel))) 1)
(defun inc (obj dn
	    /
	    pr
	    n
	    str
	    )
  (setq str (vla-get-textstring obj))
  (setq pr (str->code str 2 3)
	n (itoa (+ dn (cadr pr)))
	pr (car pr)
	)
  (vla-put-textstring obj (strcat pr n))
  
  );defun


(defun pref-txt ( prf / obj n)
  (setq ;prf (getstring prf "\nEnter the prifix... ")
	n 1)
  (while (setq obj (nentsel))
    (setq obj (vlax-ename->vla-object (car obj)))
    (vla-put-textstring obj (strcat prf (itoa n)))
    (setq n (1+ n))
    )
  )