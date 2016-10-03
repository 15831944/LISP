(defun object (name paramlist)
  (cons name paramlist)
  )

(setq kdo (object "signal" nil))
(setq pname "type")

(defun obj|addpar ('kdo pname)
  (mapcar 'car (cdr kdo))
  (if (null (member pname (mapcar 'car (cdr kdo))))
    (append 'kdo (list (list pname nil)))
    )
  );defun
(obj|addpar kdo "type")

(defun obj|setparval)
(defun obj|getparval)
(defun obj|getparams)



(defun obj|gpar)