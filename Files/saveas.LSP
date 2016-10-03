



(load (strcat #lisppath "Files\\GetFilesV1-4.lsp"))
(load (strcat #lisppath "strings\\kd-sortstrings.LSP"))
(setq filelist (LM:GETFILES "Select files ..." "D:\\_AutoCAD\\eir\\Ã“›÷-20\\“√8_2004"))
(setq filelist (kd:sortstrings filelist))



(foreach file filelist
  (setq $docs (vla-get-Documents #cad))
  (setq $doc (vla-open $docs file))
  (vla-put-LineweightDisplay (vla-get-Preferences $doc) :vlax-true)
  (vla-saveas $doc file ac2004_dwg)
  (vla-close $doc)
  )








;;;  with subfolders



(setq fltr "*.dwg")

;(setq folder "D:\\_AutoCAD\\eir\\Ã“›÷-20\\“√8_2004\\09-14-“»-»Œ—.¿“’.«ƒ.04-“Œ_«‡‰‡ÌËÂ Á‡‚Ó‰Û Ì‡ ¯Í‡Ù˚ Ò·ÓÓÍ Á‡‰‚ËÊÂÍ")
;(setq folder "D:\\_AutoCAD\\eir\\Ã“›÷-20\\“√8_2004")


(defun get-all-files-down-folder (folder fltr / sub res)
  (if (setq sub (vl-remove-if '(lambda (x) (member x '("." ".."))) (VL-DIRECTORY-FILES folder "*" -1)))
    (append
      (mapcar '(lambda (x) (strcat folder "\\" x)) (VL-DIRECTORY-FILES folder fltr 1))
      (apply 'append (vl-remove 'nil (mapcar '(lambda (x) (get-all-files-down-folder (strcat folder "\\" x) fltr) ) sub)))
      )
    (mapcar '(lambda (x) (strcat folder "\\" x)) (VL-DIRECTORY-FILES folder fltr 1))
    )
  );defun




(setq files (get-all-files-down-folder "D:\\_AutoCAD\\eir\\Ã“›÷-20\\“√8_2004" "*.dwg"))


(foreach file files
  (setq $docs (vla-get-Documents #cad))
  (setq $doc (vla-open $docs file))
  (vla-put-LineweightDisplay (vla-get-Preferences $doc) :vlax-true)
  (vla-saveas $doc file ac2004_dwg)
  (vla-close $doc)
  )


(setq files (get-all-files-down-folder "D:\\_AutoCAD\\eir\\Ã“›÷-20\\“√8_2004" "*.bak"))

(mapcar
  '(lambda (path)
     (vl-file-delete path)
     )
  files
  )

(setq files (get-all-files-down-folder "D:\\_AutoCAD\\eir\\Ã“›÷-20\\“√8_2004" "*.db"))
(mapcar 'vl-file-delete files)

(setq files (get-all-files-down-folder "D:\\_AutoCAD\\eir\\Ã“›÷-20\\“√8_2004" "*.log"))
(mapcar 'vl-file-delete files)