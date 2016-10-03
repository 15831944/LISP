(vl-load-com)      ; Load ActiveX support
(setq acadObject   (vlax-get-acad-object))
(setq acadDocument (vla-get-ActiveDocument acadObject))
(setq mSpace       (vla-get-ModelSpace acadDocument))


;; Create a line
(defun gp:putline () ; / lineObj startPt endPt matList transMat) 
	 (vla-addline mSpace (vlax-3d-point startpt) (vlax-3d-point endpt))
)


(defun gp:get2pts ()
 (setq startPt (getpoint "Pick the start point\n"))
 (setq endPt (getpoint startPt "Pick the end point\n"))
)

		

(defun c:ptline ()
(setq i 1)
  (while (< i 10)
  	(setq A (list (cons i (* i 10))))
  	;(princ strcat ((rtos i) "  "))
  	(princ A)
        (princ "  \n")
      (setq i (+ i 1))
  )
  
	  (princ a)
;  (gp:get2pts)
;  (gp:putline)
)


