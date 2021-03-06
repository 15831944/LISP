;;; �������� 10_04_01
;;; �������� �������, ������ ���� ����� ��� �������������� �������� ����
;;; ��������� ����� �� ������
;;; ����� ��� �������� ������������ ������� ��������
;;; ������������ ��� ���������� ���� �� �4 ������
;;; -kakt00z-�  �


(defun c:run ( / )
       (ktz-ss-sortX-upd)
);



;;; ����������� ��������� �� ��������� �������

(defun ktz-ss-sortX-upd (
			 /
			 ss			;����� �����
			 window			;���� ����������
			 ss1
			 pt1
			 pt2
			 pt3
			 cpt1
			 cpt2
			 bpt
			 delta1			;�������� ���������� ����� ���������
			 delta2			;�������� ���������� ����� ���������
			 DV
			 i j
			 flag
			 doc
			 )


  (vl-load-com)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)

  (acet-error-init
    (list (list	"cmdecho"	0
		"expert" 	nil
		"snapang"	0
		"limcheck"	0
	;	"orthomode"	1
		"snaptype"	0
		"snapmode"	nil
		"gridmode"	nil
		"snapunit"	nil
		"gridunit"	nil
		
		
		);list
	  T
	  );list
    );acet-error-init

  
  (princ "\n������� ��� ����� �������")
  (setq ss (ssget))
  (setq pt1 (getpoint "\n������� ���� ����������"))
  (setq pt2 (getcorner pt1))
  (setq window (vec-dif pt2 pt1))
  (setq pt3 (getpoint "\n������� �������� ���������� ����� ��������� � ������ ������"))
  (setq delta1 (vec-dif (getpoint pt3) pt3))
  (princ "\n������� ��� ���������� �������")
  (setq delta2 (vec-dif (getpoint pt3) pt3))
  (setq bpt (getpoint "\n������� ����� �������"))


  (setq i 0)
  (setq flag T)
  (while flag
    (setq cpt1 (vec-sum (vec-comp delta1 i) pt1))
    (setq cpt2 (vec-sum (vec-comp delta2 i) bpt))
    (setq DV (vec-dif cpt2 cpt1))
    ;(command "_.zoom" "_A")
    (vl-cmdf "_ZOOM"  cpt1 (vec-sum cpt1 window) "")
    (setq ss1 (ssget "_C"  cpt1 (vec-sum cpt1 window)))
    
    (if (null ss1)
      ;then
      (progn
	(setq flag nil)
	;(quit)
	);progn
      
      ;else
      (progn
	(setq j 0)
	(repeat (sslength ss1)
	  (move-ent (list (ssname ss1 j) DV))
	  (setq j (1+ j))
	  );repeat
	);progn
      );if
    (setq i (1+ i))
    );while
  


  (vla-endundomark doc)
  (acet-error-restore)

  );defun


  

;;; c������ �������� �� ������ x y
;;; vect:  (ename (x y))

(defun move-pt (enget
		pp
		vectmove
		/
		newpt
		)
  (setq newpt (vec-sum vectmove (cdr (assoc pp eng))))
  (subst (cons pp newpt)
	 (assoc pp enget)
	 enget
	 )
  );defun

(defun move-ent	(vect
		 /
		 e
		 eng
		 vmove
		 )
  (setq vmove	(cadr vect)
	e	(car vect)
	eng	(entget e))

  (if (/= "SEQEND"
	  (cdr (assoc 0 eng))
	  )
    (progn
    (setq eng (move-pt eng 10 vmove))
    (if (assoc 11 eng)
      (setq eng (move-pt eng 11 vmove))
      )
    (entmod eng)
    (entupd e)

    (if
      (or
	(= "ATTRIB" (cdr (assoc 0 eng)))
	(and
	  (= "INSERT" (cdr (assoc 0 eng)))
	  (= 1 (cdr (assoc 66 eng)))
	  );and
	);or
      ;then
      (move-ent (list (entnext e) vmove))
      );if
    );progn
    );if not seqend
  ) ;defun



;;; ������������ ���������� �� ���������� �������� �������



































