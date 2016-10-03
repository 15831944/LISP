

(defun format-heal ()
(setq blo (vlax-ename->vla-object (car (entsel))))
(setq din (getbdyn blo "Выбор"))
(setq att (getbatt blo "FORMAT_NAME"))

(vla-put-textstring att
  (strcat "%<\\AcObjProp Object(%<\\_ObjId "
	  (itoa (vla-get-ObjectID blo))
	  ">%).Parameter(15).lookupString>%"))
  (vl-cmdf "_updatefield" (vlax-vla-object->ename blo) "")
  )
	  


