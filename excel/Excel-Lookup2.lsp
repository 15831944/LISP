; ������� ����������� ��������������� �������� �.�. � ����� ������� (Kpblc) �� ��������� ����� � ������ ���������.
; ������� � ��� "����������� ������������ ����������" �������� �.�. (Supermax �� DWG.RU � ABOC.RU)
; ��� �������� �������� ���� ������������ ��������� ������� �������������� ������������ � ������� �����.

; �������� � ������ ������� ^C^C(load "Excel-Loocup.lsp" "���� Excel-Loocup.lsp �� ������")
; �������� ������ �� ����� EXCEL  
; ��������� ���������, �������������� ������ � ActiveX
(vl-load-com)
; ��������� ����� � Excel 2003
; ��������:
;   vis = T - ������� Excel �������;
;   vis = nil - ������� Excel ���������.

;������� ��������� ����� � Excel
(defun ex12_set_connect (vis / )
  (setq g_oex (vlax-get-or-create-object "Excel.Application"))
; ���� ����� �� �����������, �� �������� ��������� ������
  (if (null g_oex) (progn (alert "���������� ��������� Microsoft Excel 2003") (exit)))
; ������� Excel ������� � ����������� �� ��������� vis
 (if vis (vlax-put-property g_oex "Visible" :vlax-true))
); ����� ������� ex12_set_connect


; ������� ������� ����� � Excel � �������� �� ������
(defun ex_break_connect ( / )
(vlax-invoke-method g_oex "Quit")
; ����������� �������, ��������� � Excel, ��� ���������� �������� Excel �� ������
(mapcar (function (lambda (x) (if (and x (not (vlax-object-released-p x))) (vlax-release-object x)))) (list g_cell g_mainsh g_shs g_awb g_wkbs g_oex))
; ������ ������
(setq g_cell nil g_mainsh nil g_shs nil g_awb nil g_wkbs nil g_oex nil)
(gc)
);����� ������� ex_break_connect


; ������� ������������ ������� � ����� Excel
(defun readex12_com (tb_xls sheetname / old_echo)
; ���������� ���-������
(setq old_echo (getvar "CMDECHO"))
(setvar "CMDECHO" 0)
; ������������ ����� c Excel
(ex12_set_connect show)
; ��������� ��������� Workbooks
(setq g_wkbs (vlax-get-property g_oex "Workbooks"))
; �������� ����� ����� � ��������� ��������� �����
(setq g_awb (vlax-invoke-method g_wkbs "Open" tb_xls))
; �������� �������� �����
(if (not g_awb) (progn (alert (strcat "�� ��������� ���� " tb_xls)) (ex_break_connect) (exit)))
; ������ ������ ������; �� ����������� �������������� ������
(setq g_shs (vlax-get-property g_awb "Worksheets"))
; ��������� �� 1-� ����
(vlax-for s g_shs (if (= nil (vlax-get-property s "Previous")) (setq g_mainsh s)))
(if (not g_mainsh) (progn (alert (strcat "�� ��������� ����" sheetname)) (ex_break_connect) (exit)))
); ����� ������� readex12_com ����������� ���� *.xls

(defun convert-26 (x / ); ������� ��������������� ����� � ��������� ����������� �������� ������
(if (= (/ x 26) 0) (chr (+ x 65))
 (if (and (> (/ x 26) 0) (<= (/ x 26) 26)) 
  (strcat (chr (+ (1- (/ x 26)) 65)) 
          (chr (+ 65 (- x (* 26 (/ x 26))))))
  (if (and (> (/ (1- (/ x 26)) 26) 0) (<= x 16383)) 
   (progn (setq das_1 (1- (/ (1- (/ x 26)) 26)))
          (setq das_2 (+ 26 (- x (* (1+ (* (1+ das_1) 26)) 26))))
          (strcat (chr (+ das_1 65)) 
                  (chr (+ (1- (/ das_2 26)) 65))
                  (chr (+ 65 (- das_2 (* 26 (/ das_2 26))))
)))))))



