
(defun c:qwe ()
(vla-put-TextString
  (vlax-ename->vla-object (car (entsel)))
  (strcat
    "\t1  ��������-�������������� ����� ��. �. "
    "%<\\AcObjProp Object(%<\\_ObjId "
    (itoa (vla-get-ObjectID (getbatt (vlax-ename->vla-object (car (entsel))) "�����_�����")))
    ">%).TextString>%"
    ".\n\t"
    "2  ��� � ����������� ���������."
    )
  )
  )




(defun c:qwe ()
(vla-put-TextString
  (vlax-ename->vla-object (car (entsel)))
  (strcat
    "\t"
    "1  ����� ��� ��. �. "
    
    "%<\\AcObjProp Object(%<\\_ObjId "
    (itoa (vla-get-ObjectID (getbatt (vlax-ename->vla-object (car (entsel))) "�����_�����")))
    ">%).TextString>%"
    "."
    "\n"
    "\t"
    "2  ������� ����������� P1 ��������� �������� \"����������� �� ������� � ������������\" �� �����������."
    )
  )
  )





(defun c:qwe ()
(vla-put-TextString
  (vlax-ename->vla-object (car (entsel)))
  (strcat
    "\t"
    "1  ����� ��� ��. �. "
    
    "%<\\AcObjProp Object(%<\\_ObjId "
    (itoa (vla-get-ObjectID (getbatt (vlax-ename->vla-object (car (entsel))) "�����_�����")))
    ">%).TextString>%"
    "."
    "\n"
    "\t"
    "2  ������� ����������� P1 ��������� �������� \"����������� �� ������� � ������������\" �� �����������."
    )
  )
  )


