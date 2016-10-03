




;;;;;;;;;;;;;;; Ћќ’ ,,,,, с зажатым контролом




;;;;; редактирование блока

;;; сделаю лучше так - при нажатии на аттрибут -
;;; 1 убираю текст аттрибута
;;; 2 добавл€ю к чертежу элемент TEXT с расположением поверх аттрибута
;;; 3 вхожу в редактирование последнего
;;; при нажатии ентер, запоминаю содержимое, стираю текст и заношу в аттрибут

(defun putstringtoatt (
		       /
		       ptatt
		       oatt
		       attstr
		       otxt
		       )
  (setq oatt nil)
  (setq otxt nil)
  (while (null oatt)
    (setq oatt (nentsel "\n”кажите аттрибут"))
    )
  (setq oatt (vlax-ename->vla-object (car oatt)))
  (setq attstr (vla-get-TextString oatt))
  (vla-put-textstring oatt "")
  ;;; тут надо доработать дл€ пространства листа
  (setq otxt (vla-AddText #modspace attstr (vla-get-InsertionPoint oatt) (vla-get-Height oatt)))
  (vla-put-alignment otxt (vla-get-alignment oatt))
  (vla-put-TextAlignmentPoint otxt (vla-get-TextAlignmentPoint oatt))
  (vl-cmdf "_ddedit" (vlax-vla-object->ename otxt) "")
  (vla-put-textstring oatt (vla-get-TextString otxt))
  (vla-Delete otxt)
  (princ)
  );defun
