;;; Возвращает ename аттрибута при тыкании в блок, (выбираем из списка)
;;;********************************************************************************************
;;;**********************************************************************
;;; -kakt00z- ©
;;;**********************************************************************
;;; для придурков вроде кактуса есть функция nentsel



(defun ktz-get-blk-attrib-ename (block-ent-sel /
					     att
					     att-cur-name
					     att-name-lst
					     i
					     str-init
					     str2-init
					     str-kword
					      )
  (if

    (=	"INSERT" (cdr (assoc 0 (entget (car block-ent-sel)))))
    ;than
    (progn


    (setq att (entnext (car block-ent-sel)))
    (setq i 1)

    ;делаем список точечных пар с названиями аттрибутов в блоке
    ;а так же строки для initget и getkword
    (setq str-init "")
    (setq str2-init "")
    (setq str-kword "")
    (while
      (/= (cdr (assoc 0 (entget att))) "SEQEND")
       (setq att-cur-name (cdr (assoc 2 (entget att))))
       (setq str-init (strcase (strcat str-init (vl-string-subst "-" "_" att-cur-name) " ") t))
       (setq str-kword (strcase (strcat str-kword (vl-string-subst "-" "_" att-cur-name) "/") t))
       (setq str2-init (strcat str2-init " " (itoa i)))
       (setq att-name-lst (append att-name-lst (list (cons i att-cur-name))))
       (setq att (entnext att))
       (setq i (1+ i))
    );while

    ;(setq k str2-init)

    (initget (strcat str-init " _" str2-init))
    (setq i (atoi (getkword (strcat "\n [" str-kword "] :"))))
  (setq att (car block-ent-sel))
  (repeat i (setq att (entnext att)))
  ;(princ (assoc 1 (entget att)))
  );progn
 );if
  att
);defun