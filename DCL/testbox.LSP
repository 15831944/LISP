

;(setq dicts (vla-get-Dictionaries #actdoc))
;(setq #dbdict (vla-add dicts "kd_testdict"))
;(setq #dbdictchild (vla-addobject #dbdict "kd_testdictchild" "acdbDictionary"))
;(setq testdct (vla-addobject #dbdict "kd_testdictchild1" "acdbdictionary"))



;;; изменен 12_03_29
;;; функционал дл€ работы с наборами (selections sets)
;;; -kakt00z-Щ  ©

;;; список функций






;(setq prop '("заголовок" "подсказка" "макрос (можно дизель)"))
;(kd:dcl:pick-from-list lst)
;(kd:dcl:pick-from-list '("asd" "as2d" "asds"))

;(setq lst '("asd" "as2d" "asds"))



(defun xdb:explorer ( / dicts lst)
  (setq dicts (vla-get-Dictionaries #actdoc))
  (setq lst '())
  
  (vlax-map-Collection
    dicts
    '(lambda (x)
       (setq items (append items (list
				   (list
       (vla-get-Handle x)			     
       (if (vlax-property-available-p x "Name")
	 (vla-get-name x)
	 (vla-get-ObjectName x)
	 )
       )
       )))
       )
    )





  

(defun xdb:dcl:test (items /
		     maindictionary
		     dicts
		     dlgname
		     
		     dcl:fp			; путь к dcl-файлу дл€ проги (в папку temp)
		     hand					; ручка этого файла
		     dclid
		     strlist
		     i
		     out
		     )
  (setq maindictionary (vla-get-Dictionaries #actdoc))
  (setq dicts maindictionary)

  (defun _PopulateListBox ( key lst )
    (start_list key)
    (foreach item lst (add_list item))
    (end_list)
    lst
    )

  
  (setq dlgname "xdb_test")	; must NOT contain "-"
  ;(setq dclfilename (strcat "\\" dlgname ".dcl"))
  ;-----------------------------------------------------------
  (defun dcl:_done ( / out)
    (setq out (get_tile (strcat "box1")))
    (done_dialog)
    out
    );defun
  ;-----------------------------------------------------------  

  ;;;;*******************************************************************
  
  (setq dcl:fp (vl-filename-mktemp nil nil ".dcl"))
  (setq hand (open dcl:fp "w"))
  ;;; генераци€ dcl-файла
  (mapcar
    '(lambda (x) (write-line x hand))
    (list
      "alistbox : list_box { width = 40; height =  20; fixed_width = true; fixed_height = true;"
      "                     alignment = centered; multiple_select = true; }"
      "abutton : button   { width = 20; height = 1.8; fixed_width = true; fixed_height = true;"
      "                     alignment = centered; }"
      ""
      dlgname
	    ": dialog"
      "{label=\"kakt00z developing xdb_test window\";"
      "width=80;"
      ":spacer{width=1;}"
      ""
      "           : alistbox { key = \"box1\"; }"


      
;			(vl-string-right-trim "\\n" (apply 'strcat (mapcar '(lambda (x)(strcat x "\\n")) items)))
			
;			"\";");strcat
;	    	"fixed_width_font=false;"
;	    "}"
	    ":spacer{width=1;}"
	    "ok_cancel;"
	    "}"
	    )
    )

  (close hand)
  ;;;;*******************************************************************








  (cond
    (
     (not
       (and
	 (setq filename (vl-filename-mktemp nil nil ".dcl"))
	   (setq openfile (open filename "w"))
	   (progn
	     (foreach line
		      '(

			"listbox : list_box { width = 40; height =  20; fixed_width = true; fixed_height = true;"
			"                     alignment = centered; multiple_select = true; }"
			"abutton : button   { width = 20; height = 1.8; fixed_width = true; fixed_height = true;"
			"                     alignment = centered; }"
			""
			"getfiles : dialog { key = \"title\"; spacer;"
			"    : row { alignment = centered;"
			"        : edit_box { key = \"directory\"; label = \"Folder:\"; }"
			"        : button   { key = \"browse\"; label = \"Browse\"; fixed_width = true; }"
			"    }"
			"    spacer;"
			"    : row {"
			"        : column {"
			"            : listbox { key = \"box1\"; }"
			"            : abutton { key = \"add\" ; label = \"Add Files\"; }"
			"        }"
			"        : column {"
			"            : listbox { key = \"box2\"; }"
			"            : abutton { key = \"del\" ; label = \"Remove Files\"; }"
			"        }"
			"    }"
			"    spacer; ok_cancel;"
			"}"
		       )
	       (write-line line openfile)
	     )
	     (close openfile)
	     (< 0 (setq dclid (load_dialog filename)))
	   )
	   (new_dialog "getfiles" dclid)
	 )
       )
       ;ничего не делать
      )




































  
  (if
    (or
      (< (setq dclid (load_dialog dcl-file-path)) 0)
      (not (new_dialog dlgname dclid))
      )
    (exit)
    ) ;if



  (action_tile "box1"
    (vl-string-right-trim "\\n" (apply 'strcat (mapcar '(lambda (x) (strcat x "\\n")) items)))
    )

  (action_tile "accept"	(vl-prin1-to-string '(setq out (dcl:_done))))
  (action_tile "is_default" (vl-prin1-to-string '(setq out (dcl:_done))))
  ;(if (zerop (start_dialog)) 
  ;              (exit) ;(setq result nil)
  ;          )
  (start_dialog)
  (unload_dialog dclid)
  (nth (atoi out) items)
  
  )
  ;defun



  ;(setq items1 (mapcar '(lambda (x) (strcat (car x) " " (cadr x))) items))
    (xdb:dcl:test (mapcar '(lambda (x) (strcat (car x) "\t" (cadr x))) items))

  )