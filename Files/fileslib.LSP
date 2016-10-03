

(load (strcat #lisppath "Files\\GetFilesV1-4.lsp"))
(load (strcat #lisppath "strings\\kd-sortstrings.LSP"))


(defun get-all-files-down-folder (folder fltr / sub res)
  (if (setq sub (vl-remove-if '(lambda (x) (member x '("." ".."))) (VL-DIRECTORY-FILES folder "*" -1)))
    (append
      (mapcar '(lambda (x) (strcat folder "\\" x)) (VL-DIRECTORY-FILES folder fltr 1))
      (apply 'append (vl-remove 'nil (mapcar '(lambda (x) (get-all-files-down-folder (strcat folder "\\" x) fltr) ) sub)))
      )
    (mapcar '(lambda (x) (strcat folder "\\" x)) (VL-DIRECTORY-FILES folder fltr 1))
    )
  );defun



(defun kd:safeFilename (supposedFullName / separator folder filename ext i)
    ;(setq supposedFullName "d:/_TDMS/filename.ext")
    ;(setq supposedFullName "d:\\_TDMS\\filename.ext")
    (setq separator (cond ((wcmatch supposedFullName "*\\*") "\\") ((wcmatch supposedFullName "*/*") "/")))
    (setq folder (sepstr supposedFullName separator)
	  filename (last folder)
	  folder (strcat (antisep (reverse (cdr (reverse folder))) separator) separator)
	  )
    (setq filename (sepstr filename ".")
	  ext (last filename)
	  filename (antisep (reverse (cdr (reverse filename))) ".")
	  )
    (if (findfile (strcat folder filename "." ext))
      (progn
	(setq i -1)
	(while (findfile (strcat folder filename "[" (itoa (setq i (1+ i))) "]" "." ext)))
	(strcat folder filename "[" (itoa (setq i (1+ i))) "]" "." ext)
	)
      ;else
      (strcat folder filename "." ext)
      )
    );defun




