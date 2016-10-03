;;; прога выдает список для общих данных
;;; извлекает данные из блокоа типа format
;;; дописать консолидацию по одноименным чертежам
;;; create date 11_02_28
;;; modify date 11_05_25
;;; actuality date 11_10_28

;;;
;;;
;;;(defun formats-to-list (
;;;                        /
;;;                        doc
;;;			osmode
;;;                        ms
;;;                        lof
;;;                        )
;;;  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
;;;  (vla-startundomark doc)
;;;
;;;  (setq osmode (getvar "osmode"))
;;;  (setvar "osmode" 0)
;;;  
;;;  (acet-error-init
;;;    (list (list "cmdecho" 0
;;;		"highlight" (getvar "highlight")
;;;		"limcheck" 0
;;;		);list
;;;	  T
;;;	  );list
;;;    );acet-error-init
;;;
;;;    (setq lof '())
;;;    
;;;
;;;    (setq ms (vla-get-modelspace doc))
;;;
;;;    (vlax-for o ms
;;;        (if (and
;;;                (vlax-property-available-p o "Effectivename")
;;;                (= "format" (vla-get-Effectivename o))
;;;                )
;;;            (setq lof (append lof (list o)))
;;;            );if
;;;        )
;;;
;;;    (setq lof (mapcar '(lambda (x)
;;;                           (list
;;;                               (getbatt* x "НОМЕР_ЛИСТА")
;;;                               (strcat
;;;                                   (getbatt* x "ЧЕРТЕЖ1")
;;;                                   " "
;;;                                   (getbatt* x "ЧЕРТЕЖ2")
;;;                                   " "
;;;                                   (getbatt* x "ЧЕРТЕЖ3")
;;;                                   )
;;;                               )
;;;                           )
;;;                      lof))
;;;    (setq lof (vl-sort lof '(lambda (a b)
;;;                                (< (atof(car a))
;;;                                   (atof(car b)))
;;;                                )))
;;;  (acet-error-restore)
;;;  (vla-endundomark doc)
;;;  (setvar "osmode" osmode)
;;;  lof
;;;  );defun

(vl-load-com)
(defun getformats (
		   /
		   lst
		   )
  (setq lst (ss->list* (ssget "_X" '((0 . "INSERT")))))
  (setq lst (mapcar 'vlax-ename->vla-object lst))
  (setq lst (vl-remove-if-not '(lambda (x) (= "format" (vla-get-EffectiveName x)))
	      lst))
  )

(setq flst (getformats))


(setq txtlist
       (mapcarx vla-get-TextString nil
		(mapcar '(lambda (x)
			   (getbatts x '("НОМЕР_ЛИСТА" "ЧЕРТЕЖ1" "ЧЕРТЕЖ2" "ЧЕРТЕЖ3")))
			flst)
		))
(setq odlst '())

(foreach data txtlist
  (setq odlst (append odlst (list (list (car data) (strcat (nth 1 data) " " (nth 2 data) " " (nth 3 data))))))
  )

(vl-sort odlst '(lambda (a b) (< (car a) (car b))))














(defun clamp-content (
		      /
		      doc
		      ss
		      i
		      lst
		      )
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
  ;;;===========================================================================================
  (setq ss (ssget '((0 . "INSERT"))))
  (setq lst (mapcar '(lambda (x) (vla-get-EffectiveName (vlax-ename->vla-object x)))
		    (ss->list* ss))
	lst (compress-list lst))
  ;;;===========================================================================================
  (acet-error-restore)
  (vla-endundomark doc)
  lst
  );defun



(defun compress-list (lst / clst)
  (setq clst '())
  (foreach item lst
    (if (assoc item clst)
      (setq clst (subst
		   (list item (1+ (cadr (assoc item clst))))
		   (assoc item clst)
		   clst))
      (setq clst (append clst (list (list item 1))))
      )
    );foreach
  clst
  );defun
