
;(load (strcat #lisppath ""))
(load (strcat #lisppath "Files\\GetFilesV1-4.lsp"))
(load (strcat #lisppath "strings\\kd-sortstrings.LSP"))
(setq filelist (LM:GETFILES "Select files ..." "D:\\_TDMS\\" "dwg;dxf"))
(setq filelist (kd:sortstrings filelist))
(setq cpt '( 0 0 0 ))
(length filelist)
;;;;;;; delete PROXY







;(setq path "d:\\_TDMS\\1791-10-АТМ5.Н1\\1791-10-АТМ5.Н1 л. 2.dwg")
(mapcar
  '(lambda (path / drw scobj p1 p2)
     ;(setq path (nth 13 filelist))
     (setq drw (vla-InsertBlock #modspace (vlax-3d-point cpt) path 1 1 1 0 ))
     (if (setq sc (vl-remove-if-not
       '(lambda (obj)
	  (and
	    (member (vla-get-objectname obj) '("AcDbText" "AcDbMText"))
	    (wcmatch (vla-get-textstring obj) "Кол. уч[~?@],Кол. уч[~?@],Кол.уч[~?@],Кол.уч")
	    )
	  )
       (cont>list (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName drw)))
       ))
       (setq sc (/ 2.5 (vla-get-Height (car sc))))
       (setq sc 1)
       )
     (vla-put-XEffectiveScaleFactor drw sc)
     (vla-put-YEffectiveScaleFactor drw sc)
     (vla-put-ZEffectiveScaleFactor drw sc)
     (vla-GetBoundingBox drw 'p1 'p2)
     (setq p1 (vlax-safearray->list p1))
     (setq p2 (vlax-safearray->list p2))
     (command "_rectang" p1 p2)
     (setq cpt (mapcar '+ cpt (list 0 (- (cadr p1) (cadr p2)) 0) '(0 -5 0)))
     (vla-move drw (vlax-3d-point p1) (vlax-3d-point cpt))
    )
  filelist
  )








