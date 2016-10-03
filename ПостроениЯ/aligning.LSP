;;; прога выполняет построения (перепостроения элементов)
;;; выравнивая их на заданном расстоянии горизонтально или вертикально
;;; БАГ - если строим тексты с привязкой отличной от "влево" - блоки не ровняются - у них друггой параметр вставки текста - TextAlignmentPoint
;;; 11_06_01


(defun ss-align (
		 /
		 doc
		 ss
		 lst
		 i
		 
		 bpt
		 dv

		 e
		 eg
		 obj
		 err
		 )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		;"osmode" 0
		);list
	  T
	  );list
    );acet-error-init


  (princ "\nвыберите элементы для выравнивания...")
  (setq ss (ssget );'((0 . "TEXT")))
	)
  (princ "\nукажите последовательность сортировки выбранных элементов....")
  (setq lst (ss->list ss))
  (setq	i 0
	bpt (getpoint "\nукажите точку начала постоения...")
	dv (getpoint bpt "\nукажите расстояние между элементами в линии...")
	dv (mapcar '- dv bpt))

  (repeat (length lst)
    (setq obj (vlax-ename->vla-object (nth i lst)))
    (if (vlax-property-available-p obj "InsertionPoint" T)
      (vla-put-InsertionPoint obj
	(vlax-3d-point
	  (mapcar '+ bpt
		  (mapcar '(lambda (x) (* i x)) dv)
		  )))
      ;else
      (setq err T)
      );if
    (setq i (1+ i))
    );repeat

  (acet-error-restore)
  (vla-endundomark doc)
  (if err (alert "\nу одного из объектов не свойства \"InsertionPoint\""))
  );defun



;; 15_10_26
