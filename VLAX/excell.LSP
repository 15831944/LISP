	; Листинг 2. Чтение файла Excel с применением COM и построение таблицы в AutoCAD 
	; Программы COM-связи AutoCAD - Microsoft Excel 2000
	; Н.Н.Полещук, 2002
	;
	; Пример вычерчивания таблицы по данным из листа книги Excel
	; Используются текущий слой, текущий цвет и текущий текстовый стиль
	; В текущем текстовом стиле высота букв должна быть задана нулем
	; (тогда команда TEXT запрашивает высоту букв надписи)


(defun exc_com1	(/
		 tb_xls
		 hcell
		 hlet
		 oex
		 wkbs
		 awb
		 shs
		 mainsh
		 cell
		 nlines
		 ncolumns
		 table_items
		 i
		 j
		 row
		 pt0
		 widths
		 types
		 headers
		 xx1 xx2 yy1
		 ww
		 val
		 )

; Имя файла Excel и нужного листа
  (setq	tb_xls	  "D:\\!! ACAD work folder\\Береза\\ПИТ ТЗБ\\tst1.xlsx"
	sheetname "Лист1"
	) ;_ конец setq

; Высота ячеек рисуемой таблицы и высота букв
  (setq	hcell 8.0
	hlet 2.5
	) ;_ конец setq
;
; Установить связь c Excel

  (vl-load-com)
  (setq oex (ex_set_connect))
; Получить указатель семейства Workbooks
  (setq wkbs (vlax-get-property oex "Workbooks"))
; Открыть файл (книгу) и получить указатель книги
  (setq awb (vlax-invoke-method wkbs "Open" tb_xls))
  (if (not awb)
    (progn (alert (strcat "Не обнаружен файл " tb_xls)) (exit))
    ) ;_ конец if

  
; Прочитать список листов 
  (setq shs (vlax-get-property awb "Worksheets"))
; Получить указатель на лист с нужным именем   (manish)
  (vlax-for s shs
    (if	(= sheetname (vlax-get-property s "Name"))
      (setq mainsh s)
      ) ;_ конец if
    ) ;_ конец vlax-for
  
; Если нужный лист не обнаружен, то завершить работу
  (if (not mainsh)
    (progn (alert (strcat "Не обнаружен лист " sheetname))
	   (exit)
	   ) ;_ конец progn
    ) ;_ конец if

  
;
; Читаем из ячейки A1 файла Excel количество строк в будущей таблице
;  спецификации, без учета строки заголовков
  (setq	cell
	 (vlax-variant-value
	   (vlax-invoke-method mainsh "Evaluate" "A1")
	   ) ;_ конец vlax-variant-value
	) ;_ конец setq
  (setq	nlines
	 (fix (vlax-variant-value (vlax-get-property cell "Value")))
	) ;_ конец setq

  
; Читаем количество столбцов в будущей таблице спецификации
;  (из ячейки B1 файла Excel)
  (setq	cell
	 (vlax-variant-value
	   (vlax-invoke-method mainsh "Evaluate" "B1")
	   ) ;_ конец vlax-variant-value
	) ;_ конец setq
  (setq	ncolumns
	 (fix (vlax-variant-value (vlax-get-property cell "Value")))
	) ;_ конец setq

  
;
; Получить список элементов таблицы (строки 2,3,4, ... Excel)
; Строка 2 - ширины столбцов в мм
; Строка 3 - заголовки столбцов
  (setq	table_items nil
	j 1
	) ;_ конец setq
  (repeat (+ nlines 3)
    (setq row nil
	  j   (1+ j)
	  i   -1
	  ) ;_ конец setq
    (repeat ncolumns
      (setq i (1+ i))
      (setq cell
	     (vlax-variant-value
	       (vlax-invoke-method
		 mainsh
		 "Evaluate"
		 (strcat (chr (+ i (ascii "A"))) (itoa j))
		 ) ;_ конец vlax-invoke-method
	       ) ;_ конец vlax-variant-value
	    ) ;_ конец setq
      (setq row
	     (append
	       row
	       (list
		 (vlax-variant-value
		   (vlax-get-property cell "Value")
		   ) ;_ конец vlax-variant-value
		 ) ;_ конец list
	       ) ;_ конец append
	    ) ;_ конец setq
      );repeat ncolumns
    (setq table_items (append table_items (list row)))
    );repeat nlines
;
; Закрыть книгу Excel
  (ex_break_connect oex)
;
; Запрос точки левого верхнего угла таблицы
  (setq pt0 nil)
  (while (null pt0)
    (setq pt0 (getpoint "\nТочка левого верхнего угла таблицы: "))
    );while
;
  (setq	widths (nth 0 table_items)
	types  (nth 1 table_items)
	) ;_ конец setq
;
; Нарисовать сетку (высота ячеек 8 мм)
  (tab_lines pt0 ncolumns nlines widths hcell)
;
; Заголовки столбцов таблицы
  (setq	headers	(nth 2 table_items)
	i	-1
	xx1	(car pt0)
	yy1	(- (cadr pt0) hcell)
	) ;_ конец setq
  (repeat ncolumns
    (setq i   (1+ i)
	  ww  (nth i widths)
	  xx2 (+ xx1 ww)
	  ) ;_ конец setq
    (setq val (nth i headers))
    
    (write_item val "str" xx1 xx2 yy1 hlet)
    (setq xx1 xx2)
    )					;
					;
					; Заполнить таблицу
  (setq j 2)
  (repeat nlines
    (setq j   (1+ j)
	  i   -1
	  xx1 (car pt0)
	  yy1 (- (cadr pt0) (* (1- j) hcell))
	  ) ;_ конец setq
    (repeat ncolumns
      (setq i	(1+ i)
	    ww	(nth i widths)
	    xx2	(+ xx1 ww)
	    ) ;_ конец setq
      (setq val (nth i (nth j table_items)))
      (setq itype (nth i types))
      (write_item val itype xx1 xx2 yy1 hlet)
      (setq xx1 xx2)
      )					;repeat ncolumns
    )					;repeat nlines
					;
  (redraw)
  (princ)
  ) ;_ конец defun




