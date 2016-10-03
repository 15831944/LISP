(defun c:to-layer ( / my-set)
  (setq my-set (ssget))
  
  (if (not (tblobjname "layer" "нумерация"))
    (command "_.-layer" "_new" "нумерация" "_color" "161" "нумерация" "")  ;; Create нумерация if needed
  );if
  
  (command "_.-layer" "_set" "нумерация" "")
  (command "_.chprop" my-set "" "_lay" "нумерация" "")
  (command "_.-layer" "_freeze" "*" "")
);defun


;;;(defun c:lay-switch (/)
;;;  ;(setq)
;;;  )