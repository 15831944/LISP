;;;  ����� ��������� �� ������������

;;; ������� ����
;;; clean
(load "D:\\_LISP\\���� ����� ���������\\ktz-linereverse.lsp")
;   acad 2013 ������� MLEADERs ������� �������
(sssetfirst nil (ssget "_X" '((0 . "MULTILEADER"))))
;(sssetfirst nil (ssget "_X" '((0 . "MTEXT"))))


;;; ��������� ������� ���������, ���������
(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . "*`?*"))))
(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . "*`#*"))))
(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . "*%%�*"))))


(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . ""))))
(sssetfirst nil (ssget "_X" '((0 . "*TEXT,MULTILEADER") (1 . " "))))
;��������� ����� �������

;��������� ���� � �������� �� ������� ����� ���� 231,125,215
;(vla-get-color (vlax-ename->vla-object (car (entsel))))
(do #cad)
;(do (vla-get-Selection (vla-get-Preferences #cad)))
;(ssget "_X" ')

;;;;; ������������������,  �� ������ - ������ -   ��� ����� !! !! !!!
(defun ssgetX ( / temp)
  (setq temp (vla-get-ActiveSelectionSet #actdoc))
  (vla-Clear temp)
  ;(vla-SelectOnScreen temp)
  (vla-Select temp acSelectionSetAll)
  (kd-container->list temp)
  )

(mapcar
  '(lambda (x)
     (vlax-put-property x "color" 7)
     )
  (ssgetX))


;(vla-get-TextString (vlax-ename->vla-object (car (entsel))))

