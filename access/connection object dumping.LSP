

(setq #dbfilename "1721-1-���5.mdb")
(setq #dbpath (strcat "d:\\_AutoCAD\\1721 ������� (������)\\��� ��� �� ��������� II �������\\1721-1-���5 - ��� ��� �� ��������� ���� - 6\\" #dbfilename))


(setq ConnectionObject (ADOLISP_ConnectToDB (strcat "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" #dbpath ";Persist Security Info=False") "admin" ""))


(ADOLISP_DisconnectFromDB ConnectionObject)
(setq ConnectionObject nil)



(set 'gp vlax-get-property)
(setq propsobj (gp ConnectionObject "Properties"))
(setq params '())
(setq i (1- (gp propsobj "Count")))
(while (>= i 0)
  ;(princ (strcat "\n" (gp (gp propsobj "Item" i) "Name")))

  (setq params (cons
  (list
    (gp (gp propsobj "Item" i) "Name")
    (vlax-variant-value (gp (gp propsobj "Item" i) "Value"))
    )
  params
  ))
  (setq i (1- i))
  )


(db|diff params params-old)