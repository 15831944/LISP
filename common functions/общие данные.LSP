;; 13_04_24
;;;; ������ � ������ �������.... � �� ���� � ������� � �����������


(defun getodlist ( / ss)
  ;(setq ss (ss->lsto* (ssget "_X" '((0 . "INSERT")))))
  (if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
    (setq ss (ssget '((0 . "INSERT"))))
    );if
  (setq ss (ss->lsto* ss))
  
  ;(setq ss (vl-remove-if-not '(lambda (x)(= "��_format" (vla-get-EffectiveName x))) ss))
  (setq ss (vl-remove-if-not '(lambda (x)(= "format" (vla-get-EffectiveName x))) ss))
  
  (setq ss (vl-sort ss '(lambda (a b) (<
	(atoi (vla-get-textstring (getbatt a "�����_�����")))
	(atoi (vla-get-textstring (getbatt b "�����_�����")))
	))))
  
  (setq ss (mapcar '(lambda (x)
		      (list
			(vla-get-textstring (getbatt x "�����_����"))
			(vla-get-textstring (getbatt x "�����_�����"))
			(str:antimtext (strcat
				(vla-get-textstring (getbatt x "������1"))
				" "
				(vla-get-textstring (getbatt x "������2"))
				" "
				(vla-get-textstring (getbatt x "������3"))))
			;x ;��� ����� �������� ����� �������� ����������� �����
			))	
		   ss))
  );defun


(setq lst (getodlist))
(lst>excel lst)




  (defun tbl|addtext (str pt / txtobj)
    (setq txtobj (vla-Addtext #modspace
		   str
		   (vlax-3d-point '(0 0 0))
		   2.5
		   ))
    (vla-put-Alignment txtobj 10)
    (vla-put-TextAlignmentPoint txtobj (vlax-3d-point pt))
    txtobj
    );defun
  
  (defun tbl|addmtext (str pt wdth alp / txtobj)
    (setq txtobj (vla-AddMtext #modspace
		   (vlax-3d-point pt)
		   wdth
		   str))
    (vla-put-AttachmentPoint txtobj alp)
    (vla-put-LineSpacingStyle txtobj acLineSpacingStyleExactly)
    (vla-put-Height txtobj 2.5)
    (vla-put-LineSpacingDistance txtobj 8)
    txtobj
    );defun


(load (strcat #lisppath "TEXT & MTEXT\mtxtlib.lsp"))



;;;
;;;  (spc|addmtext (strcat "��� \"�����\"" "\n" "�. ������") '(227 -3.0724 0) 41 2)
;;;  (spc|addtext  "��." '(280 -4 0))
;;;  (spc|addtext  (itoa kol) '(300 -4 0))
;;;  (spc|addmtext "������" '(337 -3.0724 0) 36 1)



(setq bpt (getpoint "\n....Pick an upper left coner of fill area of the table"))
(mapcar '(lambda (line / mtxtobj)
	   (tbl|addtext
	     (cadr line)
	     (mapcar '+ bpt '(7.5 -4 0))
	     )
	   (setq mtxtobj
		  (tbl|addmtext
		    (caddr line)
		    (mapcar '+ bpt '(17 -3 0))
		    137 1 ))
	   (setq bpt (mapcar '+ bpt (list 0 (* -8 (mtxt:getnumberoflines mtxtobj)) 0)))
	   )lst)
