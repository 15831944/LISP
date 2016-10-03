;;;	15_11_11 закопался, надоело


(setq startPoint (getpoint))


(defun geom|eqPoints (p1 p2 fuzz) (< (expt (apply '+ (mapcar '(lambda (x) (expt x 2)) (mapcar '- p1 p2))) 0.5) fuzz))



(defun geom|getBranchPoints (startPoint / sset result)
  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list (vla-get-SelectionSets #actdoc) "geom|getBranchPoints")))
    (setq sset (vla-add (vla-get-SelectionSets #actdoc) "geom|getBranchPoints"))
    (progn (vla-delete (vla-item ssets "geom|getBranchPoints")) (setq sset (vla-add ssets "geom|getBranchPoints")))
    )
  (vla-Clear sset)
  (vla-SelectAtPoint sset
    (vlax-3D-point startPoint)
    (vlax-safearray-fill (vlax-make-safearray vlax-vbinteger '(0 . 0)) '(0))
    (vlax-safearray-fill (vlax-make-safearray vlax-vbvariant '(0 . 0)) '("LINE"))
    )
  (cond
    ((= 1 (vla-get-count sset))
     (setq result (geom|getNestedLines (vla-item sset 0)))
     )
    (T nil)
    )
  (vla-Clear sset)
  (vla-delete sset)
  result
  );defun




(setq line (vlax-ename->vla-object (car (entsel))))


(defun geom|getNestedLines (line / sset sp ep ptlist pa children owners lst result)
  (if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list (vla-get-SelectionSets #actdoc) "geom|getNestedLines")))
    (setq sset (vla-add (vla-get-SelectionSets #actdoc) "geom|getNestedLines"))
    (progn (vla-delete (vla-item ssets "geom|getNestedLines")) (setq sset (vla-add ssets "geom|getNestedLines")))
    )
  (vla-Clear sset)
  (setq sp (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint line))))
  (setq ep (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint line))))
  (setq ptlist (apply 'append (list sp ep))) (length ptlist)
  (setq pa (vlax-make-safearray vlax-vbDouble (cons 0 (1- (length ptlist)))))
  (vlax-safearray-fill pa ptlist)
  (vla-SelectByPolygon sset acSelectionSetFence pa
    (vlax-safearray-fill (vlax-make-safearray vlax-vbinteger '(0 . 0)) '(0))
    (vlax-safearray-fill (vlax-make-safearray vlax-vbvariant '(0 . 0)) '("LINE"))
    )
  ;(vla-Highlight sset :vlax-true)
  (setq lst (cont>list sset))
  ;(sssetfirst nil (lst-to-ss lst))
  (setq children
    (vl-remove-if-not
      '(lambda (l / ip)
	 (setq ip (vlax-safearray->list (vlax-variant-value (vla-IntersectWith line l acExtendNone))))
	 (or
	   (geom|eqPoints ip (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint l))) 0.01)
	   (geom|eqPoints ip (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint l))) 0.01)
	   )
	 )
      (vl-remove line lst)
      )
	)
  ;(sssetfirst nil (lst-to-ss children))
  (setq owners
     (vl-remove-if-not
       '(lambda (l / ip)
	  (setq ip (vlax-safearray->list (vlax-variant-value (vla-IntersectWith line l acExtendNone))))
	  (or
	    (geom|eqPoints ip sp 0.01)
	    (geom|eqPoints ip ep 0.01)
	    )
	  )
       (vl-remove line lst)
       )
	)
  ;(sssetfirst nil (lst-to-ss owners))
  (vla-Clear sset)
  (vla-delete sset)
  (setq result (origlist (append (list line) children owners)))
  ;(sssetfirst nil (lst-to-ss result))
  );defun



(setq lines (geom|getNestedLines (vlax-ename->vla-object (car (entsel)))))
(sssetfirst nil (lst-to-ss lines))

(mapcar 'geom|getNestedLines lines)















