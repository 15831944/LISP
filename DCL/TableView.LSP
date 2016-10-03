(setq tbl (db|formatdata (excel>lst)))



(defun dcl|tableView ( /
		      dlgname
		      dclFpath
		      dclFhand
		      dlgID

		      dcl:expl|UpdateList
		      dcl:expl|UpdateTable
		      dcl:expl|ok_pressed
		      dcl:expl|enter_pressed
		      dcl:expl|cancel_pressed
		      )
  (setq dlgname "tableView")
  (setq dclFpath (strcat (getenv "temp") (strcat "\\" dlgname ".dcl")) dclFhand (open dclFpath "w"))
  (mapcar
    '(lambda (x) (write-line x dclFhand))
    (list
      dlgname ": dialog"
      "{label=\"kakt00z (c) DCLgen window\";"
      "fixed_width_font=true;"
      "width=150;"
      ":text{label=\"label\";key=\"infokey\";}"
      ":row{"
      )
    )
  (foreach item (car tbl)
    (mapcar
      '(lambda (x) (write-line x dclFhand))
      (list
	":list_box{"
	(strcat "label=\"" item "\";")
	(strcat "key=\"" item "\";")
	(strcat "list=\"\";")
	"height=50;"
	"fixed_width_font=true;"
	;"multiple_select=true;"
      	;"allow_accept=true;"
      	"}" ;list_box
	)
      )
    )
  (mapcar
    '(lambda (x) (write-line x dclFhand))
    (list
      "}" ;row
      ":spacer{width=1;}"
      "ok_cancel;"
      "}" ;dialog
      ))
  (close dclFhand)
  
  (defun dcl:expl|UpdateList (key data) (start_list key) (mapcar 'add_list data) (end_list))
  (defun dcl:expl|UpdateTable ()
    (mapcar
      '(lambda (tag)
	 (dcl:expl|UpdateList tag (cdr (assoc tag (db|transmat tbl))))
	 )
      (car tbl)
      )
    )
  (defun dcl:expl|ok_pressed ()
    (done_dialog)
    (princ
      ;(strcat "\nOk-Button-Pressed" (itoa (setq c (1+ c))) "\n")
      )
    )
  (defun dcl:expl|enter_pressed ()
    (done_dialog)
    (princ
      ;(strcat "\nEnter-Pressed" (itoa (setq c (1+ c))) "\n")
      )
    )
  (defun dcl:expl|cancel_pressed ()
    (done_dialog 0)
    )

  (if (or (< (setq dlgID (load_dialog dclFpath)) 0) (not (new_dialog dlgname dlgID))) (exit))

  
  ;(setq obj (vla-get-Dictionaries #actdoc))
  ;(setq cont:data (dcl:expl|cont>list obj))
  ;(dcl:expl|UpdateList "listboxkey" (cons ".." (dcl:expl|gen-listvals cont:data)))
  (dcl:expl|UpdateTable)
  
  ;(action_tile "listboxkey"		"(dcl:expl|list_action)")
  (action_tile "accept"			"(dcl:expl|ok_pressed)")
  (action_tile "is_default"		"(dcl:expl|enter_pressed)")
  (action_tile "cancel" 		"(dcl:expl|cancel_pressed)")
  
  (start_dialog)
  ;(done_dialog)
  (unload_dialog dlgID)
  ;(if result (nth (atoi result) items) nil)
  );defun