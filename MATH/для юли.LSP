(setq hip 100)
(setq tg 0.3)

;; a - прилежащий
;; b - противолеж - надо узнать

;;  tg = sin/cos = (b/hip)/(a/hip) = b/hip * hip/a = b/a
;;  b/a = 0.3    ;  a/b = 1/0.3 ; a = b/0.3

;;  a2+b2=hip2
;;  b2/(0.3)2 + b2 = hip2

;;  b2 + (0.3)2b2 = (0.3)2hip2
;;  b2*(1+ (0.3)2) = (0.3)2hip2
;;  b2 = (0.3)2hip2 / (1 + (0.3)2)

(expt
  (/
    (* (expt tg 2) (expt hip 2))
    (+ 1 (expt tg 2))
    )
  0.5
  )