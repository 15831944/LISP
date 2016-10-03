; 16_02_02


(defun CW|getCurViewPts ( / scl siz ctr ll ur)
  (setq scl (/ (car (getvar "SCREENSIZE")) (cadr (getvar "SCREENSIZE")))
	siz (getvar "VIEWSIZE")
	ctr (getvar "VIEWCTR")
	ll (list (- (car ctr) (* siz scl 0.5)) (- (cadr ctr) (* siz 0.5)))
	ur (list (+ (car ctr) (* siz scl 0.5)) (+ (cadr ctr) (* siz 0.5)))
	)
  (list ll ur)
  );defun

(defun CW|setViewPtList (cvd)
  (vla-zoomwindow #cad (vlax-3d-point (car cvd)) (vlax-3d-point (cadr cvd)))
  );defun






(defun pe-select (p1 p2 mode filter / curViewData osmode ssets sset result)
  (setq curViewData (CW|getCurViewPts))
  (setq osmode (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  
  (CW|setViewPtList (list p1 p2))
  (setq ssets (vla-get-SelectionSets #actdoc))
    (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "pe-select:SelSet")))
      (setq sset (vla-add ssets "pe-select:SelSet"))
      (progn (vla-delete (vla-item ssets "pe-select:SelSet")) (setq sset (vla-add ssets "pe-select:SelSet")))
      )
    (vla-Clear sset)
    (vla-select sset mode
      (vlax-3d-point p1)
      (vlax-3d-point p2)
      (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger (cons 0 (1- (length filter)))) (mapcar 'car filter))
      (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant (cons 0 (1- (length filter)))) (mapcar 'cdr filter))
      )
  (setq result (kd-container->list sset))
  (vla-clear sset)
  (vla-Delete sset)
  (CW|setViewPtList curViewData)
  (setvar "OSMODE" osmode)
  result
  );defun



(defun pe-select-at-point (pt filter / curViewData osmode ssets sset result)
  (setq curViewData (CW|getCurViewPts))
  (setq osmode (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (CW|setViewPtList (list (mapcar '+ pt '(10 10 0)) (mapcar '- pt '(10 10 0))))
  (setq ssets (vla-get-SelectionSets #actdoc))
    (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list ssets "pe-select:SelSet")))
      (setq sset (vla-add ssets "pe-select:SelSet"))
      (progn (vla-delete (vla-item ssets "pe-select:SelSet")) (setq sset (vla-add ssets "pe-select:SelSet")))
      )
  (vla-Clear sset)
  (vla-SelectAtPoint sset
      (vlax-3d-point pt)
      (vlax-safearray-fill (vlax-make-safearray vlax-vbInteger (cons 0 (1- (length filter)))) (mapcar 'car filter))
      (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant (cons 0 (1- (length filter)))) (mapcar 'cdr filter))
      )
  (setq result (kd-container->list sset))
  (vla-clear sset)
  (vla-Delete sset)
  (CW|setViewPtList curViewData)
  (setvar "OSMODE" osmode)
  result
  );defun



;(setq obj (vlax-ename->vla-object (car (entsel))))
(defun pe-select-inBound-bref (obj / lbpt urpt offset)
  (setq offset '(1 1 0))
  (vla-GetBoundingBox obj 'lbpt 'urpt)
  (setq lbpt (mapcar '+ (variantextraction lbpt) offset))
  (setq urpt (mapcar '- (variantextraction urpt) offset))
  ;(vla-addline #modspace (vlax-3d-point lbpt) (vlax-3d-point urpt))
  (setq result (pe-select lbpt urpt acSelectionSetCrossing '((0 . "*"))))
  );defun







