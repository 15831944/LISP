;;; 12_08_06
;;; att - ��� ��������� ��� ����������


(defun arrange ( tag /  lst bpt dv i obj)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list
			   "cmdecho" 0
			   "highlight" (getvar "highlight")
			   "limcheck" 0
			   ;"osmode" 0
			   ) T));acet-error-init
  (princ "\n�������� �������� ��� ����������...")
  ;(setq lst (ss->list* (ssget '((0 . "INSERT")))))
  ;(setq lst (mapcar '(lambda (x) (vlax-ename->vla-object x)) lst))
  (setq lst (ss->lsto* (ssget '((0 . "INSERT")))))

  (setq lst (vl-sort lst '(lambda (a b)
			    (<
			      (vla-get-textstring (getbatt a tag))
			      (vla-get-textstring (getbatt b tag))
			      ))))
  (setq	i -1
	bpt (getpoint "\n������� ����� ������ ���������...")
	dv (getpoint bpt "\n������� ���������� ����� ���������� � �����...")
	dv (mapcar '- dv bpt))

  (repeat (length lst)
    (setq obj (nth (setq i (1+ i)) lst))
    (vla-put-InsertionPoint obj
      (vlax-3d-point (mapcar '+ bpt
			     (mapcar '(lambda (x) (* i x)) dv)
			     )))
    ;(vla-put-rotation obj 0)
    );repeat
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun






;;;������ �������� �� ������ "�������", �������� �� �� ��������� ������
;;;��������� � �����
;;;
;;;(defun ktz-klamp-sort (/
;;;		       ss		;����� ������ "�������"
;;;		       ss-en		;������ �� ������ ss	
;;;;;;		       ss-en-s
;;;		       ent
;;;		       enget
;;;		       i
;;;		       n-att		;���������� ����� ��������� � �����
;;;					;�� ����������� �������� ����� �����������
;;;		       bp
;;;		       dY
;;;		       ptb
;;;		       curpt
;;;		       pf
;;;
;;;		       doc
;;;		       )
;;;  
;;;  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
;;;  (vla-startundomark doc)
;;;  
;;;  (acet-error-init
;;;    (list (list "cmdecho" 0
;;;		"highlight" (getvar "highlight")
;;;		"limcheck" 0
;;;		"osmode" 0
;;;		);list
;;;	  T
;;;	  );list
;;;    );acet-error-init
;;;
;;;
;;;  
;;;
;;;  (setq	ss    (ssget)
;;;	i     0
;;;	n-att (getint
;;;		"\n������� ���������� ����� ��������� � ����� ��� ����������"
;;;	      )
;;;	bp    (getpoint "\n������� ������� �����")
;;;	dY    (- (getdist bp "\n���������� ����� ��������"))
;;;
;;;  );setq
;;;
;;;
;;;
;;;(repeat	(sslength ss)
;;;  (setq	ss-en
;;;	 (append
;;;	   ss-en
;;;	   (list
;;;	     (list
;;;	       (setq ent (ssname ss i))
;;;	       (cdr (assoc 1 (entget (if (= n-att 0)
;;;				       ent
;;;				       (repeat n-att (setq ent (entnext ent)))
;;;				       ))))
;;;				       
;;;	       )
;;;	     )
;;;	   );list
;;;	 )
;;;  
;;;  (setq i (1+ i))
;;;  )
;;;
;;;
;;;
;;;  
;;;;;; ***************************************************************************
;;;;;; ��������� ������ ���� �� ����������� n-att-��� ��������� � �����
;;;;;; ***************************************************************************
;;;
;;;  (setq
;;;    ss-en (vl-sort
;;;	    ss-en
;;;	    '(lambda (a b)
;;;	       (> (cadr a)
;;;		  (cadr b)
;;;	       )
;;;	     )
;;;	  )
;;;  )
;;;  (princ "\n ******************************************")
;;;
;;;  (setq ent nil)
;;;;;;  (foreach ent ss-en-s
;;;;;;    (setq ss-en (append ss-en (list (car ent))))
;;;;;;	   )
;;;  (setq ss-en (mapcar 'car ss-en))
;;;
;;;  
;;;
;;;;;; ***************************************************************************
;;;
;;;  (setq i 0)
;;;  (foreach ent ss-en
;;;    (ktz-move-block-to-pt
;;;     ;(ktz-move-txt-to-pt 
;;;      ent (list (car bp)
;;;		(- (cadr bp)(* dy i))))
;;;    (setq i (1+ i))
;;;  );foreach
;;;
;;;
;;;
;;;  (acet-error-restore)
;;;  (vla-endundomark doc)
;;;  
;;;);defun
;;;

