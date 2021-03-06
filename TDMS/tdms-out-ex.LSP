;;;   14_03_28 - �� ������ - ������ �����
(vl-load-com)
;; ���� tdms-out-ex.lsp
;; ��������� � ��������� :
;; ��������� ��������� ��������� ����� �� ���� �� ��������� ���� � ������ ���������� ���� "����� ������"
;; ��������� ����������� ��� ������������� ������ � ���� 4.0
;; � ���������� ����������� ������ � ���, ����������� �����������������

;; ��������� ������������� (���� ���) ������ � ������ ���
;; ���� �� �� ������� ������ - �������� ������ �� �������� ��� �� �������� ������������� ���������

;; ������  - ������ ��� ������ (��� ������������� ���) �������������  (��� ��� - "��-00" [��� �������])
;; ������� - ������ ����� ��������, ��� �� ��� � � ����������� �� ����� ������
;; ��� ������� - ������ ����� � ��������� ������ ���� (�������� ��������� - 1744), ��� ������� � �������� - ������ �����
;; ����� - ������ ����� ������ ���� - ��� ����������, ��� ��, ��� ������� � �������� - ������ �����
;; ���� - ��� ��� �������� ����� ���������� ������ (�������� ��� ������� �����: ���2.�1 )

;; ������ ��������� ������������ �� ��������� ������ �������� ����� ����� ����:
;; tdmsget[enter]







