(defun getbatt (
		 bobj
		 tag
		 /
		 al
		 )
  (if
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (< 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al))
      )
    (car (vl-remove-if-not '(lambda (x) (= tag (vla-get-tagstring x))) al))
    )
  );defun

;(getbatt (vlax-ename->vla-object (car (entsel))) "CHAN3")

;;; фильруем ss через 1
;;;=======================================================================================
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
;;;=======================================================================================




;;; составляем матрицу данных
(defun cols-to-array (nkol
		      /
		      main
		      i
		      )
  (setq main '()
	i 1)
  (repeat nkol
    (alert (strcat "указываем столбец N " (itoa i)))
    (setq main (append main (list (mapcar '(lambda (x) (cdr (assoc 1 (entget x)))) (ss->list (ssget))))))
    (princ (strcat "\n !!!!!!!!!!!!!!!!!!!!!!!!!     выбрано " (itoa (length (reverse (car main)))) " объектов   !!!!!!!!!!!!!!!\n"))
    (setq i (1+ i))
    )
  (matrix-trans main)
  );defun
;;; то же только с объектами
(defun objs-to-array (nkol
		      /
		      main
		      )
  (setq main '())
  (repeat nkol
    (alert "указываем столбец объектов")
    (setq main (append main (list  (mapcar 'vlax-ename->vla-object (ss->list (ssget))))))
    (princ "\n !!!!!!!!!!!!!!!!!!!!!!!!!     закончили выбор           !!!!!!!!!!!!!!!\n")
    )
  (matrix-trans main)
  );defun

;;; превращаем список выборок из столбцов в ассоциативные строки - матрицу
(defun matrix-trans (lst
		     /
		     i
		     lsto
		     )
  (setq lsto '()
	i 0)
  (repeat (length (car lst))
    (setq lsto (append lsto (list (mapcar '(lambda (x) (nth i x)) lst))))
    (setq i (1+ i))
    );repeat
  lsto
  );defun
;;; есть список ((1 а) (1 б) (1 с) (2 в) (2 е) (3 р))
;;; прога делает следующий
;;; ((1 а б с) (2 в е) (3 р))
;bpfill
(load (strcat #lisppath "DATA-Tables/ziplist.lsp"))


;entsel 1 текст (номер кабеля) -> ssget тексты с марками до тех пор пока етнсел
(defun associng (
		 /
		 obj
		 ss
		 lst
		 )
  (while (setq obj (entsel "\nSelect assoc object..."))
    (setq obj (vlax-ename->vla-object (car obj)))
    (setq ss (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "*TEXT"))))))
    (setq lst (append lst (list (append (list obj) ss))))
    )
  lst
  );defun


(setq lst (associng))
(mapcar 'vla-get-TextString lst)

(defun mapcarx (func
		arg
		lst
		/
		)
  (if (= 'list (type lst))
    (mapcar '(lambda (x) (mapcarx func arg x)) lst)
    (if arg
      (func lst arg)
      (func lst)
      )
    );if
  );defun
(mapcarx vla-get-TextString nil lst)

;;;
;;;
;;;(defun map (func arg lst)
;;;  (mapcar
;;;    '(lambda (x)
;;;       (mapcar
;;;	 '(lambda (y)
;;;	    (if arg
;;;	      (func y arg)
;;;	      (func y)
;;;	      )
;;;	    )
;;;	 x
;;;	 )
;;;       )
;;;    lst
;;;    )
;;;  );defun
;;;
;;;(setq cab (map vla-get-TextString  nil (associng)))
;;;    
;;;
;;;









;;;(setq bpfill (cols-to-array 2))
;;;(setq bpfill (ziplist bpfill))
;;;(setq bpfill '(("UG18" "Стенд 3N-СД № 1" "Стенд 3N-СД № 17" "Стенд 3N-СД № 17") ("UG20" "Стенд 3N-СД № 1" "Стенд 3N-СД № 20" "Стенд 3N-СД № 20") ("UG35" "Стенд 3N-СД № 1" "Стенд 3N-СД № 25") ("UG1" "Стенд 3N-СД № 3" "Стенд 3N-СД № 3") ("UG2" "Стенд 3N-СД № 4" "Стенд 3N-СД № 4") ("UG30" "Стенд 3N-СД № 5" "Стенд 3N-СД № 8" "Стенд 3N-СД № 10" "Стенд 3N-СД № 22") ("UG36" "Стенд 3N-СД № 5" "Стенд 3N-СД № 8" "Стенд 3N-СД № 25") ("UG37" "Стенд 3N-СД № 5" "Стенд 3N-СД № 8" "Стенд 3N-СД № 25") ("UG38" "Стенд 3N-СД № 5" "Стенд 3N-СД № 8" "Стенд 3N-СД № 25") ("UG3" "Стенд 3N-СД № 6" "Стенд 3N-СД № 6" "Стенд 3N-СД № 6") ("UG4" "Стенд 3N-СД № 7" "Стенд 3N-СД № 7" "Стенд 3N-СД № 7") ("UG5" "Стенд 3N-СД № 8" "Стенд 3N-СД № 9" "Стенд 3N-СД № 10") ("UG24" "Стенд 3N-СД № 8" "Стенд 3N-СД № 22" "Стенд 3N-СД № 22") ("UG6" "Стенд 3N-СД № 10" "Стенд 3N-СД № 10" "Стенд 3N-СД № 10") ("UG8" "Стенд 3N-СД № 10" "Стенд 3N-СД № 10" "Стенд 3N-СД № 10") ("UG7" "Стенд 3N-СД № 11" "Стенд 3N-СД № 11" "Стенд 3N-СД № 11") ("UG9" "Стенд 3N-СД № 11" "Стенд 3N-СД № 11" "Стенд 3N-СД № 11") ("UG12" "Стенд 3N-СД № 12" "Стенд 3N-СД № 12" "Стенд 3N-СД № 12") ("UG13" "Стенд 3N-СД № 12" "Стенд 3N-СД № 12" "Стенд 3N-СД № 12") ("UG15" "Стенд 3N-СД № 13" "Стенд 3N-СД № 14") ("UG22" "Стенд 3N-СД № 13" "Стенд 3N-СД № 14") ("UG31" "Стенд 3N-СД № 13" "Стенд 3N-СД № 14" "Стенд 3N-СД № 23" "Стенд 3N-СД № 24") ("UG32" "Стенд 3N-СД № 13" "Стенд 3N-СД № 13" "Стенд 3N-СД № 14") ("UG11" "Стенд 3N-СД № 14" "Стенд 3N-СД № 14" "Стенд 3N-СД № 16" "Стенд 3N-СД № 16") ("UG14" "Стенд 3N-СД № 14" "Стенд 3N-СД № 15") ("UG21" "Стенд 3N-СД № 15" "Стенд 3N-СД № 15") ("UG34" "Стенд 3N-СД № 15" "Стенд 3N-СД № 15") ("UG10" "Стенд 3N-СД № 16" "Стенд 3N-СД № 16" "Стенд 3N-СД № 16" "Стенд 3N-СД № 16") ("UG16" "Стенд 3N-СД № 16" "Стенд 3N-СД № 16") ("UG17" "Стенд 3N-СД № 16" "Стенд 3N-СД № 16" "Стенд 3N-СД № 16" "Стенд 3N-СД № 16") ("UG19" "Стенд 3N-СД № 18" "Стенд 3N-СД № 19") ("UG29" "Стенд 3N-СД № 18" "Стенд 3N-СД № 19") ("UG33" "Стенд 3N-СД № 20" "Стенд 3N-СД № 20") ("UG23" "Стенд 3N-СД № 21" "Стенд 3N-СД № 21" "Стенд 3N-СД № 21" "Стенд 3N-СД № 21")))
;;;(setq bpfill (vl-sort bpfill '(lambda (a b) (< (car a) (car b)))))






;;;(setq ovtabledata (cols-to-array 2))
;;;(setq data (cols-to-array 5))	;; poz, ename, rname
;;;
;;;;;; список с одними данными
;;;(setq langdata (cols-to-array 5))	;; poz, ename, rname
;;;
;;;;;; список с другими данными, но пересекающийся с первым позициями
;;;(setq clampdata (cols-to-array 2))	;; nkl, poz
;;;
;;;;;;(setq lst '((1 2 3)("A" "B" "C")))
;;;;;; формируем единую общую матрицу из двух списков (делаем совокупность двух матриц)
;;;(setq main '())
;;;(foreach line clampdata
;;;  (setq main (append main (list
;;;			    (append line (cdr (assoc (cadr line) langdata)))
;;;			    )))
;;;  )
;;;
;;;;;; сортируем по первому элементу строк
;;;(setq main
;;;       (vl-sort main '(lambda (a b)
;;;			(< (car a)
;;;			   (car b))))
;;;      )
;;;
;;;
;;;
;;;
;;;;(setq bl (vlax-ename->vla-object (car (entsel))))
;;;
;;;;;; получаем объект аттрибут блока по тэгу
;;;(defun get-att (block
;;;		tag
;;;		/
;;;		aol
;;;		)
;;;  (setq aol (vlax-safearray->list (vlax-variant-value (vla-getAttributes block))))
;;;  (nth
;;;    (vl-position tag (mapcar 'vla-get-TagString aol))
;;;    aol)
;;;  );defun
;;;
;;;;;;(vlax-dump-Object
;;;;;;(get-att
;;;;;;  (vlax-ename->vla-object (car (entsel)))
;;;;;;  "NKL"
;;;;;;  ))
;;;
;;;
;;;
;;;
;;; заполняем набор блоков
;; че за блок был? :(
;;;(defun fill (
;;;	     /
;;;	     blks
;;;	     i
;;;	     )
;;;  (setq blks (mapcar 'vlax-ename->vla-object (ss->list (ssget)))
;;;	i 0)
;;;  (foreach bl blks
;;;    (vla-put-TextString (get-att bl "NKL") (nth 0 (nth i main)))
;;;    (vla-put-TextString (get-att bl "POZ") (nth 1 (nth i main)))
;;;    (vla-put-TextString (get-att bl "ENAME") (nth 2 (nth i main)))
;;;    (vla-put-TextString (get-att bl "RNAME") (nth 3 (nth i main)))
;;;    (setq i (1+ i))
;;;    )
;;;  );defun





;;;(setq cabdata (cols-to-array 4))
;;;
;;;
;;;;;; превращаем матрицу
;;;'(("cab58type" "1X01" "1X02" "dest63")
;;;  ("cab59type" "1X03" "1X04" "dest62")
;;;  ("cab60type" "1X05" "1X06" "dest61")
;;;  ("cab61type" "1X07" "1X08" "dest60")
;;;  )
;;;;;; в такоую
;;;'(("cab58type" ("1X01" "1X02" "dest63"))
;;;  ("cab59type" ("1X03" "1X04" "dest62"))
;;;  ("cab60type" ("1X05" "1X06" "dest61"))
;;;  ("cab61type" ("1X07" "1X08" "dest60"))
;;;  )
;;;;;; для этого пишем (compress-matrix lst 2 4)
;;;(defun compress-matrix (lst
;;;			strt
;;;			end
;;;			/
;;;			out
;;;			)
;;;  (setq out '())
;;;  (foreach line lst
;;;    
;;;
;;;
;;;
;;;
;;;
;;;
;;;    (setq i 0)
;;;    (repeat)
;;;    )
;;;  );defun
;;;
;;;
;;;
;;;("cab58type" "1X01" "1X02" "dest63")
;;;("cab58type" ("1X01" "1X02" "dest63"))
;;;
;;;(setq lst '("cab58type" "1X01" "1X02" "dest63"))
;;;
;;;(defun cline (line a b
;;;	      /
;;;	      out
;;;	      )
;;;  (setq out '())
;;;  );defun




;;;(setq ao (vlax-ename->vla-object (car (nentsel))))
;;;
;;;(vlax-dump-object (vlax-ename->vla-object (car (nentsel))))
;;;


;   LineSpacingDistance = 4.16667
;   LineSpacingFactor = 1.0
;   LineSpacingStyle = 1
;   LineSpacingDistance = 2.0
;   LineSpacingFactor = 0.48
;   LineSpacingStyle = 2


;;;(setq ss (ssget))
;;;(setq i 0)
;;;
;;;(repeat (sslength ss)
;;;    (setq o (get-att (vlax-ename->vla-object (ssname ss i)) "ENAME"))
;;;    (vla-put-LineSpacingFactor o 0.6)
;;;    (setq o (get-att (vlax-ename->vla-object (ssname ss i)) "RNAME"))
;;;    (vla-put-LineSpacingFactor o 0.6)
;;;    (setq i (1+ i))
;;;    )






;;;(setq langdata (cols-to-array 3))	;; poz, eaddr, raddr
;;;(setq kabdata (cols-to-array 3))	;; poz, num, type
;;;(setq kl-poz (cols-to-array 2))		;; nkl, poz
;;;
;;;
;;;(setq main '())				;nkl, num, type, eaddr, raddr
;;;(foreach line kl-poz
;;;  (setq main (append main (list
;;;                              (list
;;;                              (car line)
;;;                              (cadr (assoc (cadr line) kabdata))
;;;                              (caddr (assoc (cadr line) kabdata))
;;;                              (cadr (assoc (cadr line) langdata))
;;;                              (caddr (assoc (cadr line) langdata))
;;;                              )
;;;                              )))
;;;    )

;;; сортируем по первому элементу строк
;;;(setq main
;;;       (vl-sort main '(lambda (a b)
;;;			(< (car a)
;;;			   (car b))))
;;;      )
;;;



;;;    main   -    nkl, num, type, eaddr, raddr
;;;(defun fillcab(
;;;	     /
;;;	     blks
;;;	     i
;;;	     )
;;;  (setq blks (mapcar 'vlax-ename->vla-object (ss->list (ssget)))
;;;	i 0)
;;;  (foreach bl blks
;;;    (vla-put-TextString (get-att bl "NUM") (nth 1 (nth i main)))
;;;    (vla-put-TextString (get-att bl "TYPE") (nth 2 (nth i main)))
;;;    (vla-put-TextString (get-att bl "EADDR") (nth 3 (nth i main)))
;;;    (vla-put-TextString (get-att bl "RADDR") (nth 4 (nth i main)))
;;;    (setq i (1+ i))
;;;    )
;;;  );defun



;;; массово уменьшаем степень сжатия МТекстов
(defun mtxtsetwidth (/)
  (setq ss (ssget '((0 . "MTEXT"))))
  (setq lomt (ss->list* ss))
  (setq lomt (mapcar 'vlax-ename->vla-object lomt))

  (foreach to lomt
    (setq txt (vla-get-TextString to))
    (setq txt (strcat "{\\W0.8;\\T0.9;" txt "}"))
    (vla-put-TextString to txt)
    (vla-put-LineSpacingFactor to 0.7)
  )
)
;;;****************************************************************************************************************
; если есть список вида (("новая позиция" "старая позиция" ...)...)
; то прога меняет в блоке тот же аттрибут со старого на новое
;;;(setq chs (cols-to-array 2))	;; newpoz, oldpoz
;;;(defun fill-fsel(
;;;                 /
;;;                 blks
;;;                 att
;;;                 )
;;;  (setq blks (mapcar 'vlax-ename->vla-object (ss->list* (ssget '((0 . "INSERT"))))))
;;;    (foreach bl blks
;;;        (setq att (get-att bl "ПОЗИЦИЯ"))
;;;        (vla-put-TextString att (cadr (assoc (vla-get-TextString att) chs)))
;;;        )
;;;  );defun

;;;****************************************************************************************************************
; то же самое с текстами
;;;(defun fill-tsel(
;;;                 /
;;;                 txts
;;;		 tag
;;;                 at
;;;                 )
;;;  (setq txts (mapcar 'vlax-ename->vla-object (ss->list (ssget))))
;;;    (foreach txt txts
;;;      (setq tag (vla-get-TextString txt))
;;;      (if (setq at (assoc tag bpfill))
;;;	(vla-put-TextString txt (cadr at))
;;;	)
;;;      )
;;;  );defun

;;;(assoc (vla-get-TextString (vlax-ename->vla-object (car (entsel)))) bpfill)
;;;
;;;(ziplist (cols-to-array 2))















;11_06_04
;;;(setq data '(("UG1" "3NP169" "резерв" "3NP175" "3NP176") ("UG2" "3NP181" "3NP205" "резерв" "резерв") ("UG3" "3NP193" "3NP194" "3NP195" "резерв") ("UG4" "3NP196" "3NP197" "3NP198" "резерв") ("UG5" "3NP213" "3NP214" "3NP233" "резерв") ("UG6" "3NP221" "3NP222" "3NP223" "резерв") ("UG7" "3NP224" "3NP225" "3NP226" "резерв") ("UG8" "3NP234" "3NP235" "3NP236" "резерв") ("UG9" "3NP237" "3NP238" "3NP239" "резерв") ("UG10" "3NP246" "3NP247" "3NP248" "3NP249") ("UG11" "3NP250" "3NP251" "3NP268" "3NP269") ("UG12" "3NP258" "3NP259" "3NP260" "резерв") ("UG13" "3NP261" "3NP262" "3NP263" "резерв") ("UG14" "3NP264" "3NP265" "резерв" "резерв") ("UG15" "3NP270" "3NP271" "резерв" "резерв") ("UG16" "3NP272" "3NP273" "резерв" "резерв") ("UG17" "3NP274" "3NP275" "3NP276" "3NP277") ("UG18" "3NP278" "3NP318" "3NP170" "резерв") ("UG19" "3NF280" "3NF281" "резерв" "резерв") ("UG20" "3NF282" "3NF283" "3NF279" "резерв") ("UG21" "3NF293" "3NF294" "резерв" "резерв") ("UG22" "3NF295" "3NF296" "резерв" "резерв") ("UG23" "3NF284" "3NF285" "3NF286" "3NF287") ("UG24" "3NF288" "3NF289" "3NF290" "резерв") ("UG25" "резерв" "3NF201.4" "3NF201.5" "резерв") ("UG26" "3NF208.4" "3NP209.4" "3NF210.4" "3NP215.4") ("UG27" "3NF211.4" "3NP212.4" "3NF236.4" "3NF237.4") ("UG28" "3NF216.4" "3NF217.4" "3NF236.6" "3NF237.6") ("UG29" "3NF213.4" "3NF214.4" "резерв" "резерв") ("UG30" "3NF218.4" "3NF219.4" "резерв" "резерв") ("UG31" "3NF201.6" "3NF201.8" "резерв" "резерв") ("UG32" "3NP216" "3NP183" "3NL300" "резерв") ("UG33" "3NP217" "3NP184" "3NL301" "резерв") ("UG34" "3NP218" "3NP185" "3NL302" "резерв")))


;(vlax-dump-Object (cadr




; есть блоки монтаж_Метран-604 с аттрибутами
; ID, CHAN1, CHAN2, CHAN3, CHAN4
; и список DATA вида (("UG1" "poz1" "poz2" "poz3" "резерв")...)
; заполняем
(put-data-into-blocks (cols-to-array 5))
(defun put-data-into-blocks (data
			     /
			     sl
			     i
			     obj
			     attl
			     taglist
			     localdata
			     j
			     )
  (setq i 0)
  (setq sl (ss->list* (ssget '((0 . "INSERT")))))
  (foreach bl sl
    (setq obj (vlax-ename->vla-object (nth i sl)))
    ;(setq obj (vlax-ename->vla-object (car (entsel))))
    ;(setq attl (vlax-safearray->list (vlax-variant-value (vla-GetAttributes obj))))
    (setq localdata (cdr (assoc (vla-get-TextString (get-att obj "ID")) data)))
    (if localdata
      (progn
	(setq attl (list
		     (get-att obj "CHAN1")
		     (get-att obj "CHAN2")
		     (get-att obj "CHAN3")
		     (get-att obj "CHAN4")
		     ))
	(mapcar 'vla-put-TextString attl localdata)
	)
	);if
    (setq i (1+ i))
    )
);defun



;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;; общий вид ... расположение блоков питания и рамок под ним
;;; берем аттрибут из блоков питания и засовываем его в аттрибут
;;; рамки надписи
(defun get-and-put (
		    /
		    ss1
		    i
		    obj
		    lst1
		    )
  (setq ss1 (ssget '((0 . "INSERT"))))
  (setq i 0
	lst1 '())
  (repeat (sslength ss1)
    (setq obj (vlax-ename->vla-object (ssname ss1 i)))
    (if (= "ОВ_Метран-604" (vla-get-EffectiveName obj))
      (setq lst1 (append lst1 (list obj)))
      )
    (setq i (1+ i))
    );repeat
  (setq	lst1 (vl-sort lst1 '(lambda (a b)
				(> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq	lst1 (vl-sort lst1 '(lambda (a b)
				(> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq lst1 (mapcar '(lambda (x)
			(vla-get-TextString (get-att x "ID"))
			)lst1))


  (setq ss2 (ssget '((0 . "INSERT"))))
  (setq i 0
	lst2 '())
  (repeat (sslength ss2)
    (setq obj (vlax-ename->vla-object (ssname ss2 i)))
    (if (= "ОВ_табличка" (vla-get-EffectiveName obj))
      (setq lst2 (append lst2 (list obj)))
      )
    (setq i (1+ i))
    );repeat
  (setq	lst2 (vl-sort lst2 '(lambda (a b)
				(> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq	lst2 (vl-sort lst2 '(lambda (a b)
				(> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq lst2 (mapcar '(lambda (x)
			(get-att x "ПОЗИЦИЯ")
			)lst2))
  (mapcar 'vla-put-TextString lst2 lst1)
  );defun
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************
;;;****************************************************************************************************************

;;; с текстов в блок
(defun get-and-put (
		    /
		    ss1
		    i
		    obj
		    lst1
		    )
  (setq ss1 (ssget '((0 . "*TEXT"))))
  (setq i 0
	lst1 '())
  (repeat (sslength ss1)
    (setq obj (vlax-ename->vla-object (ssname ss1 i)))
    (setq lst1 (append lst1 (list obj)))
    (setq i (1+ i))
    );repeat
  (setq	lst1 (vl-sort lst1 '(lambda (a b)
				(> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq	lst1 (vl-sort lst1 '(lambda (a b)
				(> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq lst1 (mapcar '(lambda (x)
			(vla-get-TextString x)
			)lst1))


  (setq ss2 (ssget '((0 . "INSERT"))))
  (setq i 0
	lst2 '())
  (repeat (sslength ss2)
    (setq obj (vlax-ename->vla-object (ssname ss2 i)))
    (if (= "монтаж_Метран-604" (vla-get-EffectiveName obj))
      (setq lst2 (append lst2 (list obj)))
      )
    (setq i (1+ i))
    );repeat
  (setq	lst2 (vl-sort lst2 '(lambda (a b)
				(> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq	lst2 (vl-sort lst2 '(lambda (a b)
				(> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
				   (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))))))
  (setq lst2 (mapcar '(lambda (x)
			(get-att x "ID")
			)lst2))
  (mapcar 'vla-put-TextString lst2 lst1)
  );defun




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; есть список сигналов - распределения по блоками питания
;(setq chlst (ziplist (cols-to-array 2)))\

; если блок 4-хканальный - то дополняем резервами

;;;(setq chlstformontazhmetran
;;;(mapcar '(lambda (x)
;;;	   (if (< (length x) 5)
;;;	     (while (< (length x) 5)
;;;	       (setq x (append x (list "резерв")))
;;;	       )
;;;	      x
;;;	     )
;;;	   ) chlst)
;;;      )