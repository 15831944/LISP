(setq dialst 
'(":dialog" ;{
  (("label" "block attributes")
    (":list_box" ;{
      (("label" "��������� �����")
	("key" "list-atts")
	("list" "�������� 1\n�������� 2\n�������� 3\n")
	("fixed_width_font" "true")
	);listparam ;}
      );box
    (":spacer" ;{
      (("width" "1"))
      );spacer ;}
    ("ok_cancel")
    );diaparm ;}
  );dialog
)



(":dialog"
  (("label" "block attributes")
    (":list_box"
      (("label" "��������� �����")
	("key" "list-atts")
	("list" "�������� 1\n�������� 2\n�������� 3\n")
	("fixed_width_font" "true")
      )
    )
    (":spacer" (("width" "1")))
    ("ok_cancel")
  )
)




(defun out (str)(princ (strcat "\n" str)))

(defun zxc (dialst / head tail)
  
  (cond
    ((= 1 (length dialst))(out (strcat (car dialst)";" )))
    ((= 2 (length dialst))(out (strcat (car dialst) "=\"" (cadr dialst)"\";" )))
    )
  )
  

 (zxc dialst)

