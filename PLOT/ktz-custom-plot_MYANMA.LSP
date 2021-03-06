;;; �������� 10_05_27
;;; ktz-plot
;;; ����� ��� ������ �� ������ ����� ������ � ����� ������
;;; �������� ��� ��������� pdf-����� ������������ ��� ������
;;; export-to-dwg
;;; ��������� ����� � ����� ������ � ������ ����� � ������� ����� (��� ������)
;;; ������������ ��� ���������� ���� �� �4 ������
;;; -kakt00z-�  �
(vl-load-com)
(load "d:/LISP WORKING/common functions/format-identification-gost.lsp")



  
;(wcmatch (cdr (assoc 1 (entget (car (entsel))))) "*A#@#,*A#,*�#@#,*�#,*A#`*#,*�#`*#")
;(format-detect (get-ftxte<-formatpts (list (getpoint)(getpoint))))




;(vl-string-translate "x�*" "sss" (cdr (assoc 1 (entget (car (entsel))))))






(defun ktz-printout (lst
		     /
		     printer
		     format
		     pt1
		     pt2
		     fit
		     plotstyle
		     line-weight
		     Plot-not-prew
		     orient
		     )
;;;  (initget "kaktooz-pdf Pashkina _1 2")
;;;  (setq flag (getkword "\n �������� �������� �� ����� ��� ������� �� ������?  : [kaktooz-pdf.pc3/\\\\Pashkina\\HP LaserJet 1020] <kaktooz-pdf.pc3>"))


  (setq
    pt1 		(caadr lst)
    pt2			(cadadr lst)
    fit			"_fit"
    plotstyle		"monochrome.ctb"
    line-weight		"_Y"
    Plot-not-prew 	"_Y"
    
    orient		;"_L"				;Landscape / Portrait   "_L" "_P"
     (if (> (abs (- (car pt1) (car pt2)))
	    (abs (- (cadr pt1) (cadr pt2))))
       "_L"
       "_P"
       );if orient
    ;printer		"kaktooz-pdf.pc3"
    ;printer		"\\\\Pashkina\\HP LaserJet 1020"
    printer
     (if (= orient "_L")
       "pdf-w.pc3"
       "pdf-v.pc3"
       );if printer
    
    format
     (if (= orient "_L")
       (strcat "w" (caddr lst))
       (strcat "v" (caddr lst))
       );if format
    ;format		"A4"
    
    )

   (command "_.plot" 		;���� ������� 
             "_Yes" 		;����� ��������� 
             "model" 		; ��� ����� ��� [?] <������>: 
             printer 		;��� ���������� ������ ��� [?] <HP2200-PCL6.pc3>: 
             format 		;������ ����� ������ ��� [?] <A4>: 
             "Millimeters" 	;������� ��������� �������� ����� [�����/����������] <����>:
             orient 		;���������� ������� [�������/���������] <�������>: 
             "_No" 		;����������� ������? [��/���] <���>:
             "_Window" 		;���������� ������� [�����/�������/������/���/�����] <�����>:
             pt1 		;������ ����� ���� 
             pt2 		;������ ����� ���� 
             fit 		;[�������] <�������>: ("_fit")
             "_center" 		;�������� �� ������ (x,y) ��� [������������] <������������>: 
             "_yes" 		;��������� ����� ������? [��/���] <��>:
             plotstyle 		;��� ������� ������ ������ ��� [?] (. ���� ���) <monochrome.ctb>:
             line-weight 	;��������� ���� �����? [��/���] <��>:
             "As displayed" 	;����� ������ ������������ �� [�������/������/������� �����/�����������] <�������>:
             "_No" 		;������ ������� � ���� [��/���] <�>:
             "_yes" 		;��������� ��������� ���������� ����� [��/���]? 
             Plot-not-prew 	;������� � ������ [��/���] <�>: 
    ) ;_ end of command


  
  );defun




;(ktz-printout (dataprint (car (entsel))))


