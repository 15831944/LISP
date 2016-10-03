;((a b c) (1 2 3) (x y z)) ====>>> ((a 1 x) (b 2 y) (c 3 z))
(defun transform (lst)
  (apply 'mapcar (append '(list) lst))
  );defun



(setq t_head '("ID" "Description"))
(defun mk_t_corr (
	       head
	       /
	       data
	       )
  (setq data '())
  (foreach param head
    (setq data (append data (list
	(mapcar '(lambda (x) (vla-get-textstring (vlax-ename->vla-object x))) (ss->list (ssget '((0 . "*TEXT")))))
	)))
    )
  (transform data)
  );defun


(setq t_head '("—·ÓÍ‡" ("ÿÍ‡Ù")))

(defun mk_t_cons (head / lout ass)
  (setq lout '())
  (while (setq ass (car (entsel)))
    (setq lout (append lout
		   (list (cons
		       (vla-get-textstring (vlax-ename->vla-object ass))
		       (mapcar '(lambda (x) (vla-get-textstring (vlax-ename->vla-object x))) (ss->list* (ssget)))
		       )))))
);defun

(setq sborki (mk_t_cons t_head))
(set —¡Œ– ¿--1 (mk_t_cons t_head))
(setq —¡Œ– ¿--2 (mk_t_cons t_head))



(foreach shkaf sborki
  (mapcar '(lambda (x) (assoc x (read (car shkaf)))) (cdr shkaf))
  )



(mapcar '(lambda (x) '(a s d)) '(1 2 3))