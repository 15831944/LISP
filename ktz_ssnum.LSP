(defun c:ktz_ssnum (/ ss i ent_i str sslist)
  (setq ss (ssget))
    
  (setq i 0)
  (repeat (sslength ss)
    (setq ent_i (entget (ssname ss i)))
    (setq str (cdr (assoc 1 ent_i)))
    (princ (strcat (itoa i) "_" str "\n"))
    (setq i (1+ i))
   );repeat
  
  (princ)
 ); defun