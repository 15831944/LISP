(vl-load-com)
(defun do (obj) (vlax-dump-Object obj T))



(defun im ( / img)
  (setq img (vlax-ename->vla-object (car (entsel))))
  (vla-put-ImageFile img (VL-STRING-subst "LIVE" "DownLoad" (vla-get-ImageFile img)))
  )