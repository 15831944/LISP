

(defun dbmake (
	       /
	       ;db
	       ;od
	   )
(dictadd   (setq od (namedobjdict))   "KIP"
  (setq db (entmakex '((0  .   "DICTIONARY")   (100  .   "AcDbDictionary")))))
  );defun


(dictsearch od "KIP")


(setq signal '((0 . "XRECORD")(100 . "AcDbXrecord")
	       (1 . "5�����17")
	       (2 . "������� � ������������ �������� �")
	     ))
(setq sig (entmakex signal))
(dictadd db "KIP" sig)