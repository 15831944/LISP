;;; изменена 10_08_09
;;; ktz-reset-block
;;; прога для регенерации оотбражения блоков
;;; например при изменении содержания аттрибутов они могут залазить
;;; на блок, становится некрасиво
;;; использована при разработке пульта БЩУ Береза
;;; -kakt00z-™  ©

;;; баг - если блок имеет 1 динамический параметр - базовую точку, сервер ActiveX выдает
;;; ошибку, т.е. не выполняется команда vlax-safearray->list для safearray варианта свойств динамического блока
;;; ниже поиск ошибки и решение
;;; если степеней свободы у блока нет, то
;;; (vlax-safearray-get-U-bound (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))) 1)
;;; дает -1, если же степеней свободы много то значение принимается от 1 до ...

(vl-load-com)


(defun c:ktz-blres ( / ss i)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T));acet-error-init
  (setq ss (ssget '((0 . "INSERT"))) i 0)
  (repeat (sslength ss)
    ;(ktz-reset-block (ssname ss i))
    (kd|resetblock (vlax-ename->vla-object (ssname ss i)))
    ;(command "_resetblock" ss "")
    (setq i (1+ i))
    )
  (acet-error-restore)
  (vla-endundomark #actdoc)
  (command "_updatefield" ss "")
  (sssetfirst nil ss)
  );defun




;(setq blo (vlax-ename->vla-object (car (entsel))))
(defun kd|resetblock (blo / dyns vals)
  (if
    ;(= (vla-get-IsDynamicBlock blo) :vlax-true)
    ;(vlax-safearray-get-U-bound (setq dyns (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel)))))) 1)
    (>= (vlax-safearray-get-U-bound (setq dyns (vlax-variant-value (vla-getDynamicBlockProperties blo))) 1) 0)
    (progn
      (setq dyns (vlax-safearray->list dyns))
      (setq vals (mapcar '(lambda (d) (list (vla-get-PropertyName d) (vla-get-Value d))) dyns))
      (vla-ResetBlock blo)
      (setq dyns (vlax-safearray->list (vlax-variant-value (vla-getDynamicBlockProperties blo))))
      (mapcar
	'(lambda (d v)
	   (if (= "Origin" (vla-get-PropertyName d))
	     (princ)
	     (if (= (vla-get-PropertyName d) (car v))
	       (vla-put-Value d (cadr v))
	       (princ "\nДинамические свойства блока не совпадают\n")
	       )
	     )
	   )
	dyns vals
	)
      )
    (vla-ResetBlock blo)
    )
  T
  );defun








  

(defun ktz-reset-block (blo ; block ename
			/
			;blo ;block object
			vval ; variant value
			sal ;safe array list
			pvl ;dinamic block properties value list
			i)
  (if (= 'ENAME (type blo)) (setq blo (vlax-ename->vla-object blo)))

  ;(if (= (vla-get-IsDynamicBlock blo) :vlax-true)
  (if (> (vlax-safearray-get-U-bound (vlax-variant-value (vla-getDynamicBlockProperties blo)) 1) 0)
    (progn
      ;(= (vla-get-IsDynamicBlock (vlax-ename->vla-object (car (entsel)))) :vlax-true)
      (setq sal (vlax-safearray->list (vlax-variant-value (vla-getDynamicBlockProperties blo)))
	    pvl '()
	    i   0
	    ) ;_ setq

      	;(vlax-dump-object (vlax-ename->vla-object (car (entsel))) T)
	;(vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))
      	;(vlax-variant-type (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel)))))
	;(vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel)))))

      	;error
	;(vlax-safearray->list (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))))
      	;(vlax-safearray-get-element (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))) 0)
      
      	;(vlax-safearray-type (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))))
      	;(vlax-safearray-get-dim (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))))
	;(vlax-safearray-get-l-bound (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))) 1)
      	;(vlax-safearray-get-U-bound (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))) 1) - вот разница !!!!
      
      (repeat (length sal)
	(setq pvl (append pvl (list (vla-get-value (nth i sal)))))
	(setq i (1+ i))
	) ;repeat
      (vla-ResetBlock blo)
      (setq i	0
	    sal	(vlax-safearray->list
		  (vlax-variant-value (vla-getDynamicBlockProperties blo))
		  ) ;_ vlax-safearray->list
	    ) ;_ setq
      (repeat (length sal)
	(if (< (vlax-variant-type (nth i pvl)) 100)
	  (vla-put-value (nth i sal) (nth i pvl))
	  ) ;_ if
	(setq i (1+ i))
	) ;repeat
      ) ;progn
    ) ;if
  ) ;_ defun




;;;
;;;(vla-get-IsDynamicBlock blo)
;;;(vlax-method-applicable-p blo 'vla-getDynamicBlockProperties)
;;;(vlax-safearray->list (vlax-variant-value (vla-getDynamicBlockProperties blo)))
;;;(vlax-safearray-type (vlax-variant-value (vla-getDynamicBlockProperties blo)))



;;; разбор формата

;(setq vlst (vlax-safearray->list (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel)))))))
;(vlax-dump-object (nth 0 vlst))
;(vla-get-AllowedValues (nth 4 vlst))

;(vlax-safearray->list (vlax-variant-value (vla-get-AllowedValues (nth 4 vlst))))
;(vlax-variant-value (car (vlax-safearray->list (vlax-variant-value (vla-get-AllowedValues (nth 4 vlst))))))