;;; �������� 11_09_01
;;; cba
;;; copy block's attributes to another block
;;; ������������ �� ����-5
;;; -kakt00z-�  �

(defun c:cbdp (
	      /
	      copylist
	      bo1
	      bo2
	      atts1
	      atts2
	      i
	      )
  
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0
			       "highlight" (getvar "highlight")
			       "limcheck" 0
			       "osmode" 0
			       );list
			 T);list
    );acet-error-init
  (setq copylist '(		   
		     "������1"
		     "������2"
		     "������3"
                     "����1"
                     "����2"
                     "����3"
                     "�����_����"
		     "CHAN1"
		     "CHAN2"
		     "CHAN3"
		     "CHAN4"
                     ))
  (princ "\n ������� ����-��������")
  (setq bo1 (vlax-ename->vla-object (car (entsel))))
  (princ "\n ������� ����-��������")
  (setq bo2 (vlax-ename->vla-object (car (entsel))))
  (if (and
	(= (vla-get-ObjectName bo1) "AcDbBlockReference")
	(= (vla-get-ObjectName bo2) "AcDbBlockReference")
	(setq atts1 (getbatts bo1 copylist)
	      atts2 (getbatts bo2 copylist)))
    (mapcar '(lambda (x y) (vla-put-textstring x (vla-get-TextString y))) atts2 atts1)
    );if
  (acet-error-restore)
  (vla-endundomark doc)
  );defun
