(defun c:tree (/ dclid)
  (if (< (setq dclid (load_dialog "d:/LISP WORKING/DCL/tst/elka.dcl"))
	 0)
    (exit)
    )
  (new_dialog "tree_dial" dclid)
  (start_image "tree")
  (mapcar (function (lambda (x) (apply 'vector_image x)))
	  ;;;;;;;;;;;;;;;;;   image   ;;;;;;;;;
	  '((3 6 3 22 73) (3 16 12 11 73) (3 16 11 22 73) (3 3 32 3 73) (17 3 17 22 73) 
(21 11 32 11 73) (32 11 21 22 73) (21 22 32 22 73) (24 15 28 19 73))
	  ;;;;;;;;;;;;;;   end image  ;;;;;;;;;
	  )
  (end_image)
  (action_tile "accept" "(okpressed)")
  (start_dialog)
  (unload_dialog dclid)
  )


(defun okpressed ()
  (done_dialog)
  );defun


;;;
;;;
;;;
;;;
;;;
;;;
;;;(defun anum20-dialog ( / anum20list dcl-ID)
;;;  (if (or (< (setq dcl-ID (load_dialog anum20-dclfile)) 0)
;;;	  (not (new_dialog "anum20dlg" dcl-ID)))
;;;    (exit));if
;;;  (action_tile "accept" "(anum20dlgokpressed)")
;;;  (anum20dlgstart)
;;;  (unload_dialog dcl-ID)
;;;  anum20list
;;;  );defun
;;;
;;;(defun anum20dlgstart ( / lst)
;;;  (if (setq lst (anum20readparamsfromfile))
;;;    (mapcar '(lambda (x) (set_tile x (cadr (assoc x lst)))) anum20-parameterlist));if
;;;  (start_dialog)
;;;  );defun
;;;
;;;(defun anum20readparamsfromfile ( / fhand line)
;;;  (if (findfile anum20-defparamsfile)
;;;    (progn
;;;      (setq fhand (open anum20-defparamsfile "r"))
;;;      (setq line (read-line fhand))
;;;      (close fhand)
;;;      (read line)
;;;      ))
;;;  );defun
;;;
;;;(defun anum20dlgokpressed ()
;;;  (setq anum20list '())
;;;  (mapcar '(lambda(x) (setq anum20list (append anum20list (list (list x (get_tile x))))))
;;;	  anum20-parameterlist)
;;;  (anum20saveparams anum20list)
;;;  (done_dialog)
;;;  );defun
;;;
;;;(defun anum20saveparams (lst / fhand)
;;;  (setq fhand (open anum20-defparamsfile "w"))
;;;  (prin1 lst fhand)
;;;  (close fhand)
;;;  );defun
