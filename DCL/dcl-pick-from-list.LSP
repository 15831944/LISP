;;; изменен 12_03_29
;;; функционал дл€ работы с наборами (selections sets)
;;; -kakt00z-Щ  ©

;;; список функций






;(setq prop '("заголовок" "подсказка" "макрос (можно дизель)"))
;(setq ans (kd:dcl:pick-from-list '("заголовок" "подсказка" "макрос (можно дизель)")))
;(kd:dcl:pick-from-list lst)

;(setq items '("asd" "as2d" "asds"))
;(kd:dcl:pick-from-list '("cabinasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfset" "clamp" "relay" "cl1" "cl2" "" "sign_type" "KKS" "mark1" "mark2" "cbl_KKS" "meas_name" "place_field" "field_name" "узел" "cab_type" "cores"))


(defun kd:dcl:pick-from-list (items /
			      dcl:formatstring
			      itemsdcl
			      dlgname
			      dclfilename
			      dcl-file-path			; путь к dcl-файлу дл€ проги (в папку temp)
			      hand					; ручка этого файла
			      dcl_id
			      windowwidth
			      strlist
			      i
			      result
			      ;c
			      )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;(setq str "\"pfuj\" sda")
  ;(dcl:formatstring str)
  ;(setq c 0)
  (defun dcl:formatstring (str / val tail)
    (cond
      ((vl-string-search "\"" str)
       (setq val (reverse (sepstr str "\"")))
       (setq tail (car val))
       (setq val (mapcar '(lambda (s) (strcat s "\\\"")) (reverse (cdr val))))
       (setq val (strcat (apply 'strcat val) tail))
       )
      ((null str) "")
      (T str)
      )
    );defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq itemsdcl (mapcar 'dcl:formatstring items))

  (setq windowwidth (min (apply 'max (mapcar '(lambda (x) (fix (* (strlen x) 1.5))) items)) 270))


  
  (setq dlgname "pick_from_lst")	; must NOT contain "-"
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  ;-----------------------------------------------------------
  (defun kd:dcl-pfl_done () (setq result (get_tile (strcat dlgname "key"))) (done_dialog))
  (defun dcl:pfl|cancel_pressed () (done_dialog))
  ;-----------------------------------------------------------  

  ;;;;*******************************************************************

  (setq dcl-file-path (strcat (getenv "temp") dclfilename)
	hand (open dcl-file-path "w"))
  
  ;;; генераци€ dcl-файла
  (mapcar '(lambda (x) (write-line x hand))
	  (list
	    dlgname
	    ": dialog"
	    "{label=\"kakt00z (c) DCLgen window\";"
	    "width=" (itoa windowwidth) ";"
	    ;;"initial_focus=\"" "key" dlgname "\";"
	    ":list_box{"
	    ;":popup_list{"
	    	(strcat "label=\"Select an item ... "  "\";" )
	    	(strcat "key=\""  dlgname "key\";")
		(strcat "list=\""
		   ;(eval (append '(strcat) (mapcar '(lambda (x) (strcat x "\\n")) itemsdcl)))		;нельз€ длинные строки
			;  заполн€ть список будем при вызове диалога
			"\";");strcat
	    	"fixed_width_font=true;"
	    	"multiple_select=true;"
	    "}"
	    ":spacer{width=1;}"
	    "ok_cancel;"
	    "}"
	    ))
  (close hand)
  ;;;;*******************************************************************


  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0) (not (new_dialog dlgname dcl_id))) (exit))
  
  (action_tile "accept"		"(kd:dcl-pfl_done)")
  ;(action_tile "is_default"	"(kd:dcl-pfl_done)")
  (action_tile "cancel" 	"(dcl:pfl|cancel_pressed)")
  ;(action_tile (strcat dlgname "key")	"(princ (strcat \"\n\" (itoa (setq c (1+ c)))))")


  (start_list (strcat dlgname "key"))
  (mapcar 'add_list items)
  (end_list)

  
  (start_dialog)
  
  
  ;(done_dialog)
  (unload_dialog dcl_id)

  (if result
    (progn
      (setq result (sepstr result " "))
      (if (= 1 (length result))
	(nth (atoi (car result)) items)
	(mapcar '(lambda (x) (nth (atoi x) items)) result)
	)
      )
    nil
    )
  
  );defun