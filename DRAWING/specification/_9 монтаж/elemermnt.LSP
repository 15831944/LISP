

;(setq xlslines (cdr (nth 1 datazipped)))
(setq #elemer|sosudur '(
     ("��-6,3-2-" 6.3)
     ("��-6,3-4-" 6.3)
     ("��-25-2-" 25)
     ("��-40-" 40)))
(defun elemer|gen-zakaz-sosudur (xlslines / quant lst CP tmp mater)
  (setq quant (length xlslines))
  (if (= "dPTF" (xlsgpar "func" (car xlslines))) (setq quant (* 2 quant)))
  (setq mater "�")
  (setq CP (atof* (xlsgpar "P" (car xlslines))))
  (setq lst (vl-remove-if '(lambda (rang) (> CP (nth 1 rang))) #elemer|sosudur))
  (setq tmp (mapcar '(lambda (x) (nth 1 x)) lst))
  (setq tmp (assoc (car (nth (vl-position (apply 'min tmp) tmp) lst)) #elemer|sosudur))
  (list "" "����� �������������" (strcat (car tmp) mater) "" "��� \"������\"\n�. ������" "��." (rtos* kol) "" "������")
  );defun

