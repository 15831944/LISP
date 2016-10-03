;;;  13_08_20 - дополнено запоминание предыдущих значений
;(kd:dclget '("заголовок" "подсказка" "макрос (можно дизель)"))
;;;  14_02_28 дополнено dcl:formatstring
;;;  16_05_04 перекинул dcl:formatstring в stringlib и переназвал str|DclFormat



;(setq ans (kd:dclget '("\"заголо\"вок" "подсказка" "макрос (можно дизель)")))
;(setq props '("\"заголо\"вок" "подсказка" "макрос (можно дизель)"))
(defun kd:dclget (props /
		  propsSafeStringlIST
		  propsdcl
		  dlgname
		  dclfilename
		  dcl-file-path			; путь к dcl-файлу для проги (в папку temp)
		  hand					; ручка этого файла
		  dcl_id
		  i
		  answer
		  
		  lastInputFilename			;last input file
		  lastData				;last data
		  focusPlaced
		  )

  (setq propsdcl (mapcar 'str|DclFormat props))
  (setq propsSafeStringlIST (mapcar 'str|FilenameFormat props))
  (setq dlgname "kd_dclget")
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  (setq lastInputFilename (strcat "\\dclget-lif-" (apply 'strcat propsSafeStringlIST) ".tmp"))
  (setq lastData (rfile (strcat (getenv "temp") lastInputFilename)))
  (if (null (listp lastData)) (setq lastData nil))

  (setq dcl-file-path (strcat (getenv "temp") dclfilename) hand (open dcl-file-path "w"))
  (setq focusPlaced nil)

  ;----------------------------------------------------------------------------------------------------------
  (defun kd:dclget_done ( / result)
    (setq result (mapcar '(lambda (p) (list p (get_tile (strcat  p "_" "key")))) propsSafeStringlIST))
    (done_dialog)
    (wfile result (strcat (getenv "temp") lastInputFilename))
    result
    );defun
  ;----------------------------------------------------------------------------------------------------------


  ;;	DCL File Header
  (mapcar '(lambda (x) (write-line x hand))
	  (list
	    dlgname
	    ": dialog"
	    "{label=\"kakt00z developing dcl get properties window\";"
	    "width=80;"
	    (strcat "initial_focus=\"" "key" "0" "\";")
	    ))
  ;;	DCL File Body
  (mapcar
    '(lambda (p)
       (write-line
	 (strcat
	   ":edit_box"
	   "{"
	   	"label=\"" p "\";"
	   	"key=\"" (strcat  p "_" "key") "\";"
	   	"edit_width=50;"
	   	"value=\"" (if lastData (cadr (assoc p lastData)) "") "\";"
	   	(if (null focusPlaced) "active=true;" "")
	   	"allow_accept=true;"
	   "}")
	 hand)
       (setq focusPlaced T)
       )
    propsSafeStringlIST
    )
  
  ;;	DCL File Tail
  (mapcar '(lambda (x) (write-line x hand))
	  '(
	    ":spacer{width=1;}"
	    "ok_cancel;"
	    "}"
	    ))
  (close hand)  
  
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0) (not (new_dialog dlgname dcl_id))) (exit))
  (action_tile "accept"	"(setq answer (kd:dclget_done))")
  (action_tile "is_default" "(setq answer (kd:dclget_done))")
  (action_tile "cancel" "(done_dialog 0)")
  (start_dialog)
  (unload_dialog dcl_id)
  (mapcar 'cadr answer)
  );defun