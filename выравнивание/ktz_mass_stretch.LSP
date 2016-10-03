;;; ниче-так прога, надо доработать!!! с использованием ID базового блока

(defun c:run ( / )
       (ktz_ss_sortX)
);



;;; базовый блок должен быть на др. слое, и только он "нумерация"

(defun ktz_ss_sortX (
		     /
		     ss			;общий набор
		     sss		;поднабор
		     bp			;точка начала вставки блоков
		     pt1		;точки окна выбора подгруппы
		     pt2
		     dpt1
		     dpt2
		     bpt		;точка вставки базового блока
		     i
		     ent
		     dX			;расстояние X между вставками групп
		     ss-en		;общий список имен примитивов
		     base_block		;базовый блок, основание для создания подгруппы
		     			;объектов для перемещения
		     tmpbp		;тчк подгруппы
		     
		     )


  (setq base_block	(car (entsel "\nукажи базовый блок"))
			; в идеале тут должно быть имя блока, но пока - слой "нумерация"
	ss		(ssget)		;"\nукажите объекты")
			

	
	i		0
	
				; в идеале тут должно быть имя блока, но пока - слой "нумерация"
	pt1		(getpoint "\nукажите первую точку для окна выбора подгруппы")
	pt2		(getpoint "\nукажите вторую точку для окна выбора подгруппы")
	bp		(getpoint "\nбазовая точка")
	dX		(getdist bp "\nрасточние между объектами X")
	
  );setq
  (setq bpt (cdr (assoc 10 (entget base_block))))
  
  (setq  dpt1	(list (- (car pt1) (car bpt))
		      (- (cadr pt1) (cadr bpt))
		      (- (caddr pt1) (caddr bpt))
		);list
	 dpt2	(list (- (car pt2) (car bpt))
		      (- (cadr pt2) (cadr bpt))
		      (- (caddr pt2) (caddr bpt))
		);list
   );setq

	
  
  


  

  
  (repeat (sslength ss)
    (setq ss-en (append ss-en (list (ssname ss i))))
    (setq i (1+ i))
  );repeat


  

;;; ***************************************************************************
;;; вывод несортированного массива
;;; ***************************************************************************
  
  (mapcar '(lambda (x)
	     (progn (princ "\n  -> ")
		    (princ x)
	     )
	   )
	  ss-en
  );mapcar
  (princ "\n ")



;;; ***************************************************************************
;;; сортируем список имен по абсциссе (оси Х)
;;; ***************************************************************************

  (setq	ss-en	(vl-sort ss-en
			 '(lambda (a b)
			    (< (car (cdr (assoc 10 (entget a))))
			       (car (cdr (assoc 10 (entget b))))
			       )
			  )
		)
  )

;;; ***************************************************************************
;;; вывод сортированного массива
;;; ***************************************************************************

  (mapcar '(lambda (x)
	     (progn (princ "\n  -> ")
		    (princ x)
	     )
	   )
	  ss-en
  );mapcar


;;; заранее нужно сдвинуть базовый блок левее остальных примитивов
;;; это нужно для того чтобы он был первый в общем списке блоков
;;; среди относящихся к нему остальных примитивов
;;; нужно для создания подгруппы для перемещения
;;; идем по списку пока не встретится блок base_block


(setq i 0)

(foreach ent ss-en
  (if (= (assoc 8 (entget base_block))
	 (assoc 8 (entget ent)));=
    (progn
      (setq bpt (cdr(assoc 10 (entget ent))))
      (setq pt1 (list (+ (car bpt) (car dpt1))
		       (+ (cadr bpt) (cadr dpt1))
		       (+ (caddr bpt) (caddr dpt1))
		 )
	    );
      (setq pt2 (list (+ (car bpt) (car dpt2))
		       (+ (cadr bpt) (cadr dpt2))
		       (+ (caddr bpt) (caddr dpt2))
		 )
	    );

      (command "_rectangle" pt1 pt2)
      
      ;(setq sss (ssget "_W" pt1 pt2))
      


      
      (setq i (1+ i))
    );progn
  );if


);foreach




					


  (princ)

);defun





;(while INSNAMES (setq OUTPUT (cons (cons (car INSNAMES)(- LEN (setq LEN (length (setq INSNAMES (vl-remove (car INSNAMES) INSNAMES)))))) OUTPUT)))



;;;(defun c:bsel (/) ;;; выбор всех одноименных блоков по указке
;;;  (setvar "cmdecho" 0) 
;;;  (sssetfirst 
;;;    nil 
;;;    (setq bSet 
;;;      (ssget 
;;;        "_C" 
;;;        (list 
;;;          (assoc 2 (entget (car (entsel "Select sample block: ")))) 
;;;        ) 
;;;      ) 
;;;    ) 
;;;  ) 
;;;  (terpri) 
;;;  (princ(strcat "*** "(itoa(sslength bSet)) " bloks selected ***")) 
;;;  (princ) 
;;;)

