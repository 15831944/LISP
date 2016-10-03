;(file-to-list (strcat "d:\\_AutoCAD\\1744 Лунинец\\1744-1-АТМ1\\Опросные листы 13_05_27\\Королев\\конкретно лунинец\\425-2-12-T+КИП.pmf"))

;(setq fpath (KD:GETFILEDLG "DLL|*.dll"))

;;; 13_10_31

(defun 2dlst->csvfile (tbl fpath / fhand)
  ;(setq fpath (KD:GETFILEDLG "text|*.txt"))
  (setq fhand (open fpath "w"))
  (mapcar
    '(lambda (line) ;(setq line (nth 3 lst))
       (write-line (apply 'strcat (mapcar '(lambda (wrd) (strcat wrd "\t")) line)) fhand)
       )
    tbl)
  (close fhand)
  );defun
  
 
;;; функция вывода списка 2-го порядка '((a1 b1 c1)(a2 b2 c2)...(an bn cn))
;;; ну то есть плоской матрицы
;;;  в файл по строкам - разделитель - табуляция и знак конца строки
;;; 13_10_17
;(setq lst (cdr db:data))
;(defun lst->ftxt (lst fpath / fhand stroka word) 
;  (setq fhand (open fpath "w"))
;  (mapcar
;    '(lambda (line) ;(setq line (nth 3 lst))
;       (write-line (apply 'strcat (mapcar '(lambda (wrd) (strcat wrd "\t")) line)) fhand)
;       )
;    lst)
;  (close fhand)
;  );defun

(defun csvfile->2dlst (fpath / fhand ch lst line word)
  (setq lst '() line '() word "")
  (setq fhand (open fpath "r"))

  (while (setq ch (read-char fhand))
    (if (= 10 ch)		;;eol
      (setq lst (append lst (list line)) line '() word "")
      (if (= 9 ch)	;;eow
	(setq line (append line (list word)) word "")
	(setq word (strcat word (chr ch)))
	)
	)
    );while
  (close fhand)
  (vl-remove-if 'null lst)
  );defun
  
  
(defun file-to-list ( fpath / data lst tmp)
  (setq data (open fpath "r"))
  (setq lst '())
  (while (setq tmp (read-line data))
    (setq lst (append lst (list tmp)))
    )
  (close data)
  (setq data nil)
  lst
  )


;(setq tmp (file-to-list "d:\\_AutoCAD\\eir\\МТЭЦ-20\\!__ТГ-6 проект\\!_WRK\\подключения\\asd\\readed.txt"))





;(setq filename "d:\\123.txt")
(defun wfile (lst filename / filepath hand)
  (if (wcmatch filename "*:*") (setq filepath filename) (setq filepath (strcat (vla-get-path #actdoc) "\\" filename)))
  (setq hand (open filepath "w"))
  ;(mapcar '(lambda (x) (prin1 x hand)) lst)
  (prin1 lst hand)
  (close hand)
  )
;(wfile db:data filename)

(defun rfile (filename / filepath hand line result)
  (if (wcmatch filename "*:*") (setq filepath filename) (setq filepath (strcat (vla-get-path #actdoc) "\\" filename)))
  (if (findfile filepath)
    (progn
      (setq hand (open filepath "r"))
      (setq result '())
      (while (setq line (read-line hand)) (setq result (append result (list (read line)))))
      (close hand)
      (car result)
      )
    nil
    )
  );defun

;(setq db:data1 (rfile filename))
