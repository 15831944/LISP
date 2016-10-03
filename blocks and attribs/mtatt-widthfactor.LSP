
(defun c:fx ( /  obj)
  (setq obj (vlax-ename->vla-object (car (nentsel))))
  (vla-put-TextString obj
    (strcat "{\\W0.8;\\T0.9;" (vla-get-TextString obj) "}" )
    )
  );defun