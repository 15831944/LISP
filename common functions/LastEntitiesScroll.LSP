;	бит	згнач
;	0	1	Возвращает координаты при движении устройства указания. Результат — список, первый элемент которого — число 5. второй — список с координатами (X, Y) считанной точки
;	1	2	Обрабатывает результаты ввода данных с любого устройства, в том числе нажатия функциональных и обычных клавиш. Не перемещает перекрестие, если пользователь нажмет кнопку устройства указания
;	2	4	Использует форму курсора, заданную аргументом <курсор>
;	3	8	Не выводит сообщение об ошибке, если пользователь нажал клавишу <Esc>


(load (strcat #lisppath "MATH\\" "hex-dec.lsp"))



(defun c:laescr ()
  (vla-StartUndoMark #actdoc)
  (lastEntitiesScroll)
  (vla-EndUndoMark #actdoc)
  )


(defun lastEntitiesScroll ( / ent 
			   time
			   listenMouse
			   listenKeys pow2lst digitVals
			   cursorType
			   obj
			   )
  (setq pow2lst '(0 1 2 3))	; степени двойки (разряд, бит)
  (setq digitVals '(1 1 1 1))	; значения битов
  (setq listenKeys (apply 'logior (mapcar '(lambda (d p) (lsh d p)) digitVals pow2lst)))
  (setq time T)
  (setq ent (entlast))
  (setq listenMouse T)	; T - lesten, nil - not
  (setq cursorType 0)	; 0 - normal, 1- nocursor, 2 - obj entsel cursor

  (sssetfirst nil (ssadd ent))
  
  (while time
    (setq drag (vl-catch-all-apply 'grread (list listenMouse listenKeys cursorType)))
    (if (vl-catch-all-error-p drag) (progn (princ "\nCommand: *Cancel*") (setq time nil))
      (progn
	(cond
	  ;((= 5 (car drag)))
	  ;((= 3 (car drag)))
	  ((and
	     (= 2 (car drag))
	     (= 32 (cadr drag))
	     )
	   (setq obj (vla-HandleToObject #actdoc (DEC>HEX (1- (HEX>DEC (vla-get-Handle (vlax-ename->vla-object ent)))))))
	   (setq ent (vlax-vla-object->ename obj))
	   (sssetfirst nil (ssadd ent))
	   )
	  )
	)
      )
    )
  (princ)
  );defun