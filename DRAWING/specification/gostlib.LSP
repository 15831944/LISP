;;; 14_02_12
;;; GOST


(setq #gost|Dy-DN
   '((10 16) (15 20) (20 26) (25 32) (32 42)
     (32 38)		; хз, технологи написали но 38 - не стандартный
     (40 45) (50 57) (65 76) (80 89) (100 108) (125 133) (150 159) (200 219) (225 245)
     (250 273) (300 325) (400 426) (500 530) (600 630) (800 820) (1000 1020) (1200 1220)
     )
      );setq
;; convert DN to Dy
(defun gost:Dnar>Dy (Dnar)
  (cadr (assoc Dnar (mapcar 'reverse #gost|Dy-DN)))
  );defun
;(gost:Dnar>Dy 530)


(defun gost:Dy>Dnar (Dy)
  (cadr (assoc Dy #gost|Dy-DN))
  );defun