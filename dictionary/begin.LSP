(setq od (namedobjdict))

(setq lod (entget (namedobjdict)))


(setq liod
       (mapcar 'cdr (vl-remove-if-not
		      (function (lambda (x) (= (car x) 3)))
		      (entget (namedobjdict))))
      )

;;;***************************************************
(progn
(setq str "")
(foreach x liod (setq str (strcat str "\n" x)))
(princ str)
T)
;;;***************************************************

(entget (tblobjname "block" "монтаж_STS-2.5"))
(entget (cdr (assoc 330 (entget (tblobjname "block" "монтаж_STS-2.5")))))




(dictsearch od "AcDbVariableDictionary")
(entget (cdr (assoc 350 (dictsearch od "AcDbVariableDictionary"))))
(vlax-ldata-list "AcDbVariableDictionary")
(vlax-ldata-list "ACAD_PLOTSTYLENAME")
(dictsearch od "AcDbVariableDictionary")
(dictsearch od "ACAD_GROUP")
(dictsearch od "ACAD_LAYOUT")
(dictsearch od "ACAD_BACKGROUND")
(dictsearch od "ASE_INDEX_DICTIONARY")|
;;;***************************************************

(setq diclist '((0 . "DICTIONARY")(100 . "AcDbDictionary")))
(setq mynewdict (entmakex diclist))
(dictadd od "ktz-dict" mynewdict)

;;; повтор команды 3 сверху, можно 2


(dictsearch od "ktz-dict")
;;;то же самое что и :
(entget mynewdict)

;;;; удалим словарь
;;;(dictremove od "ktz-dict")





;;;***********************************************
(setq lxr1 '((0 . "XRECORD")(100 . "AcDbXrecord")
	     (1 . "кабель")
	     (10  0.0 0.0 0.0)
	     (11  20.0 20.0 0.0)
	     (40 . 5)
	     (41 . 1.5)
	     ))
(setq lxr2 '((0 . "XRECORD")(100 . "AcDbXrecord")
	     (1 . "кабель")
	     (10  30.0 30.0 0.0)
	     (11  20.0 20.0 0.0)
	     (40 . 7)
	     (41 . 1.5)
	     ))

(setq xr1 (entmakex lxr1))
(setq xr2 (entmakex lxr2))

(dictadd   (namedobjdict)   "ktz-cabels"
  (setq newdic (entmakex '((0  .   "DICTIONARY")   (100  .   "AcDbDictionary")))))

(dictadd newdic "moscow" xr1)
(dictadd newdic "piter" xr2)
