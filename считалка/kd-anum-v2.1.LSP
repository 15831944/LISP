(vl-load-com)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq anum20-dclfile (strcat (getenv "temp") "\\anum20-dclfile.dcl"))
(if (null (findfile anum20-dclfile))
  (progn
    (setq hand	(open anum20-dclfile "w"))
    (foreach item
	   '("
	   anum20dlg: dialog
	   {label=\"ktz-numerator\";
	   :edit_box{label=\"Порядковый номер аттрибута блока\"; key=\"nattifblock\"; edit_width=6; value=1; children_alignment=centered; children_fixed_width=true;}
	   :edit_box{label=\"Первая цифра нумерации (001)\"; key=\"startnum\"; edit_width=6; value=1;}
	   :edit_box{label=\"Приращение\"; key=\"increment\"; edit_width=6; value=1;}
	   :edit_box{label=\"Префикс\"; key=\"prefix\"; edit_width=6;}
	   :edit_box{label=\"Суффикс\"; key=\"suffix\"; edit_width=6;}
	   :spacer{height=1;}"
	   
	   ":row {
	      :radio_column{label=\"Сортировка\"; key=\"a\"; children_alignment=centered; children_fixed_width=true;
	      	:radio_button{label=\"XY\"; key=\"a1\"; value=\"1\";}
	      	:radio_button{label=\"YX\"; key=\"a2\"; value=\"0\";}
	      	}
	      :spacer{width=1;}	 
	      :radio_column{label=\"1-ый параметр\"; key=\"b\";
	         :radio_button{label=\"По возрастанию\"; key=\"b1\"; value=\"1\";}
	         :radio_button{label=\"По убыванию\"; key=\"b2\"; value=\"0\";}
	      	 }
	      :spacer{width=1;}   
	      :radio_column{label=\"2-ой параметр\"; key=\"c\";
	         :radio_button{label=\"По возрастанию\"; key=\"c1\"; value=\"0\";}
	         :radio_button{label=\"По убыванию\"; key=\"c2\"; value=\"1\";}
	         }
	      }"
	     
	      "
	      :paragraph{
	      	:text_part{label=\"При нумерации по двум координатам, ряды и\";}
	      	:text_part{label=\"колонны элементов должны быть строго ровными\";}
	      	}
	      	ok_cancel;
	      	}
	   ")
      (write-line item hand)
    );foreach
    (close hand)
    );progn
  );if

(setq anum20-parameterlist (list "nattifblock" "startnum" "increment" "prefix" "suffix" "a1" "a2" "b1" "b2" "c1" "c2"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq anum20-defparamsfile (strcat (getenv "temp") "\\anum20-defparams.tmp"))
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(defun c:anum (/ paramilst ss)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list	"cmdecho" 0 "expert" nil)T)) ;acet-error-init
  (if (and (not (setq ss (ssget "_I")))
	  (null (setq ss (ssget '((0 . "*TEXT"))))))
    (exit))
  (setq paramlist (anum20-dialog))
  (if paramlist (ktz-numerator paramlist ss))
  (acet-error-restore)
  (vla-endundomark #actdoc)
  ) ;defun 

;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




;lst = (("nattifblock" "2") ("startnum" "005") ("increment" "7") ("prefix" "pr") ("suffix" "su") ("a1" "0") ("a2" "1") ("b1" "1") ("b2" "0") ("c1" "0") ("c2" "1")) 

(defun ktz-numerator (lst ss /
		      n_att
		      startnum
		      increment
		      n
		      prefix
		      suffix
		      codepref
		      str
		      i

		      ssl
		      entg
		      a1 a2
		      b1 b2
		      c1 c2
		      cmd1
		      cmd2
		      cmd+-1
		      cmd+-2
		      )

  (setq
    n_att (atoi (cadr (assoc "nattifblock" lst)))
    startnum (cadr (assoc "startnum" lst))
    n	  (atoi startnum)
    increment (atoi (cadr (assoc "increment" lst)))
    prefix (cadr (assoc "prefix" lst))
    suffix (cadr (assoc "suffix" lst))
    a1 (cadr (assoc "a1" lst))
    ;a2 (cadr (assoc "a2" lst))
    b1 (cadr (assoc "b1" lst))
    ;b2 (cadr (assoc "b2" lst))
    c1 (cadr (assoc "c1" lst))
    ;c2 (cadr (assoc "c2" lst))
    ) ;_ конец setq

  (setq ss (ss->list* ss))
  (setq txtsz (cdr (assoc 40 (entget (car ss)))))



  (setq cmd1   (if (= "1" a1) '(car) '(cadr)))
  (setq cmd2   (if (= "1" a1) '(cadr) '(car)))
  (setq cmd+-1 (if (= "1" c1) '(>) '(<)))
  (setq cmd+-2 (if (= "1" b1) '(<) '(>)))


  (setq ssl (mapcar '(lambda (x / pt)
		       (list
			 (if (equal '(0 0 0) (setq pt (cdr (assoc 11 (entget x)))))
			   (cdr (assoc 10 (entget x)))
			   pt
			   )
			 x
			 )
		       ) ss))


  (setq	ssl
	 (vl-sort ssl
		  '(lambda (a b)
		     (eval (append cmd+-1
				   '((-
				      (eval (append cmd1 '((car a))))
				      (eval (append cmd1 '((car b))))
				      )
				     txtsz
				     )
				   ) ;_ конец append
			   ) ;eval
		     ) ;_ конец lambda
		  ) ;_ конец vl-sort
	) ;_ конец setq



  (setq	ssl
	 (vl-sort ssl
		  '(lambda (a b)
		     (eval (append cmd+-2
				   '((-
				      (eval (append cmd2 '((car a))))
				      (eval (append cmd2 '((car b))))
				      )
				     txtsz
				     )
				   ) ;_ конец append
			   ) ;eval
		     ) ;_ конец lambda
		  ) ;_ конец vl-sort
	) ;_ конец setq

  (setq ssl (mapcar 'cadr ssl))
  (setq codepref (not (= (strlen startnum) (strlen (itoa n)))))
  

  (setq i 0)
  (foreach ent ssl
    (if	(= "INSERT"
	   (cdr (assoc 0 (entget ent)))
	   ) ;_ конец =
      (repeat n_att (setq ent (entnext ent)))
      ) ;if
    (setq entg (entget ent))


;;;*****************************************************************************************
    (if	codepref
      (progn
	(setq str "")
	(repeat	(- (strlen startnum) (strlen (itoa (+ (* i increment) n))))
	  (setq str (strcat str "0"))
	  ) ;repeat
	(setq str (strcat prefix str)
	      codepref nil)
	) ;progn
      ) ;_ конец if


    (setq entg (subst (cons 1 (strcat str (itoa (+ (* i increment) n)) suffix))
		      (assoc 1 entg)
		      entg
		      ) ;_ конец subst
	  ) ;_ конец setq


    (entmod entg)
    (entupd (cdr (assoc -1 entg)))
    (if	(< (strlen (itoa (+ (* i increment) n)))
	   (strlen (itoa (+ (* increment (1+ i)) n)))
	   )
      (setq codepref T)
      ) ;if
    (setq i (1+ i))
    ) ;foreach

  (princ)
  ) ;defun






;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
(defun anum20-dialog ( / anum20list dcl-ID)
  (if (or (< (setq dcl-ID (load_dialog anum20-dclfile)) 0)
	  (not (new_dialog "anum20dlg" dcl-ID)))
    (exit));if
  (action_tile "accept" "(anum20dlgokpressed)")
  (anum20dlgstart)
  (unload_dialog dcl-ID)
  anum20list
  );defun

(defun anum20dlgstart ( / lst)
  (if (setq lst (anum20readparamsfromfile))
    (mapcar '(lambda (x) (set_tile x (cadr (assoc x lst)))) anum20-parameterlist));if
  (start_dialog)
  );defun

(defun anum20readparamsfromfile ( / fhand line)
  (if (findfile anum20-defparamsfile)
    (progn
      (setq fhand (open anum20-defparamsfile "r"))
      (setq line (read-line fhand))
      (close fhand)
      (read line)
      ))
  );defun

(defun anum20dlgokpressed ()
  (setq anum20list '())
  (mapcar '(lambda(x) (setq anum20list (append anum20list (list (list x (get_tile x))))))
	  anum20-parameterlist)
  (anum20saveparams anum20list)
  (done_dialog)
  );defun

(defun anum20saveparams (lst / fhand)
  (setq fhand (open anum20-defparamsfile "w"))
  (prin1 lst fhand)
  (close fhand)
  );defun
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

