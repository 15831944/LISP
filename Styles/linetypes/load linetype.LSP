;(load (strcat #lisppath "common functions\\kd-container-list.LSP"))


;(mapcar 'vla-get-name (kd-container->list lts))


(setq #linetypes (vla-get-LineTypes #actdoc))


(defun lltps (str / )
  (vla-load
    #linetypes
    str
    "d:\\_AutoCAD\\eneca\\styles\\linetypes\\pe_linetypes.lin"
    ;"d:/_AutoCAD/!!!!! ��������� � ��������� ACAD&SPDS/���� �����/������.lin"
    ;"d:/_AutoCAD/!!!!! ��������� � ��������� ACAD&SPDS/���� �����/BNP-gost-lines.lin"
    )
  );defun

(lltps "PE-T2")


(lltps "R-drain")
(lltps "R-����-�-�")
(lltps "BNP-����")
(lltps "BNP-����")

(lltps "R-����")
(lltps "BNP-����")


(lltps "R-�����")

(mapcar 'lltps
"R-����1"
"R-�����"
"R-�����"
	)


(setq #linetypes (vla-get-LineTypes #actdoc))
(defun lltps (str / )
  (vla-load #linetypes str "d:/_AutoCAD/!!!!! ��������� � ��������� ACAD&SPDS/���� �����/BNP-gost-lines.lin")
  )


(mapcar 'lltps '(
"BNP-����-�������"
"BNP-���������"
"BNP-���-�������"
))

(lltps "BNP-��������-�����������")

(mapcar 'lltps '(
;"BNP-����-�������"
"BNP-����-�������"
))
