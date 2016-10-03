;14_05_06
(vl-load-com)
(setq #cad (vlax-get-acad-object)
      #actdoc (vla-get-activedocument #cad)
      #modspace (vla-get-modelspace #actdoc))
(setq
  #blockarrowpaths
   (list
     (list "podolinsky" (strcat #lisppath "!blocking\\arrow.dwg"))
     (list (getenv "USERNAME") "\\\\srv-energo\\acad\\\\!_Стандарт\\Blocks\\arrow.dwg")
     )
  )
(setq comp (getenv "USERNAME"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;		ИНСТРУКЦИЯ
;1. открой новый чертеж
;2. открой редактор лисп :
;	Инструменты->AutoLISP->редактор LISP
;3. открой присланный [этот] файл
;4. почиай нескорлько первых строк с комментариями, пойми что они означают
;5. запусти файл : [в редакторе LISP]
;	Сервис (Tools) - загрузить текст в редактор (Load text in editor)
;6. программа попросит указать точку в чертеже, в которую она вставит график
;6.1 при первом запуске будут подгружаться из сети блоки - это займет порядка 10 секунд
;7. будут построены несколько графиков , они описаны
;8. можно поварьировать числами в верхних строчках файла, запуская программу повторно (см. пп. 5,6)
;8.1 рекомендую строить следующий график горизонтально рядом с предыдущим, указывая точку вставки на одной оси Х 
;	- это дает возможность сравнить 2 гафика по значениям рисуя горизонтальные линии




;	ИСХОДНЫЕ ДАННЫЕ : есть 2 вклада - 1 в белорусских, 2 - в долларах
;	если какого -либо вклада нет (храним под подушкой) - то
;	в соответствующих переменных ниже : %BLRdeposit или %USDdeposit ставим 0
;	распределение между вкладами управляет переменная %bel - какая часть общего капитала хранится в бел. вкладе

;	ниже в программе есть параметр transaction = 60 000 = предполагаемая ежемесяцная выплата



;;   ВСЕГО РАСПОЛОГАЕМЫХ СРЕДСТВ
(setq totalcapital 340000000.0) ; бел руб

;;  доля ОТ ВСЕГО хранения на вкладе в белках
;(setq %bel 0.9)
;(setq %bel (/ (* (- (/ totalcapital 10000) 10000) 10000) totalcapital) )
(setq %bel 0.01)


;курс валют на 14_04_20
(setq startBLR/USD 9980.0)
(setq rostBLR/USD 3.5)		; ПРОГНОЗ прирост курса доллара - бел. руб. в день
;пересчет по %bel в бел счет
(setq startBLRcapital (* totalcapital %bel))
;пересчет по %bel в USD счет по курсу
(setq startUSDcapital (/ (* totalcapital (- 1 %bel)) startBLR/USD))


;;  проценты по депозитам
(setq %BLRdeposit 38.0)	; % годовых
(setq %USDdeposit 5.5)	; % годовых


;;  расчетный период	[<шаг> 	<первый-день> 	<последний-день>]
(setq Xrange '(		1 	1 		90)) ; day	= 3 месяца
;; PS так как на моих вкладах пересчет идет каждый день, то итерация - шаг = 1 день
















;(setq square 93.8)
;(setq cost/M 10826794)
;(setq totalcost)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun calculate (Xrange
		  /
		  date
		  $cBLR/USD
		  $cUSDcap $cBLRcap
		  $cBLRcap/USD
		  $summUSD
		  transaction
		  res
		  )
  (setq $cUSDcap startUSDcapital)
  (setq $cBLRcap startBLRcapital)
  (setq $cBLR/USD startBLR/USD)
  (setq date (cadr Xrange))
  ; цикл пересчета дней
  (while (<= date (caddr Xrange))
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; ежемесячные выплаты;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (cond
      ((= 25 date)
       (setq transaction 60000000)
       (setq $cUSDcap (- $cUSDcap (/ transaction $cBLR/USD)))
       (setq $cBLRcap (+ $cBLRcap transaction))
       (setq $cBLRcap (- $cBLRcap transaction))
       (setq transaction nil)
       )
      ((= 55 date)
       (setq transaction 60000000)
       (setq $cUSDcap (- $cUSDcap (/ transaction $cBLR/USD)))
       (setq $cBLRcap (+ $cBLRcap transaction))
       (setq $cBLRcap (- $cBLRcap transaction))
       (setq transaction nil)
       )
      ((= 85 date)
       (setq transaction 60000000)
       (setq $cUSDcap (- $cUSDcap (/ transaction $cBLR/USD)))
       (setq $cBLRcap (+ $cBLRcap transaction))
       (setq $cBLRcap (- $cBLRcap transaction))
       (setq transaction nil)
       )
      )

    ;; прирост курса в день
    (setq $cBLR/USD (+ $cBLR/USD rostBLR/USD))
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;		ежедневные пересчеты по % и курсу
    (setq $cUSDcap (+ $cUSDcap (/ (/ (* $cUSDcap %USDdeposit) 100) 365)))
    (setq $cBLRcap (+ $cBLRcap (/ (/ (* $cBLRcap %BLRdeposit) 100) 365)))
    (setq $cBLRcap/USD (/ $cBLRcap $cBLR/USD))
    (setq $summUSD (+ $cUSDcap $cBLRcap/USD))
    (setq res (append res (list (list
				  (cons "date"  date)
				  (cons "$cBLR/USD"  $cBLR/USD)
				  (cons "$cBLRcap"  $cBLRcap)
				  (cons "$cUSDcap"  $cUSDcap)
				  (cons "$cBLRcap/USD" $cBLRcap/USD)
				  (cons "$summUSD" $summUSD)
				  ))))
    
    (setq date (+ date (car Xrange)))
    )
  ;;  формат :  [день валюта белсчет доллсчет]
  res
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun drawbase (/ Xmax Xmin Ymax Ymin obj layer)
  (setq layer (vla-add (vla-get-Layers #actdoc) "Axes"))
  (setq Xmax (* 1.4 (apply 'max (cons 1 (mapcar 'car #baserange)))))
  (setq Xmin (* 1.4 (apply 'min (cons -1 (mapcar 'car #baserange)))))
  (setq Ymax (* 1.4 (apply 'max (cons 1 (mapcar 'cadr #baserange)))))
  (setq Ymin (* 1.4 (apply 'min (cons -1 (mapcar 'cadr #baserange)))))
  
  (setq obj (vla-addline #modspace
    (vlax-3d-point (mapcar '+ #ptbase (list Xmin 0 0)))
    (vlax-3d-point (mapcar '+ #ptbase (list Xmax 0 0)))
    )) (vlax-put-property obj "color" 250)
  (setq obj (vla-InsertBlock #modspace
    (vlax-3d-point (mapcar '+ #ptbase (list Xmax 0 0)))
	      (cadr (assoc comp #blockarrowpaths))
	      1 1 1 0)) (vlax-put-property obj "color" 250)
  (setq obj (vla-addline #modspace
    (vlax-3d-point (mapcar '+ #ptbase (list 0 Ymin 0)))
    (vlax-3d-point (mapcar '+ #ptbase (list 0 Ymax 0)))
    )) (vlax-put-property obj "color" 250)
  (setq obj (vla-InsertBlock #modspace
    (vlax-3d-point (mapcar '+ #ptbase (list 0 Ymax 0)))
	      (cadr (assoc comp #blockarrowpaths))
	      1 1 1 (* pi 0.5))) (vlax-put-property obj "color" 250)
  (setq #baserange nil)
  (vla-addtext #modspace (strcat "BLR: " (rtos startBLRcapital)) (vlax-3d-point #ptbase) 1.0)
  (vla-addtext #modspace (strcat "USD: " (rtos startUSDcapital)) (vlax-3d-point (mapcar '+ '(0 -2 0) #ptbase)) 1.0)
  );defun

(defun drawgraph (2Ddatarange color message / obj ptdata fitPoints startTan endTan osm pts i)
  (setq osm (getvar "OSMODE")) (setvar "OSMODE" 0)
  ;(setq 2Ddatarange '((1 10 )(2 15)(3 20)))
  (setq startTan (vlax-3d-point 0 0 0) endTan (vlax-3d-point 0 0 0))
  (setq ptdata (apply 'append (mapcar '(lambda (p) (mapcar '+ #ptbase (append p '(0.0)))) 2Ddatarange)))
  ;(setq fitPoints (vlax-make-safearray vlax-vbDouble (cons 0  (1- (length ptdata)))))
  ;(vlax-safearray-fill fitPoints ptdata)
  ;(setq obj (vla-AddSpline #modspace fitPoints startTan endTan))
  ;(vlax-put-property obj "color" color)
  (setq pts (mapcar '(lambda (p) (mapcar '+ #ptbase p)) 2Ddatarange) i 1)
  (repeat (1- (length pts))
    (setq obj (vla-addline #modspace (vlax-3d-point (nth (1- i) pts)) (vlax-3d-point (nth i pts))))
    (setq i (1+ i))
    (vlax-put-property obj "color" color)
    )
  (setq obj (vla-addtext #modspace message (vlax-3d-point (mapcar '+ '(5 0 0) (reverse (list (nth 0 (reverse ptdata)) (nth 1 (reverse ptdata)) (nth 2 (reverse ptdata)))))) 1))
  (vlax-put-property obj "color" color)
  (setq obj (vla-addtext #modspace (rtos (cadr (last 2Ddatarange)) 2 1) (vlax-3d-point (mapcar '+ #ptbase (last 2Ddatarange)))1.0))
  (vlax-put-property obj "color" color)
  (setq obj (vla-addtext #modspace (rtos (cadr (car 2Ddatarange)) 2 2) (vlax-3d-point (mapcar '+ #ptbase (car 2Ddatarange)))1.0))
  (vlax-put-property obj "color" color)
  (setvar "OSMODE" osm)
  );defun

(defun scale (2Ddatarange sc / res)
  (setq res (mapcar '(lambda (x) (list (car x) (* (cadr x) sc))) 2Ddatarange))
  (setq #baserange (append #baserange res))
  res
  )



(setq #ptbase (getpoint))
(setq $data (calculate Xrange))
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$cBLR/USD" x)))) $data) 0.001) 256 "currency [тыс/$]")
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$cBLRcap" x)))) $data) 0.000001) 133 "blr [млн]")
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$cBLRcap/USD" x)))) $data) 0.001) 4 "blrcap/USD [тыс]")
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$cUSDcap" x)))) $data) 0.001) 71 "USD [тыс]")
(drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "date" x)) (cdr (assoc "$summUSD" x)))) $data) 0.001) 3 "суммарный балланс в пересчете на USD [тыс]")
(drawbase) 







(defun  graph%bel (/ %belrange %bel startBLRcapital startUSDcapital $$data)
  (setq $$data nil)
  (setq %belrange '(0.05 0 1))
  (setq %bel (cadr %belrange))
  (while (<= %bel (caddr %belrange))
    (setq startBLRcapital (* totalcapital %bel))
    (setq startUSDcapital (/ (* totalcapital (- 1 %bel)) startBLR/USD))
    (setq $$data (append $$data (list (list (cons "%bel" %bel) (assoc "$summUSD" (last (calculate Xrange)))))))
    (setq %bel (+ %bel (car %belrange)))
    )
  (setq #ptbase (getpoint))
  (drawgraph (scale (mapcar '(lambda (x) (list (cdr (assoc "%bel" x)) (cdr (assoc "$summUSD" x)))) $$data) 0.001) 3 "суммарный балланс в пересчете на USD [тыс]")
  (drawbase) 
  );defun