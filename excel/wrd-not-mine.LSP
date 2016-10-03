;;; Перенос текста из Вордовского документа (с расширением .doc) в автокад в форме МТЕКСТ
;;; http://cad.ru/ru/forum/?PAGE_NAME=read&FID=22&TID=1892&PAGEN_1=4
;;; Запускается командой OUTWORD

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
  (if (setq insPt (getpoint "\nУкажите точку вставки текста [Выход]:"))
    (if (setq txtW (getreal "\nВведите ширину текста [Выход]"))
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
  (if(setq fname(getfiled "Выбор файла" "" "doc;docx;rtf" 0))
    (if(not(setq *msw* (vlax-get-object "Word.Application")))
      (if(setq *msw* (vlax-create-object "Word.Application"))
   (openWord fname 1)
   (princ "\nWord недоступен!")
      )
      (openWord fname 0)
    );;;(if(not(setq msw
    (princ "\nНе выбран файл!")
  );;;(if(setq fname
  (princ)
)