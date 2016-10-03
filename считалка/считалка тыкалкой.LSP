;;; 13_12_18




(defun c:anum* ( / parlist data smpl)
  (vla-startundomark #actdoc)
  (acet-error-init (list (list	"cmdecho" 0 "expert" nil)T))
  (if (null str+) (load (strcat #lisppath "strings\\str+.lsp")))
  (setq parlist '("Префикс" "нач.цифра" "Суффикс" "Приращение"))
  (if
    (and
      (setq smpl (nentsel))
      (setq smpl (vlax-ename->vla-object (car smpl)))
      (setq smpl (vla-get-TextString smpl))
      (setq smpl (reverse (sepstr* smpl)))
      )
    (setq data (list (antisep (reverse (cdr smpl)) "") (str+ (car smpl)) "" "1"))
    (setq data (kd:dclget parlist))
    )
  (apply 'kd:anum* data)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun



;(setq #bylayer (VLA-GET-TRUECOLOR (vlax-ename->vla-object (car (entsel)))))

(defun kd:anum* (prefix start suff inc / obj)
  (while (setq obj (car (nentsel (strcat "\n текущий номер : " start))))
    ;(setq obj (vlax-ename->vla-object (car (nentsel))))
    (setq obj (vlax-ename->vla-object obj))
    (vla-put-TextString obj (strcat prefix start suff))
;;;    (if (= "AcDbAttribute" (vla-get-ObjectName obj))
;;;      (vla-put-truecolor (vla-ObjectIDToObject #actdoc (vla-get-OwnerID obj)) #bylayer)
;;;      (vla-put-truecolor obj #bylayer)
;;;      )

    (repeat (atoi inc)
      (setq start (str+ start))
      )
    )
  (princ)
  );defun




;;;(setq i 8)
;;;(while (setq e (car (nentsel)))
;;;  (setq eng (entget e))
;;;  (setq eng (subst
;;;	      (cons 1 (itoa i))
;;;	      (assoc 1 eng)
;;;	      eng
;;;	      ))
;;;  (entmod eng)
;;;  (entupd e)
;;;  (setq i (1+ i))
;;;  )