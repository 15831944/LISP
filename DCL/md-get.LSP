(setq data (excel>lst))

(setq data (mapcar 'car data))


(setq md:textheight 1)

(setq )

(setq exd (vla-GetExtensionDictionary #modspace))


(vla-ZoomExtents #cad)

(vla-put-Width #cad 1500)


(setq ss (ssget "_X"))
(sslength ss)



(setq pts (mapcar '(lambda (x) (cdr (assoc 10 (entget (cadr x))))) (ssnamex ss)))
(setq leftbotpt (list (apply 'min (mapcar 'car pts)) (apply 'min (mapcar 'cadr pts))0.0))

