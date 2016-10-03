;Возвращает T если в объекте есть поле
;;; obj - VLA-объект
(defun isFieldAvailable ( obj  / fc )
  (and
    (vlax-method-applicable-p obj 'FieldCode) ;_есть метод FieldCode
    (setq fc (vlax-invoke obj 'FieldCode))
    (vl-string-search "%<\\Ac" fc)
    (vl-string-search ">%" fc)
   )
)
;(isFieldAvailable (vlax-ename->vla-object (car (entsel))))



;_Удаляет все поля из объекта
;;; obj - VLA-объект
;_Возвращает текстовую строку с удаленным описание поля или строку если поля нет или "" если поля нет
;_обновлять в объекте (vlax-put obj 'TextString newstr)

;(vlax-dump-object (vlax-ename->vla-object (car (entsel)))T)
(defun removeAllFieldFromObject ( obj  / fc fb fe fb1 tmp txt)
  (setq txt (vla-get-TextString obj))
  (and
    (vlax-method-applicable-p obj 'FieldCode) ;_есть метод FieldCode
    (setq fc (vlax-invoke obj 'FieldCode))
    (while (and
             (setq fb (vl-string-search "%<\\Ac" fc))
             (if (null (setq fb1 (vl-string-search "%<\\Ac" fc (1+ fb))))
               (setq fb1 (strlen fc)) T)
             (setq fe fb)
             (while (and
                      (setq tmp (vl-string-search ">%" fc (1+ fe)))
                      (< tmp fb1)
                      )
               (setq fe tmp)
               )
             (if (= fb 1)
               (setq fc (substr fc (+ 4 fe)))
               (setq fc (strcat (substr fc 1 fb)(substr fc (+ 4 fe))))
               )
             )
      )
    )
  (if fc fc txt)
  )
;(removeAllFieldFromObject (vlax-ename->vla-object (car (entsel))))


;_Удаляет поле  из объекта по указанной маске
;;; obj - VLA-объект
;;FieldPattern - маска поля (начало описания поля, см. в редакторе)
;; !! Обращайте внимание, что одиночная \ заменяется двойной \\
;;Например поле свойств - %<\\AcObjProp
;переменные -  %<\\AcVar и т.д.
;_Возвращает текстовую строку с удаленным описанием
;_обновлять в объекте (vlax-put obj 'TextString newstr)
(defun removeSpecifyFieldFromObject ( obj FieldPattern  / fc fb fe fb1 tmp )
  (and
    (vlax-method-applicable-p obj 'FieldCode) ;_есть метод FieldCode
    (setq fc (vlax-invoke obj 'FieldCode))
    (while (and
             (setq fb (vl-string-search FieldPattern fc))
             (if (null (setq fb1 (vl-string-search FieldPattern fc (1+ fb))))
               (setq fb1 (strlen fc)) T)
             (setq fe fb)
             (while (and
                      (setq tmp (vl-string-search ">%" fc (1+ fe)))
                      (< tmp fb1)
                      )
               (setq fe tmp)
               )
             (if (= fb 1)
               (setq fc (substr fc (+ 4 fe)))
               (setq fc (strcat (substr fc 1 fb)(substr fc (+ 4 fe))))
               )
             )
      )
    )
  (if fc fc "")
  )


;;Ф-ция добавляет к объекту поле
;; obj - VLA-объект
;; FieldStr - сформированная строка поля (такая же, какая отражается в окне редактора
;;Никаких проверок на корректность строки и присутствия оной в строке FieldStr не производится
;; !! Обращайте внимание, что одиночная \ заменяется двойной \\
;;Возвращает T - поле добавлено nil - нет
(defun addFieldToObj (obj FieldStr / fc)
  (and
    (vlax-write-enabled-p obj)
    (vlax-method-applicable-p obj 'FieldCode) ;_есть метод FieldCode
    (vlax-property-available-p obj 'TextString)
    (setq fc (vlax-invoke obj 'FieldCode))
    (setq fc (strcat fc " " FieldStr))
    (vlax-put obj 'TextString fc)
    )
  )





;;====== Примеры испольвания ф-ций и просто полезные команды
;_Пример использования ф-ции removeAllFieldFromObject
;_удалить все поля из текста
(defun C:DEMO1 ( )
  (if (and (setq obj (car(entsel "\nУкажи текст для удаления полей: ")))
           (wcmatch (cdr(assoc 0 (entget obj))) "*TEXT")
           (setq obj (vlax-ename->vla-object obj))
           (vlax-write-enabled-p obj)
           )
    (vla-put-TextString obj (removeAllFieldFromObject obj))
    )
  (princ)
  )
;_Пример использования ф-ции removeSpecifyFieldFromObject
;_удалить определенное поле из текста
(defun C:DEMO2 ( )
  (if (and (setq obj (car(entsel "\nУкажи текст для удаления полей %<\\AcVar: ")))
           (wcmatch (cdr(assoc 0 (entget obj))) "*TEXT")
           (setq obj (vlax-ename->vla-object obj))
           (vlax-write-enabled-p obj)
           )
    (vla-put-TextString obj (removeSpecifyFieldFromObject obj "%<\\AcVar"))
    )
  (princ)
  )
;;Пример использования ф-ции addFieldToObj
;добавление поля даты
;;Проверка, естьли уже в поле дата не производиться
(defun C:DEMO3 ( )
  (if (and (setq obj (car(entsel "\nУкажи текст для втавки даты: ")))
           (wcmatch (cdr(assoc 0 (entget obj))) "*TEXT")
           (setq obj (vlax-ename->vla-object obj))
           (vlax-write-enabled-p obj)
           )
    (addFieldToObj obj "%<\\AcVar Date \\f \"yyyy-MM-dd\">%")
    )
  (princ)
  )
;_Пример команда меняет точность представления чисел в полях
;_Например поле длины с установленной точностью N на новую
(defun c:DEMO4 ( / oldpre newpre obj fc newstr)
(princ "\nМеняет точность представления чисел в полях")
(initget 1)
(setq newpre (getint "\nНовая точность: "))
(if (and
      (setq obj (car (entsel "\nУкажите текст, содержаций поле : ")))
      (setq obj (vlax-ename->vla-object obj))
      (vlax-method-applicable-p obj 'FieldCode)
      (vlax-write-enabled-p obj)
      )
  (progn
    (setq fc (vlax-invoke obj 'FieldCode)) ;_Получаем текст + поле
    (if (and
          (setq oldpre (vl-string-search "%pr" fc))
          (vl-string-search "%" fc (1+ oldpre))
          )
      (progn
        (setq oldpre
               (substr fc (1+ oldpre)
                 (- (vl-string-search "%" fc (1+ oldpre))
                    (1- oldpre))
                       )
              )
        (setq newstr (vl-string-subst
                       (strcat "%pr" (itoa newpre) "%")
                       oldpre
                       fc)
              )
        (vlax-put obj 'TextString newstr)
        )
      )
    (princ)
    )
  )
  (princ)
  )
;если нужно просто напечатать в командной строке AutoCAD ID примитива,
;то можно воспользоваться и такой командой:
(defun C:EID ( / )
(vl-load-com)
(vla-get-objectid (vlax-ename->vla-object (car (entsel))))
)
;так - чтобы сразу печатался полный текст поля для длины
(defun C:PFLD ( / en)
  (if (setq en (car (entsel))) (progn
    (princ (strcat "\n"
      "%<\\AcObjProp Object(%<\\_ObjId "
      (vl-princ-to-string (vla-get-objectid (vlax-ename->vla-object en)))
      ">%).Length>%"
    ))
  )) ;_endof if progn
  (princ)
) ;_endof defun





;;;Использование: 
;;;Рисуем 2 отрезка разной длины А и B 
;;;Создаем текст с полем на длину отрезка A 
;;;Запускаем DEMO5 
;;;В запросе "Select old object" указываем отрезок A 
;;;В запросе "Select new object:" указываем отрезок B 
;;;В запросе "Select text:" указываем текст с полем 
;;;Смотрим результат 
(defun C:DEMO5 () 
  (vl-load-com) 
  (and 
   (setq oldobjID (car(entsel "\nSelect old object:"))) 
   (setq newobjID (car(entsel "\nSelect new object:"))) 
   (setq txt (car(nentsel "\nSelect text:"))) 
   (change_owner_in_field oldobjID newobjID txt) 
) 
) 

(defun change_owner_in_field ;_Ф-ция заменяет владельца в поле 
                             (oldobjID ;_ Старый владелец ENAME 
                              newobjID ;_ Новый владелец   ENAME 
                              txt ;_ Хранитель поля (текст или атрибут) ENAME, 
                                  ;_ возвращаемое nentsel 
                              /           dict ;_ Словарь хранителя поля 
                              field ;_ Словарь самого поля 
                              field_data ;_ Значение поля (entget field) 
                              New_field_data ;_Новый список для entmod 
                              property ;_ Название свойства объекта в поле 
                             ) 
;_ Ф-ция заменяет владельца в поле 
;_ Аргументы 
;_   oldobjID - имя примитива старого владельца ID [ENAME] 
;_   newobjID - имя примитива нового владельца ID [ENAME] 
;_ Return 
;_ T - поле обновлено 
;_ nil -нет 
;;;!!! Важно: новый владелец должен обладать свойством, используемым в поле 

  (and 
  (setq dict (cdr (assoc 360 (entget txt)))) ;_Ename Dictionary Словарь примитива 
  (setq dict 
         (cdr (assoc 360 (member '(3 . "ACAD_FIELD") (entget dict)))) 
  ) ;_Enable Field Dictionary Есть поля в объекте 
  (setq field (cdr (assoc 360 (member '(3 . "TEXT") (entget dict))))) ;_ Field Record Запись поля 
  ;_Sub Field Records Вторичные записи полей 
  (setq sub_field_list (mapcar 'cdr (vl-remove-if '(lambda(x)(/= (car x) 360))(entget field)))) 
    ;(setq field (cdr (assoc 360 (entget field)))) ;_Sub Field Record Вторичная запись поля 
  (mapcar '(lambda(field_data) 
  (setq field_data (entget field_data)) 
  (if (and (member (cons 330 oldobjID) field_data) 
           (member (cons 331 oldobjID) field_data) 
           (setq property 
                  (vl-princ-to-string 
                    (cdr (assoc 
                           1 
                           (member '(6 . "ObjectPropertyName") field_data) 
                         ) ;_ end of assoc 
                    ) ;_ end of cdr 
                  ) ;_ end of VL-PRINC-TO-STRING 
           ) ;_ end of setq 
           (vlax-property-available-p 
             (vlax-ename->vla-object newobjID) 
             property 
           ) ;_ end of vlax-property-available-p 
      ) ;_ end of and 
    (progn 
      (setq New_field_data nil) 
      (foreach itm field_data 
        (cond 
          ((and (= (car itm) 330) 
                (equal (cdr itm) oldobjID) 
           ) ;_ end of and 
           (setq New_field_data 
                  (append New_field_data 
                          (list (cons 330 newobjID)) 
                  ) ;_ end of append 
           ) ;_ end of setq 
          ) 
          ((and (= (car itm) 331) 
                (equal (cdr itm) oldobjID) 
           ) ;_ end of and 
           (setq New_field_data 
                  (append New_field_data 
                          (list (cons 331 newobjID)) 
                  ) ;_ end of append 
           ) ;_ end of setq 
          ) 
          (t (setq New_field_data (append New_field_data (list itm)))) 
        ) ;_ end of cond 
      ) ;_ end of foreach 
      (entmod New_field_data) 
      (vl-cmdf "_updatefield" txt "") 
      ;(while (> (getvar "CMDACTIVE") 0)(command "")) 
      (entupd txt) 
    ) ;_ end of progn 
    nil 
  ) ;_ end of if 
             ) 
          sub_field_list 
          ) 
  ) 
) ;_ end of defun










