

(defun kd:autoload-create-spds-server (/ reg f)
;|
* ������� ��������� �� ������ ���� GraphiCS, ���� �� ����������.
* ����� ����������� dll, ���������� ������ �� ����.
* � ������ ������ ���������� nil
|;
(if (and (not #spds)
	 (setq
	   reg (vl-registry-read
		 (strcat "HKEY_CLASSES_ROOT\\CLSID\\"
			 (vl-registry-read "HKEY_CLASSES_ROOT\\McCOM.McCOMServer\\CLSID")
			 "\\LocalServer32"
			 )
		 )
	   )
	 (not
	   (vl-remove-if-not
	     (function
	       (lambda (x)
		 (wcmatch (strcase x) "SPDS_METHOD-*,SPDS_PROP-*,SPDS_CONST-*")
		 )
	       )
	     (atoms-family 1)
	     )
	   )
	 )
  ;then
  (vlax-import-type-library :tlb-filename reg
    :methods-prefix "spds_method-"
    :properties-prefix "spds_prop-"
    :constants-prefix "spds_cont-"
    )
  );if
  (if (vl-remove-if-not
	(function (lambda (x)
	    (wcmatch (strcase x) "SPDS_METHOD-*,SPDS_PROP-*,SPDS_CONST-*")
	    ))
	(atoms-family 1)
	)
    ;then
    (setq #spds (vlax-get-or-create-object "McCOM.McCOMServer"))
    )
  #spds
  )
;������������ ����������: ���� ��� ������ ���� ���������. ���� ���-������ ��� ������� �������, �� ����� ��������� ��� ���� � ������, ��� � ���� ��������� - ��� �� �������� :)
;P.S. �� ������� 5 � 6 �� ��������.
;P.P.S. ���� ��� �� ����� ����� ������� ��������� ���������, ����� ����� ���������� � ���, ����� �������� ��� � "�������". :)
