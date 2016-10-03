(setq bref (vlax-ename->vla-object (car (entsel))))



(setq bdef (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName bref)))

(do bdef)

(vla-put-Name bdef "EL_KM-switch-diagram")


(vla-put-Name
  (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel)))))
  "EL_ÝÏ300-switch-diagram")




(vla-put-Name
  (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel)))))
  "EL_ÌÑÏ")

(vla-put-Name
  (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel)))))
  "EL_ÁÏ")


(vla-put-Name (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel)))))
  "CNCT_clampname")

(vla-put-Name (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel)))))
  "CNCT_clampsign")

(vla-put-Name (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel)))))
  "CNCT_clam")

(vla-put-Name (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel)))))
  "CNCT_clamphoenix")



(vla-put-Name (vla-item (vla-get-blocks #actdoc) (vla-get-EffectiveName (vlax-ename->vla-object (car (entsel)))))
  "EL_relay-T-NO")
