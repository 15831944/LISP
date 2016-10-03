;13_12_12

;(setq str "pre%<\\AcObjProp Object(%<\\_ObjId 2127734848>%).Parameter(15).lookupString>%post")

(if (null sepstr) (load (strcat #lisppath "strings\\stringlib.LSP")))

(defun strreverse (str) (vl-list->string (reverse (VL-STRING->LIST str))))


(defun disel:structstring (str / bc ec pref suf)
  (setq bc "%<\\" ec ">%")
  (setq pref (substr str 1 (vl-string-search bc str)))
  (setq suf (strreverse (substr (strreverse str) 1 (vl-string-search (strreverse ec) (strreverse str)))))
  (setq fc (vl-string-left-trim pref (vl-string-right-trim suf str)))
  (list pref fc suf)
  )

;(disel:structstring str)
;(setq fldstr (cadr (disel:structstring str)))

(defun disel>list (fldstr / _fldstr bc ec pref postf fc)
  (setq bc "%<\\")
  (setq ec ">%")
  (setq _fldstr (vl-string-left-trim bc (vl-string-right-trim ec fldstr)))
  (if (null (vl-string-search bc _fldstr))
    ;(setq _fldstr "_ObjId 2127734848")
    (sepstr _fldstr " ")
    (progn
      (setq pref (substr _fldstr 1 (vl-string-search bc _fldstr)))
      (setq postf (strreverse (substr (strreverse _fldstr) 1 (vl-string-search (strreverse ec) (strreverse _fldstr)))))
      (setq fc (vl-string-left-trim pref (vl-string-right-trim postf _fldstr)))
      (list pref (disel>list fc) postf)
      )
    )
  );defun


;(disel>list fldstr)
  

; (setq lst '("AcObjProp Object(" ("_ObjId" "2124898840") ").TextString") )
(defun disel:struct>string (lst / bc ec out)
  (setq bc "%<\\")
  (setq ec ">%")
  (setq out
	 
  (mapcar
    '(lambda (x)
       (if (listp x)
	 (disel:struct>string (list (car x) " " (cadr x)))
	 x
	 )
       )
    lst
    )
	)
  (strcat bc (apply 'strcat out) ec )
  );defun

;;;  может не будет работать со сложными полями....  пока хватает...
;(disel:struct>string lst)