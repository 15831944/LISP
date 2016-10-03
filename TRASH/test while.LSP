;;;--------------------------------------------------------------
;;; Сначала необходимо загрузить функции ActiveX. If ActiveX support 
;;; already exists in document (can occur when Bonus tools have been 
;;; загружен в AutoCAD), ничего не произойдет. Otherwise, ActiveX 
;;; support is loaded.                                
;;;---------------------------------------------------------------
(vl-load-com)
;;; In Lesson 4, the following comment and code is moved to utils.lsp
;;;---------------------------------------------------------------
;;; For ActiveX functions, we need to define a global variable that 
;;; "points" to the Model Space portion of the active drawing. This 
;;; variable, named *ModelSpace* will be created at load time.      
;;;---------------------------------------------------------------
(setq *ModelSpace*
(vla-get-ModelSpace
     (vla-get-ActiveDocument (vlax-get-acad-object))
) ;_ end of vla-get-ModelSpace
) ;_ end of setq

;;;------------------------------------------------------------------------------------------------------------------------;
;;; Функция: Degrees->Radians;
;;;--------------------------------------------------------------;
;;; Описание: Данная функция преобразует значение, представляющее точку с запятой (;)
;;; angular measurement in degrees, into its radian ;
;;; equivalent. There is no error checking on the ;
;;; numberOfDegrees parameter -- it is always ;
;;; expected to be a valid number. ;
;;;--------------------------------------------------------------;
(defun Degrees->Radians (numberOfDegrees) 
(* pi (/ numberOfDegrees 180.0)))


;;;------------------------------------------------------------------------------------------------------------------------;
;;; Функция: 3dPoint->2dPoint ;
;;;--------------------------------------------------------------;
;;; Описание: Эта функция обрабатывает один параметр, представляющий точку с запятой (;)
;;; 3D point (list of three integers or reals), and ;
;;; converts it into a 2D point (list of two reals).;
;;; There is no error checking on the 3D point ;
;;; parameter -- it is assumed to be a valid point. ;
;;;--------------------------------------------------------------;
;;; Действие: Добавьте функцию проверки параметров, чтобы точка с запятой (;)
;;; function won’t crash a program if it is passed a ;
;;; null value, or some other kind of data type than a ;
;;; 3D point. ;
;;;--------------------------------------------------------------;
(defun 3dPoint->2dPoint (3dpt)
  (list (float(car 3dpt)) (float(cadr 3dpt)))
)


;;;------------------------------------------------------------------------------------------------------------------------;
;;; Функция: gp:drawline*
;;;---------------------------------------------------------------
;;; Описание: С помощью этой функции можно создать линию
;;;--------------------------------------------------------------- 
(defun gp:drawline (points / p1 p2 polypoints)

  (setq   p1  (cdr (assoc 10 data_points))
    	  p2  (cdr (assoc 11 data_points))
    	  polypoints (apply 'append (mapcar '3dPoint->2dPoint (list p1 p2)))
  )
  (setq VLADataPts (gp:list->variantArray polypoints))  ;; Add polyline to the model space using ActiveX automation.
  
  (setq	line (vla-addLine
		*ModelSpace*		; Global Definition for Model Space
		VLADataPts		; массив координат 
	      ) ;_ end of vla-addLightweightPolyline
  ) ;_ end of setq
  (vla-put-closed line T)
  ;; Return the ActiveX object name for the outline polyline
  ;; The return value should look something like this:
  ;; #<VLA-OBJECT IAcadLWPolyline 02351a34> 
  линия
  (line)
) ;_ end of defun

;;;----------------------------------------------------------------------------------------------;
(defun gp:list->variantArray (ptsList / arraySpace sArray)                                    ;--;
  ; allocate space for an array of 2d points stored as doubles                                ;--;
  (setq arraySpace (vlax-make-safearray                                                       ;--;
              vlax-vbdouble ; element type                                                    ;--;
              (cons 0                                                                         ;--;
                    (- (length ptsList) 1)                                   		      ;--;
                    ) ; array dimension 	                                              ;--;
              )
)
  (setq sArray (vlax-safearray-fill arraySpace ptsList))
  ; return array variant
  (vlax-make-variant sArray)                                                                  ;--;
  )                                                                                           ;--;
;;;----------------------------------------------------------------------------------------------;




(defun gp:test ()
;  (setq a 1)
;  (while (< a 8)
;    (setq a (1+ a))
;    (alert (rtos a))
;    T
;  )

(setq data_points
   (list
     (cons '10 '(100  100  0))
     (cons '11 '(300  300  0))  
   )
)
;(princ data_points)
(setq lineName (gp:drawline data_points))
;(princ lineName)
  
(Alert "Congratulations - your program is complete!")
(princ)				; exit quietly
 
  
)











;;;;;
;;;;;   polypoints (apply 'append (mapcar '3dPoint->2dPoint (list p1 p2 p3 p4)))
;;;;;   vla-CreateText
;;;;;
