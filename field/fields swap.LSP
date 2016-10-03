;;		15_10_21
(defun c:fswap ( / obj wamark fc cid camark str)
  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  ;(setq wamark (getbatt obj "MARK"))
  (setq wamark (vlax-ename->vla-object (car (nentsel))))
  (setq fc (kd:getfieldcode wamark))
  (setq cid (atoi (car (sepstr (cadr (sepstr fc "ObjId ")) ">%)"))))
  (setq camark (vla-ObjectIDToObject #actdoc cid))
   
  (setq str (vla-get-textstring camark))
  (vla-put-TextString camark "")
  (vla-put-TextString wamark "")
  (vla-put-TextString wamark str)
  (vla-put-textstring camark (kfl:IDtoFC (vla-get-objectid wamark)))
  (vla-update camark)
  (if (= "AcDbAttribute" (vla-get-objectname camark)) (vl-cmdf "_updatefield" (vlax-vla-object->ename (vla-ObjectIDToObject #actdoc (vla-get-OwnerID camark))) ""))
  );defun


;;;(mapcar
;;;  (function
;;;    (lambda (sym)	;(setq sym (nth 1 '(obj wamark weamark wgeamark fld camark str)))
;;;      (eval
;;;	(list 'setq sym 'nil)
;;;	)
;;;      )
;;;    )
;;;  '(obj wamark weamark wgeamark fld camark str)
;;;  )