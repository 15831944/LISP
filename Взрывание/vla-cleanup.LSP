;;; �������� 10_06_01
;;; ������ ��������� � ���������� ������ :
;;; vla-cleanup
;;; ����� ��� ���������� ������ � ������� ����� �� ������
;;; ��������� �����, ����-�������, ���������,
;;; ��������!!! ��� �������� ������ �� ������� ����� �������
;;; ������������ ������ ������� �����������
;;; -kakt00z-�  �


(vl-load-com)

(defun c:vla-cleanup ( /
		      ms
		      lays
		      errlay
		      c_red
		      ss
		      i
		      los
		      ltodel
		      )
  
    (setq doc actdoc)
    (setq ms (vla-get-ModelSpace doc))
    (vla-startundomark doc)
    (acet-error-init
        (list (list "cmdecho" 0
                    "highlight" (getvar "highlight")
                    "limcheck" 0
                    "osmode" 0
                    );list
              T);list
    );acet-error-init
  (alert "\n ���� ����� �����  CLEAN")
  (setq c_red (vla-GetInterfaceObject cad "AutoCAD.AcCmColor.18"))
  (vla-put-entityColor c_red -1023410175)
  (setq lays (vla-get-Layers doc))
  (setq errlay (vla-add lays "errors"))
  (vla-put-Plottable errlay :vlax-false)
  (vlax-put-property errlay "Truecolor" c_red)

  ;(setq ut (vla-get-utility doc))
  ;(vla-sendmodelessoperationstart ut "string")
  ;(vla-sendmodelessoperationended ut "string")

  ;(vla-sendcommand doc "_spexplodeall ")


  ;(do (vlax-map-collection ms '(lambda (x) (= "AcDbLine" (vla-get-ObjectName x)))))
  ;(setq blocks (vla-get-Blocks doc))
  ;(do (vla-item blocks 5))
  
  ;(setq blrefs '())



  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;   ������� � ���������
;;;  (vlax-for obj ms
;;;    (if (= "AcDbBlockReference" (vla-get-ObjectName obj))
;;;      (block-explode obj)
;;;      );if
;;;
;;;    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;   ������� � ssget

(mapcar '(lambda (x)
	   (block-explode (vlax-ename->vla-object x)))
	(ss->list*(ssget "_X" '((0 . "INSERT"))))
	)
  

(load "d:/LISP WORKING/explode/explode-pline.LSP")

    (vlax-for obj ms
      (cond
	((and
	   (or
	     (= "AcDbText" (vla-get-ObjectName obj))
	     (= "AcDbMText" (vla-get-ObjectName obj)))
	   (or
	     (= "" (vla-get-textstring obj))
	     (= " " (vla-get-textstring obj))
	     (= "  " (vla-get-textstring obj))
	     (= "���������" (vla-get-textstring obj)))
	   );and
	 (vla-Delete obj))
	((and
	   (vlax-property-available-p obj "Lineweight")
	   (= 0 (vla-get-lineweight obj))
	   )
	 (vla-put-lineweight obj acLnWtByLayer))
	((= "AcDbPolyline" (vla-get-ObjectName obj))
	 (explode-pline obj))
	)
      );vlax-for


  (vla-purgeall doc)


  (setq ltodel '())
  (setq los (vla-get-Layers doc))
  (vlax-for lay los
    (if (= :vlax-false (vla-get-plottable lay))
      (setq ltodel (append ltodel (list lay)))
      )
    )
  
    
  ;(fields-destroy)
  ;(field-check)
  ;\n ������� ������������

  (foreach layer ltodel
    (setq ss (ssget "_X" (list (cons 8 (vla-get-name layer)))))
    (if ss (vl-cmdf "_erase" ss ""))
    )
  
  (alert "\n
  \n ��������� ���� errors �� ������� ������ - ��������� ���� � \"�����\" ������,
  \n �� ����� ����� ���������� ����������� DIN-����
  \n ��� �� �������� ����� �� ��������� OVERKILL
  \n DONE!
	 ")
  

  (acet-error-restore)
  (vla-endundomark doc)
  );defun
