;;; 14_04_11
;;; shield connect
;;; прога для отрисовки подключения экрана кабеля:
;;; на рядах зажимов тыкаешь в кабелИ,а потом в клемму к которй подключен экран,
;;; появляется ссылки: из кабеля на клемму, из клеммы - на кабель
;;; -kakt00z-™  ©


(defun c:shc ( / cabs clam direction ptlst clpt clpt2)

(defun kd:getblocks (bname / blks)
  (princ (strcat "\n Select block inserts " bname " ...\n"))
  (if (not (setq blks (ssget "_I" '((0 . "INSERT"))))) (setq blks (ssget '((0 . "INSERT")))))
  (vl-remove-if-not '(lambda (x) (= bname (vla-get-EffectiveName x))) (ss->lsto* blks))
  )

(defun shc:getshieldpoint (cab)
  (mapcar '+
     (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint cab)))
     (list
       (if (= 1 (vlax-variant-value (vla-get-Value (getbdyn cab "cableSide"))))
	 (- (+ 30 (vlax-variant-value (vla-get-Value (getbdyn cab "shldDist")))))
	 (+ 30 (vlax-variant-value (vla-get-Value (getbdyn cab "shldDist"))))
	 )
       -1 0)
     )
  );defun

  (defun kd:genfield (obj) (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-objectid  obj)) ">%).TextString>%" ));defun
    
    


(setq cabs (kd:getblocks "cbl_cnct"))
(setq clam (vlax-ename->vla-object (car (entsel "\n Select a clam ... "))))

(cond
  ((and
     (apply '= (cons 0 (mapcar '(lambda (cab) (vlax-variant-value (vla-get-Value (getbdyn cab "cableSide")))) cabs)))
     (= 1 (vlax-variant-value (vla-get-Value (getbdyn clam "Flip state1")))))
   (setq direction -1))
  ((and
     (apply '= (cons 1 (mapcar '(lambda (cab) (vlax-variant-value (vla-get-Value (getbdyn cab "cableSide")))) cabs)))
     (= 0 (vlax-variant-value (vla-get-Value (getbdyn clam "Flip state1")))))
   (setq direction 1))
  (T (princ))
  )


