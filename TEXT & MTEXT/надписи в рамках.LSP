(VL-DOC-EXPORT 'pickobj)

(setq obj (pickobj))


(load (strcat #lisppath "TEXT & MTEXT\mtxtlib.lsp"))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;    ������� � ������    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq tblobj (pickobj))
;nom-naz (("2" "A: 1RX015 pH ���������� ���� �� �������� ��������� ����� ����������\\PB: 1RX016 pH ������������ ���� ����� ����� NH{\\H0.6x;3}") ("1" "A: 1RX001 \U+00E6 ���������� ������������������ ����\\PB: 1RX002 \U+00E6 �������� ���� ������� ������ (������� ������� �����)") ("3" "A: 1RX011 �{\\H0.6x;2} � ���� ���������� �� �������� ��������� ����� ����������\\PB: 1RX012 �{\\H0.6x;2} � ���������� ������� ����� ���") ("5" "A: 1RX017 pH ����������� ���� ����� ������\\PB: 1RX018 pH �������� ���� ������� ������ (������� ������� �����)") ("4" "A: 1RX003 \U+00E6 � H-��������������� ����� ���������� ������� ����� ���\\PB: 1RX004 \U+00E6 � H-��������������� ����� ����������� ���� ����� ������") ("6" "A: 1RX013 �{\\H0.6x;2} � ����������� ���� �� �����������\\PB: 1RX014 ������") ("8" "A: 1RX019 pH �������� ���� �������� ������ ������� �������\\PB: 1RX020 pH �������� ���� �������� ������ ������ �������") ("7" "A: 1RX005 \U+00E6 �������� ���� �������� ������ ������� �������\\PB: 1RX006 \U+00E6 �������� ���� �������� ������ ������ �������") ("9" nil) ("11" nil) ("10" "A: 1RX007 \U+00E6 � H-��������������� ����� ����������� ���� �� �������\\PB: 1RX008 ������") ("12" nil) ("14" nil) ("13" "A: 1RX009 \U+00E6 ����������� ���� �� ������� �������\\PB: 1RX010 \U+00E6 ����������� ���� �� ������ �������") ("15" nil))
;;; ��. data associng.lsp


(setq 1dxy '(7.5 -19 0)
      2dxy '(17 -18 0)
      3dxy '(82.5 -19 0)
      dy 8
      )


(setq tblbpt (vlax-safearray->list (vlax-variant-value (vla-get-InsertionPoint tblobj))))

(setq cpt1 (mapcar '+ tblbpt 1dxy))
(setq cpt2 (mapcar '+ tblbpt 2dxy))
(setq cpt3 (mapcar '+ tblbpt 3dxy))

(mapcar
  '(lambda (line / txto)
     (setq txto
	    (vla-Addtext
	      #modspace
	      (car line)
	      (vlax-3d-point '(0 0 0))
	      2.5
	      )
	   )
     (vla-put-Alignment txto 10)
     (vla-put-TextAlignmentPoint txto (vlax-3d-point (setq cpt1 (mapcar '+ cpt1 '(0 -8 0)))))
     (setq txto
	    (vla-Addtext
	      #modspace
	      "1"
	      (vlax-3d-point '(0 0 0))
	      2.5
	      )
	   )
     (vla-put-Alignment txto 10)
     (vla-put-TextAlignmentPoint txto (vlax-3d-point (setq cpt3 (mapcar '+ cpt3 '(0 -8 0)))))
     
     
     
     (setq txto
	    (vla-AddMtext
	      #modspace
	      (vlax-3d-point
		(setq cpt2 (mapcar '+ cpt2 '(0 -8 0)))
		)
	      56
	      (strcat "{\\W0.9;\\T0.9;" (cadr line))
	      )
	   )
     ;(vla-put-AttachmentPoint  txto 1)
     ;(vla-put-AttachmentPoint o (if (> width 15) 1 2))
     (vla-put-LineSpacingStyle txto acLineSpacingStyleExactly)
     (vla-put-Height txto 2.5)
     (vla-put-LineSpacingDistance txto 8)
     
     (repeat (1- (mtxt:getnumberoflines txto))
       (setq cpt1 (mapcar '+ cpt1 '(0 -8 0)))
       (setq cpt2 (mapcar '+ cpt2 '(0 -8 0)))
       )
     );lambda
  nom-naz)



