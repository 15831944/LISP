




(defun c:pdfmerge ( / shell app path mergename filelist)
  (load (strcat #lisppath "Files\\GetFilesV1-4.lsp"))
  (setq filelist (LM:getfiles "Select *.pdf files to merge ..." "d:\\" "pdf"))
  (if filelist
    (progn
      (setq path (reverse (sepstr (car filelist) "\\")))
      (setq mergename (cadr path))
      (setq shell (vlax-get-or-create-object "wscript.shell"))
      (setq app "\"c:\\Program Files\\AdultPDF\\Ap PDF Split-Merge\\pdfspme_cmd.exe\" ")
      (setq script (strcat app "-mer " (apply 'strcat (mapcar '(lambda (x) (strcat "-i \"" x "\" ")) filelist)) (strcat "-o \"" (antisep (reverse (cdr path)) "\\") "\\" mergename ".pdf" "\"")))
      (vlax-invoke-method shell "run" script 1 :vlax-true)
      (vlax-release-object shell) (setq shell nil)
      )
    (princ)
    )
  );defun











(defun get-all-files-down-folder (folder fltr / sub res)
  (if (setq sub (vl-remove-if '(lambda (x) (member x '("." ".."))) (VL-DIRECTORY-FILES folder "*" -1)))
    (append
      (mapcar '(lambda (x) (strcat folder "\\" x)) (VL-DIRECTORY-FILES folder fltr 1))
      (apply 'append (vl-remove 'nil (mapcar '(lambda (x) (get-all-files-down-folder (strcat folder "\\" x) fltr) ) sub)))
      )
    (mapcar '(lambda (x) (strcat folder "\\" x)) (VL-DIRECTORY-FILES folder fltr 1))
    )
  );defun




(setq files (get-all-files-down-folder "d:\\314341241324" "*.pdf"))
(length files)




(mapcar
  '(lambda (f / p nfn)	;(setq f (nth 13 files))
     (setq p (reverse (sepstr f "\\")))
     (setq nfn (strcat (cadr p) (car p)))

     (antisep (reverse (cons nfn (cdr p)))"\\")
     
     (vl-file-rename f (antisep (reverse (cons nfn (cdr p)))"\\"))
     )
  
  files
  )










(if files
    (progn
      (setq path (reverse (sepstr (car files) "\\")))
      (setq mergename (cadr path))
      (setq shell (vlax-get-or-create-object "wscript.shell"))
      (setq app "\"c:\\Program Files\\AdultPDF\\Ap PDF Split-Merge\\pdfspme_cmd.exe\" ")
      (setq script (strcat app "-mer " (apply 'strcat (mapcar '(lambda (x) (strcat "-i \"" x "\" ")) files))
			   (strcat "-o \"" (antisep (reverse (cdr path)) "\\") "\\" mergename ".pdf" "\"")))
      ;(vlax-invoke-method shell "run" script 1 :vlax-true)
      (vlax-invoke-method shell "exec" script 1)
      (vlax-release-object shell) (setq shell nil)
      )
    (princ)
    )







;;;
;;;
;;;
;;;
;;;
;;;
;;;(setq dirs
;;;       
;;;(vl-remove-if
;;;  '(lambda (x)
;;;     (member x '("." ".."))
;;;     )
;;;  (VL-DIRECTORY-FILES "d:\\_____!!!")
;;;  )
;;;      )

