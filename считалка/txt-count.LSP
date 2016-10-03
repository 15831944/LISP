(defun c:qwer ( /
	       ss
	       att
	       i
	       )
  (if (not (setq ss (ssget "_I")))
    (setq ss (ssget))
    )
  (setq ss (mapcar 'vlax-ename->vla-object (ss->lst ss)))
  (setq i 1)
  (foreach att ss
    (vla-put-tagstring att (strcat "MARK" (itoa i)))
    (setq i (1+ i))
    )
  );def