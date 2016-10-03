;;;******************************************************************************
;;; ессли есть аттрибут с содержимым "HAND" ссылочного блока, то зуммирует на него
;;;******************************************************************************
(defun c:zh () (g:kd:zoomtohand))
(defun g:kd:zoomtohand ( / obj str)
  (setq str (vl-catch-all-apply 'nentsel))
  (if
    (or
      (null str)
      (vl-catch-all-error-p str)
      )
    (setq str (car (kd:dclget '("HANDLE"))))
    (setq str (vla-get-textstring (vlax-ename->vla-object (car str))))
    )
  ;(setq str (vla-get-textstring (vlax-ename->vla-object (car (nentsel)))))
  
  (ZoomToHand str)
  )
;;;******************************************************************************

(defun ZoomToHand (str / err)
  ;(setq str (vla-get-TextString (vlax-ename->vla-object (car (entsel)))))
  (if (and str
	(null (vl-catch-all-error-p (setq err (vl-catch-all-apply 'vla-HandleToObject (list #actdoc str)))))
	)
    (progn
      (setq err (vlax-vla-object->ename err))
      (vl-cmdf "_.zoom" "_O" err "")
      (SSSETFIRST nil (ssadd err))
      )
    (princ (strcat "\n" (VL-CATCH-ALL-ERROR-MESSAGE err)))
    )
  );defun



;;;  (initget 1 "handle")
;;;  (setq rule (getkword "\n Правило сортировки : [handle] <handle> \n"))
;;;
;;;
;;;(initget 8 "handle")
;;;(setq rule (getkword "\n Правило 	сортировки : \n"))



(defun c:gh ( / obj str to)
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (setq to (vla-addtext #modspace (vla-get-handle obj) (vlax-3d-point (getpoint)) 2.5))
  (vla-put-layer to "com_unplotted")
  (vlax-release-object obj)
  (vlax-release-object to)
  )