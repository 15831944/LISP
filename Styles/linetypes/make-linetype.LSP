
;;;  14_11_12

(defun c:mklt (/ str linetypename linetype-tmpfile-path hand)
  ;(setq #STL:TEXTSTYLENAME "pe_gost")
  (setq #STL:TEXTSTYLENAME (getvar "TEXTSTYLE"))
  (if (setq str (kd:dclget '("обозначение")))
    (progn
      (setq str (car str))
      (setq linetypename (strcat "PE-" str))
      (setq linetype-tmpfile-path (strcat (getenv "temp") "\\" linetypename ".lin"))
      (setq hand (open linetype-tmpfile-path "w"))
      (write-line (strcat "*" linetypename ",--- " str " ---") hand)
      (write-line (strcat "A,30,-2,[\"" str "\"," #STL:TEXTSTYLENAME ",x=-1.5,y=-0.75,s=1.5],-" (itoa (1- (strlen str))) ".5") hand)
      (close hand)
      (vla-load (vla-get-LineTypes #actdoc) linetypename linetype-tmpfile-path)
      (vl-file-delete linetype-tmpfile-path)
      )
    )
  );defun
(princ "\nc:mklt")
    





    