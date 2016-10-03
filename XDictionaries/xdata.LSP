(setq #Xdataname "ktz")
(regapp #Xdataname)

(setq obj (vlax-ename->vla-object (car (entsel))))



(defun kd:put-xdata (obj tag val / sa1 sa2)
  (setq sa1 (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger '(0 . 1)) (list 1001 1000)))
  (setq sa2 (vlax-safearray-fill (vlax-make-safearray vlax-vbvariant '(0 . 1)) (list tag val)))
  (vla-SetXData obj sa1 sa2)
  )
(defun kd:get-xdata (obj tag / sa1 sa2)
  (vla-GetXData obj tag 'sa1 'sa2)
  (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
  )

(kd:put-xdata (vlax-ename->vla-object (car (entsel))) "poz" "UC051")
(kd:get-xdata (vlax-ename->vla-object (car (entsel))) "poz")
(do (vla-item (vla-getextensiondictionary (vlax-ename->vla-object (car (entsel)))) 0))






(setq obj (vlax-ename->vla-object (car (entsel))))

      ;,-; #<VLA-OBJECT IAcadLine 0b858eb<3> (regapp "TestApp") ;_ регистрируем приложение
(vla-SetXData obj
  (vlax-safearray-fill (vlax-make-safearray vlax-vbinteger '(0 . 1))
    '(1001 1000))
  (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant '(0 . 1))
    '("TestApp" "Description"))
  )