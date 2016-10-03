



(load (strcat #lisppath "Files\\fileslib.lsp"))
;(setq files (GET-ALL-FILES-DOWN-FOLDER "d:\\_TDMS\\454-1-ภาฬ9" "*.dwg"))
(setq files (GET-ALL-FILES-DOWN-FOLDER "d:\\_TDMS\\383-1-ัส1" "*.dwg"))

(length files)



  
;;;  (setq $doc (vla-open $docs file))
;;;  (vla-put-LineweightDisplay (vla-get-Preferences $doc) :vlax-true)
;;;  (vla-saveas $doc file ac2004_dwg)
;;;  (vla-close $doc)





(setq #Documents (vla-get-Documents #cad))

(if
  (and
    (findfile (strcat #lisppath "ktz-load.lsp"))
    (findfile (strcat #lisppath "ktz-load-recovery.lsp"))
    )
  (vl-file-delete (strcat #lisppath "ktz-load-recovery.lsp"))
  )


(if
  (and
    (findfile (strcat #lisppath "ktz-load.lsp"))
    )  
  (progn
    
    (vl-file-rename (strcat #lisppath "ktz-load.lsp" ) (strcat #lisppath "ktz-load-recovery.lsp" ))
    (setq fw (open (strcat #lisppath "ktz-load.lsp" ) "w"))

    (princ
      (strcat
	"
	(princ)
	"
      )
      
    fw)
    
    (close fw)
    (setq fw nil)
    )
  )


(mapcar
  '(lambda (file / $doc $ut)	;(setq file (nth 0 files))
     (setq $doc (vla-open #Documents file))

     
     
     )
  files)



(vl-file-delete (strcat #lisppath "ktz-load.lsp"))
(vl-file-rename (strcat #lisppath "ktz-load-recovery.lsp") (strcat #lisppath "ktz-load.lsp" ))


(sssetfirst nil (ssget "_X" '((0 . "ACAD_PROXY_ENTITY"))))