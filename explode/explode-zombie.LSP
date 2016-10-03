;  14_05_22
;(setq obj (vlax-ename->vla-object (car (entsel))))


(defun explode-zombies ( / sset)
  (setq sset (vla-get-ActiveSelectionSet #actdoc))
  (vla-Clear sset)
  (vla-Select sset acSelectionSetAll nil nil
    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("ACAD_PROXY_ENTITY"))
    )
  (mapcar '(lambda (z) (kd|explodezombie z)) (cont>list sset))
  );defun


(defun kd|explodezombie (obj)
  (acet-explode (vlax-vla-object->ename obj))
  )

