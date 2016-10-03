;;;   13_09_09
;;;   14_01_09   v 2.3
;;;   15_06_22   v 2.4 - AcDbAttributeDefinition - tagstring
(vl-load-com)
;; файл kd-anum-v2.2.lsp
;; Пояснения к программе :
;; Программа позволяет автоматически проставить нумерацию в текстовых элементах или в аттрибутах блоков
;; с указанием способа сортировки (X-Y, Y-X и т.д.)
;; есть возможность вставки "префиксных нулей"


;; Порядковый номер аттрибута - устанавливается при нумерации блоков с аттрибутами
;; номер нужного аттрибюута можно посмотреть в окошке свойств блока, считать сверху-вниз

;; Правила расстановки сортировки
;; Если указываеися сортировка XY - то в этом случае первый параметр сортировки - это ось абсцисс (X),
;; второй параметр - ось ординат (Y), если YX - то наоборот
;; и последующие галочки (по возрастанию/убыванию) следует рассматривать в соответствии
;; с указанным способом сортировки


;; ЗАПУСК программы производится из командной строки автокада путем ввода букв:
;; anum[enter]







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))

;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(defun c:anum ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list	"cmdecho" 0 "expert" nil)T)) ;acet-error-init
  (kd:anum-project.init)
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


(defun kd:anum-project.init ( / ss paramilst anum20-dialog ktz-numerator)
  (if (and (not (setq ss (ssget "_I")))
	  (null (setq ss (ssget '((0 . "*TEXT,INSERT,ATTDEF"))))))
    (exit))

;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
(defun anum20-dialog ( /
		      anum20dlgstart
		      anum20readparamsfromfile
		      anum20dlgokpressed
		      anum20saveparams
		      ss->tbl
		      anum20-dclfile
		      hand
		      anum20list
		      dcl-ID
		      anum20-parameterlist
		      anum20-defparamsfile
		      )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq anum20-parameterlist (list "nattifblock" "startnum" "increment" "prefix" "suffix" "a1" "a2" "b1" "b2" "c1" "c2"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq anum20-defparamsfile (strcat (getenv "temp") "\\anum20-defparams.tmp"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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

(defun ss->tbl ( ss / lsto i nkol dx th tbl line)
  (if (> (sslength ss) 1)
    (progn
      
  (setq lsto (reverse (ssnamex ss)))

  (while (listp (cadar lsto))
    (setq lsto (cdr lsto)))
  
  (setq lsto (mapcar 'cadr lsto))
  (setq th (cdr (assoc 40 (entget (car lsto)))))
  (if (null th) (setq th 1.5));сделал для сортировки блоков в нумераторе
  (setq lsto (vl-sort lsto '(lambda (a b) (< (- (car (cdr (assoc 10 (entget a)))) (car (cdr (assoc 10 (entget b))))) th))))
  (setq lsto (vl-sort lsto '(lambda (a b) (> (- (cadr (cdr (assoc 10 (entget a)))) (cadr (cdr (assoc 10 (entget b))))) th))))
  (setq dx (* 10000 th))
  (setq nkol 0)

  (while (and (> dx th) (nth (setq nkol (1+ nkol)) lsto))
    (setq dx (- (cadr (assoc 10 (entget (nth nkol lsto))))
		(cadr (assoc 10 (entget (nth     0  lsto))))))
    )
  (setq tbl '() i 0 line '())
  (foreach item lsto
    (if (= i (1- nkol))
      (setq i -1
	    line (append line (list (vlax-ename->vla-object item)))
	    tbl (append tbl (list line))
	    line '())
      ;else
      (setq line (append line (list (vlax-ename->vla-object item))))
      )
    (setq i (1+ i))
    );foreach
  tbl
  )
    (list (list (vlax-ename->vla-object (ssname ss 0))))
    );if
  );defun





  
  (setq anum20-dclfile (strcat (getenv "temp") "\\anum20-dclfile.dcl"))
    (setq hand	(open anum20-dclfile "w"))
    (mapcar
      '(lambda (item) (write-line item hand))
	   (list
	     "anum20dlg: dialog"
	     "{label=\"ktz-numerator\";"
	     ":edit_box{
	        label=\"Префикс\";
	        key=\"prefix\";"
	        "edit_width=50;"
	        "allow_accept=true;
	        }"
	     ":edit_box{
	        label=\"Суффикс\";
	        key=\"suffix\";"
	        "edit_width=50;"
	        "allow_accept=true;}"


	     
	     ":row
	     	{
	     	:column{
	     	   label=\"№ аттр.\"; children_alignment=centered;
	     	   :edit_box{
	     	      key=\"nattifblock\";"
	     	      ;edit_width=6;
	     	      ;children_fixed_width=true;
	     	      "allow_accept=true;
	     	      }
	     	}"
	     	":spacer{width=3;}"
	     	":column{
	     	   label=\"n0 (001)\"; children_alignment=centered;
	     	   :edit_box{
	     	      key=\"startnum\";"
	     	      ;edit_width=6;
	     	      
	     	      "allow_accept=true;
	     	      }
	     	}"
	        ":spacer{width=3;}"
	     	":column{
	     	   label=\"приращение\"; children_alignment=centered;
	     	   :edit_box{key=\"increment\";"
	     	      ;edit_width=6;
	     	      "allow_accept=true;
	     	      }
	     	}

	   }"

	     ":spacer{height=1;}"
	     ":row {"
	      ":radio_column{label=\"Сортировка\"; key=\"a\"; children_alignment=centered; children_fixed_width=true;
	      	:radio_button{label=\"XY\"; key=\"a1\"; value=\"1\";}
	      	:radio_button{label=\"YX\"; key=\"a2\"; value=\"0\";}
	      	}"
	      ":spacer{width=1;}"
	      ":radio_column{label=\"1-ый параметр\"; key=\"b\";
	         :radio_button{label=\"По возрастанию\"; key=\"b1\"; value=\"1\";}
	         :radio_button{label=\"По убыванию\"; key=\"b2\"; value=\"0\";}
	      	 }"
	      ":spacer{width=1;}"
	      ":radio_column{label=\"2-ой параметр\"; key=\"c\";
	         :radio_button{label=\"По возрастанию\"; key=\"c1\"; value=\"0\";}
	         :radio_button{label=\"По убыванию\"; key=\"c2\"; value=\"1\";}
	         }
	      }"

	     ":row {
	      :paragraph{
	      	:text_part{label=\"При нумерации по двум координатам, ряды и\";}
	      	:text_part{label=\"колонны элементов должны быть строго ровными\";}
	      		}
	      :image {
	      		key=\"ktz\";
	      		alignment=centered;
	      		width=6;
	      		fixed_width=true;
	      		height=2;
	      		fixed_height=true;
	      		color=7;
	      		}
	      	}
	      	ok_cancel;
	      	}
	   ")
      
      );mapcar
  (close hand)

;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  (if (or (< (setq dcl-ID (load_dialog anum20-dclfile)) 0)
	  (not (new_dialog "anum20dlg" dcl-ID)))
    (exit));if
  (start_image "ktz")
  (mapcar (function (lambda (x) (apply 'vector_image x))) '((3 6 3 22 73) (3 16 12 11 73) (3 16 11 22 73) (3 3 32 3 73) (17 3 17 22 73) (21 11 32 11 73) (32 11 21 22 73) (21 22 32 22 73) (24 15 28 19 73)))
  (end_image)
  (action_tile "accept" "(anum20dlgokpressed)")
  (anum20dlgstart)
  (unload_dialog dcl-ID)
  anum20list
  );defun anum20-dialog


  (defun ktz-numerator (lst ss /
		      n_att
		      startnum
		      increment
		      n
		      nstr
		      prefix
		      suffix
		      codepref
		      str
		      i

		      tbl
		      ssl
		      entg
		      a1 ;a2
		      b1 ;b2
		      c1 ;c2
		      sort
		      )

  (setq
    n_att (atoi (cadr (assoc "nattifblock" lst)))
    startnum (cadr (assoc "startnum" lst))
    n	  (atoi startnum)
    increment (atoi (cadr (assoc "increment" lst)))
    prefix (cadr (assoc "prefix" lst))
    suffix (cadr (assoc "suffix" lst))
    a1 (cadr (assoc "a1" lst))
    b1 (cadr (assoc "b1" lst))
    c1 (cadr (assoc "c1" lst))
    ;a2 (cadr (assoc "a2" lst))
    ;b2 (cadr (assoc "b2" lst))
    ;c2 (cadr (assoc "c2" lst))
    )

  (setq sort (+ (atoi c1) (* (atoi b1) 2) (* (atoi a1) 4)))
  (setq tbl (ss->tbl ss))
  (cond
    ((= 0 sort) (setq tbl (reverse (apply 'mapcar (append '(list) tbl)))))		;-y-x	000
    ((= 1 sort) (setq tbl (apply 'mapcar (append '(list) tbl))))			;-yx	001
    ((= 2 sort) (setq tbl (reverse (apply 'mapcar (append '(list) (reverse tbl))))))	;y-x	010
    ((= 3 sort) (setq tbl (apply 'mapcar (append '(list) (reverse tbl)))))		;yx	011
    
    ((= 4 sort) (setq tbl (mapcar 'reverse tbl)))					;-x-y	100
    ((= 5 sort) (setq tbl (reverse (mapcar 'reverse tbl))))				;-xy	101
    ((= 6 sort) (setq tbl tbl))								;xy	110
    ((= 7 sort) (setq tbl (reverse tbl)))						;x-y	111
    )
  (setq tbl (apply 'append tbl))
  (setq ssl (mapcar 'vlax-vla-object->ename tbl))
  
  (setq codepref (not (= (strlen startnum) (strlen (itoa n)))))


  
  (setq i 0)
  
  (foreach ent ssl
    (if	(= "INSERT"
	   (cdr (assoc 0 (entget ent)))
	   )
      (repeat n_att (setq ent (entnext ent)))
      )

    (setq entg (entget ent))
    ;(setq entg (entget (car (entsel))))


;;;*****************************************************************************************
    (setq str (itoa (+ (* i increment) n)))

    (repeat (- (strlen startnum) (strlen str))
      (setq str (strcat "0" str)))

    (setq str (strcat prefix str suffix))

    (if (= "ATTDEF" (cdr (assoc 0 entg)))
      (setq entg (subst (cons 2 str) (assoc 2 entg) entg))
      (setq entg (subst (cons 1 str) (assoc 1 entg) entg))
      )
    
    (entmod entg)
    (entupd (cdr (assoc -1 entg)))
    (setq i (1+ i))
    ) ;foreach

  (princ)
  ) ;defun


  

  
  (setq paramlist (anum20-dialog))
  (if paramlist (ktz-numerator paramlist ss))

  
  );defun   kd:anum-project.init


;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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




;;; 13_12_18

(defun c:anum* ( / parlist data)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list	"cmdecho" 0 "expert" nil)T))
  (if (null str+) (load (strcat #lisppath "strings\\str+.lsp")))
  (setq parlist '("Префикс" "нач.цифра" "Суффикс" "Приращение"))
  (setq data (kd:dclget parlist))
  (apply 'kd:anum* data)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun

(defun kd:anum* (prefix start suff inc / obj)
  (while (setq obj (car (nentsel (strcat "\n текущий номер : " start))))
    (setq obj (vlax-ename->vla-object obj))
    (vla-put-TextString obj (strcat prefix start suff))
    (repeat (atoi inc) (setq start (str+ start)))
    )
  (princ)
  );defun


