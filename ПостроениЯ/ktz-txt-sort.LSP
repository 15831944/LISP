(defun c:run ( / )
       (ktz-txt-sort-content)
);



;;;строит клеммник из блоков "клеммка", сортиру€ их по заданному номеру
;;;аттрибута в блоке

(defun ktz-txt-sort-content (/
		       ss		;набор текстов
		       ss-en		;список из набора ss
		       ent
		       i
			     
		       bp
		       dY
		       doc
		       )
  
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  
  (acet-error-init
    (list (list "cmdecho" 0
		"highlight" (getvar "highlight")
		"limcheck" 0
		"osmode" 0
		);list
	  T
	  );list
    );acet-error-init


  

  (setq	ss    (ssget '((0 . "*TEXT")))
	i     0
	bp    (getpoint "\nукажите базовую точку")
	dY    (getdist bp "\nрассто€ние между клеммами")
	ss-en '()
	);setq
  (repeat (sslength ss)
    (setq ss-en (append ss-en (list
				(list
				  (setq ent (ssname ss i))
				  (cdr (assoc 1 (entget ent))))
				);list
			)
	  i (1+ i))
    );repeat
  (setq ss-en (vl-sort ss-en
		       '(lambda (a b)
			  (< (cadr a)
			     (cadr b)
			     ))))
  (setq ent nil)
  (setq ss-en (mapcar 'car ss-en))
  (setq i 0)
  (foreach ent ss-en
    ;(ktz-move-block-to-pt
     (ktz-move-txt-to-pt 
      ent (list (car bp)
		(- (cadr bp)(* dy i))))
    (setq i (1+ i))
  );foreach



  (acet-error-restore)
  (vla-endundomark doc)
  
);defun






(defun ktz-move-txt-to-pt (
			     e		;	text
			     pt		;	точка в которую его перенести
			     /
			     eng
			     bpt
			     )
  (setq eng (entget e))
	      
  (if (= "TEXT" (cdr (assoc 0 eng)))
    ;then
    (progn
      (setq eng (subst (cons 10 pt)
		       (assoc 10 eng)
		       eng
		       )
	    );setq
      (entmod eng)
      (entupd e)
      );progn
    ;else
    (alert "не *текст")
    );if
  );defun


