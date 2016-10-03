;;;нужно создать словарь в общем словаре
;;;и
;;;создать словарь расширений у объекта с тем же именем (словаря)
;;;и посмотреть сходятся ли они
;;;
;;;нет
;;;...
;;;надо создвать словарь в общем словаре например с названием "кабели",
;;;а в словарь расширенных данных конкретных вхождений этого кабеля (объектов) (блока на трассах, подключениях и в кабельном журнале)
;;;уже прикручивать именно этот СЛОВАРЬ "кабели"
;;;12_12_21 и не словарь, а запись из этого словаря т.е. не саму запись, ее номер или индентификатор - о! хендл записи
;;;
;;;таким образом, при доступе к словарю "кабели" из общего словаря, и из словаря расширенных данных объекта
;;;мы должны получить один и тот же объект - запись из словаря "кабели"


;; 14_02_25 поддерживаю идею
; http://forum.dwg.ru/showthread.php?p=1232870#post1232870

;    в принципе, не нужно хранить переменные с названем словарей, до них можно добраться из самих словарей

;; маленький тетинг

(setq dicts (vla-get-Dictionaries #actdoc))
;;;(do dicts)
;;;(vlax-map-Collection
;;;  dicts
;;;  '(lambda (x) (princ (strcat "\n"
;;;			      (if (vlax-property-available-p x "Name")
;;;				(vla-get-name x)
;;;				(vla-get-ObjectName x)
;;;				)
;;;			      )))
;;;  )
;;;(do (vla-item dicts 3))
;;;(vla-item dicts "AcDbFieldList")

;;;(entget (namedobjdict))
;;;(do (vlax-ename->vla-object  (namedobjdict)))


(setq dbdictname "kd_testdict")
(setq #dbdict (vla-add dicts dbdictname))
(do #dbdict)


(setq dbdictnamechild "kd_testdictchild")
(setq #dbdictchild (vla-addobject #dbdict dbdictnamechild "acdbDictionary"))

;    в принципе, не нужно хранить переменные с названем словарей, до них можно добраться из самих словарей
;(vla-GetObject #dbdict dbdictnamechild)
;(vla-item #dbdict dbdictnamechild)
;(vla-GetName #dbdict #dbdictchild)


(setq tdn "kd_testdictchild1")	; test dict name
(setq testdct (vla-addobject #dbdict tdn "acdbdictionary"))
(vla-item #dbdict tdn)
(do testdct)


;;; получилась структура

;;;  kd_testdict :                        
;;;	        [                         
;;;              kd_testdictchild         
;;;              signals                  
;;;                ]                      

;; предполагаемые функции

xdb:addDictionary
добавить словарь [создать папку в папке], если такового не существует [если сущ.-то варианты синхронизации внутренних данных]
xdb:addXrecord
добавить запись [создать файл в папке], если такового не существует [если есть-то варианты изменить/нет/дополнить(синхронизировать)]
	подфункции
	kd:setxrecdata
	kd:getxrecdata

(vla-put-textstring
  (getblockattribute "syncHandle")
  (vla-get-Handle [xrecord])
  )




;(setq xr (vla-addxrecord testdct "head"))
;(kd:setxrecdata (vla-item testdct "head") '("KKS" "func" "description" "type"))
;(kd:getxrecdata (vla-item testdct "head"))
;(vla-delete (vla-item testdct "head"))
(setq $xrec (vla-addxrecord testdct "head")))
(kd:setxrecdata
  $xrec
  '("KKS" "func" "description" "type")
  )

;(kd:addxrec testdct '("10LBA11CP001" "PT" "Давление пара за котлом" "420AI"))
(mapcar
  '(lambda (x)
     (kd:addxrec testdct x)
     )
  '(
    ("10LBA11CP001" "PT" "Давление пара за котлом" "420AI")
    ("LAA10CL003" "dptL" "Уровень в деаэраторе питательной воды" "420AI")
    ("GAC11CP503" "PI" "Давление на напоре насоса сырой воды GAC11AP001" "пм")
    ("LAB90CT001" "TT" "Температура охлаждающей воды на РОУ 1" "Pt100")
    )
  )



(defun kd:addxrec (dict data / xr)
  ;(setq dict testdct)
  ;(setq data '("10LBA11CP001" "PT" "Давление пара за котлом" "420AI"))
  (if (memberc (car data) dict)
    (progn
      (setq xr (vla-addxrecord dict (car data)))
      (kd:setxrecdata xr data)
      )
    (princ (strcat "\n" " XRecord \"" (car data) "\" уже присутствует в словаре \"" (vla-get-name dict) "\""))
    )
  )







(defun memberc (str dict)
  (member str (mapcar 'vla-get-name (KD-CONTAINER->LIST dict)))
  )
;*********************************************************************************
(defun kd:setxrecdata (xrec val / sa1 sa2)
  (if (listp val)
    (progn
      (setq sa1 (vlax-safearray-fill
		  (vlax-make-safearray vlax-vbInteger (cons 0  (1- (length val))))
		  (mapcar '(lambda (x) (cond
			       ((= (type x) 'STR) 301)
			       ((= (type x) 'INT) 451)
			       ((= (type x) 'REAL) 140)
			       )
			     ) val)))
      (setq sa2 (vlax-safearray-fill
		(vlax-make-safearray vlax-vbvariant (cons 0 (1- (length val))))
		val))
      (vla-SetXRecordData xrec sa1 sa2)
      )
    (princ "\nkd:setxrecdata : value must be a list")
    )
  );defun
;*********************************************************************************
;(kd:getxrecdata xr)
(defun kd:getxrecdata (xrec / sa1 sa2)
  (vla-getXrecordData xrec 'sa1 'sa2)
  (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
  );defun
;*********************************************************************************





(setq curstr "00QCF72")
(setq сurbranch (vla-addobject branches (strcat "br" curstr) "acdbdictionary"))
;(defun addbranch)
(setq xr (vla-addxrecord сurbranch "code"))
;(defun addbranchparam)
(kd:setxrecdata xr (list curstr))
(kd:getxrecdata xr)








(defun cdo (obj)
  (vlax-for i obj
    (princ (strcat "\n"(vla-get-name i))
	   )
    )
  )