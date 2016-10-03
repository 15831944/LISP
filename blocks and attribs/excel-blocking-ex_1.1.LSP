;; 15_05_06																				
;; excel-blocking-ex_1.1.LSP																		
;; 																					
;; Программа позволяет экспортировать в excel и импортировать назад содержимое аттрибутов блоков										

;;;	ЗАПУСК программы производится из командной строки автокада путем ввода букв:											
;;;	blks>excel[enter]																		
;;;	или																				
;;;	excel>blks[enter]																		

;;; Пояснения:																				
;;; blks>excel	- экспортирует данные из аттрибутов выделенных блоков автокада во вновь создаваемое окно excel								
;;; выделить блоки можно как до запуска команды так и после														
;;; (подсказка: выделяя блоки до запуска команды можно использовать фильтры выбора (команда _filter) или									
;;; команду "Select Similar" из всплывающего меню (правый щелчек мыши) на выделенном блоке										
;;; таким образом заранее сформировав нужный набор блоков)														
;;; В итоге, создается файл excel в котором каждому блоку будет соответствовать строка данных с заполненными значениями из аттрибутов					
;;; в шапке таблицы - имена аттрибутов																	
;;; и еще будет 1 столбец (или несколько - если в наборе были разные блоки) с "ручками" представляющими собой уникальный адрес блока в файле чертежа			
;;; по этому адресу можно будет импортировать данные из файла ексель назад в автокад											
;;; 																					
;;; обратный импорт данных:																		
;;; предварительно, в окне excel выделяется нужный диапазон данных - все данные или их часть (главное чтобы в набор попадала шапка таблицы и столбец(ы) с ручками)	
;;; далее идем в автокад и запускаем команду excel>blks															
;;; 																					
;;; можно сохранять файл ексель и производить импорт данных позже, но тут важно понимать - если вы после экспорта скопировали						
;;; целевые блоки и вставили вновь (например для альтернативного решения) а старые удалили, то - хоть внешне этот набор не будет отличаться от				
;;; исходного, но ручки (handles) будут другие, и данные из файла excel не импортируются											

; Авор: Подолинский Евгений Олегович				
; email: lisper@list.ru, podolinsky.e@gmail.com			
; skype: podolinsky.e						
; -kakt00z-™  ©							



