;;; ����� �������� � ������� ������ ����� ������ �� ","


(defun fnd-rep (/ ss i te teg str strl j)
  (setq	ss (ssget '((0 . "MTEXT")))
	i  0
	) ;_ setq

  (repeat (sslength ss)
    (setq te   (ssname ss i)
	  teg  (entget te)
	  strl (VL-STRING->LIST (cdr (assoc 1 teg)))
	  str  ""
	  j    0
	  ) ;_ setq
    (repeat (length strl)
      (if (nth j strl)
	(if (and			;���� ��� ������
	      ;(= 92 (nth j strl)) 
	      ;(= 80 (nth (1+ j) strl))

	      ;(= 32 (nth j strl)) 		;���� 2 ������� ������
	      ;(= 32 (nth (1+ j) strl))
                
	      ) ;_ and
	  (setq	str (strcat str " ")		;�������� �� ,
		j   (+ j 2)
		) ;_ setq
	  (setq	str (strcat str (chr (nth j strl)))
		j   (1+ j)
		) ;_ setq
	  ) ;_ if
	) ;_ if
      ) ;repeat j
    (setq teg (subst (cons 1 str) (assoc 1 teg) teg))
    (entmod teg)
    (entupd te)
    (setq i (1+ i))
    ) ;repeat i

  ) ;_ defun







(defun fnd-rep* (/ ss i te teg str strl j)
  (setq	ss (ssget '((0 . "MTEXT")))
	i  0
	) ;_ setq

  (repeat (sslength ss)
    (setq te   (ssname ss i)
	  teg  (entget te)
	  strl (VL-STRING->LIST (cdr (assoc 1 teg)))
	  str  ""
	  j    0
	  ) ;_ setq
    (repeat (length strl)
      (if (nth j strl)
	(if
	  (= 40 (nth j strl))
	  (setq str (strcat str (chr 92) (chr 80))
		j   (1+ j)
		) ;_ setq
	  ) ;_ if
	) ;_ if
      ) ;repeat j
    (setq teg (subst (cons 1 str) (assoc 1 teg) teg))
    (entmod teg)
    (entupd te)
    (setq i (1+ i))
    ) ;repeat i

  ) ;_ defun







;;;; ������� ������ �������� �� ss �������
(defun qwe (
	    /
	    tolst
	    str
	    nstr
	    )
  (setq tolst (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "TEXT"))))))
  (foreach to tolst
    (setq str (vla-get-textstring to))
    (setq str (vl-string-trim " " str))
    ;(setq ind (vl-string-search "  " lst))
    (setq nstr (vl-string-subst " " "  " str))
    (while (/= str nstr)
      (setq str nstr)
      (setq nstr (vl-string-subst " " "  " str))
      )
    (vla-put-textstring to nstr)
    );foreach
  )