;13_01_31
;;;  �������� ������� � ����� �� � ����



(defun c:bf ()
  (kd:block-filter)
  )


(defun kd:block-filter ( / ss blk efname)
  (princ "\n Select items to filter ....   \n")
  (if (not (setq ss (ssget "_I" '((0 . "INSERT"))))) (setq ss (ssget '((0 . "INSERT")))))
  (setq ss (ss->lsto* ss))
  (setq blk (entsel "\n Pick an element to get filter options .... \n"))
  (setq blk (vlax-ename->vla-object (car blk)))
  (setq efname (vla-get-EffectiveName blk))

  (setq
    ss (vl-remove-if-not
	 '(lambda (x)
	    (and
	      (= "AcDbBlockReference" (vla-get-ObjectName x))
	      (= efname (vla-get-EffectiveName x))
	      )
	    )ss))

  (setq ss (lst-to-ss ss))
  (SSSETFIRST nil ss)
  );defun







(defun c:bfbatt ()
  (kd:block-filter-by-att)
  )

(defun kd:block-filter-by-att ( / ss ins efname att tag str)
  (princ "\n Select items to filter ....   \n")
  (if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
    (setq ss (vl-catch-all-apply 'ssget '(((0 . "INSERT")))))
    )
  (cond
    ((= 'PICKSET (type ss))
     (setq ss (ss->lsto* ss))

     ;(setq att (nentsel "\n Pick an element to get filter options .... \n"))
     (setq att (vl-catch-all-apply 'nentsel '("Pick an element to get filter options ....")))
  ;;; ����� � ���, ��� ���� ������� ��� nentsel � ��������,
  ;;; �� ������ ������ (<��� �������: 7c1a4b60> (25937.3 37649.4 0.0)) ������� 2
  ;;; � ����� ����� �� ���� 330 ������ "INSERT" � ������� ������
  ;;; � ���� � ������� �� � ��������, �� �� ������ ������
  ;;;  (<��� �������: 7e06e500>
  ;;;	(25933.0 37643.6 0.0)
  ;;;	((1.0 0.0 0.0)
  ;;;	  (0.0 1.0 0.0)
  ;;;	  (0.0 0.0 1.0)
  ;;;	  (25927.5 37645.8 0.0)
  ;;;	)
  ;;;	(<��� �������: 7c1a4ae0>)
  ;;;  )
  ;;; � �� ���� ��������� ������� �� "INSERT", ��� ��� ���������,
  ;;; � "BLOCK" � ����� ����� "INSERT" � ������� �� �����,
  ;;; � ��� ����������� ���������� ���������

     


  (cond
    ((null att) (princ))
    ((vl-catch-all-error-p att)
     (setq str (car (kd:dclget '("String"))))
     (setq tag (kd:dcl:pick-from-list (mapcar '(lambda (a) (vla-get-TagString a)) (getbattswcmatch (setq ins (vlax-ename->vla-object (car (entsel "Pick a Block Insert")))) "*"))))
     (setq efname (vla-get-EffectiveName ins))
     )
    ((listp att)
     (setq ins (vlax-ename->vla-object (cdr (assoc 330 (entget (car att))))))
     (setq att (vlax-ename->vla-object (car att)))
     (setq tag (vla-get-TagString att))
     (setq str (vla-get-TextString att))
     (if (vl-string-search "," (setq str (vla-get-TextString att)))
       (setq str (antisep (sepstr str ",") "`,"))
       )
     (setq efname (vla-get-EffectiveName ins))
     )
    )

  
;;;  (if (= "ATTRIB" (cdr (assoc 0 (entget (car att)))))
;;;    (setq
;;;      ins (vlax-ename->vla-object (cdr (assoc 330 (entget (car att)))))
;;;      efname (vla-get-EffectiveName ins)
;;;      att (vlax-ename->vla-object (car att))
;;;      tag (vla-get-TagString att)
;;;      str (vla-get-TextString att)
;;;      )
;;;    ;else
;;;;;;    (if (= 'ENAME (type (caar (reverse att))))
;;;;;;      (setq ins (vlax-ename->vla-object (caar (reverse att))))
;;;;;;    )
;;;    )

  (setq ss
	 (vl-remove-if-not
	   '(lambda (x)
	      (and
		(= "AcDbBlockReference" (vla-get-ObjectName x))
		(= :vlax-true (vla-get-HasAttributes x))
		(= efname (vla-get-EffectiveName x))
		(wcmatch (vla-get-TextString (getbatt x tag)) str)
		)
	      )
	   ss
	   )
	)
  
;;;  (setq att (kw:pick-from-list (mapcar 'vla-get-TagString (getbattswcmatch (car ss) "*"))))
;;;  ;(setq att (kd:dcl:pick-from-list (mapcar 'vla-get-TagString (getbattswcmatch (car ss) "*"))))
;;;  (setq str (getstring
;;;	      "\n������� ����� ��������� ������� : \n
;;;	      # �������� ���� ����� �����\n
;;;	      @ �������� ���� ����� �����\n
;;;	      .(�����) �������� ����� ������, �� ���������� �� ������, �� ������\n
;;;	      * �������� ����� ������������������ (� ����� �����)\n
;;;	      ? �������� ����� ���� ����� ������\n
;;;	      ~ � ������ - ���, ����� �������������\n
;;;	      \[...\] \[~...\] �������� ����� �� ��������, ������������� � �������\n
;;;	      - ����� ����� ����������� ������� ��������� �� ��������\n
;;;	      "))
;;;  (setq ss (vl-remove-if-not '(lambda (x)
;;;     (wcmatch (vla-get-TextString (getbatt x att)) (strcat "*" str "*"))
;;;				) ss))
  (setq ss (lst-to-ss ss))
  (SSSETFIRST nil ss)
     )
    )
  );defun

;(pfl '("NUMBER" "TYPE" "CORES" "CATEGORY" "LOCCAB" "LOCFLD" "SIGNALNAME" "VOLTAGE" "SECTION" "MARK1" "MARK2" "MARK3" "MARK4" "MARK5" "MARK6" "MARK7" "MARK8" "MARK9" "MARK10" "MARK11" "MARK12" "MARK13" "MARK14" "MARK15" "MARK16" "MARK17" "MARK18" "MARK19" "MARK20" "MARK21" "MARK22" "MARK23" "MARK24" "MARK25" "MARK26" "MARK27" "MARK28" "MARK29" "MARK30" "LENGTH" "CBL_FLD_ID" "CBL_LST_ID" "SIGN"))




;(load (strcat #lisppath "excel\\xlsformatlib.LSP"))
;(setq attlist (mapcar 'car (DB|FORMATDATA  (excel>lst))))
;(fltr|block-by-atts "POZ" attlist)
(defun fltr|block-by-atts (tag attlist / ss ins efname att str)
  (princ "\n Select items to filter ....   \n")
  (if (not (setq ss (ssget "_I" '((0 . "INSERT"))))) (setq ss (ssget '((0 . "INSERT")))))
  (setq ss (ss->lsto* ss))
  (setq ss (vl-remove-if-not '(lambda (x) (member (vla-get-TextString (getbatt x tag)) attlist)) ss))
  (setq ss (lst-to-ss ss))
  (SSSETFIRST nil ss)
  );defun







(defun c:bfbdyn ()
  ;(vla-startundomark #actdoc)
  ;(acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))
  (fltr|block-by-dyn)
  ;(acet-error-restore)
  ;(vla-endundomark #actdoc)
  );defun



(defun fltr|block-by-dyn ( / ss smplblk efname pname pval)
  (princ "\n Select items to filter ....   \n")
  (if (not (setq ss (ssget "_I" '((0 . "INSERT"))))) (setq ss (ssget '((0 . "INSERT")))))
  (setq ss (ss->lsto* ss))
  (setq smplblk (vlax-ename->vla-object (car (entsel "\n Pick an element to get filter options .... \n"))))
  (setq efname (vla-get-EffectiveName smplblk))
  (setq pname (kd:dcl:pick-from-list (mapcar 'vla-get-PropertyName (vlax-safearray->list (vlax-variant-value(vla-GetDynamicBlockProperties smplblk))))))
  (setq pval (vlax-variant-value (vla-get-Value (getbdyn smplblk pname))))

  (setq
    ss
     (vl-remove-if-not
       '(lambda (x)
	  (and
	    (= efname (vla-get-EffectiveName x))
	    (= pval (vlax-variant-value (vla-get-Value (getbdyn x pname))))
	    )
	  )
       ss
       )
    )
  (princ (length ss))
  (setq ss (lst-to-ss ss))
  (SSSETFIRST nil ss)
  );defun






(defun c:bfbattwcm ()
  (bfbattwcm)
  );defun


(defun bfbattwcm ( / ss att ins efname tag str wcmask)
  (if (not (setq ss (ssget "_I" '((0 . "INSERT"))))) (setq ss (ssget '((0 . "INSERT")))))
  (setq ss (ss->lsto* ss))
  (setq att (nentsel "\n Pick an element to get filter options .... \n"))

  (cond
    (
     (= "ATTRIB" (cdr (assoc 0 (entget (car att)))))
     (setq
       ins (vlax-ename->vla-object (cdr (assoc 330 (entget (car att)))))
       efname (vla-get-EffectiveName ins)
       att (vlax-ename->vla-object (car att))
       tag (vla-get-TagString att)
       str (vla-get-TextString att)
       )
     )
;;;    (
;;;     (= 'ENAME (type (caar (reverse att))))
;;;     (setq ins (vlax-ename->vla-object (caar (reverse att))))
;;;     )
    )
  (setq wcmask (kd:dcledtlst (mapcar '(lambda (x) (strcat "*" x"*")) (sepstr str "\n"))))
  (setq wcmask (antisep (vl-remove "" wcmask) ""))
  (setq
    ss (vl-remove-if-not
	 '(lambda (x)
	    (and
	      (= "AcDbBlockReference" (vla-get-ObjectName x))
	      (= :vlax-true (vla-get-HasAttributes x))
	      (= efname (vla-get-EffectiveName x))
	      (wcmatch (vla-get-TextString (getbatt x tag)) wcmask)
	      )
	    )
	 ss))
  (setq ss (lst-to-ss ss))
  (SSSETFIRST nil ss)
  );defun






































