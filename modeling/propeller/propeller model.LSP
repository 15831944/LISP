
(setq V[kmph] 36.0)
(setq V[mps] (/ (* V[kmph] 1000) 3600))
(setq V[mmps] (/ V[mps] 1000))

(setq frq[rpm] 4500.0) ;; rpm
(setq frq[rps] (/ frq[rpm] 60.0))		;;  rotations per second

(setq x0[mm] 25.0)

(setq blade_length[mm] 150.0)

(setq lst-spds '())



(defun drawspeedvecs (/ drawspeedvec x)
  (defun drawspeedvec (x / pt1 pt2 spd[mps] y lay line)
    (setq lay "speed_vectors")
    (vla-add (vla-get-layers #actdoc) lay)
    (setq pt1 (list x 0.0 0.0))

    (setq spd[mps] (* (* 2 pi (/ x 1000)) frq[rps]))

    ;(setq y (* spd[mps] 1000))
    (setq y (* spd[mps] 1))
    (setq pt2 (list x y 0.0))
    (setq line (vla-addLine #modspace (vlax-3d-point pt1) (vlax-3d-point pt2)))
    (vla-put-layer line lay)
    );defun
  ;;;***********************************
  (setq x x0[mm])
  (while (<= x blade_length[mm])
    (drawspeedvec x)
    (setq x (+ x 10))  
    )
  );defun

(drawspeedvecs)


(defun dtr (a)
  (* pi (/ a 180.0))
  )
(defun rtd (r)
  (/ (* 180 r) pi)
  )

(rtd (getangle))	;;80.9569 


