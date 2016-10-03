;;; 12_11_05

;;;; есть список [text entity] сортированный по Y сверху вниз
;;;; прога должна распознавать руководствуясь высотой текстовых примитивов
;;;; находятся ли они:
;;;; 1 - на одной строке
;;;; 2 - на разных строках
;;;; 3 - являются элементиами разных записей (MTEXT'ов)

;;; прога должна приебразовывать столбик с текстами в столбик с м-текстами
;;; разделяя мтексты по "видимо различимому" промежутку


(defun c:t-mt ( / err)
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0
			       "highlight" (getvar "highlight")
			       "limcheck" 0
			       "osmode" 0)
			 T));acet-error-init
  (setq err (vl-catch-all-apply 'txt->mtxt nil))
  (acet-error-restore)
  (vla-endundomark #actdoc)
  (if err (vl-catch-all-error-message err))
  );defun

(defun c:mt-t ( / err)
  (setq #actdoc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0
			       "highlight" (getvar "highlight")
			       "limcheck" 0
			       "osmode" 0)
			 T));acet-error-init
  (setq err (vl-catch-all-apply 'mtxt->txt nil))
  (acet-error-restore)
  (vla-endundomark #actdoc)
  (if err (vl-catch-all-error-message err))
  );defun




(defun txt->mtxt (
		  /
		  ss
		  ssl
		  sslxymin
		  sslxymax
		  
		  str

		  mtxto
		  minp
		  maxp
		  
		  textheight
		  tmp
		  col
		  
		  i
		  )
  
  (setq ss (ssget '((0 . "*TEXT")))
	i 0
	ssl '()
	col nil
	)
  (repeat (sslength ss)
    (setq ssl (append ssl (list (ssname ss i))))
    (setq i (1+ i))
    )

  (setq textheight '())
	;tmp nil)

  
;;; находим превалирующую высоту текста   =================================================================
  (foreach item ssl
    (setq tmp (cdr (assoc 40 (entget item))))
    (if (assoc tmp textheight)
      (setq textheight (subst (cons tmp (1+ (cdr (assoc tmp textheight)))) (assoc tmp textheight) textheight))
      (setq textheight (append textheight (list (cons tmp 1))))
      );if
    );foreach
  (setq textheight (mapcar '(lambda (x) (cons (cdr x) (car x))) textheight))
  (setq textheight (cdr (assoc (eval (cons 'max (mapcar 'car textheight))) textheight)))
;;;========================================================================================================

;;; сортировка ============================================================================================

  (setq ssl (vl-sort ssl '(lambda (a b)
			    (> (car (cdr (assoc 10 (entget b))))
			       (car (cdr (assoc 10 (entget a)))))
			    )))
    
  (setq ssl (vl-sort ssl '(lambda (a b)
			    (> (-
				 (cadr (cdr (assoc 10 (entget a))))
				 (cadr (cdr (assoc 10 (entget b)))))
			       textheight)
			    )))
  
;;;========================================================================================================

;;;  формирование mtxt ==============================================================================
  (setq str (cdr (assoc 1 (entget (car ssl))))
	i 0)
  (repeat (1- (length ssl))
    (setq i (1+ i))
    (if (> (- (cadr (cdr (assoc 10 (entget (nth (1- i) ssl)))))
	      (cadr (cdr (assoc 10 (entget (nth i ssl))))))
	   textheight)
      (setq str (strcat str "\\P" (cdr (assoc 1 (entget (nth i ssl))))))
      (setq str (strcat str " " (cdr (assoc 1 (entget (nth i ssl))))))
      )
    (if (/= textheight (cdr (assoc 40 (entget (nth i ssl)))))
      (setq col T)
      );if

    );repeat
;;;========================================================================================================
;(vlax-dump-object (vla-get-TrueColor (vlax-ename->vla-object (car (entsel))))T)
 
;;; вычисление координат будующего mtext'а ================================================================
  (setq sslxymin '()
	sslxymax '())
  
  (foreach item ssl
    (vla-GetBoundingBox (vlax-ename->vla-object item) 'minp 'maxp)
    (setq sslxymin (append sslxymin (list (vlax-safearray->list minp)))
	  sslxymax (append sslxymax (list (vlax-safearray->list maxp))))
    );foreach

  (setq minp (list (eval (append (list 'min) (mapcar 'car sslxymin)))
		   (eval (append (list 'min) (mapcar 'cadr sslxymin)))))
  (setq maxp (list (eval (append (list 'max) (mapcar 'car sslxymax)))
		   (eval (append (list 'max) (mapcar 'cadr sslxymax)))))
  ;(setq minp (mapcar '- minp '(1 1 0)))
  (setq maxp (mapcar '+ maxp '(1 0 0)))
  
  
  ;(vla-GetBoundingBox (vlax-ename->vla-object (car (reverse ssl))) 'minp 'maxp)
  
  ;(setq maxp (vlax-safearray->list maxp)
;	minp (cdr (assoc 10 (entget (car ssl)))))
;;;========================================================================================================  


;;; вставка mtext entity ==================================================================================
  (setq mtxto (vla-AddMText #modspace
	       (vlax-3D-Point (cdr (assoc 10 (entget (car ssl)))))
	       (- (car maxp) (car minp))
	       str))
  (vla-put-AttachmentPoint mtxto 1)		;top left
  ;(vla-put-AttachmentPoint mtxto 5)		;mid center
  ;(vla-put-AttachmentPoint mtxto 4)		;mid left

  (vla-put-InsertionPoint mtxto (vlax-3D-Point (list (car minp) (cadr maxp))))		;top left
  ;(vla-put-InsertionPoint mtxto (vlax-3D-Point (vec-div (vec-sum minp maxp) 2)))	;mid center
  ;(vla-put-InsertionPoint mtxto (vlax-3D-Point (list (car minp) (/ (+ (cadr minp) (cadr maxp)) 2))))		;mid left

;;;=== для таблиц межстрочный интервал ====================================================================
  (vla-put-LineSpacingStyle mtxto acLineSpacingStyleExactly)
  ;(vla-put-LineSpacingDistance mtxto 8)
;;;========================================================================================================  
  
  (vla-put-Height mtxto textheight)
  (vla-put-StyleName mtxto "GOST 2.304")
  (if col (vla-put-color mtxto 2))
  ;(vlax-dump-object (vlax-ename->vla-object (car (entsel))))
;;;========================================================================================================  

  ;(mapcar '(lambda (x) (cdr (assoc 1 (entget x)))) ssl)
  
;;; удаление старых текстов ===============================================================================
  (vl-cmdf "_erase" ss "")
;;;========================================================================================================  
  col

  );defun




(defun txtlines->mtxtrows (
                           /
                           doc
                           ms
                           ss
                           enlst
                           ent
                           i
                           textheight
                           minp
                           maxp
                           mtxto
                           color
                           )
    (setq doc (vla-get-activedocument (vlax-get-acad-object)))
    (setq ms (vla-get-ModelSpace doc))
    (vla-startundomark doc)
    (acet-error-init
        (list (list "cmdecho" 0
                    "highlight" (getvar "highlight")
                    "limcheck" 0
                    "osmode" 0
                    );list
              T
              );list
        );acet-error-init
    (setq ss (ssget '((0 . "*TEXT")))
          i 0
          enlst '())
    (repeat (sslength ss)
        (setq enlst (append enlst
                            (list
                                (list
                                    (setq ent (ssname ss i))
                                    (cadr (cdr (assoc 10 (entget ent))))
                                    ))))
        (setq i (1+ i))
        );repeat
    (setq textheight (cdr (assoc 40 (entget (ssname ss 1)))))
    (setq enlst (vl-sort enlst '(lambda (a b)
                                    (< (cadr a)
                                       (cadr b)
                                       ))))
    (setq enlst (mapcar 'car enlst))

    (foreach item enlst
        (vla-GetBoundingBox (vlax-ename->vla-object item) 'minp 'maxp)
        (setq minp (vlax-safearray->list minp)
              maxp (vlax-safearray->list maxp)
              )
        (setq mtxto (vla-AddMText ms
                                  (vlax-3D-Point (cdr (assoc 10 (entget item))))
                                  (- (car maxp) (car minp))
                                  (cdr (assoc 1 (entget item)))
                                  ))
        (vla-put-AttachmentPoint mtxto 1)		;top left
        ;(vla-put-AttachmentPoint mtxto 5)		;mid center
        ;(vla-put-AttachmentPoint mtxto 4)		;mid left

        (vla-put-InsertionPoint mtxto (vlax-3D-Point (list (car minp) (cadr maxp))))		;top left
        ;(vla-put-InsertionPoint mtxto (vlax-3D-Point (vec-div (vec-sum minp maxp) 2)))	;mid center
        ;(vla-put-InsertionPoint mtxto (vlax-3D-Point (list (car minp) (/ (+ (cadr minp) (cadr maxp)) 2))))		;mid left

        (vla-put-Height mtxto textheight)
        (vla-put-StyleName mtxto "GOST 2.304")
        (if (setq color (assoc 62 (entget item)))
            (vla-put-color mtxto (cdr color))
            )
        (vl-cmdf "_erase" item "")
        );foreach
    (acet-error-restore)
    (vla-endundomark doc)
    );defun



(defun asd (
	    /
	    doc
	    ms
	    listoftexts
	    )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (setq ms (vla-get-ModelSpace doc))
  (vla-startundomark doc)
  (acet-error-init (list (list "cmdecho" 0
			       "highlight" (getvar "highlight")
			       "limcheck" 0
			       "osmode" 0);list
			 T));acet-error-init

  (setq listoftexts (cons-txtlist (ss->sortedlst (ssget '((0 . "*TEXT"))) "-y")))

  (mapcar 'appmtxt listoftexts)

  (acet-error-restore)
  (vla-endundomark doc)
  );defun

;(setq lst(ss->sortedlst (ssget '((0 . "*TEXT"))) "-y"))

(defun cons-txtlist (lst
		     /
		     dy
		     res
		     cres
		     i
		     )
  
  (setq dy (mapcar '(lambda (x) (caddr (assoc 10 (entget x)))) lst))
  (setq dy (mapcar '- dy (cdr dy)))

  (setq i 0
	res '()
	cres (list (car lst)))

  (repeat (length dy)
    (if (< (nth i dy) 10)
      (setq cres (append cres (list (nth (1+ i) lst))))
      (setq res (append res (list cres))
	    cres (list (nth (1+ i) lst)))
      )
    (setq i (1+ i))
    );repeat
  res
  );defun




(defun appmtxt (lst
		/
		sslxymin
		sslxymax
		minp
		maxp
		mtxto
		str
		i
		textheight
		tmp
		)
  
  (setq sslxymin '()
	sslxymax '())
  
  (foreach item lst
    (vla-GetBoundingBox (vlax-ename->vla-object item) 'minp 'maxp)
    (setq sslxymin (append sslxymin (list (vlax-safearray->list minp)))
	  sslxymax (append sslxymax (list (vlax-safearray->list maxp))))
    );foreach

  (setq minp (list (eval (append (list 'min) (mapcar 'car sslxymin)))
		   (eval (append (list 'min) (mapcar 'cadr sslxymin)))))
  (setq maxp (list (eval (append (list 'max) (mapcar 'car sslxymax)))
		   (eval (append (list 'max) (mapcar 'cadr sslxymax)))))

    (setq textheight '())
	;tmp nil)

;;; находим превалирующую высоту текста   =================================================================
  (foreach item lst
    (setq tmp (cdr (assoc 40 (entget  item))))
    (if (assoc tmp textheight)
      (setq textheight (subst (cons tmp (1+ (cdr (assoc tmp textheight)))) (assoc tmp textheight) textheight))
      (setq textheight (append textheight (list (cons tmp 1))))
      );if
    );foreach
  (setq textheight (mapcar '(lambda (x) (cons (cdr x) (car x))) textheight))
  (setq textheight (cdr (assoc (eval (cons 'max (mapcar 'car textheight))) textheight)))
;;;========================================================================================================


  
;;; сортировка ============================================================================================

  (setq lst (vl-sort lst '(lambda (a b)
			    (> (car (cdr (assoc 10 (entget b))))
			       (car (cdr (assoc 10 (entget a)))))
			    )))
    
  (setq lst (vl-sort lst '(lambda (a b)
			    (> (-
				 (cadr (cdr (assoc 10 (entget a))))
				 (cadr (cdr (assoc 10 (entget b)))))
			       textheight)
			    )))
  
;;;========================================================================================================

;;;  формирование mtxt ==============================================================================
  (setq str (cdr (assoc 1 (entget (car lst))))
	i 0)
  (repeat (1- (length lst))
    (setq i (1+ i))
    (if (> (- (cadr (cdr (assoc 10 (entget (nth (1- i) lst)))))
	      (cadr (cdr (assoc 10 (entget (nth i lst))))))
	   textheight)
      (setq str (strcat str "\\P" (cdr (assoc 1 (entget (nth i lst))))))
      (setq str (strcat str " " (cdr (assoc 1 (entget (nth i lst))))))
      )
    (if (/= textheight (cdr (assoc 40 (entget (nth i lst)))))
      (setq col T)
      );if

    );repeat


  ;;; вставка mtext entity ==================================================================================
  (setq mtxto (vla-AddMText #modspace
	       (vlax-3D-Point (cdr (assoc 10 (entget (car lst)))))
	       (- (car maxp) (car minp))
	       str))
  (vla-put-AttachmentPoint mtxto 1)		;top left
    
  (vla-put-InsertionPoint mtxto (vlax-3D-Point (list (car minp) (cadr maxp))))		;top left
  (vla-put-LineSpacingStyle mtxto acLineSpacingStyleExactly)
  (vla-put-Height mtxto textheight)
  (vla-put-StyleName mtxto "GOST 2.304")
  (if col (vla-put-color mtxto 2))
  ;(vl-cmdf "_erase" ss "")
;;;========================================================================================================  

  
);defun





;;;; есть список [text entity] сортированный по Y сверху вниз
;;;; прога должна распознавать руководствуясь высотой текстовых примитивов
;;;; находятся ли они:
;;;; 1 - на одной строке
;;;; 2 - на разных строках
;;;; 3 - являются элементиами разных записей (MTEXT'ов)


(defun struct (lst / mlst sublist i)
  (setq i 0)
  (setq sublist (list (car lst)))
  (repeat (1- (length lst))
    (if (> (abs (- (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint (nth i lst)))))
		   (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint (nth (1+ i) lst)))))
		   ))15)
      (setq mlst (append mlst (list sublist))
	    sublist (list (nth (1+ i) lst)))
      (setq sublist (append sublist (list (nth (1+ i) lst))))
      )
    (setq i (1+ i))
    )
  (append mlst (list sublist))
  )

(defun consmtexts ()
  (mapcar
  'appmtxt
  (mapcarx
    vlax-vla-object->ename
    nil
    (struct
      (mapcar
	'vlax-ename->vla-object
	(ss->sortedlst (ssget '((0 . "TEXT"))) "-y"))
      )
    )
  )
  )