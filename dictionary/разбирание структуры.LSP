(setq eo (vlax-ename->vla-object (car (entsel))))
(vlax-dump-object eo T)	

(vlax-dump-object 
(setq edofeo (vla-GetExtensionDictionary eo))
T)


(setq safar-atts
(vlax-variant-value
  (setq attvar (vla-GetAttributes eo))
))

(vlax-dump-object 
(nth 0 (vlax-safearray->list safar-atts))
T)


(vlax-dump-object 
(vla-GetName edofeo)
T)

;Коллекция всех словарей чертежа.
(vlax-dump-object 
(setq all-dicts (vla-get-dictionaries active_document))
T)
; IAcadDictionaries: Коллекция всех словарей чертежа.
; Значения свойств:
;   Application (RO) = #<VLA-OBJECT IAcadApplication 00d74d3c>
;   Count (RO) = 15
;   Document (RO) = #<VLA-OBJECT IAcadDocument 01b51550>
;   Handle (RO) = "C"
;   HasExtensionDictionary (RO) = -1
;   ObjectID (RO) = 2125261920
;   ObjectName (RO) = "AcDbDictionary"
;   OwnerID (RO) = 0
; Поддерживаемые методы:
;   Add (1)
;   Delete ()
;   GetExtensionDictionary ()
;   GetXData (3)
;   Item (1)
;   SetXData (2)

(entget (vlax-vla-object->ename all-dicts))
;;;((-1 . <Имя объекта: 7eacec60>)
;;;  (0 . "DICTIONARY") (5 . "C")
;;;  (102 . "{ACAD_XDICTIONARY") (360 . <Имя объекта: 6df0a090>)
;;;  (102 . "}") (330 . <Имя объекта: 0>)
;;;  (100 . "AcDbDictionary") (280 . 0) (281 . 1)
;;;  (3 . "ACAD_COLOR") (350 . <Имя объекта: 7eacedd8>)
;;;  (3 . "ACAD_FIELDLIST") (350 . <Имя объекта: 7d54cb50>)
;;;  (3 . "ACAD_GROUP") (350 . <Имя объекта: 7eacec68>)
;;;  (3 . "ACAD_LAYOUT") (350 . <Имя объекта: 7eacecd0>)
;;;  (3 . "ACAD_MATERIAL") (350 . <Имя объекта: 7eacedd0>)
;;;  (3 . "ACAD_MLEADERSTYLE") (350 . <Имя объекта: 7d54c0a8>)
;;;  (3 . "ACAD_MLINESTYLE") (350 . <Имя объекта: 7eacecb8>)
;;;  (3 . "ACAD_PLOTSETTINGS") (350 . <Имя объекта: 7eacecc8>)
;;;  (3 . "ACAD_PLOTSTYLENAME") (350 . <Имя объекта: 7eacec70>)
;;;  (3 . "ACAD_SCALELIST") (350 . <Имя объекта: 7d54c060>)
;;;  (3 . "ACAD_TABLESTYLE") (350 . <Имя объекта: 7eacee30>)
;;;  (3 . "ACAD_VISUALSTYLE") (350 . <Имя объекта: 7eacef78>)
;;;  (3 . "ACDB_RECOMPOSE_DATA") (350 . <Имя объекта: 7d54c1a8>)
;;;  (3 . "AcDbVariableDictionary") (350 . <Имя объекта: 7eaced70>)
;;;  (3 . "MCS_STREAM_DICT") (350 . <Имя объекта: 7d54cc48>)) 


(vlax-dump-object 
(vla-item all-dicts 0)
T)




(setq blo (vlax-ename->vla-object (car (entsel))))

(vlax-dump-object 
blo
T)
;;;*******************************************************************************************
(setq obj (vlax-ename->vla-object (car (entsel))))
; #<VLA-OBJECT IAcadLine Ob858eb<3>
(regapp "ktz")
;_ регистрируем приложение

(vla-setXData obj
  
  (vlax-safearray-fill
    (vlax-make-safearray vlax-vbInteger '(0 . 2))
    '(1001 1000 1010)
    );fill
  (vlax-safearray-fill
    (vlax-make-safearray vlax-vbVariant '(0 . 2))
    '("ktz" "описание" 12.34)
    );fill
  )

;;;*******************************************************************************************


(setq obj (vlax-ename->vla-object (car (entsel))))

(vlax-dump-object
  (setq obj
  (vla-get-activedocument
    (vlax-get-acad-object)
    ))
T)
(setq obj active_document)

(vla-AddAttribute
  obj
  20
  acAttributeModeNormal
  "Test"
  (vlax-3D-point (getpoint))
  "MYATR"
  "Any string")


;;;*******************************************************************************************



(setq obj (vlax-ename->vla-object (car (entsel))))

(vlax-dump-object obj T)



(vla-getXData obj "app1" 'XDataType 'XDataValue)
;;;  XDataType, XDataValue -safearraies

(vlax-safearray->list XDataType)
(setq tmpvars (vlax-safearray->list XDataValue))
(mapcar 'vlax-variant-value tmpvars)


;(cdadr (assoc -3 (entget (car (entsel)) '("app1"))))







;;;(entget (namedobjdict))
;;;(vlax-dump-object
;;;  (setq o-maindict (vlax-ename->vla-object (namedobjdict)))
;;;  T)
;;;(setq i 0)
;;;;1-15
;;;(vlax-dump-object (vla-item o-maindict 7) T)



(vlax-dump-object
  (setq o-mainblock (vlax-ename->vla-object (car (entsel))))
  T)
(vlax-dump-object
(setq ed (vla-GetExtensionDictionary o-mainblock))
  T)
(vlax-dump-object ed T)
(vlax-dump-object (vla-item ed 1) T)
