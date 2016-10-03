
;;; доступ к данным динамичесих блоков

(defun resetblock (
		   /
		   bl		; block ename
		   blo		;block object
		   sal1		;safe array list
		   pvl		;dinamic block properties value list
		   i
		   )

  (setq bl (car (entsel))	
	blo (vlax-ename->vla-object bl)
	sal (vlax-safearray->list (vlax-variant-value (vla-getDynamicBlockProperties blo)))
	pvl '()
	i 0
	)
  (repeat (length sal)
    (setq pvl (append pvl (list (vla-get-value (nth i sal)))))
    (setq i (1+ i))
    );repeat
  (vla-ResetBlock blo)
  (alert "asdfasdf")
  (setq i 0
	sal (vlax-safearray->list (vlax-variant-value (vla-getDynamicBlockProperties blo)))
	)
  (repeat (length sal)
    (if (< (vlax-variant-type (nth i pvl)) 100)
      (vla-put-value (nth i sal) (nth i pvl))
    )
    (setq i (1+ i))
    );repeat
  );defun



;;;
;;;
;;;
;;;(mapcar 'vlax-dump-object (vlax-safearray->list (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel)))))))
;;;
;;;(vlax-get-property (vlax-ename->vla-object (car (entsel))) 'getDynamicBlockProperties)
;;;
;;;
;;;
;;;(setq va (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel)))))
;;;(vla-ResetBlock (vlax-ename->vla-object (car (entsel))))
;;;
;;;(vla-add)
;;;(vlax-dump-object (vlax-ename->vla-object (car (entsel))))
;;;
;;;;;; катит!!!!!
;;;(vla-put-value (car (vlax-safearray->list (vlax-variant-value (vla-getDynamicBlockProperties (vlax-ename->vla-object (car (entsel))))))) "мостиковая")
;;;
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;(setq obj   (vla-get-ModelSpace actdoc))
;;;;;; #<VLA-OBJECT IAcadModelSpace2 0bbf0d44>
;;;(vla-AddMInsertBlock obj (vlax-3D-point (getpoint)) "VI" 1.2 0.9 1.2 (/ pi 8) 2 3 100 120)
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;; уже что-то
;;;(progn
;;;(setq name (cdr (assoc 2 (entget (setq e (car (entsel)))))))
;;;(vla-put-name (vlax-ename->vla-object e) name)
;;;;(vla-put-name (vlax-ename->vla-object (car (entsel))) "*U329")
;;;)
;;;
;;;
;;;
;;;(setq obj (vlax-ename->vla-object (car (entsel))))
;;;
;;;(vlax-dump-object obj T)
;;;
;;;
;;;(setq va (vla-GetDynamicBlockProperties obj))
;;;
;;;
;;;(vla-Update (vlax-ename->vla-object (car (entsel))))
;;;(vla-ResetBlock (vlax-ename->vla-object (car (entsel))))
;;;
;;;
;;;(setq sa (vlax-variant-value va))
;;;
;;;
;;;
;;;(vla-ConvertToAnonymousBlock (vlax-ename->vla-object (car (entsel))))
;;;(vlax-ename->vla-object (car (entsel)))
;;;(vla-ResetBlock (vlax-ename->vla-object (car (entsel))))