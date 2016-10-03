;(load (strcat #lisppath "TDMS\\tdmslib.LSP"))
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(set 'gp vlax-get-property)

(defun tdms|askwich (lst / desc)
  (setq desc (kd:dcl:pick-from-list (mapcar '(lambda (x) (gp x "Description")) lst)))
  (car (vl-remove-if-not '(lambda (x) (= desc (gp x "Description"))) lst))
  );defun



(defun tdms|child (obj str / objc lst)
  (setq objc (gp obj "Content"))
  (setq lst (vl-remove-if-not '(lambda (o) (wcmatch (gp o "Description") (strcat "*" str "*"))) (cont>list objc)))
  (cond
    ((= (length lst) 1) (car lst))
    ((> (length lst) 1) (tdms|askwich lst))
    (T (princ (gp o "Description")))
    )
  );defun



(defun tdms-get-sub (
		     pf	;parent folder
		     str ;Description
		     /
		     i
		     ln
		     )
  (setq i 0 ln '())
  (repeat (vlax-get-property pf "Count")
    (if (wcmatch
            (vlax-get-property
                (vlax-get-property
                    pf
                    "item"
                    i)
                "Description")
            str);wcmatch
        (setq ln (append ln (list i)))
        );if
    (setq i (1+ i))
    );repeat
  (vlax-get-property pf "item" (car ln))
  )
  
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


(defun tdms|getatt (obj tag)
  (vlax-variant-value
    (vlax-get-property
      (vlax-get-property
	(vlax-get-property obj "Attributes")
	"item" tag)
      "Value"
      )
    )
  );defun


(defun tdms|putatt (obj tag val /)
  (vlax-put-property
    (vlax-get-property
      (vlax-get-property obj "Attributes")
      "item"
      tag)
    "Value"
    val)
  )


(defun tdms-putatt (obj tag val /)
  (vlax-put-property
    (vlax-get-property
      (vlax-get-property obj "Attributes")
      "item"
      tag)
    "Value"
    val)
  );defun





;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(defun tdms-content (collection / i)
  (setq i 0)
  (while (< i (vlax-get-property collection "Count"))
    (princ (strcat "\n\t" (itoa i) " \t"))
    (princ (vlax-get-property (vlax-get-property collection "item" i) "Description"))
    (setq i (1+ i))
    )
  );defun
  
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
