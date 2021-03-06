(setq od (namedobjdict))
(setq diclist '((0 . "DICTIONARY")(100 . "AcDbDictionary")))
(setq dict (entmakex diclist))
(setq cont-dict-name "contacts")
(dictadd od cont-dict-name dict)


(setq contact-data-list
       (list
	 (list "L"
	       (cons "point" '(-5.0 0.0 0.0))
	       (cons "signal type" "220VAC")
	       (cons "polar" "A")
	       )
	 ))

(vlax-ldata-put (vlax-ename->vla-object (car (entsel))) cont-dict-name contact-data-list)

(vlax-ldata-get (vlax-ename->vla-object (car (entsel))) cont-dict-name)
(vlax-ldata-list (vlax-ename->vla-object (car (entsel))))

(defun ktz-vlax-ldata-add (
			   ename
			   cdn
			   datalist
			   /
			   eo
			   tmp
			   )
  (setq eo (vlax-ename->vla-object ename)
	tmp (vlax-ldata-get eo cdn)
	tmp (append tmp datalist))
  (vlax-ldata-put eo cdn tmp)
  );defun
(ktz-vlax-ldata-add (car (entsel)) cont-dict-name contact-data-list)

;;;************************************************************************************************
(setq contact-data-list
       (list
	 (list "N"
	       (cons "point" '(-0.0 0.0 0.0))
	       (cons "signal type" "220VAC")
	       (cons "polar" "N")
	       )
	 ))
(vlax-ldata-put (vlax-ename->vla-object (car (entsel))) cont-dict-name contact-data-list)
(vlax-ldata-get (vlax-ename->vla-object (car (entsel))) cont-dict-name)

(vlax-ldata-list (vlax-ename->vla-object (car (entsel))))
;(vlax-ldata-delete (vlax-ename->vla-object (car (entsel))) "d-signals")
(vlax-ldata-test (vlax-ename->vla-object (car (entsel))))



;;;���������� ��� �-��� vlax-ldata-put ���������� ���� ���������� ������


(car (vlax-ldata-get (vlax-ename->vla-object (car (entsel))) cont-dict-name))
(length (vlax-ldata-get (vlax-ename->vla-object (car (entsel))) cont-dict-name))
(nth 3 (vlax-ldata-get (vlax-ename->vla-object (car (entsel))) cont-dict-name))
(assoc "2" (vlax-ldata-get (vlax-ename->vla-object (car (entsel))) cont-dict-name))

(entget (car (entsel)) '("*"))



(setq contact-data-list
       (list
	 (list "L"
	       (cons "point" '(-5.0 0.0 0.0))
	       (cons "signal type" "220VAC")
	       (cons "polar" "A")
	       (cons "direction" "up")
	       (cons "clamp" "������_STS-2.5-��")
	       )
	 (list "N"
	       (cons "point" '(-0.0 0.0 0.0))
	       (cons "signal type" "220VAC")
	       (cons "polar" "N")
	       )
	 (list "PE"
	       (cons "point" '(5.0 0.0 0.0))
	       (cons "signal type" "PE")
	       (cons "polar" "PE")
	       )
	 (list "1"
	       (cons "point" '(-20.0 -40.0 0.0))
	       (cons "signal type" "4...20��")
	       (cons "polar" "-")
	       )
	 (list "2"
	       (cons "point" '(-15.0 -40.0 0.0))
	       (cons "signal type" "4...20��")
	       (cons "polar" "+")
	       )
	 (list "3"
	       (cons "point" '(-10.0 -40.0 0.0))
	       (cons "signal type" "4...20��")
	       (cons "polar" "-")
	       )
	 (list "4"
	       (cons "point" '(-5.0 -40.0 0.0))
	       (cons "signal type" "4...20��")
	       (cons "polar" "+")
	       )
	 (list "5"
	       (cons "point" '(5.0 -40.0 0.0))
	       (cons "signal type" "4...20��")
	       (cons "polar" "-")
	       )
	 (list "6"
	       (cons "point" '(10.0 -40.0 0.0))
	       (cons "signal type" "4...20��")
	       (cons "polar" "+")
	       )
	 (list "7"
	       (cons "point" '(15.0 -40.0 0.0))
	       (cons "signal type" "4...20��")
	       (cons "polar" "-")
	       )
	 (list "8"
	       (cons "point" '(20.0 -40.0 0.0))
	       (cons "signal type" "4...20��")
	       (cons "polar" "+")
	       )
	 ))



(setq od (namedobjdict))
(setq diclist '((0 . "DICTIONARY")(100 . "AcDbDictionary")))
(setq dict (entmakex diclist))
(setq dict-name "spec")
(dictadd od dict-name dict)

(setq data-list
       (list
	 (list
	   "specification"
	   (cons 1 "������� ���� ������� ����������������, �������� ��� 4 � 50 ��")
	   (cons 2 "�������� ���������� 24 �. ������� ~ 220 � ")
	   (cons 3 "��� ��� � 1")
	   )
	 ))


(vlax-ldata-put (vlax-ename->vla-object (car (entsel))) dict-name data-list)

(vlax-ldata-get (vlax-ename->vla-object (car (entsel))) "contacts")
(vlax-ldata-get (vlax-ename->vla-object (car (entsel))) "spec")