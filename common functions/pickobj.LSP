;;; ÄÎÁÀÂÈÒÜ ÎÁÐÀÁÎÒÊÓ ESC
(defun pickobj (/ catchit)
  (setq catchit (vl-catch-all-apply 'entsel '("\nPick an entity...")))
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type catchit)) (princ (VL-CATCH-ALL-ERROR-MESSAGE catchit)))
    ((null catchit)(pickobj))
    (T (vlax-ename->vla-object (car catchit)))
    )
  );defun
