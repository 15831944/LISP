;;; изменена 10_05_27
;;; ktz-plot
;;; прога для вывода на печать массы листов в одной модели
;;; например для генерации pdf-файла спецпфикации для архива
;;; export-to-dwg
;;; сохраняет листы с одной модели в разные файлы с номером листа (для архива)
;;; использована при разработке щита БП №4 Береза
;;; -kakt00z-™  ©
(vl-load-com)
(load "d:/LISP WORKING/common functions/format-identification-gost.lsp")



  
;(wcmatch (cdr (assoc 1 (entget (car (entsel))))) "*A#@#,*A#,*А#@#,*А#,*A#`*#,*А#`*#")
;(format-detect (get-ftxte<-formatpts (list (getpoint)(getpoint))))




;(vl-string-translate "xх*" "sss" (cdr (assoc 1 (entget (car (entsel))))))






(defun ktz-printout (lst
		     /
		     printer
		     format
		     pt1
		     pt2
		     fit
		     plotstyle
		     line-weight
		     Plot-not-prew
		     orient
		     )
;;;  (initget "kaktooz-pdf Pashkina _1 2")
;;;  (setq flag (getkword "\n Выбирать аттрибут по точке или выбрать из списка?  : [kaktooz-pdf.pc3/\\\\Pashkina\\HP LaserJet 1020] <kaktooz-pdf.pc3>"))


  (setq
    pt1 		(caadr lst)
    pt2			(cadadr lst)
    fit			"_fit"
    plotstyle		"monochrome.ctb"
    line-weight		"_Y"
    Plot-not-prew 	"_Y"
    
    orient		;"_L"				;Landscape / Portrait   "_L" "_P"
     (if (> (abs (- (car pt1) (car pt2)))
	    (abs (- (cadr pt1) (cadr pt2))))
       "_L"
       "_P"
       );if orient
    ;printer		"kaktooz-pdf.pc3"
    ;printer		"\\\\Pashkina\\HP LaserJet 1020"
    printer
     (if (= orient "_L")
       "pdf-w.pc3"
       "pdf-v.pc3"
       );if printer
    
    format
     (if (= orient "_L")
       (strcat "w" (caddr lst))
       (strcat "v" (caddr lst))
       );if format
    ;format		"A4"
    
    )

   (command "_.plot" 		;сама команда 
             "_Yes" 		;нужны настройки 
             "model" 		; Имя листа или [?] <Модель>: 
             printer 		;Имя устройства вывода или [?] <HP2200-PCL6.pc3>: 
             format 		;Формат листа бумаги или [?] <A4>: 
             "Millimeters" 	;Единицы измерения размеров листа [Дюймы/Миллиметры] <дюйм>:
             orient 		;Ориентация чертежа [Книжная/Альбомная] <Книжная>: 
             "_No" 		;Перевернуть чертеж? [Да/Нет] <Нет>:
             "_Window" 		;Печатаемая область [Экран/Границы/Лимиты/Вид/Рамка] <Рамка>:
             pt1 		;Первая точка окна 
             pt2 		;Вторая точка окна 
             fit 		;[Вписать] <Вписать>: ("_fit")
             "_center" 		;Смещение от начала (x,y) или [Центрировать] <Центрировать>: 
             "_yes" 		;Учитывать стили печати? [Да/Нет] <Да>:
             plotstyle 		;Имя таблицы стилей печати или [?] (. если нет) <monochrome.ctb>:
             line-weight 	;Учитывать веса линий? [Да/Нет] <Да>:
             "As displayed" 	;Режим вывода раскрашенных ВЭ [Обычный/Каркас/Скрытие линий/Тонирование] <Обычный>:
             "_No" 		;Запись чертежа в файл [Да/Нет] <Н>:
             "_yes" 		;Сохранить изменения параметров листа [Да/Нет]? 
             Plot-not-prew 	;Перейти к печати [Да/Нет] <Д>: 
    ) ;_ end of command


  
  );defun




;(ktz-printout (dataprint (car (entsel))))


