(defun showss (lst / elst ss) (sssetfirst nil (lst-to-ss lst)))



; ������ �������� "INSERT"
(setq blolst (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT"))))))



; ������ obj ������-�������
(vl-remove-if-not
  '(lambda (x) (= "��_�������" (vla-get-effectivename x)))
  (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
  )




(setq
  lst
   (vl-remove-if-not
     '(lambda (x)
	;(setq x (vlax-ename->vla-object (car (entsel))))
	(and
	  ;;;   ������
	  (member (vla-get-effectivename x) '("cbl_lst-kks"))
	  ;;; � ���� �����������
	  ;(member (vla-get-TextString (getbatt x "LOCCAB")) '("���� �����������"))
	  (wcmatch (vla-get-TextString (getbatt x "LOCCAB")) "*(���)*")
	  ;;;; �� ������
	  (wcmatch (vla-get-TextString (getbatt x "LOCFLD"))   "*������ ����-88�. \"BJH40\"*")
	  )
	)
     (ss->lsto* (ssget '((0 . "INSERT"))))
     )
  )
(showss lst)






; ������ obj ������-������� � ID "H"
(setq objlst
(vl-remove-if-not
  '(lambda (x) (= "H" (vla-get-textstring (getbatt x "ID"))))
  (vl-remove-if-not
    '(lambda (x) (= "��_�������" (vla-get-effectivename x)))
    (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
    ))
      )

(showss objlst)


(selblkatt "��_�������" "POZ" "UA-###")
(selblkatt "��_�������" "ID" "H")


(defun selblkatt (bname tag str
	    /
	    objlst
	    )
  (setq objlst
	 (vl-remove-if-not
	   '(lambda (x) (= str (vla-get-textstring (getbatt x tag))))
	   (vl-remove-if-not
	     '(lambda (x) (= bname (vla-get-effectivename x)))
	     (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT")))))
	     ))
	)
  (showss objlst)
  );defun









(setq lst
       (mapcar 'vlax-ename->vla-object (ss->list* (ssget '(
						    ;(0 . "MULTILEADER")
						    (304 . "*\\Fcs*")
						    )))))
(showss lst)



(setq temp  (vla-get-ActiveSelectionSet actdoc))
;;;   fKVLA-OBJECT IAcadSelectionSet 0c4c0f64>
(vla-Clear temp)
(vla-SelectOnScreen temp)

(vla-SelectOnScreen temp
                    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 1)) '(0 304))
                    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 1)) '("MULTILEADER" "*{*"))
                    )
(vla-Highlight temp :vlax-true)
