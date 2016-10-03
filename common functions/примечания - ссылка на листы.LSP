
(defun c:qwe ()
(vla-put-TextString
  (vlax-ename->vla-object (car (entsel)))
  (strcat
    "\t1  Монтажно-коммутационная схема см. л. "
    "%<\\AcObjProp Object(%<\\_ObjId "
    (itoa (vla-get-ObjectID (getbatt (vlax-ename->vla-object (car (entsel))) "НОМЕР_ЛИСТА")))
    ">%).TextString>%"
    ".\n\t"
    "2  УПП и гидропанели заземлить."
    )
  )
  )




(defun c:qwe ()
(vla-put-TextString
  (vlax-ename->vla-object (car (entsel)))
  (strcat
    "\t"
    "1  Общий вид см. л. "
    
    "%<\\AcObjProp Object(%<\\_ObjId "
    (itoa (vla-get-ObjectID (getbatt (vlax-ename->vla-object (car (entsel))) "НОМЕР_ЛИСТА")))
    ">%).TextString>%"
    "."
    "\n"
    "\t"
    "2  Обвязку гидропанели P1 выполнить согласно \"Руководству по монтажу и эксплуатации\" на гидропанель."
    )
  )
  )





(defun c:qwe ()
(vla-put-TextString
  (vlax-ename->vla-object (car (entsel)))
  (strcat
    "\t"
    "1  Общий вид см. л. "
    
    "%<\\AcObjProp Object(%<\\_ObjId "
    (itoa (vla-get-ObjectID (getbatt (vlax-ename->vla-object (car (entsel))) "НОМЕР_ЛИСТА")))
    ">%).TextString>%"
    "."
    "\n"
    "\t"
    "2  Обвязку гидропанели P1 выполнить согласно \"Руководству по монтажу и эксплуатации\" на гидропанель."
    )
  )
  )


