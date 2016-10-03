


определение назначение измерений



 xlsdata				таблица xls-задания с перечнем точек КИП

(foreach measuredata xlsdata

(setq measuredata '( ... )) ; - строка из xls-задания

(setq func (cdr (assoc "func" measuredata))) ;- столбец A из xls-задания



(cond
  ((= func "TI")())
  ;((= func "TS")())
  ((= func "TT")(gen-paragraph measuredata)) ;;; короч тут наду промежуточные шаги проверки
  ((= func "TTF")(gen-nothing-leave-for-SVTU))
  ((wcmatch func "T*")())
  
  ((= func "PI")())
  ((= func "PS")())
  ((= func "PT")())
  ((wcmatch func "P*")())

  ;((= func "dPI")())
  ;((= func "dPS")())
  ;((= func "dPT")())
  ;((= func "dPTP")())
  ((= func "dPTF")())
  ((= func "dPTL")())
  ((wcmatch func "dP*")(askwhatdp))
  
  ;((= func "LI")())
  ((= func "LS")())
  ((= func "LT")())

  ;((= func "FI")())
  ;((= func "FS")())
  ((= func "FT")())
  

  (T ("неопределено"))
  )







;; 	после того как хоть чтото заработает,
;;	нужно добавить к названиям переменных и функций,
;;	особенно глобальных, префикс с указанием на этот проект "спецификация"
