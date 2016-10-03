(vl-load-com)      ; Load ActiveX support
(setq acadObject   (vlax-get-acad-object))
(setq acadDocument (vla-get-ActiveDocument acadObject))
(setq mSpace       (vla-get-ModelSpace acadDocument))



;; Create a line
(defun gp:putline () ; / lineObj startPt endPt matList transMat) 
	 (setq lineObj (vla-addline mSpace (vlax-3d-point startpt) (vlax-3d-point endpt)))
  (princ "set line is correctly")	
  (princ lineObj)
)


(defun gp:get2pts ()
 (setq startPt (getpoint "Pick the start point"))
 (setq endPt (getpoint startPt "Pick the end point"))
 (setq pts (list startpt endpt))
)



(defun c:ptline ()
(gp:get2pts)  
(gp:putline)
)