;; 14_03_04
;;  �������� �� ������ ��������� ������������ ���������� ����������

;;;'((-1 . <Entity name: 7ee79518>)
;;;  (0 . "BLOCK_RECORD")
;;;  (5 . "16BB")
;;;  (102 . "{ACAD_XDICTIONARY")
;;;  (360 . <Entity name: 7ee79520>)
;;;  (102 . "}")
;;;  (330 . <Entity name: 7ee75c08>)
;;;  (100 . "AcDbSymbolTableRecord")
;;;  (100 . "AcDbBlockTableRecord")
;;;  (2 . "*U17")
;;;  (360 . <Entity name: 7ee79530>)
;;;  (340 . <Entity name: 0>)
;;;  (102 . "{BLKREFS")
;;;  (331 . <Entity name: 7ee5e3b8>)
;;;  (331 . <Entity name: 7eea1300>)
;;;  (331 . <Entity name: 7eea1468>)
;;;  (102 . "}")
;;;  (70 . 0)
;;;  (280 . 1)
;;;  (281 . 1)
;;; )
;;;
;;;'((102 . "{BLKREFS")
;;;  (331 . <Entity name: 7ee5e3b8>)
;;;  (331 . <Entity name: 7eea1300>)
;;;  (331 . <Entity name: 7eea1468>)
;;;  (102 . "}")
;;; )

(defun cutlist (eng start end / eng1 tail ans cpp)
  (if (null end)
    (member start eng)
    (progn
      (setq eng1 (member start eng))
      (setq tail (member end eng1))
      (defun fnc (a b) (if (and (= (length b) 1) (= (car b) (car a))) a (fnc (cdr a) (cdr b))))
      (reverse (fnc (reverse eng1) (reverse tail)))
      )
    )
  )
;(cutlist '("a" "b" "x" "c" "d" "y" "e" "f" "x" "g" "y") "x" "y")
;(cutlist '("a" "b" "x" "c" "d" "y" "e" "f" "x" "g" "y") "x" nil)
;(cutlist '("a" "b" "x" "c" "d" "y" "e" "f" "x" "g" "y") nil "y")
