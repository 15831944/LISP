;;; ����� �� 2-� ������� ������, ��������� ��, � ��������� � 3-�
;;; ��� KKS ����� ��� ����� � 2 �������

(defun c:zc ( /
	     e1
	     e2
	     ent-to
		      ename-get
		      fl		; ���� ��������� ���������� �������
		      tmp
		      str
		      doc
		      es
			  )

  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init



    
  (while (not fl)
    (setq e1 (car (nentsel "\n ������� �������� 1 ������ ... :"))
	  tmp (cdr (assoc 0 (entget e1)))
	  );setq
    (if	(or
	  (eq tmp "TEXT")
	  (eq tmp "ATTRIB")
	  (eq tmp "MTEXT")
	  (eq tmp "DIMENSION")
	  );or
      ;then	
      (setq fl T)
      ;else
      (princ "\n *** �� ������ �������� ������ ***")
      );if
    );while
  (setq fl nil)

    (while (not fl)
    (setq e2 (car (nentsel "\n ������� �������� 2 ������ ... :"))
	  tmp (cdr (assoc 0 (entget e2)))
	  );setq
    (if	(or
	  (eq tmp "TEXT")
	  (eq tmp "ATTRIB")
	  (eq tmp "MTEXT")
	  (eq tmp "DIMENSION")
	  );or
      ;then	
      (setq fl T)
      ;else
      (princ "\n *** �� ������ �������� ������ ***")
      );if
    );while
  (setq fl nil)

  
  (setq	str (strcat
	      (cdr (assoc 1 (entget e1)))
	      (cdr (assoc 1 (entget e2)))
	      ))
  

  (while (setq es (nentsel "\n ������� ������-�������� ������ ... :"))
    (if (and
	  es
	  (setq ent-to (car es))
	  (member (cdr (assoc 0 (entget ent-to)))
	    '("ATTRIB" "MTEXT" "DIMENSION" "TEXT")
	    ) ;_ member
	  ) ;_ and
	  
    (progn
      (setq ename-get (entget ent-to))
      (setq ename-get (subst (cons 1 str)
			     (assoc 1 ename-get)
			     ename-get
			     ) ;_ subst
	    ) ;_ setq
      (entmod ename-get)
      (entupd (cdr (assoc -1 ename-get)))
      (vl-cmdf "_updatefield" (cdr (assoc -1 ename-get)) "")
      ) ;progn
    (princ "\n *** �� ������ ����� �������-��������� ***")
    ) ;if ent
  (acet-error-restore)
  (vla-endundomark #actdoc)

    ) ;while entsel
 
  (princ)
);defun
