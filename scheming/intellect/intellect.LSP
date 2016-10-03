
;(setq el "C1")



;;;(defun declare (el)
;;;(apply 'set (list
;;;   (read (strcat el ".obj"))
;;;   (list
;;;     ("eltype" "capacitor")
;;;     ("contacts" "1" "2")
;;;     ("const" "50") ;;; постоянная величина, характеризующая элемент
;;;     )))

(setq el "R1")

(defun declare (el)
  (apply 'set (list
   (read (strcat el ":data"))
   '(
     ("eltype" "resistor")
     ("contacts" "1" "2")
     ("const" "50") ;;; Ом ;;; постоянная величина, характеризующая элемент
     ;("funcU" "")
     )))
  (apply 'defun (list
    (read (strcat el ":fU"))
    '(u)
    (list '- 'u (list '* (list 'read (strcat el ":fI")) 50))
    ))


  );defun


(setq el "R")

(defun R:fU (u) (princ "asd"))

(defun dofun (el)
  )