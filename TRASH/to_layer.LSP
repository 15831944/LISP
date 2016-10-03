;;(defun c:to-layer (nowset / my_set)

(defun begin_activex ()
  (vl-load-com)
  (setq acad_application (vlax-get-acad-object))
  (setq active_document (vla-get-activeDocument acad_application))
  (setq model_space (vla-get-modelSpace active_document))
  (setq paper_space (vla-get-paperSpace active_document))
)



(defun c:to-layer ()

; (begin_activex)


  
  (setq my_set (ssget))
  

;(setq my_set (vlax-get-acad-object))


  
  (if (not (tblobjname "layer" "нумерация"))
    (command "_.-layer" "_new" "нумерация" "_color" "161" "нумерация" "")  ;; Create нумерация if needed
  );if

; (vla-put-layer my_set "нумерация" )


  
  (command "_.-layer" "_set" "нумерация" "")
;  (command "_.chprop" (nowset) "" "_lay" "нумерация" "")
  (command "_.chprop" my_set "" "_lay" "нумерация" "")
  (command "_.-layer" "_freeze" "*" "")

(setq my_set nil)
)


;	(defun c:yh ()
;	  (setq yh 38)
;	)