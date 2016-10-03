




(defun c:exbtf ( / docs ss path blks ssets cssname css objsa ) ;files)
  (setq path (strcat (vla-get-Path #actdoc) "\\project blocks"))
  (if (null (vl-file-directory-p path)) (vl-mkdir path))
  (setq ssets (vla-get-SelectionSets #actdoc)) (setq cssname "BETF_selection")
  (if (member cssname (mapcar 'vla-get-name (cont>list ssets)))
    (setq css (vla-item ssets cssname))
    (setq css (vla-add ssets cssname))
    )
  (vla-clear css)
  (vla-SelectOnScreen css (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0)) (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("INSERT")))
  
  (if (= 0 (vla-get-count css))
    (setq blks (mapcar 'vla-get-name (vl-remove-if '(lambda (b / n) (wcmatch (vla-get-name b) (antisep '("`*Model_Space" "`*Paper_Space" "_ArchTick") ","))) (cont>list (vla-get-blocks #actdoc)))))
    (setq blks (origlist (mapcar 'vla-get-name (cont>list css))))
    )
  (vla-clear css)
  (mapcar
    '(lambda (bn / cbrefs)
       ;(setq cbrefs (ssget))
       (setq cbrefs (ssget "_X" (list '(0 . "INSERT") (cons 2 (strcat bn "," "`*U*")))))
       (setq cbrefs (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) (list bn))) (ss->lsto* cbrefs)))
       (if cbrefs
	 (progn
	   (setq objsa (vlax-make-safearray vlax-vbObject (cons 0 0)))
	   (vlax-safearray-put-element objsa 0 (car cbrefs))
	   (vla-AddItems css objsa)
	   (setq files (cons (strcat path "\\" (vla-get-EffectiveName (car cbrefs)) ".dwg") files))
	   (vla-Wblock #actdoc (strcat path "\\" (vla-get-EffectiveName (car cbrefs)) ".dwg") css)
	   (vla-clear css)
	   )
	 )
       )
    blks
    )
  
  (setq docs (vla-get-Documents #cad))
  (mapcar
    '(lambda (file / $doc b)
       (setq $doc (vla-open docs file))
       (setq b (vla-item (vla-get-ModelSpace $doc) 0))
       (vla-put-InsertionPoint b (vlax-3d-point '(0 0 0)))
       ;(setq ip (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))
       (vla-explode b)
       (vla-delete b)
       (vla-PurgeAll $doc)
       (vla-saveas $doc file ac2004_dwg)
       (vla-close $doc)
       )
    files)
  );defun


;;;(setq cpt (getpoint))
;;;(mapcar
;;;  '(lambda (path / drw p1 p2)
;;;     ;(setq path (nth 13 filelist))
;;;     (setq drw (vla-InsertBlock #modspace (vlax-3d-point cpt) path 1 1 1 0 ))
;;;     (vla-GetBoundingBox drw 'p1 'p2)
;;;     (setq p1 (vlax-safearray->list p1))
;;;     (setq p2 (vlax-safearray->list p2))
;;;     (command "_rectang" p1 p2)
;;;     (setq cpt (mapcar '+ cpt (list 0 (- (cadr p1) (cadr p2)) 0) '(0 -5 0)))
;;;     (vla-move drw (vlax-3d-point p1) (vlax-3d-point cpt))
;;;    )
;;;  files
;;;  )








;;;
;;;
;;;  (setq ssets (vla-get-SelectionSets #actdoc))
;;;  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "getcableline")))
;;;    (setq sset (vla-add ssets "getcableline"))
;;;    (progn (vla-delete (vla-item ssets "getcableline")) (setq sset (vla-add ssets "getcableline")))
;;;    )
;;;  (vla-Clear sset)
;;;  (setq pt (cbl|getendpoint obj))
;;;  ;(vl-cmdf "_zoom" "_W" (car pts) (cadr pts))
;;;  (vla-select sset acSelectionSetCrossing
;;;    (vlax-3d-point pt)
;;;    (vlax-3d-point pt)
;;;    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
;;;    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("LINE"))
;;;  )
;;;  (cond
;;;    ((= 1 (vla-get-count sset)) (setq result (vla-item sset 0)))
;;;    ((= 0 (vla-get-count sset)) (setq result nil))
;;;    (T (setq result (kd-container->list sset)))
;;;    )
;;;  (vla-clear sset)
;;;  (vla-Delete sset)
;;;  result
;;;  );defun
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;(setq ss (vla-get-ActiveSelectionSet #actdoc))
;;;(vla-Clear ss)
;;;(vla-SelectOnScreen ss)
;;;(vla-Wblock #actdoc (strcat folder "98-13-рх-хня.юру.яа.02-рн_" (itoa (setq i (1+ i))) ".dwg") ss)
;;;
;;;'((0 . "INSERT")(2 . 
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;(do #modspace)
;;;(do #actdoc)
;;;(do #cad)
;;;(do (vla-get-Database #actdoc))
;;;(do (vla-get-OpenSave (vla-get-Utility #actdoc)))
;;;
;;;
;;;(do (vlax-ename->vla-object (car (entsel))))
;;;
;;;BSAVEAS
;;;
;;;
;;;(do #actdoc)
;;;
;;;
;;;
;;;
;;;;;		bexp
;;;
;;;(setq bref (vlax-ename->vla-object (car (entsel))))
;;;;(do bref)
;;;(setq effname (vla-get-EffectiveName bref))
;;;(setq block (vla-item (vla-get-blocks #actdoc) effname))
;;;(do block)
;;;
;;;;;;(setq exd (vla-GetExtensionDictionary block))
;;;;;;(do exd)
;;;;;;(vla-delete exd)
;;;;;;(vlax-release-object exd)
;;;;;;(setq exd nil)
;;;
;;;
;;;vla-InsertBlock
;;;
;;;
;;;(vla-Wblock)
;;;
;;;(do #actdoc)
;;;(do (vla-get-SelectionSets #actdoc))
;;;
;;;(vla-item (vla-get-SelectionSets #actdoc) "asd")
;;;
;;;
;;;
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;
;;;
;;;
;;;(setq bref (vlax-ename->vla-object (car (entsel))))
;;;(setq blk (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName bref)))
;;;(setq bname (vla-get-name blk))
;;;
;;;(if (member "bexp" (mapcar 'vla-get-name (cont>list (vla-get-SelectionSets #actdoc))))
;;;  (setq css (vla-item (vla-get-SelectionSets #actdoc) "bexp"))
;;;  (setq css (vla-add (vla-get-SelectionSets #actdoc) "bexp"))
;;;  )
;;;(vla-clear css)
;;;
;;;
;;;
;;;
;;;
;;;
;;;(setq sa (vlax-make-safearray vlax-vbObject (cons 0 (- (vla-get-Count blk) 1))))
;;;(vlax-safearray->list sa)
;;;
;;;(setq i -1)
;;;(mapcar
;;;  '(lambda (obj)
;;;     (vlax-safearray-put-element sa (setq i (1+ i)) obj)
;;;     (princ)
;;;     )
;;;  lst
;;;  ;(cont>list blk)
;;;  )
;;;
;;;(setq var (vlax-make-variant sa))
;;;
;;;
;;;(vla-AddItems css var)
;;;
;;;
;;;
;;;
;;;
;;;
;;;(vla-AddItems css sa)
;;;(vla-Update css)
;;;
;;;
;;;
;;;(do block)
;;;
;;;(setq itemlist (cont>list block))
;;;
;;;(setq sa (vlax-make-safearray vlax-vbObject (cons 0 (- (vla-get-Count block) 1))))
;;;(setq cnt -1)
;;;(vlax-for item block (vlax-safearray-put-element sa (setq cnt (1+ cnt)) item))
;;;
;;;(vla-AddItems css (vlax-make-variant sa))
;;;
;;;(vlax-make-variant itemlist vlax-vbArray)
;;;
;;;
;;;(vlax-for item block (vla-AddItems css (vlax-make-variant item)))
;;;
;;;
;;;(setq ss (ssadd))
;;;
;;;(vlax-ename->vla-object ss)
;;;
;;;
;;;(mapcar
;;;  '(lambda (i)
;;;     (ssadd (vlax-vla-object->ename i) ss)
;;;     )
;;;  itemlist)
;;;
;;;
;;;
;;;
;;;
;;;(setq cnt 0)
;;;    (vlax-for each-item block
;;;        (vlax-safearray-put-element sa cnt each-item)
;;;        (setq cnt (1+ cnt))
;;;    )
;;;
;;;
;;;sa
;;;		
;;;(vla-AddItems css sa)
;;;
;;;(setq obj (vlax-ename->vla-object (car (entsel))))
;;;
;;;(vla-AddItems css (vlax-make-variant obj))
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;(defun ss2vbaSS (ss name / doc ssets vlss idx ss_list)
;;;  (setq doc (vla-get-activedocument (vlax-get-acad-object))
;;;	ssets (vla-get-selectionsets doc)
;;;	)
;;;  (vl-catch-all-apply '(lambda () (vla-delete (vla-item ssets name))))
;;;  
;;;  (setq vlss (vla-add ssets name) idx -1)
;;;  (while (< (setq idx (1+ idx)) (sslength ss))
;;;    (setq ss_list (cons (vlax-ename->vla-object (ssname ss idx)) ss_list))
;;;    )
;;;  (vlax-invoke vlss 'additems (reverse ss_list))
;;;  )