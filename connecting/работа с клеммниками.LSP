

(defun c:selclams ( / ss clambase)
(setq ss (ssget '((0 . "INSERT"))))
(setq clambase
    (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x)
       '(
	 "wiring_STS-2.5"
	 "wiring_STS-2.5-PE"
	 "wiring_STS-2.5-MT"
	 "wiring_STS-2.5-TG"
	 "wiring_ST-4-HESI"
	 "wiring_ST-4-HEDI"
	 
	 "монтаж_STS-2.5"
	 "монтаж_ST4-HEDI"
	 "монтаж_ST4-HESI"
	 )
   ))
  (ss->lsto* ss)
  ))


(sssetfirst nil (lst-to-ss clambase))
  )