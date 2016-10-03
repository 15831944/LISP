(defun getbdyn (blref propname /)
  (car
    (vl-remove-if-not '(lambda (x) (= propname (vla-get-PropertyName x)))
      (vlax-safearray->list (vlax-variant-value(vla-GetDynamicBlockProperties blref)))
      )
    )
  );defun

(defun getbdynval (blref propname /)
  (vla-get-Value
  (car
    (vl-remove-if-not '(lambda (x) (= propname (vla-get-PropertyName x)))
      (vlax-safearray->list (vlax-variant-value(vla-GetDynamicBlockProperties blref)))
      )
    )
  )
  );defun


;;;(setq blref (vlax-ename->vla-object (car (entsel))))
;;;(setq propname "Size")
;;;(setq val "À4x8")

(defun setbdynval (blref propname val / dps prop av)
  (and
    (= :vlax-true (vla-get-IsDynamicBlock blref))
    (setq dps (vlax-safearray->list (vlax-variant-value (vla-GetDynamicBlockProperties blref))))
    (setq prop (vl-remove-if-not '(lambda (x) (= propname (vla-get-PropertyName x))) dps))
    (= 1 (length prop))
    (setq av (mapcar 'vlax-variant-value (vlax-safearray->list (vlax-variant-value (vla-get-AllowedValues (setq prop (car prop)))))))
    (member val av)
    (vla-put-Value prop val)
    )
  );defun


