





(sssetfirst nil (ssget '((1 . "*##@@@##@@###*"))))




(defun str|CodeExtraction (str)
  ; ����������� ��������� ������������������ � cond
  (cond
    ;�������, �������
    ((wcmatch str (strcat "*" "##@@@##@@###-@@##" "*"))
     "�������, �������"
     )
    ((wcmatch str (strcat "*" "##@@@##@@###-@##" "*"))
     "�������, �������"
     )
    ((wcmatch str (strcat "*" "##@@@##@@###-@@#" "*"))
     "�������, �������"
     )

    ;���������� �����������
    ((wcmatch str (strcat "*" "##@@@##@@###-@#" "*"))
     "���������� �����������"
     )
    ((wcmatch str (strcat "*" "##@@@##@@###-#" "*"))
     "���������� �����������"
     )
    ((wcmatch str (strcat "*" "##@@@##@@###-@" "*"))
     "���������� �����������"
     )
    
    ;��������
    ((wcmatch str (strcat "*" "##@@@##@@###" "*"))
     "��������"
     )
    ;������
    ((wcmatch str (strcat "*" "##@@@##-####" "*"))
     "������"
     )
    ;�����
    ((wcmatch str (strcat "*" "##@@@##" "*"))
     ";�����"
      )
    )
  );defun


(defun c:asd ()
(str|CodeExtraction (kd-get-textstring (vlax-ename->vla-object (car (nentsel)))))
  )