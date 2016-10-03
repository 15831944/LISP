


(defun c:getvisent (/ scl siz ctr ll ur)
  (setq scl (/ (car (getvar "SCREENSIZE")) (cadr (getvar "SCREENSIZE")))
        siz (getvar "VIEWSIZE")
        ctr (getvar "VIEWCTR")
         ll (list (- (car ctr) (* siz scl 0.5)) (- (cadr ctr) (* siz 0.5)))
         ur (list (+ (car ctr) (* siz scl 0.5)) (+ (cadr ctr) (* siz 0.5)))
         )
  )

(vla-get-ViewingDirection )




(defun c:extrec( / )
  (command "rectang"
       (list (- (car (getvar "viewctr")) (/ (* (getvar "viewsize") (/ (car (getvar "screensize")) (cadr (getvar "screensize")))) 2))
         (- (cadr (getvar "viewctr")) (/ (getvar "viewsize") 2))
         0)
       (list (+ (car (getvar "viewctr")) (/ (* (getvar "viewsize") (/ (car (getvar "screensize")) (cadr (getvar "screensize")))) 2))
         (+ (cadr (getvar "viewctr")) (/ (getvar "viewsize") 2))
         0)
       )
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





(defun c:first()
  (vl-load-com)
  ; Access autocad application object.
  (setq app(vlax-get-acad-object))
  ; Access the documents collection.
  (setq docs(vlax-get-property app "documents"))
  ; Access the targed drawings.
  (setq doc1(vla-item docs 0))
  (setq doc2(vla-item docs 1))
  ; Set command reactor to monitor pan command.
  (vlr-command-reactor nil '((:vlr-commandended . checkPan)))
  )
 
 
 
; Check if a pan command is performed in the current drawing.


(defun checkPan (reactorObj cmdInfo)
  ; Get the name of the command ended.
  (setq cmd (nth 0 cmdInfo))
  (setq center (getvar "viewctr"))
  (setq height (getvar "viewsize"))
  (setq ratio (getvar "screensize"))
  (setq width (* height (/ (car ratio)(cadr ratio))))
  (setq wseg (/ width 2.0))
  (setq hseg (/ height 2.0))

  ;find screen corners
  (Setq ll (list (- (car center) wseg)(- (cadr center) hseg)))
  (Setq ur (list (+ (car center) wseg)(+ (cadr center) hseg)))
  (Setq ul (list (- (car center) wseg)(+ (cadr center) hseg)))
  (Setq lr (list (+ (car center) wseg)(- (cadr center) hseg)))
  (setq ll (vlax-3d-point ll))
  (setq ur (vlax-3d-point ur))
  (vla-activate doc2)
  )

; To zoom/pan second drawing as we zoom/pan first one.
(defun c:second()
  (vl-load-com)
  ; Set command reactor to monitor pan command.
  (vlr-docmanager-reactor nil '((:vlr-documentBecameCurrent . panView)))
  )

; Check if a pan command is performed in the current drawing.
(defun panView (reactorObj cmdInfo)
  (vla-zoomwindow (vl-bb-ref 'appRef) (vlax-3d-point (vl-bb-ref 'a)) (vlax-3d-point(vl-bb-ref 'b)))
  ;(vla-regen (vl-bb-ref 'doc2Ref) acActiveViewPort)
  (vla-activate (vl-bb-ref 'doc1Ref))
  )