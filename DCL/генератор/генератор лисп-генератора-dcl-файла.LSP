;;; �������� 10_04_27
;;; ��������� lisp-����, ������������� dcl-���� � ����� Windows\Temp
;;; 
;;; ������������ ��� ���������� ���� �� �4 ������
;;; -kakt00z-�  �


(defun c:qwe (
	      /
	      sdclf		;;; �������� - ���� dcl
	      ch
	      cdclf		;;; ������������ lisp-����
	      folder
	      generated-dcl
	      )
  (vl-load-com)
  (setq folder "d:\\LISP WORKING\\DCL\\���������\\")
  ;(setq folder (strcat (getenv "temp") "\\"))
  (setq generated-dcl "file.dcl")
  
  (setq sdclf (open (strcat folder "sourcedcl.dcl") "r")
	cdclf (open (strcat folder "code-dcl.lsp") "w"))

  ;;;������ lisp-�����

  (write-line "(vl-load-com)" cdclf)
  (write-line (strcat
		"(setq dclfile (strcat (getenv \"temp\") \"\\\\"
		generated-dcl
		"\")"
		);strcat
    cdclf)
  (write-line "hand	(open dclfile \"w\"))" cdclf)
  (write-line "(foreach item" cdclf)
  (write-line "'(" cdclf)
  (write-line "" cdclf)


  (write-char 34 cdclf)
  (while (setq ch (read-char sdclf))
    (if	(= ch 34)
      ;�������
      (write-char 92 cdclf )
      ) ;if
    (write-char ch cdclf )
    ) ;while
  (close sdclf)
  
  ;;;����� lisp-�����  
  (write-char 34 cdclf)
  (write-line ")" cdclf)
  (write-line "(write-line item hand)" cdclf)
  (write-line ");foreach" cdclf)
  (write-line "(close hand)" cdclf)
  (write-line "" cdclf)
  (close cdclf)

  
  );defun