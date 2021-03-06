;;; �������� 10_05_27
;;; ktz-plot
;;; ����� ��� ������ �� ������ ����� ������ � ����� ������
;;; �������� ��� ��������� pdf-����� ������������ ��� ������
;;; export-to-dwg
;;; ��������� ����� � ����� ������ � ������ ����� � ������� ����� (��� ������)
;;; ������������ ��� ���������� ���� �� �4 ������
;;; -kakt00z-�  �
(load "d:/LISP WORKING/common functions/format-identification-gost.lsp")
(vl-load-com)


;;;************************************************************************************************************
;;; ����� "���.��"
;;; ���� ������ (pt1 pt2 "��� �������")
;;;************************************************************************************************************
(defun dataprint (ent / pt-list foname nlist)
  (setq pt-list (get-formatpts<-rightformatline (get-rightformatline<-koluch ent)))
  (setq foname (format-detect (get-ftxte<-formatpts pt-list)))
  (setq nlist (get-lnumber ent))
  (cons (atof nlist) (list pt-list foname)) 
  );defun
;;;************************************************************************************************************
;;;************************************************************************************************************


;;;************************************************************************************************************
;;;;;; main function1    ktz-plot
;;;************************************************************************************************************
(defun c:ktz-plot (/
		   koluchs
		   flist
		   scale
		   )
  (setq koluchs (get-kol-uch)
	flist '())
  (setq scale (/ (cdr (assoc 40 (entget (car koluchs)))) 2.5))

  (setq flist (mapcar 'dataprint koluchs))
  
;;; ***************************************************************************
;;; ��������� ������ �� ������ �����
;;; ***************************************************************************
  (setq	flist	(vl-sort flist '(lambda (a b)
				  (< (car a) (car b)) )))
;;; ***************************************************************************
  (foreach en flist
    (ktz-printout en)
    ;(command pause)				;;;;; ������������ ���� ����� ������ � ��������� ����
    						;;;;; ����� ���������� ������ ����� ��� ������������
    );foreach
  );defun



;;;************************************************************************************************************
;;; ����� '(17.13 ((30180.0 23747.6) (30600.0 24044.6)) "-A3")
;;; ������ 17,13 � ������� �� ������������
;;;************************************************************************************************************
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














;;;************************************************************************************************************
;;;************************************************************************************************************
(defun c:export-to-dwg ( /
			lst
			uznumber
			nlist
			pt-list
			scale
			)
  (if (or
	(ssget "_X" '((0 . "LWPOLYLINE")))
	(ssget "_X" '((1 . "���������")))
	(ssget "_X" '((0 . "spdsFormat")))
	)
    (progn
      (alert "������ �� �����������
      \n  - �������� SPDS-������� � �����
      \n  - ������� ����� \"���������\"
      \n  - �������� ��������")
      (exit)
      )
    (setq lst (get-kol-uch))
    );if
      
  (setq scale (/ (cdr (assoc 40 (entget (car lst)))) 2.5))
  
  (foreach ent lst
    (setq pt-list (get-formatpts<-rightformatline (get-rightformatline<-koluch ent)))
    (setq nlist (get-lnumber ent))
    (setq uznumber (cdr (assoc 1 (entget (get-uznumber ent)))))
    (vl-cmdf "_zoom" "_W" (car pt-list) (cadr pt-list))
    
    (ss->file (list (strcat uznumber " �" nlist ".dwg")  (ssget "_C" (car pt-list) (cadr pt-list))))
    )
  );defun
;;;************************************************************************************************************
;;; ����� ("�������� �����1.dwg" <Selection set: 10e0>) � ��������� � ��������� �����
;;;************************************************************************************************************
(defun ss->file (sslist
			  /
			  temp
			  actdoc
			  path
			  filename
			  )
  (setq path "d:/!!! TDMS/"
  ;(setq path "c:/Documents and Settings/user/��� ���������/"
	
	filename (car sslist))
  (setq actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (sssetfirst nil (cadr sslist))
  
  (setq temp (vla-get-ActiveSelectionSet actdoc))
  (vla-Clear temp)
  (vla-SelectOnScreen temp)
  (vla-Wblock actdoc (strcat path filename) temp)
  );defun
;;;************************************************************************************************************
;;;************************************************************************************************************