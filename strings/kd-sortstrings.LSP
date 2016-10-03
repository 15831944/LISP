;(load (strcat #lisppath "!чужое разобрать\\LEE MAC PROGRAMMING\\GetFilesV1-1.lsp"))
;(setq pathlist (LM:GETFILES "Select files ..." "D:\\_TDMS\\" "dwg"))
;(setq pathlist '("D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л1.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л10.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л11.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л12.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л13.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л14.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л15.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л16.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л2.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л3.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л4.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л5.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л6.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л7.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л8.dwg" "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л9.dwg"))
;(vl-sort pathlist '<)       => 1 10 11 12 2 3 4 5 6 7 8 9
;(kd:sortstrings pathlist) => 1 2 3 4 5 6 7 8 9 10 11


;;принимает список строк например как его соритрует файловая система:
;'("D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л1.dwg"
;  "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л10.dwg"
;  "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л11.dwg"
;  "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л8.dwg"
;  "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л9.dwg")
;; и сортирует его как надо в нашем понимании (в отличии от vl-sort):
;'("D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л1.dwg"
;  "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л8.dwg"
;  "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л9.dwg"
;  "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л10.dwg"
;  "D:\\_TDMS\\1703-69-АВП1\\1703-69-АВП1 л11.dwg")
 
;(load (strcat #lisppath "DataBase\\dblib.lsp"))

;(setq  pathlist		'("A1" "A10" "A2" "A11"))
;(vl-sort pathlist '<)	=>	 ("A1" "A10" "A11" "A2")  
;(kd:sortstrings pathlist)	 ("A1" "A2" "A10" "A11")




(defun kd:sortmarks (marks / mlst lengthes ans)
  (setq mlst (mapcar 'sepstr* marks))
  (setq lengthes (origlist (mapcar 'length mlst)))
  (setq ans (mapcar 'list lengthes))
  (mapcar
    '(lambda (line)	;(setq line (nth 2 mlst))
       (setq ans
       (subst
	 (reverse (cons line (reverse (assoc (length line) ans))))
	 (assoc (length line) ans)
	 ans))
       )
    mlst
    )
  (princ)
  (setq ans (vl-sort ans '(lambda (a b) (> (car a) (car b)))))

  (setq ans
  (mapcar
    '(lambda (tbl / n tb)	;(setq tbl (nth 0 ans))
       (setq n (car tbl) tb (cdr tbl))
       (while (>= (setq n (1- n)) 0)
	 (setq tb (vl-sort tb '(lambda (a b)
	   (<
	     (if (= "num" (str|charcategory (nth n a)))
	       (atoi (nth n a))
	       (car (vl-string->list (nth n a)))
	       )
	     (if (= "num" (str|charcategory (nth n b)))
	       (atoi (nth n b))
	       (car (vl-string->list (nth n b)))
	       )
	     ))))
	 )
       tb
       )
    ans))
  (mapcar '(lambda (x) (antisep x "")) (apply 'append ans))
  );defun









(setq pathlist files)
(defun kd:sortstrings	(pathlist / path ext i lst)
  ;вычисляем совпадающую часть строк
  (setq
    path
     (car
       (mapcar
	 'VL-LIST->STRING
	 (db|transmat
	   (vl-remove-if-not
	     '(lambda (line)
		(apply '= line)
		)
	     (db|transmat
	       (mapcar
		 '(lambda (line)
		    (VL-STRING->LIST line)
		    )
		 pathlist)
	       )
	     )
	   )
	 )
       )
    )
  
  (setq i -1)
  (while (apply '= (nth (setq i (1+ i)) (db|transmat (mapcar '(lambda (line) (reverse (VL-STRING->LIST line))) pathlist)))))
  (setq ext (strcut (car pathlist) (- (strlen (car pathlist)) i) 0))
  (setq	lst (mapcar '(lambda (x) (list (atoi (vl-string-right-trim ext (vl-string-subst "" path x))) x) ) pathlist ))
  (setq lst (mapcar 'cadr (vl-sort lst '(lambda (a b) (< (car a) (car b))))))
  lst
  );defun


(defun kd:sortfunc (pathlist func / path ext i)
  ;вычисляем совпадающую часть строк
  (setq path (vl-remove-if-not '(lambda (line) (apply '= line)) (db|transmat (mapcar '(lambda (line) (VL-STRING->LIST line)) (mapcar func pathlist) ))))
  (if path
    (setq path (car (mapcar 'VL-LIST->STRING (db|transmat path))))
    (setq path "")
    )
  (setq i -1)
  (while (apply '= (nth (setq i (1+ i)) (db|transmat (mapcar '(lambda (line) (reverse (VL-STRING->LIST line))) (mapcar func pathlist) )))))
  (setq ext (strcut (car (mapcar func pathlist)) (- (strlen (car (mapcar func pathlist))) i) 0))
  
  (setq	lst (mapcar '(lambda (x) (list (atoi (vl-string-right-trim ext (vl-string-subst "" path (car (mapcar func (list x)))))) x)) pathlist))
  (setq lst (mapcar 'cadr (vl-sort lst '(lambda (a b) (< (car a) (car b))))))
  );defun

















;(setq items '("1" "F" "asd" "3"))


;(dcl:ManualSort '("1" "F" "asd" "3"))



(defun dcl:ManualSort (
		       items
		       /
		       $DLGName
		       dcl_id
		       
		       DCL|MkDlgFile
		       windowWidth
		       windowHeight
		       
		       MS|Done
		       MS|Cancelled
		       MS|RefreshLists
		       MS|AddClicked
		       MS|RemoveClicked
		       MS|ReverseClicked
		       
		       curSrcList
		       curResList
		       result
		       )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;(setq itemsdcl (mapcar 'dcl:formatstring items))
  (setq windowWidth (max (min (apply 'max (mapcar '(lambda (x) (fix (* (strlen x) 1.5))) items)) 270) 85))
  (setq windowHeight (+ 5 (length items)))
  
  (setq curSrclist items)
  (setq curResList '(""))
  
  (setq $DLGName "ManualSort")	; must NOT contain "-"


  
  ;----------------------------------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------------------------------
  (defun MS|Done ()
    (setq result curResList)
    (done_dialog)
    )
  ;----------------------------------------------------------------------------------------------------------
  (defun MS|Cancelled () (done_dialog))
  ;----------------------------------------------------------------------------------------------------------
  (defun MS|RefreshLists (sl rl)
    (start_list "srcLstKey")
    (mapcar 'add_list sl)
    (end_list)
    (start_list "resLstKey")
    (mapcar 'add_list rl)
    (end_list)
    )
  ;----------------------------------------------------------------------------------------------------------
  (defun MS|AddClicked ( / gtsrc gtres)
    (setq gtsrc (get_tile "srcLstKey"))
    (setq gtres (get_tile "resLstKey"))
    (if (/= "" gtsrc)
      (progn
	(setq gtres (sepstr gtres " "))
	(setq gtsrc (mapcar '(lambda (n) (nth n curSrclist)) (mapcar 'atoi (sepstr gtsrc " "))))
	(setq curSrclist (reverse (car (db|diff curSrclist gtsrc))))
	(setq curResList (vl-remove '"" (append curResList gtsrc)))
	(MS|RefreshLists curSrclist curResList)
	)
      )
    );defun
  ;----------------------------------------------------------------------------------------------------------
  (defun MS|RemoveClicked ( / gtsrc gtres)
    (setq gtsrc (get_tile "srcLstKey"))
    (setq gtres (get_tile "resLstKey"))
    (if (/= "" gtres)
      (progn
	(setq gtsrc (sepstr gtsrc " "))
	(setq gtres (mapcar '(lambda (n) (nth n curResList)) (mapcar 'atoi (sepstr gtres " "))))
	(setq curResList (reverse (car (db|diff curResList gtres))))
	(setq curSrclist (vl-remove '"" (append curSrclist gtres)))
	(MS|RefreshLists curSrclist curResList)
	)
      )
    );defun
  ;----------------------------------------------------------------------------------------------------------
  (defun MS|ReverseClicked ( / )
    (setq curSrclist (reverse curSrclist))
    (MS|RefreshLists curSrclist curResList)
    );defun
  ;----------------------------------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------------------------------


  (defun DCL|MkDlgFile ( / dcl:formatstring  FileHanlde)
    (defun dcl:formatstring (str / val tail) 
      (cond
	((vl-string-search "\"" str) (setq val (reverse (sepstr str "\""))) (setq tail (car val)) (setq val (mapcar '(lambda (s) (strcat s "\\\"")) (reverse (cdr val)))) (setq val (strcat (apply 'strcat val) tail)))
	((null str) "")
	(T str)
	)
      )
    (setq FileHanlde (open (strcat (getenv "temp") "\\" $DLGName ".dcl") "w"))
    
    
    (mapcar
      '(lambda (x) (write-line x FileHanlde))
      (list
	
      $DLGName ": dialog"
      "{label=\"kakt00z (c) DCLgen window\";"
      "width=" (itoa windowwidth) ";"
      ;"height=" "70" ";"
      ;;"initial_focus=\"" "key" dlgname "\";"
      ":row{"
      	":column{"
      	":list_box{"
      		(strcat "label=\"Select an item ... "  "\";" )
      		(strcat "key=\"srcLstKey\";")
      		(strcat "list=\"" "\";")
      		"height=" (itoa windowHeight) ";"
      		"fixed_width_font=true;"
      		"multiple_select=true;"
      		"}"
      	":button{"
      		(strcat "key=\""  "AddBtnKey" "\";")
      		(strcat "label=\""  "Add -->" "\";")
      		;"action=\"(MS|AddClicked)\";"
      		"}"
      	"}"
      	":column{"
      	":list_box{"
      		(strcat "label=\"Select an item ... "  "\";" )
      		(strcat "key=\"resLstKey\";")
      		(strcat "list=\"" "\";")
      		"height=" (itoa windowHeight) ";"
      		"fixed_width_font=true;"
      		"multiple_select=true;"
      		"}"
      	":button{"
      		(strcat "key=\""  "RemoveBtnKey" "\";")
      		(strcat "label=\""  "<-- Remove" "\";")
      		;"action=\"(MS|RemoveClicked)\";"
      		"}"      
      	"}"
      "}"
      ":spacer{width=1;}"
      ":button{"
      (strcat "key=\""  "RvrsBtnKey" "\";")
      (strcat "label=\""  "Reverse" "\";")
      "}"
      ":spacer{width=1;}"
      "ok_cancel;"
      "}"
      ))
    (close FileHanlde)
    );defun
  ;----------------------------------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------------------------------
    (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") "\\" $DLGName ".dcl"))) 0)
	  (not (new_dialog $DLGName dcl_id))
	) (exit))
  ;----------------------------------------------------------------------------------------------------------
  ;(action_tile "is_default"	"(kd:dcl-pfl_done)")
  (action_tile "accept"		"(MS|Done)")
  (action_tile "cancel" 	"(MS|Cancelled)")
  (action_tile "AddBtnKey" 	"(MS|AddClicked)")
  (action_tile "RemoveBtnKey" 	"(MS|RemoveClicked)")
  (action_tile "RvrsBtnKey" 	"(MS|ReverseClicked)")
  (MS|RefreshLists curSrclist curResList)
  (start_dialog)
  ;(done_dialog)
  (unload_dialog dcl_id)
  result
  );defun




