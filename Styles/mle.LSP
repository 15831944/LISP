

(VL-STRING->LIST
  (vla-get-TextString (vlax-ename->vla-object (car (entsel))))
  )



(VL-STRING->LIST
  (cdr (assoc 1 (entget (car (entsel)))))
  )




(defun c:mle ( / obj str)
  (setq obj (entsel))
  (if obj
    (progn
      ;(setq str (cdr (assoc 304 (entget (car obj)))))
      (setq obj (vlax-ename->vla-object (car obj)))
      (setq str (kd-get-TextString obj))
      ;(kd:mtextstring-unformat str)
      (setq str (sepstr str "\n"))
      (setq str (kd:dcledtlst  str))
      (vla-put-TextWidth obj (* (apply 'max (mapcar 'strlen str)) (* 0.7 (vla-get-TextHeight obj))))
      (setq str (antisep str "\n"))
      (vla-put-TextString obj str)
      )
    )
  
  );defun




(do (setq obj (vlax-ename->vla-object (car (entsel)))))
(setq str (kd:dclget '("line1" "line2")))


(vla-put-TextWidth obj
  (* (apply 'max (mapcar 'strlen str)) (* 0.7 (vla-get-TextHeight obj)))
  )





(do (setq obj (vlax-ename->vla-object (car (entsel)))))



(vla-put-TextString
  (vlax-ename->vla-object (car (entsel)))
  (strcat (nth 0 str) "\n" (nth 1 str))
  )

(;entget (cdr (assoc 340 (reverse (entget (car (entsel)) '("*"))))))

;(modent (vlax-vla-object->ename obj) (cons 44 0))







(defun kd:dclget (props /
		  propsdcl
		  dlgname
		  dclfilename
		  dcl-file-path
		  hand
		  dcl_id
		  i
		  lst
		  lif				;last input file
		  lifr				;last input file read
		  ld				;last data
		  tmp
		  )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;(setq str "\"pfuj\" sda")
  ;(dcl:formatstring str)
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
  (defun dcl:fsforfilename (str)	; format string to generate filename
    (if (vl-string-search "\"" str)
      (apply 'strcat (sepstr str "\""))
      str
      )
    );defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq propsdcl (mapcar 'dcl:formatstring props))

  (setq dlgname "kd_dclget")
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  (setq lif (strcat "\\dclget-lif-" (apply 'strcat (mapcar 'dcl:fsforfilename props)) ".tmp"))

  ;-----------------------------------------------------------
  (defun kd:dclget_done ( / lst i lifw)		; last input file write
    (setq lst '() i 0)
    (repeat (length props)
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
  
  
  
  ;;; генерация dcl-файла
  (mapcar '(lambda (x) (write-line x hand))
	  (list
	    dlgname
	    ": dialog"
	    "{label=\"kakt00z developing dcl get properties window\";"
	    "width=80;"
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


(defun modenteo (ent pp / engeo enghead eng)
  (setq eng (entget ent))
  (setq engeo (member '(101 . "Embedded Object") eng))
  (setq enghead (reverse (cdr (member '(101 . "Embedded Object") (reverse eng)))))
  (setq engeo (subst pp (assoc (car pp) engeo) engeo))
  (setq eng (append enghead engeo))
  (entmod eng)
  (entupd ent)
  );defun

(defun modent (ent pp / head eng)
  (setq head (car pp))
  (setq eng (entget ent))
  (setq eng (subst pp (assoc head eng) eng))
  (entmod eng)
  (entupd ent)
  )