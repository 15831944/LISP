(defun lst-to-ss (lst / ss)
  (setq ss (ssadd))
  (mapcar '(lambda (x)
	     (ssadd
	       (if (= 'VLA-OBJECT (type x))
		 (vlax-vla-object->ename x)
		 x
		 )
	       ss)
	     );lambda
	  lst)
  ss
  );defun

;;;(defun lsto-to-ss (lst / ss)
;;;  (lst-to-ss (mapcar 'vlax-vla-object->ename lst))
;;;  );defun