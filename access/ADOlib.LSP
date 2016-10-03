; 15_01_23
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ado|createDB (#dbpath / ADOX_catalog str ConnectionObject)
  (setq ADOX_catalog (vlax-get-or-create-object "ADOX.Catalog"))
  (setq str (strcat "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" #dbpath ))
  (setq ConnectionObject (ADOLISP_VARIANT-VALUE (vlax-invoke-method ADOX_catalog "Create" str)))
  (vlax-invoke-method ConnectionObject "Close")
  (vlax-release-object ConnectionObject)
  (setq ConnectionObject nil)
  (vlax-release-object ADOX_catalog)
  (setq ADOX_catalog nil)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq skelet '(("NAME" "T_looptypes") ("TAGS" "LOOP-TYPE") ("KEY" "LOOP_TYPE")))
(defun ado|createTBL (skelet / ConnectString ConnectionObject head data pkeys)
  ;(setq skelet tbl|skelet)
  (setq tname (cadr (assoc "NAME" skelet)))
  (setq head (cdr (assoc "TAGS" skelet)))
  (if (apply 'or (mapcar '(lambda (x) (wcmatch x "*-*")) head)) (progn (alert "заголовок столбца не должен содержать \"-\"") (exit)))
  (setq pkeys (cdr (assoc "KEY" skelet)))
  (setq ConnectString (strcat "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" #dbpath ";Persist Security Info=False"))
  (setq ConnectionObject (ADOLISP_ConnectToDB ConnectString "admin" ""))
  (ADOLISP_DOSQL ConnectionObject (strcat "CREATE TABLE " tname " " "(" (antisep* (mapcar '(lambda (x) (strcat x " varchar(255)")) head) ", ") ")"))
  (if pkeys (ADOLISP_DOSQL ConnectionObject (strcat "ALTER TABLE " tname " " "ADD PRIMARY KEY " "(" (antisep* pkeys ",") ")")))
  (if ADOLISP_ErrorList (princ ADOLISP_ErrorList))
  ;(if ADOLISP_LastSQLStatement (princ ADOLISP_LastSQLStatement))
  (ADOLISP_DisconnectFromDB ConnectionObject)
  (setq ConnectionObject nil)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq tbl (origlist (tbl|selectfrom #$Contacts (cdr (assoc "TAGS" tbl|skelet)))))
(defun ado|addRecords (tname tbl / ConnectString ConnectionObject head data)
  (setq ConnectString (strcat "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" #dbpath ";Persist Security Info=False"))
  (setq ConnectionObject (ADOLISP_ConnectToDB ConnectString "admin" ""))
  (setq head (car tbl))
  (mapcar '(lambda (line) (ADOLISP_DOSQL ConnectionObject (strcat "INSERT INTO " tname " " (strcat "(" (antisep* head ", ") ")") " " "VALUES" " " (strcat "('" (antisep* line "', '") "')")))) (cdr tbl))
  (ADOLISP_DisconnectFromDB ConnectionObject)
  (setq ConnectionObject nil)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq tname "40_loops")
(defun ado|tbl>lst (tname / ConnectString ConnectionObject res)
  (if (null #dbpath) (exit))
  (setq ConnectString (strcat "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" #dbpath ";Persist Security Info=False"))
  (setq ConnectionObject (ADOLISP_ConnectToDB ConnectString "admin" ""))
  (setq res (ADOLISP_DOSQL ConnectionObject (strcat "SELECT * FROM " tname)))
  (ADOLISP_DisconnectFromDB ConnectionObject)
  (setq ConnectionObject nil)
  res
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







