
(defun cl|acad-tables-explode ( / ss)
  (setq ss (ssget "_X" '((0 . "ACAD_TABLE"))))
  (if ss
    (mapcar
      '(lambda (o)
	 (vl-cmdf "_explode" "_o" o)
	 )
      (ss->list* ss)
      )
    )
  );defun

