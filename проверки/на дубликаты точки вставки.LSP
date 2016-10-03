

(if
  (not (setq ss (ssget "_I")))
  (setq ss (ssget '((0 . "INSERT"))))
  )

(setq ss (ss->lsto* ss))
(length ss)
(setq ss (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) '("format" "format-spec"))) ss))


(setq tmp (mapcar 'vla-get-insertionPoint ss))



(defun compress-list (lst / clst)
  (setq clst '())
  (foreach item lst
    (if (assoc item clst)
      (setq clst (subst
		   (list item (1+ (cadr (assoc item clst))))
		   (assoc item clst)
		   clst))
      (setq clst (append clst (list (list item 1))))
      )
    );foreach
  clst
  );defun




(compress-list
(mapcar 'car 
(mapcar 'reverse
(compress-list
(mapcar
  '(lambda (x)
     (vlax-safearray->list (vlax-variant-value (vla-get-insertionPoint x)))
     )
  ss)
)))))



