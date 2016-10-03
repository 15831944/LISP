;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(defun tdms-get-sub (pf str / i ln)
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

(defun tdms-putatt (drw tag val /)
  (vlax-put-property
    (vlax-get-property
      (vlax-get-property drw "Attributes")
      "item"
      tag)
    "Value"
    val)
  );defun

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

(defun tdmsgp (obj prop)
  (vlax-get-property obj prop)
  )

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
