(defun c:put-linear-dimention (
	    /
	    doc
	    )
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)


  (if (not (tblobjname "layer" "��_�������"))
    (command "_.-layer" "_new" "��_�������" "_color" "252" "��_�������" "")
    );if

  (command "_dimlinear" pause pause pause)
  (command "_.chprop" (entlast) "" "_lay" "��_�������" "")
  (change-ent '(3 . "SPDS-��") (entlast))
  ;(command "_.-layer" "_freeze" "*" "")
  (vla-endundomark doc)
  )
setvar