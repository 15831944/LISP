; 13_07_01


(defun tbl>excel ( / lst)
  (setq lst (ss->tbl (ssget '((0 . "*TEXT")))))
  (setq lst (mapcarx vla-get-TextString nil lst))
  (lst>excel lst)
  )

(defun tbl*a>excel ( / lst)
  (setq lst (ss->tbl (ssget '((0 . "ATTDEF")))))
  (setq lst (mapcarx vla-get-TagString nil lst))
  (lst>excel lst)
  )




(defun tbl>lst ( / lst)
  (setq lst (ss->tbl (ssget '((0 . "*TEXT")))))
  (setq lst (mapcarx vla-get-TextString nil lst))
  )



;;;(defun tbl>excel ( / lst #excel wkbs wb ash range nl)
;;;  (setq lst (ss->tbl (ssget)))
;;;  (setq #excel (vlax-get-or-create-object "Excel.Application"))
;;;  (vlax-put-property #excel "Visible" :vlax-true)
;;;  (setq wkbs (vlax-get-property #excel "Workbooks"))
;;;  (setq wb (vlax-invoke-method wkbs "Add" 1))
;;;  (setq ash (vlax-get-property wb "ActiveSheet"))
;;;  (setq nl 1)
;;;  (foreach line lst
;;;    (setq range (vlax-get-property ash "Range" (strcat "A" (itoa nl))))
;;;    (foreach obj line
;;;      (vlax-put-property range "Value2" (vla-get-TextString obj))
;;;      (setq range (vlax-get-property range "Next"))
;;;      )
;;;    (setq nl (1+ nl))
;;;    )
;;;  (mapcar
;;;    (function (lambda (x) (if (not (vlax-object-released-p x))
;;;			    (vlax-release-object x)
;;;			    )))
;;;    (list range ash wb wkbs #excel); обязательно в обратном порядке
;;;    )
;;;  (setq	range nil
;;;	ash nil
;;;	wb nil
;;;	wkbs nil
;;;	#excel nil)
;;;  (prin1)
;;;  );defun




;|
_$ (vlax-get-property range "NUMBERFORMAT")
#<variant 8 ДД.МММ>
_$ (vlax-get-property range "NUMBERFORMAT")
#<variant 8 Основной>
_$ (vlax-get-property range "NUMBERFORMAT")
#<variant 8 0,00>
_$ (vlax-get-property range "NUMBERFORMAT")
#<variant 8 @>
_$ (vlax-variant-value (vlax-get-property range "NUMBERFORMAT"))
|;


(defun lst>excel (lst / #excel wkbs wb ash range nl)
  (setq #excel (vlax-get-or-create-object "Excel.Application"))
  (vlax-put-property #excel "Visible" :vlax-true)
  (setq wkbs (vlax-get-property #excel "Workbooks"))
  (setq wb (vlax-invoke-method wkbs "Add" 1))
  (setq ash (vlax-get-property wb "ActiveSheet"))
  (setq nl 0)
  (foreach line lst
    (setq range (vlax-get-property ash "Range" (strcat "A" (itoa (setq nl (1+ nl))))))
    (foreach str line
      (vlax-put-property range "NUMBERFORMAT" "@")
      (vlax-put-property range "Value2" str)
      (setq range (vlax-get-property range "Next"))
      ))
  (mapcar (function (lambda (x) (if (not (vlax-object-released-p x)) (vlax-release-object x))))
	  (list range ash wb wkbs #excel)); обязательно в обратном порядке
  (setq	range nil ash nil wb nil wkbs nil #excel nil)
  (prin1)
  );defun




(defun lst>curexcel (lst / #excel #selection #range)
  (setq #excel (vlax-get-object "Excel.Application"))
  (setq #selection (vlax-get-Property #excel "Selection"))
  (setq nl 0)
  (foreach line lst
    (setq #range (vlax-get-property #selection "Range" (strcat "A" (itoa (setq nl (1+ nl))))))
    (foreach str line
      (vlax-put-property #range "Value2" str)
      (setq #range (vlax-get-property #range "Next"))
      )
    )
  (mapcar
    (function (lambda (x) (if (not (vlax-object-released-p x)) (vlax-release-object x))))
    (list #range #selection #excel)); обязательно в обратном порядке
  (setq	#range nil #selection nil #excel nil)
  (gc)
  (prin1)
  )
;defun





(defun c:excel|unmerge ( / #excel selection Range MergeArea)
  (setq #excel (vlax-get-object "Excel.Application"))
  (setq selection (vlax-get-Property #excel "Selection"))
  (vlax-for Range selection
    (if (= :vlax-true (vlax-variant-value (vlax-get-property Range "MergeCells")))
      (progn
	(setq MergeArea (vlax-get-property Range "MergeArea"))
	(vlax-invoke-method MergeArea "UnMerge")
	(vlax-put-property MergeArea "Formula" (vlax-get-property Range "Formula"))
	)
      )
    )
  (mapcar
    (function (lambda (x) (if (not (vlax-object-released-p x)) (vlax-release-object x))))
    (list MergeArea selection #excel)
    )
  );defun


(defun c:excel|format-apply ( / #excel selection Range MergeArea)
  (setq #excel (vlax-get-object "Excel.Application"))
  (setq selection (vlax-get-Property #excel "Selection"))
  (vlax-for Range selection
    (vlax-put-property Range "Formula" (vlax-get-property Range "Formula"))
    )
  (mapcar
    (function (lambda (x) (if (not (vlax-object-released-p x)) (vlax-release-object x))))
    (list selection #excel)
    )
  );defun














(defun excel>tbl () (lst>objs (excel>lst)))



;(setq lst tbl:SHK10)
(defun lst>objs (lst / colwidth bpt lbpt th cw txtobj lst>objs#data v cx by)
  (setq lst>objs#data '() v '(-1 1 0))
  (setq th 2.5 cw 3)	;;;  3мм на букву
  (setq lst (mapcarx any-to-string nil lst))

  (setq colwidth (mapcar '(lambda (line) (mapcar 'strlen line)) lst))
  (setq colwidth (mapcar '(lambda (line) (apply 'max line)) (db|transmat colwidth)))
  (setq colwidth (mapcar '(lambda (x) (* x cw)) colwidth))
  (setq basepoint (getpoint) bpt basepoint)

  (mapcar
    '(lambda (line / ol) 
       (setq ol '() lbpt bpt)
       (mapcar
	 '(lambda (word w)
	    (setq txtobj (vla-AddMtext #modspace (vlax-3d-point bpt) (1- w) word))
	    (setq ol (cons (vla-get-Handle txtobj) ol))
	    ;(setq ol (append ol (list (vla-get-Handle txtobj))))
	    (setq bpt (mapcar '+ bpt (list w 0 0)))
	    )
	 line colwidth
	 )
       (vla-addLine #modspace (vlax-3d-point (mapcar '+ v lbpt)) (vlax-3d-point (mapcar '+ v bpt)))
       (setq lst>objs#data (cons ol lst>objs#data))
       ;(setq lst>objs#data (append lst>objs#data (list ol)))
       (setq bpt (mapcar '+ bpt (list (- (apply '+ colwidth)) (- (* th 2)) 0)))
       )
    lst
    )
  (setq cx (car basepoint) by (cadr basepoint))
  
  (mapcar
    '(lambda (dx)
       (setq cx (+ cx dx))
       (vla-addLine #modspace
	 (vlax-3d-point (mapcar '+ v (list cx by)))
	 (vlax-3d-point (mapcar '+ v (list cx (cadr bpt))))
	 )
       )
    colwidth)
  (vla-addLine #modspace
	 (vlax-3d-point (mapcar '+ v (list (car basepoint) (cadr bpt))))
	 (vlax-3d-point (mapcar '+ v (list cx (cadr bpt))))
	 )
  lst>objs#data
  );defun
(setq lst>tbl lst>objs)





(defun excel>ss (/ lst s)
  (setq lst (excel>lst))
  (setq ss (ss->tbl (ssget '((0 . "*TEXT")))))
  (mapcar '(lambda (d s) (mapcar '(lambda (dd ss) (vla-put-TextString dd ss)) d s)) ss lst)
  )

(defun excel>tags (/ lst s)
  (setq lst (excel>lst))
  (setq ss (ss->tbl (ssget '((0 . "ATTDEF")))))
  (mapcar '(lambda (d s) (mapcar '(lambda (dd ss) (vla-put-TagString dd ss)) d s)) ss lst)
  )








;;;;;;		EXCEL USED RANGE
;;;
;;;   (setq #excel (vlax-get-object "Excel.Application"))
;;;   (setq #actsht (vlax-get-Property #excel "ActiveSheet"))
;;;   (setq #usedRange (vlax-get-Property #actsht "UsedRange"))
;;;		(setq #usedRows (vlax-get-Property #usedRange "Rows"))
;;;			(setq usedRowsQuantity (vlax-get-Property #usedRows "Count"))
;;;   (setq sa (vlax-get-Property #usedRange "Value"))
;;;   (setq lst (vlax-safearray->list (vlax-variant-value tmp)))
;;;   (setq answer (mapcarx vlax-variant-value nil lst))
;;;   (mapcar 'vlax-release-object (list #usedRange #actsht #excel))
;;;
;;;
;;;(vlax-release-object #excel)
;;;(vlax-release-object #actsht)
;;;(vlax-release-object #selection)
;;;(vlax-release-object #areas)
;;;(vlax-release-object area1)
;;;(vlax-release-object area2)
;;;
;;;
;;;
;;;(setq #excel (vlax-get-object "Excel.Application"))
;;;(setq #actsht (vlax-get-Property #excel "ActiveSheet"))
;;;(setq #selection (vlax-get-Property #excel "Selection"))
;;;(setq #areas (vlax-get-Property #selection "Areas"))








;образует list - табkицу из выделенного в excel диапазона


(defun excel>lst ( /
		  xls|getDataFramed
		  xls|getDataColumnsSelected
		  xls|getDataRowsSelected
		  #excel
		  #selection
		  result)



  
  (defun xls|getDataFramed (selection / sa)
    (setq sa (vl-catch-all-apply 'vlax-get-property (list Selection "Value2")))
    (if (= (type sa) 'variant) (setq sa (vlax-variant-value sa)) (setq sa nil))
    (cond
      ((= 'STR (type sa)) sa)
      ((= 'safearray (type sa)) (mapcar '(lambda (line) (subst "" nil (mapcar 'vlax-variant-value line))) (vlax-safearray->list sa)))
      (T nil)
      )
    )

  
  (defun xls|getDataColumnsSelected (areas / return) ;#selection)
    (setq return
	   (mapcar
	     '(lambda (area)
		(if (> (vlax-get-property area "Count")  usedRowsQuantity)
		  (progn
		    (mapcar
		      '(lambda (col / cells i column)
			 (setq cells (vlax-get-property col "Cells"))
			 (setq i 0) (setq column '())
			 (while (< (setq i (1+ i)) (1+ usedRowsQuantity))
			   (setq column (cons (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property cells "Item" i)) "Value2")) column))
			   )
			 (reverse column)
			 )
		      (cont>list (vlax-get-property area "Columns"))
		      )
		    )
		  )
		)
	     (vl-remove-if '(lambda (area) (< (vlax-get-property area "Count") 2)) (cont>list areas))
	     ))
    (setq return (apply 'append return))
    (apply 'mapcar (cons 'list return))
    );defun




  (defun xls|getDataRowsSelected (areas /  return head rng) ;#selection)
    (setq return
	   (mapcar
	     '(lambda (area)	;(setq area (car (vl-remove-if '(lambda (area) (< (vlax-get-property area "Count") 2)) (cont>list #areas))))
		(if (> (vlax-get-property area "Count")  usedColumnsQuantity)
		  (progn
		    (mapcar
		      '(lambda (col / cells i row)
			 (setq cells (vlax-get-property col "Cells"))
			 (setq i 0) (setq row '())
			 (while (< (setq i (1+ i)) (1+ usedColumnsQuantity))
			   (setq row (cons (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property cells "Item" i)) "Value2")) row))
			   )
			 (reverse row)
			 )
		      (cont>list (vlax-get-property area "Rows"))
		      )
		    )
		  )
		)
	     (vl-remove-if '(lambda (area) (< (vlax-get-property area "Count") 2)) (cont>list areas))
	     ))
    (setq return (apply 'append return))
    ;;;  добавление шапки если нет
    (if (/= "srt" (car (car return)))
      (progn
	(setq rng (vlax-get-property #actsht "Range" (strcat "A1")))
	(setq head (list rng))
	(repeat usedColumnsQuantity
	  (setq head (cons (setq rng (vlax-get-property rng "Next")) head))
	  )
	(setq head (reverse head))
	(setq head (mapcar '(lambda (x) (vlax-variant-value (vlax-get-property x "Text"))) head))
	(setq return (cons head return))
	)
      )
    return
    );defun


  


  
  (setq #excel (vlax-get-object "Excel.Application"))
  (setq #actsht (vlax-get-Property #excel "ActiveSheet"))
  (setq #usedRange (vlax-get-Property #actsht "UsedRange"))
  (setq #usedRows (vlax-get-Property #usedRange "Rows"))
  (setq #usedColumns (vlax-get-Property #usedRange "Columns"))
  (setq usedRowsQuantity (vlax-get-Property #usedRows "Count"))
  (setq usedColumnsQuantity (vlax-get-Property #usedColumns "Count"))
  (setq #selection (vlax-get-Property #excel "Selection"))
  (setq #areas (vlax-get-Property #selection "Areas"))
  
  (cond
    ; если мало колонок и много строк
    ((and
       (< (vlax-get-Property (vlax-get-Property (vlax-get-Property #areas "Item" 1) "Columns") "Count") (expt 2 7))
       (> (vlax-get-Property (vlax-get-Property (vlax-get-Property #areas "Item" 1) "Rows") "Count") (expt 2 11))
       )
     (setq result (xls|getDataColumnsSelected #areas))
     )
    ;  если мало строк и много колонок
    ((and
       (< (vlax-get-Property (vlax-get-Property (vlax-get-Property #areas "Item" 1) "Rows") "Count") (expt 2 11))
       (> (vlax-get-Property (vlax-get-Property (vlax-get-Property #areas "Item" 1) "Columns") "Count") (expt 2 7))
       )
     (setq result (xls|getDataRowsSelected #areas))
     )
    ;  если набор из одной рамки
    ((and
       (= 1 (vlax-get-Property #areas "Count"))
       (< (vlax-get-Property #selection "Count") (expt 2 17))
       )
     (setq result (xls|getDataFramed #selection))
     )
    (T (alert "Unsupported selection") (setq result nil))
    )

  (vlax-release-object #areas)
  (vlax-release-object #selection)
  (vlax-release-object #usedRows)
  (vlax-release-object #usedColumns)
  (vlax-release-object #usedRange)
  (vlax-release-object #actsht)
  (vlax-release-object #excel)
  result
  );defun