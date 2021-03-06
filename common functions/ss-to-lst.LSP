
;; 12_03_30   ����� ������� ssnamex
;;;(mapcar '(lambda (x)
;;;	   (vlax-ename->vla-object (cadr x))
;;;	   )
;;;	(cdr (reverse (ssnamex ss)))
;;;	)



;;; �������� 11_08_05

;;; ������� ��������� ����� (ss) � ������ �� ����
;;; ������ ���� ((ename1 x1)(ename2 x2)...(enamen xn))
;;; ��� x1, x2, ... , xn - �������� ����������,
;;; ��������� ��� � ������ ������ (ename1 ename2 ... enamen)

;;; -kakt00z-�  �

;;; ������ �������
;ss->list		(����� ������� ����������) ������ ������
;ss->list*		(��� ����������)
;ss->lst (ss)	(����� ������� ����������)
;ss->lsto* (ss)	ss - � ��������������� ������ ��������
;ss->sortedlst (ss rule)

;;;(mapcar '(lambda (x) (cdr (assoc 1 (entget x)))) (ss->lst (ssget)))

(defun ss->list (ss /
		e
		rule		;������� ����������
		i
		lst		;���������� ������
		getparam	;������� ��������� ��������� ����������
		cmd2
		enlst
		)
  (initget 1 "x -x y -y content")
  (setq rule (getkword "\n ������� ���������� : [x/-x/y/-y/content] <x> \n"))
  (cond
    ;����� �������
    ((= rule "x") (setq getparam (lambda (x) (cadr (assoc 10 (entget x)))) cmd2 '(<)))
    ;������ ������
    ((= rule "-x") (setq getparam (lambda (x) (cadr (assoc 10 (entget x)))) cmd2 '(>)))
    ;����� �����
    ((= rule "y") (setq getparam (lambda (x) (caddr (assoc 10 (entget x)))) cmd2 '(<)))
    ;������ ����
    ((= rule "-y") (setq getparam (lambda (x) (caddr (assoc 10 (entget x)))) cmd2 '(>)))
    ;�� ����������� ������
    ((= rule "content") (setq getparam (lambda (x) (cdr (assoc 1 (entget x)))) cmd2 '(<)))
    );cond
  (setq i 0)
  (repeat (sslength ss)
    (setq enlst
	   (append enlst
		   (list (list (setq ent (ssname ss i))
			       (getparam ent)))))
    (setq i (1+ i))
    );repeat
  (setq i 0)
;;;************************************************************
  (setq	enlst (vl-sort enlst
			  '(lambda (a b)
			     (eval (append cmd2 '((cadr a)
						  (cadr b)
						  )
					   )
				   )
			     )
			  )
  )
;;;************************************************************

  (mapcar 'car enlst)
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;  ������ ������ ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(defun ss->list* (ss / i enlst)
;;;  (setq i 0)
;;;  (repeat (sslength ss)
;;;    (setq enlst	(append enlst (list (ssname ss i)))
;;;	  i	(1+ i)
;;;	  ) ;_ setq
;;;    ) ;repeat
;;;  enlst
;;;  ) ;defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun ss->list* (ss / lst)
  (setq lst (reverse (ssnamex ss)))
  (while (listp (cadar lst))
    (setq lst (cdr lst)))
  (mapcar '(lambda (x) (cadr x)) lst)
  ) ;defun



(defun ss->lsto (ss)
  (mapcar ' vlax-ename->vla-object (ss->list ss))
  ) ;defun

(defun ss->lsto* (ss / lsto)
  (if ss
    (progn
      (setq lsto (reverse (ssnamex ss)))
      (while (listp (cadar lsto))
	(setq lsto (cdr lsto)))
      (mapcar '(lambda (x) (vlax-ename->vla-object (cadr x))) lsto)
      )
    )
  );defun



(defun ss->lst (ss /
		rule		;������� ����������
		)
  (setq ss (ss->list* ss))
  (initget 1 "x -x y -y content")
  (setq rule (getkword "\n ������� ���������� : [x/-x/y/-y/content] <x> \n"))

  (cond
    ((= rule "x")(setq rule '(< (cadr (assoc 10 (entget a))) (cadr (assoc 10 (entget b))))     ))
    ((= rule "y")(setq rule '(< (caddr (assoc 10 (entget a))) (caddr (assoc 10 (entget b))))     ))
    ((= rule "-x")(setq rule '(> (cadr (assoc 10 (entget a))) (cadr (assoc 10 (entget b))))     ))
    ((= rule "-y")(setq rule '(> (caddr (assoc 10 (entget a))) (caddr (assoc 10 (entget b))))     ))
    ((= rule "content")(setq rule '(< (cdr (assoc 1 (entget a))) (cdr (assoc 1 (entget b))))     ))
    )
  (vl-sort ss '(lambda (a b) (eval rule)))
  );defun



;(mapcar '(lambda (x) (cdr (assoc 1 (entget x)))) (ss->lst (ssget)))

(defun ss->sortedlst (ss
		      rule		;������� ����������
		      )
  (setq ss (ss->list* ss))
  (cond
    ((= rule "x")(setq rule '(< (cadr (assoc 10 (entget a))) (cadr (assoc 10 (entget b))))     ))
    ((= rule "y")(setq rule '(< (caddr (assoc 10 (entget a))) (caddr (assoc 10 (entget b))))     ))
    ((= rule "-x")(setq rule '(> (cadr (assoc 10 (entget a))) (cadr (assoc 10 (entget b))))     ))
    ((= rule "-y")(setq rule '(> (caddr (assoc 10 (entget a))) (caddr (assoc 10 (entget b))))     ))
    ((= rule "content")(setq rule '(< (cdr (assoc 1 (entget a))) (cdr (assoc 1 (entget b))))     ))
    )
  (vl-sort ss '(lambda (a b) (eval rule)))
  );defun



(defun ssgetlsto ( / lst)
  (if (not (setq lst (ssget "_I"))) (setq lst (vl-catch-all-apply 'ssget '())))
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type lst)) (setq lst (VL-CATCH-ALL-ERROR-MESSAGE lst)))
    ;((null lst) (princ))
    ((= 'PICKSET (type lst)) (setq lst (ss->lsto* lst)))
    )
  lst
  );defun


