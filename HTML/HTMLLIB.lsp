




(setq htmlcode
   (list
     '("html"
       '("head"
	 '("title" "My Title")
	 )
       '("body"
	 '("p" "Hello world!")
	 )
       )
     )
      )






;;;;;		HTML TABLES

(if
(or
  (setq lst (ssget "_I" '((0 . "INSERT"))))
  (and (setq lst (ssget* '((0 . "INSERT")))) (= 'PICKSET (type lst)))
  )
(progn
  (setq lst (ss->lsto lst))
  (setq data (mapcar '(lambda (x) (blref-to-data x #blks>excel:isFielding)) lst))
  (setq head (origlist (mapcar 'car (apply 'append data))))
  (setq res (mapcar '(lambda (bobj) (mapcar '(lambda (par / a) (if (setq a (assoc par bobj)) (cadr a)"")) head)) data))
  (setq res (cons head res))
  )
)


(setq tbl res)



(setq tbl (excel>lst))



(setq tag:td "td")
(setq tag:tr "tr")
(setq tag:thead "thead")
(setq tag:tbody "tbody")

(defun html:tagWrap (data tag) (strcat "<" tag ">" " " data " " "<" "/" tag ">"))
(defun html:2DLstWrap (tbl)
  (apply 'strcat
    (mapcar
      '(lambda (line)
	 (html:tagWrap
	   (apply 'strcat
	     (mapcar '(lambda (cell) (html:tagWrap cell tag:td)) line)
	     )
	   tag:tr
	   )
	 )
      tbl)
    )
  );defun


(setq res (list 
(html:tagWrap
(strcat
  (html:tagWrap
    (apply 'strcat (mapcar '(lambda (cell) (html:tagWrap cell "th")) head))
    "thead"
    )
  (html:tagWrap
    (html:2DLstWrap (cdr tbl))
    "tbody"
    )
  )
"table"
)))


(setq hand (open "d:\\asd.txt" "w"))
(mapcar '(lambda (x) (write-line x hand)) res)
(close hand)


(setq fileName (kd:safeFilename "c:\\Server\\domains\\localhost\\public_html\\index3.php"))
(setq hand (open fileName "w"))
(mapcar '(lambda (x) (write-line x hand)) res)
(close hand)


(command "._browser" fileName)



(setq obj (vlax-get-or-create-object "FirefoxURL"))
(vlax-dump-object obj)
(vlax-release-object obj)


vlax-get-or-create-object

vlax-g

interface





(vlax-import-type-library  :tlb-filename "c:/program files/microsoft office/msword8.olb"  :methods-prefix "msw-"  :properties-prefix "msw-"  :constants-prefix "mswc-")
T


