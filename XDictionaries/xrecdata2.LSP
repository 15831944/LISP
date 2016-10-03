(load (strcat #lisppath "common functions\\kd-container-list.LSP"))

;;; читать dictXrecs.lsp

;; модель структуры

;; Dictionary (vla-get-Dictionaries #actdoc)
;; 	Dictionary   "KD_branches" 		- главный словарь веток (branches)
;;		Dictionary   "br00QCF72"  	- словарь ветка (branch)
;;		|	X-запись : "code"	("00QCF72")
;;		|	X-запись : "consist"	("handle1" "handle2" "handle3" ...)
;;		|	X-запись : "transmitter"("branch1" "branch2" ...)
;;		|	X-запись : "reciever" 	("branch3/hand" "branch4" ...)
;;		|	X-запись : "funcname" 	("Зажелезенный конденсат из производства на ВПУ")

;; добавить ! .... хммм... если добавить именно объект (для кабелей)
;;		|	X-запись : "INSERT" 	(#<VLA-OBJECT IAcadBlockReference2 16aebe24> )
;;; ;;;;;;;;;;;;;;;;;;;;;;;            ("HANDLE" !!!!!)


;; ща попробуем забить в поле данные из словаря расширенных данных


(vlax-ename->vla-object (car (entsel)))

(setq #kksdictname "KD_branches")
(setq dicts (vla-get-Dictionaries #actdoc))

(vlax-for dict dicts
  (if (vlax-property-available-p dict 'Name)
    (progn (princ "\n")
      (princ (vla-get-name dict))
      )
    )
  )

;;;(setq a 
;;;(vlax-for dict dicts
;;;  (if (vlax-property-available-p dict 'Name)
;;;    (vla-get-name dict)
;;;    )
;;;  )
;;;      )
;;;
;;;
;;;(setq a 
;;;(vlax-map-collection dicts '(lambda (x)
;;;			      (if (vlax-property-available-p x 'Name)
;;;				(vla-get-name x)
;;;				)
;;;			      )))
;;;(= a dicts) ; T


;(member (cons 3 "ACAD_GROUP") (entget (namedobjdict)))

;; если словарь уже есть то приявязываем его к переменной, если нет - то создаем новый
(if (member (cons 3 #kksdictname) (entget (namedobjdict)))
  (setq branches (vla-item dicts #kksdictname))
  (setq branches (vla-add dicts #kksdictname))
  )
;;имеем словарь с именем KD_branches

(setq curstr "00QCF72")
(setq сurbranch (vla-addobject branches (strcat "br" curstr) "acdbdictionary"))
;(defun addbranch)
(setq xr (vla-addxrecord сurbranch "code"))
;(defun addbranchparam)
(kd:setxrecdata xr (list curstr))
(kd:getxrecdata xr)

;; примем X-запись - как за параметр элемента, например

;; X-запись : "code" "00QCF72"
(setq xr (vla-addxrecord сurbranch "code"))
(kd:setxrecdata xr (list curstr))

;; X-запись : "consist" "handle1" "handle2" "handle3" ...
(setq xr (vla-addxrecord сurbranch "consist"))
(kd:setxrecdata xr (mapcar 'vla-get-Handle (ss->lsto* (ssget))))

;; X-запись : "transmitter" "branch1" "branch2" ...
;; X-запись : "reciever" "branch3" "branch4" ...
;; эти записи будут добавлены к словарю branch соответствующему данной ветке трубопровода
;(kd:setxrecdata xr '("ss" "asd" "a12ee"))

(do
  (vla-item (vla-item dicts #kksdictname) 0)
  )




;;;;; обобщим добавление ветки

;(setq kkscode "00QLCA11")
(defun br:add ( / kkscode branch xr lsto)
  (setq kkscode (getstring))
  
  ;(vla-item branches "br00QCF73")
  ;(vla-GetObject branches "br00QCF72")
  (setq branch (vla-addobject branches (strcat "br" kkscode) "AcDbDictionary"))
  
  (setq xr (vla-addxrecord branch "code"))
  (kd:setxrecdata xr (list kkscode))
  (setq xr (vla-addxrecord branch "consist"))
  (setq lsto (ss->lsto* (ssget)))
  (kd:setxrecdata xr (mapcar 'vla-get-Handle lsto))
  );defun

;(mapcar 'vla-get-name (kd-container->list branches))
;(mapcar 'vla-get-name (kd-container->list (vla-item branches 0)))

;(vla-item branches (kd:dcl:pick-from-list (mapcar 'vla-get-name (kd-container->list branches))))


;;; функция добавления параметра к branch
(defun br:addprop (branch tag str / xr)
  (setq xr (vla-addxrecord branch tag))
  (kd:setxrecdata xr str)
  );defun

(br:addprop
  (vla-item branches (kd:dcl:pick-from-list (mapcar 'vla-get-name (kd-container->list branches))))
  "funcname"
  '("Зажелезенный конденсат из производства на ВПУ")
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