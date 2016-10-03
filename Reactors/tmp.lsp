(vl-load-com)

; Указываем на нужный нам объект:
(setq obj (vlax-ename->vla-object (car (entsel))))


;Устанавливаем на него реактор модификации 
(setq reactor1 (vlr-object-reactor (list obj) nil (list '(:VLR-modified . vlr-sdd22))))
;Делаем его постоянным
(vlr-pers reactor1) ;Пардон, тут ошибка была

;(vlr-remove-all)


;Функция запускаемая по окончании действия реактора
(defun lisp_Onobj () 
;освобождаем объект Script
(vl-catch-all-apply '(lambda () (vlax-release-object script)))
(alert "Привет"))
;Функция действия самого реактора
(defun VLR-SDD22 (a-object b-vlr-object c-data / ) 
;Сохраняем указатель на объект - блок "линия
 (setq stat-object a-object)
;Сохраняем указатель на объект - реактор
 (setq stat-vlr-object b-vlr-object)
;записываем имя временного файла
(setq Fdcl "Sel555.vbs")	
;Создаем путь к временному файлу
(setq Fdcl (strcat (VL-FILENAME-DIRECTORY(vl-filename-mktemp Fdcl)) "\\" Fdcl))   
(vl-file-delete Fdcl)  ;Если есть такой файл, то его убить, поскольку он каждый раз создается с 0.

(setq dsl0055 (open Fdcl "w")) ;Открываем и заполняем файл Sel555.vbs 
(write-line "Set AutoCAD = GetObject(, \"AutoCAD.Application\")" dsl0055)
(write-line "Set ActiveDocument = AutoCAD.ActiveDocument" dsl0055)
(write-line "WScript.Sleep 10" dsl0055)
(write-line "ActiveDocument.SendCommand \"(lisp_Onobj) \"" dsl0055)
(close dsl0055)
;Запускаем скрипт.
(setq script (DwgRu-WScript-Exec Fdcl ""))

;Сваливаем из реактора
)


(defun DwgRu-WScript-Exec (a b /)
  (alert "ОПАЧКИ!")
  )







;;;;;;  2
;;;;Функция запускаемая по окончании действия реактора
;;;(defun lisp_Onobj () (alert "Привет"))
;;;;Функция действия самого реактора
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
;;;  (vla-SendCommand (vla-get-ActiveDocument (vlax-get-acad-object))"(alert \"Привет!\") ")
;;;  (alert 
;;;    "Пока еще нет привета"
;;;    )
 ;(vlax-dump-object a-object)
