; 11_08_04
; пока прога увеличивает цифровое значение текстовых примитивов
; (аттрибутов блоков) на заданную величину
; но проект нужно сделать что-то типа
; авто-ренумератора с префиксной/постфиксной возможностью добавлени€
; -kakt00z-Щ  ©


(defun recount (
		/
		doc
		ss
		str
		dn
		)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init

  (if (not (setq ss (ssget "_I" '((0 . "*TEXT")))))
    (setq ss (ssget '((0 . "*TEXT"))))
    );if
  
  (setq dn 1)

  (setq ss (mapcar 'vlax-ename->vla-object (ss->list* ss)))
  
  (foreach to ss
    (setq str (vla-get-TextString to))
    (setq str (itoa (+ (atoi str) dn)))
    (vla-put-TextString to str)
    )
  (acet-error-restore)
  (vla-endundomark doc)
  );defun




(defun recount*bl (
		/
		doc
		ss
		str
		dn
		atag
		)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init

  (if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
    (setq ss (ssget '((0 . "INSERT"))))
    );if
  
  (setq dn 1)
  (setq atag "number")


  
  (setq ss (mapcar 'vlax-ename->vla-object (ss->list* ss)))

  (setq ss (mapcar '(lambda (x) (getbatt x atag)) ss))

  
  
  (foreach to ss
    (setq str (vla-get-TextString to))
    (setq str (itoa (+ (atoi str) dn)))
    (vla-put-TextString to str)
    )
  (acet-error-restore)
  (vla-endundomark doc)
  );defun




(setq str "CBA-301")

(defun anum-str-format (str
			/
			lst
			code
			number
			n
			)
  (setq lst (vl-string->list str))
  (setq number (vl-member-if '(lambda (x) (and (>= x 48) (<= x 57))) lst))
  (vl-some)
  (setq number (vl-list->string number))
  (setq code (vl-string-right-trim (vl-list->string number) str))
  
  )


(defun list-minus (a b)
  )