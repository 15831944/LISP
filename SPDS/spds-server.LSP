

(defun kd:autoload-create-spds-server (/ reg f)
;|
* Создает указатель на сервер СПДС GraphiCS, если он установлен.
* Также импортирует dll, отвечающую именно за него.
* В случае ошибки возвращает nil
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
;Единственное требование: СПДС уже должна быть загружена. Если СОМ-сервер был успешно получен, то потом выполнить его дамп и понять, кто к чему относится - уже не проблема :)
;P.S. На версиях 5 и 6 не проверял.
;P.P.S. Если код на более новых версиях сработает корректно, можно будет задуматься о том, чтобы засунуть код в "Готовые". :)
