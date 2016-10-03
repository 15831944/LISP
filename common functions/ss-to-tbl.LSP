
(defun ss->tbl ( ss / lsto i nkol dx th tbl line)
  ;(setq ss (ssget '((0 . "*TEXT"))))
  (if (> (sslength ss) 1)
    (progn
      
  (setq lsto (reverse (ssnamex ss)))

  (while (listp (cadar lsto))
    (setq lsto (cdr lsto)))
  
  (setq lsto (mapcar 'cadr lsto))
  (setq th (cdr (assoc 40 (entget (car lsto)))))
  (if (null th) (setq th 1.5));сделал для сортировки блоков в нумераторе
  (setq lsto (vl-sort lsto '(lambda (a b) (< (- (car (cdr (assoc 10 (entget a)))) (car (cdr (assoc 10 (entget b))))) th))))
  (setq lsto (vl-sort lsto '(lambda (a b) (> (- (cadr (cdr (assoc 10 (entget a)))) (cadr (cdr (assoc 10 (entget b))))) th))))
  (setq dx (* 10000 th))
  (setq nkol 0)

  (while (and (> dx th) (nth (setq nkol (1+ nkol)) lsto))
    (setq dx (- (cadr (assoc 10 (entget (nth nkol lsto))))
		(cadr (assoc 10 (entget (nth     0  lsto))))))
    )
  (setq tbl '() i 0 line '())
  (foreach item lsto
    (if (= i (1- nkol))
      (setq i -1
	    line (append line (list (vlax-ename->vla-object item)))
	    tbl (append tbl (list line))
	    line '())
      ;else
      (setq line (append line (list (vlax-ename->vla-object item))))
      )
    (setq i (1+ i))
    );foreach
  tbl
  )
    (list (list (vlax-ename->vla-object (ssname ss 0))))
    );if
  );defun


; для сцепки 3 колонок текста

;;;(mapcar '(lambda (x)
;;;	  (strcat
;;;	    (vla-get-TextString (car x))
;;;	    (vla-get-TextString (cadr x))
;;;	    (vla-get-TextString (caddr x))
;;;	    )
;;;	  )tb)