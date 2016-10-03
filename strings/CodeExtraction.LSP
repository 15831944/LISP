





(sssetfirst nil (ssget '((1 . "*##@@@##@@###*"))))




(defun str|CodeExtraction (str)
  ; обязательно соблюдать последовательность в cond
  (cond
    ;коробки, датчики
    ((wcmatch str (strcat "*" "##@@@##@@###-@@##" "*"))
     "коробки, датчики"
     )
    ((wcmatch str (strcat "*" "##@@@##@@###-@##" "*"))
     "коробки, датчики"
     )
    ((wcmatch str (strcat "*" "##@@@##@@###-@@#" "*"))
     "коробки, датчики"
     )

    ;маркировка потенциалов
    ((wcmatch str (strcat "*" "##@@@##@@###-@#" "*"))
     "маркировка потенциалов"
     )
    ((wcmatch str (strcat "*" "##@@@##@@###-#" "*"))
     "маркировка потенциалов"
     )
    ((wcmatch str (strcat "*" "##@@@##@@###-@" "*"))
     "маркировка потенциалов"
     )
    
    ;арматура
    ((wcmatch str (strcat "*" "##@@@##@@###" "*"))
     "арматура"
     )
    ;кабели
    ((wcmatch str (strcat "*" "##@@@##-####" "*"))
     "кабели"
     )
    ;шкафы
    ((wcmatch str (strcat "*" "##@@@##" "*"))
     ";шкафы"
      )
    )
  );defun


(defun c:asd ()
(str|CodeExtraction (kd-get-textstring (vlax-ename->vla-object (car (nentsel)))))
  )