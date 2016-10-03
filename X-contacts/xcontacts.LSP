
(vl-load-com)
(setq cont-dict-name "contacts")
(defun xcontacts (
		  /
		  dcl-file-path
		  dcl_id

		  handf

		  ename
		  eo
		  lst
		  str
		  )

  (setq ename (car (entsel))
	eo (vlax-ename->vla-object ename))
  (setq lst (vlax-ldata-get eo cont-dict-name))
  (setq dcl-file-path (strcat (getenv "temp") "\\x-cont-dcl.dcl")
	hand	(open dcl-file-path "w"))
  (foreach item
	   '(

"X_contact_dia : dialog {width=100; label=\"X-contacts\";
    : row {
    	: text {value=\"none\"; key=\"block-effective-name\";}
    	: button {label=\"выбрать\"; key=\"kgetent\";}//width=10;fixed_width=true;}
        : edit_box {label=\"имя словаря\"; key=\"cont_dict_name\"; value=\"contacts\";}
        : button {label=\"show\";width=10; fixed_width=true;}
    }
    : boxed_row {label=\"Dictionary\"; key=\"frame\";
    	: list_box {key=\"lstbox\";}
        : button {label=\"delete\"; fixed_width=true;width=10;}
    }
    : row {
    	:column {
    		: text {value=\"Name\";}
    		: edit_box {key=\"cname\";}
        	}
        :column {
        	: text {value=\"point\";}
        	: edit_box {key=\"cpoint\";}
        	}
        :column {
        	: text {value=\"type\";}
        	: edit_box {key=\"ctype\";}
        	}
        :column {
        	: text {value=\"polar\";}
        	: edit_box {key=\"cpolar\";}
        	}
        : button {label=\"Add\";width=10;fixed_width=true;fixed_height=false; height=3;}
        }
    spacer_1;
    ok_cancel;
}
")
(write-line item hand)
);foreach
(close hand)







  
  ;(setq lst (vlax-ldata-get eo cont-dict-name))
  ;(setq dcl-file-path "d:\\LISP WORKING\\connecting\\X-contacts\\x-cont-dcl.dcl")
  (if (< (setq
	   dcl_id (load_dialog dcl-file-path))
	 0
	 )
    (exit)
    ) ;if
  (if (not (new_dialog "X_contact_dia" dcl_id))
    (exit)
    ) ;_ конец if

  (set_tile "block-effective-name" (vla-get-effectivename eo))
  (set_tile "cont_dict_name" cont-dict-name)

;;;  (setq str "")
;;;  (foreach item lst
;;;    (setq str (strcat str (car item) "\n"))
;;;    )
  (start_list "lstbox")
  (foreach item lst
    (add_list (xc-make-listline item))
    ;(add_list (strcat (car item) "   " (cdr (caddr item)) "   "(cdr (cadddr item))))
    )
  (end_list)



  

  (action_tile
    "accept"
    "(done_dialog)"
    ) ; action-tile accept
  (action_tile
    "cancel"
    "(done_dialog)"
    ) ; action-tile accept
  
  (action_tile
    "is_default"
    "(done_dialog)"
    )
  (start_dialog)
  (unload_dialog dcl_id)
    
  );defun

;;;(setq str "")
;;;(foreach item lst
;;;  (setq str (strcat str (car item) "\n"))
;;;  )


;;;(
;;; ("N"
;;;   ("point" 0.0 0.0 0.0)
;;;   ("signal type" . "220VAC")
;;;   ("polar" . "N")
;;;   )
;;;  ("L"
;;;    ("point" -5.0 0.0 0.0)
;;;    ("signal type" . "220VAC")
;;;    ("polar" . "A")
;;;    )
;;;  ("PE"
;;;    ("point" 5.0 0.0 0.0)
;;;    ("signal type" . "PE")
;;;    ("polar" . "PE")
;;;    )
;;;  )

;;;(setq i (list
;;; "N"
;;;   '("point" 0.0 0.0 0.0)
;;;   '("signal type" . "220VAC")
;;;   '("polar" . "N")
;;;   ))


(defun k-list->str (lst
	    /
	    str
	    )
  (setq str "")
  (if (= 'LIST (type (cdr lst)))
    (progn
    
  (foreach item lst
    (cond
      ((= 'STR (type item))
       (setq str (strcat str " " item)))
      ((= 'LIST (type item))
       (setq str (strcat str (d12 item))))
      ((= 'INT (type item))
       (setq str (strcat str " " (itoa item))))
      ((= 'REAL (type item))
       (setq str (strcat str " " (rtos item))))
      
      );cond
    )
  )
    (setq str (strcat
		;(car lst)
		;" . "
		"       "
		(cdr lst)
		))
    )
  str
  );defun


(defun xc-make-listline (
			 lst
			 /
			 name
			 stype
			 pol
			 str
			 l
			 step
			 )
  (setq step 40
	name (car lst)
	stype (cdr (caddr lst))
	pol (cdr (cadddr lst))
	)
  (setq str name)
  (repeat (- step (strlen name))
    (setq str (strcat str " "))
    );repeat
  (setq str (strcat str stype))
  (repeat (- step (strlen stype))
    (setq str (strcat str " "))
    );repeat
  (setq str (strcat str pol)) 
  );defun


