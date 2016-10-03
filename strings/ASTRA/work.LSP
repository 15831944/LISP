(setq fpath "d:\\_LISP\\strings\\ASTRA\\tmp.txt")
(setq fpath "d:\\_LISP\\strings\\ASTRA\\салонные предохранители2.txt")
(setq fpath "d:\\_LISP\\strings\\ASTRA\\салонные предохранители2.txt")
(setq fpath "d:\\_LISP\\strings\\ASTRA\\wirecolors.txt")



(setq lst '())
(setq fhand (open fpath "r"))
(while (setq strline (read-line fhand))
  (setq lst (append lst (list strline)))
  )
(close fhand)
(setq fhand nil)

(setq lst (vl-remove-if '(lambda (x) (= "" x)) lst))


(defun gendatafromlst (lst k / n data nk clist)
  (setq clist '() nk -1)
  (repeat k (setq clist (append clist  (list (strcat " (nth (+ (* k n) " (itoa (setq nk (1+ nk))) ") lst)")))))
  (setq clist (mapcar 'read clist))

  (setq n 0 data '())
  (repeat (/ (length lst) k)
    (setq data (append data (list (mapcar 'eval clist))))
    (setq n (1+ n))
    )
  data
  )



(lst>excel (gendatafromlst lst 2))


















