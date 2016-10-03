



(defun ss:str:antimtext ()
  (setq ss (ss->lsto* (ssget '((0 . "*TEXT,MULTILEADER")))))
  (mapcar '(lambda (x)
	     (vla-put-TextString x (str:antimtext (vla-get-TextString x)))
	     ) ss)
  )

(defun str:antimtext (str / str1 str2)
  (setq str1 str)
  (while (/= str1 str2)
    (setq str2 str1)
    (setq str1 (vl-string-subst " " "\\P" str1))
    (setq str1 (vl-string-subst " " "\n" str1))
    (setq str1 (vl-string-trim " " str1))
    (setq str1 (vl-string-subst " " "  " str1))
    )
  str1
  );defun




;;;(defun str:antimtext (str / nstr)
;;;    (setq nstr str)
;;;    (setq nstr (vl-string-subst " " "\\P" nstr))
;;;    (setq nstr (vl-string-subst " " "\n" nstr))
;;;    (setq nstr (vl-string-trim " " nstr))
;;;    (setq nstr (vl-string-subst " " "  " nstr))
;;;  (if (/= nstr str)
;;;    (str:antimtext nstr)
;;;    nstr
;;;    )
;;;  );defun


(defun ss:str:del-spaces ()
  (setq ss (ss->lsto* (ssget '((0 . "*TEXT,MULTILEADER")))))
  (mapcar '(lambda (x)
	     (vla-put-TextString x (str:del-spaces (vla-get-TextString x)))
	     ) ss)
  )

(defun str:del-spaces (str / str1 str2)
  (setq str1 str)
  (while (/= str1 str2)
    (setq str2 str1)
    (setq str1 (vl-string-subst "" " " str1))
    )
  str1
  );defun