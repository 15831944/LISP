;;;  13_08_20 - дополнено запоминание предыдущих значений
;(kd:dclget '("заголовок" "подсказка" "макрос (можно дизель)"))
;;;  14_02_28 дополнено dcl:formatstring
;;;  16_05_04 перекинул dcl:formatstring в stringlib и переназвал str|DclFormat



;(setq ans (kd:dclget '("\"заголо\"вок" "подсказка" "макрос (можно дизель)")))
;(setq props '("\"заголо\"вок" "подсказка" "макрос (можно дизель)"))
(defun kd:dclget (props /
		  propsdcl
		  dlgname
		  dclfilename
		  dcl-file-path			; путь к dcl-файлу для проги (в папку temp)
		  hand					; ручка этого файла
		  dcl_id
		  i
		  lst
		  lif				;last input file
		  lifr				;last input file read
		  ld				;last data
		  tmp
		  )
 
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq propsdcl (mapcar 'str|DclFormat props))

  (setq dlgname "kd_dclget")
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  (setq lif (strcat "\\dclget-lif-" (apply 'strcat (mapcar 'str|FilenameFormat props)) ".tmp"))

  ;-----------------------------------------------------------
  (defun kd:dclget_done ( / result i lifw)		; last input file write
    (setq result '() i 0)
    (repeat (length props)
      (setq result (append result (list (get_tile (strcat "key" (itoa i))))))
      (setq i (1+ i))
      )
    (done_dialog)
    (setq lifw (open (strcat (getenv "temp") lif) "w"))
    (mapcar '(lambda (x) (write-line x lifw)) lst)
    (close lifw)
    result
    );defun
  ;-----------------------------------------------------------  

  ;;;;*******************************************************************

  (setq dcl-file-path (strcat (getenv "temp") dclfilename) hand (open dcl-file-path "w"))

  (if (setq lifr (open (strcat (getenv "temp") lif) "r"))
    (progn
      (while (setq tmp (read-line lifr)) (setq ld (append ld (list tmp))))
      (close lifr)
      )
    )
  
  
  
  ;;; генерация dcl-файла
  (mapcar '(lambda (x) (write-line x hand))
	  (list
	    dlgname
	    ": dialog"
	    "{label=\"kakt00z developing dcl get properties window\";"
	    "width=80;"
	    (strcat "initial_focus=\"" "key" "0" "\";")
	    ))
    
  (setq i 0)
  (repeat (length propsdcl)
    (write-line (strcat
		  ":edit_box"
		  "{"
		  	"label=\"" (nth i propsdcl) "\";"
		  	"key=\"" (strcat "key" (itoa i)) "\";"
		  	"edit_width=50;"
		  	"value=\"" (if ld (nth i ld) "") "\";"
		  	(if (= i 0) "active=true;" "")
		  "allow_accept=true;"
		  
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
  
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0) (not (new_dialog dlgname dcl_id))) (exit))
  (action_tile "accept"	"(setq lst (kd:dclget_done))")
  (action_tile "is_default" "(setq lst (kd:dclget_done))")
  (action_tile "cancel" "(done_dialog 0)")
  (start_dialog)
  (unload_dialog dcl_id)
  lst
  );defun