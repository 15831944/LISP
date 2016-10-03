
;;; ¬озвращает ename аттрибута блока, ближайший к точке указани€
;;;********************************************************************************************
;;; 
;;;
;;;	оп€ть же, дл€ придурков вроде кактуса, есть функци€ nentsel !!!!!!   переделать!!
;;;
;;;


(defun ktz-get-blk-attrib-ename-by-pt (block-ent-sel	 / 
				       blk 			;блок
				       pt 			;тычка (точка куда тыкнул)
				       att 			;очередной аттрибут
				       n-att 			;нужный нам аттрибут
				       pt-att 			;точка его вставки
				       c-dist 			;очередное рассто€ние
				       min-dist 		;минимальное рассто€ние
				       n			;номер аттр. с минимальным рассто€нием
				       i
				      )

  (if

    (=	"INSERT" (cdr (assoc 0 (entget (car block-ent-sel)))))
    ;than
    (progn
	  
  (setq
    blk	     (car block-ent-sel)
    pt	     (cadr block-ent-sel)
    att	(entnext blk)
    i	     0
    min-dist 0
  )
 

  (while
    (/= (cdr (assoc 0 (entget att))) "SEQEND")
;;; устанавливаем тчк вставки очередного атрибута
     (if
       (equal (cdr (assoc 11 (entget att))) '(0.0 0.0 0.0))
       ;than
       (setq pt-att (cdr (assoc 10 (entget att))))
       ;else
       (setq pt-att (cdr (assoc 11 (entget att))))
     );if
    
;;; мер€ем рассто€ние и если оно меньше то записываем в мин

     (setq c-dist (ktz-getrasst pt pt-att))
     (if (or (= min-dist 0)
	     (> min-dist c-dist)
	 );or
     ;then
       (progn
	 (setq min-dist c-dist)
	 (setq n-att att)
       );progn
       
       );if
     
     (setq att (entnext att))
     (setq i (1+ i))
  );while
  );progn
    ;else
    )
n-att    
);defun