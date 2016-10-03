(defun cdo (obj)(vlax-for i obj (princ (strcat "\n"(vla-get-name i)))))


(defun kd:itemtags (obj / oexd xr taglist)
  (setq taglist '())
  (vlax-for xr obj (setq taglist (append taglist (list (vla-get-name xr)))))
  taglist
  )




(setq menugroups (vla-get-MenuGroups #cad))
;(kd:itemtags menugroups)
(setq menu (vla-item menugroups "KTZ_LISP"))
(setq toolbars (vla-get-Toolbars menu))
;(do toolbars)
;(cdo toolbars)
;(setq toolbar (vla-item toolbars 0))
;(do toolbar)
;(setq button (vla-item toolbar 3))
;(vla-GetBitmaps button 'a 'b)



(vlax-for toolbar toolbars
  (vlax-map-Collection
    toolbar
    '(lambda (button / a b)
       (if (/= "separator" (vla-get-Name button))
	 (progn
	   (vla-GetBitmaps button 'a 'b)
	   (if (or
		 (wcmatch a "*LISP WORKING*")
		 (wcmatch b "*LISP WORKING*")
	       )
	     (vla-SetBitmaps
	       button
	       (strcat #lisppath (substr a 17))
	       (strcat #lisppath (substr a 17))
	     )
	   )
	 )
       )
     )
  )
)



;if all is ok
(vla-save menu acMenuFileCompiled)
(vla-save menu acMenuFileSource)





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

(vla-SetBitmaps btn "d:/LISP WORKING/automenu/test1.bmp" "d:/LISP WORKING/automenu/test1.bmp")

(vla-SetBitmaps btn "default" "default")

(vla-delete btn)
(vlax-release-object btn)
(setq btn nil)

(kd:itemtags toolbar)


