;;; ����, ���� ������
;;; � ������� ���� 3 ��������, 2 �� ������� ��������� �� ������
;;; �� d:\LISP WORKING\field\mkfieldgeneral.dwg


;;; ���������� ������� ���, ����� �������� ����������� ������,
;;; �.�. ������� ������� ��������-��������

;;; a<-b->c -- b - �������
;;; ������ � 1 ���� �� a ������� ���:  a->b->c (a-�������)
;;; � ����� ��������, ����� � � (��� ��������) ������� a<-b<-c (�-�������)


;;;!!!!!!!!! ������ ������

(setq obj (vlax-ename->vla-object (car (nentsel))))

(do obj)

(vla-FieldCode (vlax-ename->vla-object (car (nentsel))))
(vla-FieldCode obj)




(defun fld-setmain ( / obj)
  (setq obj (vlax-ename->vla-object (car (nentsel))))
  (if (isfield obj)
    (fld-reverse obj)
    )
  )

(defun fld-reverse (objm / IDd objd str)
  (setq str (vla-get-textstring objm))
  (setq IDd (getfldID objm))
  (setq objd (vla-ObjectIdToObject #actdoc (atoi IDd)))
  ;(delete-field objm)
  (if (isfield objd)
    (fld-reverse objd)
    (progn
      (vla-put-textstring objd (strcat
		"%<\\AcObjProp Object(%<\\_ObjId "
		(itoa (vla-get-ObjectID objm))
		">%).TextString>%"))
      ;(delete-field objm)
      (vla-put-textstring objm str)
      )
    )
  );defun



(defun getfldID (obj / fc)
  ;(setq obj (vlax-ename->vla-object (car (nentsel))))
  ;(setq str (vla-get-textstring obj))
  (setq fc (substr (vla-FieldCode obj) (1+ (vl-string-search "%<\\Ac" (vla-FieldCode obj)))))
  (vl-string-right-trim ">%).TextString>%"
    (vl-string-left-trim "%<\\AcObjProp Object(%<\\_ObjId " fc)
    )
  );defun
;(getfldID (vlax-ename->vla-object (car (nentsel))))




(defun isfield (obj)
  (and
    (vlax-method-applicable-p obj 'FieldCode) ;_���� ����� FieldCode
    (setq fc (vlax-invoke obj 'FieldCode))
    (vl-string-search "%<\\Ac" fc)
    (vl-string-search ">%" fc)
    )
  );defun