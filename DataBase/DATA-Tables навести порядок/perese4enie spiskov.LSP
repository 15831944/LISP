(defun do (obj) (vlax-dump-object obj T))
(defun getbatt (
		 bobj
		 tag
		 /
		 al
		 i
		 )
  (if
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (< 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al))
      (setq i (vl-position tag (mapcar 'vla-get-tagstring al)))
      )
  (nth i al))
  );defun

(defun ss-odd (
	       /
	       lst
	       ss
	       i
	       )
  (setq lst (ss->list (ssget))	
	i 0
	ss (ssadd))
  (repeat (/ (length lst) 2)
    (setq ss (ssadd (nth i lst) ss))
    (setq i (+ i 2))
    )
  (sssetfirst nil ss)
  )




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ��������������� ���������� �����
; ���� ������ ������ ������� � �������� ���������� �� ���
; ��� ������� �������� � ����� � ������ ������� �������� ������� ��������
; ugl - UG list - ������ (("UG1" "�����1" "�����3"...)(UG2" "�����2" "�����3"...)...)
; stl - stend list - (("�����1" "UG1" "UG5" ...)("�����2" "UG1" "UG5"...)...)
; ugs - UGs - ������ ���� ������ ������� ("UG1" "UG2" "UG3" ... "UG last)
; ����� ������� ����� �������, ������� ������������ �������� (����� ���� � ������ ��������)
; �� ����� ���������� � ������ ������ ���������
; 11_07_07
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq src (cols-to-array 2))
(setq ugl (ziplist src))
(setq ugl (vl-sort ugl '(lambda (a b) (< (car a) (car b)))))
(setq stl (ziplist (mapcar 'reverse src)))
(setq stl (vl-sort stl '(lambda (a b) (< (car a) (car b)))))
(setq ugs (mapcar 'car ugl))
(setq ugs (vl-sort ugs '(lambda (a b) (< a b))))


(setq globtocheck ugs)
(setq res '())


(progn
(while globtocheck
  (setq checked '())
  (setq tocheck (list (car globtocheck)))
  (while tocheck
    (getlinked ugl stl)
    )
  (setq res (append res (list checked)))
  (setq globtocheck (vl-remove-if '(lambda (x) (member x checked)) globtocheck))
);while
res
);progn


(defun getlinked (owl nextl / curcheck nextcheck)
  (setq checked (append checked tocheck)
	curcheck tocheck
	tocheck '()
	)
  (foreach it curcheck
    (setq nextcheck (cdr (assoc it owl)))
    (foreach itt nextcheck
      (foreach ittt (cdr (assoc itt nextl))
	(if (or
	      (member ittt checked)
	      (member ittt tocheck)
	      )
	  (princ)
	  (setq tocheck (append tocheck (list ittt)))
	  )
	)
      )
    );foreach it
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







(setq data (ziplist (cols-to-array 2)))



(defun fill-tsel(
                 /
                 txts
		 tag
                 at
		 str
                 )
  (setq txts (mapcar 'vlax-ename->vla-object (ss->list (ssget '((0 . "MTEXT"))))))
    (foreach txt txts
      (setq tag (vla-get-TextString txt))
      (if (setq at (cdr (assoc tag ug-nazv)))
	(progn
	  (setq str "")
	  (foreach item at
	    (setq str (strcat str " " item))
	    )
	  (vla-put-TextString txt str)
	  )
	)
      )
  tag
  );defun






(setq src (cols-to-array 5))
(put-data-into-blocks src)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun blkattsstring->assoclst (blockname taglist / blks assoclist)
  (setq assoclist '())
  (setq blks (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT"))))))
  (foreach bl blks
    (if (= blockname (vla-get-Effectivename bl))
        (setq assoclist (append assoclist (list (mapcar '(lambda (x) (vla-get-TextString (getbatt bl x))) taglist))))
      )
    )
  (vl-sort assoclist '(lambda (a b) (< (car a) (car b))))
  );defun

(blkattsstring->assoclst "��_��������" '("�����" "�������"))
(setq data
(blkattsstring->assoclst "������_������-604" '("ID" "CHAN1" "CHAN2" "CHAN3" "CHAN4"))
      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






(defun objs-to-array (nkol
		      /
		      main
		      )
  (setq main '())
  (repeat nkol
    (alert "��������� ������� ��������")
    (setq main (append main (list  (mapcar 'vlax-ename->vla-object (ss->list (ssget))))))
    (princ "\n !!!!!!!!!!!!!!!!!!!!!!!!!     ��������� �����           !!!!!!!!!!!!!!!\n")
    )
  (matrix-trans main)
  );defun

(setq texts (objs-to-array 2))

(mapcar 'vla-put-textstring texts tblesdata)

(setq tblesdata '(("19" "UG3") ("20" "UG8") ("21" "UG12") ("22" "UG6") ("23" "UG25") ("24" "UG26") ("25" "UG27") ("26" "UG28") ("27" "UG4") ("28" "UG9") ("29" "UG13") ("30" "UG7") ("31" "UG2") ("32" "UG1") ("33" "UG10") ("34" "UG11") ("35" "UG5") ("36" "UG18") ("37" "UG36") ("38" "UG20") ("39" "UG14") ("40" "UG15") ("41" "UG16") ("42" "UG17") ("43" "UG24") ("44" "UG35") ("45" "UG37") ("46" "UG33") ("47" "UG19") ("48" "UG29") ("49" "UG21") ("50" "UG22") ("51" "UG30") ("52" "UG23") ("53" "UG38") ("54" "UG31") ("55" "UG32") ("56" "UG34")))




(defun fill-tsel(
                 /
                 txts
		 tag
                 at
                 )
  (setq txts (mapcar 'vlax-ename->vla-object (ss->list (ssget))))
    (foreach txt txts
      (setq tag (vla-get-TextString txt))
      (if (setq at (assoc tag bpfill))
	(vla-put-TextString txt (cadr at))
	)
      )
  );defun
	
(defun fill-tsel*(
                 /
                 txts
		 tag
                 att
                 )
  (setq txts (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "*TEXT"))))))
    (foreach txt txts
      (setq tag (vla-get-TextString txt))
      (if (setq att (assoc tag data))
	(vla-put-TextString txt
	  (strcat
	    "-24�\\~�\\~��������: "
	    "1."(nth 1 att)"; "
	    "2."(nth 2 att)"; "
	    "3."(nth 3 att)"; "
	    "4."(nth 4 att)
	    )
	  )
	)
      )
  );defun


;;; ���������� �� ������ ((UG5 A101) (UG6 A103) ... ) ������ �������� ������������ � �����
;;; ������-604 �� ���� ���� "������" ����� �������� "OWNER" � ����� ���������� ID ����� ��������
(setq data (cols-to-array 2))

(defun qwe (data
	    /
	    wires
	    doc
	    i
	    str
	    )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (setq wires (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT"))))))
  (foreach blk wires
    (vla-put-TextString
      (getbatt blk "MARK")
      (cadr (assoc (vla-get-TextString (getbatt (getfieldowner (getbatt blk"OWNER")) "ID")) data))
      )
    )
  );defun
(defun getfieldowner (obj / owner fld)
  (setq fld (entget (vlax-vla-object->ename obj)))
  (while (and (/= "FIELD" (cdr (assoc 0 fld))) (assoc 360 fld)) ;and
    (setq fld (entget (cdr (assoc 360 fld))))) ;while
  (setq owner (cdr (assoc 360 fld)))
  (vlax-ename->vla-object (cdr (assoc 330 (entget (cdr (assoc 331 (entget owner)))))))
  ) ;defun

