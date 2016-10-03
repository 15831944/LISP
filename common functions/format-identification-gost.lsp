;;; изменен 11_12_14
;;; набор функций для идентификации формата чертежа
;;; в случаях когда "разбито все"
;;; -kakt00z-™  ©
;;; список функций

;;; get-rightformatline<-koluch
;;; get-formatpts<-rightformatline
;;; ktz-show-error
;;; get-first-on-errors-layer 
;;; get-ftxte<-formatpts
;;; format-detect
;;; get-lnumber
;;; get-uznumber
;;; get-sheetname	(en)	(<sheet name string>)
;;; get-kol-uch		()	(<list of "Кол.уч." text entities>)
;;; detectformatgost	(en)	(<format string> <quantity of A4>)


;;;***************************************************************************************************************
;;;           глобальные переменные
;;;***************************************************************************************************************
;; (setq scale 1)
;; (if (null scale) (setq scale (atoi (car (kd:dclget '("Введите кратность масштаба чертежей\\n(1:100 будет 100)"))))))




;;;***************************************************************************************************************
;;;           get-rightformatline<-koluch
;;;***************************************************************************************************************
;;; даёт ename линии справа от слова Кол. уч. на 179 * scale мм
;;; ent - слово Кол. уч.
;;;***************************************************************************************************************
;(setq ent (car (entsel)))
;(get-rightformatline<-koluch (car (entsel)))
(defun get-rightformatline<-koluch (ent	/ pt1 pt2 ss en)
  (setq	pt1 (list
	      (+ 0 (+ (car (cdr (assoc 10 (entget ent)))) (* 177.5 scale)))
	      (cadr (cdr (assoc 10 (entget ent))))
	      )
	pt2 (list
	      (+ 0 (+ (car pt1) (* 4 scale)))
	      (+ (cadr pt1) (* 4 scale))
	      )
	)

  (setq ss (pe-select pt1 pt2 acSelectionSetCrossing '((0 . "LINE"))))
  
;;;  (vl-cmdf "_zoom" "_W" pt1 pt2)
;;;  (setq ss (ssget "_C" pt1 pt2))
;;;  ;(command "_rectang" pt1 pt2)
;;;  (if (and ss (= 1 (sslength ss))) (setq en (ssname ss 0))
;;;    (ktz-show-error pt1 "\nget-rightformatline<-koluch : набор ss не 2 элемента"))

  (if (and ss (listp ss) (= 1 (length ss)))
    (setq en (vlax-vla-object->ename (car ss)))
    (ktz-show-error pt1 "\nget-rightformatline<-koluch : набор ss не 2 элемента")
    )
  en
  );defun


;;;***************************************************************************************************************
;;;           get-formatpts<-rightformatline
;;;***************************************************************************************************************
;;; даёт 2 точки - окно форматки
;;; принимает ent - правый отрезок рамки формата
;;;***************************************************************************************************************

(defun get-formatpts<-rightformatline (ent    /	     frame-fltr
				       ss     i	     lstX   lstY
				       minX   minY   maxX   maxY
				       pt1    pt2
				      )

  (setq	frame-fltr (list '(-4 . "<AND")
			 '(0 . "LINE")
			 '(-4 . "<OR")
			 	(cons 10 (cdr (assoc 10 (entget ent))))
			 	(cons 10 (cdr (assoc 11 (entget ent))))
			 	(cons 11 (cdr (assoc 10 (entget ent))))
			 	(cons 11 (cdr (assoc 11 (entget ent))))
			 '(-4 . "OR>")
			 '(-4 . "AND>")));setq
  
  (setq ss (ssget "_X" frame-fltr))
  (setq ss (ssdel ent ss))
  (if (/= 2 (sslength ss))
    (ktz-show-error (cdr (assoc 10 (entget ent))) "проверьте рамку формата")
    (progn
      (setq i 0)
      (repeat (sslength ss)
	(setq lstX (append lstX (list
				  (cadr (assoc 10 (entget (ssname ss i))))
				  (cadr (assoc 11 (entget (ssname ss i))))));list
	      lstY (append lstY (list
				  (caddr (assoc 10 (entget (ssname ss i))))
				  (caddr (assoc 11 (entget (ssname ss i))))));list
	      );setq
	(setq i (1+ i))
      );repeat
      (setq minX (eval (append (list 'min) lstX))
	    maxX (eval (append (list 'max) lstX))
	    minY (eval (append (list 'min) lstY))
	    maxY (eval (append (list 'max) lstY))
	    pt1	 (list minX minY)
	    pt2	 (list maxX maxY)
      );setq
      (list pt1 pt2)
    );progn
  );if
);defun

;;;***************************************************************************************************************
;;;           ktz-show-error
;;;***************************************************************************************************************
;;; рисует красный круг в предполагаемой области рисунка
;;; пишет сообщение об ошибке
;;; pt - точечная прара (10 . X Y Z)
;;;***************************************************************************************************************

(defun ktz-show-error (pt txt)
  (if (not (tblobjname "layer" "lisp-errors"))
    (command "_.-layer" "_new" "lisp-errors" "_color" "1" "lisp-errors" "_LW" "0.6" "lisp-errors" "_P" "_N" "lisp-errors" "")
    )
  (entmakex (append '((0 . "CIRCLE")
		      (62 . 1)
		      (370 . 60)
		      (40 . 150)
		      (8 . "lisp-errors"))
		    (list (list 10 (car pt) (cadr pt) 0.0)))
	    );netmakex
  (entmakex (append '((0 . "TEXT")
		      (62 . 1)
		      (40 . 20)
		      (8 . "lisp-errors"))
		    (list (cons 1 txt)
			  (list 10 (car pt) (cadr pt) 0.0)))
	    );netmakex
  ;(command "_rectang" pt1 pt2)
  (exit)
  );defun

;;;***************************************************************************************************************
;;;           get-first-on-errors-layer
;;;***************************************************************************************************************
;;;  
;;;  
;;;***************************************************************************************************************
(defun get-first-on-errors-layer ( / ss)
    (if (tblobjname "layer" "errors")
        (progn
            (setq ss (ssget "_X" '((8 . "errors"))))
            (if ss
                (progn
                    (vl-cmdf "_ZOOM" "_O" (ssname ss 0) "")
                    (sssetfirst nil ss)
                    )
                (alert "слой errors пуст")
                )
            )
        (alert "нет слоя ошибок!")
        )
    );defun


;;;***************************************************************************************************************
;;;           get-ftxte<-formatpts
;;;***************************************************************************************************************
;;; принимает 2 точки - лев. нижн., прав. верхн. углы форматки
;;; возвращает строку содержащую информацию об размере формата
;;;***************************************************************************************************************
(defun get-ftxte<-formatpts (ptlist / ss format-size)
  (vl-cmdf "_zoom" "_W" (car ptlist) (cadr ptlist))
  (setq	ss (ssget "_C" (list
			 (- (caadr ptlist) (* 1 scale))
			 (+ (* 2 scale) (cadar ptlist)))
		  
		  (list
		    (- (caadr ptlist) (* 100 scale)) ;Xpt2
		    (+ (* 2 scale) (cadar ptlist)) ;Ypt1
		    )
		  
		  '((0 . "*TEXT"))
		  )
	)
  (if ss
    
  (cond
;1
    ((> (sslength ss) 2)
     (ktz-show-error
       (cons 10 (list (caadr ptlist) (cadar ptlist)))
       "возможны лишние элементы в рамке формата"
       ) ;_ конец ktz-show-error
     (setq format-size "error")
     )
;2
    ((= (sslength ss) 2)
     (progn
       (if
	 (> (cadr (assoc 10 (entget (ssname ss 0))))
	    (cadr (assoc 10 (entget (ssname ss 1))))
	    )
	 ;then
	  (setq format-size (cdr (assoc 1 (entget (ssname ss 0)))))
	 ;else
	  (setq format-size (cdr (assoc 1 (entget (ssname ss 1)))))
	  );if
       );progn
     )
;3
    (
     (= (sslength ss) 1)
     (setq format-size (cdr (assoc 1 (entget (ssname ss 0)))))
     )
    );cond
    (ktz-show-error (cons 10 (list (caadr ptlist) (cadar ptlist))) "нет набора")
    )

  (setq	format-size (vl-string-trim " Копировал ФорматAА formatF" format-size))				;
  (vl-string-translate "х" "x" format-size)
  );defun

;;;***************************************************************************************************************
;;;           format-detect
;;;***************************************************************************************************************
;;; принимает строку содержащую информацию об размере формата
;;; возвращает размер формата для вывода на принтер
;;;***************************************************************************************************************
(defun format-detect (fstr /
		      str
		      printer-format
		      printer-separator
		      n1
		      n2
		      )
;;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;; данные зависят от того как сделан принтер			;
  (setq printer-format "-A")					; латиница
  (setq printer-separator "x")					; латиница
;;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
  (if (wcmatch fstr "#@#,#,#`*#")
    (progn
      (cond
	((= (strlen fstr) 1)
	 (setq str (strcat printer-format fstr)))
	((= (strlen fstr) 3)
	 (setq str (vl-string-translate "xх*"
		  (strcat printer-separator printer-separator printer-separator)
		  fstr))
	 (setq str (strcat printer-format str)))
	)
      T
      );progn
    (alert "ошибка при определении формата, \nвозможно неверный формат")
    )
  str
  );defun

;;;***************************************************************************************************************
;;;           get-lnumber
;;;***************************************************************************************************************
;;; берет колуч выдает entity с номером листа - old
;;; берет колуч выдает цифру с номером листа
;;; есть  функция get-sh-number в файле plot/autoplotting.lsp
;;;************************************************************************************************************
(defun get-lnumber (en / e1 vect pt1 pt2 li)
  ;(if (null scale) (setq scale 1))
  (setq vect (list (* 181 scale) (* 15 scale)))
  (setq pt1 (mapcar '+ (cdr (assoc 10 (entget en))) vect))
  (setq pt2 (mapcar '- pt1 (list (* 42 scale) (* 30 scale))))
  (vl-cmdf "_.zoom" "_W" pt1 pt2)
  (setq li (ssget "_C" pt1 pt2 '((0 . "*TEXT")(1 . "Лист"))))
  (if (and li (= (sslength li) 1)) (setq li (ssname li 0)) (ktz-show-error (cons 10 pt1) "проверьте данное место"))
  (setq vect (list (* 9 scale) (* 9 scale)))
  (setq pt1 (mapcar '- (cdr (assoc 10 (entget li))) (list 0 (* 2 scale))))
  (setq pt2 (mapcar '+ pt1 (list (* 9 scale) (* -9 scale))))
  (setq e1 (ssget "_C" pt1 pt2 '((0 . "*TEXT"))))
  
  (if (null e1)
    "0"
    (progn
      (if (= (sslength e1) 1) (setq e1 (ssname e1 0)) (ktz-show-error (cons 10 pt1) "проверьте данное место"))
      (vl-string-trim " " (cdr (assoc 1 (entget e1))))
      );progn
    );if
  );defun

;;;************************************************************************************************************
;;;           get-uznumber
;;;************************************************************************************************************
;;; берет колуч выдает entity с номером узла
;;;************************************************************************************************************
;(setq en (car (entsel)) scale 1)
(defun get-uznumber (en /
		     vect
		     pt1
		     pt2
		     li
		     )
  (setq vect (list (* 150 scale) (* 20 scale)))
  (setq pt1 (mapcar '+ (cdr (assoc 10 (entget en))) vect))
  (setq pt2 (mapcar '- pt1 (list (* 85 scale) (* 20 scale))))
  ;(command "_rectang" pt1 pt2)
  ;(vl-cmdf "_.zoom" "_W" pt1 pt2)
  ;(setq li (ssget "_C" pt1 pt2 (list '(0 . "*TEXT") (cons 40 (* 5 scale)))))
  (setq li (pe-select pt1 pt2 acSelectionSetCrossing (list
						       '(0 . "*TEXT")
						       (cons 40 (* 5 scale))
						       '(8 . "com_formats")
						       )))
  (if (and li (= (length li) 1)) (setq li (car li)) (ktz-show-error pt1 "нет набора нвыборки номера узла или высота текста не 5"))
  (vlax-vla-object->ename li)
  );defun


;;;***************************************************************************************************************
;;;           get-sheetname
;;;***************************************************************************************************************
;;; берет колуч выдает строку с названием листа
;;;************************************************************************************************************
(defun get-sheetname (en / v1 v2 pt1 pt2 li str)
  (setq str "")
  (setq v1 (list (* 55 scale) (* -30 scale)))
  (setq v2 (list (* 120 scale) (* -17 scale)))
  (setq pt1 (mapcar '+ (cdr (assoc 10 (entget en))) v1))
  (setq pt2 (mapcar '+ (cdr (assoc 10 (entget en))) v2))
  (vl-cmdf "_.zoom" "_W" pt1 pt2)
  (setq li (ssget "_C" pt1 pt2 (list '(0 . "*TEXT") (cons 40 (* 2.5 scale)))))
  (if (and li (> (sslength li) 0)) (setq li (ss->sortedlst li "-y")) (ktz-show-error pt1 "проверьте данное место"))
  (foreach item li
    (setq str (strcat str (cdr (assoc 1 (entget item))) " "))
    )
  (vl-string-trim " " str)
  );defun


;;;***************************************************************************************************************
;;;           get-kol-uch
;;;***************************************************************************************************************
;;; выдает список (e1 e2 ... en), где ех - текст с содержимым "Кол. Уч"
;;;************************************************************************************************************
(defun get-kol-uch (/ fltr ss)
  (setq fltr '((0 . "TEXT") (1 . "Кол. уч[~?@],Кол. уч[~?@],Кол.уч[~?@],Кол.уч")))
  (if (or (setq ss (ssget "_I" fltr))
	  (setq ss (ssget fltr)))
    (ss->list* ss)
    );if
  );defun



;;;***************************************************************************************************************
;;;           detectformatgost
;;;***************************************************************************************************************
;;; принимает koluch
;;; выдает список ("A4" 1) или ("A3x5" 10) в зависимости от формата
;;; 1 элемент - строка формата с английскими "A" и "x"
;;; 2 элемент - количество приведенных А4 (но есть и другая прога его вычисляющая более красиво гдето в папке ТДМС)
;;;************************************************************************************************************

;(detectformatgost (car (entsel)))
(defun detectformatgost (en / v1 v2 pt1 pt2 li fs x na4)
  (setq str "")
  (if (null scale) (setq scale (atoi (car (kd:dclget '("Введите кратность масштаба чертежей\\n(1:100 будет 100)"))))))
  (setq v1 (list (* 157 scale) (* -37 scale)))
  (setq v2 (list (* 170 scale) (* -30 scale)))
  (setq pt1 (mapcar '+ (cdr (assoc 10 (entget en))) v1))
  (setq pt2 (mapcar '+ (cdr (assoc 10 (entget en))) v2))
  (vl-cmdf "_.zoom" "_W" pt1 pt2)
  (setq li (ssget "_C" pt1 pt2 '((0 . "*TEXT")(1 . "*[AА]#[xх]#*,*[AА]#"))))
  ;(1 . "A#x#,A#х#,А#x#,А#х#,A#,А#")
  (if (= (sslength li) 1) (setq li (ssname li 0)) (ktz-show-error (cons 10 pt1) "проверьте данное место"))
  (setq str (cdr (assoc 1 (entget li))))
  (setq str (vl-string-trim " AАФормат" str))
  (cond
    ((= 1 (strlen str))(setq fs (atoi str) x 1))
    ((= 3 (strlen str))(setq fs (atoi (chr (vl-string-elt str 0))) x (atoi (chr (vl-string-elt str 2)))))
    (T nil)
    )
  (cond
    ((= fs 4)(setq na4 1))
    ((= fs 3)(setq na4 2))
    ((= fs 2)(setq na4 4))
    ((= fs 1)(setq na4 8))
    ((= fs 0)(setq na4 16))
    )
  (setq na4 (* na4 x))

  (if (= x 1)
    (list (strcat "A" (itoa fs)) na4)
    (list (strcat "A" (itoa fs) "x" (itoa x)) na4)
    )
  
  );defun




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;     V   2      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq blpt (getpoint) trpt (getpoint))
;(setq str "*Лист*")
(defun zoomgettextobj (blpt trpt str / ss osm)
  ;(setq osm (getvar "osmode"))
  ;(setvar "osmode" 0)
  (vl-cmdf "_zoom" "_W" blpt trpt)
  (setq ss (ssget "_C" blpt trpt (list (cons 0 "*TEXT") (cons 1 str))))
  ;(setvar "osmode" osm)
  (if ss (ss->lsto* ss) nil)
  )

;(setq obj (vlax-ename->vla-object (car (entsel))))
(defun FG|getcontractname (obj / ip linkobj p1 p2) ;#scale
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
  (setq linkobj (zoomgettextobj (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(53 -1.25 0))) (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(174 14 0))) "*"))
  (antisep (mapcar 'vla-get-TextString (vl-sort linkobj '(lambda (a b) (>
			(cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
			(cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))
			)))) " ")
  );defun


;(setq obj (vlax-ename->vla-object (car (entsel))))
;(FG|getprjname obj)
(defun FG|getprjname (obj / ip linkobj p1 p2 str) ;#scale
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
  (setq linkobj (zoomgettextobj (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(55 -16.1 0))) (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(123 -1.4 0))) "*"))
  (setq str (antisep (mapcar 'vla-get-TextString (vl-sort linkobj '(lambda (a b) (> (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))))))) " "))
  ;(str:antimtext str)
  (str|remove-multi-lines str)
  );defun



;(setq obj (vlax-ename->vla-object (car (entsel))))
;(FG|getdrwname obj)
(defun FG|getdrwname (obj / ip linkobj p1 p2 str) ;#scale
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
  (setq linkobj (zoomgettextobj (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(55 -31.1 0))) (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(123 -16.4 0))) "*"))
  (setq str (antisep (mapcar 'vla-get-TextString (vl-sort linkobj '(lambda (a b) (>
			(cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))
			(cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))
			)))) " "))
  ;(str:antimtext str)
  (str|remove-multi-lines str)
  );defun



;(setq obj (vlax-ename->vla-object (car (entsel))))
(defun FG|getprjnumber (obj / ip linkobj p1 p2) ;#scale
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
  (setq p1 (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(65 0 0))))
  (setq p2 (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(160 30 0))))
  (vl-cmdf "_zoom" "_W" p1 p2)
  ;(vla-addline #modspace (vlax-3d-point p1)(vlax-3d-point p2))
  (setq linkobj (ssget "_C" p1 p2 (list (cons 0 "*TEXT") (cons 40 (* scale 2.5 2)))))
  (if (and linkobj (= 1 (length (setq linkobj (ss->lsto* linkobj)))))
    (vl-string-trim " " (noeng (vla-get-TextString (car linkobj))))
    (exit))
  );defun



;(setq obj (vlax-ename->vla-object (car (entsel))))
;(setq linkobj (vlax-ename->vla-object (car (entsel))))
(defun FG|getsheetnumber (obj / ip linkobj) ;#scale
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
  ;(vla-AddCircle #modspace (vlax-3d-point ip) 4)
  (setq linkobj (zoomgettextobj
		  (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(130 -20 0)))
		  (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(177 25 0)))
		  "*Лист"))
  (if (and linkobj (= 1 (length linkobj))) (setq linkobj (car linkobj)) (exit))
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint linkobj))))
  (cond
    ((= "AcDbMText" (vla-get-objectname linkobj))
     (setq ip (mapcar '+ ip '(-4 -1.25 0)))
     )
    )
  (setq linkobj (zoomgettextobj (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(-3 -10 0)))  (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(11 -1 0)))  "*"))
  (if (and linkobj (= 1 (length linkobj)))
    (vla-get-TextString (car linkobj))
    (progn
      (if (and (setq linkobj (FG|getsheetquantity obj)) (= "1" linkobj))
	"1"
	(ktz-show-error ip "не найден номер листа")
	)
      )
    )
  );defun

;(setq obj (vlax-ename->vla-object (car (entsel))))
;(FG|getsheetquantity (vlax-ename->vla-object (car (entsel))))
(defun FG|getsheetquantity (obj / ip linkobj) ;#scale
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
;;;  (command
;;;    "_rectang"
;;;    (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(155 -7 0)))
;;;    (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(174 0 0)))
;;;    )
  
  (setq linkobj (zoomgettextobj
		  (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(155 -7 0)))
		  (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(174 0 0)))
		  "*Листов*"))
  (if (and linkobj (= 1 (length linkobj)))
    (progn
      (setq linkobj (car linkobj))
      )
    (exit)
    ;(setq )
    )
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint linkobj))))
  (setq linkobj (zoomgettextobj (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(-3 -10 0)))(mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(11 -1 0)))"*"))
  (if (and linkobj (= 1 (length linkobj)))
    (vla-get-TextString (car linkobj)) "")
  );defun



;(FG|getframetype (vlax-ename->vla-object (car (entsel))))
(defun FG|getframetype (obj / ip linkobj) ;#scale
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
  (setq linkobj (zoomgettextobj
		   (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(125 -30 0)))
		   (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(178 -15 0)))
		   "*БЕЛНИПИЭНЕРГОПРОМ*"))
  (if linkobj "purgedframe" "purgedframespec")
  );defun


;(setq obj (vlax-ename->vla-object (car (entsel))))
;(FG|getpts (vlax-ename->vla-object (car (entsel))))
(defun FG|getpts (obj / linkobj p1 p2 listmin listmax minx miny maxx maxy)
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint obj))))
  (setq linkobj (zoomgettextobj (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(120 -40 0))) (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(160 0 0))) "*Формат*"))
  (if (and linkobj (= 1 (length linkobj))) (setq linkobj (car linkobj)) (ktz-show-error ip "не найдено слово Формат или их > 1"))
  (setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint linkobj))))
  (vl-cmdf "_zoom" "_O" (vlax-vla-object->ename linkobj) "")
  (setq linkobj (ssget "_C" ip (mapcar '+ ip (mapcar '(lambda (x) (* x scale)) '(0 -3 0))) '((0 . "LINE"))))
  (if (and linkobj (= 1 (length (setq linkobj (ss->lsto* linkobj))))) (setq linkobj (car linkobj)) (ktz-show-error ip "не найдена нижняя линия форматки или их > 1"))

  (setq p1 (vlax-safearray->list (vlax-variant-value (vla-get-Startpoint linkobj))))
  (setq p2 (vlax-safearray->list (vlax-variant-value (vla-get-Endpoint linkobj))))
  (setq linkobj (ssget "_X" (list '(-4 . "<AND") '(0 . "LINE") '(-4 . "<OR") (cons 10 p1) (cons 10 p2) (cons 11 p1) (cons 11 p2) '(-4 . "OR>")'(-4 . "AND>"))))

  (mapcar
    '(lambda (line / minp maxp)
       (vla-getboundingbox line 'minp 'maxp)
       (setq listmin (append listmin (list minp)))
       (setq listmax (append listmax (list maxp)))
       )
    (ss->lsto* linkobj)
    )
  (setq minx (apply 'min (mapcar 'car (mapcar 'vlax-safearray->list listmin))))
  (setq miny (apply 'min (mapcar 'cadr (mapcar 'vlax-safearray->list listmin))))
  (setq maxx (apply 'max (mapcar 'car (mapcar 'vlax-safearray->list listmax))))
  (setq maxy (apply 'max (mapcar 'cadr (mapcar 'vlax-safearray->list listmax))))
  (list (list minx miny)(list maxx maxy))
  );defun




;(FG|formatsizedetect pts)

;(setq scale 1) (FG|formatsizedetect (list (getpoint)(getpoint)))

;(setq tobj (vlax-ename->vla-object (car (entsel))))
;(setq pts (FG|getpts tobj)) (setq scale 1)

;(FG|formatsizedetect pts)

;(vla-addline #modspace (vlax-3d-point (car pts)) (vlax-3d-point (cadr pts)))

(defun FG|formatsizedetect (pts / dopusk size ans brpt frmtstr) ;#scale
  ;(setq pts (list (getpoint)(getpoint))) (setq scale 1)
  (setq dopusk 2)
  (setq brpt (list (car (cadr pts)) (cadr (car pts))))
  ;(setq brpt (list (car (cadr a)) (cadr (car a))))
  (setq frmtstr (zoomgettextobj
		  (mapcar '+ brpt (mapcar '(lambda (x) (* x scale)) '(-75 -1 0)))
		  (mapcar '+ brpt (mapcar '(lambda (x) (* x scale)) '(-10 6 0))) "*A#*,*А#*"))
  (if (and frmtstr (= 1 (length frmtstr))) (setq frmtstr (car frmtstr)) (ktz-show-error brpt "не найден текст  A#x# или их > 1"))
  (setq	frmtstr (vl-string-translate "х" "x" (vl-string-trim " Копировал ФорматAА formatF" (vla-get-TextString frmtstr))))

  (setq size (mapcar '- (cadr pts) (car pts)))
  (setq size (mapcar '(lambda (x) (/ x scale)) size))
  (setq ans (vl-member-if '(lambda (frmt) (and (< (abs (- (cadr size) (caddr frmt))) dopusk) (< (abs (- (car size) (cadr frmt))) dopusk))) #gostformats))

  (if (and ans (= frmtstr
		  (strcut (car (car ans)) 3 0)
		  ))
    (car (car ans))
    (ktz-show-error (car pts) "format detect error")
    )
  );defun




(defun FG|A4Encount (str / s n1 n2)
  ;(setq str "A1")
  (cond
    ((wcmatch str "#") (setq s (strcat str "x1")))
    ((wcmatch str "@#") (setq s (strcat (vl-string-left-trim "AА" str) "x1")))
    ((wcmatch str "@#@#") (setq s (vl-string-left-trim "AА" str)))
    ((wcmatch str "#@#") (setq s str))
    (T (ktz-show-error '(0 0 0 ) "format name string detect error"))
    )
  (if
    (or
      (= 2 (length (setq s (sepstr s (chr 120)))))	 ;"x"
      (= 2 (length (setq s (sepstr s (chr 245)))))
      )
    (* (atoi (cadr s)) (expt 2 (- 4 (atoi (car s)))))
    (ktz-show-error '(0 0 0 ) "format name string detect error")
    )
  );defun