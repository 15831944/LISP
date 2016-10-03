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
;;; Функция: gp:getPointInput ;
;;;--------------------------------------------------------------;
;;; Описание: С помощью этой функции пользователю предлагается выбрать три точки с запятой (;)
;;; points in a drawing, which will determine the ;
;;; path location, direction, and size. ;
;;;--------------------------------------------------------------;
;;; If the user responds to the get functions with valid data, ;
;;; use startPt and endPt to determine the position, length, ;
;;; and angle at which the path is drawn. ;
;;;--------------------------------------------------------------;
;;; Эта функция возвращает список, который состоит из следующих элементов: ;
;;; (10 . Starting Point) ;; List of 3 reals (a point) denoting ;
;;; ;; starting point of garden path. ;
;;; (11 . Ending Point) ;; List of 3 reals (a point) denoting ;
;;; ;; ending point of garden path. ;
;;; (40 . Width) ;; Real number denoting boundary ;
;;; ;; ширина. ;
;;; (41 . Length) ;; Real number denoting boundary ;
;;; ;; длина. ;
;;; (50 . Path Angle) ;; Real number denoting the angle ;
;;; ;; of the path, in radians. ;
;;;--------------------------------------------------------------;
(defun gp:getPointInput(/ StartPt EndPt HalfWidth)
  (if (setq StartPt (getpoint "\nStart point of path: "))
    (if (setq EndPt (getpoint StartPt "\nEndpoint of path: "))
      (if (setq HalfWidth (getdist EndPt "\nhalf-width of path: "))
         ;; if you've made it this far, build the association list
         ;; as documented above. This will be the return value
         ;; from the function.
         (list
           (cons 10 StartPt)
           (cons 11 EndPt)
           (cons 40 (* HalfWidth 2.0))
           (cons 50 (angle StartPt EndPt))
           (cons 41 (distance StartPt EndPt))
) ) ) ) )


;;;------------------------------------------------------------------------------------------------------------------------;
;;; Function gp:getDialogInput will get path parameters
(defun gp:getDialogInput ()
  (alert
    "Function gp:getDialogInput will get user choices via a dialog"
  )
  ;; For now, return T, as if the function worked correctly.
  T
)

