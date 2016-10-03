


;;;;		пересень действующих чертежей
(setq tdms:department "КП-00")


(setq tdms:str-dogovor "010-59-12")
(setq tdms:customer "Лунинец")

;(setq tdms:str-dogovor "020-71-14")
;(setq tdms:customer "Оршанская ТЭЦ")


(load (strcat #lisppath "TDMS/tdmslib.lsp"))
(load (strcat #lisppath "strings/norus.lsp"))



;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(setq #tdms (vlax-get-or-create-object "TDMS.Application"))
;(vlax-put-property #tdms "Visible" :vlax-true)

;(setq tdms:drwDef (gp tdms:objDefs "item" "Чертеж"))
;(setq tdms:docDef (gp tdms:objDefs "item" "Документ"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; выдирание типов ТДМС-файлов
;(setq tdms:fileDefs (gp #tdms "FileDefs"))
;(setq dwgfiledef (gp tdms:fileDefs "item" "FILE_DWG2000"))
;(setq pdffiledef (gp tdms:fileDefs "item" "FILETYPE_PDF"))
;(setq tdms:classformats (gp (gp (gp (gp #tdms "AttributeDefs") "item" "ATTR_FORMAT") "Classifier")"Classifiers"))


(setq tdms:content
       (gp
	 (tdms|child
	     (tdms|child
	       (tdms|child
		 (gp #tdms "Root")
		 (strcat "*" tdms:customer "*")
		 )
	       (strcat "*" tdms:str-dogovor "*")
	       )
	     (strcat "*" tdms:department "*")
	     )
	 "Content")
      )




(setq lst '())	;(setq item (vlax-get-property tdms:content "Item" 3))
(vlax-for item tdms:content (setq lst (cons
					(list
					  (tdms|getatt item 2)
					  (tdms|getatt item 3)
					  (tdms|getatt item 11)
					  ) lst)))
(vlax-release-object tdms:content) (setq tdms:content nil)
(vlax-release-object #tdms) (setq #tdms nil)
(setq lst (reverse lst))


;(lst>excel lst)





(setq bpt (getpoint) cpt bpt)

(setq
  #od|insertparamslist
   '(
     (("object" "TEXT")("dpt" '(30 -4 0))("attch" 10))
     (("object" "MTEXT")("dpt" '(62 -3 0))("attch" 1)("width" 91))
     )
  );spctblparamlist



(load (strcat #lisppath "TEXT & MTEXT\\mtxtlib.lsp"))


(mapcar
  '(lambda (uz / obj kl cl nstr mtlines)

     (setq obj (vla-Addtext #modspace (car uz) (vlax-3d-point '(0 0 0)) 2.5))
     (vla-put-Alignment obj (cadr (assoc "attch" (nth 0 #od|insertparamslist))))
     (vla-put-TextAlignmentPoint obj (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" (nth 0 #od|insertparamslist)))))))

     (setq obj (vla-AddMtext #modspace (vlax-3d-point (mapcar '+ cpt (eval (cadr (assoc "dpt" (nth 1 #od|insertparamslist)))))) (cadr (assoc "width" (nth 1 #od|insertparamslist))) ""))
     (vla-put-TextString obj (cadr uz))
     (vla-put-AttachmentPoint obj (cadr (assoc "attch" (nth 1 #od|insertparamslist))))
     (vla-put-LineSpacingStyle obj acLineSpacingStyleExactly)
     (vla-put-Height obj 2.5)
     (vla-put-LineSpacingDistance obj 8)
     (setq mtlines (mtxt:getnumberoflines obj))
     (setq cpt (mapcar '+ cpt (list 0 (- (* 8 mtlines)) 0)))
     )
  lst
  )