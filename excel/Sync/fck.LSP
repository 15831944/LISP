(setq sync|base-file-str "d:\\_LISP\\excel\\Sync\\syncbase.xlsx")
;(search )

  
(setq #sync|excel (vlax-get-or-create-object "Excel.Application"))
;(vlax-put-property #sync|excel "Visible" :vlax-true)
;(vlax-put-property #sync|excel "Visible" :vlax-false)



;(vlax-invoke-method #excel "Quit")
;(vlax-release-object #sync|excel)
;(setq #sync|excel nil)

(setq wkbs (vlax-get-property #sync|excel "Workbooks"))
(setq wb (vlax-invoke-method wkbs "Add" sync|base-file-str))
(setq shts (vlax-get-property wb "Sheets"))

(setq sht (vlax-get-property shts "Item" "base"))
(vlax-release-object sht)
(vlax-release-object shts)
(vlax-release-object wb)
(vlax-release-object wkbs)
(vlax-release-object #sync|excel)

(setq sht nil)
(setq shts nil)
(setq wb nil)
(setq wkbs nil)
(setq #sync|excel nil)




(vlax-invoke-method wb "Close" 1 2)



