;; из каб жур. делаем таблицу просто вертикальную цельную без форматок



;	1) убираем штамп согласований (который слева)

;; строим форматы вертикально
;;;  см. ktz-frame-move.LSP ftsar

;;  удаляем шьамп
(setq p1 (getpoint) p2 (getpoint))
(vl-cmdf "_zoom" "_all")
(setq ss (ssget "_W" p1 p2))
(sslength ss)
(mapcar
  '(lambda (x)
     ;(vlax-put-property x "color" acYellow)
     (vla-delete x)
     )
  (vl-remove-if
    '(lambda (obj)
       (and
	 (= "AcDbLine" (vla-get-objectname obj))
	 (= 297 (vla-get-Length obj))
	 )
       )
    (ss->lsto* ss)
    )
  )

;	1) убираем шапку таблицы

;; строим форматы горизонтально
;;;  см. ktz-frame-move.LSP ftsar

;;  удаляем шапку
(setq p1 (getpoint) p2 (getpoint))
(vl-cmdf "_zoom" "_all")
(setq ss (ssget "_W" p1 p2))
(sslength ss)
(mapcar
  '(lambda (x)
     ;(vlax-put-property x "color" acYellow)
     (vla-delete x)
     )
  (vl-remove-if
    '(lambda (obj)
       (and
	 (= "AcDbLine" (vla-get-objectname obj))
	 (= 420 (vla-get-Length obj))
	 )
       )
    (ss->lsto* ss)
    )
  )






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun cl|getline (cbpt)
  (mapcar
    '(lambda (cdptc / cp1 cp2)
       ;(setq cdptc (nth 3 dptc))
       (setq cp1 (mapcar '+ cbpt (car cdptc)) cp2 (mapcar '+ cbpt (cadr cdptc)))
       (cellgetdata cp1 cp2)
       )
    dptc
    )
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;(cellgetdata (getpoint) (getpoint))
;  (setq cp1 (getpoint) cp2 (getpoint))
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
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;   вводим верхнй левый угол
(setq bpt (getpoint))
(setq cellHeight 8)
(setq tbheight 500)

;;  вводим    правые нижние точки ячеек первой графы КЖ
(setq lst nil) (while (setq tmp (getpoint)) (setq lst (append lst (list tmp))))


;; вычисляем вектора
(setq dpts (mapcar '(lambda (pt) (mapcar '- pt bpt)) lst))
(setq dptc (mapcar '(lambda (p1 p2) (list (list (car p1) 0 0) (list (car p2) -12 0))) (cons '(0 -12 0) dpts) dpts))





(setq curlinept bpt)
(setq res '())
(while (> (cadr curlinept) (- (cadr bpt) tbheight))
  (setq res (append res (list (cl|getline curlinept))))
  (setq curlinept (mapcar '+ curlinept (list 0 (- cellHeight) 0)))
  )
(length res)

(lst>excel res)