;;;			 
;;;		     /
;;;		     ss			;����� �����
;;;		     sss		;��������
;;;		     bp			;����� ������ ������� ������
;;;		     pt1		;����� ���� ������ ���������
;;;		     pt2
;;;		     dpt1
;;;		     dpt2
;;;		     bpt		;����� ������� �������� �����
;;;		     i
;;;		     ent
;;;		     dX			;���������� X ����� ��������� �����
;;;		     ss-en		;����� ������ ���� ����������
;;;		     base_block		;������� ����, ��������� ��� �������� ���������
;;;		     			;�������� ��� �����������
;;;		     mbp		;������� ��� �������������� ���������
;;;		     ptm
;;;		     ptkon
;;;		     
;;;		     )
;;;
;;;
;;;  (setq base_block	(car (entsel "\n����� ������� ����"))
;;;			; � ������ ��� ������ ���� ��� �����, �� ���� - ���� "���������"
;;;	ss		(ssget)		;"\n������� �������")
;;;			
;;;
;;;	
;;;	i		0
;;;	
;;;				; � ������ ��� ������ ���� ��� �����, �� ���� - ���� "���������"
;;;	pt1		(getpoint "\n������� ������ ����� ��� ���� ������ ���������")
;;;	pt2		(getpoint "\n������� ������ ����� ��� ���� ������ ���������")
;;;	mbp		(getpoint "\n������� ������� ����� ��� �������������� ���������")
;;;	bp		(getpoint "\n������� �����")
;;;	dX		(getdist bp "\n��������� ����� ��������� X")
;;;	
;;;  );setq
;;;  (setq bpt (cdr (assoc 10 (entget base_block))))
;;;  
;;;  (setq  dpt1	(list (- (car bpt) (car pt1))
;;;		      (- (cadr pt1) (cadr bpt))
;;;		);list
;;;	 dpt2	(list (- (car pt2) (car bpt))
;;;		      (- (cadr bpt) (cadr pt2))
;;;		);list
;;;	 mbp	(list (- (car bpt) (car mbp))
;;;		      (- (cadr bpt) (cadr mbp))
;;;		);list
;;;   );setq
;;;
;;;	
;;;  
;;;  
;;;
;;;
;;;  
;;;
;;;  
;;;  (repeat (sslength ss)
;;;    (setq ss-en (append ss-en (list (ssname ss i))))
;;;    (setq i (1+ i))
;;;  );repeat
;;;
;;;
;;;  
;;;(princ "\n ******************************************")
;;;;;; ***************************************************************************
;;;;;; ����� ���������������� �������
;;;;;; ***************************************************************************
;;;  
;;;  (mapcar '(lambda (x)
;;;	     (progn (princ "\n  -> ")
;;;		    (princ x)
;;;	     )
;;;	   )
;;;	  ss-en
;;;  );mapcar
;;;  
;;;
;;;
;;;;;; ***************************************************************************
;;;;;; ��������� ������ ���� �� �������� (��� �)
;;;;;; ***************************************************************************
;;;
;;;  (setq	ss-en	(vl-sort ss-en
;;;			 '(lambda (a b)
;;;			    (< (car (cdr (assoc 10 (entget a))))
;;;			       (car (cdr (assoc 10 (entget b))))
;;;			       )
;;;			  )
;;;		)
;;;  )
;;;
;;;  (princ "\n ******************************************")
;;;;;; ***************************************************************************
;;;;;; ����� �������������� �������
;;;;;; ***************************************************************************
;;;
;;;  (mapcar '(lambda (x)
;;;	     (progn (princ "\n  -> ")
;;;		    (princ x)
;;;	     )
;;;	   )
;;;	  ss-en
;;;  );mapcar
;;;
;;;
;;;;;; ������� ����� �������� ������� ���� ����� ��������� ����������
;;;;;; ��� ����� ��� ���� ����� �� ��� ������ � ����� ������ ������
;;;;;; ����� ����������� � ���� ��������� ����������
;;;;;; ����� ��� �������� ��������� ��� �����������
;;;;;; ���� �� ������ ���� �� ���������� ���� base_block
;;;(princ "\n ******************************************")
;;;
;;;(setq i 0)
;;;
;;;(foreach ent ss-en
;;;  (if (equal (assoc 8 (entget base_block))
;;;	     (assoc 8 (entget ent)));=
;;;    (progn
;;;      (setq bpt (cdr(assoc 10 (entget ent))))
;;;      (setq pt1 (list (- (car bpt) (car dpt1))
;;;		       (+ (cadr bpt) (cadr dpt1)))
;;;	    pt2 (list (+ (car bpt) (car dpt2))
;;;		       (- (cadr bpt) (cadr dpt2)))
;;;	    ptm (list (+ (car bpt) (car mbp))
;;;		      (+ (cadr bpt) (cadr mbp)))
;;;       );setq
;;;
;;;      (setq ptkon (list (+ (car bp) (* dX i))
;;;			(cadr bp)))
;;;
;;;
;;;      (command "_move" "_W" pt1 pt2 "" ptm ptkon)
;;;
;;;      ;(command "_rectangle" pt1 pt2)
;;;      
;;;      ;(setq sss (ssget "_W" pt1 pt2))
;;;      
;;;
;;;
;;;      
;;;      (setq i (1+ i))
;;;    );progn
;;;  );if
;;;
;;;
;;;);foreach
;;;
;;;
;;;
;;;
;;;					
;;;
;;;
;;;  (princ)
;;;
;;;);defun
;;;
;;;
;;;
;;;
;;;
;;;;(while INSNAMES (setq OUTPUT (cons (cons (car INSNAMES)(- LEN (setq LEN (length (setq INSNAMES (vl-remove (car INSNAMES) INSNAMES)))))) OUTPUT)))
;;;
;;;
;;;
;;;;;;(defun c:bsel (/) ;;; ����� ���� ����������� ������ �� ������
;;;;;;  (setvar "cmdecho" 0) 
;;;;;;  (sssetfirst 
;;;;;;    nil 
;;;;;;    (setq bSet 
;;;;;;      (ssget 
;;;;;;        "_C" 
;;;;;;        (list 
;;;;;;          (assoc 2 (entget (car (entsel "Select sample block: ")))) 
;;;;;;        ) 
;;;;;;      ) 
;;;;;;    ) 
;;;;;;  ) 
;;;;;;  (terpri) 
;;;;;;  (princ(strcat "*** "(itoa(sslength bSet)) " bloks selected ***")) 
;;;;;;  (princ) 
;;;;;;)
;;;

