

;;;************************************************************************************************************************************************************
;;;**********************  fld->lst  ***************************  ���� �������� ������ ************************************************************************
;;;************************************************************************************************************************************************************
(defun ss:cbl:fld->lst (/ ssf ssl)
  (setq ssf (vl-sort (ss->lsto* (ssget '((0 . "INSERT"))))
		     '(lambda (a b) (<
				      (vla-get-textstring (getbatt a "NUMBER"))
				      (vla-get-textstring (getbatt b "NUMBER"))
				      ))))
  (setq ssl (ss->lsto (ssget '((0 . "INSERT")))))
  (mapcar 'cbl:fld->lst ssf ssl)
  );defun

;;;******************************************************************************
(defun g:cbl:fld->lst ()
  (cbl:fld->lst (vlax-ename->vla-object (car (entsel))) (vlax-ename->vla-object (car (entsel))))
  );defun

;;;******************************************************************************
;;;(setq objfld (vlax-ename->vla-object (car (entsel))))
;;;(setq objlst (vlax-ename->vla-object (car (entsel))))
;;;******************************************************************************
;;; ��� ������ ������ cbl_fld � cbl_lst/cbl_lst-mtxt
;;; ���������� ������� �� ������ ������� + HAND ����-����
;;;******************************************************************************
(defun cbl:fld->lst (objsrc objdest / objsrcl objdestl catt)
  (setq objsrcl (getbattswcmatch objsrc "*"))
  (setq objdestl (getbattswcmatch objdest "*"))
  (if (/= (length objsrcl)(length objdestl))
    (princ (strcat "\n" "�� ��������� ���������� ���������� " (vla-get-EffectiveName objsrc) " " (vla-get-EffectiveName objdest) " "))
    );if
  
  (foreach att objsrcl
    (if (not (member (vla-get-TagString att) (append #cbl:linklist #cbl:exceptlist)))
      (progn
	(setq catt (vl-remove-if-not '(lambda (x)
					(= (vla-get-tagstring att)(vla-get-tagstring x))
					) objdestl))
	(if (= (length catt) 1)
	  (setq catt (car catt)) ;; it's ok
	  (princ
	  (strcat
	    "\n" "� ����� ��������� " (vla-get-EffectiveName objdest) " "
	    "������� " (itoa (length catt)) " ���������� " (vla-get-tagstring att)))
	);if
      (if (or (wcmatch (vla-get-textstring catt) "*`#*")
	      (= "" (vla-get-textstring catt)))
	(vla-put-textstring catt (vla-get-textstring att))
	(princ (strcat
		 "\n �������� !!!  "
		 " �� ��������� �������� ����������� ���������� \n "
		 "���� " (vla-get-EffectiveName objsrc) " "
		 (vla-get-tagstring att) " = " (vla-get-textstring att) "\n"
		 "���� " (vla-get-EffectiveName objdest) " "
		 (vla-get-tagstring catt) " = " (vla-get-textstring catt) "\n"
		 ))
	);if
    );progn
      );if not in exception
    );foreach
  (vla-put-textstring (getbatt objdest "CBL_FLD_HAND") (vla-get-Handle objsrc))
  (vla-put-textstring (getbatt objsrc "CBL_LST_HAND") (vla-get-Handle objdest))
  (princ)
  );def
;;;************************************************************************************************************************************************************
;;;************************************************************************************************************************************************************




















;;;************************************************************************************************************************************************************
;;;**********************  lst->cnct  **************************************************************************************************************************
;;;************************************************************************************************************************************************************

(defun ss:cbl:lst->cnct (/ sssrc ssdest)
  (setq sssrc (ss->lsto (ssget '((0 . "INSERT")))))
  ;(setq sssrc (vl-sort (ss->lsto* (ssget '((0 . "INSERT"))))
;		     '(lambda (a b) (<
;				      (vla-get-textstring (getbatt a "NUMBER"))
;				      (vla-get-textstring (getbatt b "NUMBER"))
;				      ))))
  (setq ssdest (ss->lsto (ssget '((0 . "INSERT")))))
  (mapcar 'cbl:lst->cnct sssrc ssdest)
  );defun


;;;******************************************************************************
(defun g:cbl:lst->cnct ()
  (cbl:lst->cnct (vlax-ename->vla-object (car (entsel))) (vlax-ename->vla-object (car (entsel))))
  );defun

;;;******************************************************************************
;;;(setq objsrc (vlax-ename->vla-object (car (entsel))))
;;;(setq objdest (vlax-ename->vla-object (car (entsel))))
;;;******************************************************************************
;;; ��� ������ ������ cbl_fld � cbl_lst/cbl_lst-mtxt
;;; ���������� ������� �� ������ ������� + HAND ����-����
;;;******************************************************************************
(defun cbl:lst->cnct (objsrc objdest / objsrcl objdestl catt thirdaddstr thirdselfhand)
  (setq objsrcl (getbattswcmatch objsrc "*"))
  (setq objdestl (getbattswcmatch objdest "*"))
  (if (/= (length objsrcl)(length objdestl))
    (princ (strcat "\n" "�� ��������� ���������� ���������� " (vla-get-EffectiveName objsrc) " " (vla-get-EffectiveName objdest) " "))
    );if
  
  (foreach att objsrcl
    (if (not (member (vla-get-TagString att) (append #cbl:linklist #cbl:exceptlist)))
      (progn
	(setq catt (vl-remove-if-not '(lambda (x)
					(= (vla-get-tagstring att)(vla-get-tagstring x))
					) objdestl))
	(if (= (length catt) 1)
	  (setq catt (car catt)) ;; it's ok
	  (princ
	    (strcat
	    "\n" "� ����� ��������� " (vla-get-EffectiveName objdest) " "
	    "������� " (itoa (length catt)) " ���������� " (vla-get-tagstring att)))
	  );if
      (if (or (wcmatch (vla-get-textstring catt) "*`#*")
	      (= "" (vla-get-textstring catt)))
	(vla-put-textstring catt (vla-get-textstring att))
	(princ (strcat
		 "\n �������� !!!  "
		 " �� ��������� �������� ����������� ���������� \n "
		 "���� " (vla-get-EffectiveName objsrc) " "
		 (vla-get-tagstring att) " = " (vla-get-textstring att)
		 "���� " (vla-get-EffectiveName objdest) " "
		 (vla-get-tagstring catt) " = " (vla-get-textstring catt)
		 ))
	);if
    );progn
      );if not in exception
    );foreach
  (vla-put-textstring (getbatt objdest "CBL_LST_HAND") (vla-get-Handle objsrc))
  (vla-put-textstring (getbatt objsrc "CBL_CNCT_HAND") (vla-get-Handle objdest))

  (setq thirdaddstr (vla-get-TextString (getbatt objsrc "CBL_FLD_HAND")))
  (if (not (or (wcmatch thirdaddstr "*`#*") (= "" thirdaddstr)))
    (progn
      (vla-put-textstring (getbatt objdest "CBL_FLD_HAND") thirdaddstr)
      (setq thirdselfhand (getbatt (vla-HandleToObject #actdoc thirdaddstr) "CBL_CNCT_HAND"))
      (if (/= (vla-get-textstring thirdselfhand) (vla-get-Handle objdest))
	(progn
	  (princ (strcat "\n" "  ��������, �� ��������� hand-������ �� ������ �� ������������ � ������ �����...  ������ hand : " (vla-get-textstring thirdselfhand)))
	  (princ (strcat "\n" " �������� ����� �������� ���������"))
	  (vla-put-textstring thirdselfhand (vla-get-Handle objdest))
	  )
	)
      )
    );if
  ;(cbl:gensign objdest)
  (princ)
  );def
;;;*****************************************************************************************************************************************************
;;;************************************************************************************************************************************************************










;;;************************************************************************************************************************************************************
;;;**********************  lst->fld  **************************************************************************************************************************
;;;************************************************************************************************************************************************************
(defun ss:cbl:lst->fld (/ sssrc ssdest)
  (setq sssrc (vl-sort (ss->lsto* (ssget '((0 . "INSERT"))))
		     '(lambda (a b) (<
				      (vla-get-textstring (getbatt a "NUMBER"))
				      (vla-get-textstring (getbatt b "NUMBER"))
				      ))))
  (setq ssdest (ss->lsto (ssget '((0 . "INSERT")))))
  (mapcar 'cbl:lst->fld sssrc ssdest)
  );defun

;;;******************************************************************************
(defun g:cbl:lst->fld ()
  (cbl:lst->fld (vlax-ename->vla-object (car (entsel))) (vlax-ename->vla-object (car (entsel))))
  );defun

;;;******************************************************************************
;;;(setq objfld (vlax-ename->vla-object (car (entsel)))
;;;      objlst (vlax-ename->vla-object (car (entsel))))
;;;******************************************************************************
;;; ��� ������ ������ cbl_fld � cbl_lst/cbl_lst-mtxt
;;; ���������� ������� �� ������ ������� + HAND ����-����
;;;******************************************************************************
(defun cbl:lst->fld (objsrc objdest / objsrcl objdestl catt thirdaddstr thirdselfhand)
  (setq objsrcl (getbattswcmatch objsrc "*"))
  (setq objdestl (getbattswcmatch objdest "*"))
  (if (/= (length objsrcl)(length objdestl))
    (princ (strcat "\n" "�� ��������� ���������� ���������� " (vla-get-EffectiveName objsrc) " " (vla-get-EffectiveName objdest) " "))
    );if
  (foreach att objsrcl
    (if (not (member (vla-get-TagString att) (append #cbl:linklist #cbl:exceptlist)))
      (progn
	(setq catt (vl-remove-if-not '(lambda (x)
					(= (vla-get-tagstring att)(vla-get-tagstring x))
					) objdestl))
	(if (= (length catt) 1)
	  (setq catt (car catt)) ;; it's ok
	  (princ
	  (strcat
	    "\n" "� ����� ��������� " (vla-get-EffectiveName objdest) " "
	    "������� " (itoa (length catt)) " ���������� " (vla-get-tagstring att)))
	);if
      (if (or (wcmatch (vla-get-textstring catt) "*`#*")
	      (= "" (vla-get-textstring catt)))
	(vla-put-textstring catt (vla-get-textstring att))
	(princ (strcat
		 "\n �������� !!!  "
		 " �� ��������� �������� ����������� ���������� \n "
		 "���� " (vla-get-EffectiveName objsrc) " "
		 (vla-get-tagstring att) " = " (vla-get-textstring att)
		 "���� " (vla-get-EffectiveName objdest) " "
		 (vla-get-tagstring catt) " = " (vla-get-textstring catt)
		 ))
	);if
    );progn
      );if not in exception
    );foreach
  (vla-put-textstring (getbatt objdest "CBL_LST_HAND") (vla-get-Handle objsrc))
  (vla-put-textstring (getbatt objsrc "CBL_FLD_HAND") (vla-get-Handle objdest))

  (setq thirdaddstr (vla-get-TextString (getbatt objsrc "CBL_CNCT_HAND")))
  (if (not (or (wcmatch thirdaddstr "*`#*") (= "" thirdaddstr)))
    (progn
      (vla-put-textstring (getbatt objdest "CBL_CNCT_HAND") thirdaddstr)
      (setq thirdselfhand (getbatt (vla-HandleToObject #actdoc thirdaddstr) "CBL_FLD_HAND"))
      (if (/= (vla-get-textstring thirdselfhand) (vla-get-Handle objdest))
	(progn
	  (princ (strcat "\n" "  ��������, �� ��������� hand-������ �� ������ ����� � ������ �� ������������...  ������ hand : " (vla-get-textstring thirdselfhand)))
	  (princ (strcat "\n" " �������� ����� �������� ���������"))
	  (vla-put-textstring thirdselfhand (vla-get-Handle objdest))
	  )
	)
      )
    );if
  ;(cbl:gensign objdest)
  (princ)
  );def
;;;*****************************************************************************************************************************************************
;;;************************************************************************************************************************************************************



;(length (getbattswcmatch (vlax-ename->vla-object (car (entsel))) "*"))









;;;******************************************************************************
;;; ������� ��� �������� ���������� �����
;;;******************************************************************************
(defun c:ss:kd:clearatts (/ blks lst)
  (setq blks (ss->lsto* (ssget)))
  (foreach blk blks
    (setq lst (getbattswcmatch blk "*"))
    ;(mapcar '(lambda (x) (vla-put-textstring x "#")) lst)
    (mapcar '(lambda (x) (vla-put-textstring x "")) lst)
    )
  (princ)
  )
(defun c:ss:kd:clearatts# (/ blks lst)
  (setq blks (ss->lsto* (ssget)))
  (foreach blk blks
    (setq lst (getbattswcmatch blk "*"))
    ;(mapcar '(lambda (x) (vla-put-textstring x "#")) lst)
    (mapcar '(lambda (x) (vla-put-textstring x "#")) lst)
    )
  (princ)
  )

(defun g:kd:clearatts (/ lst)
  (setq lst (getbattswcmatch (vlax-ename->vla-object (car (entsel))) "*"))
  ;(mapcar '(lambda (x) (vla-put-textstring x "#")) lst)
  (mapcar '(lambda (x) (vla-put-textstring x "")) lst)
  (princ)
  )
(defun ss:clearatt (tag / blks lst)
  (setq blks (ss->lsto* (ssget '((0 . "INSERT")))))
  (foreach blk blks
    (vla-put-textstring (getbatt blk tag) "")
    )
  (princ)
  );defun

















;;;
;;;;;;******************************************************************************
;;;;;; ����� ���� �������� � ���������� "HAND" ���������� �����, �� ��������� �� ����
;;;;;;******************************************************************************
;;;(defun c:zh () (g:kd:zoomtohand))
;;;(defun g:kd:zoomtohand ( / obj str)
;;;  (setq str (vla-get-textstring (vlax-ename->vla-object (car (nentsel)))))
;;;  (setq obj (vlax-vla-object->ename (vla-HandleToObject #actdoc str)))
;;;  (vl-cmdf "_.zoom" "_O" obj "")
;;;  (SSSETFIRST nil (ssadd obj))
;;;  )
;;;;;;******************************************************************************
;;;
