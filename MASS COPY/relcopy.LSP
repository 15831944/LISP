;;; размножение элемента по примеру
;;; тыкаешь элемент, тыкаешь к какому элементу он "привязан"
;;; ssget базовых элементов возле которых надо вставить исходный элемент
;;; relcopy
;;; relcopy-ss
;;; copymacro
;;;
;;; 11_02_01


(defun relcopy (
		     /
		     obj
		     newo
		     base-el
		     ss
		     i
		     e
		     eng
		     dvect
		     doc
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

  (setq obj (vlax-ename->vla-object (car (entsel "\nукажите размножаемый элемент")))
	base-el (car (entsel "\nукажите объект-указатель")))
  (princ "\nтеперь выберите остальные указатели...")
  (setq ss (ssget)
	i 0)
  (setq dvect (mapcar '-
		(vlax-safearray->list(vlax-variant-value(vla-get-InsertionPoint obj)))
		(cdr (assoc 10 (entget base-el)))))
  (repeat (sslength ss)
    (setq newo (vla-copy obj))
    (vla-put-InsertionPoint newo
      (vlax-3d-point
	(mapcar '+ dvect (cdr (assoc 10 (entget (ssname ss i)))))
	)
      )
    (setq i (1+ i))
    );repeat

  (acet-error-restore)
  (vla-endundomark doc)
  (princ "\n ЗЫ текст может не переноситься если у него есть AlignmentPoint\n")
  );defun


;(vlax-dump-object (vlax-ename->vla-object (car (entsel)))T)



;;; прога работает и все размножает но поля ссылаются на исходные адреса,
;;; т.е. адреса не ассоциативны


(defun relcopy-ss (
		   /
		   obj
		   objl
		   ssobj
		   newo
		   base-el
		   ss
		   i
		   j
		   e
		   eng
		   dvect
		   doc
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
  (princ)
  (princ "\n укажите размножаемую выборку")
  (setq objl '()
	i 0
	ssobj (ssget))
  (repeat (sslength ssobj)
    (setq objl (append objl (list (vlax-ename->vla-object (ssname ssobj i)))))
    (setq i (1+ i))
    )
 
  ;(setq obj (vlax-ename->vla-object (car (entsel "\nукажите размножаемый элемент")))

  (setq base-el (car (entsel "\nукажите объект-привязку")))
  (princ "\nтеперь выберите элементы вдоль которых нужно размножить...")
  (setq ss (ssget))

  (foreach obj objl
    (setq i 0)
  (setq dvect (mapcar '-
		(vlax-safearray->list(vlax-variant-value(vla-get-InsertionPoint obj)))
		(cdr (assoc 10 (entget base-el)))))
  (repeat (sslength ss)
    (setq newo (vla-copy obj))
    (vla-put-InsertionPoint newo
      (vlax-3d-point
	(mapcar '+ dvect (cdr (assoc 10 (entget (ssname ss i)))))
	)
      )
    (setq i (1+ i))
    );repeat
    );foreach

  (acet-error-restore)
  (vla-endundomark doc)
  (princ "\n ЗЫ текст может не переноситься если у него есть AlignmentPoint\n")
  );defun


;;; такая прога размножает все с ассоциативными полями, переносит все ссылки :)
;;; 11_02_01


(defun c:cm () (copymacro))
(defun copymacro (
		  /
		  ssc		; ss to copy
		  ssb		; ss of base elements
		  be		; base entity
		  i
		  doc
		  )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0 ) T))

  (if (setq ssb (ssget "_I"))
    (progn
      (sssetfirst nil nil)
      (princ)
      (princ "\nSelect objects to copy....")
      (setq ssc (ssget))
      (princ "\nSelect base object....")
      (setq be (car (entsel)))
      )
    (progn
      (princ "\nSelect objects to copy....")
      (setq ssc (ssget))
      (princ "\nSelect base object....")
      (setq be (car (entsel)))
      (princ "\nSelect objects to paste near target object....")
      (setq ssb (ssget))
      )
    )
  (vl-cmdf "_copybase" (cdr (assoc 10 (entget be))) ssc "")
  (princ)
  (setq i 0)
  (repeat (sslength ssb)
    (vl-cmdf "_pasteclip" (cdr (assoc 10 (entget (ssname ssb i)))))
    (setq i (1+ i))
    )

  (acet-error-restore)
  (vla-endundomark doc)  
  
  );defun


