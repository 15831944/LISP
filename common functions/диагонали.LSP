
;;;; ����� ������ ��� ������ � ������� ���� ����� ��������
;(setq lst '(a b c d))

(defun symbollinks (lst)
  (mapcar 'list
	  lst
	  (append (cdr lst) (list (car lst)))
	  )
  )

;(symbollinks lst)
;((A B) (B C) (C D) (D A)) 