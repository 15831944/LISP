(defun c:run ( / )
       (ktz_ss_sortX)
);



;;; базовый блок должен быть на др. слое, и только он "нумерация"

(defun ktz_ss_sortX (
		     /
		     ss			;общий набор
		     pt1ss		;точки выбора общего набора
		     pt2ss	
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
		     mbp		;базовая тчк перетаскивания подгруппы
		     ptm
		     ptkon
		     
		     )
  (alert "Надеюсь ты не забыл перекинуть базовый блок на отдельный слой и передвинуть его левее остальных??")

  (setq	pt1ss		(getpoint "\n укажите первую точку окна выбора ВСЕХ объектов :")
	pt2ss		(getpoint "\n теперь второй (противоположный) угол :"))

  (command "_zoom" pt1ss pt2ss)

  (setq	ss		(ssget "_W" pt1ss pt2ss)
	base_block	(car (entsel "\nукажи базовый блок"))
			; в идеале тут должно быть имя блока, но пока - слой "нумерация"
	
	i		0
	
				; в идеале тут должно быть имя блока, но пока - слой "нумерация"
	pt1		(getpoint "\nукажите первую точку для окна выбора подгруппы")
	pt2		(getpoint "\nукажите вторую точку для окна выбора подгруппы")
	mbp		(getpoint "\nукажите базовую точку для перетаскивания подгруппы")
	bp		(getpoint "\nбазовая точка")
	dX		(getdist bp "\nрасточние между объектами X")
	
  );setq
  (setq bpt (cdr (assoc 10 (entget base_block))))
  
  (setq  dpt1	(list (- (car bpt) (car pt1))
		      (- (cadr pt1) (cadr bpt))
		);list
	 dpt2	(list (- (car pt2) (car bpt))
		      (- (cadr bpt) (cadr pt2))
		);list
	 mbp	(list (- (car bpt) (car mbp))
		      (- (cadr bpt) (cadr mbp))
		);list
   );setq

	
  
  


  

  
  (repeat (sslength ss)
    (setq ss-en (append ss-en (list (ssname ss i))))
    (setq i (1+ i))
  );repeat


  
(princ "\n ******************************************")
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

  (princ "\n ******************************************")
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
;;; это нужно для того чтобы он был первый в общем списке блоков по оси Х
;;; среди относящихся к нему остальных примитивов
;;; нужно для создания подгруппы для перемещения
;;; идем по списку пока не встретится блок base_block
(princ "\n ******************************************")

(setq i 0)

(foreach ent ss-en
  (if (equal (assoc 8 (entget base_block))
	     (assoc 8 (entget ent)));=
    (progn
      (setq bpt (cdr(assoc 10 (entget ent))))
      (setq pt1 (list (- (car bpt) (car dpt1))
		       (+ (cadr bpt) (cadr dpt1)))
	    pt2 (list (+ (car bpt) (car dpt2))
		       (- (cadr bpt) (cadr dpt2)))
	    ptm (list (+ (car bpt) (car mbp))
		      (+ (cadr bpt) (cadr mbp)))
       );setq

      (setq ptkon (list (+ (car bp) (* dX i))
			(cadr bp)))


      (command "_move" "_W" pt1 pt2 "" ptm ptkon)

      ;(command "_rectangle" pt1 pt2)
      
      


      
      (setq i (1+ i))
    );progn
  );if


);foreach




					


  (princ)

);defun