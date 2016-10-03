(defun spds-search)

(vlax-dump-object (vlax-ename->vla-object (car (entsel))) T)


