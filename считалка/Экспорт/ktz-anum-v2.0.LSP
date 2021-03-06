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
	   :edit_box{label=\"���������� ����� ��������� �����\"; key=\"nattifblock\"; edit_width=6; value=1; children_alignment=centered; children_fixed_width=true;}
	   :edit_box{label=\"������ ����� ��������� (001)\"; key=\"startnum\"; edit_width=6; value=1;}
	   :edit_box{label=\"����������\"; key=\"increment\"; edit_width=6; value=1;}
	   :edit_box{label=\"�������\"; key=\"prefix\"; edit_width=6;}
	   :edit_box{label=\"�������\"; key=\"suffix\"; edit_width=6;}
	   :spacer{height=1;}"
	   
;;;	   :row {
;;;	      :radio_column{label=\"����������\"; key=\"a\"; children_alignment=centered; children_fixed_width=true;
;;;	      	:radio_button{label=\"XY\"; key=\"a1\"; value=\"1\";}
;;;	      	:radio_button{label=\"YX\"; key=\"a2\"; value=\"0\";}
;;;	      	}
;;;	      :spacer{width=1;}	 
;;;	      :radio_column{label=\"1-�� ��������\"; key=\"b\";
;;;	         :radio_button{label=\"�� �����������\"; key=\"b1\"; value=\"1\";}
;;;	         :radio_button{label=\"�� ��������\"; key=\"b2\"; value=\"0\";}
;;;	      	 }
;;;	      :spacer{width=1;}   
;;;	      :radio_column{label=\"2-�� ��������\"; key=\"c\";
;;;	         :radio_button{label=\"�� �����������\"; key=\"c1\"; value=\"0\";}
;;;	         :radio_button{label=\"�� ��������\"; key=\"c2\"; value=\"1\";}
;;;	         }
;;;	      }
	     
	      "
	      :paragraph{
	      	:text_part{label=\"��� ��������� �� ���� �����������, ���� �\";}
	      	:text_part{label=\"������� ��������� ������ ���� ������ �������\";}
	      	}
	      	ok_cancel;
	      	}
	   ")
      (write-line item hand)
    );foreach
    (close hand)
    );progn
  );if

(setq anum20-parameterlist (list "nattifblock" "startnum" "increment" "prefix" "suffix"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq anum20-defparamsfile (strcat (getenv "temp") "\\anum20-defparams.tmp"))
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



(defun c:anum (/ paramilst ss)
  (vla-startundomark actdoc)
  (acet-error-init (list (list	"cmdecho" 0 "expert" nil)T)) ;acet-error-init
  (if (or (not (setq ss (ssget "_I")))
	  (null (setq ss (ssget))))
    (exit))
  (setq paramlist (anum20-dialog))
  (if paramlist (ktz-numerator paramlist))
  (acet-error-restore)
  (vla-endundomark actdoc)
  ) ;defun 



(defun ktz-numerator (lst    /	    n_att  startnum	  increment	 n	lit
		      suf    str    prefix sort	  ss	 i	en-lst
		      entg   ent    cmd1   cmd2	  cmd+-1 cmd+-2	txtsz
;;; ���������� ������� ������
		      tsz
;;; ������ �������� ������
		      pXY    doc
		      )

  (setq
    i	  0
    n_att (atoi (car lst))
    lst	  (cdr lst)
    startnum	  (atoi (car lst))
    lst	  (cdr lst)
    increment	  (car lst)
    lst	  (cdr lst)
    n	  startnum
    lit	  (car lst)
    lst	  (cdr lst)
    suf	  (car lst)
    sort  (cadr lst)
    ) ;_ ����� setq


  (if (= (strlen startnum)
	 (strlen (itoa n))
	 ) ;_ ����� =
    (setq frefix nil
	  str lit
	  ) ;_ ����� setq
    (setq prefix T)
    ) ;if
  (setq txtsz 0.1)

  (if (= 1 (car sort))
    (progn (setq cmd1 '(car)) (setq cmd2 '(cadr)))
    (progn (setq cmd1 '(cadr)) (setq cmd2 '(car)))
    ) ;if

  (if (= 1 (caddr sort))
    (progn
      (setq cmd+-2 '(<))
      (if (= 1 (cadr sort))
	(setq cmd+-1 '(>))
	(setq cmd+-1 '(<))
	) ;_ ����� if
      ) ;progn
    (progn
      (setq cmd+-2 '(>))
      (if (= 1 (cadr sort))
	(setq cmd+-1 '(<))
	(setq cmd+-1 '(>))
	) ;_ ����� if
      ) ;progn
    ) ;if



  (repeat (sslength ss)
    (if	(and
	  (not (equal
		 '(0 0 0)
		 (cdr (assoc 11 (entget (ssname ss i))))
		 ) ;_ ����� equal
	       ) ;_ ����� not
	  (equal '(0 . "*TEXT") (assoc 0 (entget (ssname ss i))))
	  ) ;and
      (setq pXY 11)
      (setq pXY 10)
      ) ;_ ����� if
    (setq en-lst
	   (append
	     en-lst
	     (list
	       (list (setq ent (ssname ss i))
		     (list (car (setq ent (cdr (assoc pXY (entget ent)))))
			   (cadr ent)
			   ) ;_ ����� list
		     ) ;_ ����� list
	       ) ;_ ����� list
	     ) ;append
	  ) ;setq

    (setq tsz (cdr (assoc 40 (entget (ssname ss i)))))
    (if	(> tsz txtsz)
      (setq txtsz tsz)
      ) ;_ ����� if

    (setq i (1+ i))
    ) ;repeat   expt

  (setq i 0)


  (setq	en-lst
	 (vl-sort en-lst
		  '(lambda (a b)
		     (eval (append cmd+-1
				   '((-
				      (eval (append cmd1 '((cadr a))))
				      (eval (append cmd1 '((cadr b))))
				      )
				     txtsz
				     )
				   ) ;_ ����� append
			   ) ;eval
		     ) ;_ ����� lambda
		  ) ;_ ����� vl-sort
	) ;_ ����� setq


  (setq	en-lst
	 (vl-sort en-lst
		  '(lambda (a b)
		     (eval (append cmd+-2
				   '((-
				      (eval (append cmd2 '((cadr a))))
				      (eval (append cmd2 '((cadr b))))
				      )
				     txtsz
				     )
				   ) ;_ ����� append
			   ) ;eval
		     ) ;_ ����� lambda
		  ) ;_ ����� vl-sort
	) ;_ ����� setq


  (foreach ent en-lst
    (setq ent (car ent))
    (if	(= "INSERT"
	   (cdr (assoc 0 (entget ent)))
	   ) ;_ ����� =
      (repeat n_att (setq ent (entnext ent)))
      ) ;if
    (setq entg (entget ent))


;;;*****************************************************************************************
    (if	prefix
      (progn
	(setq str "")
	(repeat	(- (strlen startnum) (strlen (itoa (+ (* i increment) n))))
	  (setq str (strcat str "0"))) ;repeat
	(setq str    (strcat lit str)
	      prefix nil) ;_ ����� setq
	) ;progn
      ) ;_ ����� if


    (setq entg (subst (cons 1 (strcat str (itoa (+ (* i increment) n)) suf))
		      (assoc 1 entg)
		      entg
		      ) ;_ ����� subst
	  ) ;_ ����� setq


    (entmod entg)
    (entupd (cdr (assoc -1 entg)))
    (if	(< (strlen (itoa (+ (* i increment) n)))
	   (strlen (itoa (+ (* increment (1+ i)) n)))
	   ) ;_ ����� <
      (setq prefix T)
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

