;;;  13_08_20 - дополнено запоминание предыдущих значений
;(kd:dclget '("заголовок" "подсказка" "макрос (можно дизель)"))
;;;  14_02_28 дополнено dcl:formatstring



;(kd:dclget '("\"заголо\"вок" "подсказка" "макрос (можно дизель)"))
;(setq props '("\"заголо\"вок" "подсказка" "макрос (можно дизель)"))
(defun mldt-dcl-getstrings (/
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
  (setq propsdcl '("text" "upind" "downind"))

  (setq dlgname "MLDTgetcontent")
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  (setq lif (strcat "\\dclget-lif-" dlgname ".tmp"))

  ;-----------------------------------------------------------
  (defun kd:dclget_done ( / lst i lifw)		; last input file write
    (setq lst '() i 0)
    (repeat (length propsdcl)
      (setq lst (append lst (list (get_tile (strcat "key" (itoa i))))))
      (setq i (1+ i))
      )
    (done_dialog)
    (setq lifw (open (strcat (getenv "temp") lif) "w"))
    (mapcar '(lambda (x) (write-line x lifw)) lst)
    (close lifw)
    lst
    );defun
  ;-----------------------------------------------------------  

  ;;;;*******************************************************************

  (setq dcl-file-path (strcat (getenv "temp") dclfilename)
	hand (open dcl-file-path "w"))

  (if (setq lifr (open (strcat (getenv "temp") lif) "r"))
    (progn
      (while (setq tmp (read-line lifr))
	(setq ld (append ld (list tmp)))
	)
      (close lifr)
      )
    )
  
  (write-line (strcat dlgname ": dialog" "{label=\"kd "dlgname "\";") hand)
  (write-line ":row{" hand)

  (setq i 0)
  (write-line
    (strcat
      ":edit_box"
      "{"
      "label=\"" (nth i propsdcl) "\";"
      "key=\"" (strcat "key" (itoa i)) "\";"
      "edit_width=20;"
      "alignment=centered;"
      "value=\"" (if ld (nth i ld) "") "\";"
      (if (= i 0) "active=true;" "")
      "allow_accept=true;"
      "}")
    hand)


  (write-line ":column{" hand)
  (setq i 1)
    (write-line
    (strcat
      ":edit_box"
      "{"
      "label=\"" (nth i propsdcl) "\";"
      "key=\"" (strcat "key" (itoa i)) "\";"
      "edit_width=10;"
      "value=\"" (if ld (nth i ld) "") "\";"
      (if (= i 0) "active=true;" "")
      "allow_accept=true;"
      "}")
    hand)
  (setq i 2)
  (write-line
    (strcat
      ":edit_box"
      "{"
      "label=\"" (nth i propsdcl) "\";"
      "key=\"" (strcat "key" (itoa i)) "\";"
      "edit_width=10;"
      "value=\"" (if ld (nth i ld) "") "\";"
      (if (= i 0) "active=true;" "")
      "allow_accept=true;"
      "}")
    hand)


  (write-line "}" hand) ; end column
  (write-line "}" hand) ; end row
  
  (mapcar '(lambda (x) (write-line x hand)) '(":spacer{width=1;}" "ok_cancel;" "}"))
  (close hand)
  ;;;;*******************************************************************
  
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0)
	  (not (new_dialog dlgname dcl_id)))
    (exit)
    ) ;if

  (action_tile "accept"		"(setq lst (kd:dclget_done))")
  (action_tile "is_default"	"(setq lst (kd:dclget_done))")
  (action_tile "cancel" 	"(done_dialog 0)")
  (start_dialog)
  (unload_dialog dcl_id)
  lst
  );defun