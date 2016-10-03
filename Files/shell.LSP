





;;;;;  ;    !!!   (getfiled "asd" "" "dwg" 64)




;(ACET-FILE-OPEN "asd" "DWG|*.dwg|text|*.txt")
(defun kd:getfolderdlg (msg dir / err shell fold self path )
  (setq err (vl-catch-all-apply
	(function
	  (lambda ( /  hwnd )
	    (if (setq shell (vla-getinterfaceobject #cad "Shell.Application")
		      hwnd  (vl-catch-all-apply 'vla-get-hwnd (list #cad))
		      fold  (vlax-invoke-method shell 'BrowseForFolder (if (vl-catch-all-error-p hwnd) 0 hwnd) msg 512 dir)
                            )
	      (setq self (vlax-get-property fold 'self)
		    path (vlax-get-property self 'path)
		    path (vl-string-right-trim "\\" (vl-string-translate "/" "\\" path))
		    )
	      )
	    )
	  )
	)
	)
  (if self  (vlax-release-object  self))
  (if fold  (vlax-release-object  fold))
  (if shell (vlax-release-object shell))
  (if (vl-catch-all-error-p err)
    (prompt (vl-catch-all-error-message err))
    path
    )
  );defun
;(kd:getfolderdlg "pick a folder" "D:\\")







;;;(setq err (vl-catch-all-apply
;;;	(function
;;;	  (lambda ( /  hwnd )
;;;	    (setq ComDlg (vla-getinterfaceobject #cad "MSComDlg.CommonDialog"))
;;;	    )
;;;	  )
;;;	)
;;;	)
;;;
;;;(vl-catch-all-error-p err)
;;;(VL-CATCH-ALL-ERROR-MESSAGE err)


(defun kd:getfiledlg (flt / ComDlg str)
  (setq ComDlg (vla-getinterfaceobject #cad "MSComDlg.CommonDialog.1"))
  ;(vlax-put-Property comdlg "InitDir" "D:\\")
  (vlax-put-Property comdlg "Filter" flt)
  (vlax-put-Property comdlg "MaxFileSize" 1000)
  (vlax-put-Property comdlg "DialogTitle" "kd:getfilEdlg")
  (vlax-invoke-method comdlg "ShowOpen")
  (setq str (vlax-get-Property comdlg "FileName"))
  (vlax-release-object comdlg)
  (setq comdlg nil)
  str
  )
;(KD:GETFILEDLG "DWG|*.dwg|text|*.txt")


;;;(defun kd:getfiledlg (msg dir ext / )
;;;  (acet-ui-getfile msg
;;;    ;(acet-filename-ext-remove (getvar "DWGNAME"))
;;;    dir
;;;    ext
;;;    "Acet:RText" 1664)
;;;  );defun

;(kd:getfiledlg "file:" "D:\\" "exe;*") 


;;;
;;;(setq shell (vla-getinterfaceobject cad "Shell.Application"))
;;;(setq ComDlg (vla-getinterfaceobject cad "MSComDlg.CommonDialog"))
;;;(setq shell (vla-getinterfaceobject cad "ShellNameSpace.ShellNameSpace"))
;;;(vlax-release-object shell)
;;;(vlax-invoke-method comdlg "AboutBox")
;;;(vlax-invoke-method comdlg "ShowHelp")
;;;(vlax-release-object shell)


;;;(setq obj (vla-getinterfaceobject cad "System.Collections.SortedList"))
;;;(vlax-release-object obj)


;;;
;;;HKEY_CLASSES_ROOT\AdCommon.AdFileOpenDialog.1
;;;
;;;(setq cfd (vlax-get-or-create-object "AcSmComponents.AcSmDSTFiler.18"))
;;;(setq cfd (vla-getinterfaceobject #cad "AdCommon.AdFileOpenDialog.1"))
;;;
;;;
;;;(vlax-invoke-method cfd "ShowFileOpenDialog"
;;;  ;(vl-catch-all-apply 'vla-get-hwnd (list #cad))
;;;  "title"
;;;  "DWG|*.dwg|text|*.txt"
;;;  512
;;;  512
;;;  )
;;;
;;;
;;;
;;;
;;;
;;;(defun asd1 ()
;;;  
;;;  )
;;;
;;;
;;;(setq asd (vla-getinterfaceobject #cad "Microsoft.Access.OLEDB.10.0"))