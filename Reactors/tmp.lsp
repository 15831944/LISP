(vl-load-com)

; ��������� �� ������ ��� ������:
(setq obj (vlax-ename->vla-object (car (entsel))))


;������������� �� ���� ������� ����������� 
(setq reactor1 (vlr-object-reactor (list obj) nil (list '(:VLR-modified . vlr-sdd22))))
;������ ��� ����������
(vlr-pers reactor1) ;������, ��� ������ ����

;(vlr-remove-all)


;������� ����������� �� ��������� �������� ��������
(defun lisp_Onobj () 
;����������� ������ Script
(vl-catch-all-apply '(lambda () (vlax-release-object script)))
(alert "������"))
;������� �������� ������ ��������
(defun VLR-SDD22 (a-object b-vlr-object c-data / ) 
;��������� ��������� �� ������ - ���� "�����
 (setq stat-object a-object)
;��������� ��������� �� ������ - �������
 (setq stat-vlr-object b-vlr-object)
;���������� ��� ���������� �����
(setq Fdcl "Sel555.vbs")	
;������� ���� � ���������� �����
(setq Fdcl (strcat (VL-FILENAME-DIRECTORY(vl-filename-mktemp Fdcl)) "\\" Fdcl))   
(vl-file-delete Fdcl)  ;���� ���� ����� ����, �� ��� �����, ��������� �� ������ ��� ��������� � 0.

(setq dsl0055 (open Fdcl "w")) ;��������� � ��������� ���� Sel555.vbs 
(write-line "Set AutoCAD = GetObject(, \"AutoCAD.Application\")" dsl0055)
(write-line "Set ActiveDocument = AutoCAD.ActiveDocument" dsl0055)
(write-line "WScript.Sleep 10" dsl0055)
(write-line "ActiveDocument.SendCommand \"(lisp_Onobj) \"" dsl0055)
(close dsl0055)
;��������� ������.
(setq script (DwgRu-WScript-Exec Fdcl ""))

;��������� �� ��������
)


(defun DwgRu-WScript-Exec (a b /)
  (alert "������!")
  )







;;;;;;  2
;;;;������� ����������� �� ��������� �������� ��������
;;;(defun lisp_Onobj () (alert "������"))
;;;;������� �������� ������ ��������
;;;(defun VLR-SDD22 (a-object b-vlr-object c-data / ) 
;;;(setq ScriptControl (vlax-get-or-create-object "MSScriptControl.ScriptControl"))
;;;(vlax-put-property ScriptControl "Language" "VBScript")
;;;(vlax-invoke-method ScriptControl "AddCode" "
;;;  Set AutoCAD = GetObject(, \"AutoCAD.Application\")
;;;  Set ActiveDocument = AutoCAD.ActiveDocument
;;;  ActiveDocument.SendCommand \"(lisp_Onobj) \"
;;;")
;;;)
;;;  1
;;;
;;;(defun VLR-SDD22 (
;;;		  a-object
;;;		  b-vlr-object
;;;		  c-data
;;;		  /
;;;		  )
;;;  (vla-SendCommand (vla-get-ActiveDocument (vlax-get-acad-object))"(alert \"������!\") ")
;;;  (alert 
;;;    "���� ��� ��� �������"
;;;    )
 ;(vlax-dump-object a-object)
