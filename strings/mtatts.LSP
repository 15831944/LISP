

(defun c:fx ( / obj)
  (setq obj (vlax-ename->vla-object (car (nentsel))))
  (vla-put-TextString obj (strcat "{\\W0.9;\\T0.9;" (vla-get-TextString obj) "}" )
    )
  );defun




(defun c:asd ( / obj)
  (setq lst (ss->lsto* (ssget "_I")))
  (mapcar
    '(lambda (obj)
       (vla-put-TextString obj (strcat "{\\W0.9;\\T0.9;" (vla-get-TextString obj) "}" ))
       )
    
       lst
    )
  (princ)
  );defun
