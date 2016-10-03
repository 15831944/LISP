
;;;    !!!!!    старое говно, см. spec2data

(load (strcat #lisppath "common functions/format-identification-gost.lsp"))


;;	убираем 2 первых листа кабельноо журнала
;;  	на остальных:

(setq lst (get-kol-uch))
(setq scale (/ (cdr (assoc 40 (entget (car lst)))) 2.5))


;	'([number]	[width] 	[height] 	[entity]		[([blpt] 		[urpt])])
;	("73.12" 	420.0		297.0 	<Entity name: 7e85eab0>		((10643.0 -1301.5) (11063.0 -1004.5))) 


(setq lst (mapcar '(lambda (x / pts)	;(setq x (car lst))
		       (progn
			 (setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch x)))
			 (list
			   (get-lnumber x)
			   (abs (- (car (cadr pts)) (car (car pts))))
			   (abs (- (cadr (cadr pts)) (cadr (car pts))))
			   x
			   pts
			   )
			 )
		     ) lst))
(setq lst (vl-sort lst '(lambda (a b) (< (atoi (cadr (sepstr (car a) "."))) (atoi (cadr (sepstr (car b) ".")))))))



;;;   выстраиваем  листы
(setq startpt (getpoint) cpt startpt)
(setq dir (getangle cpt))
(setq delta 15)

(mapcar
  '(lambda (line / p1 p2 )	;(setq line (car lst))
     (setq p1 (car (last line)))
     (setq p2 (cadr (last line)))
     (vl-cmdf "_.zoom" p1 p2)
     (setq cpt (polar cpt dir (+ (nth 2 line) delta)))
     (mapcar '(lambda (x) (vla-move x (vlax-3d-point p1) (vlax-3d-point cpt)) )(ss->lsto* (ssget "_C" p1 p2)))
     )
  lst
  )





;;  переделываем данные по новым расположениям форматок

(setq lst (mapcar '(lambda (l) (nth 3 l)) lst))
(setq lst (mapcar '(lambda (x / pts)	;(setq x (car lst))
		       (progn
			 (setq pts (get-formatpts<-rightformatline (get-rightformatline<-koluch x)))
			 (list
			   (get-lnumber x)
			   (abs (- (car (cadr pts)) (car (car pts))))
			   (abs (- (cadr (cadr pts)) (cadr (car pts))))
			   x
			   pts
			   )
			 )
		     ) lst))
(setq lst (vl-sort lst '(lambda (a b) (< (atoi (cadr (sepstr (car a) "."))) (atoi (cadr (sepstr (car b) ".")))))))



(mapcar
  '(lambda (line / blpt ss)	;(setq line (car lst))
     (setq blpt (car (last line)))
     (vl-cmdf "_.zoom" blpt (cadr (last line)))
     (setq ss (ssget "_W" blpt (mapcar '+ blpt '(25 100))) )
     ;(sssetfirst nil ss)
     (if ss (mapcar 'vla-delete (ss->lsto* ss)))
     )
  lst
  )







;	'([number]	[width] 	[height] 	[entity]		[([blpt] 		[urpt])])
;	("73.12" 	420.0		297.0 	<Entity name: 7e85eab0>		((10643.0 -1301.5) (11063.0 -1004.5))) 
(mapcar
  '(lambda (line / blpt ss)	;(setq line (car lst))
     (setq blpt (car (last line)))
     (vl-cmdf "_.zoom" blpt (cadr (last line)))
     (setq ss (ssget "_W"
		     (mapcar '+ blpt (list -10 (+ 5 (nth 2 line))))
		     (mapcar '+ blpt (list (+ 5 (nth 1 line)) (- (nth 2 line) 21)))
		     ))
     ;(sssetfirst nil ss)
     (if ss (mapcar 'vla-delete (ss->lsto* ss)))
     )
  lst
  )






;	'([number]	[width] 	[height] 	[entity]		[([blpt] 		[urpt])])
;	("73.12" 	420.0		297.0 	<Entity name: 7e85eab0>		((10643.0 -1301.5) (11063.0 -1004.5))) 
(mapcar
  '(lambda (line / blpt ss)	;(setq line (car lst))
     (setq blpt (car (last line)))
     (vl-cmdf "_.zoom" blpt (cadr (last line)))
     (setq ss (ssget "_C"
		     (mapcar '+ blpt (list -1 -1))
		     (mapcar '+ blpt (list (+ (nth 1 line) 1) 21))
		     ))
     ;(sssetfirst nil ss)
     (if ss (mapcar 'vla-delete (ss->lsto* ss)))
     )
  lst
  )








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cl|getline (cbpt) (mapcar '(lambda (cdptc / cp1 cp2) (setq cp1 (mapcar '+ cbpt (car cdptc)) cp2 (mapcar '+ cbpt (cadr cdptc))) (cellgetdata cp1 cp2)) dptc))
(defun cellgetdata (cp1 cp2 / sso tmp str)
  (setq sso (vla-get-ActiveSelectionSet #actdoc))
  (vla-Clear sso)
  (vl-cmdf "_zoom" "_W" cp1 cp2)
  (vla-select sso
    acSelectionSetWindow
    (vlax-3d-point cp1) (vlax-3d-point cp2)
    (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 0)) '(0))
    (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 0)) '("*TEXT"))
    )
  (cond
    ((= 0 (vla-get-Count sso)) (setq str ""))
    ((= 1 (vla-get-Count sso)) (setq str (kd-get-textstring (vla-item sso 0))))
    (T
     (setq tmp (kd-container->list sso))
     (setq tmp (vl-sort tmp '(lambda (a b) (> (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b)))) (car (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a))))))))
     (setq tmp (vl-sort tmp '(lambda (a b) (> (- (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint a)))) (cadr (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint b))))) 2.5))))
     (setq str (antisep (mapcar 'kd-get-textstring tmp) " "))
     )
    )
  (vlax-release-object sso)
  (setq sso nil)
  str
  )







(setq startpt (mapcar '+ '(20 -23) startpt))
;(vla-AddCircle #modspace (vlax-3d-point startpt) 5)
;(setq startpt (getpoint))
(setq dstr 12)


;;  вводимправые нижние точки ячеек первой графы КЖ
(setq rangelist nil)
(while (setq range (getdist (mapcar '+ startpt '(0 -12))))
  (setq rangelist (cons range rangelist))
  )(setq rangelist (reverse rangelist))

;; вычисляем вектора

(setq dptc (mapcar 'list
;; левые верхние точки 
(mapcar '(lambda (r) (mapcar '+ '(0 0 0) (list r 0 0))) (cons 0 (reverse (cdr (reverse rangelist)))))
;; правые нижние точки 
(mapcar '(lambda (r) (mapcar '+ '(0 0 0) (list r (- dstr) 0))) rangelist)
	))



(setq cpt startpt)
(setq result '())
(setq tbheight 10000)


(while (> (cadr cpt) (- (cadr startpt) tbheight))
  (setq result (cons (cl|getline cpt) result))
  (setq cpt (mapcar '+ cpt (list 0 (- dstr) 0)))
  )

(setq res (vl-remove-if '(lambda (lst) (apply '= lst) ) result))


(lst>excel (reverse res))

