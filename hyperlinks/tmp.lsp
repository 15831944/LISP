(defun do (o) (vlax-dump-object o T))

(setq ktz-hyperlinkname-my-data "ktz-data-url")
(setq ktz-hyperlinkname-my-data "#,Лист1")

(defun puthyp (
               /
               eo
               )
    (setq eo (vlax-ename->vla-object (car (entsel))))
    ;(vla-get-hyperlinks eo)
    
    );defun



(ktz-put-hyperlink eo "#,Лист1")

(defun ktz-put-hyperlink (object str)
    (vla-add (vla-get-hyperlinks object)
             ktz-hyperlinkname-my-data
             str
             )
    )

(defun ktz-hyperlink-add-str (object
                              newstr
                              /
                              str
                              )
    (vla-add (vla-get-hyperlinks object)
             ktz-hyperlinkname-my-data
             str
             )
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq kd-hypermarks "kd-hyperremarks")

(setq object (vlax-ename->vla-object (car (entsel))))
(do (vla-get-hyperlinks object))


(vla-add (vla-get-hyperlinks object)
             kd-hypermarks
             "длиннаястрокадлиннаястрокадлиннаястрокадлиннаястрока"
             )