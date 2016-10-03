;;;  13_08_20 - дополнено запоминание предыдущих значений
;(kd:dclget '("заголовок" "подсказка" "макрос (можно дизель)"))
;;;  14_02_28 дополнено dcl:formatstring



;(kd:dclget '("\"заголо\"вок" "подсказка" "макрос (можно дизель)"))
;(setq props '("\"заголо\"вок" "подсказка" "макрос (можно дизель)"))

;(setq question "are you sure?")
;(dcl|YN "are you sure?")
(defun dcl|YN (question
	       /
	       dlgname
	       dclfilename
	       dclfullpath
	       hand
	       dcl_id
	       res
	       )
  (defun dcl:formatstring (str / val tail)
    (if (vl-string-search "\"" str)
	 (progn
	   (setq val (reverse (sepstr str "\"")))
	   (setq tail (car val))
	   (setq val (mapcar '(lambda (s) (strcat s "\\\"")) (reverse (cdr val))))
	   (setq val (strcat (apply 'strcat val) tail))
	   )
	 str
	 )
    );defun
  (setq dlgname "kd_dclYN")
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  ;-----------------------------------------------------------
  (defun kd:dclget_done ()
    (done_dialog)
    );defun
  ;-----------------------------------------------------------  

  ;;;;*******************************************************************

  (setq dclfullpath (strcat (getenv "temp") dclfilename) hand (open dclfullpath "w"))

  
  
  
  
  ;;; генерация dcl-файла
  (mapcar
    '(lambda (x)
       (write-line x hand)
       )
    (list
      dlgname ": dialog"
      "{label=\"kakt00z developing dcl get properties window\";"
      (strcat
	":paragraph{"
	":text_part{label=\"" question "\";}"
	"}"
	)
      )
    )
    
  
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

  (action_tile "accept"		"(setq res (kd:dclget_done))")
  (action_tile "is_default"	"(setq res (kd:dclget_done))")
  (action_tile "cancel" 	"(done_dialog 0)")
  (start_dialog)
  (unload_dialog dcl_id)
  (and res)
  );defun