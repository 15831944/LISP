
;; значения точек - или 220 или 0
;; значения состояния контактов- или "c" или "o" (clsed, opened)
;; значения активности элементов "a" "p" - active, passive
;; cA35 - вычисление точки A35 - присваивание значения A35
;; знчение состояния ключа  SA = "middle" "open" "close"



;;;
;;;
;;;(defun cA12 ()
;;;  (setq A11 (cA11))
;;;  (setq A12
;;;  (if (= A11 0)
;;;    0
;;;    (if
;;;      (or
;;;	(= "op" SA)
;;;	(= "c" KMC5354)
;;;	(= "c" KQ1314)
;;;	)
;;;      A11
;;;      0
;;;      )
;;;    )
;;;	)
;;;  );defun
;;;
;;;
;;;(defun cA14 ()
;;;  (setq A12 (cA12))
;;;  (setq A14
;;;	 (cond
;;;    ((= "c" KQ3132) A12)
;;;    ((= "o" KQ3132) 0)
;;;    )
;;;	)
;;;  )
;;;
;;;(defun cA15 ()
;;;  (setq A14 (cA14))
;;;  (setq A15 (cond
;;;    ((= "c" KMT3132) A14)
;;;    ((= "o" KMT3132) 0)
;;;    ))
;;;  )
;;;
;;;(defun cKMC ()
;;;  (setq A15 (cA15))
;;;  ((= 220 A15) (setq KMCAB "a" KMC3132 "o" KMC5354 "c" KMC1 "c"))
;;;  ((=   0 A15) (setq KMCAB "p" KMC3132 "c" KMC5354 "o" KMC1 "o"))
;;;  (T (exit))
;;;  )
;;;
;;;
;;;
;;;(defun cA22 ()
;;;  (setq A21 (cA21))
;;;  (setq A22
;;;  (if (= A21 0)
;;;    0
;;;    (if
;;;      (or
;;;	(= "cl" SA)
;;;	(= "c" KMT5354)
;;;	(= "c" KQ2324)
;;;	)
;;;      A21
;;;      0
;;;      )
;;;    ))
;;;  );defun
;;;
;;;(defun cA24 ()
;;;  (setq A22 (cA22))
;;;  (setq A24
;;;	 (cond
;;;    ((= "c" KQ4142) A22)
;;;    ((= "o" KQ4142) 0)
;;;    ))
;;;  )
;;;
;;;(defun cA25 ()
;;;  (setq A24 (cA24))
;;;  (setq A25
;;;	 (cond
;;;    ((= "c" KMC3132) A24)
;;;    ((= "o" KMC3132) 0)
;;;    ))
;;;  )
;;;
;;;(defun cKMT ()
;;;  (setq A25 (cA25))
;;;  ((= 220 A25) (setq KMTAB "a" KMT3132 "o" KMT5354 "c" KMT1 "c"))
;;;  ((=   0 A25) (setq KMTAB "p" KMT3132 "c" KMT5354 "o" KMT1 "o"))
;;;  (T (exit))
;;;  )
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;(defun cA35 ()
;;;  (setq A35
;;;  (cond
;;;    ((= "cl" SA) (setq A12 (cA12)) (setq A35 A12))
;;;    ((= "op" SA) (setq A22 (cA22)) (setq A35 A22))
;;;    (T (setq A35 0))
;;;    ))
;;;  )
;;;
;;;
;;;
;;;
;;;
;;;(defun cKQ ()
;;;  (setq A35 (cA35))
;;;  (cond
;;;    ((= 220 A35) (setq KQAB "a" KQ1314 "c" KQ2324 "c" KQ3132 "o" KQ4142 "o") (princ))
;;;    ((=   0 A35) (setq KQAB "p" KQ1314 "o" KQ2324 "o" KQ3132 "c" KQ4142 "c") (princ))
;;;    (T (exit))
;;;    )
;;;  )
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;(defun cA11 ()
;;;  (setq A10 220)
;;;  (cM)
;;;  (setq A11
;;;  (cond
;;;    ((= "c" SQ12) A10)
;;;    ((= "o" SQ12) 0)
;;;    ))
;;;  )
;;;
;;;(defun cA21 ()
;;;  (setq A10 220)
;;;  (cM)
;;;  (setq A21
;;;	 (cond
;;;    ((= "c" SQ1314) A10)
;;;    ((= "o" SQ1314) 0)
;;;    ))
;;;  )
;;;
;;;
;;;
;;;
;;;
;;;
;;;(defun cA51 ()
;;;  (setq A10 220)
;;;  (cM)
;;;  (setq A51
;;;	 (cond
;;;    ((= "c" SQ34) A10)
;;;    ((= "o" SQ34) 0)
;;;    ))
;;;  )
;;;(defun cA61 ()
;;;  (setq A10 220)
;;;  (cM)
;;;  (setq A61 (cond
;;;    ((= "c" SQ1516) A10)
;;;    ((= "o" SQ1516) 0)
;;;    ))
;;;  )
;;;(defun cA52 ()
;;;  (setq A51 (cA51))
;;;  (setq A52 A51)
;;;  )
;;;(defun cA62 ()
;;;  (setq A61 (cA61))
;;;  (setq A62 A61)
;;;  )
;;;
;;;
;;;
;;;
;;;
;;;
;;;;(setq M "open")
;;;;(setq M "clo")
;;;;(setq M "mid")
;;;(defun cM ()
;;;  (cond
;;;    ((= M "open") (setq SQ12 "o" SQ34 "c" SQ1314 "c" SQ1516 nil))
;;;    ((= M "mid") (setq SQ12 "c" SQ34 "o" SQ1314 "c" SQ1516 nil))
;;;    ((= M "clo") (setq SQ12 "c" SQ34 "o" SQ1314 "o" SQ1516 T))
;;;    )
;;;  );defun
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(setq M "clo")
;;;(setq SA "mid")
;;;
;;;(cA11)
;;;(cA12)
;;;
;;;(cA21)
;;;(cA22)
;;;
;;;(cA35)
;;;
;;;(cKQ)
;;;
;;;(mapcar
;;;  '(lambda (x)
;;;     (setq (read x) nil)
;;;     )
;;;  '("A10" "A11" "A21" "A51" "A61" "A52" "A62" "A12" "A22" "A14" "A24" "A15" "A25" "A35"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;(setq M "clo")
;;;(setq SA "op")
;;;
;;;(cA11)
;;;(cA12)
;;;
;;;(cA21)
;;;(cA22)
;;;
;;;(cA35)
;;;
;;;(cKQ)
;;;
;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq dicts (vla-get-Dictionaries #actdoc))


;*********************************************************************************
(defun kd:setXRECdata (xrec val / sa1 sa2)
  (if (listp val)
    (progn
      (setq sa1 (vlax-safearray-fill
		  (vlax-make-safearray vlax-vbInteger (cons 0  (1- (length val))))
		  (mapcar
		    '(lambda (x)
		       (cond
			 ((= (type x) 'STR) 301)
			 ((= (type x) 'INT) 451)
			 ((= (type x) 'REAL) 140))) val)))
      (setq sa2 (vlax-safearray-fill (vlax-make-safearray vlax-vbvariant (cons 0 (1- (length val)))) val))
      (vla-SetXRecordData xrec sa1 sa2))
    (princ "\nkd:setxrecdata : value must be a list"))
  );defun
;*********************************************************************************
;(kd:getxrecdata xr)
(defun kd:getXRECdata (xrec / sa1 sa2)
  (vla-getXrecordData xrec 'sa1 'sa2)
  (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
  );defun
;*********************************************************************************

;*********************************************************************************
(defun kd:putXdata (obj tag val / sa1 sa2)
  (setq sa1 (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 1)) (list 1001 1000)))
  (setq sa2 (vlax-safearray-fill (vlax-make-safearray vlax-vbvariant '(0 . 1)) (list tag val)))
  (vla-SetXData obj sa1 sa2)
  )
(defun kd:getXdata (obj tag / sa1 sa2)
  (vla-GetXData obj tag 'sa1 'sa2)
  (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
  )
;*********************************************************************************


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(setq
;;;  lst
;;;   (vl-remove-if-not
;;;     '(lambda (x) (= "node" (vla-get-effectivename x)))
;;;     (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
;;;     )
;;;  )
;;;
;;;(mapcar '(lambda (x) (vla-get-textstring (getbatt x "ID"))) lst)
;;;;("A11" "A10" "A1" "A12" "A14" "A15" "N" "A52" "A62" "A51" "A61" "A35" "A22" "A21") 




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Условности для данного файла
;; 1. Есть элементы схемы - ключи, лоампочки, концевики, моторы и т.д.
;; 2. Есть блоки "node" - узлы схемы
;; 3. Словари :
;; 	KD_raschet-shemy (KD-POTENCIALS)
;;		
;;	KD-ELFUNCTIONS
;;	KD_contacts (пока вопрос о его надобности)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq sch:dictname "KD-POTENCIALS")
(setq #dict (vla-add dicts sch:dictname))

;;;  добавляет запись в словарь KD_raschet-shemy(KD-POTENCIALS) с названием "A10" содержащую Hand блока node и значение (220, 0, "N"(?) - для node и (?) "c", "o" - для элементов)
(defun sch:setpotencial (obj val)
  (kd:setxrecdata (vla-addxrecord #dict (vla-get-TextString (getbatt obj "ID"))) (list (vla-get-Handle obj) val))
  (kd:putXdata obj sch:dictname (vla-get-Handle (vla-item #dict (vla-get-TextString (getbatt obj "ID")))))
  val
  )
;(kd:getxrecdata (vla-HandleToObject #actdoc (cadr (kd:getXdata (vlax-ename->vla-object (car (entsel))) sch:dictname))))
;(kd:getxrecdata (vla-item #dict "A10"))
(defun sch:getpotencial (obj)
  (cadr (kd:getxrecdata (vla-HandleToObject #actdoc (cadr (kd:getXdata obj sch:dictname)))))
  )
;(sch:setpotencial (vlax-ename->vla-object (car (entsel))) "c")
;(sch:getpotencial (vlax-ename->vla-object (car (entsel))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;           N O D E S           ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; узлы схемы
(setq #nodes (vl-remove-if-not '(lambda (x) (= "node" (vla-get-effectivename x))) (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))))
;(mapcar '(lambda (x) (vla-get-textstring (getbatt x "ID"))) #nodes)
;("A11" "A10" "A12" "A14" "A15" "N" "A52" "A62" "A51" "A61" "A35" "A22" "A21")
(mapcar 'sch:getpotencial #nodes)

;;; очистка потенциалов
(mapcar '(lambda (x) (sch:setpotencial x nil)) #nodes)
(sch:setpotencial (vlax-ename->vla-object (car (entsel))) "220")
;(sch:getpotencial (vlax-ename->vla-object (car (entsel))))
(sch:setpotencial (vlax-ename->vla-object (car (entsel))) "N")
;(sch:getpotencial (vlax-ename->vla-object (car (entsel))))


(defun sch:gnode (str / lst)
  (setq lst (vl-remove-if-not '(lambda (x) (= str (vla-get-TextString (getbatt x "ID")))) #nodes))
  (if (= 1 (length lst))
    (car lst)
    (exit)
    )
  );defun
;(sch:gnode "A12")

(defun sch:gnbxr (str / obj val)	;;;;; get node by (from) Xrecord
  ;(setq str "A11")
  ;(vla-item dicts "KD-POTENCIALS")
  (setq obj (kd:getxrecdata (vla-item (vla-item dicts "KD_raschet-shemy") str)))
  (setq val (cadr obj))
  (setq obj (vla-HandleToObject #actdoc (car obj)))
  ;(do obj)
  );defun





;;;(defun sch:pcalc ("A35")
;;;  (if (= "" (sch:getpotencial (sch:gnode "A12"))) (shc:pcalc "A12"))
;;;  (sch:setpotencial "A35"
;;;    (cond
;;;      ((= (SA "6" "8" ) "closed") (if (= "" )) (sch:getpotencial (sch:gnode "A12")))
;;;      ((= (SA "5" "7" ) "closed") (sch:getpotencial (sch:gnode "A22")))
;;;      (T "0")
;;;      )
;;;    )
;;;  )



;(kd:setxrecdata (vla-addxrecord #dict (vla-get-TextString (getbatt obj "ID"))) (list (vla-get-Handle obj) val))












































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(vla-get-TextString
;;;(getbatt
;;;  (vla-HandleToObject #actdoc (vla-get-name
;;;				;(kd:getxrecdata
;;;				(vla-item (vla-item dicts "KD-connections") 1)
;;;				;)
;;;				))
;;;  "ID"
;;;  ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; информация об подключении - собситвенно - модель схемы
(setq #DDname  "KD-connections")  ;;;  DATA DICT name
(setq #DD (vla-add dicts #DDname))


(defun sch:nodeconnect (/ nodeobj lst xr item)
  (setq nodeobj (vlax-ename->vla-object (car (entsel))))
  (setq lst nil)
  (while (setq item (nentsel))
    (setq lst (append lst (list (vlax-ename->vla-object (car item)))))
    )
  (kd:setxrecdata (setq xr (vla-addxrecord #DD (vla-get-Handle nodeobj))) (mapcar 'vla-get-handle lst))
  (kd:putXdata nodeobj (vla-get-name #DD) (vla-get-Handle xr))
  (mapcar '(lambda (x) (kd:putXdata x (vla-get-name #DD) (vla-get-Handle xr))) lst)

  (princ (apply 'strcat (append (list "прконнектили - к " "Node " (vla-get-TextString (getbatt (vla-HandleToObject #actdoc (vla-get-name xr)) "ID")) " элементы " )
    (mapcar '(lambda (x) (strcat (vla-get-TextString (getbatt (vla-ObjectIDToObject #actdoc (vla-get-OwnerID (vla-HandleToObject #actdoc x))) "CODE")) ":"
       (vla-get-TextString (vla-HandleToObject #actdoc x)) ", ")) (kd:getxrecdata xr)) (list "...  ")))
	 )
  );defun
;;;; подучается у xr - название - хендл объекта "node", а занчение - список аттрибутов(контактов) присоединенных элементов

(sch:nodeconnect)
(vla-get-Count (vla-item dicts "KD-connections"))
(length #nodes)
(vlax-for it (vla-item dicts "KD-connections") (princ (strcat "\n" (vla-get-name it))))
(mapcar 'vla-get-Handle #nodes)
(vla-HandleToObject #actdoc "1202")
;(vla-get-name (vla-item #DD 6))
;(vla-delete (vla-item #DD 6))

;;; проверка от контакта
;(kd:getxrecdata (vla-HandleToObject #actdoc (cadr (kd:getXdata (vlax-ename->vla-object (car (nentsel))) #DDname))))
(vla-get-TextString (getbatt (vla-HandleToObject #actdoc (vla-get-name (vla-HandleToObject #actdoc (cadr (kd:getXdata (vlax-ename->vla-object (car (nentsel))) #DDname))))) "ID"))
;;; проверка от NODE
(mapcar '(lambda (x) (strcat (vla-get-TextString (getbatt (vla-ObjectIDToObject #actdoc (vla-get-OwnerID (vla-HandleToObject #actdoc x))) "CODE")) ":"
       (vla-get-TextString (vla-HandleToObject #actdoc x)) ", ")) (kd:getxrecdata (vla-HandleToObject #actdoc (cadr (kd:getXdata (vlax-ename->vla-object (car (entsel))) #DDname)))))
;(setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata (vlax-ename->vla-object (car (entsel))) #DDname))))
;(vla-get-name xr)
;(kd:getxrecdata xr)







(setq #Dfuncname  "KD-ELFUNCTIONS")  ;;;  DICT functions name
(setq #DF (vla-add dicts #Dfuncname))

;;;  добавить в x-запись саму функцию вычисления потенциала контакта именно "(if .. и т.д.)"
;;;  чтбы потом делать (eval (read ...))

(setq obj (vlax-ename->vla-object (car (entsel))))

;;;; node : 
(vla-HandleToObject #actdoc (vla-get-name (vla-HandleToObject #actdoc (cadr (kd:getXdata (vlax-ename->vla-object (car (nentsel))) #DDname)))))
















(defun parelist (lst / tmp i)
  ;(setq lst '(123 "23" 33 431.1 "3fff" asd))
  (= (gcd (setq i (length lst)) 2) 2)   ;;;  проверка на четность
  (while (>= i 2)
    (setq tmp (append tmp (list (list (nth (- i 2) lst) (nth (1- i) lst)))))
    (setq i (- i 2))
    )
  (reverse tmp)
  )




(defun transform (lst)
  (apply 'mapcar (append '(list) lst))
  );defun






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq #DDname  "KD_contacts")  ;;;  DATA DICT name
(setq #DD (vla-add dicts #DDname))



;;;; SQ1
(setq obj (vlax-ename->vla-object (car (nentsel))))
;;; имя x-записи
(setq XRname (strcat (vla-get-TextString (getbatt obj "CODE")) "-" (vla-get-TextString (getbatt obj "PIN1"))))



(kd:setxrecdata (setq xr (vla-addxrecord #DD (vla-get-Handle obj))) lst)
(kd:putXdata obj (vla-get-name #DD) (vla-get-Handle xr))


(setq xr (vla-addxrecord #DD (vla-get-Handle obj)))
















;;  13_09_12


;; надо бы это все перелопатить.... н оч разумно сделано
;;  итак....
;; составляющие схемы:
;; узлы (nodes) и элементы : исполнительные и причинные
;; словарь
;; "KDEL-STATE"
;; состояние узлов : "220" - есть потенциал, "0" - нет потенциала, "N" - на всякий случай нейтраль, "#" - неопределен
;; состояние элементов "active", "passive", "open", "close", "middle", "closed", "opened"

;; словарь
;; KDEL-CONNECTIONS - вроде бы составлен неплохо
;; в словаре - X-rec с именеи handle of node-obj, значение - список handle`ов аттрибутов (PIN#) блоков (ключ, ...) - контактов
;; к элементам добавляется X-data с названием словаря и handle`ом на эту X-rec
;;         в обзем случае, (см. "vlave logic.dwg")
;;	если представить тчку соединения например A22
;;	которая соединяет аттрибуты блоков KQ1:24, SA1:4, KMT1:54, KQ1:41, SA1:5
;;	можно описать это ассоциативным списком
;;      (A22             KQ1:24    SA1:4     KMT1:54   KQ1:41    SA1:5) , или в объектном представлении
;;	(node-obj       att-obj1  att-obj2  att-obj3  att-obj4  att-obj5), или в представлении хендлов
;;	("1243"		"108F"     "FBD"     "100B"     "10A6"    "1062")
;; тогда можно попробывать написать обзую функцию для таких данных

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq sch:cnct:data (list
     (vlax-ename->vla-object (car (entsel))) ;; - node
     (vlax-ename->vla-object (car (nentsel))) ;; - pin1
     (vlax-ename->vla-object (car (nentsel))) ;; - pin2
     (vlax-ename->vla-object (car (nentsel))) ;; - pin3
     (vlax-ename->vla-object (car (nentsel))) ;; - pin4
     (vlax-ename->vla-object (car (nentsel))) ;; - pin5
     ))
;;;'(#<VLA-OBJECT IAcadBlockReference 17561684>
;;;  #<VLA-OBJECT IAcadAttributeReference 176db94c>
;;;  #<VLA-OBJECT IAcadAttributeReference 176dbc44>
;;;  #<VLA-OBJECT IAcadAttributeReference 176dbe0c>
;;;  #<VLA-OBJECT IAcadAttributeReference 176dbfd4>
;;;  #<VLA-OBJECT IAcadAttributeReference 176dc19c>)

;(mapcar 'vla-get-Handle sch:cnct:data)
;("1243" "108F" "FBD" "100B" "10A6" "1062")

(setq sch:cnct:dn "KDEL-CONNECTIONS")		;; dict name
;(DICTSEARCH (namedobjdict) "KD-connections")
;(DICTSEARCH (namedobjdict) "KDEL-CONNECTIONS")
;(setq dict (vlax-ename->vla-object (cdr (assoc -1 (DICTSEARCH (namedobjdict) sch:cnct:dn)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:adddata (sch:cnct:dn sch:cnct:data / datalst dict xr)
  (if (DICTSEARCH (namedobjdict) sch:cnct:dn) (setq dict (vla-item dicts sch:cnct:dn)) (setq dict (vla-add dicts sch:cnct:dn)))
  (setq datalst (mapcar 'vla-get-Handle sch:cnct:data))
  ;; 1 - Xrec
  (kd:setxrecdata (setq xr (vla-addxrecord dict (car datalst))) (cdr datalst))
  ;; 2 - Xdata
  (mapcar '(lambda (x) (kd:putXdata x sch:cnct:dn (vla-get-Handle xr))) sch:cnct:data)
  (sch:cnct:reply xr)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:man:gendata ( / nodeobj lst item)
  (setq nodeobj (car (entsel "\nSelect a node.. : ")))
  (setq lst nil)
  (while (setq item (nentsel "\nSelect the NEXT attribute... : ")) (setq lst (append lst (list (car item)))))
  (mapcar 'vlax-ename->vla-object (append (list nodeobj) lst))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (sch:cnct:adddata    sch:cnct:dn     (sch:cnct:man:gendata))
; (sch:cnct:adddata "KDEL-CONNECTIONS" (sch:cnct:man:gendata))
; (vla-get-TextString (getbatt (vla-HandleToObject #actdoc (vla-get-name (vla-item dict 1))) "ID"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:xr>list (xr)
  (mapcar '(lambda (x) (vla-HandleToObject #actdoc x)) (append (list (vla-get-name xr)) (kd:getxrecdata xr)))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;old
;;;(defun sch:cnct:reply (xr)
;;;  (princ (apply 'strcat (append (list "\n\nпрконнектили - к " "Node " (vla-get-TextString (getbatt (vla-HandleToObject #actdoc (vla-get-name xr)) "ID")) " элементы " )
;;;    (mapcar '(lambda (x) (strcat (vla-get-TextString (getbatt (vla-ObjectIDToObject #actdoc (vla-get-OwnerID (vla-HandleToObject #actdoc x))) "CODE")) ":"
;;;       (vla-get-TextString (vla-HandleToObject #actdoc x)) ", ")) (kd:getxrecdata xr)) (list "...  "))))
;;;  );defun
(defun sch:cnct:reply (xr / lst)
  (setq lst (sch:cnct:xr>list xr))
  (princ (apply 'strcat (append (list "\n\nпрконнектили - к " "Node " (vla-get-TextString (getbatt (car lst) "ID")) " элементы " ) (mapcar '(lambda (x) (strcat (vla-get-TextString (getbatt (vla-ObjectIDToObject #actdoc (vla-get-OwnerID x)) "CODE")) ":" (vla-get-TextString x) ", ")) (cdr lst)) (list "...  "))))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:genadrstr (attobj / )  ;; generate address (SQ1:1) from #<VLA-OBJECT IAcadAttributeReference 176dbfd4>
  ;(setq attobj (nth 1 lst))
  (strcat (vla-get-TextString (getbatt (vla-ObjectIDToObject #actdoc (vla-get-OwnerID attobj)) "CODE")) ":" (vla-get-TextString attobj))
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; вот это уже похоже на шедевр ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:getdata ( / sel xr lst choice)
  (if (setq nsel (nentsel))
    (setq sel (vlax-ename->vla-object (car nsel)))
    (exit)
    )
  (cond
    ((= (vla-get-ObjectName sel) "AcDbAttribute")
     (cond
       ((wcmatch (vla-get-TagString sel) "ID")  (setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata (vla-ObjectIDToObject #actdoc (vla-get-OwnerID sel)) sch:cnct:dn)))))
       ((wcmatch (vla-get-TagString sel) "PIN*")(setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata sel sch:cnct:dn)))))
       ((wcmatch (vla-get-TagString sel) "CODE")(setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata (progn (setq lst (getbattswcmatch (vla-ObjectIDToObject #actdoc (vla-get-OwnerID sel)) "*PIN*")) (setq choice (kd:dcl:pick-from-list (mapcar 'vla-get-TagString lst))) (car (vl-remove-if-not '(lambda (x) (= choice (vla-get-TagString x))) lst ))) sch:cnct:dn )))))
       ))
    (T
     (setq sel (vlax-ename->vla-object (caar (reverse nsel))))
     (cond
       ((= "node" (vla-get-EffectiveName sel))(setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata sel sch:cnct:dn)))))
       (T (setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata (progn (setq lst (getbattswcmatch sel "*PIN*")) (setq choice (kd:dcl:pick-from-list (mapcar 'vla-get-TagString lst))) (car (vl-remove-if-not '(lambda (x) (= choice (vla-get-TagString x))) lst ))) sch:cnct:dn)))))
       )
     )
    );cond
  ;(sch:cnct:xr>list xr)
  xr
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:fulldelete1connection ( / cnctdata xr)
  (setq cnctdata (sch:cnct:getdata))
  (vla-delete (vla-HandleToObject #actdoc (cadr (kd:getXdata (car cnctdata) sch:cnct:dn))))
  (mapcar '(lambda (x) (kd:putXdata x sch:cnct:dn nil)) cnctdata)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(sch:cnct:fulldelete1connection)
;(DICTSEARCH (namedobjdict) sch:cnct:dn)
;(do (vlax-ename->vla-object (cdr (assoc -1 (DICTSEARCH (namedobjdict) sch:cnct:dn)))))
;(sch:cnct:adddata    sch:cnct:dn     (sch:cnct:man:gendata))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sch:cnct:dcleditconnections (lst
				    /
				    xr
				    dclpath
				    dclans
				    dcl_id

				    )
  (setq dclans lst)
  (setq dclpath (strcat (getenv "temp") "\\sch_cnct_dcleditconnections.dcl"))
  ;;;--------------------------------------------------------------------
  ;;;--------------------------------------------------------------------
  ;;;--------------------------------------------------------------------
  ;;;--------------------------------------------------------------------
  (defun sch:cnct:dclgendclfile (lst / dclhand dclstrlist dcli)
    (setq dclstrlist (list
       "kd_sch_cnct_dcleditconnections : dialog"
       "{ label=\"kakt00z dcl sch:cnct edit connections\";"
       ":row {"
       		":text{label=\"Node\";}"
       		(strcat ":text{label=\"" (vla-get-TextString (getbatt (car lst) "ID")) "\";}")
       		"}"
       ))
    (setq dcli 1)
    (repeat (1- (length lst))
      (setq dclstrlist
       (append
	 dclstrlist
	 (list
	   ":row {"
	   	(strcat ":text{label=\"" "Connection" (itoa dcli) "\";width=15;}")
	   	(strcat ":text{label=\"" (sch:cnct:genadrstr (nth dcli lst)) "\";width=15;}")
		(strcat ":button{label=\"replace\";key=\"" "cnrepbtn" (itoa dcli) "\";width=20;action=\"(progn (done_dialog) (unload_dialog dcl_id) (bntrepclicked " (itoa dcli) ")(sch:cnct:dclstartdialog) (done_dialog) (unload_dialog dcl_id))\";}")
	   	(strcat ":button{label=\"remove\";key=\"" "cnrembtn" (itoa dcli) "\";width=20;action=\"(progn (done_dialog) (unload_dialog dcl_id) (bntremclicked " (itoa dcli) ")(sch:cnct:dclstartdialog) (done_dialog) (unload_dialog dcl_id))\";}")
	   	"}"
	   )
	 )
      )
    (setq dcli (1+ dcli))
    )


  (setq dclstrlist (append dclstrlist (list
					":spacer{width=3;}"
					"ok_button;"
					"}"
					)))
    (setq dclhand (open dclpath "w"))
    (mapcar '(lambda (x) (write-line x dclhand)) dclstrlist)
    (close dclhand)
    dclpath
    );defun sch:cnct:dclgendclfile
  ;;;--------------------------------------------------------------------
  ;;;--------------------------------------------------------------------
  ;;;--------------------------------------------------------------------
  ;;;--------------------------------------------------------------------


  



  (setq dclans (sch:cnct:xr>list (sch:cnct:getdata)))
  ;(mapcar 'sch:cnct:genadrstr (cdr dclans))
  (sch:cnct:dclgendclfile dclans)



  
;;;  (defun sch:cnct:dclstartdialog ()
;;;    (if (or (< (setq dcl_id (load_dialog dclpath))0) (not (new_dialog "kd_sch_cnct_dcleditconnections" dcl_id))) (exit)
;;;      (progn (start_dialog) (action_tile "accept" "(progn (done_dialog) (unload_dialog dcl_id))")))
;;;    )

  (defun bntremclicked (n / remitem)
    ;(done_dialog)
    ;(unload_dialog dcl_id)
    (setq remitem (nth n dclans))
    ;(kd:putXdata remitem sch:cnct:dn nil)
    (setq dclans (vl-remove remitem dclans))
    ;(sch:cnct:adddata sch:cnct:dn dclans)
    (sch:cnct:dclgendclfile dclans)
    ;(sch:cnct:dclstartdialog)
    )


  (defun sch:cnct:dclstartdialog ()
    (if (or
	  (< (setq dcl_id (load_dialog dclpath))0)
	  (not (new_dialog "kd_sch_cnct_dcleditconnections" dcl_id))
	  )
      (exit)
      (progn (start_dialog) (action_tile "accept" "(progn (done_dialog))") (unload_dialog dcl_id))
      )
    );defun




  (sch:cnct:dclstartdialog)



  (setq xr (vla-HandleToObject #actdoc (cadr (kd:getXdata (car lst) sch:cnct:dn))))
  
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(vla-get-Handle (vlax-ename->vla-object (car (entsel))))