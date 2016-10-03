(vl-load-com)


(defun my-insert (name)
  (

   
   (lambda (f-rec doc)
     (f-rec name)
     )
    

    
   (lambda (name)
     (
      
      (lambda (x)
	(vla-endundomark doc)
	(if x (f-rec name) "Это штатный выход - можно сделать и не по ESC")
	)
       
      (progn
	(vla-startundomark doc)
	(vis-ins-bl name 1 1 1 0)
	)
      )
     )
   
   
   (vla-get-activedocument (vlax-get-acad-object))
   
   )
  );defun




(defun vis-ins-bl (name x y z ang)
  ((lambda (get-m make-ref model f-rec) (f-rec (get-m) x y z ang 'move))
   (lambda () (vl-catch-all-apply 'grread '(T 8)))
   (lambda (pt-or x y z ang)
     (vla-insertblock model
        (vlax-3d-point ((lambda (pt)
                         ((lambda (os-pt)
                           (if os-pt (trans os-pt 1 0) pt))
                         (osnap pt-or "_end,_mid"))); вот здесь по идее должна формироватся строка на основании привязок - лень искать формат и перемнные - пока забил просто, но суть ясна
                       (trans pt-or 1 0 T)))
                       name x y z ang))
   (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))
   (lambda (key x y z ang action)
     (if (vl-catch-all-error-p key) 
         nil;exit
         (if (and (not (listp (cadr key)))
                  (not (= (car key) 25)))
             (f-rec (get-m) x y z ang action); здесь можно добавить обработку данных с клавиатуры
             (if (= (car key) 5)
                 ((lambda (obj newkey)
                    (vla-delete obj)
                    (cond ((vl-catch-all-error-p newkey) nil);exit
                          ((= action 'move)
                           (f-rec newkey x y z ang action))
                          ((= action 'scale)
                           ((lambda (sc)
                              (f-rec newkey (* x sc) (* y sc) (* z sc) ang action))
                            (if (listp (cadr newkey))
                                (if (> (caadr key)
                                       (caadr newkey))
                                    1.1
                                    0.99)
                                1)))
                          ((= action 'rotate)
                           (f-rec (cons (car newkey) (cdr key))
                                  x y z
                                  (if (listp (cadr newkey)) (angle (cadr key) (cadr newkey)) ang)
                                  action))))
                  (make-ref (cadr key) x y z ang)
                  (get-m))
                 (if (= (car key) 3)
                     (make-ref (cadr key) x y z ang)
                     (f-rec (get-m) x y z ang (cdr (assoc action '((move . scale); здесь можно приукрасить меню, сделать изменение орбиты, привязок и всего прочего
                                                                   (scale . rotate)
                                                                   (rotate . move))))))))))))