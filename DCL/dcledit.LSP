;; 13_12_17

;;(kd:dcledtlst '("10" "LCA" "25" "CT" "001"))
;;(kd:dcledittab '(("a" "10") ("b" "LCA") ("c" "25") ("d" "CT") ("e" "001")))

(defun kd:dcledtlst (props /
		  dlgname
		  dclfilename
		  dcl-file-path			; путь к dcl-файлу для проги (в папку temp)
		  hand					; ручка этого файла
		  dcl_id
		  i
		  lst
		     kd:dcledtlst_done
		  )
  (setq dlgname "kd_dcledt")
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  ;-----------------------------------------------------------
  (defun kd:dcledtlst_done ( / lst i)
    (setq lst '() i 0)
    (repeat (length props)
      (setq lst (append lst (list (get_tile (strcat "key" (itoa i))))))
      (setq i (1+ i))
      )
    (done_dialog)
    lst
    );defun
  ;-----------------------------------------------------------  

  ;;;;*******************************************************************

  (setq dcl-file-path (strcat (getenv "temp") dclfilename)
	hand (open dcl-file-path "w"))
  
  ;;; генерация dcl-файла
  (mapcar '(lambda (x) (write-line x hand))
	  (list
	    dlgname
	    ": dialog"
	    "{label=\"kakt00z dcl edit window\";"
	    ;"width=80;"
	    ))
    
  (setq i 0)
  (repeat (length props)
    (write-line (strcat
		  ":edit_box"
		  "{"
		  	"value=\"" (nth i props) "\";"
		  	"key=\"" (strcat "key" (itoa i)) "\";"
		  	;"edit_width=20;"
		  	"allow_accept=true;"
		  	(if (= i 0) "active=true;" "")
		  "}")
      hand)
    (setq i (1+ i))
    );repeat
  (mapcar '(lambda (x) (write-line x hand))
	  '(
	    ":spacer{width=1;}"
	    "ok_cancel;"
	    "}"
	    ))
  (close hand)
  ;;;;*******************************************************************
  
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0)
	  (not (new_dialog dlgname dcl_id)))
    (exit)
    ) ;if

  (action_tile "accept"		"(setq lst (kd:dcledtlst_done))")
  ;(action_tile "is_default"	"(setq lst (kd:dcledtlst_done))")
  (action_tile "cancel" 	"(done_dialog 0)")
  (start_dialog)
  (unload_dialog dcl_id)
  lst
  );defun








;;(kd:dcledittab '(("a" "10") ("b" "LCA") ("c" "25") ("d" "CT") ("e" "001")))
;(setq data '(("a" "10") ("b" "LCA") ("c" "25") ("d" "CT") ("e" "001")))
;(setq data '(("project-number" "1747-1-АТМ1") ("object-name1" "Теплоснабжение жилой застройки \"Фолюш\" и \"Колбасино\".") ("object-name2" "Строительство насосной станции ПНС-Ф") ("object-name3" "на обратном трубопроводе по ул. Окульная в г. Гродно") ("project-name1" "Понизительная насосная станция") ("project-name2" "") ("project-name3" "КИП и А")) )

;(kd:dcledittab '(("a" " sd  \"fb\" ")))


(defun kd:dcledittab
       (data /
	names
	props
	dlgname
	dclfilename
	dcl-file-path			; путь к dcl-файлу для проги (в папку temp)
	hand					; ручка этого файла
	dcl_id
	i
	lst
	kd:dcledittab_done
	)
  (setq names (mapcar 'car data))
  (setq props (mapcar 'cadr data))

  (setq props
  (mapcar
    '(lambda (x / val tail)   ;(setq x (cadr props))
       (if (vl-string-search "\"" x)
	 (progn
	   (setq val (reverse (sepstr x "\"")))
	   (setq tail (car val))
	   (setq val (mapcar '(lambda (s) (strcat s "\\\"")) (reverse (cdr val))))
	   (setq val (strcat (apply 'strcat val) tail))
	   )
	 x
	 )
       )
    props)
	)
  
  (setq dlgname "kd_dcledittab")
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  ;-----------------------------------------------------------
  (defun kd:dcledittab_done ( / lst i)
    (setq lst '() i 0)
    (repeat (length props)
      (setq lst (append lst (list (get_tile (strcat "key" (itoa i))))))
      (setq i (1+ i))
      )
    (done_dialog)
    lst
    );defun
  ;-----------------------------------------------------------  

  ;;;;*******************************************************************

  (setq dcl-file-path (strcat (getenv "temp") dclfilename)
	hand (open dcl-file-path "w"))
  
  ;;; генерация dcl-файла
  (mapcar '(lambda (x) (write-line x hand))
	  (list
	    dlgname
	    ": dialog"
	    "{label=\"kakt00z dcltab edit window\";"
	    ;"width=80;"
	    ;"children_fixed_width=true;"
	    ))
    
  (setq i 0)
  (repeat (length props)
    (write-line (strcat
		  ":edit_box"
		  "{"
		  	"label=\"" (nth i names) "\";"
		  	"value=\"" (nth i props) "\";"
		  	"key=\"" (strcat "key" (itoa i)) "\";"
		  	"edit_width=40;"
		  	"allow_accept=true;"
		  	(if (= i 0) "active=true;" "")
		  "}")
      hand)
    (setq i (1+ i))
    );repeat
  (mapcar '(lambda (x) (write-line x hand))
	  '(
	    ":spacer{width=1;}"
	    "ok_cancel;"
	    "}"
	    ))
  (close hand)
  ;;;;*******************************************************************
  
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0)
	  (not (new_dialog dlgname dcl_id)))
    (exit)
    ) ;if

  (action_tile "accept"		"(setq lst (kd:dcledittab_done))")
  ;(action_tile "is_default"	"(setq lst (kd:dcledittab_done))")
  (start_dialog)
  (unload_dialog dcl_id)


  (mapcar 'list names lst)
  );defun