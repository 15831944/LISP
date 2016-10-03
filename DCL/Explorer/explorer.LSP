;(load (strcat #lisppath "DataBase\\dblib.lsp"))
;(load (strcat #lisppath "strings\\stringlib.lsp"))
;(load (strcat #lisppath "Excel\\xlsformatlib.LSP"))

;(length lst)




;(setq obj (vla-get-Database #actdoc))
;(setq obj (vla-get-Dictionaries #actdoc))
;(setq obj (vla-get-Blocks #actdoc))
(setq obj (vla-get-Dictionaries #actdoc))
;(setq obj exd)
(dcl|listing)

(defun dcl|listing (
		    /
		    ;obj
		    cont:data
		    
		    dlgname
		    dclFpath			; путь к dcl-файлу для проги (в папку temp)
		    dclFhand					; ручка этого файла
		    dlgID

		    windowwidth
		    strlist
		    i
		    result
		    
		    )
  
(defun dcl:expl|cont>list (obj / res a b)
  (cond
    (
     ;(and (vlax-property-available-p obj "Count") (vlax-method-applicable-p obj "Item"))
     ;(= "AcDbDictionary" (vla-get-ObjectName obj))
     (member (vla-get-ObjectName obj) '("AcDbDictionary" "AcDbBlockTable" "AcDbBlockTableRecord"))
     (setq res '() i (1- (vla-get-Count obj)))
     (while (>= i 0)
       (setq res (cons
		   (list
		     (1+ i)
		     (if (vlax-property-available-p (vla-item obj i) "ObjectName")
		       (vlax-get-property (vla-item obj i) "ObjectName")
		       ""
		       )
		     (if (vlax-property-available-p (vla-item obj i) "Name")
		       (vlax-get-property (vla-item obj i) "Name")
		       ""
		       )
		     (if (vlax-property-available-p (vla-item obj i) "Count")
		       (vlax-get-property (vla-item obj i) "Count")
		       -1
		       )
		     )
		   res))
       (setq i (1- i))
       )
     )
    ((= "AcDbXrecord" (vla-get-ObjectName obj))
     (vla-GetXRecordData obj 'a 'b)
     (setq b (mapcar '(lambda (x) (vlax-variant-value x)) (vlax-safearray->list b)))
     (setq res (list (list 0 (vla-get-ObjectName obj) (antisep (cons (vla-get-name obj) b) " ") -1)))
     )
    (T
     (setq b (entget (vlax-vla-object->ename obj)))
     (setq a (list
	       (cond ((assoc 0 b) (cdr (assoc 0 b))) (T ""))
	       (cond ((assoc 1 b) (cdr (assoc 1 b))) (T ""))
	       (cond ((assoc 2 b) (cdr (assoc 2 b))) (T ""))
	       ))
     (setq res (list (list "#" (vla-get-ObjectName obj) (antisep a " ") "#")))
     )
    )
  res
  );defun


(defun dcl:expl|gen-listvals (lst / tostr)
  (cond
    (T
     (mapcar
       '(lambda (line)
	  (strcat
	    (str|fixedwidth (any-to-string (nth 0 line)) 5)
	    (str|fixedwidth (any-to-string (nth 1 line)) 22)
	    (str|fixedwidth (any-to-string (nth 2 line)) 50)
	    (str|fixedwidth (any-to-string (nth 3 line)) 4)
	    )
	  )
       lst)
     )
    )
  );defun
  



  
  (setq dlgname "listing")	; must NOT contain "-"
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun dcl:expl|format-string-quotes (str / val tail)
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
  ;;;;*******************************************************************
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
      ":list_box{"
      	(strcat "label=\""
		(str|fixedwidth "ID" 5)
		(str|fixedwidth "ObjName" 40)
		(str|fixedwidth "Name" 25)
		(str|fixedwidth "Count" 6)
		"\";" )
      	(strcat "key=\"listboxkey\";")
      	(strcat "list=\"\";")
      	"height=50;"
      	"fixed_width_font=true;"
      	;"multiple_select=true;"
      	;"allow_accept=true;"
      	"}" ;list_box
      "}"
      ":spacer{width=1;}"
      "ok_cancel;"
      "}" ;dialog
      ))
  (close dclFhand)
  ;;;;*******************************************************************


  (defun dcl:expl|UpdateList (key data) (start_list key) (mapcar 'add_list data) (end_list))
  ;-----------------------------------------------------------
  ;----- функции обработки нажатий ---------------------------
  ;-----------------------------------------------------------
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
  (defun dcl:expl|list_action ( / tile owner)
    ;(princ (strcat "\nList-Action-Pressed" (itoa (setq c (1+ c)))))
    ;(set_tile "infokey" (get_tile "listboxkey"))
    ;(princ (strcat "\n" "reason = " (itoa $reason) " | List-Action-Pressed = " (nth (atoi (get_tile "listboxkey")) arglst) " | " (itoa (setq c (1+ c))) "\n"))

    (cond
      ((= 4 $reason)
       (setq tile (atoi (get_tile "listboxkey")))
       (cond
	 ((= 0 tile)
	  (setq owner (vla-get-OwnerID obj))
	  (cond
	    ((= 0 owner) (princ))
	    (T
	     (setq obj (vla-ObjectIDToObject #actdoc owner))
	     (setq cont:data (dcl:expl|cont>list obj))
	     (dcl:expl|UpdateList "listboxkey" (cons ".." (dcl:expl|gen-listvals cont:data)))
	     )
	    )
	  )
	 (T
	  (setq obj (vla-item obj (1- tile)))
	  (setq cont:data (dcl:expl|cont>list obj))
	  (dcl:expl|UpdateList "listboxkey" (cons ".." (dcl:expl|gen-listvals cont:data)))
	  )
	 )
       )
      );cond
    )
    
  
  ;-----------------------------------------------------------  


  
  (if (or (< (setq dlgID (load_dialog dclFpath)) 0) (not (new_dialog dlgname dlgID))) (exit))
 
  
  (setq cont:data (dcl:expl|cont>list obj))
  (dcl:expl|UpdateList "listboxkey" (cons ".." (dcl:expl|gen-listvals cont:data)))
  (action_tile "listboxkey"		"(dcl:expl|list_action)")
  (action_tile "accept"			"(dcl:expl|ok_pressed)")
  (action_tile "is_default"		"(dcl:expl|enter_pressed)")
  (action_tile "cancel" 		"(dcl:expl|cancel_pressed)")
  
  (start_dialog)
  ;(done_dialog)
  (unload_dialog dlgID)
  ;(if result (nth (atoi result) items) nil)
  );defun



(dcl|listing)

