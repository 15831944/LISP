

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(setq #tdms (vlax-get-or-create-object "TDMS.Application"))
;(vlax-put-property #tdms "Visible" :vlax-true)
(setq tdms:objDefs (gp #tdms "ObjectDefs"))
(setq tdms:drwDef (gp tdms:objDefs "item" "Чертеж"))
(setq tdms:docDef (gp tdms:objDefs "item" "Документ"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; выдирание типов ТДМС-файлов
(setq tdms:fileDefs (gp #tdms "FileDefs"))
(setq dwgfiledef (gp tdms:fileDefs "item" "FILE_DWG2000"))
(setq pdffiledef (gp tdms:fileDefs "item" "FILETYPE_PDF"))
(setq tdms:classformats (gp (gp (gp (gp #tdms "AttributeDefs") "item" "ATTR_FORMAT") "Classifier")"Classifiers"))








(setq tdms:str-dogovor "*29/Э-13 (918-58-13)*")
(setq tdms:department "КП-00")
(setq tdms:customer "1791")

(load (strcat #lisppath "TDMS/tdmslib.lsp"))
(load (strcat #lisppath "strings/norus.lsp"))



(setq #tdms (vlax-get-or-create-object "TDMS.Application"))

(setq tdms:depContent
       (tdms|child (tdms|child (tdms|child (gp #tdms "Root")
				     (strcat "*" tdms:customer "*")
				     )
			 (strcat "*" tdms:str-dogovor "*")
			 )
	     (strcat "*" tdms:department "*")
	     )
      )

(setq cnt (gp tdms:depContent "Content"))


(setq lst (cont>list cnt))


(tdms-content cnt)

(do (nth 85 lst))

(variantextraction (gp (car lst) "ModifyTime"))

(setq aftlst (member (nth 41 lst) lst))


(setq mine (mapcar 'car (excel>lst)))



(tdms-content aftlst)



(setq ans
       
(mapcar
  '(lambda (o / tmp m r)	;(setq o (nth 85 lst))
     (list
       (tdms|getatt o 2)
       (tdms|getatt o 3)
       (vl-prin1-to-string (gp o "ModifyTime"))
       (apply '+ (mapcar '(lambda (drw) (tdms|getatt drw "ATTR_REPETITIONS")) (cont>list (gp  o "Content"))))
       (if (member (tdms|getatt o 2) mine) "Подолинский" "")
       )
     )
  aftlst)
      )


(lst>excel ans)