;;; берет "Format" выдает int  номер листа
(defun m-get-lnumber (en /
		   e1
		   vect
		   pt1
		   pt2
		   li
		   )
  
  (setq vect (list (* 181 scale) (* 15 scale)))
  (setq pt1 (vec-sum (cdr (assoc 10 (entget en))) vect))
  (setq pt2 (vec-dif pt1 (list (* 42 scale) (* 30 scale))))
  ;(get-lnumber (car (entsel)))
  ;(command "_rectang" pt1 pt2)
  (vl-cmdf "_.zoom" "_W" pt1 pt2)
  (setq li (ssget "_C" pt1 pt2 '((0 . "*TEXT")(1 . "Лист"))))
  (if (= (sslength li) 1)
    (setq li (ssname li 0))
    (progn
      (ktz-show-error
	(cons 10 pt1)
	"проверьте данное место"
	) ;_ конец ktz-show-error
      (exit)
    )
    );if
    
  (setq vect (list (* 9 scale) (* 9 scale)))
  (setq pt1 (vec-dif (cdr (assoc 10 (entget li))) (list 0 (* 2 scale))))
  (setq pt2 (vec-sum pt1 (list (* 9 scale) (* -9 scale))))
  ;(command "_rectang" pt1 pt2)
  (setq e1 (ssget "_C" pt1 pt2 '((0 . "*TEXT"))))
  (if (= (sslength e1) 1)
      (setq e1 (ssname e1 0))
      (progn
	(ktz-show-error
	  (cons 10 pt1)
	"проверьте данное место"
	) ;_ конец ktz-show-error
      (exit)
    )
    );if

  e1
  );defun




;;;;;; ***************************************************************************
;;;;;; main function1    ktz-plot
;;;;;; dataprint - 
;;;;;; ***************************************************************************





;;; выдает список (e1 e2 ... en), где ех - текст с содержимым "*Format*"
(defun m-get-txte-format (
                        /
                        ss
                        lst
                        en
                        i
                        )
    (setq ss (ssget "_X" '((1 . "*Format*")))
          lst '())
    (repeat (sslength ss)
        (setq lst (append lst (list (ssname ss i))))
        (setq i (1+ i))
        )
       );defun
;;;************************************************************************************************************



;;;(vlax-safearray->list(vlax-variant-value 
;;;(vlax-get-property (vlax-ename->vla-object (car (entsel))) "StartPoint")))
;;;
;;;;;; указвыаем листы для распознавания
;;;;;; непечатаемый слой frames
;;;
;;;(setq frss (ssget "_X" '((8 . "frames"))))
;;;(sssetfirst nil frss)
;;;
;;;(setq i 0)
;;;(repeat (sslength frss)
;;;    (setq tmpo (vlax-ename->vla-object (ssname frss i)))
;;;    (setq st (vlax-safearray->list(vlax-variant-value (vlax-get-property tmpo "StartPoint"))))
;;;    (setq en (vlax-safearray->list(vlax-variant-value (vlax-get-property tmpo "EndPoint"))))
;;;    (setq midp (mapcar '(lambda (x) (/ x 2)) (mapcar '+ st en)))
;;;    (vla-Mirror tmpo (vlax-3d-point midp) (vlax-3d-point (mapcar '+ midp '(0 -100 0))))
;;;    (setq i (1+ i))
;;;    )




(defun c:m-plot (
                 /
		   txtents
		   flist
		   scale
		   )
  (setq txtents (m-get-txte-format)
	flist '())
  (setq scale (/ (cdr (assoc 40 (entget (car txtents)))) 2.5))
  (foreach en txtents
    (setq flist (append flist (list (m-dataprint en))))
    );foreach
;;; сортируем список по номеру листа

  (setq	flist	(vl-sort flist
			 '(lambda (a b)
			    (< (car a)
			       (car b)
			       ))))  
  (foreach en flist
    (ktz-printout en)
    ;(command pause)				;;;;; раскоментить если нужно чертеж в отдельный файл
    						;;;;; после сохранения нажать ентер для проджолжения
    );foreach
  );defun


;;;********************  DATAPRINT  *******************************************
;;; берет "Format A3"
;;; дает список (pt1 pt2 "имя формата")
(defun m-dataprint (ent
		  /
		  pt-list
		  foname
		  nlist
		  )
  (setq pt-list (m-get-formatpts<-rightformatline
                    (m-get-rightformatline<-koluch
                        ent)))
  (setq foname (m-format-detect ent))
  (setq nlist (m-get-lnumber ent))
  (cons (atof nlist) (list pt-list foname)) 

  ;(command "_rectang" p1 p2 "")
  ;(princ fo)
  );defun

;;;****************************************************************************
;;; даёт ename линии справа от слова Format на 20 мм
;;; ent - слово Кол. уч.
(defun m-get-rightformatline<-koluch (ent
			     /
			     pt1
			     pt2
			     ss
			     en
			     )
  (setq	pt1	(list
			  (+ (car (cdr (assoc 10 (entget ent)))) (* 15 scale)) ;;;; расстояние до линии справа
			    (cadr (cdr (assoc 10 (entget ent)))) 
			)
		pt2	(list
			  (+ (car pt1) (* 5 scale))
			  (cadr pt1)
			  )
		)
  (vl-cmdf "_zoom" "_W" pt1 pt2)
  
      (setq ss (ssget "_C" pt1 pt2))
  
      (if (= 1 (sslength ss))
	(setq en (ssname ss 0))
	(progn
	  (ktz-show-error
	    (cons 10 pt1)
	    "\nлинии рамки формата дублируются или отсутствуют\nнужно сделать чтобы рамка была нарисована 4-мя отрезками"
	    ) ;_ конец ktz-show-error
	  (exit)
	  );progn
	);if
     en
  ;(command "_Line" pt1 pt2 "")
);defun




;;;****************************************************************************
;;; даёт 2 точки - окно форматки
;;; принимает ent - правый отрезок рамки формата

(defun m-get-formatpts<-rightformatline (ent
		   /
		   frame-fltr
		   ss
		   i
		   lstX
		   lstY
		   minX
		   minY
		   maxX
		   maxY
		   pt1
		   pt2
		   )

(setq frame-fltr
       (list '(-4 . "<AND")
	     '(0 . "LINE")
	     '(-4 . "<OR")
	     (cons 10 (cdr (assoc 10 (entget ent))))
	     (cons 10 (cdr (assoc 11 (entget ent))))
	     (cons 11 (cdr (assoc 10 (entget ent))))
	     (cons 11 (cdr (assoc 11 (entget ent))))
	     '(-4 . "OR>")
	     '(-4 . "AND>")
       )
);setq
  (setq ss (ssget "_X" frame-fltr))
  (setq ss (ssdel ent ss))

  (if (/= 2 (sslength ss))
    ;then
    (progn
      (ktz-show-error
	(assoc 10 (entget ent))
	"проверьте рамку формата"
	)
      (exit)
      )
    ;esle
    (progn
      (setq i 0)
      (repeat (sslength ss)
	(setq lstX (append lstX (list (cadr (assoc 10 (entget (ssname ss i))))
				      (cadr (assoc 11 (entget (ssname ss i))))
				      ));list
	      lstY (append lstY (list (caddr (assoc 10 (entget (ssname ss i))))
				      (caddr (assoc 11 (entget (ssname ss i))))
				      ));list
	      );setq
	
	(setq i (1+ i))
	);repeat
      
      (setq minX (eval (append (list 'min) lstX))
	    maxX (eval (append (list 'max) lstX))
	    minY (eval (append (list 'min) lstY))
	    maxY (eval (append (list 'max) lstY))
	    pt1 (list minX minY)
	    pt2 (list maxX maxY)
	    );setq
      
      (list pt1 pt2)

      ;(command "_rectang" pt1 pt2)

      );progn
    );if
  );defun



;;;****************************************************************************
;;; принимает строку содержащую информацию об размере формата
;;; возвращает размер формата для вывода на принтер


(defun m-format-detect (e
		      /
                        fstr
		      str
		      printer-format
		      printer-separator
		      n1
		      n2
		      )

;;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;; данные зависят от того как сделан принтер			;
  (setq printer-format "-A")					; латиница
  (setq printer-separator "x")					; латиница
;;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    (setq e (car (entsel)))
    (setq fstr (cdr (assoc 1 (entget e))))
   
  (if (wcmatch fstr "#@#,#,#`*#")
    ;then
    (progn
      (cond
	((= (strlen fstr) 1)
	 (setq str (strcat printer-format fstr))
	 )
	((= (strlen fstr) 3)
	 (setq str
		(vl-string-translate
		  "xх*"
		  (strcat printer-separator printer-separator printer-separator)
		  fstr))
	 (setq str (strcat printer-format str))
	 
	 )
	)
      T
      );progn
    ;else
    (alert "ошибка при определении формата, \nвозможно неверный формат")
    )
  str
  );defun







