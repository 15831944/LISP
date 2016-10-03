;; хрень

(defun kvla-get-dyn-block-property (
				    bl
				    property
				    /
				    blo
				    sal
				    
				    i
				    olist
				    )
  (setq	blo (vlax-ename->vla-object bl)
	sal (vlax-safearray->list
	      (vlax-variant-value
		(vla-getDynamicBlockProperties blo)))
	pvl '()
	i 0)
  
  (repeat (length sal)
    (if (= property (vla-get-PropertyName (nth i sal)))
      (setq olist (list property
			;(vlax-variant-value
			(vla-get-value (nth i sal))
			;)
			))
      )
    ;(setq pvl (append pvl (list (vla-get-value (nth i sal)))))
    (setq i (1+ i))
    );repeat
  olist
  )




;;;(setq	blo (vlax-ename->vla-object (car (entsel)))
;;;	sal (vlax-safearray->list
;;;	      (vlax-variant-value
;;;		(vla-getDynamicBlockProperties blo)))
;;;	)
;;;
;;;(mapcar 'vla-get-value sal)
;;;
;;;(vlax-safearray->list (vlax-variant-value (vla-get-value (cadr sal))))