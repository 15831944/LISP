(defun cdo (obj)(vlax-for i obj (princ (strcat "\n"(vla-get-name i)))))

(defun kd:itemtags (obj / oexd xr taglist)
  (setq taglist '())
  (vlax-for xr obj (setq taglist (append taglist (list (vla-get-name xr)))))
  taglist
  )

;(getvar "ACADVER")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun autoresetscales-eng (/)
  (vl-cmdf "_-scalelistedit" "r" "y" "e")
  )
(defun autoresetscales-rus (/)
  (vl-cmdf "_-scalelistedit" "с" "д" "в")
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(setq menugroups (vla-get-MenuGroups #cad))
;(cdo menugroups)
;(do menugroups)

(setq custmenugroup (vla-item menugroups "custom"))
;(do custmenugroup)
(setq ctoolbars (vla-get-Toolbars custmenugroup))
;(do ctoolbars)

(setq toolbar
       (if (member "lisputils" (kd:itemtags ctoolbars))
	 (vla-item ctoolbars "lisputils")
	 (vla-add ctoolbars "lisputils")
	 )
      )
(vla-put-visible toolbar 1)
;(vla-Dock toolbar acToolbarDockTop)
;(vla-Dock toolbar acToolbarDockRight)
;(vla-Float toolbar 150 100 2)
;(do toolbar)




;(vla-delete btn)




  (if (null (member "resetscales" (kd:itemtags toolbar)))
    (progn
      (setq btn (vla-AddToolbarButton toolbar (vla-get-count toolbar)
	    "resetscales"						; заголовок
	    "reset all scales in a drawing to default list"		; подсказка
	    "(autoresetscales-eng) "					; макрос (можно дизель)
	    ;"(autoresetscales-rus) "					; russian
	    :vlax-false							; признак подменю
	    ))
      (vla-put-CommandDisplayName btn "resetscales")
      (setq bmppath (kd:getfiledlg "BMP|*.bmp"))
      (vla-SetBitmaps btn bmppath bmppath)
      )
    );if


(setq cdo nil
      kd:itemtags nil
      menugroups nil
      custmenugroup nil
      ctoolbars nil
      toolbar nil
      btn nil
       )









;(vla-SetBitmaps btn "default" "default")

;(vla-delete btn)
;(vlax-release-object btn)
;(setq btn nil)

	

;(vla-saveas custmenugroup (strcat (getenv "TEMP") "\\lisputils") acMenuFileCompiled)

;;;
;;;(vla-saveas custmenugroup "lisputils" acMenuFileCompiled)
;;;
;;;(setq err (vl-catch-all-apply '(lambda () (vla-saveas custmenugroup "lisputils" acMenuFileCompiled))))
;;;
