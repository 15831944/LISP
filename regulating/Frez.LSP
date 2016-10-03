

(setq c "100 pF")
(setq l "40 mkH")



(defun cap:trans (str / val scale)
  (setq val (sepstr str " "))
  (setq scale (cadr val))
  (setq val (atof* (car val)))
  (cond
    ((= "pF") (* val (expt 10.0 -12)))
    ((= "nF") (* val (expt 10.0 -9)))
    ((= "mkF") (* val (expt 10.0 -6)))
    )
  );defun

(defun ind:trans (str / val scale)
  (setq val (sepstr str " "))
  (setq scale (cadr val))
  (setq val (atof* (car val)))
  (cond
    ((= "pH") (* val (expt 10.0 -12)))
    ((= "nH") (* val (expt 10.0 -9)))
    ((= "mkH") (* val (expt 10.0 -6)))
    )
  );defun




(setq frec (/ 1 (* 2 Pi (expt (cap:trans c) (ind:trans L) 0.5))))


(setq f 2 ) ;Hz

(setq LC (/ 1 (expt (* 2 Pi f) 2)))

(* 0.08 0.08)