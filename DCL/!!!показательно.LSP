(vl-load-com)

(defun lispru-dcl (/ file handle dcl_id dcl_res)

  (setq file   (strcat (vl-string-right-trim
       "\\"
       (vla-get-tempfilepath
         (vla-get-files
           (vla-get-preferences (vlax-get-acad-object))
           ) ;_ end of vla-get-files
         ) ;_ end of vla-get-tempfilepath
       ) ;_ end of vl-string-right-trim
           "\\dlg.dcl"
           ) ;_ end of strcat
  handle (open file "w")
  ) ;_ end of setq
  (foreach item
     '("dlg:dialog{label=\"lispru dialog\";"
       ":toggle{key=\"check1\";label=\"Вариант 1\";}"
       ":toggle{key=\"check2\";label=\"Вариант 2\";}"
       ":radio_button{key=\"var\";label=\"Сложить варианты\";}"
       ":radio_button{key=\"text\";label=\"Сложить тексты\";}"
       "ok_cancel;" "}")
    (write-line item handle)
    ) ;_ end of foreach
  (close handle)
  (setq dcl_id (load_dialog file))
  (new_dialog "dlg" dcl_id)
  ;; Устанавливаем значения
  (set_tile "check1" "1")
  (set_tile "check2" "1")
  (set_tile "var" "1")
  (action_tile "accept" "(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")
  (setq dlg_res (start_dialog))
  (unload_dialog dcl_id)
  (if (= dlg_res 1)
    (alert "Был нажат ОК, действуем дальше")
    (alert "Отмена")
    ) ;_ end of if
  ) ;_ end of defun