
(setq lst (excel>lst))
(setq lst (mapcarx any-to-string nil lst))
(setq nsheet 2)

(defun getqlits (str) (length (VL-STRING->LIST str)))





(setq pt (getpoint))

(setq obj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(210 -297 0)))
  (strcat #lisppath "!blocking\\format-spec.dwg")
  1 1 1 0))

(vla-put-Value (getbdyn obj "Выбор") "A4")
(vla-put-TextString (getbatt obj "НОМЕР_УЗЛА") "1744-1-АТМ1.ОЛ")
(vla-put-Textstring (getbatt obj "FORMAT_NAME") (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID obj)) ">%).Parameter(15).lookupString>%"))
(vla-put-TextString (getbatt obj "НОМЕР_ЛИСТА") (itoa (setq nsheet (1+ nsheet))))
(vla-put-Layer obj "com_formats-tables")





(setq str "РУП \"Белнипиэнергопром\"")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 3 (getqlits str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(30 -12 0))))

(setq str "Опросный лист №")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 3 (getqlits str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 3)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(165 -12 0))))
  
(setq str "01 04 07")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 3 (getqlits str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(169 -12 0))))

(setq str "Опросный лист по проведению расчетов отверстия сужающего устройства")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 2.5 (getqlits str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 2)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(112 -17 0))))


(setq str "Заказчик:")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 2.5 (getqlits str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(30 -28 0))))

(setq str "РУП \"Брестэнерго\", филиал Пинские тепловые сети, Щербинин Н. Ф.")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 2.5 (getqlits str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(80 -28 0))))

(setq str "Почтовый адрес заказчика:")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 2.5 (getqlits str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(30 -32 0))))

(setq str "225710, г. Пинск, ул. Переборная, 1а")
(setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 2.5 (getqlits str)) str))
(vla-put-Height txto 2.5)
(vla-put-AttachmentPoint txto 1)
(vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ pt '(80 -32 0))))

(vla-addLine #modspace (vlax-3d-point (mapcar '+ pt '(20 -37 0))) (vlax-3d-point (mapcar '+ pt '(205 -37 0))))




(setq cpt (mapcar '+ pt '(20 -42 0)))
(mapcar
  '(lambda (line / str)
     (setq str (nth 0 line))
     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 2.5 (getqlits str)) str))
     (vla-put-Height txto 2.5)
     (vla-put-AttachmentPoint txto 1)
     (vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ cpt '(5 -5 0))))

     (setq str (nth 1 line))
     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 2.5 (getqlits str)) str))
     (vla-put-Height txto 2.5)
     (vla-put-AttachmentPoint txto 3)
     (vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ cpt '(163 -5 0))))
     
     (setq str (nth 2 line))
     (setq txto (vla-AddMtext #modspace (vlax-3d-point '(0 0 0)) (* 2.5 (getqlits str)) str))
     (vla-put-Height txto 2.5)
     (vla-put-AttachmentPoint txto 1)
     (vla-put-InsertionPoint txto (vlax-3d-point (mapcar '+ cpt '(165 -5 0))))
     (setq cpt (mapcar '+ cpt '(0 -5 0)))
     (if (> (abs (cadr (mapcar '- cpt pt))) 262)
       (progn
	 (setq pt (mapcar '+ pt '(0 -302 0)))
	 (setq obj (vla-InsertBlock #modspace (vlax-3d-point (mapcar '+ pt '(210 -297 0)))
		     (strcat #lisppath "!blocking\\format-spec.dwg")
		     1 1 1 0))
	 (vla-put-Value (getbdyn obj "Выбор") "A4")
	 (vla-put-TextString (getbatt obj "НОМЕР_УЗЛА") "1744-1-АТМ1.ОЛ")
	 (vla-put-Textstring (getbatt obj "FORMAT_NAME") (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID obj)) ">%).Parameter(15).lookupString>%"))
	 (vla-put-TextString (getbatt obj "НОМЕР_ЛИСТА") (itoa (setq nsheet (1+ nsheet))))
	 (vla-put-Layer obj "com_formats-tables")
	 (setq cpt (mapcar '+ pt '(20 -10 0)))
	 )
       )
     )
  lst)






