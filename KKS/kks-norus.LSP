(sepstr* (kd-get-textstring (vlax-ename->vla-object (car (entsel)))))

(kd-get-textstring (vlax-ename->vla-object (car (entsel))))



(setq ss (ss->lsto* (ssget '((0 . "*TEXT")))))

(setq x (vlax-ename->vla-object (car (entsel))))

(setq ans (vl-remove-if-not
	    '(lambda (x)
	       (isstringkks (kd-get-textstring x))
	       )
	    ss))


(mapcar
  '(lambda (x / str)
     (if (isstringkks (setq str (kd-get-textstring x)))
       (vla-put-TextString x (norus str))
       )
     )
  ss
  )




(isstringkks (kd-get-textstring (vlax-ename->vla-object (car (entsel)))))



(defun isstringkks (str)
  (member
    (getmarkformat str)
    '(
      ("char" "num" "char" "char" "char" "num" "num" "char" "char" "num" "num" "num")
      ("num" "num" "char" "char" "char" "num" "num" "char" "char" "num" "num" "num")
      ("num" "num" "char" "char" "char" "num" "num" "char" "char" "num" "num" "num" "char")
      (		   "char" "char" "char" "num" "num" "char" "char" "num" "num" "num")
      (		   "char" "char" "char" "num" "num" "char" "char" "num" "num" "num" "char")
      )
    )

  
;;;  (equal
;;;    '("num" "num"  "char" "char" "char" "num" "num" "char" "char" "num" "num" "num")
;;;    ;'(       "num" "char" "char" "char" "num" "num" "char" "char" "num" "num" "num")
;;;    ;'(              "char" "char" "char" "num" "num" "char" "char" "num" "num" "num")
;;;    (getmarkformat str)
;;;    )
  );defun


(defun getmarkformat (str)
  (mapcar 'str|charcategory* (mapcar 'chr (vl-string->list str)))
  );defun


(defun str|charcategory* (ch / x delims)
  (setq delims '("-" "." ":"))
  (setq x (ascii ch))
  (cond
    ((or (< x 45) (= x 47) (and (> x 58) (< x 65)) (and (> x 90) (< x 97)) (and (> x 122) (< x 192)))
     "trash"
     )
    ((member ch delims)
     "delimiter"
     )
    ((and (> x 47) (< x 58))
     "num"
     )
    ((or (and (> x 64) (< x 91)) (and (> x 96) (< x 123)))
     "char"
     )
    ((and (> x 191) (< x 256))
     "char")
    )
  );defun







