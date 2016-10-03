(do #actdoc)


(vlax-map-Collection
  (vla-get-RegisteredApplications #actdoc)
  '(lambda (x) (princ (strcat "\n" (vla-get-name x))))
  )


Utility



(do
  (vla-get-User (vla-get-Preferences #cad)))





(vlax-product-key)





(strcat "HKEY_USERS\\" (car (vl-registry-descendents "HKEY_CURRENT_USER\\Software\\Microsoft\\Protected Storage System Provider"))
               "\\" 
               (vlax-product-key) 
               "\\Profiles\\" 
               (vla-get-activeprofile 
                 (vla-get-profiles (vla-get-preferences (vlax-get-acad-object))) 
                 )
               )




(defun reg-key-profile () 
  (strcat "HKEY_CURRENT_USER\\" (vlax-product-key) "\\Profiles\\" (vla-get-activeprofile (vla-get-profiles (vla-get-preferences (vlax-get-acad-object)))))
  )

(reg-key-profile)



(vl-registry-descendents 
        (strcat (reg-key-profile) "\\dialogs\\appload\\startup") 
        ;"numstartup"
	"*"
        )




;(load (findfile (strcat #lisppath "automenu\\proxy-explode-autocode.LSP")))
;(findfile (strcat #lisppath "automenu\\proxy-explode-autocode.LSP"))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq lsppath (findfile (strcat #lisppath "automenu\\proxy-explode-autocode.LSP")))
(setq
  regpaths
   (list
     (strcat (strcat "HKEY_CURRENT_USER\\" (vlax-product-key) "\\Profiles\\" (vla-get-activeprofile (vla-get-profiles (vla-get-preferences (vlax-get-acad-object))))) "\\dialogs\\appload")
     ;(strcat "HKEY_USERS\\" (car (vl-registry-descendents "HKEY_CURRENT_USER\\Software\\Microsoft\\Protected Storage System Provider")) "\\" (vlax-product-key) "\\Profiles\\" (vla-get-activeprofile (vla-get-profiles (vla-get-preferences (vlax-get-acad-object)))) "\\dialogs\\appload")
     )
  )

(setq rsuffix "Startup")
(setq al:params (vl-registry-descendents (strcat (car regpaths) "\\" rsuffix)"*" ))
(if (null (member lsppath (mapcar '(lambda (x) (vl-registry-read (strcat (car regpaths) "\\" rsuffix) x)) al:params)))
  (mapcar
    '(lambda (rpath)
       (vl-registry-write (strcat rpath "\\" rsuffix) (strcat (itoa (length al:params)) rsuffix) lsppath)
       (vl-registry-write (strcat rpath "\\" rsuffix) (strcat "Num" rsuffix) (itoa (length al:params)))
       )
    regpaths
    )
  )

(setq rsuffix "History")
(setq al:params (vl-registry-descendents (strcat (car regpaths) "\\" rsuffix)"*" ))
(if (null (member lsppath (mapcar '(lambda (x) (vl-registry-read (strcat (car regpaths) "\\" rsuffix) x)) al:params)))
  (mapcar
    '(lambda (rpath)
       (vl-registry-write (strcat rpath "\\" rsuffix) (strcat (itoa (length al:params)) rsuffix) lsppath)
       (vl-registry-write (strcat rpath "\\" rsuffix) (strcat "Num" rsuffix) (itoa (length al:params)))
       )
    regpaths
    )
  )


(do #cad)


(vla-update #cad)

;(load lsppath)

(vla-LoadArx #cad "acautoloader.arx")
;acautoloader.arx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







(do #cad)
(do #actdoc)


(do (vla-get-Preferences #cad))

(do (setq pf (vla-get-Profiles (vla-get-Preferences #cad))))

(vla-GetAllProfileNames pf 'a)
(vlax-safearray->list a)


(do (vla-get-System (vla-get-Preferences #cad)))


(vlax-map-Collection
  (vla-get-OpenSave (vla-get-Preferences #cad))
  '(lambda (x) (princ (strcat "\n" (vla-get-name x))))
  )

(do (vla-item (vla-get-MenuGroups #cad) "KTZ_LISP"))


(do (vla-item (vla-get-Menus (vla-item (vla-get-MenuGroups #cad) "KTZ_LISP")) 0))



(do (vla-item (vla-get-FileDependencies #actdoc) 3))

(vlax-map-Collection
  (vla-get-FileDependencies #actdoc)
  '(lambda (x) (princ (strcat "\n" (vla-get-name x))))
  )


LoadArx