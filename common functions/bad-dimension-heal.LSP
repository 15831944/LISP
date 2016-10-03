


(defun c:bdh (/ lst)
  (vla-startundomark #actdoc)
  (setq lst (ss->lsto* (ssget)))
  (mapcar 'bad-dimension-heal lst)
  (vla-endundomark #actdoc)
  )



(defun bad-dimension-heal (obj / exd)
  (if
    (and
      (= :vlax-true (vla-get-HasExtensionDictionary obj))
      (setq exd (vla-GetExtensionDictionary obj))
      )
    (progn
      (mapcar '(lambda (x) (if (= "AcDbZombieObject" (vla-get-ObjectName x)) (vla-delete x))) (cont>list exd))
      (if (= 0 (vla-get-Count exd)) (vla-delete exd))
      )
    )
  );defun

