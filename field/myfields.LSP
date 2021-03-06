;���������� T ���� � ������� ���� ����
;;; obj - VLA-������
(defun isFieldAvailable ( obj  / fc )
  (and
    (vlax-method-applicable-p obj 'FieldCode) ;_���� ����� FieldCode
    (setq fc (vlax-invoke obj 'FieldCode))
    (vl-string-search "%<\\Ac" fc)
    (vl-string-search ">%" fc)
   )
)
;(isFieldAvailable (vlax-ename->vla-object (car (entsel))))



;_������� ��� ���� �� �������
;;; obj - VLA-������
;_���������� ��������� ������ � ��������� �������� ���� ��� ������ ���� ���� ��� ��� "" ���� ���� ���
;_��������� � ������� (vlax-put obj 'TextString newstr)

;(vlax-dump-object (vlax-ename->vla-object (car (entsel)))T)
(defun removeAllFieldFromObject ( obj  / fc fb fe fb1 tmp txt)
  (setq txt (vla-get-TextString obj))
  (and
    (vlax-method-applicable-p obj 'FieldCode) ;_���� ����� FieldCode
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


;_������� ����  �� ������� �� ��������� �����
;;; obj - VLA-������
;;FieldPattern - ����� ���� (������ �������� ����, ��. � ���������)
;; !! ��������� ��������, ��� ��������� \ ���������� ������� \\
;;�������� ���� ������� - %<\\AcObjProp
;���������� -  %<\\AcVar � �.�.
;_���������� ��������� ������ � ��������� ���������
;_��������� � ������� (vlax-put obj 'TextString newstr)
(defun removeSpecifyFieldFromObject ( obj FieldPattern  / fc fb fe fb1 tmp )
  (and
    (vlax-method-applicable-p obj 'FieldCode) ;_���� ����� FieldCode
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


;;�-��� ��������� � ������� ����
;; obj - VLA-������
;; FieldStr - �������������� ������ ���� (����� ��, ����� ���������� � ���� ���������
;;������� �������� �� ������������ ������ � ����������� ���� � ������ FieldStr �� ������������
;; !! ��������� ��������, ��� ��������� \ ���������� ������� \\
;;���������� T - ���� ��������� nil - ���
(defun addFieldToObj (obj FieldStr / fc)
  (and
    (vlax-write-enabled-p obj)
    (vlax-method-applicable-p obj 'FieldCode) ;_���� ����� FieldCode
    (vlax-property-available-p obj 'TextString)
    (setq fc (vlax-invoke obj 'FieldCode))
    (setq fc (strcat fc " " FieldStr))
    (vlax-put obj 'TextString fc)
    )
  )





;;====== ������� ����������� �-��� � ������ �������� �������
;_������ ������������� �-��� removeAllFieldFromObject
;_������� ��� ���� �� ������
(defun C:DEMO1 ( )
  (if (and (setq obj (car(entsel "\n����� ����� ��� �������� �����: ")))
           (wcmatch (cdr(assoc 0 (entget obj))) "*TEXT")
           (setq obj (vlax-ename->vla-object obj))
           (vlax-write-enabled-p obj)
           )
    (vla-put-TextString obj (removeAllFieldFromObject obj))
    )
  (princ)
  )
;_������ ������������� �-��� removeSpecifyFieldFromObject
;_������� ������������ ���� �� ������
(defun C:DEMO2 ( )
  (if (and (setq obj (car(entsel "\n����� ����� ��� �������� ����� %<\\AcVar: ")))
           (wcmatch (cdr(assoc 0 (entget obj))) "*TEXT")
           (setq obj (vlax-ename->vla-object obj))
           (vlax-write-enabled-p obj)
           )
    (vla-put-TextString obj (removeSpecifyFieldFromObject obj "%<\\AcVar"))
    )
  (princ)
  )
;;������ ������������� �-��� addFieldToObj
;���������� ���� ����
;;��������, ������ ��� � ���� ���� �� �������������
(defun C:DEMO3 ( )
  (if (and (setq obj (car(entsel "\n����� ����� ��� ������ ����: ")))
           (wcmatch (cdr(assoc 0 (entget obj))) "*TEXT")
           (setq obj (vlax-ename->vla-object obj))
           (vlax-write-enabled-p obj)
           )
    (addFieldToObj obj "%<\\AcVar Date \\f \"yyyy-MM-dd\">%")
    )
  (princ)
  )
;_������ ������� ������ �������� ������������� ����� � �����
;_�������� ���� ����� � ������������� ��������� N �� �����
(defun c:DEMO4 ( / oldpre newpre obj fc newstr)
(princ "\n������ �������� ������������� ����� � �����")
(initget 1)
(setq newpre (getint "\n����� ��������: "))
(if (and
      (setq obj (car (entsel "\n������� �����, ���������� ���� : ")))
      (setq obj (vlax-ename->vla-object obj))
      (vlax-method-applicable-p obj 'FieldCode)
      (vlax-write-enabled-p obj)
      )
  (progn
    (setq fc (vlax-invoke obj 'FieldCode)) ;_�������� ����� + ����
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
;���� ����� ������ ���������� � ��������� ������ AutoCAD ID ���������,
;�� ����� ��������������� � ����� ��������:
(defun C:EID ( / )
(vl-load-com)
(vla-get-objectid (vlax-ename->vla-object (car (entsel))))
)
;��� - ����� ����� ��������� ������ ����� ���� ��� �����
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





;;;�������������: 
;;;������ 2 ������� ������ ����� � � B 
;;;������� ����� � ����� �� ����� ������� A 
;;;��������� DEMO5 
;;;� ������� "Select old object" ��������� ������� A 
;;;� ������� "Select new object:" ��������� ������� B 
;;;� ������� "Select text:" ��������� ����� � ����� 
;;;������� ��������� 
(defun C:DEMO5 () 
  (vl-load-com) 
  (and 
   (setq oldobjID (car(entsel "\nSelect old object:"))) 
   (setq newobjID (car(entsel "\nSelect new object:"))) 
   (setq txt (car(nentsel "\nSelect text:"))) 
   (change_owner_in_field oldobjID newobjID txt) 
) 
) 

(defun change_owner_in_field ;_�-��� �������� ��������� � ���� 
                             (oldobjID ;_ ������ �������� ENAME 
                              newobjID ;_ ����� ��������   ENAME 
                              txt ;_ ��������� ���� (����� ��� �������) ENAME, 
                                  ;_ ������������ nentsel 
                              /           dict ;_ ������� ��������� ���� 
                              field ;_ ������� ������ ���� 
                              field_data ;_ �������� ���� (entget field) 
                              New_field_data ;_����� ������ ��� entmod 
                              property ;_ �������� �������� ������� � ���� 
                             ) 
;_ �-��� �������� ��������� � ���� 
;_ ��������� 
;_   oldobjID - ��� ��������� ������� ��������� ID [ENAME] 
;_   newobjID - ��� ��������� ������ ��������� ID [ENAME] 
;_ Return 
;_ T - ���� ��������� 
;_ nil -��� 
;;;!!! �����: ����� �������� ������ �������� ���������, ������������ � ���� 

  (and 
  (setq dict (cdr (assoc 360 (entget txt)))) ;_Ename Dictionary ������� ��������� 
  (setq dict 
         (cdr (assoc 360 (member '(3 . "ACAD_FIELD") (entget dict)))) 
  ) ;_Enable Field Dictionary ���� ���� � ������� 
  (setq field (cdr (assoc 360 (member '(3 . "TEXT") (entget dict))))) ;_ Field Record ������ ���� 
  ;_Sub Field Records ��������� ������ ����� 
  (setq sub_field_list (mapcar 'cdr (vl-remove-if '(lambda(x)(/= (car x) 360))(entget field)))) 
    ;(setq field (cdr (assoc 360 (entget field)))) ;_Sub Field Record ��������� ������ ���� 
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










