;;; короче работает, норм, тока если загнацца передачей части строки, или дополнять вставляемую, то поля лучше



(setq od (namedobjdict))
(setq diclist '((0 . "DICTIONARY")(100 . "AcDbDictionary")))
(setq dict (entmakex diclist))
(setq link-dict-name "ktz-textlinks")
(dictadd od link-dict-name dict)


;(dictsearch (namedobjdict)"ktz-textlinks")

(vlr-remove-all)

(defun put-link (
		 /
		 od
		 diclist
		 dict
		 link-dict-name
		 
		 seo		;source text entity object
		 teo		;target text entity object
		 hand

		 rea-link
		 )
  
  (setq link-dict-name "ktz-textlinks")
  (if (not (dictsearch (setq od (namedobjdict)) link-dict-name))
    (progn
      (setq diclist '((0 . "DICTIONARY")(100 . "AcDbDictionary"))
	    dict (entmakex diclist))
      (dictadd od link-dict-name dict)
      )
    )

  (setq seo (vlax-ename->vla-object (car (entsel "\nобъект-источник")))		;;; source entity object
	teo (vlax-ename->vla-object (car (entsel "\nобъект-приемник"))))	;;; target entity object (linked)

  (vlax-ldata-put
    seo
    link-dict-name
    (list (vla-get-handle teo))
    )
  

  (setq :rea-link (vlr-object-reactor (list beo) nil (list '(:vlr-modified . children-modify))))
  
  );defun
  
  
  



(defun children-modify (
			a	; a - object
			b	; b - reactor
			c	;
			/
			acDoc		;active document
			ms		; model space
			hand
			child
			)

    (setq acDoc (vla-get-ActiveDocument (vlax-get-acad-object))
		ms (vla-get-modelspace acDoc))
  ;(vla-put-TextString (vlax-ename->vla-object (car (entsel))) txt)
  ;(vla-put-TextString (car c) txt)
  (setq hand (vlax-ldata-get a link-dict-name)
	child (vla-HandleToObject acDoc (car hand)))
  (vla-put-Textstring child (vla-get-TextString a))
  ;(princ "reaction")
  
    
  )
  



;(vlax-dump-object (vlax-ename->vla-object (car (entsel))))

;;;
;;;(vlr-types)
;;;(vlr-reactors)
;;;(vlr-type vlr-ktz-react)
;(vlr-reaction-names :vlr-object-reactor)
;:VLR-modified
;(vlr-types)
;(length (vlr-types))
;(VLR-Reaction-Names :VLR-Linker-Reactor)
;:VLR-modified
;(vlax-ldata-get (vlax-ename->vla-object (car (entsel))) "ktz-textlinks")








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  V2



(defun put-link ( / od
		 diclist
		 dict
		 link-dict-name
		 
		 seo		
		 teo		
		 hand

		 rea-link
		 )
  
  (setq link-dict-name "ktz-textlinks")
  (if (not (dictsearch (setq od (namedobjdict)) link-dict-name))
    (progn
      (setq diclist '((0 . "DICTIONARY")(100 . "AcDbDictionary"))
	    dict (entmakex diclist))
      (dictadd od link-dict-name dict)
      )
    (setq dict (cdr (cadr (member (cons 3 link-dict-name) (entget od)))))
    )

  (setq seo (vlax-ename->vla-object (car (entsel "\nобъект-источник")))		;;; source entity object
	teo (vlax-ename->vla-object (car (entsel "\nобъект-приемник"))))	;;; target entity object (linked)

  (vlax-ldata-put seo link-dict-name (list (vla-get-handle teo)))
  (setq rea-link (vlr-object-reactor (list beo) nil (list '(:vlr-modified . children-modify))))
  
  );defun
  
  
  



(defun children-modify (
			a	; a - object
			b	; b - reactor
			c	;
			/
			hand
			child
			)
  

  ;(setq a)
  (setq hand (vlax-ldata-get a link-dict-name)
	child (vla-HandleToObject #actdoc (car hand)))
  (vla-put-Textstring child (vla-get-TextString a))
  ;(princ "reaction")
  
    
  )