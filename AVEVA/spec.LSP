(vl-load-com)

;(setq fname "spec.txt")
;(setq path "D:/")
;(setq fpath (strcat path fname))
(setq theight 8)
(setq cols '(0 20 100 50))

;(setq str "2;Îòâîä 90-219x6;ÃÎÑÒ 17375-2001;Ñòàëü 20")


(defun c:spec ( / actdoc
	       lst
	       bpt
	       )

  (setq actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (setq modspace (vla-get-modelspace actdoc))
  (vla-startundomark actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0)T));acet-error-init
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (if (setq lst (file-to-data fpath))
    (progn
      (setq bpt (getpoint "Pick a head Point of table..."))

      (foreach line lst
	(mapcar '(lambda (st dx)
		   (vla-addText modspace st
		     (vlax-3d-point
		       (setq bpt (mapcar '+ bpt (list dx 0 0)))
		       )
		     2.5
		     )
		   ) line cols)
	(setq bpt (mapcar '- bpt (list (eval (append '(+) cols)) theight 0.0)))
	)
      
      )
    (exit)
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (acet-error-restore)
  (vla-endundomark actdoc)
  );defun


(defun file-to-data (fpath / hand lst strline)
  ;(setq lst '())
  (if (setq hand (open fpath "r"))
    (progn
      (while (setq strline (read-line hand))
	(setq lst (append lst (list strline)))
	)
      (close hand)
      (mapcar 'strline->data lst)
      )
    (princ (strcat "\nFile " fpath " is not found..."))
   );if
 )

(defun strline->data (strline /
		      delimiter
		      strhead
		      strtail
		      poz
		      )
  (setq delimiter ";")
  
  (if (setq poz (vl-string-search delimiter strline))
    (progn (setq strhead (substr strline 1 poz)
		 strtail (substr strline (+ poz 1 (strlen delimiter))))
      (append (list strhead) (strline->data strtail))
      );progn
    (list strline)
    );if
  );defun




(defun kd:getfiledlg (flt / ComDlg str)
  (setq ComDlg (vla-getinterfaceobject #cad "MSComDlg.CommonDialog"))
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