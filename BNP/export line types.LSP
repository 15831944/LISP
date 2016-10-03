(vl-load-com)
(setq #cad (vlax-get-acad-object)
      #actdoc (vla-get-activedocument #cad)
      #modspace (vla-get-modelspace #actdoc))



(defun c:exlt ( / linetypes line fpath lt)
  (setq linetypes (vla-get-Linetypes #actdoc))
  (setq fpath "D:\\type.lin")
  (setq line (vlax-ename->vla-object (car (entsel))))
  (setq lt (vla-get-linetype line))
  (cond
    ((= "ByLayer" lt)
     (setq lt (vla-get-layer line))
     (setq lt (vla-get-Linetype (vla-item (vla-get-layers #actdoc) lt)))
     )
    )
  (exlt|exportlinetype (vla-item linetypes lt) fpath)
  );


(defun exlt|exportlinetype (lto fpath / fo ltlist ltname ltdesc ltdef wval def)
    (defun exlt|get74 (wlist / ass74 rval)
      (setq ass74 (cdr (assoc 74 wlist)))
      (cond
	((= ass74 0) (exlt|return nil nil nil nil))
	((= ass74 1) (exlt|return (cdr (assoc 2 (entget (cdr (assoc 340 wlist))))) nil "A" nil))
	((= ass74 2) (exlt|return (cdr (assoc 2 (entget (cdr (assoc 340 wlist))))) (cdr (assoc 9 wlist)) "R" nil))
	((= ass74 3) (exlt|return (cdr (assoc 2 (entget (cdr (assoc 340 wlist))))) (cdr (assoc 9 wlist)) "A" nil))
	((= ass74 4) (exlt|return (cdr (assoc 3 (entget (cdr (assoc 340 wlist))))) nil "R" (cdr (assoc 75 wlist))))
	((= ass74 5) (exlt|return (cdr (assoc 3 (entget (cdr (assoc 340 wlist))))) nil "A" (cdr (assoc 75 wlist))))
	(T (exlt|return nil nil nil nil))
	)
      rval
      );defun
    (defun exlt|return (shx text rot shp / ttext test)
      (setq test (cdr (assoc 50 wlist)))
      (if (and test rot) (setq rot (strcat rot "=" (angtos test))))
      (setq test (cdr (assoc 46 wlist)))
      (if (and test rot) (setq rot (strcat rot ",S=" (rtos test 2 8))))
      (setq test (cdr (assoc 44 wlist)))
      (if (and test rot) (setq rot (strcat rot ",X=" (rtos test 2 8))))
      (setq test (cdr (assoc 45 wlist)))
      (if (and test rot) (setq rot (strcat rot ",Y=" (rtos test 2 8))))
      (if text (setq ttext (strcat ",[\"" text "\"," shx "," rot "]")))
      (if (and (not text) shp) (setq ttext (strcat ",[" (exlt|getname shp shx) "," shx "," rot "]")))
      (setq rval ttext)
      );defun
    (defun exlt|getname (shape shapefile / sfn lownum charcount shpcount zerocount this name char1)
      (if (setq sfn (open (findfile shapefile) "r"))
	(progn
	  (repeat 23 (read-char sfn))
	  (setq lownum (read-char sfn)) (read-char sfn)
	  (setq charcount (- shape lownum)) 
	  (setq hignum (read-char sfn)) (read-char sfn)
	  (setq shpcount (read-char sfn)) (read-char sfn)
	  (repeat (* shpcount 4) (read-char sfn))
	  (setq zerocount 0)
	  (while (< zerocount (* charcount 2))
	    (setq this (read-char sfn))
	    (if (= this 0) (setq zerocount (1+ zerocount))))
	  (setq char1 (read-char sfn))
	  (setq name "")
	  (while (/= 0 char1)
	    (setq name (strcat name (chr char1)))
	    (setq char1 (read-char sfn))
	    )
	  (close sfn)
	  name
	  )
	)
      );defun

    (setq ltlist (entget (vlax-vla-object->ename lto)))
    (setq fo (open fpath "w"))
    (setq ltname (strcat "*" (strcase (cdr (assoc 2 ltlist)))))
    (setq ltdesc (cdr (assoc 3 ltlist)))
    (setq ltdef "A" wval nil)
    (setq ltlist (member (assoc 49 ltlist) ltlist))
    (while (assoc 49 ltlist)
      (setq def (cdr (assoc 49 ltlist)))
      (setq def (strcat "," (rtos def 2 8)))
      (setq ltdef (strcat ltdef def))
      (setq ltlist (cdr (member (assoc 49 ltlist) ltlist)))
      (setq wval (exlt|get74 ltlist))
      (if wval (setq ltdef (strcat ltdef wval)))
      );while
    (if (/= ltdef "A")
      (progn
	(write-line (strcat ltname "," ltdesc) fo)
	(write-line ltdef fo)
	)
      )
    (close fo)
    )
(defun exlt|antisep (lst del)
  (vl-string-right-trim del (apply 'strcat (mapcar '(lambda (x) (strcat x del)) lst)))
  );defun
(defun exlt|getlttsts (lt)	;; get linetype text styles
  (mapcar
    '(lambda (a) (vlax-ename->vla-object (cdr a)))
    (vl-remove-if-not '(lambda (x) (= 340 (car x))) (entget (vlax-vla-object->ename lt)))
    )
  );defun
(defun exlt|isltspds (lt)
  (apply 'or (mapcar '(lambda (ts) ;(setq ts (car (getlttsts lt)))
	(null (or (member (strcase (vla-get-name ts)) (mapcar 'strcase #allowedtextstyles)) (= "" (vla-get-name ts)))))
	(exlt|getlttsts lt)
	))
    );defun

