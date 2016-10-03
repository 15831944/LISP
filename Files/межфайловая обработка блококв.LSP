(load (strcat #lisppath "files\\shell.lsp"))
(setq file (kd:getfiledlg "AutoCad Filw (*.dwg)|*.dwg"))


(setq docs (vla-get-Documents cad))
(setq $doc (vla-open docs file))
(setq blocks (vla-get-blocks $doc))
(setq blk (vla-item blocks "НИПИ_штамп_основной"))

(setq lstobjtodel nil)
(repeat (setq i (vla-get-count blk))
  (setq o (vla-item blk (setq i (1- i))))
  (if
    (and
      (= "AcDbLine" (vla-get-objectname o))
      ;(= 55 (vla-get-length o))
      (or
	(equal '(0.0 0.0 0.0) (vlax-safearray->list (vlax-variant-value (vla-get-startpoint o))))
	(equal '(0.0 0.0 0.0) (vlax-safearray->list (vlax-variant-value (vla-get-endpoint o))))
	)
      )
    (setq lstobjtodel (append lstobjtodel (list o)))
    )
  )

(setq err (vl-catch-all-apply '(lambda (x) (vla-delete x)) lstobjtodel))
(vl-catch-all-error-message err)