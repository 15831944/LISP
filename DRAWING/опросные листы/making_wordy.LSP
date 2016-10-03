(load (strcat #lisppath "strings/str+.lsp"))
(load (strcat #lisppath "excel/xlsformatlib.LSP"))
;(alert "не забыть проверить ввод данных из екселя в список лиспа типа 1.56E-5")

(setq nsheet 2)			; номер листа
(setq noplista "00")		; номер опросника
(setq nopprefix "02 04 ")
(setq fwf 2)			; fontwidthfactor
(setq nuzh "1744-1-АТМ5.ОЛ")

(setq
  families
   '(
     ("Зав. гр. ОСУ"	"С. Е. Позняк\t"		"(017) 200-53-55")
     ("Гл. констр. ОСУ"	"В. Ф. Евченко"		"(017) 209-44-12")
     ("Гл. техн. ОТ"	"А. С. Шутенков"	"(017) 200-59-21")
     )
   )

;(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . ""))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   1-й запуск внизу  а тут второй и последующие запуски -       (addrasschet)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun addsheet (pt / obj)
  (setq obj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(210 -297 0))) (strcat #lisppath "!blocking\\format-spec.dwg") 1 1 1 0))
  (vla-put-Value (getbdyn obj "Выбор") "A4")
  (vla-put-TextString (getbatt obj "НОМЕР_УЗЛА") nuzh)
  (vla-put-Textstring (getbatt obj "FORMAT_NAME") (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID obj)) ">%).Parameter(15).lookupString>%"))
  (vla-put-TextString (getbatt obj "НОМЕР_ЛИСТА") (itoa (setq nsheet (1+ nsheet))))
  (vla-put-Layer obj "com_formats-tables")
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun addrasschet ( / str lst pt txto)
(setq lst (excel>lst))
(setq lst (db|formatdata lst))
(setq pt (getpoint))
(addsheet pt)
(setq str "РУП \"Белнипиэнергопром\"")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(30 -12 0))))

(setq str "Опросный лист №")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 3)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(165 -12 0))))

(setq noplista (str+ noplista))
(setq str (strcat nopprefix noplista))
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(169 -12 0))))

(setq str "Опросный лист по проведению расчетов отверстия сужающего устройства")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 2)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(112 -17 0))))


(setq str "Заказчик:")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(30 -28 0))))

(setq str "РУП \"Брестэнерго\", филиал Пинские тепловые сети, Щербинин Н. Ф.")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(80 -28 0))))

(setq str "Почтовый адрес заказчика:")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(30 -32 0))))

(setq str "225710, г. Пинск, ул. Переборная, 1а")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(80 -32 0))))

(vla-addLine #modspace (vlax-3d-point (mapcar '+ pt '(20 -37 0))) (vlax-3d-point (mapcar '+ pt '(205 -37 0))))



(setq cpt (mapcar '+ pt '(20 -42 0)))
(mapcar
  '(lambda (line / str wdth ccpt)

     (setq ccpt (mapcar '+ cpt '(5 -5 0)))
     (setq str (nth 0 line))
     (setq wdth (* fwf (strlen str)))
     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) wdth str))
     (vla-put-Height txto 2.5)
     (vla-put-AttachmentPoint txto 1)
     (vla-put-InsertionPoint txto (vlax-3d-point ccpt))
     

     (setq ccpt (mapcar '+ ccpt (list wdth 0 0) '(2 0 0)))
     (setq str (nth 1 line))
     (setq wdth (* fwf (strlen str)))
     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) wdth str))
     (vla-put-Height txto 2.5)
     (vla-put-AttachmentPoint txto 1)
     (vla-put-InsertionPoint txto (vlax-3d-point ccpt))

     (setq ccpt (mapcar '+ ccpt (list wdth 0 0) '(2 0 0)))
     (setq str (nth 2 line))
     (setq wdth (* fwf (strlen str)))
     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) wdth str))
     (vla-put-Height txto 2.5)
     (vla-put-AttachmentPoint txto 1)
     (vla-put-InsertionPoint txto (vlax-3d-point ccpt))

     (setq ccpt (mapcar '+ ccpt (list wdth 0 0) '(2 0 0)))
     (setq str (nth 3 line))
     (setq wdth (* fwf (strlen str)))
     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) wdth str))
     (vla-put-Height txto 2.5)
     (vla-put-AttachmentPoint txto 1)
     (vla-put-InsertionPoint txto (vlax-3d-point ccpt))

     (setq ccpt (mapcar '+ ccpt (list wdth 0 0) '(2 0 0)))
     (setq str (nth 4 line))
     (setq wdth (* fwf (strlen str)))
     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) wdth str))
     (vla-put-Height txto 2.5)
     (vla-put-AttachmentPoint txto 1)
     (vla-put-InsertionPoint txto (vlax-3d-point ccpt))

     (setq cpt (mapcar '+ cpt '(0 -5 0)))
     
     (if (> (abs (cadr (mapcar '- cpt pt))) 262)
       (progn
	 (setq pt (mapcar '+ pt '(0 -302 0)))
	 (addsheet pt)
	 (setq cpt (mapcar '+ pt '(20 -10 0)))
	 )
       )
     )
  lst)
(setq pt (mapcar '+ pt '(0 -302 0)))


;(setq str "Зав. гр. ОСУ\\P\\PГл. констр. ОСУ\\P\\PГл. техн. ОТ")
(setq str (strcat
	    (car (nth 0 families)) "\\P"
	    (car (nth 1 families)) "\\P"
	    (car (nth 2 families))
	    ))  
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) 40 str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 7)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(30 70 0))))

;(setq str "С. Е. Позняк (017 200-53-55)\\P\\PВ. Ф. Евченко (017 209-44-12)\\P\\PА. С. Шутенков (017 200-59-21)")
(setq str (strcat
	    (cadr (nth 0 families)) "\t" (caddr (nth 0 families)) "\\P"
	    (cadr (nth 1 families)) "\t" (caddr (nth 1 families)) "\\P"
	    (cadr (nth 2 families)) "\t" (caddr (nth 2 families))
	    ))
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) 60 str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 7)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(130 70 0))))

);defun addrasschet


;;;(setq cpt (mapcar '+ pt '(20 -42 0)))
;;;(mapcar
;;;  '(lambda (line / str)
;;;     (setq str (nth 0 line))
;;;     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
;;;     (vla-put-Height txto 2.5)
;;;     (vla-put-AttachmentPoint txto 1)
;;;     (vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ cpt '(5 -5 0))))
;;;
;;;     (setq str (nth 1 line))
;;;     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
;;;     (vla-put-Height txto 2.5)
;;;     (vla-put-AttachmentPoint txto 3)
;;;     (vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ cpt '(163 -5 0))))
;;;     
;;;     (setq str (nth 2 line))
;;;     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* fwf (strlen str)) str))
;;;     (vla-put-Height txto 2.5)
;;;     (vla-put-AttachmentPoint txto 1)
;;;     (vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ cpt '(165 -5 0))))
;;;     (setq cpt (mapcar '+ cpt '(0 -5 0)))
;;;     (if (> (abs (cadr (mapcar '- cpt pt))) 262)
;;;       (progn
;;;	 (setq pt (mapcar '+ pt '(0 -302 0)))
;;;	 (addsheet pt)
;;;	 (setq cpt (mapcar '+ pt '(20 -10 0)))
;;;	 )
;;;       )
;;;     )
;;;  lst)






(if addrasschet (addrasschet) (alert (strcat "не была загружена функция\nзагрузил!\nго еще раз")))