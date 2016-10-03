;;;14_05_27
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(load (strcat #lisppath "strings\\stringlib.lsp"))


(defun str|FilenameFormat (str / deniedSymbls res)
  (setq deniedSymbls '("\\" "/" ":" "`*" "?" "\"" "<" ">" "|"))
  (setq res str)
  (mapcar
    '(lambda (sym)
       (if (vl-string-search sym str) (setq res (antisep (sepstr res sym) "")))
       )
    deniedSymbls
    )
  res
  );defun


;(setq str "\"pfuj\" sda")
(defun str|DclFormat (str) (antisep* (sepstr str "\"") "\\\""))




(defun str|charcategory (ch / x delims)
  (setq delims '("-" "." ":"))
  (setq x (ascii ch))
  (cond
    ((or (< x 45) (= x 47) (and (> x 58) (< x 65)) (and (> x 90) (< x 97)) (and (> x 122) (< x 192)))
     "trash"
     )
    ((member ch delims)
     "delimiter"
     )
    ((and (> x 47) (< x 58))
     "num"
     )
    ((or (and (> x 64) (< x 91)) (and (> x 96) (< x 123)))
     "eng"
     )
    ((and (> x 191) (< x 256))
     "rus")
    )
  );defun





;;;(setq str "[$$]LAC[$$]CP[$$$]-X[##].1")
;;;(defun sepstr[] (str)
;;;  (apply 'append (mapcar '(lambda (x) (sepstr x "]")) (sepstr str "[")))
;;;  );defun
;;;(sepstr* str)








;(setq str "00GCM11CXU001")

;(sepstr* "00GCM11CXU001")

(defun sepstr* (str / ch|cat ans cur ccat)
  (defun ch|cat (x / delims)
    (setq delims '("-" "." ":"))
    (cond
      ((member x '(45 46 47 58 95 92)) "delimiter")
      ((and (> x 47) (< x 58)) "num")
      ((or (and (> x 64) (< x 91)) (and (> x 96) (< x 123))) "eng")
      ((and (> x 191) (< x 256)) "rus")
      ;((or (< x 45) (= x 47) (and (> x 58) (< x 65)) (and (> x 90) (< x 97)) (and (> x 122) (< x 192))) "trash")
      (T "trash")
      )
    );defun
  (mapcar
    '(lambda (c)	;(setq c (nth 5 (vl-string->list str)))
       (cond
	 ((= ccat (ch|cat c))
	  (setq cur (cons c cur))
	  )
	 (T
	  (setq ans (append ans (list (reverse cur))))
	  (setq ccat (ch|cat c))
	  (setq cur (list c))
	  )
	 )
       )
    (vl-string->list str)
    )
  (mapcar 'vl-list->string (vl-remove 'nil (append ans (list (reverse cur)))))
  );defun





;(setq strline str)
;(setq delimiter "{")
(defun sepstr (strline delimiter / strhead strtail poz)
  ;(setq delimiter "\\" strline cstr)
  (if (setq poz (vl-string-search delimiter strline))
    (progn (setq strhead (substr strline 1 poz) strtail (substr strline (+ poz 1 (strlen delimiter))))
      (append (list strhead) (sepstr strtail delimiter)))
    (list strline)
    );if
  );defun
(defun antisep (lst del)
  ;(vl-string-right-trim del (apply 'strcat (mapcar '(lambda (x) (strcat x del)) lst)))
  (vl-string-trim del (apply 'strcat (mapcar '(lambda (x) (strcat x del)) lst)))
  );defun
(defun antisep* (lst del / str)
  (setq str (apply 'strcat (mapcar '(lambda (x) (strcat x del)) lst)))
  (repeat (strlen del) (setq str (strcut str 0 -1)))
  str
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun parsepattern ()
  (princ)
  );defun





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq strline "Noprlist=Quotation № 40845 rev. 0;KKSTT=2LCQ10CT001")
;(setq par "KKSTT")
(defun vcfgpar (par strline / vcl tmp)
  (setq vcl (mapcar '(lambda (x) (sepstr x "=")) (sepstr strline ";")))
  (if (setq tmp (assoc par vcl))
    (cadr tmp)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq str "Открыть=A11,A12;Закрыть=A19,A20;Отмена=A10,A16;Ход на открытие=A15,N;Ход на закрытие=A23,N;Не открыто=A11,N;Не закрыто=A19,N" )
(defun vcfstr>data (str / sep sepstr*)
  (defun sepstr* (str del / tmp)
    (if (> (length (setq tmp (sepstr str del))) 1)
      tmp
      (car tmp)
      )
    );defun
  (mapcar
    '(lambda (x1 / tmp tmp1)
       (setq tmp (sepstr* x1 "="))
       (if (listp tmp)
	 ;(list (car tmp) (sepstr* (cadr tmp) ","))
	 (append (list (car tmp))
		 ;(sepstr* (cadr tmp) ",")
		 (sepstr (cadr tmp) ",")
		 )
	 tmp
	 )
       )
    ;(sepstr* str ";")			хз зачем я так сделал в прошлом, но ща надо просто вот так
    (sepstr str ";")
    )
  );defun
;(assoc "Не открыто" (vcfstr>data str) )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun isnumericstring (str / lst)
  (setq lst (subst 46 44 (VL-STRING->LIST str)))
  (eval (append '(and) (mapcar '(lambda (x) (or (diap x 48 57)(= x 46))) lst)))
  );defun

