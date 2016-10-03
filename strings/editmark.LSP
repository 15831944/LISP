(load (strcat #lisppath "DCL/dcledit.lsp"))



;(setq str (vla-get-textstring (vlax-ename->vla-object (car (entsel)))))
;(getmarkformat str)





(defun getmarkformat (str)
  (mapcar 'str|charcategory (mapcar 'chr (vl-string->list str)))
  );defun

(defun markcount (lst / fr i)
(setq fr '(1) i 1)
  (repeat (length (cdr lst))
    (if (= (nth i lst)(nth (1- i) lst))
      (setq fr (append
		 (reverse (cdr (reverse fr)))
		 (list (1+ (last fr)))
		 ))
      (setq fr (append fr (list 1)))
      )
    (setq i (1+ i))
    )
  fr
  );defun


(defun str-separate (str / idxlist cnt)
  (setq cnt 1 idxlist '())
  (foreach ind (markcount (getmarkformat str))
    (setq idxlist (append idxlist
			  (list
			    (substr str cnt ind)
			    )
			  ))
    (setq cnt (+ cnt ind))
    )
  idxlist
  )

;;;(str-separate str)
;;;(str-separate (vla-get-textstring (vlax-ename->vla-object (car (entsel)))))

(defun edit-mark (obj / strl)
  (if (setq strl (kd:dcledtlst (str-separate (vla-get-textstring obj))))
    (vla-put-textstring obj (eval (append '(strcat) strl)))
    )
  )



(defun c:em (/ obj)
;  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T	
	  );list
    );acet-error-init
  (if (setq obj (nentsel))
    (edit-mark (vlax-ename->vla-object (car obj)))
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun





;(kd:dcledtlst (str-separate (vla-get-textstring (vlax-ename->vla-object (car (nentsel))))))