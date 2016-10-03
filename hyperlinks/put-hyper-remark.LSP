;;;; добавление пометки к элементу
;;;; средством hyperlink

(setq put-hyper-remark-URL-name "kd-hyper-remarks")


(defun c:rem ()
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		) T));acet-error-init
  (kd:put-hyper-remark)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  )

(defun kd:put-hyper-remark ( / obj str hls)
  (while (null obj)
    (setq obj (entsel))
    )
  (setq obj (vlax-ename->vla-object (car obj)))
  (setq str (car (kd:dclget '("текст пометки"))))
  ;;;------------------------------------------------
  (setq hls (vla-get-hyperlinks obj))
  (while (> (vla-get-Count hls) 0)
    (vla-delete (vla-item hls 0))
    (setq hls (vla-get-hyperlinks obj))
    )
    ;(do hls)
    ;(do (vla-item hls 1))
  (vla-add hls put-hyper-remark-URL-name str)
  ;;;------------------------------------------------
  );defun