;;; ����� "Format" ������ int  ����� �����
(defun m-get-lnumber (en /
		   e1
		   vect
		   pt1
		   pt2
		   li
		   )
  
  (setq vect (list (* 181 scale) (* 15 scale)))
  (setq pt1 (vec-sum (cdr (assoc 10 (entget en))) vect))
  (setq pt2 (vec-dif pt1 (list (* 42 scale) (* 30 scale))))
  ;(get-lnumber (car (entsel)))
  ;(command "_rectang" pt1 pt2)
  (vl-cmdf "_.zoom" "_W" pt1 pt2)
  (setq li (ssget "_C" pt1 pt2 '((0 . "*TEXT")(1 . "����"))))
  (if (= (sslength li) 1)
    (setq li (ssname li 0))
    (progn
      (ktz-show-error
	(cons 10 pt1)
	"��������� ������ �����"
	) ;_ ����� ktz-show-error
      (exit)
    )
    );if
    
  (setq vect (list (* 9 scale) (* 9 scale)))
  (setq pt1 (vec-dif (cdr (assoc 10 (entget li))) (list 0 (* 2 scale))))
  (setq pt2 (vec-sum pt1 (list (* 9 scale) (* -9 scale))))
  ;(command "_rectang" pt1 pt2)
  (setq e1 (ssget "_C" pt1 pt2 '((0 . "*TEXT"))))
  (if (= (sslength e1) 1)
      (setq e1 (ssname e1 0))
      (progn
	(ktz-show-error
	  (cons 10 pt1)
	"��������� ������ �����"
	) ;_ ����� ktz-show-error
      (exit)
    )
    );if

  e1
  );defun




;;;;;; ***************************************************************************
;;;;;; main function1    ktz-plot
;;;;;; dataprint - 
;;;;;; ***************************************************************************





;;; ������ ������ (e1 e2 ... en), ��� �� - ����� � ���������� "*Format*"
(defun m-get-txte-format (
                        /
                        ss
                        lst
                        en
                        i
                        )
    (setq ss (ssget "_X" '((1 . "*Format*")))
          lst '())
    (repeat (sslength ss)
        (setq lst (append lst (list (ssname ss i))))
        (setq i (1+ i))
        )
       );defun
;;;************************************************************************************************************



;;;(vlax-safearray->list(vlax-variant-value 
;;;(vlax-get-property (vlax-ename->vla-object (car (entsel))) "StartPoint")))
;;;
;;;;;; ��������� ����� ��� �������������
;;;;;; ������������ ���� frames
;;;
;;;(setq frss (ssget "_X" '((8 . "frames"))))
;;;(sssetfirst nil frss)
;;;
;;;(setq i 0)
;;;(repeat (sslength frss)
;;;    (setq tmpo (vlax-ename->vla-object (ssname frss i)))
;;;    (setq st (vlax-safearray->list(vlax-variant-value (vlax-get-property tmpo "StartPoint"))))
;;;    (setq en (vlax-safearray->list(vlax-variant-value (vlax-get-property tmpo "EndPoint"))))
;;;    (setq midp (mapcar '(lambda (x) (/ x 2)) (mapcar '+ st en)))
;;;    (vla-Mirror tmpo (vlax-3d-point midp) (vlax-3d-point (mapcar '+ midp '(0 -100 0))))
;;;    (setq i (1+ i))
;;;    )




(defun c:m-plot (
                 /
		   txtents
		   flist
		   scale
		   )
  (setq txtents (m-get-txte-format)
	flist '())
  (setq scale (/ (cdr (assoc 40 (entget (car txtents)))) 2.5))
  (foreach en txtents
    (setq flist (append flist (list (m-dataprint en))))
    );foreach
;;; ��������� ������ �� ������ �����

  (setq	flist	(vl-sort flist
			 '(lambda (a b)
			    (< (car a)
			       (car b)
			       ))))  
  (foreach en flist
    (ktz-printout en)
    ;(command pause)				;;;;; ������������ ���� ����� ������ � ��������� ����
    						;;;;; ����� ���������� ������ ����� ��� ������������
    );foreach
  );defun


;;;********************  DATAPRINT  *******************************************
;;; ����� "Format A3"
;;; ���� ������ (pt1 pt2 "��� �������")
(defun m-dataprint (ent
		  /
		  pt-list
		  foname
		  nlist
		  )
  (setq pt-list (m-get-formatpts<-rightformatline
                    (m-get-rightformatline<-koluch
                        ent)))
  (setq foname (m-format-detect ent))
  (setq nlist (m-get-lnumber ent))
  (cons (atof nlist) (list pt-list foname)) 

  ;(command "_rectang" p1 p2 "")
  ;(princ fo)
  );defun

;;;****************************************************************************
;;; ��� ename ����� ������ �� ����� Format �� 20 ��
;;; ent - ����� ���. ��.
(defun m-get-rightformatline<-koluch (ent
			     /
			     pt1
			     pt2
			     ss
			     en
			     )
  (setq	pt1	(list
			  (+ (car (cdr (assoc 10 (entget ent)))) (* 15 scale)) ;;;; ���������� �� ����� ������
			    (cadr (cdr (assoc 10 (entget ent)))) 
			)
		pt2	(list
			  (+ (car pt1) (* 5 scale))
			  (cadr pt1)
			  )
		)
  (vl-cmdf "_zoom" "_W" pt1 pt2)
  
      (setq ss (ssget "_C" pt1 pt2))
  
      (if (= 1 (sslength ss))
	(setq en (ssname ss 0))
	(progn
	  (ktz-show-error
	    (cons 10 pt1)
	    "\n����� ����� ������� ����������� ��� �����������\n����� ������� ����� ����� ���� ���������� 4-�� ���������"
	    ) ;_ ����� ktz-show-error
	  (exit)
	  );progn
	);if
     en
  ;(command "_Line" pt1 pt2 "")
);defun




;;;****************************************************************************
;;; ��� 2 ����� - ���� ��������
;;; ��������� ent - ������ ������� ����� �������

(defun m-get-formatpts<-rightformatline (ent
		   /
		   frame-fltr
		   ss
		   i
		   lstX
		   lstY
		   minX
		   minY
		   maxX
		   maxY
		   pt1
		   pt2
		   )

(setq frame-fltr
       (list '(-4 . "<AND")
	     '(0 . "LINE")
	     '(-4 . "<OR")
	     (cons 10 (cdr (assoc 10 (entget ent))))
	     (cons 10 (cdr (assoc 11 (entget ent))))
	     (cons 11 (cdr (assoc 10 (entget ent))))
	     (cons 11 (cdr (assoc 11 (entget ent))))
	     '(-4 . "OR>")
	     '(-4 . "AND>")
       )
);setq
  (setq ss (ssget "_X" frame-fltr))
  (setq ss (ssdel ent ss))

  (if (/= 2 (sslength ss))
    ;then
    (progn
      (ktz-show-error
	(assoc 10 (entget ent))
	"��������� ����� �������"
	)
      (exit)
      )
    ;esle
    (progn
      (setq i 0)
      (repeat (sslength ss)
	(setq lstX (append lstX (list (cadr (assoc 10 (entget (ssname ss i))))
				      (cadr (assoc 11 (entget (ssname ss i))))
				      ));list
	      lstY (append lstY (list (caddr (assoc 10 (entget (ssname ss i))))
				      (caddr (assoc 11 (entget (ssname ss i))))
				      ));list
	      );setq
	
	(setq i (1+ i))
	);repeat
      
      (setq minX (eval (append (list 'min) lstX))
	    maxX (eval (append (list 'max) lstX))
	    minY (eval (append (list 'min) lstY))
	    maxY (eval (append (list 'max) lstY))
	    pt1 (list minX minY)
	    pt2 (list maxX maxY)
	    );setq
      
      (list pt1 pt2)

      ;(command "_rectang" pt1 pt2)

      );progn
    );if
  );defun



;;;****************************************************************************
;;; ��������� ������ ���������� ���������� �� ������� �������
;;; ���������� ������ ������� ��� ������ �� �������


(defun m-format-detect (e
		      /
                        fstr
		      str
		      printer-format
		      printer-separator
		      n1
		      n2
		      )

;;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;; ������ ������� �� ���� ��� ������ �������			;
  (setq printer-format "-A")					; ��������
  (setq printer-separator "x")					; ��������
;;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    (setq e (car (entsel)))
    (setq fstr (cdr (assoc 1 (entget e))))
   
  (if (wcmatch fstr "#@#,#,#`*#")
    ;then
    (progn
      (cond
	((= (strlen fstr) 1)
	 (setq str (strcat printer-format fstr))
	 )
	((= (strlen fstr) 3)
	 (setq str
		(vl-string-translate
		  "x�*"
		  (strcat printer-separator printer-separator printer-separator)
		  fstr))
	 (setq str (strcat printer-format str))
	 
	 )
	)
      T
      );progn
    ;else
    (alert "������ ��� ����������� �������, \n�������� �������� ������")
    )
  str
  );defun







