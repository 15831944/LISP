(load "D:\\LISP WORKING\\common functions\\lst-to-ss.LSP")

;;;;
(sel '("HATCH" "AREA"))
(setq props '("HATCH" "AREA" "Patterntype"))
(setq props '("TEXT" "TextString" "layer"))

(sel props)
(defun sel (props
	    /
	    lst
	    samplobj
	    propsC
	    propvals
	    l
	    )
  (setq lst (ss->lsto* (ssget (list (cons 0 (car props))))))
  (setq samplobj (vlax-ename->vla-object (car (entsel))))
  (setq propsC (mapcar '(lambda (x) (read (strcat "vla-get-" x))) (cdr props)))
  (setq propvals (mapcar '(lambda (x) (eval (list x samplobj))) propsC))
  (setq l
    (vl-remove-if-not '(lambda (x)
	(eval
	  (cons 'and
	  (mapcar '(lambda (a b)
	     (= (eval (list a x)) b))
		  propsC propvals
		  )))) lst))
  (sssetfirst nil (lst-to-ss (mapcar 'vlax-vla-object->ename l)))
  );defun



(sssetfirst nil (ssget '((0 . "*TEXT")(1 . "*ì\U+00B3*"))))

(sssetfirst nil (ssget '((0 . "*TEXT")(1 . "*ì`?*"))))

(sssetfirst nil (ssget '((0 . "*TEXT")(1 . "*`?*"))))