(defun c:tdmsget ( / tdms:askwich dcl:formatstring dcl:sepstr dcl:fsforfilename
		  tdms:checkOut tdms:child cont->list kd:dclget)
  (defun tdms:askwich (lst / desc)
    (setq desc (kd:dcl:pick-from-list (mapcar '(lambda (x) (gp x "Description")) lst)))
    (car (vl-remove-if-not '(lambda (x) (= desc (gp x "Description"))) lst))
    );defun
  (defun dcl:formatstring (str / val tail)
    (if (vl-string-search "\"" str)
	 (progn
	   (setq val (reverse (sepstr str "\"")))
	   (setq tail (car val))
	   (setq val (mapcar '(lambda (s) (strcat s "\\\"")) (reverse (cdr val))))
	   (setq val (strcat (apply 'strcat val) tail))
	   )
	 str
	 )
    );defun
  (defun dcl:sepstr (strline delimiter / strhead strtail poz)
    (if (setq poz (vl-string-search delimiter strline))
      (progn (setq strhead (substr strline 1 poz) strtail (substr strline (+ poz 1 (strlen delimiter))))
	(append (list strhead) (sepstr strtail delimiter)))
      (list strline)
      )
    );defun
  (defun dcl:fsforfilename (str)	; format string to generate filename
    (if (vl-string-search "\"" str)
      (apply 'strcat (sepstr str "\""))
      str
      )
    );defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






  

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun kd:dclget (props /
		    
		    propsdcl dlgname dclfilename dcl-file-path hand dcl_id i lst
		  lif				;last input file
		  lifr				;last input file read
		  ld				;last data
		  tmp
		  )
    (setq propsdcl (mapcar 'dcl:formatstring props))
    (setq dlgname "kd_dclget")
    (setq dclfilename (strcat "\\" dlgname ".dcl"))
    (setq lif (strcat "\\dclget-lif-" (apply 'strcat (mapcar 'dcl:fsforfilename props)) ".tmp"))
    ;-----------------------------------------------------------
    (defun kd:dclget_done ( / lst i lifw)		; last input file write
      (setq lst '() i 0)
      (repeat (length props)
	(setq lst (append lst (list (get_tile (strcat "key" (itoa i))))))
	(setq i (1+ i))
	)
      (done_dialog)
      (setq lifw (open (strcat (getenv "temp") lif) "w"))
      (mapcar '(lambda (x) (write-line x lifw)) lst)
      (close lifw)
      lst
      );defun
  ;-----------------------------------------------------------  

  ;;;;*******************************************************************
    (setq dcl-file-path (strcat (getenv "temp") dclfilename) hand (open dcl-file-path "w"))
    (if (setq lifr (open (strcat (getenv "temp") lif) "r"))
      (progn (while (setq tmp (read-line lifr)) (setq ld (append ld (list tmp)))) (close lifr))
      )
    ;;; ��������� dcl-�����
    (mapcar '(lambda (x) (write-line x hand)) (list dlgname ": dialog" "{label=\"kakt00z developing dcl get properties window\";" "width=80;"))
    (setq i 0)
    (repeat (length propsdcl)
      (write-line (strcat ":edit_box" "{"
		  	"label=\"" (nth i propsdcl) "\";"
		  	"key=\"" (strcat "key" (itoa i)) "\";"
		  	"edit_width=50;"
		  	"value=\"" (if ld (nth i ld) "") "\";"
		  	(if (= i 0) "active=true;" "")
			  "allow_accept=true;" "}")
	hand)
    (setq i (1+ i))
    );repeat
  (mapcar '(lambda (x) (write-line x hand)) '(":spacer{width=1;}" "ok_cancel;" "}"))
  (close hand)
  ;;;;*******************************************************************
  
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0) (not (new_dialog dlgname dcl_id))) (exit) ) ;if
    (action_tile "accept"		"(setq lst (kd:dclget_done))")
    (action_tile "is_default"	"(setq lst (kd:dclget_done))")
    (action_tile "cancel" 	"(done_dialog 0)")
    (start_dialog)
    (unload_dialog dcl_id)
    lst
    );defun

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  (defun kd:dcl:pick-from-list (items / itemsdcl dlgname dclfilename dcl-file-path hand dcl_id strlist  i out)
    (setq itemsdcl (mapcar 'dcl:formatstring items))
    (setq dlgname "pick_from_lst")	; must NOT contain "-"
    (setq dclfilename (strcat "\\" dlgname ".dcl"))
    ;-----------------------------------------------------------
    (defun kd:dcl-pfl_done ( / out)
      (setq out (get_tile (strcat dlgname "key")))
      (done_dialog)
      out
      );defun
  ;-----------------------------------------------------------  
  ;;;;*******************************************************************
  (setq dcl-file-path (strcat (getenv "temp") dclfilename)
	hand (open dcl-file-path "w"))
    ;;; ��������� dcl-�����
  (mapcar '(lambda (x) (write-line x hand))
	  (list dlgname ": dialog"  "{label=\"kakt00z developing dcl-pick-from-list window\";" "width=80;"
	    ":list_box{"
	    	(strcat "label=\"Select an item ... "  "\";" )
	    	(strcat "key=\""  dlgname "key\";")
		(strcat "list=\"" (eval (append '(strcat) (mapcar '(lambda (x) (strcat x "\\n")) itemsdcl))) "\";")
		"fixed_width_font=false;" "}"
	":spacer{width=1;}"  "ok_cancel;" "}"))
    (close hand)
  ;;;;*******************************************************************
    (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0) (not (new_dialog dlgname dcl_id))) (exit) ) ;if
  (action_tile "accept"		"(setq out (kd:dcl-pfl_done))")
  (action_tile "is_default"	"(setq out (kd:dcl-pfl_done))")
  (action_tile "cancel" 	"(done_dialog 0)")
  (start_dialog)
  (unload_dialog dcl_id)
  (nth (atoi out) items)
  );defun
  

(defun cont->list (objc / lst)
  (setq lst '())
  (vlax-for o objc (setq lst (cons o lst)))
  (reverse lst)
  );defun
  
(defun tdms:child (obj str / objc lst)
  (setq objc (gp obj "Content"))
  (setq lst (vl-remove-if-not '(lambda (o) (wcmatch (gp o "Description") (strcat "*" str "*"))) (cont->list objc)))
  (cond
    ((= (length lst) 1) (car lst))
    ((> (length lst) 1) (tdms:askwich lst))
    (T (princ (gp o "Description")))
    )
  );defun

(defun tdms:checkOut (/ gp tdmsfolder uzlist uznum otdel uzfolder dogovor #tdms uzobj file quitcheck)
  (set 'gp vlax-get-property)
  (setq tdmsfolder "d:/_TDMS/")
  (if (null (vl-file-directory-p tdmsfolder)) (vl-mkdir tdmsfolder))    
  (setq uzlist (kd:dclget '("������" "�������" "��� �������" "�����" "����")))
  (setq otdel (nth 0 uzlist) dogovor (nth 1 uzlist) uznum (strcat (nth 2 uzlist) "-" (nth 3 uzlist) "-" (nth 4 uzlist)))
  (setq uzfolder (strcat tdmsfolder uznum "/"))
  (if (null (vl-file-directory-p uzfolder)) (vl-mkdir uzfolder))
  (setq #tdms (vlax-get-or-create-object "TDMS.Application"))
  (setq uzobj (tdms:child (tdms:child (tdms:child (tdms:child (gp #tdms "Root") (nth 2 uzlist)) dogovor) otdel) (strcat uznum " ")))
  (vlax-for sh (gp uzobj "Content")
    (setq file (gp (gp sh "Files") "Item" 0))
    (vlax-invoke-method file "CheckOut" (strcat uzfolder (gp file "FileName")))
    (setq file (gp (gp sh "Files") "Item" 1))
    (vlax-invoke-method file "CheckOut" (strcat uzfolder (gp file "FileName")))
    )

  (if (ws|yes-no "tdmsget" "������� ����?")
    (vlax-invoke-method #tdms "Quit")
    )

;;;  (setq quitcheck (kd:dcl:pick-from-list '("������� TDMS" "�������� TDMS ��������")))
;;;  (cond
;;;    ((= quitcheck "�������� TDMS ��������") (princ))
;;;    (T (vlax-invoke-method #tdms "Quit"))
;;;    )
  (mapcar 'vlax-release-object (list file uzobj #tdms))
  );defun
  
  (tdms:checkOut)
  );defun

;; EOP






;; ��������� ������ ��� �������

;; 1. ���������/��������� ���������� (���� �����): ������� ������ � ���� ��������� ����� ����� ��
;; ��� ������� � ����� - �� ���� ���� � ���� "A" ���������� - �� � �� ������ ������� "A" � ����������
;; ���������, ���� ������ ��� �� ���������� �� �������� "�", �� �� �������� � ��������� ����

;; 2. ������� ���� ��� ������ �� ���� D:\ - ���� � ��� �� ��� - ��������� �� ����� ��������
;; - ��� ��� �) ������� �������� ���������� "tdmsfolder" � ������ (setq tdmsfolder "d:/TDMS/") �� �� ����� ���� �� ������
;; ��������� �����, �� ����� �) ���������� � ���������� ��������������

;; 3. �������� �� ��� ������������ ���� ���������� ������ ������, ����� ��� ����� ������� ���� "kd_dclget.dcl"
;; � ����� � ���������� �������, ������� ����� ������ ����� � ��������� ������ �������� - ������� "(getenv "temp")", ��� ������� �������

;; 4. �� ����� ������ ����, ��� � ��������� ���� ��� ������.
;;EOF