
(setq od (namedobjdict))
(setq fd (dictsearch od "ACAD_FIELDLIST"))

(setq liod
       (mapcar 'cdr (vl-remove-if-not
		      (function (lambda (x) (= (car x) 330)))
		      (dictsearch od "ACAD_FIELDLIST"))))

(entget (nth 1 liod))

(setq eng fd
      i 0)
(repeat (length eng)
  (princ (nth i eng))
  (princ "\n")
  (setq i (1+ i))
  )