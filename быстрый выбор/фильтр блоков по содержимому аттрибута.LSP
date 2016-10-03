(load (strcat #lisppath "быстрый выбор\\kd-block-filter-by-att.LSP"))

;(defun do (o) (vlax-dump-object o T))

;;;(defun blfltrbyatt (
;;;		    /
;;;		    ss
;;;                    str
;;;		    tag
;;;                    i	
;;;		    str
;;;                    ble
;;;                    sss
;;;		    )
;;;    (if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
;;;        (setq ss (ssget '((0 . "INSERT"))))
;;;        );if
;;;    (setq str (getstring
;;;	      "\nУкажите текст используя символы : \n
;;;	      # Заменяет одну любую цифру\n
;;;	      @ Заменяет одну любую букву\n
;;;	      .(точка) Заменяет любой символ, не являющийся ни буквой, ни цифрой\n
;;;	      * Заменяет любую последовательность (в любом месте)\n
;;;	      ? Заменяет ровно один любой символ\n
;;;	      ~ В начале - все, кроме определенного\n
;;;	      \[...\] \[~...\] Заменяет любой из символов, перечисленных в скобках\n
;;;	      - Между двумя однотипными знаками указывает на диапазон\n
;;;	      "))
;;;    (setq str (if str str ""))
;;;    (setq tag (seltag (mapcar 'att->tag (getatts (vlax-ename->vla-object (ssname ss 1))))))
;;;    ;(setq tag (seltag (mapcar 'att->tag (getatts (car (entsel))))))
;;;
;;;    (setq sss (ssadd))
;;;  (setq i 0)
;;;    
;;;  (repeat (sslength ss)
;;;      (setq ble (ssname ss i))
;;;      (foreach att (getatts (vlax-ename->vla-object ble))
;;;          (if (and
;;;                  (= tag (att->tag att))
;;;                  (wcmatch (vla-get-TextString att) str)
;;;                  )
;;;              (ssadd ble sss)
;;;              )
;;;          )
;;;      (setq i (1+ i))
;;;      )
;;;  (princ)
;;;    (sssetfirst nil sss)
;;;    );defun
;;;
;;;;;;;******************************************************************************
;;;(defun getatts (blo / atts)
;;;    (setq atts (vla-GetAttributes blo))
;;;    (setq atts (vlax-variant-value atts))
;;;    (if (>= (vlax-safearray-get-u-bound atts (vlax-safearray-get-dim atts)) 0)
;;;        (vlax-safearray->list atts)
;;;        nil)
;;;    );defun
;;;
;;;(defun att->tag (att)
;;;    (if att
;;;        (strcase (vl-string-subst "-" "_" (vla-get-tagstring att)) t)
;;;        nil)
;;;    );defun
;;;
;;;(defun seltag (tags / init kword)
;;;    (setq init "" kword "")
;;;    (foreach tag tags
;;;        (setq init (strcat init tag " "))
;;;        (setq kword (strcat kword tag "/"))
;;;        )
;;;    (setq init (strcat init "все"))
;;;    (setq kword (strcat kword "все"))
;;;    (initget (strcat init " _" init))
;;;    (getkword (strcat "\n Укажите аттрибут \n[" kword "] :"))
;;;    );defun
;;;;;;;******************************************************************************
;;;
;;;
;;;
;;;;;;;******************************************************************************
;;;(defun bpick (
;;;	      /
;;;	      od
;;;	      bname
;;;	      blist
;;;	      bss
;;;	      be
;;;	      )
;;;  (setq bss (ssadd))
;;;  
;;;
;;;  ;(setq od (namedobjdict))
;;;  (setq bname (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel)))))
;;;  (setq blist (entget (tblobjname "block" bname)))
;;;
;;;  (setq blist (entget (cdr (assoc 330 blist))))
;;;  (while (setq be (assoc 331 blist))
;;;    (setq bss (ssadd (cdr be) bss)
;;;	  blist (vl-remove be blist))
;;;    );while
;;;  (sssetfirst nil bss)
;;;  ) ;_ defun
;;;;(bpick)
;;;;;;;******************************************************************************
;;;
;;;
;;;
;;;;;;;;;BLOCK_RECORD
;;;;;;(entget (cdr (assoc 330 (entget (car (entsel))))))
;;;;;;;;; table
;;;;;;(entget (cdr (assoc 330 (entget (cdr (assoc 330 (entget (car (entsel)))))))))
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;;;; функция для указания номера аттрибута
;;;;;; берет из ss 1-й элемент и сканирует его аттрибуты
;;;;;; выдает порядковый номер аттрибута или 0 - если все
;;;
;;;(defun getnatt (
;;;		e
;;;		/
;;;		ent
;;;		acn
;;;		init
;;;		kword
;;;		vinit
;;;		i
;;;		)
;;;  (setq i 1
;;;	acn ""
;;;	init ""
;;;	kword ""
;;;	vinit ""
;;;	
;;;	)
;;;  (setq ent (entnext e))
;;;  ;;;**************************************
;;;      (while
;;;      (/= (cdr (assoc 0 (entget ent))) "SEQEND")
;;;       (setq acn (cdr (assoc 2 (entget ent))))
;;;       (setq init (strcase (strcat init (vl-string-subst "-" "_" acn) " ") t))
;;;       (setq kword (strcase (strcat kword (vl-string-subst "-" "_" acn) "/") t))
;;;       (setq vinit (strcat vinit (itoa i) " "))
;;;       (setq ent (entnext ent))
;;;       (setq i (1+ i))
;;;    );while
;;;  
;;;  (setq init (strcat init "все"))
;;;  (setq kword (strcat kword "все"))
;;;  (setq vinit (strcat vinit "0"))
;;;  
;;;  (setq kword (vl-string-right-trim "/" kword))
;;;  (initget (strcat init " _" vinit))
;;;  (atoi (getkword (strcat "\n Укажите аттрибут \n[" kword "] :")))
;;;);defun
;;;
;;;
;;;
;;;
;;;(defun flt-content (
;;;		    /
;;;		    ss
;;;		    na
;;;		    str
;;;		    sss
;;;		    i
;;;		    txt
;;;		    
;;;		    )
;;;
;;;(if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
;;;   (setq ss (ssget))
;;;   );if
;;;  (setq sss (ssadd))
;;;  (setq i 0)
;;;  (setq str (getstring
;;;	      "\nУкажите текст используя символы : \n
;;;	      # Заменяет одну любую цифру\n
;;;	      @ Заменяет одну любую букву\n
;;;	      .(точка) Заменяет любой символ, не являющийся ни буквой, ни цифрой\n
;;;	      * Заменяет любую последовательность (в любом месте)\n
;;;	      ? Заменяет ровно один любой символ\n
;;;	      ~ В начале - все, кроме определенного\n
;;;	      \[...\] \[~...\] Заменяет любой из символов, перечисленных в скобках\n
;;;	      - Между двумя однотипными знаками указывает на диапазон\n
;;;	      "))
;;;  (setq str
;;;	 (if str
;;;	   str
;;;	   ""))
;;;    
;;;  (setq na (getnatt (ssname ss 1)))
;;;  
;;;  (repeat (sslength ss)
;;;    (setq ent (entnext (ssname ss i)))
;;;    (if (setq txt (assoc 1 (entget (repeat (- na 1) (setq ent (entnext ent))))))
;;;      (if (wcmatch (cdr txt) str)
;;;	(ssadd (ssname ss i) sss)
;;;	);if
;;;      );if
;;;    (setq i (1+ i))
;;;    )
;;;
;;;  (sssetfirst nil sss)
;;;   
;;;
;;;)