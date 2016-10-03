;;; изменена 10_04_26
;;; прога загоняет в реест для PDFfactory наши форматы типа v-A4x5 w-A3x2
;;; использована при разработке щита БП №4 Береза
;;; -kakt00z-™  ©


(vl-load-com)
(setq formatsfile (strcat (getenv "temp") "\\formats.txt")
      hand	  (open formatsfile "w")
      ) ;_ setq

(foreach item
	      '(
		"w-A4 297 210"
		"w-A4x3 630 297"
		"w-A4x4 841 297"
		"w-A4x5 1051 297"
		"w-A4x6 1261 297"
		"w-A4x7 1471 297"
		"w-A4x8 1682 297"
		"w-A4x9 1892 297"
		
		"w-A3 420 297"
		"w-A3x3 891 420"
		"w-A3x4 1189 420"
		"w-A3x5 1486 420"
		"w-A3x6 1783 420"
		"w-A3x7 2080 420"
		
		"w-A2 594 420"
		"w-A2x3 1261 594"
		"w-A2x4 1682 594"
		"w-A2x5 2102 594"
		
		"w-A1 841 594"
		"w-A1x3 1783 841"
		"w-A1x4 2378 841"
		
		"w-A0 1189 841"
		"w-A0x2 1682 1189"
		"w-A0x3 2523 1189"
		
		"v-A4 210 297"
		"v-A4x3 297 630"
		"v-A4x4 297 841"
		"v-A4x5 297 1051"
		"v-A4x6 297 1261"
		"v-A4x7 297 1471"
		"v-A4x8 297 1682"
		"v-A4x9 297 1892"
		
		"v-A3 297 420"
		"v-A3x3 420 891"
		"v-A3x4 420 1189"
		"v-A3x5 420 1486"
		"v-A3x6 420 1783"
		"v-A3x7 420 2080"
		
		"v-A2 420 596"
		"v-A2x3 596 1261"
		"v-A2x4 596 1682"
		"v-A2x5 596 2102"
		
		"v-A1 596 841"
		"v-A1x3 841 1783"
		"v-A1x4 841 2378"
		
		"v-A0 841 1189"
		"v-A0x2 1189 1682"
		"v-A0x3 1189 2523"
		)

  (write-line item hand)
  ) ;foreach
(close hand)

(defun format-reg-add (/ file ch path fname format lfile word flist i)


 ;(setq   file (open "D:\\LISP WORKIG\\Архив\\Форматы\\formats.txt" "r"))
  (if (not
	(setq file (open (strcat (getenv "temp") "\\formats.txt") "r"))
	) ;_ not
    (exit)
    ) ;if



  (while (setq ch (read-char file))
    (if	(or (> ch 44)
	    (null ch)
	    ) ;_ or
 ;не пробел
      (setq word (append word (list ch)))
 ;пробел
      (setq lfile (append lfile (list (vl-list->string word)))
	    word  nil
	    ) ;_ setq
      ) ;if
    ) ;while
  (close file)
  (setq	lfile (append lfile (list (vl-list->string word)))
	word  nil
	) ;_ setq

  (setq i 0)
  (repeat (/ (length lfile) 3)
    (setq flist	(append	flist
			(list (list
				(nth (* i 3) lfile)
				(list
				  (atoi (nth (+ (* i 3) 1) lfile))
				  (atoi (nth (+ (* i 3) 2) lfile))
				  ) ;_ list
				) ;_ list
			      ) ;_ list
			) ;_ append
	  ) ;_ setq
    (setq i (1+ i))
    ) ;_ repeat

  (setq	path
	 "HKEY_CURRENT_USER\\Software\\FinePrint Software\\pdfFactory4\\CustomPapers\\"
	) ;_ конец setq

  (foreach item	flist
    (vl-registry-write (setq fname (strcat path (car item))))
    (vl-registry-write fname "Width" (* (caadr item) 1000))
    (vl-registry-write fname "Height" (* (cadadr item) 1000))
    (vl-registry-write fname "Units" 2)
    ) ;_ foreach

  (alert
    "\nНовые форматы появятся\nпосле перезапуска автокада"
    ) ;_ alert

  ) ;_ конец defun

(format-reg-add)