;;;   ровнение набора текстовых элементов по X-координате верхнего


(defun c:txtalign ( / ss x)
  (if
    (and
      (or (setq ss (ssget "_I" '((0 . "*TEXT")))) (setq ss (ssget '((0 . "*TEXT")))))
      (setq ss (mapcar 'vlax-ename->vla-object (ss->sortedlst ss "-y")))
      )
    (progn
      (setq x (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint (car ss))))))
      (mapcar
	'(lambda (txt / pt) ; (setq txt (cadr ss))
	   (setq pt (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint txt))))
	   (vla-put-InsertionPoint txt (vlax-3d-point (list x (cadr pt))))
	   )
	ss)
      )
    )
  );defun