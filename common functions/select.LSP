;;; днаюбхрэ напюанрйс ESC
(defun entsel* ( str / catchit)
  ;(setq str "asd")
  (setq catchit (vl-catch-all-apply 'entsel (list str)))
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type catchit)) (VL-CATCH-ALL-ERROR-MESSAGE catchit))
    ((= 'LIST (type catchit)) catchit)
    (T nil)
    )
  );defun

(defun nentsel* ( str / catchit)
  ;(setq str "asd")
  (setq catchit (vl-catch-all-apply 'nentsel (list str)))
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type catchit)) (VL-CATCH-ALL-ERROR-MESSAGE catchit))
    ((= 'LIST (type catchit)) catchit)
    (T nil)
    )
  );defun



(defun ssget* (fltr / ss)
  (if (not (setq ss (ssget "_I" fltr)))
    (setq ss (vl-catch-all-apply 'ssget (list fltr)))
    )
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type ss)) (VL-CATCH-ALL-ERROR-MESSAGE ss))
    ((= 'PICKSET (type ss)) ss)
    (T nil)
    )
  );defun