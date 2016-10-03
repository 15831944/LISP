(setq bl (car (entsel)))
(setq blo (vlax-ename->vla-object (car (entsel))))







(setq blo (vlax-ename->vla-object (car (entsel))))

(setq catch (vl-catch-all-apply 'vla-explode (list blo)))


(cond
  ((= (type catch) 'VLA-OBJECT)
   (princ))
  ((= (type catch) 'VARIANT)
   (princ))
  ((= (type catch) 'VL-CATCH-ALL-APPLY-ERROR)
   (VL-CATCH-ALL-ERROR-MESSAGE catch))
  )













(defun lispru-ent-modify-ename (/ ent layer)
  (setq layer "Layer_Ent"
        ent   (entmakex
                '((0 . "LINE")
                  (10 0. 0. 0.)
                  (11 10. 100. 0.)
                  )
                ) ;_ end of entmakex
        ) ;_ end of setq
  (entmod (entmod (subst (cons 8 layer)
                         (assoc 8 (entget ent))
                         (entget ent)
                         ) ;_ end of subst
                  ) ;_ end of entmod
          ) ;_ end of entmod
  ) ;_ end of defun





(defun lispru-ent-modify-vla1 (/ ent layer)
  (vl-load-com)
  (setq layer "Layer_Vla"
        ent   (vla-addline
                (vla-get-modelspace
                  (vla-get-activedocument (vlax-get-acad-object))
                  ) ;_ end of vla-get-ModelSpace
                (vlax-3d-point '(100. 0. 0.))
                (vlax-3d-point '(110. 100. 0.))
                ) ;_ end of vla-addline
        ) ;_ end of setq
  (vla-put-layer ent layer)
  ) ;_ end of defun






