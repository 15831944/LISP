;;; ������� ������ �� ����������� ��������� (� ����������� .doc) � ������� � ����� ������
;;; http://cad.ru/ru/forum/?PAGE_NAME=read&FID=22&TID=1892&PAGEN_1=4
;;; ����������� �������� OUTWORD

(vl-load-com)
(defun ba-string-subst (chars_new chars_old string / new_string)
  (setq new_string (vl-string-subst chars_new chars_old string))
  (while (not (equal new_string string))
    (setq string new_string new_string (vl-string-subst chars_new chars_old string))
    )
  new_string
  );defun

(defun mSpace (/ doc)
  (setq doc (vla-get-ActiveDocument (vlax-get-Acad-Object)))
  (if (= 1 (getvar "TILEMODE"))
    (vla-get-ModelSpace doc)
    (vla-get-PaperSpace doc)
  )
)

(defun openWord (fname flg / Documents myDoc mySelect myTxt insPt txtW)
  (setq Documents (vlax-get-property *msw* 'Documents))
  (setq myDoc (vlax-invoke-method Documents 'Open fname))
  (setq myCon (vlax-get-property myDoc 'Content))
  (setq myTxt (vlax-get-property myCon 'Text))
  (setq myTxt (ba-string-subst "\\P" "\r" myTxt))
  (if (setq insPt (getpoint "\n������� ����� ������� ������ [�����]:"))
    (if (setq txtW (getreal "\n������� ������ ������ [�����]"))
      (vla-AddMText (mSpace) (vlax-3d-point insPt) txtW myTxt)
      )
    )
  (vlax-invoke-method myDoc 'Close)
  (if(= flg 1)
    (progn
      (vlax-invoke-method *msw* 'Quit)
      (setq *msw* nil)
      )
    )
  )

(defun c:outWord (/ fname)
  (if(setq fname(getfiled "����� �����" "" "doc;docx;rtf" 0))
    (if(not(setq *msw* (vlax-get-object "Word.Application")))
      (if(setq *msw* (vlax-create-object "Word.Application"))
   (openWord fname 1)
   (princ "\nWord ����������!")
      )
      (openWord fname 0)
    );;;(if(not(setq msw
    (princ "\n�� ������ ����!")
  );;;(if(setq fname
  (princ)
)