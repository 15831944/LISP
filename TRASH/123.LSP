
(vl-load-com)
(setq *ModelSpace* (vla-get-ModelSpace (vla-get-ActiveDocument 
                 (vlax-get-Acad-Object))))


(defun gp:getPointInput(/ StartPt EndPt HalfWidth)
  (if (setq StartPt (getpoint "\nStart point of path: "))
    (if (setq EndPt (getpoint StartPt "\nEndpoint of path: "))
          (list
           (cons 10 StartPt)
           (cons 11 EndPt)
           (cons 40 (* HalfWidth 2.0))
           (cons 50 (angle StartPt EndPt))
           (cons 41 (distance StartPt EndPt))
) ) )  )


(defun c:myline ()
  (setq	line (vla-addLine
		*ModelSpace*		; Global Definition for Model Space
		VLADataPts		; vertices of path boundary
	      ) 
  ) ;_ end of setq
  (vla-put-closed pline T)
)