;;;------------------------------------------------------------------------------------------------------------------------;
;;; Функция: gp:drawOutline                                  
;;;---------------------------------------------------------------
;;; Описание: С помощью этой функции можно создать границу парковой
;;; дорожки.                                            
;;;--------------------------------------------------------------- 
;;; Примечание: Проверка на наличие ошибок и коррекция не выполняются на     
;;; BoundaryData parameter. The sequence of items within this
;;; parameter does not matter, but it is assumed that all sublists
;;; are present and contain valid data.                           
;;; --------------------------------------------------------------
(defun gp:drawOutline (BoundaryData	     /		VLADataPts
		       PathAngle  Width	     HalfWidth	StartPt
		       PathLength angm90     angp90	p1
		       p2	  p3	     p4		polypoints
		       pline
		      )
  ;; extract the values from the list BoundaryData
  (setq	PathAngle  (cdr (assoc 50 BoundaryData))
	Width	   (cdr (assoc 40 BoundaryData))
	HalfWidth  (/ Width 2.00)
	StartPt	   (cdr (assoc 10 BoundaryData))
	PathLength (cdr (assoc 41 BoundaryData))
	angp90	   (+ PathAngle (Degrees->Radians 90))
	angm90	   (- PathAngle (Degrees->Radians 90))
	p1	   (polar StartPt angm90 HalfWidth)
	p2	   (polar p1 PathAngle PathLength)
	p3	   (polar p2 angp90 Width)
	p4	   (polar p3 (+ PathAngle (Degrees->Radians 180)) PathLength)
	polypoints (apply 'append
			  (mapcar '3dPoint->2dPoint (list p1 p2 p3 p4))
		   )
  )
  ;; ***** data conversion *****
  ;; Notice, polypoints is in AutoLISP format, consisting of a list
  ;; of the 4 corner points for the garden path.
  ;; The variable needs to be converted to a form of input parameter
  ;; acceptable to ActiveX calls.
  (setq VLADataPts (gp:list->variantArray polypoints))
  ;; Add polyline to the model space using ActiveX automation.
  (setq	pline (vla-addLightweightPolyline
		*ModelSpace*		; Global Definition for Model Space
		VLADataPts
	      ) ;_ end of vla-addLightweightPolyline
  ) ;_ end of setq
  (vla-put-closed pline T)
  ;; Return the ActiveX object name for the outline polyline
  ;; The return value should look something like this:
  ;; #<VLA-OBJECT IAcadLWPolyline 02351a34> 
  плиния
  (pline)
) ;_ end of defun



(defun gp:list->variantArray (ptsList / arraySpace sArray)
  ; allocate space for an array of 2d points stored as doubles
  (setq arraySpace (vlax-make-safearray
              vlax-vbdouble ; element type
              (cons 0
                    (- (length ptsList) 1)
                    ) ; array dimension
              )
)
  (setq sArray (vlax-safearray-fill arraySpace ptsList))
  ; return array variant
  (vlax-make-variant sArray)
  )






;;;------------------------------------------------------------------------------------------------------------------------;
;;;**************************************************************;
;;; Функция: C:GPath - основная функция для построения парковой дорожки ;
;;;--------------------------------------------------------------;
;;; Описание: Это основная функция для построения парковой дорожки. It is a ;
;;; C: функция означает, что она преобразуется в ;
;;; команда AutoCAD именуемая GPATH. This function ;
;;; determines the overall flow of the garden path ;
;;; program. ;
;;;**************************************************************;
;;; В переменной gp_PathData содержится ассоциативный список форм: ;
;;; (10 . Starting Point) - List of 3 reals (a point) denoting ;
;;; starting point of the garden path. ;
;;; (11 . Ending Point) - List of 3 reals (a point) denoting ;
;;; endpoint of the garden path. ;
;;; (40 . Width) - Real number denoting boundary ;
;;; ширина. ;
;;; (41 . Length) - Real number denoting boundary ;
;;; длина. ;
;;; (50 . Path Angle) - Real number denoting the angle of ;
;;; the path, in radians. ;
;;; (42 . Tile Size) - Real number denoting the size ;
;;; (radius) of the garden path tiles. ;
;;; (43 . Tile Offset) - Spacing of tiles, border to border. ;
;;; ( 3 . Object Creation Style) ;
;;; - Object creation style indicates how ;
;;; the tiles are to be drawn. Элемент ;
;;; expected value is a string and one ;
;;; one of three values (string case ;
;;; не важен): ;
;;; "ActiveX" ;
;;; "Entmake" ;
;;; "Command" ;
;;; ( 4 . Polyline Border Style) ;
;;; - Polyline border style determines ;
;;; the polyline type to be used for ;
;;; path boundary. The expected value ;
;;; one of the following (string case is;
;;; не важна): ;
;;; "Pline" ;
;;; "Light" ;
;;;**************************************************************;


(defun C:GPath ()
  ;; Запрос на ввод: путь к местоположению и
  ;; direction, then for path parameters. Continue only if you have
  ;; valid input. Store the data in gp_PathData.
  (if (setq gp_PathData (gp:getPointInput)) ; 
    (if	(gp:getDialogInput)
      (progn
	;; At this point, you have valid input from the user.
	;; Draw the outline, storing the resulting polyline 
	;; "pointer" in the variable called PolylineName.
	(setq PolylineName (gp:drawOutline gp_PathData))
	(princ "\nThe gp:drawOutline function returned <")
	(princ PolylineName)
	(princ ">")
	(Alert "Congratulations - your program is complete!")
      )
      (princ "\nFunction cancelled.")
    )
    (princ "\nIncomplete information to draw a boundary.")
  )
  (princ)				; exit quietly
)
;;; Display a message to let the user know the command name.
(princ "\nType gpath to draw a garden path.")
(princ)