(defun c:blks>excel ( / lst>excel origlist blref-to-data selSetToSortedObjList ssget* lst head data)
  (defun ssget* (fltr / ss)
    (if (not (setq ss (ssget "_I" fltr)))
      (setq ss (vl-catch-all-apply 'ssget (list fltr)))
      )
    (cond
      ((= 'VL-CATCH-ALL-APPLY-ERROR (type ss)) (VL-CATCH-ALL-ERROR-MESSAGE ss))
      ((= 'PICKSET (type ss)) ss)
      (T nil)
      )
    );defun

  (defun selSetToSortedObjList (ss / lst rule)	;(setq ss (ssget))
    (setq lst (reverse (ssnamex ss)))
    (while (listp (cadar lst)) (setq lst (cdr lst)))
    (setq lst (mapcar '(lambda (x) (cadr x)) lst))
    (initget 1 "x -x y -y content")
    (setq rule (vl-catch-all-apply 'getkword '("\n Правило сортировки : [x/-x/y/-y/content] <x> \n")))
    (cond
      ((= 'VL-CATCH-ALL-APPLY-ERROR (type rule)) (setq rule nil))
      
      ((= rule "x")(setq rule '(< (cadr (assoc 10 (entget a))) (cadr (assoc 10 (entget b))))))
      ((= rule "y")(setq rule '(< (caddr (assoc 10 (entget a))) (caddr (assoc 10 (entget b))))))
      ((= rule "-x")(setq rule '(> (cadr (assoc 10 (entget a))) (cadr (assoc 10 (entget b))))))
      ((= rule "-y")(setq rule '(> (caddr (assoc 10 (entget a))) (caddr (assoc 10 (entget b))))))
      ((= rule "content")(setq rule '(< (cdr (assoc 1 (entget a))) (cdr (assoc 1 (entget b))))))
      )
    (setq lst (vl-sort lst '(lambda (a b) (eval rule))))
    (mapcar 'vlax-ename->vla-object lst)
    );defun

  (defun blref-to-data (obj / getbattswcmatch)
    (defun getbattswcmatch ( bobj str / al)
      (if
	(and
	  (vlax-method-applicable-p bobj "getattributes")
	  (setq al (vlax-variant-value (vla-getattributes bobj)))
	  (<= 0 (vlax-safearray-get-u-bound al 1))
	  (setq al (vlax-safearray->list al))
	  )
	(vl-remove-if-not '(lambda (x) (wcmatch (vla-get-tagstring x) (strcat str "," (strcase str)))) al)
	)
      );defun
    (if (= "AcDbBlockReference" (vla-get-ObjectName obj))
      (cons
	(list (strcat "[BN]=" (vla-get-EffectiveName obj)) (vla-get-Handle obj))
	(mapcar
	  '(lambda (att / destatt str)
	     (list (vla-get-TagString att) (vla-get-TextString att))
	     )
	  (getbattswcmatch obj "*")
	  )
	)
      )
    );defun
  (defun origlist (lst / ans)
    (mapcar '(lambda (x) (if (null (member x ans)) (setq ans (cons x ans)))) lst)
    (reverse ans)
    );defun

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
    (mapcar (function (lambda (x) (if (not (vlax-object-released-p x)) (vlax-release-object x)))) (list range ash wb wkbs #excel))
    (setq range nil ash nil wb nil wkbs nil #excel nil)
    (prin1)
    );defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  (if
    (and (setq lst (ssget* '((0 . "INSERT")))) (= 'PICKSET (type lst)))
    (progn
      (princ "\n\nPlease do not change a handle column\n")
      (setq lst (selSetToSortedObjList lst))
      ;(mapcar '(lambda (x) (vla-get-textstring (getbatt x "POZ"))) lst)
      (setq data (mapcar 'blref-to-data lst))
      (setq head (origlist (mapcar 'car (apply 'append data))))      
      (setq res (mapcar '(lambda (bobj) (mapcar '(lambda (par / a) (if (setq a (assoc par bobj)) (cadr a)"")) head)) data))
      (lst>excel (cons head res))
      )
    )
  );defun










(defun c:excel>blks ( / sepstr getbatt excel>lst db|formatdata lst head data reprt htn htns bname)
  (defun db|formatdata (lines / rtos* ans)
    (defun rtos* (num / str)
      (if (null num) "" (VL-LIST->STRING (subst 44 46 (VL-STRING->LIST (rtos num)))))
      );defun
    (setq ans (mapcar
		'(lambda (line)
		   (mapcar
		     '(lambda (x)
			(cond
			  ((or (= (type x) 'INT) (= (type x) 'REAL)) (rtos* x))
			  ((= "м?/ч" x) "м\U+00B3/ч")
			  ;;   kappa \U+00E6	63
			  ((= "#" x) "")
			  ((null x) "")
			  (T x)
			  )
			)
		     line
		     )
		   )
		lines
		))
    (setq ans (vl-remove-if '(lambda (x) (apply '= (cons nil x))) ans))
    (setq ans (vl-remove-if '(lambda (x) (apply '= (cons "" x))) ans))
    );defun
  (defun excel>lst ( / cont>list xls|getDataFramed xls|getDataNotFramed #excel #selection isSelectionFramed result)
    (defun cont>list (objc / lst) (vlax-for o objc (setq lst (append lst (list o)))) lst)
    (defun xls|getDataFramed (selection / sa)
    (setq sa (vl-catch-all-apply 'vlax-get-property (list Selection "Value2")))
    (if (= (type sa) 'variant) (setq sa (vlax-variant-value sa)) (setq sa nil))
    (cond ((= 'STR (type sa)) sa) ((= 'safearray (type sa)) (mapcar '(lambda (line) (subst "" nil (mapcar 'vlax-variant-value line))) (vlax-safearray->list sa))) (T nil))
    )
  (defun xls|getDataNotFramed (#excel / #actsht #usedRange #usedRows usedRowsQuantity #areas return) ;#selection)
    ;(setq #selection (vlax-get-Property #excel "Selection"))
    (setq #actsht (vlax-get-Property #excel "ActiveSheet"))
    (setq #usedRange (vlax-get-Property #actsht "UsedRange"))
    (setq #usedRows (vlax-get-Property #usedRange "Rows"))
    (setq usedRowsQuantity (vlax-get-Property #usedRows "Count"))
    (setq #areas (vlax-get-Property #selection "Areas"))
    (setq return
	   (mapcar
	     '(lambda (area)
		(if (> (vlax-get-property area "Count")  usedRowsQuantity)
		  (progn
		    (mapcar
		      '(lambda (col / cells i column)
			 (setq cells (vlax-get-property col "Cells"))
			 (setq i 0) (setq column '())
			 (while (< (setq i (1+ i)) (1+ usedRowsQuantity)) (setq column (cons (vlax-variant-value (vlax-get-property (vlax-variant-value (vlax-get-property cells "Item" i)) "Value2")) column)))
			 (reverse column)
			 )
		      (cont>list (vlax-get-property area "Columns"))
		      )
		    )
		  )
		)
	     (vl-remove-if '(lambda (area) (< (vlax-get-property area "Count") 2)) (cont>list #areas))
	     ))
    (setq return (apply 'append return))
    (vlax-release-object #areas)
    ;(vlax-release-object #selection)
    (vlax-release-object #usedRows)
    (vlax-release-object #usedRange)
    (vlax-release-object #actsht)
    (apply 'mapcar (cons 'list return))
    )
  (setq #excel (vlax-get-object "Excel.Application"))
  (setq #selection (vlax-get-Property #excel "Selection"))
  (if (setq isSelectionFramed (< (vlax-get-Property #selection "Count") (expt 2 20)))
    (setq result (xls|getDataFramed #selection))
    (setq result (xls|getDataNotFramed #excel))
    )
  (vlax-release-object #selection)
  (vlax-release-object #excel)
  result
  );defun
  (defun getbatt (bobj tag / al sc )
    (if
      (and
	(vlax-method-applicable-p bobj "getattributes")
	(setq al (vlax-variant-value (vla-getattributes bobj)))
	(<= 0 (vlax-safearray-get-u-bound al 1))
	(setq al (vlax-safearray->list al))
	)
      (progn
	(setq al (vl-remove-if-not '(lambda (x) (member (vla-get-tagstring x) (list tag (strcase tag)))) al))
	(cond
	  ((= 1 (length al)) (car al))
	  (T nil)
	  )
	)
      )
    );defun
  (defun sepstr (strline delimiter / strhead strtail poz)
    (if (setq poz (vl-string-search delimiter strline))
      (progn (setq strhead (substr strline 1 poz) strtail (substr strline (+ poz 1 (strlen delimiter))))
	(append (list strhead) (sepstr strtail delimiter)))
      (list strline)
      );if
    );defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq #excel>blks:reprt nil)
  (if (and
	(setq lst (db|formatdata (excel>lst)))
	(setq data (cdr lst) head (car lst))
	(setq htns (vl-remove-if-not '(lambda (x) (= "[BN]" (substr x 1 4))) head))
	)
    (progn
      (mapcar
	'(lambda (htn)
      (setq bname (cadr (sepstr htn "=")))
      (mapcar
	'(lambda (line / h bobj)	;(setq line (nth 0 data))
	   (setq h (nth (vl-position htn head) line))
	   (if (/= "" h)
	     (progn
	       (setq bobj (vl-catch-all-apply 'vla-HandleToObject (list #actdoc h)))
	       (cond
	     ((= (type bobj) 'VLA-OBJECT)
	      (mapcar
		'(lambda (tag / att aval val)	;(setq tag "PROP1")
		   (if (setq att (getbatt bobj tag))
		     (progn
		       (setq aval (vla-get-textstring att))
		       (setq val (nth (vl-position tag head) line))
		       (vla-put-TextString att val)
		       (if (/= aval val) (setq #excel>blks:reprt (cons (list h (strcat "TAG '" tag "' changed from '" aval "' to '" val "'")) #excel>blks:reprt)))
		       )
		     )
		   )
		(vl-remove htn head)
		)
	      )
	     ((= (type bobj) 'VL-CATCH-ALL-APPLY-ERROR) (setq #excel>blks:reprt (cons (list h (VL-CATCH-ALL-ERROR-MESSAGE bobj)) #excel>blks:reprt)))
	     );cond
	       )
	     )
	   )
	data
	)
	   )
	htns
	)
      )
    (alert "в выделенном диапазоне в Excel не найден столбец с handle'ами")
    )
  (princ "\n\n inspect #excel>blks:reprt to see report")
  (princ)
  );defun

(vl-load-com) (setq #cad (vlax-get-acad-object) #actdoc (vla-get-activedocument #cad) #modspace (vla-get-modelspace #actdoc))
(princ (strcat "\n\n"
	 "	Type in the command line:\n"
	 "	blks>excel - (on selected block inserts / or select them later) to export data to excel sheet\n"
	 "	excel>blks - to import data back to the blocks from excel (selecting beforehand a range you want to import including table-head)\n"
	 ))







