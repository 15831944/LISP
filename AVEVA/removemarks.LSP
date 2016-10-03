(vl-load-com)

(setq ctmp (vla-GetInterfaceObject (vlax-get-acad-object) "AutoCAD.AcCmColor.18"))
(vla-put-entityColor ctmp -1036280892)


(setq ss (ssget "_X" '((0 . "*TEXT")(1 . "999"))))
(setq ss (mapcar 'vlax-ename->vla-object (ss->list* ss)))
(length ss)






(foreach item ss
  (setq lst (getlisttodel item))
  (mapcar '(lambda (x)
	     (if x
	       (vla-Delete x)
	       )
	     ) lst)
  
  )























;(setq txt (vlax-ename->vla-object (car (entsel))))

;(getlisttodel txt)  

(defun getlisttodel (txt999
		     /
		     minp
		     maxp
		     crds
		     tmpss
		     frame
		     arrow
		     pointer
		     )

(vla-GetBoundingBox txt999 'minp 'maxp)
(setq minp (vlax-safearray->list minp))
(setq maxp (vlax-safearray->list maxp))
(setq tmpss (ssget "_C" minp maxp '((0 . "LWPOLYLINE"))))
(setq tmpss (mapcar 'vlax-ename->vla-object (ss->list* tmpss)))

(setq tmpss (vl-remove-if-not '(lambda (x)
	(= 26 (length (vlax-safearray->list (vlax-variant-value(vla-get-Coordinates x)))))
	) tmpss))
(if (= 1 (length tmpss))
  (setq frame (car tmpss))
  (progn
    (alert "\n СлоЖнсти с определением рамки")
    (vla-put-TrueColor txt999 ctmp)
    (exit)
    )
  )
;;; если тут  не вылетает то мы нашли овал рамки

;;; ищем стрелку
(vla-GetBoundingBox frame 'minp 'maxp)
(setq minp (vlax-safearray->list minp))
(setq maxp (vlax-safearray->list maxp))
;погрешность в 1 мм в оба направления
(setq minp (mapcar '- minp '(0.4 0.4 0)))
(setq maxp (mapcar '+ maxp '(0.4 0.4 0)))


(setq tmpss (ssget "_C" minp maxp '((0 . "LWPOLYLINE")(43 . 0.0))))
(setq tmpss (mapcar 'vlax-ename->vla-object (ss->list* tmpss)))
(length tmpss)
(setq tmpss (vl-remove frame tmpss))

(cond
  ((= 1 (length tmpss))(setq arrow (car tmpss)))
  ((= 0 (length tmpss))(setq arrow nil))
  (T (progn
       (alert "\n Нашол много претендентов на СТРЕЛУ")
       (vla-put-TrueColor txt999 ctmp)
       (exit)));T
  );cond


  (if arrow
    (if
      (= 4 (length (setq crds (vlax-safearray->list(vlax-variant-value(VLA-GET-COORDINATEs arrow))))))
      ;then
  (progn
    (setq tmpss (ssget "_F" (list (list
				    (nth 0 crds)
				    (nth 1 crds))
				  (list
				    (nth 2 crds)
				    (nth 3 crds)))
		       '((0 . "LWPOLYLINE")(43 . 0.0))
		       ));setq
    
    (setq tmpss (mapcar 'vlax-ename->vla-object (ss->list* tmpss)))
    (setq tmpss (vl-remove frame tmpss))
    (setq tmpss (vl-remove arrow tmpss))

    (setq tmpss (vl-remove-if-not '(lambda (x)
	(= 6 (length (vlax-safearray->list (vlax-variant-value(vla-get-Coordinates x)))))
	) tmpss))
    (cond
      ((= 1 (length tmpss))(setq pointer (car tmpss)))
      ((= 0 (length tmpss))(setq pointer nil))
      (T
  (progn
    (alert "\n Сложнсти с определением указателя стрелки")
    (vla-put-TrueColor txt999 ctmp)
    (exit)
    )

       )
      )
    );progn
  )
    );if
  (list txt999 frame arrow pointer)
  );defun








(defun ss->list* (ss / i enlst)
  (setq i 0)
  (repeat (sslength ss)
    (setq enlst	(append enlst (list (ssname ss i)))
	  i	(1+ i)
	  ) ;_ setq
    ) ;repeat
  enlst
  ) ;defun


