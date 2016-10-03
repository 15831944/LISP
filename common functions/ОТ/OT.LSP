


(setq obj (vlax-ename->vla-object (car (entsel))))


(vlax-get-property obj "Color")



(defun c:asd ( / obj layer color)
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (cond
    ((= 256 (vlax-get-property obj "Color"))
     (setq layer (vla-item (vla-get-Layers #actdoc) (vla-get-Layer obj)))
     (setq color (vlax-get-property layer "Color"))
     (setq color (acad_colordlg color T))
     (vlax-put-property layer "color" color)
     )
    )
  (command "_regenall")
  color
  );defun


(setq lst (ss->lsto* (ssget "_X" '((0 . "LWPOLYLINE")))))
(length lst)

(mapcar 'explode-pline lst)







;;;;		COPY TO CLIPPBOARD FAILED - решение см ниже

(setq badblref (vlax-ename->vla-object (car (entsel))))

(setq blk (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName badblref)))
(do blk)

(vlax-for item blk)
(do (vla-item blk 1))







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq baddim (vlax-ename->vla-object (car (entsel))))
(setq gooddim (vlax-ename->vla-object (car (entsel))))

(do baddim)


(do gooddim)


(vla-get-HasExtensionDictionary baddim)
(vla-get-HasExtensionDictionary gooddim)




;;;(setq lst (ss->lsto* (ssget)))
;;;(sssetfirst nil
;;;(lst-to-ss
;;;(vl-remove-if-not
;;;  '(lambda (x)
;;;     (= :vlax-true (vla-get-HasExtensionDictionary x))
;;;     )
;;;  lst
;;;  )
;;;)) (setq lst nil)


(setq badobj (car lst))

(setq exd (vla-GetExtensionDictionary badobj))
(do exd) (cdo exd)

(do (vla-item exd 0))

(entget (vlax-vla-object->ename (vla-item exd 0)))









;;;;		COPY TO CLIPPBOARD FAILED - решение см ниже

(defun heal ( / obj exd)
  (if
    (and
      (setq obj (entsel))
      (setq obj (vlax-ename->vla-object (car obj)))
      (= :vlax-true (vla-get-HasExtensionDictionary obj))
      (setq exd (vla-GetExtensionDictionary obj))
      )
    (progn
      (mapcar '(lambda (x) (if (= "AcDbZombieObject" (vla-get-ObjectName x)) (vla-delete x))) (cont>list exd))
      (if (= 0 (vla-get-Count exd)) (vla-delete exd))
      )
    )
  );defun



(sssetfirst nil (ssget "_X" '((0 . "ACAD_PROXY_ENTITY"))))



(defun heal* (obj / exd)
  (if
    (and
      (= :vlax-true (vla-get-HasExtensionDictionary obj))
      (setq exd (vla-GetExtensionDictionary obj))
      )
    (progn
      (mapcar '(lambda (x) (if (= "AcDbZombieObject" (vla-get-ObjectName x)) (vla-delete x))) (cont>list exd))
      (if (= 0 (vla-get-Count exd)) (vla-delete exd))
      )
    )
  );defun

(setq lst (ss->lsto* (ssget)))
;(setq lst (ss->lsto* ss))
;(length lst)
(setq lst (vl-remove-if-not '(lambda (x) (= :vlax-true (vla-get-HasExtensionDictionary x))) lst))
;(length lst)
(sssetfirst nil (lst-to-ss lst))

;;;  !!! ВОТ
(mapcar 'heal* lst)



;(heal)



















