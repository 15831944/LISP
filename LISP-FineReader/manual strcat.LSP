

;;	manual strcat

(defun c:asd ( / obj marks m todel)
  (setq marks nil m nil obj nil)
  (setq m (entsel))
  (setq obj (cons m obj))
  (setq marks (cons (kd-get-textstring (vlax-ename->vla-object (car m))) marks))
  (vlax-put-property (vlax-ename->vla-object (car m)) "Color" 3)

  
  (while (setq m (nentsel (apply 'strcat (mapcar '(lambda (x) (strcat x "\n")) (reverse marks)))))
    (setq obj (cons m obj))
    (setq marks (cons (kd-get-textstring (vlax-ename->vla-object (car m))) marks))
    (vlax-put-property (vlax-ename->vla-object (car m)) "Color" 1)
    )
  (setq obj (reverse obj))
  (setq todel (mapcar '(lambda (x) (vlax-ename->vla-object (car x))) (cdr obj)))
  (setq obj (vlax-ename->vla-object (car (car obj))))

  (setq marks 

  (mapcar
    '(lambda (s / res)	;(setq s (car marks))
       (setq res (vl-string-trim " " s))
       (setq
	 res
	  (if (vl-string-search "-" res (1- (strlen res)))
	    (vl-string-subst "" "-" res (1- (strlen res)))
	    (strcat res " ")
	    )
	 )
       
       )
    (reverse marks)
    ))

  
  (vla-put-TextString obj (str|replacechars " " "  " (vl-string-trim " " (antisep marks ""))))
  (mapcar 'vla-delete todel)
  (vlax-put-property obj "Color" 256)
  );defun


