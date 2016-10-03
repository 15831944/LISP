(defun c:put-linear-dimention (
	    /
	    doc
	    )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)


  (if (not (tblobjname "layer" "СУ_размеры"))
    (command "_.-layer" "_new" "СУ_размеры" "_color" "252" "СУ_размеры" "")
    );if

  (command "_dimlinear" pause pause pause)
  (command "_.chprop" (entlast) "" "_lay" "СУ_размеры" "")
  (change-ent '(3 . "SPDS-ОН") (entlast))
  ;(command "_.-layer" "_freeze" "*" "")
  (vla-endundomark doc)
  )
setvar