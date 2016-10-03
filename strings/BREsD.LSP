

(setq str "LIRSHLÀHL")
(setq str (norus str))
(setq slst (vl-string->list str))

(setq string "" cf nil)
(mapcar
  '(lambda (ch)
     (cond

       (T (setq string (strcat string (chr ch))))
       )
     )
  slst)





(defun str|format-PID_instrument-ml[func] (str / tmp)
  (cond
    ((vl-string-search "SHL" str)
     (setq tmp (sepstr str "SHL"))
     (strcat "\\A1;" (car tmp) "S" "{\\H0.6x;\\SH^L;}" ())
     )
     
    ((vl-string-search "SH" str) )
    ((vl-string-search "SL" str) )
    ((vl-string-search "S" str) )

    
    )
  )





(sepstr str "HL")


(defun str|format-PID_instrument-ml[func] (str / tmp)
  (cond
    ((vl-string-search "HL" str)
     (vl-string-elt )
     (vl-string-translate )
     )
     
     
     
    ((vl-string-search "SH" str) )
    ((vl-string-search "SL" str) )
    ((vl-string-search "S" str) )

    
    )
  )

















(vla-get-TextString (vlax-ename->vla-object (car (entsel))))








"\\A1;COMMON{\\H0.6x;\\SH^L;}LAST"

"COMMON{\\H0.6x;\\Supp/dwn;}LAST" 



"LIR SL AHL"
(vla-put-TextString (vlax-ename->vla-object (car (nentsel)))
  (strcat
    "\\A1;"
    "LIR"
    "S"
    "{\\H0.6x;\\S ^L;}"
    "A"
    "{\\H0.6x;\\SH^L;}"
    )
  )




"LIR SHL AHL"
(vla-put-TextString (vlax-ename->vla-object (car (nentsel)))
  (strcat
    "\\A1;"
    "LIR"
    "S"
    "{\\H0.6x;\\SH^L;}"
    "A"
    "{\\H0.6x;\\SH^L;}"
    )
  )


"LIR AH"
(vla-put-TextString (vlax-ename->vla-object (car (nentsel)))
  (strcat
    "\\A1;"
    "LIR"
    "A"
    "{\\H0.6x;\\SH^ ;}"
    )
  )
