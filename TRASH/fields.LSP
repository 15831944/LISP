(defun c:Paste_Field ()
  (setq ent (entsel))
  (prin1 "Укажите местоположение")
  (setq pt (getpoint))
  (command '(pt) pause pause)
  (princ)
)


;(defun deg2rad (deg)
;  (* deg (/ pi 180))
;)