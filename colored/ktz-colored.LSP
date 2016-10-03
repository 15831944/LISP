
(setq #currentcolor acYellow)
;(setq #currentcolor 252)

(defun c:ktz-colored ( / ss ent entg i c )
  (if (null (setq ss (ssget "_I")))
    (setq ss (ssget))
    )
  (mapcar12 vlax-put-property "color" #currentcolor (ss->lsto* ss))
  );defun

(defun c:ktz-colored-0 ( / ss ent entg i c )
  (if (null (setq ss (ssget "_I")))
    (setq ss (ssget))
    )
  (mapcar12 vlax-put-property "color" 256 (ss->lsto* ss))
  );defun





(defun c:colorchange ( / obj layer color)
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (cond
    ((= 256 (vlax-get-property obj "Color"))
     (setq layer (vla-item (vla-get-Layers #actdoc) (vla-get-Layer obj)))
     (setq color (vlax-get-property layer "Color"))
     (setq color (acad_colordlg color 2))
     ;(setq color (acad_truecolordlg color T))
     (vlax-put-property layer "color" color)
     )
    )
  (command "_regenall")
  color
  );defun
