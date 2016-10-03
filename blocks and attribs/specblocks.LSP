(defun kd:specblocks ( / ss i lst)
  (setq ss (ssget '((0 . "INSERT"))))
  (setq lst (mapcar '(lambda (x) (vla-get-EffectiveName (vlax-ename->vla-object x))) (ss->list* ss)))
  (compress-list lst)
  );defun