;;; ������� 12_11_05
;;; ����� ������ �� ������ ����� � ������� ���� � ������
;;; -kakt00z-�  �

;(setq prop '("���������" "���������" "������ (����� ������)"))
;(kd:dcl:str<-strlst*btn '("���	������" "���������" "������"))


(defun kd:dcl:str<-strlst*btn (strlst
			       /
			       dlgname
			       dclfilename
			       dcl-file-path			; ���� � dcl-����� ��� ����� (� ����� temp)
			       hand					; ����� ����� �����
			       dcl_id
			       strlist
			       i
			       out
			       dcl:str<-strlst*btn_done
			       )
  (setq dlgname "kd_dcl_str_strlst_btn")	; must NOT contain "-", ":", "*"
  (setq dclfilename (strcat "\\" dlgname ".dcl"))

  ;;;;*******************************************************************

  (setq dcl-file-path (strcat (getenv "temp") dclfilename)
	hand (open dcl-file-path "w"))
  
  ;;; ��������� dcl-�����
  (mapcar '(lambda (x) (write-line x hand))
	  (list
	    dlgname
	    ": dialog"
	    "{label=\"kakt00z developing kd:dcl:str_strlst*btn window\";"
	    "width=80;"
	    )
	  )
  (setq i -1)

  (repeat (length strlst)
    (write-line (strcat
		  ":button"
		  "{"
		  "key=\"key" (itoa (setq i (1+ i))) "\";"
		  "label=\"" (nth i strlst) "\";"
		  "action=" "\"(setq out " (itoa i) ")" "(done_dialog)\";"
		  "}"
		  );strcat
      hand
      )
    );repeat

;;;  (mapcar '(lambda (x)
;;;	     (write-line
;;;	       (strcat ":button"
;;;			 "{"
;;;			 "label=\"" x "\";"
;;;			 "key=\"" x "\";"
;;;			 "}"
;;;			 );strcat
;;;	       )
;;;	     )
;;;	  strlst
;;;	  )
;;;  (mapcar '(lambda (x) (write-line x hand))
;;;	  '(
	    ":spacer{width=1;}"
	    "ok_cancel;"
;;;	    "}"
;;;	    )
;;;	  )
  (write-line ":spacer{width=1;}ok_cancel;}" hand)
  (close hand)
  ;;;;*******************************************************************
  
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0)
	  (not (new_dialog dlgname dcl_id)))
    (exit)
    ) ;if

  (action_tile "accept"		"(setq out 0)(done_dialog)")
  (action_tile "is_default"	"(setq out 0)(done_dialog)")
  (start_dialog)
  (unload_dialog dcl_id)
  (nth out strlst)
  );defun