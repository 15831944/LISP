;(load (strcat #lisppath "common functions\\kd-container-list.LSP"))


;(mapcar 'vla-get-name (kd-container->list lts))


(setq #linetypes (vla-get-LineTypes #actdoc))


(defun lltps (str / )
  (vla-load
    #linetypes
    str
    "d:\\_AutoCAD\\eneca\\styles\\linetypes\\pe_linetypes.lin"
    ;"d:/_AutoCAD/!!!!! заготовки и настройки ACAD&SPDS/типы линий/РОССИЯ.lin"
    ;"d:/_AutoCAD/!!!!! заготовки и настройки ACAD&SPDS/типы линий/BNP-gost-lines.lin"
    )
  );defun

(lltps "PE-T2")


(lltps "R-drain")
(lltps "R-конд-х-о")
(lltps "BNP-Фуоо")
(lltps "BNP-Куоо")

(lltps "R-Фууф")
(lltps "BNP-Фууф")


(lltps "R-Фуэди")

(mapcar 'lltps
"R-Фуоо1"
"R-Куэди"
"R-Фуэди"
	)


(setq #linetypes (vla-get-LineTypes #actdoc))
(defun lltps (str / )
  (vla-load #linetypes str "d:/_AutoCAD/!!!!! заготовки и настройки ACAD&SPDS/типы линий/BNP-gost-lines.lin")
  )


(mapcar 'lltps '(
"BNP-Вода-сетевая"
"BNP-конденсат"
"BNP-пар-отборов"
))

(lltps "BNP-продувка-непрерывная")

(mapcar 'lltps '(
;"BNP-вода-химобес"
"BNP-вода-химочищ"
))