; ������ 
(readex12_com 
(setcfg "AppData/Excel-Loocup/files/xls" ;1
(getfiled "����� ����� Excel ��� ������������ Lookup-a" ;2
(if (null (getcfg "AppData/Excel-Loocup/files/xls")) (car '("C:\\")) (getcfg "AppData/Excel-Loocup/files/xls"))
 "xls" 0)) '(vlax-get-property g_mainsh "Name"))

(setq g_mainst g_mainsh)
(setq str_listr (list (vlax-get-property g_mainst "Name")))
(setq str_list nil)
(while (/= nil (vlax-get-property g_mainst "Next")) 
(progn 
(setq g_mainst (vlax-get-property g_mainst "Next")) 
(setq str_list (list (vlax-get-property g_mainst "Name")))
(setq str_listr (append str_list str_listr))))
;������ ������ �������� � ���������� str_listr
(setq str_listr (reverse str_listr))


(defun modes2 ( / ) (setq listrr (nth (atoi (get_tile "b4")) str_listr)) (done_dialog)
; ��������� �� ��������� ����
(vlax-for s g_shs (if (= listrr (vlax-get-property s 'Name)) (setq g_listsel s)))
(if (not g_listsel) (progn (alert (strcat "�� ��������� ��������� ���� " listrr)) (ex_break_connect) (exit)))
) 

(defun modes3 ( / ) (setq listlookup (nth (atoi (get_tile "b4")) n17)) (done_dialog)
); ��������� �� ��������� Lookup. � ���������� listlookup �������� ��� Lookup-a 

(setq Fdcl "0055Selection.dcl")                                          ;;; Add VVA 12.09.2008
(setq Fdcl (strcat (VL-FILENAME-DIRECTORY(vl-filename-mktemp Fdcl)) "\\" Fdcl))   ;;; Add VVA 12.09.2008
(vl-file-delete Fdcl)  ;_Mod VVA 12.09.2008 ;���� ���� ����� ����, �� ��� �����, ��������� �� ������ ��� ��������� � 0.
;� listrr �������� ��� ����� � �������� ������������ Lookup-a
(setq dsl0055 (open Fdcl "w")) ;_Mod VVA 12.09.2008 ;��������� ���� 0055selection.dcl ������������ ��������.
(write-line "np_exel: dialog{label=\"����� ������� ����� � �����\";\n  :column{label=\" \";" dsl0055)
(write-line "  :text{label=\"������ ������������ � ����� ������\";alignment=centered;}" dsl0055)
(write-line "  :popup_list{label=\" \";list=\" \";value=\" \";key=\"b4\";width=35;alignment=centered;}" dsl0055)
(write-line "  :ok_button{label=\"���������\";key=\"df3\";alignment=centered;fixed_width=true;}" dsl0055)
(write-line "  }}//" dsl0055)
(close dsl0055)

(if (/= (setq Selexel (load_dialog Fdcl)) -1) ;_Mod VVA 12.09.2008
(new_dialog "np_exel" Selexel "" (list 222 114)) (alert "���� 0055Selection.dcl �� ������"))
(action_tile "df3" "(modes2)")
(mode_tile "accept" 1)
(start_list "b4")
(setq ddffdd (mapcar 'add_list str_listr))
(end_list)
(start_dialog)

(setq lst (entget (TBLOBJNAME "block" (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel "������� ������ ��� ����"))))) '("*")))
(setq aa (cdr (assoc 330 lst)))
(setq n17 nil)
(setq n15 (entget (car (setq lst_dict (mapcar 'cdr (vl-remove-if-not '(lambda(x) (= (car x) 360)) (entget (cdr (assoc 360 (entget aa))))))))))
(setq n16 (mapcar '(lambda(z) (setq n17 (cons (cdr (assoc 300 (entget (cdr z)))) n17))) 
(vl-remove-if-not '(lambda(y) (= (cdr (assoc 0 (entget (cdr y)))) "BLOCKLOOKUPACTION")) ;�� ���� �������� �������� ������ "BLOCKLOOKUPACTION"
(vl-remove-if-not '(lambda(x) (= (car x) 360)) (entget (car lst_dict)))))) ;�������� ��� ������� � ���. ����������
(setq n17 (reverse n17)) ;��������������, � �� �� ����� �� ����� ����������.

(setq Fdcl "0066Selection.dcl")                                          ;;; Add VVA 12.09.2008
(setq Fdcl (strcat (VL-FILENAME-DIRECTORY(vl-filename-mktemp Fdcl)) "\\" Fdcl))   ;;; Add VVA 12.09.2008

(vl-file-delete Fdcl) ;_Mod VVA 12.09.2008 ;���� ���� ����� ����, �� ��� �����, ��������� �� ������ ��� ��������� � 0.
;� listrr �������� ��� ����� � �������� ������������ Lookup-a
(setq dsl0066 (open Fdcl "w")) ;_Mod VVA 12.09.2008 ;��������� ���� 0066selection.dcl ������������ ��������.
(write-line "np_lookup: dialog{label=\"����� ������� Lookup-a � �����\";\n  :column{label=\" \";" dsl0066)
(write-line "  :text{label=\"������ ������������ � ����� Lookup-��\";alignment=centered;}" dsl0066)
(write-line "  :popup_list{label=\" \";list=\" \";value=\" \";key=\"b4\";width=35;alignment=centered;}" dsl0066)
(write-line "  :ok_button{label=\"���������\";key=\"df3\";alignment=centered;fixed_width=true;}" dsl0066)
(write-line "  }}//" dsl0066)
(close dsl0066)

(if (/= (setq Sellookup (load_dialog Fdcl)) -1);_Mod VVA 12.09.2008
(new_dialog "np_lookup" Sellookup "" (list 222 114)) (alert "���� 0066Selection.dcl �� ������"))
(action_tile "df3" "(modes3)") ; ����� ������������ � ���������� listlookup �������� ��� Lookup-a 
(mode_tile "accept" 1)
(start_list "b4")
(setq ddffdd (mapcar 'add_list n17))
(end_list)
(start_dialog)

(setq n18  (entget (cdr (car
(vl-remove-if-not '(lambda(y) (= (cdr (assoc 300 (entget (cdr y)))) listlookup)) ;�� ���� �������� �������� ������ ���, ��� ��� ��������� � ���������� � ���������� listlookup
(vl-remove-if-not '(lambda(x) (= (car x) 360)) (entget (car lst_dict)))))))) ;�������� ��� ������� � ���. ����������
(setq n19 (cdr (assoc 93 n18)))
(if (= n19 0) (progn (alert "Lookup �� �������� ���������!") (ex_break_connect) (exit)))
(setq n21 nil)
(while (/= (car (car n18)) 301) (setq n21 (cons (car n18) n21)) (setq n18 (cdr n18)))
(setq n301 (car n18))
(setq n18 (cdr n18))
(while (= (car (car n18)) 302) (setq n18 (cdr n18))) ;�������� �� 302 ����� ������ ����������� ������

(defun xyn ( / )
(setq N_X_I (convert-26 N_X))
(setq N_YI (itoa N_Y))
(setq N_XS (itoa N_X))
(setq N_XI N_X_I)
(setq N_XY (strcat N_XI  N_YI))
(setq g_cell (vlax-variant-value (vlax-invoke-method g_mainsh "Evaluate" N_XY)))
;������ ������ �� ������
(setq _Color (vlax-variant-value (vlax-get-property (vlax-get-property g_cell 'Font) 'Color)))
(setq _FontName (vlax-variant-value (vlax-get-property (vlax-get-property g_cell 'Font) 'Name)))
(setq _Text (vl-princ-to-string (vlax-variant-value (vlax-get-property g_cell 'Text))))
); ����� ������� ������ ������ �� g_mainsh (1-� ����)

(setq N_Y 1)
(setq N_X 0)
(setq n23  nil)
(defun cod ( / ) (setq n23 (append n23 (list (vl-list* 302 (xyn))))))

;������� ����� � ����� ������.
(while (/= (xyn) "") (setq N_Y (+ N_Y 1)))
(setq N_Y-end (1- N_Y))
(setq N_X-end (1- n19))
(setq N_Y 1)
(defun wwwhile ( / ) (while (<= (1+ N_X)  N_X-end) (setq N_X (1+ N_X)) (cod)))
(print (while (<= N_Y N_Y-end) (cod) (wwwhile) (setq N_X 0) (setq N_Y (+ 1 N_Y))))


(setq n24 (car n21))
(setq n25 (cdr (cdr n21)))
(setq n20 (reverse n25))
(setq n20 (append n20 (list (vl-list* 92 N_Y-end)) (list n24) (list n301)))
(setq n22 (append n20 n23 n18))
(setq n26 nil)
(while (/= (car (car n22)) 1071) (setq n26 (cons (car n22) n26)) (setq n22 (cdr n22))) ; ������� ��� 1071
(setq n22 (cdr n22))
(setq n22 (append (reverse n26) n22))
(setq n26 nil)
(while (/= (car (car n22)) 1010) (setq n26 (cons (car n22) n26)) (setq n22 (cdr n22))) ; ������� ��� 1010
(setq n22 (cdr n22))
(setq n22 (append (reverse n26) n22))
(print (entmod n22))
(entupd (cdr (car n22)))


