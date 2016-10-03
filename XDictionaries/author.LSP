; 16_05_04

(load (strcat #lisppath "XDictionaries\\XDictlib.LSP"))



(setq
  #authorInfo
   (strcat
     "Подолинский Е.О.;" " "
     "I&E(ACS) designer / инженер-проектировщик полевого уровня АСУТП;" " "
     "mailto:podolinsky.e@gmail.com;" " "
     "+375296612534;" " "
     "Беларусь, Минск;" " "
     (strcut (rtos (getvar "CDATE") 2 16) 0 4)
     ))
      

;(kd|setauthor (vlax-ename->vla-object (car (entsel))) "Подолинский Е. О.")
(defun kd|setauthor (obj name / exd authXR)
  (setq exd (vla-GetExtensionDictionary obj))
  (if (null (member "author" (XD|GETNAMES exd)))
    (setq authXR (vla-AddXRecord exd "author"))
    (setq authXR (vla-item exd "author"))
    )
  (XD|XR|SETDATA authXR (list name))
  );defun



(defun c:kd|getauthor () (kd|getauthor (vlax-ename->vla-object (car (entsel)))))
(defun c:kd|getauthor () (kd|getauthor (vlax-ename->vla-object (car (nentsel)))))
(defun kd|getauthor ( obj / exd authXR)
  (if (and (= :vlax-true (vla-get-HasExtensionDictionary obj))
	   (setq exd (vla-GetExtensionDictionary obj))
	   (member "author" (XD|GETNAMES exd)))
    (XD|XR|getdata (vla-item exd "author"))
    )
  );defun




;;;(setq fn (lambda ( / ss )
;;;	   (if (not (setq ss (ssget "_I"))) (setq ss (ssget)))
;;;	   (if ss (mapcar '(lambda (x) (kd|setauthor x "Подолинский Е.О.; ACS designer / инженер-проектировщик полевого уровня АСУТП; podolinsky.e@gmail.com; +375296612534; Беларусь, Минск; 2016")) (ss->lsto* ss)))
;;;	   ))
;;;(setq fn (lambda ( / ss )
;;;	   (if (not (setq ss (ssget "_I"))) (setq ss (ssget)))
;;;	   (if ss (mapcar '(lambda (x) (kd|setauthor x "Подолинский Е. О.")) (ss->lsto* ss)))
;;;	   ))
;;;(setq fn (lambda ( / ss )
;;;	   (if (not (setq ss (ssget "_I"))) (setq ss (ssget)))
;;;	   (if ss (mapcar '(lambda (x) (kd|setauthor x "")) (ss->lsto* ss)))
;;;	   ))



;;;(setq fn (lambda ( / ss )
;;;	   (if (not (setq ss (ssget "_I"))) (setq ss (ssget)))
;;;	   (if ss (mapcar '(lambda (x) (kd|setauthor x #authorInfo)) (ss->lsto* ss)))
;;;	   ))
;;;
;;;(fn)
