; 13_07_25
; SummaryInfo
; suilib.lsp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ("project-number" "object-name1" "object-name2" "object-name3" "project-name1" "project-name2" "project-name3") 

(defun sui:getcustomprops ( / sui quant lst paramname paramval)
  (setq sui (vla-get-SummaryInfo #actdoc))
  (setq quant (vla-NumCustomInfo sui))
  (while (>= (setq quant (1- quant)) 0)
    (vla-GetCustomByIndex sui quant 'paramname 'paramval)
    (setq lst (append lst (list (list paramname paramval))))
    )
  (reverse lst)
  )

;(sui:getcustomprops)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sui:addcustomprop (pn pv / sui quant lst n)
  ;(setq pn "project-name1")
  (setq sui (vla-get-SummaryInfo #actdoc))
  (setq quant (vla-NumCustomInfo sui))
  (setq lst (sui:getcustomprops))
  (if (and lst (assoc pn lst))
    (progn (vla-SetCustomByKey sui pn pv)
      (princ (strcat "\nProperty { " pn " } has changed to " pv))
      )
    (progn (vla-AddCustomInfo sui pn pv)
    (princ (strcat "\nProperty { " pn " } has added as " pv))
    )
    )
  (princ)
  )
;(addcustomprop "object-name2" "в г. Ћунинец")

