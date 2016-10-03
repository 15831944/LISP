(setq path "d:\\_ACAD221\\_ system -_\\ssssad t#emp\\dddd\\")
(defun kd:mkpath (path / lst cpath)
  (setq lst (vl-remove "" (sepstr path "\\")))
  (setq cpath (car lst) lst (cdr lst))
  (mapcar
    '(lambda (dir)
       (setq cpath (strcat cpath "\\" dir))
       (if (null (vl-file-directory-p cpath)) (vl-mkdir cpath))
       )
  lst)
  );defun
;(kd:mkpath path)