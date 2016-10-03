;;  13_07_29 ..... надо переписать
;;  14_05_05 - переписал! УРА

;;;(vl-string->list (vla-get-textstring (vlax-ename->vla-object (car (entsel)))))
;;;
;;;
;;;{   a   d    s   f  a   d   s \  \c  1  2  3  ;   a  s   d   a   s  d}
;;;123 97 100 115 102 97 100 115 92 99 49 50 51 59 97 115 100 97 115 100 125)
;;;
;;;
;;;
;;;(vl-string->list (vla-get-textstring (vlax-ename->vla-object (car (entsel)))))
;;;
;;;1FT-7201A_XQ01
;;;"{\\fArial|b0|i0|c0;\\c0;1FT-7201A_XQ01"
;;;     \\  f   A  r   i   a  l   |                              ;
;;;(123 92 102 65 114 105 97 108 124 98 48 124 105 48 124 99 48 59 92 99 48 59 49 70 84 45 55 50 48 49 65 95 88 81 48 49)
;;;


;;;
;;;;(setq str (vla-get-textstring (vlax-ename->vla-object (car (entsel)))))
;;;;(kd:mtextstring-unformat (vla-get-TextString (vlax-ename->vla-object (car (entsel)))))
;;;(defun kd:mtextstring-unformat (str / strlst nlst iscode i)
;;;  ;(setq str (vla-get-TextString (vlax-ename->vla-object (car (entsel)))))
;;;  (setq strlst (vl-string->list str))
;;;  (setq nlst '() iscode 0)
;;;  (setq i 0)
;;;  
;;;  (repeat (length strlst)
;;;    (setq sym (nth i strlst))
;;;    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;    (if (and
;;;	  (= sym (ascii "\\"))
;;;	  (/= (nth (1+ i) strlst) 85)
;;;	  )
;;;      (setq iscode (1+ iscode))
;;;      )
;;;    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;    (if (and
;;;	  (/= 0 iscode)
;;;	  (= sym (ascii ";"))
;;;	  )
;;;      (setq iscode (1- iscode))
;;;      )
;;;    
;;;    (if (and
;;;	  (= 0 iscode)
;;;	  sym
;;;	  )
;;;      (setq nlst (append nlst (list sym)))
;;;      )
;;;    
;;;    (if (and
;;;	  (> iscode 0)
;;;	  (= 80 (nth (1+ i) strlst))
;;;	  )
;;;      (setq nlst (append nlst (list sym (nth (1+ i) strlst)))
;;;	    i (1+ i)
;;;	    iscode (1- iscode))
;;;      )
;;;    (setq i (1+ i))
;;;    );foreach
;;;  (setq nlst (vl-list->string nlst))
;;;  (setq nlst (vl-string-trim ";{}" nlst))
;;;  );defun



;(kd:mtextstring-unformat (vla-get-textstring (vlax-ename->vla-object (car (entsel)))))


;(kd:mtextstring-unformat (kd-get-TextString (car (entsel))))
;(kd-get-TextString (car (entsel)))
(defun c:mtxtunf ( / ss)
  (setq ss (ss->lsto* (ssget '((0 . "*TEXT,MULTILEADER")))))
  (mapcar '(lambda (obj)
	     (vla-put-textstring obj (kd:mtextstring-unformat
				       ;(vla-get-textstring obj)	;; 13_07_29
				       (kd-get-TextString obj)
				       ))
	     ) ss)
  )


(defun c:g:mtxtunf ( / ss)
  (setq ss (vlax-ename->vla-object (car (nentsel))))
  (vla-put-textstring ss (kd:mtextstring-unformat (kd-get-TextString ss)))
  )





;;;
;;; 
;;;; mip_MTEXT_Unformat автор VVA
;;;; http://forum.dwg.ru/showpost.php?p=138785&postcount=24
;;;(defun mip_MTEXT_Unformat ( Mtext / text Str )
;;;  (setq Text "")
;;;   (while (/= Mtext "")
;;;        (cond
;;;          ((wcmatch (strcase (setq Str (substr Mtext 1 2))) "\\[\\{}]")
;;;            (setq Mtext (substr Mtext 3) Text   (strcat Text Str)))
;;;          ((wcmatch (substr Mtext 1 1) "[{}]")(setq Mtext (substr Mtext 2)))
;;;          ((wcmatch (strcase (setq Str (substr Mtext 1 2))) "\\[LO`~]")
;;;	   (setq Mtext (substr Mtext 3)))
;;;          ((wcmatch (strcase (substr Mtext 1 2)) "\\[ACFHQTW]")
;;;            (setq Mtext (substr Mtext (+ 2 (vl-string-search ";" Mtext)))))
;;;          ((wcmatch (strcase (substr Mtext 1 2)) "\\P")
;;;            (if (or(= " " (substr Text (strlen Text)))
;;;		   (= " " (substr Mtext 3 1)))
;;;               (setq Mtext (substr Mtext 3))
;;;               (setq Mtext (substr Mtext 3) ;|Text (strcat Text " ")|;))) ; закомментировано для текущей задачи
;;;	  ((wcmatch (strcase (substr Mtext 1 2)) "\\S")
;;;            (setq Str   (substr Mtext 3 (- (vl-string-search ";" Mtext) 2))
;;;                  Text  (strcat Text (vl-string-translate "#^\\" "/^\\" Str))
;;;                  Mtext (substr Mtext (+ 4 (strlen Str)))))
;;;	  (t (setq Text (strcat Text (substr Mtext 1 1)) Mtext (substr Mtext 2)))
;;;	  ))
;;;  Text
;;;  ); end mip_MTEXT_Unformat
;;;
;;;
;;;
;;;; Вызов mtext->block
;;;(defun c:mtext->block()
;;;  (vla-startundomark (vla-get-activedocument (vlax-get-acad-object)))
;;;  ((lambda (block_name template sel_mtext)
;;;     (if (and sel_mtext
;;;              (or (tblsearch "BLOCK" block_name)
;;;                  (findfile block_name)
;;;                  )
;;;              )
;;;       (foreach item (vl-remove-if 'listp (mapcar 'cadr (ssnamex sel_mtext)))
;;;         ((lambda(ins_point lst_attr)
;;;            (if (vl-every 'wcmatch lst_attr template)
;;;              (if (not (vl-catch-all-error-p
;;;                         (vl-catch-all-apply 'apply
;;;                                             (list 'vl-cmdf (append (list  "_.-insert" block_name ins_point "" "" "") lst_attr))
;;;                                             )
;;;                         )
;;;                       )
;;;                (entdel item)
;;;                )
;;;              )
;;;            )
;;;           (cdr (assoc 10 (entget item)))
;;;           ((lambda(f_rec str)
;;;              (f_rec str template)
;;;              )
;;;             (lambda(ss temp)
;;;               (if (and (/= ss "")
;;;                        temp
;;;                        )
;;;                 (cons (substr ss 1 (strlen (car temp))) (f_rec (substr ss (1+ (strlen (car temp)))) (cdr temp)))
;;;                 )
;;;               )
;;;             (mip_MTEXT_Unformat (cdr (assoc 1 (entget item))))
;;;             )
;;;           )
;;;         )
;;;       )
;;;     )
;;;    "Block"	; здесь имя блока или путь до файла *.dwg
;;;    (list "@@@" "###" "@@" "###" "@")	; здесь изменяемый шаблон для выборки mtext'а (это конкртено для твоего примера)
;;;    (ssget "_X" (list (cons 0 "MTEXT")))
;;;    )
;;;  (vla-endundomark (vla-get-activedocument (vlax-get-acad-object)))
;;;  (princ)
;;;  ); end c:mtext->block
;;;
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;(setq str (kd-get-Textstring (car (entsel))))

(defun kd:mtextstring-unformat (str / strparts mtu:sepstr mtu:searchchar res)
  (defun mtu:sepstr (strline delimiter / strhead strtail poz)
    (if (setq poz (mtu:searchchar delimiter strline))
      (progn (setq strhead (substr strline 1 poz) strtail (substr strline (+ poz 1 (strlen delimiter))))
	(append (list strhead) (mtu:sepstr strtail delimiter)))
      (list strline)
      )
    );defun
  (defun mtu:searchchar (char str / strl poz)
    (setq poz -1)
    (if (null (and (setq poz (vl-string-search char str (1+ poz))) (= 0 poz)))
      (progn (while (and poz (= 92 (vl-string-elt str (1- poz)))) (setq poz (vl-string-search char str (1+ poz)))))
      )
    poz
    );defun
  (setq res (str|replacechars " " "  " (str|remove-multi-lines str)))
  (setq strparts (apply 'append (mapcar '(lambda (x) (mtu:sepstr x "}")) (mtu:sepstr res "{"))))
  (setq res
     (apply 'strcat
	(apply 'append
	  (mapcar
	    '(lambda (cstr)		;(setq cstr (car strparts))
	       (mapcar
		 '(lambda (x)
		    (last (sepstr x ";"))
		    )
		 (sepstr cstr "\\")
		 )
	       )
	    strparts
	    )
	       )
	    ))
  (vl-string-left-trim "ol" res)
  );defun
  

;(kd:mtextstring-unformat (kd-get-Textstring (car (entsel))))


;(vla-addtext #modspace (kd:mtextstring-unformat (kd-get-Textstring (car (entsel)))) (vlax-3d-point (getpoint)) 2.5)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;
;;;\\W0.9
;;;\\T1.15


;	multi text edit format

(defun c:mtxtef ( / obj str)
  (defun mtu:sepstr (strline delimiter / strhead strtail poz)
    (if (setq poz (mtu:searchchar delimiter strline))
      (progn (setq strhead (substr strline 1 poz) strtail (substr strline (+ poz 1 (strlen delimiter))))
	(append (list strhead) (mtu:sepstr strtail delimiter)))
      (list strline)
      )
    );defun
  (defun mtu:searchchar (char str / strl poz)
    (setq poz -1)
    (if (null (and (setq poz (vl-string-search char str (1+ poz))) (= 0 poz)))
      (progn (while (and poz (= 92 (vl-string-elt str (1- poz)))) (setq poz (vl-string-search char str (1+ poz)))))
      )
    poz
    );defun
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (setq str (vla-get-textstring obj))
  (setq res (str|replacechars " " "  "(str|remove-multi-lines str)))
  (setq strparts (apply 'append (mapcar '(lambda (x) (mtu:sepstr x "}")) (mtu:sepstr res "{"))))


  (mapcar
    '(lambda (cstr)		;(setq cstr (cadr strparts))
       
       
       )
    strparts
    )



  
  
  );defun



(defun c:mtxtstrcase ( / lst)
  (vla-startundomark #actdoc)
  (setq lst (ss->lsto* (ssget '((0 . "*TEXT,MULTILEADER")))))
  (mapcar
    '(lambda (obj / str)	;(setq obj (car lst))
       (setq str (kd-get-textstring obj))
       (vla-put-textstring obj (strcase str))
       )
    lst)
  (vla-endundomark #actdoc)
  )