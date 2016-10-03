(load (strcat #lisppath "XDictionaries\\XDictlib.LSP"))

;(setq #dicts (vla-get-Dictionaries #actdoc))
(setq #DB (vla-add (vla-get-Dictionaries #actdoc) "#DATABASE"))






;  идея-изобретение
мой словарь #DB="#DATABASE"
в папке с автокадовским файлом должны лежать файлы excel
каждому файлу соответствует свой словарь в словаре #DB

например тут - файл ШК10.xlsx и словарь с именем "ШК10"
в словаре будут лежать записи - xrecords
переменная действующего словаря $tbl

(setq #cbnt10 (vla-AddObject #DB "ШК10" "AcDbDictionary"))


		правила создания имен запией

Xrecord "HEAD"
переменная $db:head
значение '("cabinet" "clamp" "cl1" "cl2" "relay" "sign_type" "KKS" "mark1" "mark2" "cbl_KKS" "event" "equipment" "meas_name" "элсх" "монтсх" "cab_type" "cores" "section" "place_field" "field_name")


$db:data - все записи с именами "rec*"
значение '("table" () () () ... $$rec)
	Xrecord "REC1"
	переменная $$rec
	значение'("ШК10.1Б" "1XT3" "1" "2" "1" "420AI+" "2FT350" "-1" "-2" "2UHA-4021" "" "" "Расход вторичного воздуха " "" "" "КВВГЭнг" "4" "1,5" "#КС" "СК-14")


еще наверное надо добавить запсись с настройками екселевской таблицы - на будующее
Xrecord "XLSETTINGS"
значение '("rowheight=15" "colwidth=20,20,20,15,35,..." ... и может еще дальше чего .. хз)


функции работы с словарем таблицы

бля... не могу больше

cont>list - преобразует контейнер в список

XD|names - дает список имен членов словаря

XD|getxrecord $tbl "name" = $$rec / nil
XD|getxrecdata $$rec - будет давать данные
??? XD|ask $tbl "name" 

XD|addxrecord $tbl "name" (val1 val2 val3 ...) - добавляет в словарь запись, если нет такого имени
XD|setxrecdata $$rec (val1 val2 val3 ...) - перезаписывает данные

XD|delxrecs $tbl '("name")











;(setq $db:head db:head)
;(setq $db:data db:data)







(XD|dictgetnames #DB) 


(XD|dictgetnames #cbnt10)


(XD|dictdivide #DB)

(XD|dictdivide #cbnt10)

















;(kd|setauthor (vlax-ename->vla-object (car (entsel))) "Подолинский Е. О.")
(defun kd|setauthor ( obj name / exd authXR)
  (setq exd (vla-GetExtensionDictionary obj))
  (if (null (member "author" (XD|dictgetnames exd)))
    (setq authXR (vla-AddXRecord exd "author"))
    (setq authXR (vla-item exd "author"))
    )
  (XD|setxrecdata authXR (list name))
  ;(XD|getxrecdata	 authXR)
  );defun



;(kd|getauthor (vlax-ename->vla-object (car (nentsel))))
;(kd|getauthor (vlax-ename->vla-object (car (entsel))))
(defun c:kd|getauthor ()(kd|getauthor (vlax-ename->vla-object (car (entsel)))))
(defun kd|getauthor ( obj / exd authXR)
  (if
    (and
      (= :vlax-true (vla-get-HasExtensionDictionary obj))
      (setq exd (vla-GetExtensionDictionary obj))
      (member "author" (XD|getnames exd))
      )
    (XD|getxrecdata (vla-item exd "author"))
    )
  );defun










(setq lst (ss->lsto* (ssget "_X")))



(setq fn
(lambda ( / ss lst)
  (if (not (setq ss (ssget "_I" '((0 . "INSERT"))))) (setq ss (ssget '((0 . "INSERT")))))
  (if ss (setq lst (ss->lsto* ss)))
  (mapcar '(lambda (x) (kd|setauthor x "Подолинский Е. О."))lst)
  )
      )

(setq fn
(lambda ( / ss lst)
  (if (not (setq ss (ssget "_I"))) (setq ss (ssget)))
  (if ss (setq lst (ss->lsto* ss)))
  (mapcar '(lambda (x) (kd|setauthor x "Подолинский Е. О."))lst)
  )
      )

(fn)




