(vl-load-com)
;;; прога меняет првязку текста




;;; ипался писать сам но забил, решил использовать уже написанную ф-цию acet-tjust из експреса


(defun txtjust ( / doc ss j acj acjlist flt)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T))

  (setq flt "*TEXT,ATTDEF,ATTRIB")
  (if (not (setq ss (ssget "_I" (list (cons 0  flt))))) (setq ss (vl-catch-all-apply 'ssget (list (list (cons 0 flt))))))
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type ss)) 
     (princ  (strcat "\n" (VL-CATCH-ALL-ERROR-MESSAGE ss)))
     )
    ((null ss) nil)
    ((= 'PICKSET (type ss))
     (setq j (getjust))
     (setq acjlist
	    (list
	   "Start" "Center" "Right"
	   "Middle" "Middle" "Middle"
	   "TL" "TC" "TR"
	   "ML" "MC" "MR"
	   "BL" "BC" "BR"
	   ))
     (setq acj (nth j acjlist))
     (acet-tjust ss acj)
     )
    (T nil)
    )
  (acet-error-restore)
  (vla-endundomark doc)
  );defun



(defun getjust ( / dcl-file-path hand dcl_id justvar func)
  ;;;;*******************************************************************
  (setq dcl-file-path (strcat (getenv "temp") "\\txtjust-dcl.dcl") hand (open dcl-file-path "w"))

  (foreach item
	   (list
;;; begin dcl file
"txtjust : dialog {label=\"txtjust\";"
	": row {"
		": button {label=\"Влево\";key=\"kleft\";}"
		": button {label=\"Центр\";key=\"kcent\";}"
		": button {label=\"Вправо\";key=\"kright\";}"
	"}"
	": button {label=\"Выровненный\";key=\"kstrait\";}"
	": button {label=\"Середина\";key=\"kmid\";}"
	": button {label=\"По ширине\";key=\"kwidth\";}"
    "spacer_1;	"
	": row {"
		": button {label=\"Вверх Влево\";key=\"tl\";}"
		": button {label=\"Вверх Центр\";key=\"tc\";}"
		": button {label=\"Вверх Вправо\";key=\"tr\";}"
	"}"
	": row {"
		": button {label=\"Середина Влево\";key=\"cl\";}"
		": button {label=\"Середина Центр\";key=\"cc\";}"
		": button {label=\"Середина Вправо\";key=\"cr\";}"
	"}"
	": row {"
		": button {label=\"Вниз Влево\";key=\"bl\";}"
		": button {label=\"Вниз Центр\";key=\"bc\";}"
		": button {label=\"Вниз Вправо\";key=\"br\";}"
	"}"
    "spacer_1;"
    "ok_cancel;"
"}"
;;; end of dcl file
		)
    (write-line item hand)
    );foreach
  (close hand)
  ;;;;*******************************************************************
  (if (< (setq dcl_id (load_dialog dcl-file-path)) 0) (exit))
  (if (not (new_dialog "txtjust" dcl_id)) (exit))
  
  (action_tile "kleft" (strcat "(setq justvar 0)" "(done_dialog)"))
  (action_tile "kcent" (strcat "(setq justvar 1)" "(done_dialog)"))
  (action_tile "kright" (strcat "(setq justvar 2)" "(done_dialog)"))
  (action_tile "kstrait" (strcat "(setq justvar 3)" "(done_dialog)"))
  (action_tile "kmid" (strcat "(setq justvar 4)" "(done_dialog)"))
  (action_tile "kwidth" (strcat "(setq justvar 5)" "(done_dialog)"))
  (action_tile "tl" (strcat "(setq justvar 6)" "(done_dialog)"))
  (action_tile "tc" (strcat "(setq justvar 7)" "(done_dialog)"))
  (action_tile "tr" (strcat "(setq justvar 8)" "(done_dialog)"))
  (action_tile "cl" (strcat "(setq justvar 9)" "(done_dialog)"))
  (action_tile "cc" (strcat "(setq justvar 10)" "(done_dialog)"))
  (action_tile "cr" (strcat "(setq justvar 11)" "(done_dialog)"))
  (action_tile "bl" (strcat "(setq justvar 12)" "(done_dialog)"))
  (action_tile "bc" (strcat "(setq justvar 13)" "(done_dialog)"))
  (action_tile "br" (strcat "(setq justvar 14)" "(done_dialog)"))
  (action_tile "is_default" (strcat "(setq justvar nil)" "(done_dialog)"))
  (start_dialog)
  (unload_dialog dcl_id)
  justvar
  );defun


  


(defun kd:txtjust-sc ( / ss)

  (setq ss (ssget "_I" '((0 . "*TEXT,ATTDEF,ATTRIB"))))
  (if (null ss) (setq ss (ssget '((0 . "*TEXT,ATTDEF,ATTRIB")))))
  
  
  )