(defun ss-stretch (
		   /
		   doc
		   ssmain
		   sssub
		   kol
		   )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		;"osmode" 0
		);list
	  T
	  );list
    );acet-error-init

  (princ "\n��� ����� ������� (�������� ���!)")
  (setq ssmain (ssget))

  (princ "\n������� ���������� ��� �������������� (������ (�����))")
  (setq sssub (ssget))
  (setq kol (/ (sslength ssmain) (sslength sssub)))


	 

  
  



  (acet-error-restore)
  (vla-endundomark doc)  
  );defun