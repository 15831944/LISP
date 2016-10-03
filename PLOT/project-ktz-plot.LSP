;;; изменена 10_05_27
;;; ktz-plot
;;; прога для вывода на печать массы листов в одной модели
;;; например для генерации pdf-файла спецпфикации для архива
;;; export-to-dwg
;;; сохраняет листы с одной модели в разные файлы с номером листа (для архива)
;;; использована при разработке щита БП №4 Береза
;;; -kakt00z-™  ©
(load "d:/LISP WORKING/common functions/format-identification-gost.lsp")
(vl-load-com)


;;;************************************************************************************************************
;;; берет "кол.уч"
;;; дает список (pt1 pt2 "имя формата")
;;;************************************************************************************************************
(defun dataprint (ent / pt-list foname nlist)
  (setq pt-list (get-formatpts<-rightformatline (get-rightformatline<-koluch ent)))
  (setq foname (format-detect (get-ftxte<-formatpts pt-list)))
  (setq nlist (get-lnumber ent))
  (cons (atof nlist) (list pt-list foname)) 
  );defun
;;;************************************************************************************************************
;;;************************************************************************************************************


;;;************************************************************************************************************
;;;;;; main function1    ktz-plot
;;;************************************************************************************************************
(defun c:ktz-plot (/
		   koluchs
		   flist
		   scale
		   )
  (setq koluchs (get-kol-uch)
	flist '())
  (setq scale (/ (cdr (assoc 40 (entget (car koluchs)))) 2.5))

  (setq flist (mapcar 'dataprint koluchs))
  
;;; ***************************************************************************
;;; сортируем список по номеру листа
;;; ***************************************************************************
  (setq	flist	(vl-sort flist '(lambda (a b)
				  (< (car a) (car b)) )))
;;; ***************************************************************************
  (foreach en flist
    (ktz-printout en)
    ;(command pause)				;;;;; раскоментить если нужно чертеж в отдельный файл
    						;;;;; после сохранения нажать ентер для проджолжения
    );foreach
  );defun



;;;************************************************************************************************************
;;; берет '(17.13 ((30180.0 23747.6) (30600.0 24044.6)) "-A3")
;;; причем 17,13 в функции не используется
;;;************************************************************************************************************
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














;;;************************************************************************************************************
;;;************************************************************************************************************
(defun c:export-to-dwg ( /
			lst
			uznumber
			nlist
			pt-list
			scale
			)
  (if (or
	(ssget "_X" '((0 . "LWPOLYLINE")))
	(ssget "_X" '((1 . "Копировал")))
	(ssget "_X" '((0 . "spdsFormat")))
	)
    (progn
      (alert "Чертеж не подготовлен
      \n  - разбейте SPDS-объекты и блоки
      \n  - уберите слово \"Копировал\"
      \n  - разбейте полилини")
      (exit)
      )
    (setq lst (get-kol-uch))
    );if
      
  (setq scale (/ (cdr (assoc 40 (entget (car lst)))) 2.5))
  
  (foreach ent lst
    (setq pt-list (get-formatpts<-rightformatline (get-rightformatline<-koluch ent)))
    (setq nlist (get-lnumber ent))
    (setq uznumber (cdr (assoc 1 (entget (get-uznumber ent)))))
    (vl-cmdf "_zoom" "_W" (car pt-list) (cadr pt-list))
    
    (ss->file (list (strcat uznumber " л" nlist ".dwg")  (ssget "_C" (car pt-list) (cadr pt-list))))
    )
  );defun
;;;************************************************************************************************************
;;; берет ("название листа1.dwg" <Selection set: 10e0>) и сохраняет в указанной папке
;;;************************************************************************************************************
(defun ss->file (sslist
			  /
			  temp
			  actdoc
			  path
			  filename
			  )
  (setq path "d:/!!! TDMS/"
  ;(setq path "c:/Documents and Settings/user/Мои документы/"
	
	filename (car sslist))
  (setq actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (sssetfirst nil (cadr sslist))
  
  (setq temp (vla-get-ActiveSelectionSet actdoc))
  (vla-Clear temp)
  (vla-SelectOnScreen temp)
  (vla-Wblock actdoc (strcat path filename) temp)
  );defun
;;;************************************************************************************************************
;;;************************************************************************************************************