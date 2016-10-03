


(setq file (strcat (getenv "temp") "\\lodocs.tmp"))


(defun kd:save (/ fhand lst str)
  (setq lst '())
  (vlax-for item (vla-get-documents #cad)
    (setq lst (append lst (list (vla-get-FullName item))))
    )
  (setq fhand (open file "w"))
  (foreach item lst
    (write-line item fhand)
    )
  (close fhand)
  );defun

;;;(kd:save)


(defun kd:load (/ fhand str lst docs)
  (setq docs (vla-get-Documents #cad))
  (setq fhand (open file "r"))
  (setq lst '())
  (while (setq str (read-line fhand))
    (setq lst (append lst (list str)))
    )
  (close fhand)
  (mapcar '(lambda (x) (vla-open docs x)) lst)
  (princ)
  );defun

;(kd:load)

