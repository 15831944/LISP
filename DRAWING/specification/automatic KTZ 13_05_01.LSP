


����������� ���������� ���������



 xlsdata				������� xls-������� � �������� ����� ���

(foreach measuredata xlsdata

(setq measuredata '( ... )) ; - ������ �� xls-�������

(setq func (cdr (assoc "func" measuredata))) ;- ������� A �� xls-�������



(cond
  ((= func "TI")())
  ;((= func "TS")())
  ((= func "TT")(gen-paragraph measuredata)) ;;; ����� ��� ���� ������������� ���� ��������
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
  

  (T ("������������"))
  )







;; 	����� ���� ��� ���� ����� ����������,
;;	����� �������� � ��������� ���������� � �������,
;;	�������� ����������, ������� � ��������� �� ���� ������ "������������"
