;; hex2int.lsp
;; Hexadecimal to base-10 Integer converter [e.g. for entity handles]
;; Modified/simplified from Frank Oquendo's (basetodecimal) function.
;; Added negative-argument capability and argument validity controls.
;; Kent Cooper, January 2011

(defun hex2int (hndl / result neg power tmp)
  (if (/= (type hndl) 'STR)
    (progn
      (alert "Requires string argument.")
      (quit)
    ); end progn
  ); end if
  (setq
    hndl (strcase hndl)
    result 0
  ); end setq
  (if (= (substr hndl 1 1) "-")
    (setq neg T hndl (substr hndl 2))
  ); end if
  (if (/= (vl-string-trim "0123456789ABCDEF" hndl) "")
    (progn
      (alert "Invalid hexadecimal string.")
      (quit)
    ); end progn
  ); end if
  (repeat (setq power (strlen hndl))
    (setq result
      (+
        result
        (*
          (-
            (setq tmp (ascii (substr hndl 1 1)))
            (if (> tmp 64) 55 48)
          ); end -
          (expt 16 (setq power (1- power)))
        ); end *
      ); end +
      hndl (substr hndl 2)
    ); end setq
  ); end while
  (if neg (- result) result)
); end defun - hex2int
