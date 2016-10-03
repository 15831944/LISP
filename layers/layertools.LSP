(load (strcat #lisppath "common functions\\kd-container-list.LSP"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:ltoss (/ ss lays lmname)
  (setq ss (ssget "_I"))
  (setq lays (cont>list (vla-get-Layers #actdoc)))
  (setq lname (kd:dcl:pick-from-list (mapcar 'vla-get-name lays)))
;;;  (if ss
;;;    (sssetfirst nil (ssget "_I" (list (cons 8 lname))))
;;;    (sssetfirst nil (ssget "_X" (list (cons 8 lname))))
;;;    )
  (if lname
    (sssetfirst nil (ssget (if ss "_I" "_X") (list (cons 8 lname))))
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:picklay (/ p lname)
  (if (setq p (entsel))
    (progn
      (setq lname (cdr (assoc 8 (entget (car p)))))
      (sssetfirst nil (ssget (if ss "_I" "_X") (list (cons 8 lname))))
      )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:ssLayerFilter ( / ss layers)
  (if (setq ss (ssget "_I"))
    (setq ss (ss->lsto* ss))
    (setq ss (ss->lsto* (ssget)))
    )
  (setq layers (origlist (mapcar 'vla-get-layer ss)))
  (setq layers (kd:dcl:pick-from-list layers))
  (setq ss (vl-remove-if-not '(lambda (o) (= layers (vla-get-layer o))) ss))
  (sssetfirst nil (lst-to-ss ss))
  );defun



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:to-layer ( / my-set)
  (setq my-set (ssget))
  (if (not (tblobjname "layer" "нумерация")) (command "_.-layer" "_new" "нумерация" "_color" "161" "нумерация" ""))
  (command "_.-layer" "_set" "нумерация" "")
  (command "_.chprop" my-set "" "_lay" "нумерация" "")
  (command "_.-layer" "_freeze" "*" "")
);defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:lo () (g:layeroff))
(defun g:layeroff (/ obj)
  (if (setq obj (ssget "_I"))
    (setq obj (ss->lsto* obj))
    (if (setq obj (entsel))
      (progn
	(setq obj (list (vlax-ename->vla-object (car obj))))
	(mapcar
	  '(lambda (x)
	     (vla-put-Freeze
	       (vlax-ename->vla-object (tblobjname "layer" (vla-get-Layer x)))
	       :vlax-true)
	     )
	  obj
	  )
	)
      )
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

















;;;
;;;
;;;
;;;
;;;
;;;(defun qwe ( / ss lays laysinss lname)
;;;  (if (null (setq ss (ssget "_I")))
;;;    (setq ss (ssget))
;;;    )
;;;  (if ss (setq lst (ss->lsto* ss)) (exit))
;;;  (mapcar
;;;    '(lambda (x / l)
;;;       (if (null (member (setq l (vla-get-layer x)) laysinss))
;;;	 (setq laysinss (cons l laysinss))
;;;	 )
;;;       )
;;;    lst)
;;;  (setq lname (kd:dcl:pick-from-list  laysinss))
;;;  (sssetfirst nil ss)
;;;  (sssetfirst nil (ssget "_I" (list (cons 8 lname))))
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






  ;; поиск блока в котором элемент "на слое..."


(defun dump|printblocknames (layername / ls blks bnames items)
  ;(setq el (vlax-ename->vla-object (car (entsel))))
  (defun dump|deleteXDict (exd)
    (if (= 0 (vla-get-Count exd))
      (progn (vla-delete exd) (vlax-release-object exd) (setq exd nil))
      (vlax-for e exd (dump|deleteXDict exd))
      )
    )
  (defun check (el / atts)
    (if (= "AcDbBlockReference" (vla-get-objectname el))
      (mapcar '(lambda (att) (check att)) (GETBATTSWCMATCH el "*"))
      (if (member (vla-get-layer el) ls)
	(setq items (cons el items))
	)
    )
  )
  (if (atom layername) (setq ls (list layername)) (setq ls layername))
  ;(setq ls '("СУ_выноски"))
  (mapcar
    '(lambda (l / exd)	;(setq l (car ls))
       (setq exd (vla-item (vla-get-layers #actdoc) l))
       (if (= :vlax-true (vla-get-HasExtensionDictionary exd))
	 (progn
	   (setq exd (vla-GetExtensionDictionary exd))
	   (dump|deleteXDict exd)
	   )
	 )
       )
    ls)
  (setq blks (vla-get-blocks #actdoc))
  (setq blks (cont>list blks))
  (setq blks (vl-remove-if '(lambda (b / n) (setq n (vla-get-name b)) (or (wcmatch n "*Model_Space*") (wcmatch n "*Paper_Space*") (wcmatch n "_ArchTick"))) blks))
  (mapcar
    '(lambda (blk / layer)
       (vlax-for item blk
	 (setq layer (vla-get-Layer item))
	 (if (member layer ls)
	   (setq bnames (cons (vla-get-name blk) bnames))
	   )
	 )
       )
    blks
    )
  (vlax-for item #modspace (check item))
  (list
    bnames
    items
    )
  )

;(setq ans (dump|printblocknames "com_formats-tables"))

;(setq ans (dump|printblocknames "невидимые_аттрибуты"))
;(setq ans (dump|printblocknames "клеммы"))
;(setq ans (dump|printblocknames "СУ_Линии тонкие"))
;(setq ans (dump|printblocknames "Линия"))
;(do (car (cadr ans)))

;(setq ans (dump|printblocknames "СУ"))


;(dump|printblocknames "СУ_Выноски")

;(dump|printblocknames '("СУ"))

;(vla-insertblock #modspace (vlax-3d-point (getpoint)) "dwgB1A1" 1 1 1 0)



;(setq b (vla-item (vla-get-blocks #actdoc) "dwgB1A1"))




(defun blk|getrefs (bname / blk refs)
  (setq blk (vla-item (vla-get-blocks #actdoc) bname))
  (setq refs (mapcar '(lambda (x) (vlax-ename->vla-object (cdr x))) (vl-remove-if-not '(lambda (pp) (= 331 (car pp))) (entget (vlax-vla-object->ename blk)))))
  );defun

;;;
;;;(setq lst
;;;(mapcar
;;;  '(lambda (x)
;;;     (vla-ObjectIDToObject #actdoc (vla-get-OwnerID x))
;;;     )
;;;  (blk|getrefs "dwgB1A1")
;;;  )
;;;      )
;;;
;;;(length lst)
;;;(length (origlist lst))
;;;
;;;(mapcar 'vla-get-name (origlist lst))
;;;
;;;
;;;
