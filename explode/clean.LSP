;;; version 12_11_19
(load (strcat #lisppath "strings\\stringlib.lsp"))

;;; commented потомучто в 2014 акаде overkill уже встроен в акад
;;;(setq catchit
;;;       (vl-catch-all-apply
;;;	 'load
;;;	 (list "overkillsup.lsp")
;;;	 )
;;;      )
;;;(load "redir.lsp")
;;;(if (vl-catch-all-error-p catchit)
;;;  (princ (strcat "\n " (vl-catch-all-error-message catchit)
;;;		 "\n  Не установлен пакет Express !!! ..."
;;;		 "\n  Выполнение функции clean приведет к ошибке !!!")))

(load (strcat #lisppath "Explode\\explode-block.LSP"))
(load (strcat #lisppath "Explode\\explode-pline.LSP"))
(load (strcat #lisppath "Explode\\explode-mleader.LSP"))
(load (strcat #lisppath "Explode\\explode-zombie.LSP"))
(load (strcat #lisppath "Explode\\explode-tables.LSP"))
(load (strcat #lisppath "Explode\\explode-tables.LSP"))
(load (strcat #lisppath "XDictionaries\\author.lsp"))

;-----------------------------------------------------------------------------------------
;             MAUN FUNCTION
;-----------------------------------------------------------------------------------------
(defun c:clean ( / txto err *error*)
  (kd|setauthor #modspace #authorInfo)
  ;(kd|getauthor #modspace)
  ;(setq #modspace (vla-get-ModelSpace #actdoc))

  (vla-startundomark #actdoc)
;;;  (acet-error-init
;;;    (list (list "cmdecho" 0
;;;		"highlight" (getvar "highlight")
;;;		"limcheck" 0
;;;		"osmode" 0
;;;		);list
;;;	  T);list
;;;    );acet-error-init
  

  ;(vla-sendcommand #actdoc "_spexplodeall ")
  (vla-sendcommand #actdoc "(cl:delete-fields) ")
  (vla-sendcommand #actdoc "(cl|acad-tables-explode) ")
  (vla-sendcommand #actdoc "(explode-zombies) ")
  (vla-sendcommand #actdoc "(explode-mleaders) ")
  (vla-sendcommand #actdoc "(kd:cleanup) ")
  ;(vla-sendcommand #actdoc "(ktz-clean-overkill) ")
  


  (princ (strcat
	   "\n" "проверить на ФС типы линий с буквами чтобы были снизу вверх"
	   "\n проверить слой errors на наличие ошибок - сломанные поля и \"наезд\" текста,"
	   "\n на общих видах обработать пересечение DIN-реек"
	   "\n                  ДИАМЕТРЫ И КВАДРАТЫ %%C - вопросительные знаки выделены"
	   "\n если разбивались мтексты - проверить наезды текстов т.к. не сохраняется степень сжатия и может быть и межстрочное расстояние"
	   "\n"
	   "\n MLEADERs - если разбивались - поднять их MTEXTs на 0,5"
	   ))

  ;(acet-error-restore)
  (vla-endundomark #actdoc)
  ;(vl-cmdf "_zoom" "o" (vlax-vla-object->ename txto))
  );defun c:clean


;-----------------------------------------------------------------------------------------
;             удаление полей
;-----------------------------------------------------------------------------------------
(defun cl:delete-fields (/ objlist fltr)
  (setq fltr '((-4 . "<OR") (0 . "*TEXT") (0 . "ATTDEF") (0 . "INSERT") (0 . "MULTILEADER") (-4 . "OR>")))
  (setq objlist (ssget "_X" fltr))
  (vl-cmdf "_updatefield" objlist "")
  (if objlist
    (progn
      (setq objlist (mapcar 'vlax-ename->vla-object (ss->list* objlist)))
      (setq objlist (vl-remove-if '(lambda (x) (or (and (= "AcDbMLeader" (vla-get-ObjectName x)) (= 1 (vla-get-ContentType x))) (and (= "AcDbBlockReference" (vla-get-ObjectName x))(= :vlax-false (vla-get-HasAttributes x))))) objlist))
      (mapcar 'delete-field objlist)
      )
    )
  );defun clean-delete-fields




(defun cl|str|diameter-symbol-fix ( / lst res)
  (setq lst (ss->lsto* (ssget "_X" '((0 . "*TEXT")))))
  (setq res (vl-remove-if-not '(lambda (x) (wcmatch (kd-get-textstring x) "*%%C*,*%%c*,*\U+2205*")) lst))
  ;(sssetfirst nil (lst-to-ss res))
  (mapcar
    '(lambda (obj / x)
       (setq x (kd-get-textstring obj))
       (cond
	 ((vl-string-search "%%C" x) (while (vl-string-search "%%C" x) (setq x (vl-string-subst "\U+E712" "%%C" x))))
	 ((vl-string-search "%%c" x) (while (vl-string-search "%%c" x) (setq x (vl-string-subst "\U+E712" "%%c" x))))
	 ((vl-string-search "\U+2205" x) (while (vl-string-search "\U+2205" x) (setq x (vl-string-subst "\U+E712" "\U+2205" x))))
	 )
       (vla-put-textstring obj x)
       )
    res
    )
  ;"\U+2205"
  ;"%%C"
  ;"\U+E712"
  ;"{\\Fcs_gost2304|c186;\U+E712}"
  ;(vla-put-TextString (vlax-ename->vla-object (car (entsel))) "\U+2205")
  ;(vla-put-TextString (vlax-ename->vla-object (car (entsel))) "%%C")
  ;(vla-put-TextString (vlax-ename->vla-object (car (entsel))) "\U+E712")
  ;(vla-put-TextString (vlax-ename->vla-object (car (entsel))) "{\\Fcs_gost2304|c186;\U+E712}")
  );defun















;-----------------------------------------------------------------------------------------
;             удаление наезжающих линий
;-----------------------------------------------------------------------------------------
(defun ktz-clean-overkill ()
  (acet-overkill2 (list (ssget "_X") (max 0.000001 1.0e-08) '(390 62) nil nil nil))
  );defun

;-----------------------------------------------------------------------------------------
;             разбивание блоков и полиилиний, учистка мусора
;-----------------------------------------------------------------------------------------
(defun kd:cleanup ( / lays errlay  ss i ltodel  err)
  (setq black (vla-GetInterfaceObject (vlax-get-acad-object) (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2))))
  (vla-put-entityColor black -1023409926)
  (setq lays (vla-get-Layers #actdoc))
  (setq errlay (vla-add lays "errors"))
  (vla-put-Plottable errlay :vlax-false)
  (vla-SetRGB #color 250 100 100)
  (vlax-put-property errlay "Truecolor" #color)
  (vla-regen #actdoc 0)
  (setq ss (ssget "_X" '((0 . "INSERT"))))
  (if ss (mapcar '(lambda (x) (block-explode (vlax-ename->vla-object x))) (ss->list* ss)))
  (setq ltodel '())
  (setq lays (vla-get-Layers #actdoc ))
  (vlax-for lay lays (if (= :vlax-false (vla-get-plottable lay)) (setq ltodel (append ltodel (list lay)))))


  ;(setq obj (vlax-ename->vla-object (car (entsel))))
  

  (vlax-for obj #modspace
  ;(kd-container->list #modspace)

  ;(mapcar
   ; '(lambda (obj)
      (cond
	;;; objs to delete
	((or
	   (and
	     (or
	       (= "AcDbText" (vla-get-ObjectName obj))
	       (= "AcDbMText" (vla-get-ObjectName obj)))
	     (or
	       (= "" (vla-get-textstring obj))
	       (= " " (vla-get-textstring obj))
	       (= "  " (vla-get-textstring obj))
	       (= "Копировал" (vla-get-textstring obj)))
	     );and
	   (member (vla-get-layer obj) (mapcar 'vla-get-name ltodel))
	   );or
	 (vla-Delete obj))
	;;;;; lineweight
	((and (vlax-property-available-p obj "Lineweight") (= 0 (vla-get-lineweight obj)))
	 (vla-put-lineweight obj acLnWtByLayer))
;;;	;;;;;;;polylines
;;;	((and (vlax-read-enabled-p obj) (= "AcDbPolyline" (vla-get-ObjectName obj)))
;;;	 (explode-pline obj))
      ; MULTILEADERS
;;;      ((= "AcDbMLeader" (vla-get-ObjectName obj))
;;;       (explode-mleader obj))
	);cond
      );vlax-for


  
  
    (vlax-for obj #modspace
      (cond
	((= "AcDbPolyline" (vla-get-ObjectName obj))
	 (explode-pline obj))
	)
      )
      


  
  (mapcar '(lambda (x)
	     (if (null (vlax-erased-p x))
	       (setq err (vl-catch-all-apply 'vla-delete (list x)))
	       )
	     (vlax-release-object x)
	     )
	     ltodel)
  (if err (vl-catch-all-error-message err))
  
;;;  (foreach layer ltodel
;;;    (setq ss (ssget "_X" (list (cons 8 (vla-get-name layer)))))
;;;    (if ss (vl-cmdf "_erase" ss ""))
;;;    )
  (vla-purgeall #actdoc )
  (cl|str|diameter-symbol-fix)
  err
  );defun



;;;(defun clean-mleaders-explode ( / ss)
;;;  (setq ss (ssget "_X" '((0 . "MULTILEADER"))))
;;;  (sssetfirst nil ss)
;;;  (vla-sendcommand #actdoc "_explode ")
;;;  ;(vla-sendcommand #actdoc " ")
;;;  ;(command "_.explode ")
;;;  );
;;;
;;;
;;;
;;;(defun clean-mtxt-explode ( / ss)
;;;  (setq ss (ssget "_X" '((0 . "MTEXT"))))
;;;  (sssetfirst nil ss)
;;;  (vla-sendcommand #actdoc "_explode ")
;;;  ;(vla-sendcommand #actdoc " ")
;;;  ;(command "_.explode ")
;;;  );


;;;(setq ss (ssget "_X" '((0 . "DIMENSION"))))
;;;(sssetfirst nil ss)
;;;(vla-sendcommand #actdoc "_explode ")
;;;
;;;
;;;(setq ss (ssget "_X" '((0 . "MULTILEADER"))))
;;;(sssetfirst nil ss)
;;;(vla-sendcommand #actdoc "_explode ")