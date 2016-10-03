;;Опубликовано Keith
;; http://www.theswamp.org/index.php?topic=506.0
;;упоминалась http://dwg.ru/f/showthread.php?t=14319
;------------------------------------------------------------
; Команда: LTEXTRACT
; Эта команда позволяет экспортировать описание
; типов линий из чертежей (*.dwg) в файл описания типов линий (*.lin)
; Код можно сохранить в файле ltextract.lsp
; Возможный макрос для кнопки или пункта меню:
; ^C^C(if (not C:LTEXTRACT)(load "LTEXTRACT"));LTEXTRACT
;------------------------------------------------------------

;;; ----------- LTExtract - Version 1.0 -----------
;;; Copyright (C) 2002 by BCI Computer Solutions
;;; Author: K.E. Blackie
;;; 
;;; 
;;; BCI COMPUTER SOLUTIONS PROVIDES THIS PROGRAM "AS IS" AND WITH
;;; ALL FAULTS. BCI COMPUTER SOLUTIONS SPECIFICALLY DISCLAIMS ANY
;;; IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR
;;; USE. BCI COMPUTER SOLUTIONS DOES NOT WARRANT THAT THE OPERATION
;;; OF THE PROGRAM WILL BE UNINTERRUPTED OR ERROR FREE.
;;; 
;;; If you need to contact BCI Computer Solutions concerning this
;;; program you may do so by mail at the following address:
;;; 
;;; BCI Computer Solutions
;;; 2031 SW Fallon Lane
;;; Lake City, FL 32025 
;;; Attn: Software Development
;;; or
;;; email lisper@bcinc.hypermart.net
;;; 
;;; DESCRIPTION
;;; LTExtract will extract all of the linetypes defined in a drawing to a seperate
;;; linetype definition file, including complex linetypes using text and shape
;;; modifiers.
;;;
;;;
;;; ------------------------------------------------------------

(Defun c:ltextract
       (/ ltlist ltfile fn ltname wval ltdef def old_DIMZIN)
  (setq old_DIMZIN (getvar "DIMZIN"))
  (setvar "DIMZIN" 8)
  (setq ltlist (tblnext "LTYPE" t))
  (if ltlist
    (setq ltlist (entget (tblobjname "LTYPE" (cdr (assoc 2 ltlist)))))
  )
  (setq ltfile (getvar "dwgname"))
  (if (= (strcase (substr ltfile (- (strlen ltfile) 3) 4))
	 (strcase ".dwg")
      )
    (setq
      ltfile (strcat (substr ltfile 1 (- (strlen ltfile) 4)) ".lin")
    )
    (setq ltfile (strcat ltfile ".lin"))
  )
  (setq ltfile (getfiled "Save Linetype Definition As" ltfile "lin" 9))
  (if ltfile
    (progn
      (setq fn (open ltfile "w"))
      (while ltlist
	(setq ltname (strcat "*" (strcase (cdr (assoc 2 ltlist))))
	      ltdesc (cdr (assoc 3 ltlist))
	)
	(setq ltdef "A"
	      wval nil
	)
	(setq ltlist (member (assoc 49 ltlist) ltlist))
	(while (assoc 49 ltlist)
	  (setq def (cdr (assoc 49 ltlist)))
	  (setq def (strcat "," (rtos def 2 8)))
	  (setq ltdef (strcat ltdef def))
	  (setq ltlist (cdr (member (assoc 49 ltlist) ltlist)))
	  (setq wval (get74 ltlist))
	  (if wval
	    (setq ltdef (strcat ltdef wval))
	  )
;;;-------------старый код<начало>-------------
;;;	 (setq wval (get74 ltlist))
;;;	 (setq def (cdr (assoc 49 ltlist)))
;;;	 (setq def (strcat "," (rtos def 2 8)))
;;;	 (if wval
;;;	 (setq ltdef (strcat ltdef wval def))
;;;	 (setq ltdef (strcat ltdef def))
;;;	 )
;;;	 (if (> (length ltlist) 1)
;;;	 (setq ltlist (cdr (member (assoc 49 ltlist) ltlist)))
;;;	 (setq ltlist (list nil))
;;;	 )
;;;-------------старый код<конец>-------------
	)
	(setq ltlist (tblnext "LTYPE"))
	(if ltlist
	  (progn
	    (setq ltlist
		   (entget (tblobjname "LTYPE" (cdr (assoc 2 ltlist)))
		   )
	    )
	  )
	)
	(if (/= ltdef "A")
	  (progn
	    (write-line (strcat ltname "," ltdesc) fn)
	    (write-line ltdef fn)
	  )
	)
      )
      (close fn)
    )
  )
  (setvar "DIMZIN" old_DIMZIN)
  (princ)
)