(defun atof* (str / lst)
  (if (and str
      (setq lst (subst 46 44 (VL-STRING->LIST str)))
      (eval (append '(and) (mapcar '(lambda (x) (or (diap x 48 57) (= x 46) (= x 45) (= x 43))) lst))))
    (atof (VL-LIST->STRING lst))
    0)
  );defun

(defun rtos* (num / str)	;(setq num 6.63445)
  (if (null num)
    ""
    (VL-LIST->STRING (subst 44 46 (VL-STRING->LIST
				    (cond
				      ((> num 100) (rtos num 2 0))
				      ((> num 10) (rtos num 2 1))
				      ((> num 1) (rtos num 2 2))
				      ((> num 0.1) (rtos num 2 3))
				      (t (rtos num))
				      )
				    )))
    )
  );defun

;(setq i 35 l 4)
(defun itos (i l / str)
  (setq str (itoa i))
  (while (< (strlen str) l) (setq str (strcat "0" str)))
  str
  );defun



;;  дополняет или обрезает строку str  до равности по длине w
;;  "населен..."
(defun str|fixedwidth (str w / l res)
  (setq res str)
  (setq l (strlen res))
  (cond
    ((< l  w) (repeat (- w l) (setq res (strcat res " "))))
    ((> l  w) (setq res (strcat (substr res 1 (- w 3)) "...")))
    (T (princ))
    )
  res
  );defun




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; start - количество ненужных букв слева (которые нужно удалить из строк)
;;; end - количество ненужных букв справа (с минусом)
(defun strcut (txt start end / s strl ns i)
  (setq strl (vl-string->list txt) ns "" s (1+ start) i s)
  (if (<= end 0) (setq end (+ (length strl) end)))
  (repeat (1+ (- end s))
    (if (<= i end) (setq ns (strcat ns (chr (nth (1- i) strl)))))
    (setq i (1+ i))
    )
  ns
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun str|remove-multi-lines (str / res)
  ;(setq str (vla-get-TextString (vlax-ename->vla-object (car (nentsel)))))
  (setq res str)
  (while (vl-string-search "\n" res)
    (setq res (vl-string-subst " " "\n" res))
    )
  (while (vl-string-search "\\P" res)
    (setq res (vl-string-subst " " "\\P" res))
    )
  res
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun str|replacechars (new old str / res)
  ;(setq str (vla-get-TextString (vlax-ename->vla-object (car (nentsel)))))
  (setq res str)
  (while (vl-string-search old res)
    (setq res (vl-string-subst new old res))
    )
  res
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;(defun kd:strtranslate (str old new / lold lnew lstr ans)
;;;  (setq lnew (vl-string->list new))
;;;  (setq lold (vl-string->list old))
;;;  (setq lst (vl-string->list str))
;;;
;;;
;;;  
;;;    (setq ans '())
;;;    (foreach item strl
;;;      (cond
;;;	((= 40 item) (setq nstr (append nstr (list 10 40))))	; (+enter
;;;	((= 80 item) (princ))					; del enter
;;;	((= 47 item) (princ))					; del enter
;;;	((= 80 item) (setq nstr (append nstr (list 32))))	; (+enter
;;;	((= 219 item) (setq nstr (append nstr (list 10))))	; (+enter
;;;	((= 95 item) (setq nstr (append nstr (list 10))))		; _ -> enter
;;;      
;;;      
;;;      ((= 92 item) (setq nstr (append nstr (list 32))))	; / на " "
;;;      ((= 34 item) (setq nstr (append nstr (list 32))))	; """  на " "
;;;      ((= 10 item) (setq nstr (append nstr (list 32))))	;
;;;      (T (setq nstr (append nstr (list item))))
;;;      );






;;;   степень совпадения двух строк,  в процентных ДОЛЯХ

;(setq s1 (vla-get-TextString (vlax-ename->vla-object (car (nentsel)))))
;(setq s2 (vla-get-TextString (vlax-ename->vla-object (car (nentsel)))))
(defun str|compare (s1 s2 / len lst i j)
  (setq len (apply 'min (mapcar 'strlen (list s1 s2))))
  (setq lst '())
  (setq i -1)
  (while (< (setq i (1+ i)) len)
    (setq j -1)
    (while (< (setq j (1+ j)) len)
      (setq lst (append lst (list (vl-string-mismatch s1 s2 i j T))))
      )
    )
  (length lst)
  (setq lst (vl-remove 0 lst))
  ;(setq lst (vl-remove 1 lst))
  ;(setq lst (vl-remove 2 lst))
  (/ (+ 0.0 (apply '+ lst)) (+ (/ (expt len 2) 2) 1.0))
  );defun

;(str|compare "котик" "котоп")


;;;;  v 2    Soundex

;(setq s1 (vla-get-TextString (vlax-ename->vla-object (car (nentsel)))))
;(setq s2 (vla-get-TextString (vlax-ename->vla-object (car (nentsel)))))
(defun str|compare-SoundexWordEncode (str / strc1 strc2 strc3)
  (setq strc1 (mapcar 'chr (vl-string->list (strcase (vl-string-trim " \\~" str) T))))
  (setq strc2 (cons (car strc1)
(mapcar
  '(lambda (c)	;(setq c "n")
     (cond
       ((member c '("a" "e" "h" "i" "o" "u" "w" "y")) "")
       ((member c '("b" "f" "p" "v")) "1")
       ((member c '("c" "g" "j" "k" "q" "s" "x" "z")) "2")
       ((member c '("d" "t")) "3")
       ((member c '("l")) "4")
       ((member c '("m" "n")) "5")
       ((member c '("r")) "6")
       (T "#err#")
       )
     )
  (cdr strc1)
  )
		    ))
  (setq strc3 '())
  (foreach x (reverse (vl-remove "" strc2))
    (if (null (= x (car strc3)))
      (setq strc3 (append (list x) strc3))
      )
    )
  (while (< 4 (length strc3))
     (setq strc3 (reverse (cdr (reverse strc3))))
     )
  (while (> 4 (length strc3))
     (setq strc3 (append strc3 (list "0")))
     )
  (apply 'strcat strc3)
  );defun
;;;(str|compare-SoundexWordEncode " beautiful")
;;;(str|compare-SoundexWordEncode " won2derful")
;;;(str|compare-SoundexWordEncode " werewolf")
  





(defun str|compare-SoundexWordEncodeRU (str / strc1 strc2 strc3)
  (setq strc1 (mapcar 'chr (vl-string->list (strcase (vl-string-trim " \\~" str) T))))
  (setq strc2 (cons (car strc1)
(mapcar
  '(lambda (c)	;(setq c "n")
     (cond
       ((member c '("а" "о" "у" "ы" "э"  "я" "ё" "ю" "и" "е" "й")) "")
       ((member c '("б" "п")) "1")
       ((member c '("г" "к" "х")) "2")
       ((member c '("в" "ф")) "3")
       ((member c '("д" "т" "ц")) "4")
       ((member c '("ж" "ш" "щ" "ч")) "5")
       ((member c '("з" "с")) "6")
       ((member c '("л" "м" "н")) "7")
       ((member c '("р")) "8")
       ((member c '("ъ" "ь")) "9")
       (T "#err#")
       )
     )
  (cdr strc1)
  )
		    ))
  (setq strc3 '())
  (foreach x (reverse (vl-remove "" strc2))
    (if (null (= x (car strc3)))
      (setq strc3 (append (list x) strc3))
      )
    )
  (while (< 6 (length strc3))
     (setq strc3 (reverse (cdr (reverse strc3))))
     )
  (while (> 6 (length strc3))
     (setq strc3 (append strc3 (list "0")))
     )
  (apply 'strcat strc3)
  );defun

;(str|compare-SoundexWordEncodeRU "привередливый")
;(str|compare-SoundexWordEncodeRU "надоедливый")


  



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(princ)