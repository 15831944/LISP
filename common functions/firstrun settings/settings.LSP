(vl-load-com)
(setq #cad (vlax-get-acad-object)
      #actdoc (vla-get-activedocument #cad)
      #modspace (vla-get-modelspace #actdoc)
      )

(setq #cadpath "D:\\_AutoCAD")
(setq #lisppath "D:\\_LISP\\")





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kd:mkpath (path / lst cpath)
  (defun sepstr (strline delimiter / strhead strtail poz)
    (if (setq poz (vl-string-search delimiter strline))
      (progn (setq strhead (substr strline 1 poz) strtail (substr strline (+ poz 1 (strlen delimiter))))
	(append (list strhead) (sepstr strtail delimiter)))
      (list strline))
    );defun
  (setq lst (vl-remove "" (sepstr path "\\"))) (setq cpath (car lst) lst (cdr lst))
  (mapcar '(lambda (dir) (setq cpath (strcat cpath "\\" dir)) (if (null (vl-file-directory-p cpath)) (vl-mkdir cpath))) lst)
  );defun
(defun sepstr (strline delimiter / strhead strtail poz)
  ;(setq delimiter "\\" strline cstr)
  (if (setq poz (vl-string-search delimiter strline))
    (progn (setq strhead (substr strline 1 poz) strtail (substr strline (+ poz 1 (strlen delimiter))))
      (append (list strhead) (sepstr strtail delimiter)))
    (list strline)
    );if
  );defun
(defun antisep (lst del)
  (vl-string-right-trim del (apply 'strcat (mapcar '(lambda (x) (strcat x del)) lst)))
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;(do (vla-get-Files (vla-get-Preferences #cad)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; path for the database workspace file
; AutoCAD path
;(vla-get-WorkspacePath (vla-get-Files (vla-get-Preferences #cad)))
(setq path (strcat #cadpath "\\_- ACAD system -_\\acad data links" ))
(if (or (vl-file-directory-p path) (apply '= (cons 'T (kd:mkpath path))))
  (vla-put-WorkspacePath (vla-get-Files (vla-get-Preferences #cad)) path)
  (princ (strcat "\n ������������ � ���������� �������  " path " , - �� ���������"))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DefaultPlotToFilePath
(setq path "D:\\_TDMS\\")
(if (or (vl-file-directory-p path) (apply '= (cons 'T (kd:mkpath path))))
  (vla-put-DefaultPlotToFilePath (vla-get-Output (vla-get-Preferences #cad)) path)
  (princ (strcat "\n ������������ � ���������� �������  " path " , - �� ���������"))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CustomDictionary
;(vla-get-CustomDictionary (vla-get-Files (vla-get-Preferences #cad)))
(setq path  (strcat #cadpath "\\_- ACAD system -_\\Dictionary\\sample.cus"))
(if (findfile path)
  (vla-put-CustomDictionary (vla-get-Files (vla-get-Preferences #cad)) path)
  (princ (strcat "\n ������������ �����  " path " , - �� ���������"))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (vl-string-search "\\enu\\" (getvar "LOCALROOTPREFIX"))
  (vla-put-TextEditor (vla-get-Files (vla-get-Preferences #cad)) "Internal")
  (vla-put-TextEditor (vla-get-Files (vla-get-Preferences #cad)) "����������")
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(setq path  (strcat #cadpath "\\_- ACAD system -_\\Fonts"))
(setq tmp (vla-get-SupportPath (vla-get-Files (vla-get-Preferences #cad))))
(vla-put-SupportPath (vla-get-Files (vla-get-Preferences #cad)) (antisep (cons path (sepstr tmp ";")) ";"))
(setq tmp nil)


; PrintSpoolerPath
;;;(setq path (strcat #cadpath "\\_- ACAD system -_\\acad temp\\"))
;;;(if (or (vl-file-directory-p path) (apply '= (cons 'T (kd:mkpath path))))
;;;  (vla-put-PrintSpoolerPath (vla-get-Output (vla-get-Preferences #cad)) path)
;;;  (princ (strcat "\n ������������ � ���������� �������  " path " , - �� ���������"))
;;;  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TempFilePath
;;;(setq path (strcat #cadpath "\\_- ACAD system -_\\acad temp\\"))
;;;(if (or (vl-file-directory-p path) (apply '= (cons 'T (kd:mkpath path))))
;;;  (vla-put-TempFilePath (vla-get-Output (vla-get-Preferences #cad)) path)
;;;  (princ (strcat "\n ������������ � ���������� �������  " path " , - �� ���������"))
;;;  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TempXrefPath
;;;(setq path (strcat #cadpath "\\_- ACAD system -_\\acad exref\\"))
;;;(if (or (vl-file-directory-p path) (apply '= (cons 'T (kd:mkpath path))))
;;;  (vla-put-TempXrefPath (vla-get-Output (vla-get-Preferences #cad)) path)
;;;  (princ (strcat "\n ������������ � ���������� �������  " path " , - �� ���������"))
;;;  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(vla-get-SaveAsType (vla-get-OpenSave (vla-get-Preferences #cad)))
;��������� ��������:
;   acUnknown (-1) � ����������� ������ � ���� ��������� (������ ������)
;   acR12_DXF(l) �RI2DXF;
;   ac2000_dwg(12) � R15DWG;
;   acRl5_dwg(12) �RI5DWG;
;   ac2000_dxf(13) �R15DXF;
;   acRl5_dxf(13) �R15DXF;
;   ac2000_Template(14) � R15DWT;
;   acRl5_Tsroplate(14) �RI5DWT;
;   acNative (24) � "������" ������;
;   ac2004_dwg (24) � R16 DWG;
;   acR18_dwg(24) �R16DWG;
;   ac2004_dxf (25) � R16 DX F;
;   acRl8_dxf(25) �R16DXF;
;   ac2004_Template (26) � R16 DWT;
;   acRl8_Template(26) �R16DWT.
(vla-put-SaveAsType (vla-get-OpenSave (vla-get-Preferences #cad))
  ac2004_dwg
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(do (vla-get-Files (vla-get-Preferences #cad)))
;(do (vla-get-Drafting (vla-get-Preferences #cad)))
;(do (vla-get-Preferences #cad))

;(getvar "TRUSTEDPATHS")

;#lisppath
;(setvar "TRUSTEDPATHS" (strcat "\\\\srv-energo\\acad\\!_��������\\LISP\\...;" #lisppath "..."))
(setvar "TRUSTEDPATHS" (strcat #lisppath "..."))
(setvar "TIMEZONE" 2000)

(setq path nil)