(defun get74 (wlist / ass74 rval)
  (setq ass74 (cdr (assoc 74 wlist)))
  (cond
    ((= ass74 0) (return nil nil nil nil))
    ((= ass74 1)
     (return (cdr (assoc 2 (entget (cdr (assoc 340 wlist)))))
	     nil
	     "A"
	     nil
     )
    )
    ((= ass74 2)
     (return (cdr (assoc 2 (entget (cdr (assoc 340 wlist)))))
	     (cdr (assoc 9 wlist))
	     "R"
	     nil
     )
    )
    ((= ass74 3)
     (return (cdr (assoc 2 (entget (cdr (assoc 340 wlist)))))
	     (cdr (assoc 9 wlist))
	     "A"
	     nil
     )
    )
    ((= ass74 4)
     (return (cdr (assoc 3 (entget (cdr (assoc 340 wlist)))))
	     nil
	     "R"
	     (cdr (assoc 75 wlist))
     )
    )
    ((= ass74 5)
     (return (cdr (assoc 3 (entget (cdr (assoc 340 wlist)))))
	     nil
	     "A"
	     (cdr (assoc 75 wlist))
     )
    )
    (T (return nil nil nil nil))
  )
  rval
)


(defun return (shx text rot shp / ttext test)
  (setq test (cdr (assoc 50 wlist)))
  (if (and test rot)
    (setq rot (strcat rot "=" (angtos test)))
  )
  (setq test (cdr (assoc 46 wlist)))
  (if (and test rot)
    (setq rot (strcat rot ",S=" (rtos test 2 8)))
  )
  (setq test (cdr (assoc 44 wlist)))
  (if (and test rot)
    (setq rot (strcat rot ",X=" (rtos test 2 8)))
  )
  (setq test (cdr (assoc 45 wlist)))
  (if (and test rot)
    (setq rot (strcat rot ",Y=" (rtos test 2 8)))
  )
  (if text
    (setq ttext (strcat ",[\"" text "\"," shx "," rot "]"))
  )
  (if (and (not text) shp)
    (setq ttext (strcat ",[" (getname shp shx) "," shx "," rot "]"))
  )
  (setq rval ttext)
)


(defun getname (shape shapefile	/ sfn lownum charcount shpcount
		zerocount this name char1
	       )
  (if (setq sfn (open (findfile shapefile) "r"))
    (progn
      (repeat 23
	(read-char sfn)
      )
      (setq lownum (read-char sfn))
      (read-char sfn)
      (setq charcount (- shape lownum))
      (setq hignum (read-char sfn))
      (read-char sfn)
      (setq shpcount (read-char sfn))
      (read-char sfn)
      (repeat (* shpcount 4)
	(read-char sfn)
      )
      (setq zerocount 0)
      (while (< zerocount (* charcount 2))
	(setq this (read-char sfn))
	(if (= this 0)
	  (setq zerocount (1+ zerocount))
	)
      )
      (setq char1 (read-char sfn))
      (setq name "")
      (while (/= 0 char1)
	(setq name (strcat name (chr char1)))
	(setq char1 (read-char sfn))
      )
      (close sfn)
      name
    )
  )
)
;(princ)