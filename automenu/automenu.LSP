(defun cdo (obj)(vlax-for i obj (princ (strcat "\n"(vla-get-name i)))))


(defun kd:itemtags (obj / oexd xr taglist)
  (setq taglist '())
  (vlax-for xr obj (setq taglist (append taglist (list (vla-get-name xr)))))
  taglist
  )


(setq menubar (vla-get-MenuBar #cad))
(do (vla-item menubar 3))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq menugroups (vla-get-MenuGroups #cad))
(setq kdmenu (vla-item menugroups "KD-AUTOMENU"))
(setq toolbars (vla-get-Toolbars (vla-item menugroups "KD-AUTOMENU")))
(do toolbars)
(mapcar 'vla-get-name toolbars)

(setq toolbar
       (if (member "test_toolbar" (kd:itemtags toolbars))
	 (vla-item toolbars "test_toolbar")
	 (vla-add toolbars "test_toolbar")
	 )
      )
(do toolbar)
(setq btn (vla-AddToolbarButton toolbar (vla-get-count toolbar)
	    "lisplist"						; заголовок
	    "arranging mtext contained a lisp list"		; подсказка
	    "(lisplist) "					; макрос (можно дизель)
	    :vlax-false						; признак подменю
	    ))
(vla-put-CommandDisplayName btn "(lisplist)")

(vla-SetBitmaps btn (strcat #lisppath "automenu/test1.bmp") (strcat #lisppath "automenu/test1.bmp"))

(vla-SetBitmaps btn "default" "default")

(vla-delete btn)
(vlax-release-object btn)
(setq btn nil)

(kd:itemtags toolbar)


