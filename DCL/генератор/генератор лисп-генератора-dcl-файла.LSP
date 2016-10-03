;;; изменена 10_04_27
;;; генератор lisp-кода, генерирующего dcl-файл в папку Windows\Temp
;;; 
;;; использована при разработке щита БП №4 Береза
;;; -kakt00z-™  ©


(defun c:qwe (
	      /
	      sdclf		;;; источник - файл dcl
	      ch
	      cdclf		;;; генерируемый lisp-файл
	      folder
	      generated-dcl
	      )
  (vl-load-com)
  (setq folder "d:\\LISP WORKING\\DCL\\генератор\\")
  ;(setq folder (strcat (getenv "temp") "\\"))
  (setq generated-dcl "file.dcl")
  
  (setq sdclf (open (strcat folder "sourcedcl.dcl") "r")
	cdclf (open (strcat folder "code-dcl.lsp") "w"))

  ;;;начало lisp-файла

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
      ;кавычки
      (write-char 92 cdclf )
      ) ;if
    (write-char ch cdclf )
    ) ;while
  (close sdclf)
  
  ;;;конец lisp-файла  
  (write-char 34 cdclf)
  (write-line ")" cdclf)
  (write-line "(write-line item hand)" cdclf)
  (write-line ");foreach" cdclf)
  (write-line "(close hand)" cdclf)
  (write-line "" cdclf)
  (close cdclf)

  
  );defun