(setq ptlst (mapcar 'shc:getshieldpoint cabs))
(apply '= (mapcar 'car ptlst))
(setq ptlst (vl-sort ptlst '(lambda (a b) (> (cadr a) (cadr b)))))



(setq clpt (mapcar '+ (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint clam))) (list (* direction 40) 2.5 0)))

(setq line (vla-addline #modspace (vlax-3d-point clpt) (vlax-3d-point (setq clpt2 (mapcar '+ clpt (list (* direction 30)0 0))))))
(vla-put-lineType line "GOST2.303 4")
(setq arrow (vla-InsertBlock #modspace (vlax-3d-point clpt2) (strcat #lisppath "!blocking\\arrow.dwg") 1 1 1 (+ (/ Pi 2) (* direction (/ Pi 2)))))
(setq txto (vla-Addtext #modspace (strcat (if (> (length cabs) 1) "От кабелей " "От кабеля ") (antisep (mapcar '(lambda (cab) (vla-get-TextString (getbatt cab "NUMBER"))) cabs) ", ")) (vlax-3d-point '(0 0 0)) 2.5))
(vla-put-Alignment txto (if (= direction -1) 11 9))
(vla-put-TextAlignmentPoint txto (vlax-3d-point (mapcar '+ clpt2 (list direction 0 0))))

(setq line (vla-addline #modspace (vlax-3d-point (car ptlst)) (vlax-3d-point (last ptlst))))
(vla-put-lineType line "GOST2.303 4")
(setq arrow (vla-InsertBlock #modspace (vlax-3d-point (last ptlst)) (strcat #lisppath "!blocking\\arrow.dwg") 1 1 1 (- (/ Pi 2))))

(setq txto (vla-Addtext #modspace (strcat (kd:genfield (getbatt clam "CLAMP")) ":" (kd:genfield (getbatt clam "NUMBER"))) (vlax-3d-point '(0 0 0)) 2.5))
(vla-put-Alignment txto 7)
(vla-put-TextAlignmentPoint txto (vlax-3d-point (mapcar '+ (last ptlst) '(0 -5 0))))
(princ)
);defun













;;; изменена 10_08_10
;;; shield connect
;;; прога для отрисовки подключения экрана кабеля:
;;; на рядах зажимов тыкаешь в кабель, в клемму к которй подключен экран,
;;; появляется ссылки: из кабеля на клемму, из клеммы - на кабель
;;; использована при разработке проектов Березовской ГРЭС
;;; -kakt00z-™  ©

(defun c:shc (
	      /
	      ecab
	      ecl
	      
	      ncabatt
	      ncl
	      nclmn
	      
	      pt

	      txtx1-34
	      txt-tocable
	      otr

	      doc
	      )
  ;(load (strcat #lisppath "Блоки Аттрибуты Тексты\\getbatt.LSP"))
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
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
  
  
  (setq ecab (car (entsel "\nукажите кабель"))
	ecl (car (entsel "\nукажите клемму экрана")))

  (cond
    ((= 1 (vlax-variant-value
	    (vla-get-Value
	      ;(getbdyn (vlax-ename->vla-object ecab) "Отраженное состояние"))))
	      (getbdyn (vlax-ename->vla-object ecab) "Отраженное состояние"))))
     (setq otr T))
    ((= 0 (vlax-variant-value
	    (vla-get-Value
	      ;(getbdyn (vlax-ename->vla-object ecab) "Отраженное состояние"))))
	      (getbdyn (vlax-ename->vla-object ecab) "Отраженное состояние"))))
     (setq otr nil))
    )
  
;;;  (setq ncabatt (getbatt ecab "НомКабеля")
;;;	nclmn (getbatt ecl "NКЛЕММНИКА")
;;;	ncl (getbatt ecl "НОМЕР_КЛЕММЫ"))

  (setq ncabatt (getbatt (vlax-ename->vla-object ecab) "НомКабеля")
	nclmn (getbatt (vlax-ename->vla-object ecl) "CLAMP")
	ncl (getbatt (vlax-ename->vla-object ecl) "NUMBER"))
  

  (setq txtx1-34 (strcat "%<\\AcObjProp Object(%<\\_ObjId "
			  (itoa (vla-get-objectid  nclmn))
			  ">%).TextString>%"
			  ":"
			  "%<\\AcObjProp Object(%<\\_ObjId "
			  (itoa (vla-get-objectid  ncl))
			  ">%).TextString>%"
			  );strcat
	txt-tocable (strcat "В кабель "
			    "%<\\AcObjProp Object(%<\\_ObjId "
			    (itoa (vla-get-objectid  ncabatt))
			    ">%).TextString>%"
			    );strcat
	)
  

  (if (and ncabatt nclmn ncl)
    (progn

      
      (entmake (list
		 '(0 . "LINE")
		 (cons 10 (setq pt (mapcar '- (cdr (assoc 10 (entget ecab)))
					    (if otr
					      '(-15.0 1.33008)
					      '(15.0 1.33008)
					      )
					    )))
		 (cons 11 (setq pt (mapcar '- pt '(0 5))))
		 )
	       )
      (entmake (list
		 '(0 . "LINE")
		 (cons 10 pt)
		 (cons 11 (mapcar '- pt '(-1 -2.8)))
		 )
	       )
      (entmake (list
		 '(0 . "LINE")
		 (cons 10 pt)
		 (cons 11 (mapcar '- pt '(1 -2.8)))
		 )
	       )
      (entmake (list
		 '(0 . "TEXT")
		 (cons 10 '(0 0 0))
		 (cons 1 txtx1-34)
		 '(40 . 2.5)
		 '(41 . 1.0)
		 '(51 . 0.0)
		 '(7 . "GOST 2.304")
		 '(71 . 0)
		 '(72 . 1)
		 '(73 . 3)
		 (cons 11 (mapcar '- pt '(0 1)))
		 ))
      (vl-cmdf "_updatefield" (entlast) "")
      ;(entmake
	(list
		 '(0 . "LINE")
		 (cons 10 (setq pt (mapcar '- (cdr (assoc 10 (entget ecl)))
					    (if otr
;;;					      '(-41.9046 -2.5)
;;;					      '(41.9046 -2.5)
					      '(-41.9046 -5)
					      '(41.9046 -5)
					      
					      )
					    )))
		 (cons 11 (setq pt (mapcar '- pt
					    (if otr
					      '(-25 0)
					      '(25 0)
					      )
					    )))
		 '(6 . "GOST2.303 4")
		 )
	       ;)
      ;(entmake
	(list
		 '(0 . "LINE")
		 (cons 10 pt)
		 (cons 11 (mapcar '- pt
				   (if otr
				     '(2.8 1)
				     '(-2.8 1)
				     )
				   ))
		 )
	       ;)
      ;(entmake
	(list
		 '(0 . "LINE")
		 (cons 10 pt)
		 (cons 11 (mapcar '- pt
				   (if otr
				     '(2.8 -1)
				     '(-2.8 -1)
				     )

				   ))
		 )
	       ;)
      (entmake (list
		 '(0 . "TEXT")
		 (cons 10 '(0 0 0))
		 (cons 1 txt-tocable)
		 '(40 . 2.5)
		 '(41 . 1.0)
		 '(51 . 0.0)
		 '(7 . "GOST 2.304")
		 '(71 . 0)
		 '(72 . 0)
		 '(73 . 2)
		 (cons 11 (mapcar '- pt
				   (if otr
				     '(-1 0)
				     '(1 0)
				     )
				   ))))
      (vl-cmdf "_updatefield" (entlast) "")
      )
    (exit)
    )

  (acet-error-restore)
  (vla-endundomark doc)
  
  );defun

