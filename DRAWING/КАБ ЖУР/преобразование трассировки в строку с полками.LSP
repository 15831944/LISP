


; ������ ��� ����� ���� :
; ����� (1)  -  �����
;   2  7 7� 6 12 13 15
; �����
; "7; 7�; 6; 12; 13; 15 (2)"

(setq lst (excel>lst))



(setq ans
(mapcar
  '(lambda (line / sh)	;(setq line (nth 0 lst))     (setq line (nth 250 lst))	(setq line (nth 2 lst))
     (if (= (setq sh (car line)) "")
       (antisep (vl-remove '"" (cdr line)) "; ")
       (strcat (antisep (vl-remove '"" (cdr line)) "; ") " (" sh ")")
       )
     )
  lst)
      )

(lst>excel (mapcar 'list ans))