;-------------- Подпрограммы -----------------
; Установить связь с Excel 2000
; Возвращаемое значение - VLA-объект приложения
(defun ex_set_connect (/ e)
  (setq e (vlax-get-or-create-object "Excel.Application"))
; Если связь не установлена, то аварийно завершить работу
  (if (null e)
    (progn
      (alert "Нельзя запустить Microsoft Excel")
      (exit)
      ) ;_ конец progn
    );if
; Можно сделать Excel видимым:
;;; (vlax-put-property e "Visible" :vlax-true)
;
; Возвращаемое значение
  e
  ) ;_ конец defun



;---------------------------------------------
; Разорвать связь с Excel
(defun ex_break_connect	(e /)
  (vlax-invoke-method e "Quit")
  (vlax-release-object e)
  ) ;_ конец defun


;-----------------------------------------------------------
; Вычерчивание элемента таблицы, с отступом от границ ячейки
(defun write_item (item		; item  - элемент
		   typ		; typ   - тип ("int", "str", ...)
		   x1 x2	; x1,x2 - граничные абсциссы ячейки
		   		; таблицы, в которую нужно внести текст
		   yi		; yi    - ордината нижней границы ячейки
		   hl		; hl    - высота букв надписи
		   /
		   gapx		; gapx - отступ по X от левой и правой границ ячейки
		   gapy		; gapy - отступ по Y от нижней границы ячейки
		   wi		; wi    - ширина ячейки
		   yig
		   st
		   siz
		   sizex
		   )
  (setq	gapx 1.0
	gapy 1.0
	wi   (- x2 x1)
	yig  (+ yi gapy)
	) ;_ конец setq
  (if item
    (progn
;
; Преобразование значения item в текст, в зависимости от формата
; Значения типа "int" нужно обрабатывать без дробной части
      (setq st
	     (if (= typ "int")
	       (itoa (fix item))
	       (vl-princ-to-string item)
	       ) ;_ конец if
	    ) ;_ конец setq
;
; Вычислить размер текста (sizex - размер по горизонтали)
      (setq size (textbox (list (cons 1 st) (cons 40 hl))))
      (setq sizex (- (caadr size) (caar size)))
; Если текст помещается в ячейке, то вписываем его
;  с выравниванием по левой нижней точке
; Если текст не помещается, то вписываем его с опцией Fit (По ширине)
      (if (<= sizex (- wi (+ gapx gapx)))
	(command "_.TEXT" (list (+ x1 gapx) yig) hl 0.0 st)
	(command "_.TEXT"
		 "_F"
		 (list (+ x1 gapx) yig)
		 (list (- xx2 gapx) yig)
		 hl
		 st
		 ) ;_ конец command
	)				;if
      )					;progn
    )					;if item
  );




;--------------------------------------
; Вычерчивание линий таблицы
(defun tab_lines (p0 nc nl wids h / w k xx yy htab)
					; p0  - точка верхнего левого угла таблицы
					; nc   - количество столбцов
					; nl   - количество строк
					; wids - список ширин столбцов
					; h    - высота строк
					;
					; Вычисление w - полной ширины таблицы
  (setq	w 0.0
	k -1
	) ;_ конец setq
  (repeat nc
    (setq k (1+ k)
	  w (+ w (nth k wids))
	  ) ;_ конец setq
    ) ;_ конец repeat
					;
					; Горизонтальные отрезки
  (setq	xx (car p0)
	yy (cadr p0)
	) ;_ конец setq
  (repeat (+ nl 2)
    (command "_.LINE" (list xx yy) (list (+ xx w) yy) "")
    (setq yy (- yy h))
    )					;repeat
					;
					; Вертикальные отрезки
  (setq	xx   (car p0)
	yy   (cadr p0)
	htab (* h (1+ nl))
	k    -1
	) ;_ конец setq
  (command "_.LINE" (list xx yy) (list xx (- yy htab)) "")
  (repeat nc
    (setq k  (1+ k)
	  xx (+ xx (nth k wids))
	  ) ;_ конец setq
    (command "_.LINE" (list xx yy) (list xx (- yy htab)) "")
    )					;repeat
  )					;defun