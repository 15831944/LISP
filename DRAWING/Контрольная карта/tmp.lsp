
(initget 128 "�������� ������")
(setq ruk (getkword " ������� ���. ������ [��������/������] <��������>"))
(if (= "������" ruk)
  (setq ruk (getstring))
  )
(princ "end")
(initget "�������� _�")
(setq ruk (getstring "������� ���. ������ <��������>"))





(while (null od)
  (setq od (entsel "\n������� �������� ����� ������"))
  )
(setq od (vlax-ename->vla-object (car od)))

(setq nplay (vla-add (vla-get-layers #actdoc) "non printed"))
(vla-put-plottable nplay 0)
(vlax-put-Property nplay "Truecolor" #color)

(setq ip (getpoint "\n������� ����� �������"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LINES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(line "non printed"
(MAPCAR '+ IP '(210.0 0.0 0.0)) 
(MAPCAR '+ IP '(0.0 0.0 0.0)) 
      )
(line "non printed"
(MAPCAR '+ IP '(0.0 0.0 0.0)) 
(MAPCAR '+ IP '(0.0 -297.0 0.0)) 
      )
(line "non printed"
(MAPCAR '+ IP '(210.0 -297.0 0.0)) 
(MAPCAR '+ IP '(210.0 0.0 0.0)) 
      )
(line "non printed"
(MAPCAR '+ IP '(0.0 -297.0 0.0)) 
(MAPCAR '+ IP '(210.0 -297.0 0.0)) 
      )

;(setq ipo (getpoint "\n������� ����� ������� �������"))




(defun vl-generating ( / file hand lin)
  (defun line (l pt1 pt2 / lo p1 p2)
    (setq lo (vla-addLine #modspace
	       (vlax-3d-point pt1) (vlax-3d-point pt2)
	       ))
    (vla-put-layer lo l)
    )
  (setq file "d:\\generated.lsp"
	hand	(open file "w"))
  (while (setq lin (vlax-ename->vla-object (car (entsel))))
    
  (prin1 
(list 'line "non printed"
      (list 'mapcar ''+ 'ip (append '(list) (mapcar '- (vlax-safearray->list (vlax-variant-value (vla-get-startpoint lin))) ipo)))
      (list 'mapcar ''+ 'ip (append '(list) (mapcar '- (vlax-safearray->list (vlax-variant-value (vla-get-endpoint lin))) ipo)))
      )
hand
)
    )
  (close hand)
  );defun

