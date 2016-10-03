


(setq doc (vla-get-activedocument (vlax-get-acad-object)))



(vlax-dump-object
    prop
    T
    )

(vlax-dump-object
    (setq prop (vla-get-Dictionaries doc))
    T
    )


(setq prop (vla-get-Dictionaries prop))




(vlax-for x
   prop
    (vlax-dump-object x T)
    (princ "\n")
    )




(vlax-dump-object
(vla-item prop 12)
    T
    )

(setq prop (vla-item prop 12))











(setq obj (vlax-ename->vla-object (car (entsel))))
(vla-GetExtensionDictionary obj)
(vlax-dump-object
(vla-GetExtensionDictionary obj)
    T
    )